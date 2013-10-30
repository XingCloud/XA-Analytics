Analytics.Views.Segments ||= {}

class Analytics.Views.Segments.IndexView extends Backbone.View
  template: JST['backbone/templates/segments/segment_index']
  events:
    "click a#new-segment" : "new_segment"
    "click a.edit-segment" : "edit_segment"
    "click a.remove-segment" : "remove_segment"
    "click li.pre.enabled a" : "pre_page"
    "click li.nex.enabled a" : "nex_page"

  initialize: () ->
    _.bindAll(this, "render", "redraw")
    @collection.bind "all", @redraw
    @page = 1

  render: () ->
    @calc_page()
    $(@el).html(@template({
      segments: @collection.filter((segment) -> not Instances.Models.project? or segment.get("project_id")?)
      page: @page
      max_page: @max_page
    }))
    this

  redraw: () ->
    @delegateEvents(@events)
    @render()

  new_segment: () ->
    segment = new Analytics.Models.Segment({project_id: if Instances.Models.project then Instances.Models.project.id else null})
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

  pre_page: (ev) ->
    @page = @page - 1
    @redraw()

  nex_page: (ev) ->
    @page = @page + 1
    @redraw()

  calc_page: () ->
    filtered = @collection.filter((segment) -> segment.get("project_id")?)
    @max_page = (if filtered.length == 0 then 1 else Math.ceil(filtered.length / 100))
    if @page > @max_page
      @page = @max_page





