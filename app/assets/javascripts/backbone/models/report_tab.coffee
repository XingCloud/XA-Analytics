class Analytics.Models.ReportTab extends Backbone.Model

  headerView: null
  bodyView: null
  metricsView: null
  metrics: null

  initialize: (options) ->
    @metrics = new Analytics.Collections.Metrics()
    for metric_options in options['metrics']
      metric_options['tab_index'] = options['index']
      @metrics.add(new Analytics.Models.Metric(metric_options))
    delete options['metrics']
    @set options

  add_metric_url: (tab_index) ->
    if not @get("project_id")?
      "/admin/template_metrics/new?tab_index="+tab_index
    else
      "/projects/"+@get("project_id")+"/metrics/new?tab_index="+tab_index
