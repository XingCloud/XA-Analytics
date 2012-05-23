class Analytics.Models.ReportTab extends Backbone.Model
  defaults:
    chart_type: 'line'
    interval: 'day'
    length: 7
    compare: 0
    metric_ids: []

  initialize: (options) ->
    now = Analytics.Utils.UTCDate(new Date().getTime())
    compare = Analytics.Utils.UTCDate(new Date().getTime() - @get("length")*86400000)
    @end_time = new Date(now.getFullYear(), now.getMonth(), now.getDate()).getTime()
    @compare_end_time = new Date(compare.getFullYear(), compare.getMonth(), compare.getDate()).getTime()
    @dimensions_filters = []

  urlRoot: () ->
    if @get('project_id')?
      "/projects/"+@get('project_id')+'/reports/'+@get('report_id')+'/report_tabs'
    else
      "/template/reports/"+@get('report_id')+'/report_tabs'

  toJSON: () ->
    {report_tab: @attributes}

  metrics_attributes: () ->
    metrics = []
    for metric_id in @get("metric_ids")
      metrics.push(metrics_router.get(metric_id).attributes)
    metrics

  show_attributes: () ->
    attributes = _.clone(@attributes)
    attributes.end_time = @end_time
    attributes.compare_end_time = @compare_end_time
    attributes.dimensions_filters = @dimensions_filters
    attributes
