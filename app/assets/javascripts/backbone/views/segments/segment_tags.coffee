Analytics.Views.Segments ||= {}

class Analytics.Views.Segments.TagsView extends Backbone.View
  template: JST["backbone/templates/segments/segment_tags"]
  events:
    "click .add-segment .tag": "add_segment"
    "click .icon-remove-sign": "remove_segment"


  initialize: (options) ->
    _.bindAll this, "render"
    @parent_view = options.parent_view
    @report_tab_view = options.report_tab_view

  render: () ->
    $(@el).html(@template(@model.show_attributes()))
    $(@parent_view.el).find(".segments-panel").html(@el)

  redraw: () ->
    @remove()
    @render()
    @delegateEvents(@events)

  add_segment: (ev) ->
    id = parseInt($(ev.currentTarget).attr("value"))
    segment = Instances.Collections.segments.get(id)
    segment.selected = true
    @report_tab_view.redraw()

  remove_segment: (ev) ->
    id = parseInt($(ev.currentTarget).attr("value"))
    segment = Instances.Collections.segments.get(id)
    segment.selected = false
    @report_tab_view.redraw()