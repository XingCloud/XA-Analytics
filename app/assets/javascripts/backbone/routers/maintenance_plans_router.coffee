class Analytics.Routers.MaintenancePlansRouter extends Backbone.Router
  routes:
    "maintenance_plans": "index"
    "maintenance_plans/new": "new"
    "maintenance_plans/:id/edit": "edit"
    "maintenance_plans/:id/destroy": "destroy"

  initialize: () ->

  index: () ->
    if Instances.Collections.maintenance_plans.view?
      Instances.Collections.maintenance_plans.view.redraw()
    else
      Instances.Collections.maintenance_plans.view = new Analytics.Views.MaintenancePlans.IndexView({
        collection: Instances.Collections.maintenance_plans
      })
      Instances.Collections.maintenance_plans.view.render()
    $('#main-container').html(Instances.Collections.maintenance_plans.view.el)

  new: () ->

  edit: () ->

  destroy: () ->
