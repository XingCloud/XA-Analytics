class Analytics.Collections.MaintenancePlans extends Backbone.Collection
  defaults:
    keep_running: false
  model: Analytics.Models.MaintenancePlan

  url: () ->
    "/template/maintenance_plans"