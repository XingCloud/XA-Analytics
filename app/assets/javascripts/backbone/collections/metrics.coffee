class Analytics.Collections.Metrics extends Backbone.Collection
  model: Analytics.Models.Metric

  initialize: (models, options) ->
    @resource_name = "指标"
    if options?
      @project = options.project

  batch_add: (metrics_options) ->
    for metric_options in metrics_options
      @add(new Analytics.Models.Metric(metric_options))

  url: () ->
    if @project?
      "/projects/"+@project.id+"/metrics"
    else
      "/template/metrics"