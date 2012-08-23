window.Analytics = {
  Models: {},
  Views: {},
  Routers: {},
  Collections: {},
  Utils: {}
}

window.Instances = {
  Models: {},
  Collections: {},
  Routers: {}
}

Backbone.default_sync = Backbone.sync
Backbone.sync = (method, model, options) ->
  $('#loading-message').fadeIn(200)
  request = Backbone.default_sync(method, model, options)
  request.done((resp) -> $('#loading-message').fadeOut(200))
  request.fail((xhr, options, error) ->
    $('#loading-message').fadeOut(200)
    Analytics.Request.error(xhr, options, error)
  )

