Analytics.Request ||= {}

Analytics.Request.error_message = false

Analytics.Request.get = (options, hide_loading = false) ->
  options["type"] = "GET"
  Analytics.Request.ajax(options, hide_loading)

Analytics.Request.post = (options, hide_loading = false) ->
  options["type"] = "POST"
  Analytics.Request.ajax(options, hide_loading)

Analytics.Request.ajax = (options, hide_loading = false) ->
  if not hide_loading
    $('#loading-message').fadeIn(200)
  success = options.success
  options.success = (resp) ->
    if not hide_loading
      $('#loading-message').fadeOut(200)
    if success?
      success(resp)

  error = options.error
  options.error = (xhr, opts, err) ->
    if not hide_loading
      $('#loading-message').fadeOut(200)
    if error?
      error(xhr, opts, err)
    Analytics.Request.error(xhr, opts, err)

  $.ajax(options)

Analytics.Request.error = (xhr, options, error) ->
  Analytics.Request.doAlert("", xhr.status)

Analytics.Request.doAlert = (message = "服务器开小差了，请稍后再试", status = 500, type = "alert-error") ->
  if Analytics.Request.error_message
    $('#error-message').remove()
  params = {}
  if message?
    params.message = message
  if status?
    params.status = status
  if type?
    params.type = type
  $('body').prepend(JST['backbone/templates/utils/error'](params))
  $('#error-message').fadeIn(500)
  Analytics.Request.error_message = true

Analytics.Request.doAlertWithErrcode = (err_code) ->
  codeTable = {
    "ERR_11" : {type: "alert-error", message: "请求参数为空，请联系管理员"},
    "ERR_12751":  {type: "", message: "NumberOfDay和Interval非法。如果指标的定义涉及多天的数据的计算，那么您不能以小于一天（小时或分钟）为间隔来展示这个指标。"},
    "ERR_1275":   {type: "alert-error", message: "参数非法，请联系管理员"},
    "ERR_12":     {type: "alert-error", message: "Json解析错误，请联系管理员"},
    "ERR_20":     {type: "alert-error", message: "开始/结束日期非法，请联系管理员"},
    "ERR_22":     {type: "alert-error", message: "Segment解析和处理过程中发生异常，请联系管理员"},
    "ERR_37":     {type: "alert-error", message: "查询异常，请联系管理员"},
    "ERR_39":     {type: "alert-error", message: "汇总Total和Natural过程中发生异常，请联系管理员"}
  }
  option = codeTable[err_code]
  if not option?
    option = {type: "alert-error", message: "未知错误，请稍候再试"}
  Analytics.Request.doAlert option.message, 500, option.type
