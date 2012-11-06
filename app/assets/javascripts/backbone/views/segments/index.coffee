Analytics.Views.Segments ||= {}

class Analytics.Views.Segments.IndexView extends Backbone.View
  template: JST['backbone/templates/segments/index']
  events:
    "click a#new-segment" : "new_segment"
    "click a.edit-segment" : "edit_segment"
    "click a.remove-segment" : "remove_segment"


  initialize: () ->
    _.bindAll(this, "render", "redraw")
    @collection.bind "all", @redraw

  render: () ->
    $(@el).html(@template(@collection))
    this

  redraw: () ->
    @delegateEvents(@events)
    @render()

  new_segment: () ->
    segment = new Analytics.Models.Segment()
    segment.collection = @collection
    $(@el).html(new Analytics.Views.Segments.FormView({
      model: segment
      parent: this
    }).render().el)

  edit_segment: (ev) ->
    id = $(ev.currentTarget).attr("value")
    segment = @collection.get(id)
    $(@el).html(new Analytics.Views.Segments.FormView({
      model: segment
      parent: this
    }).render().el)

  remove_segment: (ev) ->
    id = $(ev.currentTarget).attr("value")
    segment = @collection.get(id)
    if confirm(I18n.t('commons.confirm_delete'))
      segment.destroy({wait: true})





