Analytics.Views.Widgets ||= {}

###
普通项目的dashboard。
collection: Instances.Collections.widgets
###
class Analytics.Views.Widgets.IndexView extends Backbone.View
  template: JST['backbone/templates/widgets/widget_index']
  events:
    "click .add-widget" : "new_widget"
    "click .refresh-widgets" : "refresh_widgets"

  initialize: () ->
    _.bindAll this, "render", "redraw", "add_widget"
    @collection.bind "add", @add_widget

  render: () ->
    $(@el).html(@template(@collection))
    $("#main-container").html($(@el))
    #@render_datepicker()
    @render_widgets()
    @render_sortable()

  ###
  render_datepicker: () ->
    el = @el
    collection = @collection
    view = this
    $(el).find(".widget-range").datepicker().on('changeDate', (ev) ->
      $(el).find('.widget-range').datepicker('hide')
      collection.end_time = Analytics.Utils.pickUTCDate(ev.date.valueOf())
      XA.action("click.dashboard.calendar")
      view.redraw()
    )
  ###

  render_widgets: () ->
    Instances.Charts.reset()
    index = 0
    add_widget = @add_widget
    @collection.check_position(@collection.columns)
    @collection.each((widget) ->
      add_widget(widget, this)
      index = index + 1
    )

  render_sortable: () ->
    collection = @collection
    $(@el).find(".widgets").sortable({
      connectWith: ".widgets"
      handle: ".widget-title"
      placeholder: "widget-placeholder"
      forcePlaceholderSize: true
      revert: 300
      delay: 100
      opacity: 0.8
      containment: $(@el)
      stop: (event, ui) ->
        parent = $(ui.item).parent()
        widgets = parent.find(".widget")
        widget_id = $(ui.item).find(".widget-title").attr("widget-id")
        px = parseInt(parent.attr("column"))
        prev_widgets = $(ui.item).prevUntil()
        prev_widget_ids = ($(prev_widget).find(".widget-title").attr("widget-id") for prev_widget in prev_widgets)
        next_widget_id = $(ui.item).next().find(".widget-title").attr("widget-id")
        collection.update_position(widget_id, px, next_widget_id, prev_widget_ids)
    })

  redraw: () ->
    @remove()
    @render()
    @delegateEvents(@events)

  new_widget: () ->
    model = new Analytics.Models.Widget({
      project_id: (if @collection.project? then @collection.project.id)
      project_widget:
        px: 0
        py: @collection.position_y(0)
    })
    model.collection = @collection
    new Analytics.Views.Widgets.FormView({
      model: model
    }).render()


  add_widget: (widget, collection) ->
    widgets_column = $(@el).find(".widgets")[widget.get("project_widget").px % @collection.columns]
    if not widget.view?
      new Analytics.Views.Widgets.ShowView({model: widget, parent_el: widgets_column}).render()
    else
      widget.view.redraw({parent_el: widgets_column})

  refresh_widgets: () ->
    @collection.each((widget) ->
      widget.view.fetch_chart(true)
    )

###
管理员视图，dashboard面板管理。
collection: Instances.Collections.widgets
###
class Analytics.Views.Widgets.ListView extends Backbone.View
  template: JST['backbone/templates/widgets/widget_list']
  events:
    "click .add-widget" : "new_widget"
    "click .edit-widget" : "edit_widget"

  initialize: () ->
    _.bindAll this, "render", "redraw"
    @collection.bind "change", @redraw
    @collection.bind "add", @redraw
    @collection.bind "destroy", @redraw

  render: () ->
    $(@el).html(@template(@collection))
    $("#main-container").html($(@el))

  redraw: () ->
    @remove()
    @render()
    @delegateEvents(@events)

  new_widget: () ->
    model = new Analytics.Models.Widget()
    model.collection = @collection
    new Analytics.Views.Widgets.FormView({
      model: model
    }).render()

  edit_widget: (ev) ->
    id = $(ev.currentTarget).attr("value")
    widget = @collection.get(id)
    new Analytics.Views.Widgets.FormView({
      model: widget
    }).render()