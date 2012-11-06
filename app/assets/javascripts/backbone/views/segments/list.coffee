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
    @report_view = options.parent
    Instances.Collections.segments.bind "all", @redraw

  render: () ->
    $(@el).html(@template())
    for segment in Instances.Collections.segments.select((segment) -> segment.get("project_id")?)
      $(@el).find('#custom-segments').append(new Analytics.Views.Segments.ListItemView({
        model: segment
      }).render().el)
    for segment in Instances.Collections.segments.select((segment) -> not segment.get("project_id")?)
      $(@el).find('#template-segments').append(new Analytics.Views.Segments.ListItemView({
        model: segment
      }).render().el)
    this

  redraw: () ->
    @delegateEvents(@events)
    @render()

  new_segment: () ->
    segment = new Analytics.Models.Segment({project_id: Instances.Models.project.id})
    segment.collection = Instances.Collections.segments
    $(@el).html(new Analytics.Views.Segments.FormView({
      model: segment
      parent: this,
    }).render().el)

  query_segments: () ->
    @report_view.hide_segments()
    Instances.Models.project.active_tab.trigger("change")

  query_segments_cancel: () ->
    @report_view.reset_segments_select()
    @report_view.hide_segments()

  edit_segment: (ev) ->
    id = $(ev.currentTarget).attr("value")
    segment = Instances.Collections.segments.get(id)
    $(@el).html(new Analytics.Views.Segments.FormView({
      model: segment
      parent: this
    }).render().el)

  remove_segment: (ev) ->
    id = $(ev.currentTarget).attr("value")
    segment = Instances.Collections.segments.get(id)
    if confirm(I18n.t('commons.confirm_delete'))
      segment.destroy({wait: true})

class Analytics.Views.Segments.ListItemView extends Backbone.View
  template: JST['backbone/templates/segments/list-item']
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