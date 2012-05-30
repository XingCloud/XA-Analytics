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
  if Analytics.Request.error_message
    $('#error-message').remove()
  $('body').prepend(JST['backbone/templates/utils/error']({status: xhr.status}))
  $('#error-message').fadeIn(500)
  Analytics.Request.error_message = true
