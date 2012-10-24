class Analytics.Collections.Broadcastings extends Backbone.Collection
  model: Analytics.Models.Broadcasting

  initialize: (models, options) ->
    @resource_name = "公告"
    @fetched = true

  url: () ->
    "/broadcastings"
