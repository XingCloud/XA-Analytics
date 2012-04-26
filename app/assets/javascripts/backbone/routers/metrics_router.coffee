class Analytics.Routers.MetricsRouter extends Backbone.Router

  initialize: (options) ->
    @project = options.project
    @metrics = new Analytics.Collections.Metrics(options.metrics)
    if @project?
      @templates = new Analytics.Collections.Metrics(options.templates)

  get: (id) ->
    metric = @metrics.get(id)
    if not metric?
      metric = @templates.get(id)
    metric

