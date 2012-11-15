class Analytics.Models.ReportTab extends Backbone.Model
  defaults:
    chart_type: 'line'
    interval: 'day'
    length: 7
    compare: 0
    day_offset: 0
    show_table: false
    metric_ids: []

  initialize: (attributes, options) ->
    now = new Date().getTime()
    compare = new Date().getTime() - @get("length")*86400000 - @get("day_offset")*86400000
    @end_time = now - now % 86400000 - @get("day_offset")*86400000
    @compare_end_time = compare - compare % 86400000
    @dimensions = _.clone(@get("dimensions_attributes"))
    @dimension = (if @dimensions? and @dimensions.length > 0 then @dimensions[0])
    @force_fetch = false

  dimensions_filters: () ->
    report = Instances.Collections.reports.get(@get("report_id"))
    report.dimensions_filters

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
      metrics.push(Instances.Collections.metrics.get(metric_id).attributes)
    metrics

  show_attributes: () ->
    _.extend({
      end_time: @end_time
      compare_end_time: @compare_end_time
      dimensions_filters: @dimensions_filters()
      dimensions: @dimensions
      dimension: @dimension
    }, @attributes)

  get_end_time: () ->
    @end_time

  get_compare_end_time: () ->
    @compare_end_time

  get_dimension: () ->
    @dimension

  update_dimensions: () ->
    @dimensions = _.clone(@get("dimensions_attributes"))
    @dimension = (if @dimensions? and @dimensions.length > 0 then @dimensions[0])
