class Analytics.Collections.Projects extends Backbone.Collection
  model: Analytics.Models.Project

  initialize: () ->
    @fetched = false
    @columns = 3
    @page_size = 6
    @view = new Analytics.Views.Projects.IndexView({collection: @})
    @view.render()
    @show()

  url: () ->
    "/projects_details"

  show: () ->
    collection = @
    @fetch({
      success: () ->
        collection.fetched = true
        collection.page = 1
        collection.max_page = (if collection.length == 0 then 1 else Math.ceil(collection.length / collection.page_size))
        if collection.page > collection.max_page
          collection.page = collection.max_page
        collection.view.redraw()
    })

  comparator: (project) ->
    if project.get("rank")?
      project.get("rank")
    else
      Number.MAX_VALUE