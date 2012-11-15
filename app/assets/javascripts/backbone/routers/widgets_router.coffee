class Analytics.Routers.WidgetsRouter extends Backbone.Router
  routes:
    "/dashboard" : "index"

  initialize: () ->

  index: () ->
    collection = Instances.Collections.widgets
    if not collection.view?
      if Instances.Models.project?
        $('.nav-report').removeClass("active")
        $('.nav-dashboard li').addClass("active")
        collection.view = new Analytics.Views.Widgets.IndexView({
          collection: collection
        })
      else
        collection.view = new Analytics.Views.Widgets.ListView({
          collection: collection
        })
      collection.view.render()
    else
      if Instances.Models.project?
        $('.nav-report').removeClass("active")
        $('.nav-dashboard li').addClass("active")
      collection.view.redraw()
