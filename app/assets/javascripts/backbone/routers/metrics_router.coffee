class Analytics.Routers.MetricsRouter extends Backbone.Router

  initialize: (options) ->
    @project = options.project
    @metrics = new Analytics.Collections.Metrics(options.metrics)
    if @project?
      @templates = new Analytics.Collections.Metrics(options.templates)


