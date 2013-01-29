Analytics.Views.Projects ||= {}
class Analytics.Views.Projects.IndexView extends Backbone.View
  template: JST["backbone/templates/projects/index"]
  events:
    "click .load-more": "load_more"

  initialize: () ->
    _.bindAll this, "render", "redraw"

  render: () ->
    $(@el).html(@template(@collection))
    $(".home").html(@el)
    @render_projects()

  redraw: () ->
    @remove()
    @render()
    @delegateEvents(@events)

  render_projects: () ->
    index = 0
    total = @collection.columns
    for index in [(@collection.page - 1) * @collection.page_size..Math.min(@collection.page * @collection.page_size - 1, @collection.length - 1)]
      project = @collection.models[index]
      column = $(".home .projects").find(".projects-column")[index % total]
      new Analytics.Views.Projects.IndexItemView({
        model: project
        parent_el: column
      }).render()

  load_more: () ->
    @collection.page = @collection.page + 1
    if @collection.page == @collection.max_page
      $(@el).find(".load-more").remove()
    @render_projects()

class Analytics.Views.Projects.IndexItemView extends Backbone.View
  template: JST["backbone/templates/projects/index-item"]
  className: "project well"

  initialize: (options) ->
    @model.view = this
    @parent_el = options.parent_el
    _.bindAll this, "render"

  render: () ->
    $(@el).html(@template(@model.attributes))
    $(@parent_el).append(@el)
    model = @model
    if not model.fetched
      $(@el).block({message: "<strong>" + I18n.t('commons.pending') + "</strong>"})
      @model.fetch({
        success: () ->
          model.fetched = true
          $(model.view.el).unblock()
          model.view.render()
        error: () ->
          $(model.view.el).unblock()
      })