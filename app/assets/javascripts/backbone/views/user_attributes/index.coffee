Analytics.Views.UserAttributes ||= {}

class Analytics.Views.UserAttributes.IndexView extends Backbone.View
  template: JST["backbone/templates/user_attributes/index"]
  events:
    "click a.btn.add-user-attribute": "add"
    "click a.btn.edit-user-attribute": "edit"
    "click a.btn.remove-user-attribute": "remove"
    "click li.pre.enabled a" : "pre_page"
    "click li.nex.enabled a" : "nex_page"

  initialize: (options) ->
    _.bindAll this, "render", "redraw"
    @collection.bind "change", @redraw
    @collection.bind "add", @redraw
    @collection.bind "destroy", @redraw
    @page = 1

  redraw: () ->
    @render()
    @delegateEvents(@events)

  render: () ->
    @calc_page()
    $(@el).html(@template({
      user_attributes: @collection.models
      page: @page
      max_page: @max_page
    }))
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
#    if confirm(I18n.t('commons.confirm_delete'))
#      model.destroy({wait: true})
    new Analytics.Views.UserAttributes.RemoveView({model: model}).render()

  pre_page: (ev) ->
    @page = @page - 1
    @redraw()

  nex_page: (ev) ->
    @page = @page + 1
    @redraw()

  calc_page: () ->
    @max_page = (if @collection.length == 0 then 1 else Math.ceil(@collection.length / 10))
    if @page > @max_page
      @page = @max_page