###
定义了Charts的数据同步的行为。
向服务器发请求；如果数据中含有pending，而且本chart是处于激活状态的，则定时重新刷新。
###
class Analytics.Collections.BaseCharts extends Backbone.Collection
  pending_period: 1
  pending_start_time: 0
  is_pending: false


  ## for subclasses to override
  initialize: (models, options) ->
    true

  ## for subclasses to override
  initialize_charts: (metric_ids, segment_ids = [0], has_compare = false) ->
    true

  fetch_charts: (options = {}, force = false) ->
    if not @is_activated()
      ## @xa_id() + " fetching, but no longer needed"
      return
    # @xa_id() + " fetching charts..."
    collection = this
    start_time = (new Date()).getTime()
    if not @is_pending
      @pending_start_time = start_time
      @is_pending = true
    params = @fetch_params()
    ## @last_request, 对上一次请求的缓存，用来防止同一个页面狂刷的情况
    if (force or @last_request.params != JSON.stringify(params) or
        not @last_request.success or new Date().getTime() - @last_request.time > 300000)
      @last_request.params = JSON.stringify(params)
      @last_request.success = false
      @last_request.time = new Date().getTime()
      Analytics.Request.post({
        url: @fetch_url()
        data: params
        success: (resp) ->
          collection.fetch_success(resp, start_time)
          if options.success?
            options.success(resp)
        error: (xhr, opts, err) ->
          collection.fetch_error(xhr, opts, err, start_time)
          if options.error?
            options.error(xhr, opts, err)
      }, true)
    else
      if options.success?
        collection.fetch_success(@last_request.resp, 0, false)
        options.success(@last_request.resp)

  ##开启后台数据自动更新
  activate: () ->
    Instances.Charts.activate this

  ##是否开启自动更新
  is_activated: () ->
    Instances.Charts.is_activated this

  ##检查所有timeline，看看有没有还在pending的数据。如果有，则定时reload一次：再次fetch_charts
  check_pendings: (send_xa = true) ->
    collection = this
    if @has_pendings()
      @last_request?.success = false
      if collection.timer?
        clearTimeout(collection.timer);
      collection.timer = _.delay(collection.fetch_charts, 2000 * @pending_period)
      @pending_period = @pending_period + 1
    else
      @pending_period = 1
      @is_pending = false
      if send_xa
        @xa_pending(@pending_start_time)
      if collection.timer?
        clearTimeout(collection.timer);
        delete collection.timer

  ##chart的数据是否含有pending状态。
  ##由子类实现。
  has_pendings: () ->
#     @xa_id() + " charts has_pendings false"
    false

  fetch_success: (resp, start_time, send_xa = true) ->
    @last_request.resp = resp
    ##判断resp的状态信息，是否有错误
    if not resp["data"]? or resp["err_code"]?
      @last_request.success = false
      Analytics.Request.doAlertWithErrcode (resp["err_code"])
      contains_error = true
    else
      @last_request.success = true
      contains_error = not @process_fetched_data(resp)
      ##发送 change 事件。让相应的view(TimelinesView, KpisView等) 重绘自己
      @trigger "change"
      @check_pendings(send_xa)
    if send_xa
      @xa_action(start_time, (if contains_error then "error" else "success"))

  ## for subclasses to override
  ## 执行数据成功读取后的解析工作
  process_fetched_data: (resp) ->
    true

  fetch_error: (xhr, opts, err, start_time, send_xa = true) ->
    @last_request.success = false
    if send_xa
      @xa_action(start_time, "error")

  xa_action: (start_time, tag) ->
    xa_action = "response." + Instances.Models.project.get("identifier") + "." + @xa_id()
    xa_interval = (new Date()).getTime() - start_time
    XA.action(xa_action + ".responsetime." + Analytics.Utils.timeShard(xa_interval) + "," + xa_interval, xa_action+"."+tag+",0")

  xa_pending: (start_time) ->
    xa_action = "response." + Instances.Models.project.get("identifier") + "." + @xa_id()
    xa_interval = (new Date()).getTime() - start_time
    XA.action(xa_action + ".pending." + Analytics.Utils.timeShard(xa_interval) + "," + xa_interval)

  xa_id: () ->
    if @for_widget
      "widget." + @selector.id
    else
      "report." + @selector.get("report_id") + "/" + @selector.id + "/" + @constructor.name