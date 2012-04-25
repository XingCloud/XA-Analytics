Analytics.Request ||= {}

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
    error: (rtdata) ->
      $('#loading-message').fadeOut(200)
  })