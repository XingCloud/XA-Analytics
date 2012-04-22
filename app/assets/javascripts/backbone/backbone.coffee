Backbone.default_sync = Backbone.sync
Backbone.sync = (method, model, options) ->
  $('#loading-message').fadeIn(200)
  request = Backbone.default_sync(method, model, options)
  request.done((resp) -> $('#loading-message').fadeOut(200))
  request.fail((resp) -> $('#loading-message').fadeOut(200))

