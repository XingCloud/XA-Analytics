class Analytics.Models.ReportTab extends Backbone.Model
  defaults:
    chart_type: 'line'
    interval: 'day'
    length: 7
    compare: 0
    day_offset: 1
    show_table: false
    metric_ids: []

  initialize: (attributes, options) ->
    @end_time = Analytics.Utils.pickUTCStart() - @get("day_offset")*86400000
    @compare_end_time = Analytics.Utils.pickUTCStart() - @get("length")*86400000 - @get("day_offset")*86400000
    @dimensions = _.clone(@get("dimensions_attributes"))
    @dimension = (if @dimensions? and @dimensions.length > 0 then @dimensions[0])
    _dimension = @dimension
    if _dimension?
      @dimension.filter = {
        dimension: {
          dimension_type: _dimension.dimension_type
          name: Analytics.Static.getDimensionName(_dimension.value)
          value: _dimension.value
          value_type: _dimension.value_type
        }
        value: "all-dimensions"
        keys: []
      }
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
    @update_dimension()
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

  update_dimension: () ->
    remain_dimension = false
    for dimension in @dimensions
      filter_exist = @find_filter(dimension)
      if not filter_exist?
        remain_dimension = true # we change the only dimension to a specific dimension value, now we only have filter.

        if dimension == @dimension
          break

        @dimension = dimension
        _dimension = dimension
        dimension.filter = {
          dimension: {
            dimension_type: _dimension.dimension_type
            name: Analytics.Static.getDimensionName(_dimension.value)
            value: _dimension.value
            value_type: _dimension.value_type
          }
          value: "all-dimensions"
          keys: []
        }
        break

    if not remain_dimension
      @dimension = null;

  find_filter: (dimension) ->
    if not dimension?
      return null
    _.find(@dimensions_filters(), (item) ->
      item.dimension.dimension_type == dimension.dimension_type and item.dimension.value == dimension.value
    )
