###
定义了Charts的数据同步的行为。
向服务器发请求；如果数据中含有pending，而且本chart是处于激活状态的，则定时重新刷新。
###
class Analytics.Collections.BaseCharts extends Backbone.Collection
  pending_period: 1
  pending_start_time: 0
  initial_start_time: 0
  is_pending: false


  ## for subclasses to override
  initialize: (models, options) ->
    true

  ## for subclasses to override
  initialize_charts: (metric_ids, segment_ids = [0], has_compare = false) ->
    true

  fetch_charts: (options = {}, force = false) ->
    ##if not @is_activated()
      ## @xa_id() + " fetching, but no longer needed"
    ##  return
    # @xa_id() + " fetching charts..."
    collection = this
    start_time = (new Date()).getTime()
    if not @is_pending
      @initial_start_time = start_time
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
      collection.fetch_success(@last_request.resp, 0, false)
      if options.success?
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
      if not @is_pending
        @pending_start_time = (new Date()).getTime()
        @is_pending = true
      @last_request?.success = false
      if collection.timer?
        clearTimeout(collection.timer);
      collection.timer = _.delay(collection.fetch_charts, 2000 * @pending_period)
      @pending_period = @pending_period + 1
    else
      if send_xa
        @xa_pending()
      if collection.timer?
        clearTimeout(collection.timer)
        delete collection.timer
      @last_request?.success = true
      @pending_period = 1
      @is_pending = false

  ##chart的数据是否含有pending状态。
  ##由子类实现。
  has_pendings: () ->
#     @xa_id() + " charts has_pendings false"
    false

  fetch_success: (resp, start_time, send_xa = true) ->

    @last_request.resp = resp
    ##判断resp的状态信息，是否有错误
    if @process_fetched_data(resp)
      contains_error = false
      @trigger "change"
      @check_pendings(send_xa)
    else
      contains_error = true
      @last_request.success = false
      if resp["err_code"]?
        Analytics.Request.doAlertWithErrcode (resp["err_code"])
      else
        Analytics.Request.doAlertWithErrcode("ERR_UNKNOWN") ## contains error but error_code is null, see timelines.process_fetched_data
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
    if collection.timer?
      clearTimeout(collection.timer)
      delete collection.timer
    @pending_period = 1
    @is_pending = false

  xa_action: (start_time, tag) ->
    xa_action = "response." + @project.get("identifier") + "." + @xa_id()
    xa_interval = (new Date()).getTime() - start_time
    XA.action(xa_action + ".responsetime." + Analytics.Utils.timeShard(xa_interval) + "," + xa_interval, xa_action+"."+tag+",0")

  xa_pending: () ->
    xa_action = "response." + @project.get("identifier") + "." + @xa_id()
    end = (new Date()).getTime()
    xa_interval = end - @initial_start_time
    xa_pending_interval = end - @pending_start_time
    if @is_pending
      XA.action(xa_action + ".pend." + Analytics.Utils.timeShard(xa_pending_interval) + "," + xa_pending_interval,
                xa_action + ".show." + Analytics.Utils.timeShard(xa_interval) + "," + xa_interval)
    else
      XA.action(xa_action + ".show." + Analytics.Utils.timeShard(xa_interval) + "," + xa_interval)

  xa_id: () ->
    if @for_widget
      "widget." + @selector.id
    else
      "report." + @selector.get("report_id") + "/" + @selector.id + "/" + @constructor.name

  decorate_num: (num, metric_id)->
    value_type =  Instances.Collections.metrics.get(metric_id).get('value_type')
    result = num
    if not _.contains(["XA-NA", "na", "pending", null], num)
      if "percent" == value_type
        result = (num*100).toFixed(2)+"%"
      else if "rounding" == value_type
        result = Math.floor(num)

    result

  incomplete: (date, metric) ->
    interval = 0;
    switch @selector.get("interval")
      when "day" then interval=0
      when "week" then interval=6
      when "month" then interval=new Date(date.getFullYear(), date.getMonth()+1, 0).getDate()-1
    interval = interval*24*60*60*1000

    number_of_day_origin = metric.get("number_of_day_origin")
    number_of_day = metric.get("number_of_day")

    if number_of_day == null or number_of_day == null
      return false

    current_time = new Date().getTime()
    end_time = date.getTime() + interval - number_of_day*24*60*60*1000
    if current_time < end_time
      return true

    if metric.get("combine_action") != null and metric.get("combine_action") != ""  and  metric.get("combine_attributes") != null
      if @incomplete(date, new Analytics.Models.Metric(metric.get("combine_attributes")))
        return true

    return false


