class Analytics.Routers.MetricsRouter extends Backbone.Router
  initialize: () ->
    @metrics = new Analytics.Collections.Metrics()

  add: (tab_index, options) ->
    options['tab_index'] = tab_index
    metric = new Analytics.Models.Metric(options)
    metric_view = new Analytics.Views.Metrics.EditView({model: metric})
    $('#report_tab'+tab_index+'_metric_list').append metric_view.render().el
    @metrics.add metric

  update: (options) ->
    @metrics.updateItem options



