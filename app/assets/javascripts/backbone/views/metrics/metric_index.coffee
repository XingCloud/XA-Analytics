Analytics.Views.Metrics ||= {}

class Analytics.Views.Metrics.IndexDropdownView extends Backbone.View
  template: JST['backbone/templates/metrics/metric_index_dropdown']
  tagName: "ul"
  className: "metrics-dropdown dropdown-menu"
  events:
    "click .metric-new" : "new_metric"
    "click .metric-search input" : "click_search"
    "click .metric-list .metric" : "click_metric"
    "mouseover .metric-list .metric" : "highlight_metric"
    "keyup .metric-search input" : "keyup_toggle"
    "keydown .metric-search input" : "keydown_toggle"

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
    $(@el).parent().removeClass('open')

  click_search : (ev) ->
    ev.stopPropagation()

  click_metric: (ev) ->
    id = parseInt($(ev.currentTarget).attr("value"))
    @list_view.add_metric(id)
    @selected_metric_clear()
    $(@el).parent().removeClass('open')

  highlight_metric: (ev) ->
    $(@el).find(".metric-list .metric").removeClass("selected")
    $(ev.currentTarget).addClass("selected")

  highligh_metric_with_scroll: (metric) ->
    metric.addClass("selected")
    maxHeight = parseInt($(@el).find(".metric-list").css("height"), 10)
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
    if filter? and filter.length > 0
      filter = filter.toLowerCase()
      $(@el).find(".metric-list .metric").each((index, metric) ->
        name = $(metric).attr("name").toLowerCase()
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
      @list_view.add_metric(id)
    @selected_metric_clear()

  keyup_toggle: (ev) ->
    switch ev.keyCode
      when 40 then break
      when 38 then break
      when 13 then break
      else @filter_metric()

  keydown_toggle: (ev) ->
    switch ev.keyCode
      when 40 then @highlight_next_metric()
      when 38 then @highlight_prev_metric()
      when 13 then @select_metric(ev)

class Analytics.Views.Metrics.IndexView extends Backbone.View
  template: JST['backbone/templates/metrics/metric_index']
  events:
    "click a#new-metric" : "new_metric"
    "click a.edit-metric" : "edit_metric"
    "click a.remove-metric" : "remove_metric"
    "click li.pre.enabled a" : "pre_page"
    "click li.nex.enabled a" : "nex_page"

  initialize: () ->
    _.bindAll(this, "render", "redraw")
    @collection.bind "all", @redraw
    @page = 1

  render: () ->
    @calc_page()
    $(@el).html(@template({
      metrics: @collection.filter((metric) -> not Instances.Models.project? or metric.get("project_id")?)
      page: @page
      max_page: @max_page
    }))
    this

  redraw: () ->
    @delegateEvents(@events)
    @render()

  edit_metric:(ev)->
    id = $(ev.currentTarget).attr("value")
    @model = Instances.Collections.metrics.get(id)
    if Instances.Models.project? and not @model.get("project_id")?
      template_model = new Analytics.Models.Metric(@model.attributes)
      Instances.Collections.metrics.remove(@model)  # todo ok to remove?
      Instances.Collections.metrics.add(template_model)
      @model.collection = Instances.Collections.metrics
      @model.set({id: null, project_id: Instances.Models.project.id, name:template_model.get("name")+"_custom"}, {silent: true})
      if @model.get("combine_attributes")?
        @model.get("combine_attributes")["id"] = null
        @model.get("combine_attributes")["project_id"] = Instances.Models.project.id

    @model.set({just_show:true},{slient:true})
    new Analytics.Views.Metrics.FormView({
      model: @model
      clone: template_model
      id: (if @model.id? then "edit_metric_"+@model.id else "clone_metric")
    }).render()

  remove_metirc: ()->
    @model

  pre_page: (ev) ->
    @page = @page - 1
    @redraw()

  nex_page: (ev) ->
    @page = @page + 1
    @redraw()

  calc_page: () ->
    filtered = @collection.filter((metric) -> metric.get("project_id")?)
    @max_page = (if filtered.length == 0 then 1 else Math.ceil(filtered.length / 10))
    if @page > @max_page
      @page = @max_page