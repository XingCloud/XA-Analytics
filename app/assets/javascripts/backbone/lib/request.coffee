Analytics.Request ||= {}

Analytics.Request.error_message = false

Analytics.Request.get = (url, params, callback) ->
  Analytics.Request.ajax(url, params, "GET", callback)

Analytics.Request.post = (url, data, callback) ->
  Analytics.Request.ajax(url, data, "POST", callback)

Analytics.Request.put = (url, data, callback) ->
  Analytics.Request.ajax(url, data, "PUT", callback)

Analytics.Request.delete = (url, data, callback) ->
  Analytics.Request.ajax(url, data, "DELETE", callback)

Analytics.Request.ajax = (url, data, type, success) ->
  $('#loading-message').fadeIn(200)
  $.ajax({
    type : type
    url : url
    data : data
    success : (rtdata) ->
      $('#loading-message').fadeOut(200)
      success(rtdata)
    error: (xhr, options, error) ->
      $('#loading-message').fadeOut(200)
      Analytics.Request.error(xhr, options, error)
  })

Analytics.Request.error = (xhr, options, error) ->
  if Analytics.Request.error_message
    $('#error-message').remove()
  $('body').prepend(JST['backbone/templates/utils/error']({status: xhr.status}))
  $('#error-message').fadeIn(500)
  Analytics.Request.error_message = true
