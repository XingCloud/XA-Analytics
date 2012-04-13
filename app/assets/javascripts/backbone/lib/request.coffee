Analytics.Request ||= {}

Analytics.Request.get = (url, params, callback) ->
  $.get(url, params).success((data) ->
    #do something here
    callback(data)
  ).error(() ->
    #do something here
  )

Analytics.Request.post = (url, data, callback) ->
  $.post(url, data).success((rtdata) ->
    #do something here
    callback(rtdata)
  ).error(() ->
    #do something here
  )

Analytics.Request.put = (url, data, callback) ->
  $.ajax({
    type : 'PUT'
    url : url
    data : data
    success : (rtdata) ->
      callback(rtdata)
  })

Analytics.Request.delete = (url, data, callback) ->
  $.ajax({
    type : 'DELETE'
    url : url
    data : data
    success : (rtdata) ->
      callback(rtdata)
  })
