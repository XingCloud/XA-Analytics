Analytics.Views.ProjectUsers ||= {}

class Analytics.Views.ProjectUsers.IndexView extends Backbone.View
  template: JST["backbone/templates/project_users/index"]
  events:
    "click a.btn.edit-project-user": "edit"

  initialize: (options) ->
    _.bindAll this, "render", "redraw"
    @collection.bind "change", @redraw

  redraw: ()->
    @render()
    @delegateEvents(@events)

  render: () ->
    $(@el).html(@template({project_users:@collection.models}))
    this

  edit: (ev)->
    id = $(ev.currentTarget).attr("value")
    model = @collection.get(id)
    new Analytics.View.ProjectUsers.FormView({model:model}).render()