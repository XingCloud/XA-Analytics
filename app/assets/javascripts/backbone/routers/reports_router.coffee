class Analytics.Routers.ReportsRouter extends Backbone.Router
  initialize: (options) ->
    @reports = new Analytics.Collections.Reports()