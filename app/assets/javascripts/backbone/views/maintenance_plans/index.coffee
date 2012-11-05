Analytics.Views.MaintenancePlans ||= {}

class Analytics.Views.MaintenancePlans.IndexView extends Backbone.View
  template: JST["backbone/templates/maintenance_plans/index"]
  events:
    "click a#new-maintenance-plan": "new_maintenance_plan"
    "click a.edit-maintenance-plan": "edit_maintenance_plan"
    "click a.remove-maintenance-plan": "remove_maintenance_plan"

  initialize: (options) ->
    _.bindAll this, "render", "redraw"
    @collection.bind "all", @redraw

  render: () ->
    $(@el).html(@template(@collection))

  redraw: () ->
    #@remove()
    @render()
    @delegateEvents()

  new_maintenance_plan: () ->
    new Analytics.Views.MaintenancePlans.FormView({
      model: new Analytics.Models.MaintenancePlan()
    }).render()

  edit_maintenance_plan: (ev) ->
    id = $(ev.currentTarget).attr("value")
    new Analytics.Views.MaintenancePlans.FormView({
      model: Instances.Collections.maintenance_plans.get(id)
    }).render()

  remove_maintenance_plan: (ev) ->
    if confirm("确认删除？")
      id = $(ev.currentTarget).attr("value")
      model = Instances.Collections.maintenance_plans.get(id)
      model.destroy({
        wait: true
      })
