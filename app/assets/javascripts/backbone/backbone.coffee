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
      Instances.Charts.timelines = []
      Instances.Charts.dimensions = []
    activate: (chart) ->
      ## "activating "+chart.constructor.name
      if chart instanceof Analytics.Collections.TimelineCharts and not (chart in Instances.Charts.timelines)
        Instances.Charts.timelines.push(chart)
      else if chart instanceof Analytics.Collections.DimensionCharts and not (chart in Instances.Charts.dimensions)
        Instances.Charts.dimensions = [] # current, we only store one dimension object
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

$(document).on "click", "a[href^='/']", (ev) ->
  href = $(ev.currentTarget).attr("href")
  if _gaq?
    _gaq.push(['_trackPageview', href])
  if Analytics.Utils.checkPushState() and href != "/template/projects" and href.indexOf("manage/")==-1 and href!="/users/sign_out" and href.indexOf("?page") == -1
    ev.preventDefault()
    Backbone.history.navigate href.replace(window.ROOT + '/', ''), {trigger: true}

$(document).on "click", "a[href^='#']", (ev) ->
  href = $(ev.currentTarget).attr("href")
  if _gaq?
    _gaq.push(['_trackPageview', window.ROOT + '/' + href.replace("#", '')])
