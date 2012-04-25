Analytics.Views.Segments ||= {}

class Analytics.Views.Segments.IndexView extends Backbone.View
  template: JST['backbone/templates/segments/index']
  events:
    "click a#new-segment" : "new_segment"
    "click a.edit-segment" : "edit_segment"
    "click a.remove-segment" : "remove_segment"


  initialize: () ->
    _.bindAll(this, "render", "redraw")
    @collection.bind "add", @redraw
    @collection.bind "destroy", @redraw
    @collection.bind "change", @redraw

  render: () ->
    $(@el).html(@template(@collection))
    this

  redraw: () ->
    @delegateEvents(@events)
    @render()

  new_segment: () ->
    $(@el).html(new Analytics.Views.Segments.FormView({
      model: new Analytics.Models.Segment()
      parent: this,
      collection: @collection
    }).render().el)

  edit_segment: (ev) ->
    id = $(ev.currentTarget).attr("value")
    segment = @collection.get(id)
    $(@el).html(new Analytics.Views.Segments.FormView({
      model: segment
      parent: this,
      collection: @segments
    }).render().el)

  remove_segment: (ev) ->
    id = $(ev.currentTarget).attr("value")
    segment = @collection.get(id)
    if confirm("确认删除？")
      segment.destroy({wait: true})





