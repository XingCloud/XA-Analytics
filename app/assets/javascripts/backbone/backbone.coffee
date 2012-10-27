window.Analytics = {
  Models: {},
  Views: {},
  Routers: {},
  Collections: {},
  Utils: {}
}

window.Instances = {
  ##不属于任何collections的model实例，比如project
  Models: {},
  ##各种集合的实例，比如reports, segments, 等等
  Collections: {},
  Routers: {},

  ##保存当前需要绘制的图表和曲线的数据实例。TimelineCharts, DimensionCharts
  ##以便让不需要的TimelineCharts不再更新自己
  Charts: {
    timelines: [],
    dimensions: [],
    reset: () ->
      console.log "reset charts"
      Instances.Charts.timelines = []
      Instances.Charts.dimensions = []
    activate: (chart) ->
      console.log "activating "+chart.constructor.name
      if chart instanceof Analytics.Collections.TimelineCharts and not (chart in Instances.Charts.timelines)
        Instances.Charts.timelines.push(chart)
      else if chart instanceof Analytics.Collections.DimensionCharts and not (chart in Instances.Charts.dimensions)
        Instances.Charts.dimensions.push(chart)
    is_activated: (chart) ->
      if chart instanceof Analytics.Collections.TimelineCharts
        chart in Instances.Charts.timelines
      else if chart instanceof Analytics.Collections.DimensionCharts
        chart in Instances.Charts.dimensions

  }
}

Backbone.default_sync = Backbone.sync
Backbone.sync = (method, model, options) ->
  $('#loading-message').fadeIn(200)
  request = Backbone.default_sync(method, model, options)
  request.done((resp) -> $('#loading-message').fadeOut(200))
  request.fail((xhr, options, error) ->
    $('#loading-message').fadeOut(200)
    Analytics.Request.error(xhr, options, error)
  )

