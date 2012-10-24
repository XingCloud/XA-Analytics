class Analytics.Routers.BroadcastingRouter extends Backbone.Router
  routes:
    "/broadcasting" : "index"

  initialize: () ->

  index: () ->
    collection = Instances.Collections.broadcastings
    if not collection.view?
      collection.view = new Analytics.Views.Broadcastings.IndexView({
      model: collection.first()
      })
      collection.view.render()
    else
      collection.view.redraw()
