class Analytics.Collections.MaintenancePlans extends Backbone.Collection
  model: Analytics.Models.MaintenancePlan

  url: () ->
    "/template/maintenance_plans"