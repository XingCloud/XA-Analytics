class Analytics.Routers.SegmentsRouter extends Backbone.Router
  routes:
    "/segments" : "index"

  initialize: (options) ->
    @project = options.project
    @segments = new Analytics.Collections.Segments(options.segments)
    if @project?
      @templates = new Analytics.Collections.Segments(options.templates)

  index: () ->
    $('#main-container').html(new Analytics.Views.Segments.IndexView({
      collection: @segments
    }).render().el)

  get: (id) ->
    segment = @segments.get(id)
    if not segment?
      segment = @templates.get(id)
    segment

  all: () ->
    if @templates?
      @templates.models.concat(@segments.models)
    else
      @segments.models

