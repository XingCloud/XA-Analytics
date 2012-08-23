Analytics.Views.Metrics ||= {}

class Analytics.Views.Metrics.IndexDropdownView extends Backbone.View
  template: JST['backbone/templates/metrics/index-dropdown']
  tagName: "ul"
  className: "metrics-dropdown dropdown-menu"
  events:
    "click .metric-new" : "new_metric"
    "click .metric-search input" : "click_search"
    "click .metric-list .metric" : "click_metric"
    "mouseover .metric-list .metric" : "highlight_metric"
    "keyup .metric-search input" : "keyup_toggle"

  initialize: (options) ->
    _.bindAll(this, "render")
    @list_view = options.list_view
    @disable_add_metric = (if options.disable_add_metric? then options.disable_add_metric else false)
    @height = (if options.height? then options.height else 200)
    Instances.Collections.metrics.bind "change", @render
    Instances.Collections.metrics.bind "add", @render

  render: () ->
    $(@el).html(@template({
      disable_add_metric: @disable_add_metric
      height: @height
    }))

  new_metric: (ev) ->
    if Instances.Models.project?
      metric = new Analytics.Models.Metric({project_id : Instances.Models.project.id})
    else
      metric = new Analytics.Models.Metric()
    metric.list_view = @list_view
    metric.collection = Instances.Collections.metrics
    new Analytics.Views.Metrics.FormView({
      model: metric,
      id: "new_metric"
    }).render()

  click_search : (ev) ->
    ev.stopPropagation()

  click_metric: (ev) ->
    id = parseInt($(ev.currentTarget).attr("value"))
    @list_view.render_metric(id)
    @selected_metric_clear()

  highlight_metric: (ev) ->
    $(@el).find(".metric-list .metric").removeClass("selected")
    $(ev.currentTarget).addClass("selected")

  highligh_metric_with_scroll: (metric) ->
    metric.addClass("selected")
    maxHeight = parseInt($(@el).find(".metric-list").css("maxHeight"), 10)
    visible_top = $(@el).find(".metric-list").scrollTop()
    visible_bottom = maxHeight + visible_top
    high_top = metric.position().top + visible_top
    high_bottom = high_top + metric.outerHeight()
    if high_bottom >= visible_bottom
      $(@el).find(".metric-list").scrollTop((if high_bottom > maxHeight then high_bottom - maxHeight else 0))
    else if high_top < visible_top
      $(@el).find(".metric-list").scrollTop(high_top)

  highlight_first_metric: () ->
    $(@el).find(".metric-list .metric").removeClass("selected")
    new_selected_metric = $(@el).find(".metric-list .metric").not(".hide").first()
    if new_selected_metric.length > 0
      @highligh_metric_with_scroll(new_selected_metric)

  highlight_next_metric: () ->
    all_display_metrics = $(@el).find(".metric-list .metric").not(".hide")
    selected_metric = $(@el).find(".metric-list .metric.selected")
    new_selected_metric = all_display_metrics.first()
    if selected_metric.length > 0
      selected_metric.removeClass("selected")
      index = all_display_metrics.index(selected_metric)
      if index != all_display_metrics.length - 1
        new_selected_metric = $(all_display_metrics.get(index + 1))
    @highligh_metric_with_scroll(new_selected_metric)

  highlight_prev_metric: () ->
    all_display_metrics = $(@el).find(".metric-list .metric").not(".hide")
    selected_metric = $(@el).find(".metric-list .metric.selected")
    new_selected_metric = all_display_metrics.first()
    if selected_metric.length > 0
      selected_metric.removeClass("selected")
      index = all_display_metrics.index(selected_metric)
      if index != 0
        new_selected_metric = $(all_display_metrics.get(index - 1))
      else
        new_selected_metric = all_display_metrics.last()
    @highligh_metric_with_scroll(new_selected_metric)

  filter_metric: () ->
    filter = $(@el).find(".metric-search input").val()
    if filter?
      $(@el).find(".metric-list .metric").each((index, metric) ->
        name = $(metric).attr("name")
        if name.indexOf(filter) == -1 and not $(metric).hasClass('hide')
          $(metric).addClass("hide")
        else if name.indexOf(filter) != -1 and $(metric).hasClass('hide')
          $(metric).removeClass("hide")
      )
    else
      $(@el).find(".metric-list .metric").removeClass("hide")
    @highlight_first_metric()

  selected_metric_clear: () ->
    $(@el).find(".metric-search input").val(null)
    $(@el).find(".metric-list .metric").removeClass("hide")
    $(@el).find(".metric-list .metric").removeClass("selected")

  select_metric: (ev) ->
    selected_metric = $(@el).find(".metric-list .metric.selected")
    if selected_metric.length > 0
      id = parseInt(selected_metric.attr("value"))
      @list_view.render_metric(id)
    @selected_metric_clear()

  keyup_toggle: (ev) ->
    switch ev.keyCode
      when 40 then @highlight_next_metric()
      when 38 then @highlight_prev_metric()
      when 13 then @select_metric(ev)
      else @filter_metric()

