Analytics.Request ||= {}

Analytics.Request.error_message = false

Analytics.Request.get = (url, params, success, error, hide_loading = false) ->
  Analytics.Request.ajax(url, params, "GET", success, error, hide_loading)

Analytics.Request.post = (url, data, success, error, hide_loading = false) ->
  Analytics.Request.ajax(url, data, "POST", success, error, hide_loading)

Analytics.Request.put = (url, data, success, error, hide_loading = false) ->
  Analytics.Request.ajax(url, data, "PUT", success, error, hide_loading)

Analytics.Request.delete = (url, data, success, error, hide_loading = false) ->
  Analytics.Request.ajax(url, data, "DELETE", success, error, hide_loading)

Analytics.Request.ajax = (url, data, type, success, error, hide_loading = false) ->
  if not hide_loading
    $('#loading-message').fadeIn(200)
  $.ajax({
    type : type
    url : url
    data : data
    success : (rtdata) ->
      if not hide_loading
        $('#loading-message').fadeOut(200)
      success(rtdata)
    error: (xhr, options, err) ->
      if not hide_loading
        $('#loading-message').fadeOut(200)
      error(xhr, options, err)
      Analytics.Request.error(xhr, options, error)
  })

Analytics.Request.error = (xhr, options, error) ->
  if Analytics.Request.error_message
    $('#error-message').remove()
  $('body').prepend(JST['backbone/templates/utils/error']({status: xhr.status}))
  $('#error-message').fadeIn(500)
  Analytics.Request.error_message = true
