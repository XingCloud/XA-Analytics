class Analytics.Routers.WidgetsRouter extends Backbone.Router
  routes:
    "/dashboard" : "index"

  initialize: (options) ->
    @project = options.project
    @widgets = new Analytics.Collections.Widgets({project: @project})

  index: () ->
    collection = @widgets
    collection.sync_server({
      success: (resp) ->
        if not collection.view?
          if collection.project?
            collection.view = new Analytics.Views.Widgets.IndexView({
              collection: collection
            })
          else
            collection.view = new Analytics.Views.Widgets.ListView({
              collection: collection
            })
          collection.view.render()
        else
          collection.view.redraw()
    })
