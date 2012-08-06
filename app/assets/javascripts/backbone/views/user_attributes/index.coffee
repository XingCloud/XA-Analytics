Analytics.Views.UserAttributes ||= {}

class Analytics.Views.UserAttributes.IndexView extends Backbone.View
  template: JST["backbone/templates/user_attributes/index"]
  events:
    "click a.btn.add-user-attribute": "add"
    "click a.btn.edit-user-attribute": "edit"
    "click a.btn.remove-user-attribute": "remove"

  initialize: (options) ->
    _.bindAll this, "render", "redraw"
    @collection.bind "change", @redraw
    @collection.bind "add", @redraw
    @collection.bind "destroy", @redraw

  redraw: () ->
    @render()
    @delegateEvents(@events)

  render: () ->
    $(@el).html(@template({user_attributes: @collection.models}))
    this

  add: () ->
    model = new Analytics.Models.UserAttribute({project_id: @collection.project.id})
    new Analytics.Views.UserAttributes.FormView({model: model, collection: @collection}).render()

  edit: (ev) ->
    id = $(ev.currentTarget).attr("value")
    model = @collection.get(id)
    new Analytics.Views.UserAttributes.FormView({model: model}).render()

  remove: (ev) ->
    id = $(ev.currentTarget).attr("value")
    model = @collection.get(id)
    if confirm("确认删除？")
      model.destroy({wait: true})