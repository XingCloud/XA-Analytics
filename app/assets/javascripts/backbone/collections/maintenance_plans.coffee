class Analytics.Collections.MaintenancePlans extends Backbone.Collection
  defaults:
    keep_running: false
  model: Analytics.Models.MaintenancePlan

  url: () ->
    "/template/maintenance_plans"

  comparator: (maintenance_plan) ->
    0 - Date.parse(maintenance_plan.get("begin_at"))

  current_month_total: () ->
    now = new Date()
    plans = @filter((plan) -> (moment(plan.get("begin_at")).month() == now.getMonth() and
                               moment(plan.get("begin_at")).year() == now.getFullYear()))
    total = 0
    _.each(plans, (plan) ->
      total = total + Date.parse(plan.get("end_at")) - Date.parse(plan.get("begin_at"))
    )
    total