Analytics.Views.Segments ||= {}
class Analytics.Views.Segments.ListView extends Backbone.View
  template: JST['backbone/templates/segments/list']

  events:
    "click a#new-segment" : "new_segment"
    "click a#query-segments" : "query_segments"
    "click a#query-segments-cancel" : "query_segments_cancel"
    "click a.edit-segment" : "edit_segment"
    "click a.remove-segment" : "remove_segment"

  initialize: (options) ->
    _.bindAll(this, "render", "redraw")
    @segments = options.segments
    @templates = options.templates
    @report_view = options.parent
    @segments.bind "add", @redraw
    @segments.bind "destroy", @redraw
    @segments.bind "change", @redraw

  render: () ->
    $(@el).html(@template())
    for segment in @segments.models
      $(@el).find('#custom-segments').append(new Analytics.Views.Segments.ListItemView({
        model: segment
        collection: @segments
      }).render().el)
    for segment in @templates.models
      $(@el).find('#template-segments').append(new Analytics.Views.Segments.ListItemView({
        model: segment
        collection: @templates
      }).render().el)
    this

  redraw: () ->
    @delegateEvents(this.events)
    @render()

  new_segment: () ->
    $(@el).html(new Analytics.Views.Segments.FormView({
      model: new Analytics.Models.Segment({project_id: project.id})
      parent: this,
      collection: @segments
    }).render().el)

  query_segments: () ->
    @report_view.hide_segments()

  query_segments_cancel: () ->
    @report_view.reset_segments_select()
    @report_view.hide_segments()

  edit_segment: (ev) ->
    id = $(ev.currentTarget).attr("value")
    segment = @segments.get(id)
    if not segment?
      segment = @templates.get(id)
    $(@el).html(new Analytics.Views.Segments.FormView({
      model: segment
      parent: this,
      collection: @segments
    }).render().el)

  remove_segment: (ev) ->
    id = $(ev.currentTarget).attr("value")
    segment = @segments.get(id)
    if not segment?
      segment = @templates.get(id)
    if confirm("确认删除？")
      segment.destroy({wait: true})

class Analytics.Views.Segments.ListItemView extends Backbone.View
  template: JST['backbone/templates/segments/item']
  tagName: 'tr'
  events:
    "change input[type='checkbox']" : "change_select"

  initialize: () ->
    _.bindAll(this, "render")

  render: () ->
    attributes = _.clone(@model.attributes)
    attributes.selected = @model.selected
    $(@el).html(@template(attributes))
    this

  change_select: (ev) ->
    @model.selected = $(ev.currentTarget)[0].checked