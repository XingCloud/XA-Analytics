Analytics.Views.Projects ||= {}
class Analytics.Views.Projects.IndexView extends Backbone.View
  template: JST["backbone/templates/projects/project_index"]
  events:
    "click .load-more": "load_more"
    "click .project a": "redirect"

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
    for index in [(@collection.page - 1) * @collection.page_size..Math.min(@collection.page * @collection.page_size - 1, @collection.length - 1)]
      project = @collection.models[index]
      new Analytics.Views.Projects.IndexItemView({
        model: project
        parent_el: $(@el).find(".projects")
      }).render()

  load_more: () ->
    @collection.page = @collection.page + 1
    if @collection.page == @collection.max_page
      load_more_el = $(@el).find(".load-more")
      load_more_el.removeClass("load-more")
      load_more_el.addClass("disabled")
      load_more_el.text(I18n.t("templates.projects.index.no_more"))
    @render_projects()

  redirect: (ev) ->
    window.location.href = $(ev.currentTarget).attr("href")

class Analytics.Views.Projects.IndexItemView extends Backbone.View
  template: JST["backbone/templates/projects/project_index_item"]
  tagName: "tr"

  initialize: (options) ->
    @model.view = this
    @parent_el = options.parent_el
    @charts = new Analytics.Collections.ProjectSummaryCharts([], {project: @model, view: this})
    @charts.initialize_charts()
    _.bindAll this, "render", "redraw"

  render: () ->
    $(@el).html(@template({
      name: @model.get("name")
      identifier: @model.get("identifier")
      data: @charts.view_data()
    }))
    $(@parent_el).append(@el)
    @charts.fetch_charts()

  redraw: () ->
    $(@el).html(@template({
      name: @model.get("name")
      identifier: @model.get("identifier")
      data: @charts.view_data()
      no_data: @charts.no_data
    }))