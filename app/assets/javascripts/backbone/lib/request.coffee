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
    ## maybe user aborted
    if not not xhr.getAllResponseHeaders()
      Analytics.Request.error(xhr, opts, err)
  if options.data?
    options.data["format"] = "json"
  else
    options["data"] = {format: "json"}
  $.ajax(options)

Analytics.Request.error = (xhr, options, error) ->
  Analytics.Request.doAlert("", xhr.status)

Analytics.Request.doAlert = (message = I18n.t("errors.err_default"), status = 500, type = "alert-error") ->
  if Analytics.Request.error_message
    $('#error-message').remove()
  params = {}
  if message? and message != ""
    params.message = message
  else
    params.message = I18n.t("errors.err_default")
  if status?
    params.status = status
  if type?
    params.type = type
  $('body').prepend(JST['backbone/templates/utils/error'](params))
  $('#error-message').fadeIn(500)
  Analytics.Request.error_message = true

Analytics.Request.doAlertWithErrcode = (err_code) ->
  codeTable = {
    "ERR_11" :    {type: "alert-error", message: I18n.t("errors.err_11")},
    "ERR_12751":  {type: "", message: I18n.t("errors.err_12751")},
    "ERR_1275":   {type: "alert-error", message: I18n.t("errors.err_1275")},
    "ERR_12":     {type: "alert-error", message: I18n.t("errors.err_12")},
    "ERR_20":     {type: "alert-error", message: I18n.t("errors.err_20")},
    "ERR_22":     {type: "alert-error", message: I18n.t("errors.err_22")},
    "ERR_37":     {type: "alert-error", message: I18n.t("errors.err_37")},
    "ERR_39":     {type: "alert-error", message: I18n.t("errors.err_39")}
    "ERR_36":     {type: "", message: I18n.t("errors.err_36")}
    "ERR_TIMEOUT":{type: "alert-error", message: I18n.t("errors.err_40")}
  }
  option = codeTable[err_code]
  if not option?
    option = {type: "alert-error", message: I18n.t("errors.err_unknown")}
  Analytics.Request.doAlert option.message, 500, option.type
