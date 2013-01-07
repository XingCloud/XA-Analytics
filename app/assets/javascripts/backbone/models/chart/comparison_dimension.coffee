class Analytics.Models.ComparisonDimensionChart extends Backbone.Model
  initialize: (options) ->
    @set({sequence: {
      total: null
      natural: null
    }})

  fetch_params: () ->
    end_time = @report_tab.compare_end_time
    start_time = end_time - (@report_tab.get("length") - 1) * 86400000
    metric = Instances.Collections.metrics.get(@get("metric_id"))
    metric_options = metric.sequence_options(@get("segment_id"), @build_filters(@get("dimension_result")))
    _.extend(metric_options, {
      id: @id
      end_time: Analytics.Utils.formatUTCDate(end_time, "YYYY-MM-DD")
      start_time: Analytics.Utils.formatUTCDate(start_time, "YYYY-MM-DD")
      interval: @report_tab.get("interval").toUpperCase()
      type: "COMMON"
      project_id: Instances.Models.project.get("identifier")
    })


  build_filters: (dimension_result) ->
    filters = @report_tab.dimensions_filters()
    dimension = @report_tab.dimension
    filter = {
      dimension: {
        dimension_type: dimension.dimension_type
        name: Analytics.Static.getDimensionName(dimension.value)
        value: dimension.value
        value_type: dimension.value_type
      }
      value: dimension_result
    }
    cloned_filters = _.clone(filters)
    oldfilter =  _.find(filters, (item) ->
      item.dimension.dimension_type == filter.dimension.dimension_type and item.dimension.value == filter.dimension.value
    )
    if not oldfilter? and dimension_result != "XA-NA"
      cloned_filters.push(filter)
    cloned_filters