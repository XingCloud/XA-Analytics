class Analytics.Routers.SegmentsRouter extends Backbone.Router
  routes:
    "/segments" : "index"
    "/segments/new" : "new"
    "/segments/:id" : "show"
    "/segments/:id/edit" : "edit"
    "/segments/:id/delete" : "destroy"


  initialize: (options) ->
    @project = options.project
    @segments = new Analytics.Collections.Segments(options.segments)
    if @project?
      @templates = new Analytics.Collections.Segments(options.templates)

