class Analytics.Routers.MetricsRouter extends Backbone.Router

  initialize: (project, options) ->
    @project = project
    @metrics = new Analytics.Collections.Metrics(options)


