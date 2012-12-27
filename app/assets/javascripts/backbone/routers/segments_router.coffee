class Analytics.Routers.SegmentsRouter extends Backbone.Router
  routes:
    "segments" : "index"

  initialize: () ->

  index: () ->
    $('#main-container').html(new Analytics.Views.Segments.IndexView({
      collection: Instances.Collections.segments
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

