Analytics.Views.Widgets ||= {}

class Analytics.Views.Widgets.IndexView extends Backbone.View
  template: JST['backbone/templates/widgets/index']
  events:
    "click .add-widget" : "add_widget"

  initialize: () ->
    _.bindAll this, "render", "redraw"

  render: () ->
    $(@el).html(@template(@collection))
    $("#main-container").html($(@el))

  redraw: () ->
    @remove()
    @render()
    @delegateEvents(@events)

  add_widget: () ->
    model = new Analytics.Models.Widget({
      project_id: (if @collection.project? then @collection.project.id)
    })
    model.collection = @collection
    new Analytics.Views.Widgets.FormView({
      model: model
    }).render()

class Analytics.Views.Widgets.ListView extends Backbone.View
  template: JST['backbone/templates/widgets/list']
  events:
    "click .add-widget" : "add_widget"
    "click .edit-widget" : "edit_widget"

  initialize: () ->
    _.bindAll this, "render", "redraw"
    @collection.bind "change", @redraw
    @collection.bind "add", @redraw

  render: () ->
    $(@el).html(@template(@collection))
    $("#main-container").html($(@el))

  redraw: () ->
    @remove()
    @render()
    @delegateEvents(@events)

  add_widget: () ->
    model = new Analytics.Models.Widget()
    model.collection = @collection
    new Analytics.Views.Widgets.FormView({
      model: model
    }).render()

  edit_widget: (ev) ->
    id = $(ev.currentTarget).attr("value")
    widget = @collection.get(id)
    new Analytics.Views.Widgets.FormView({
      model: widget
    }).render()