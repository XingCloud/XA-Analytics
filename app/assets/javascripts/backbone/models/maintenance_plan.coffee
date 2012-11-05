class Analytics.Models.MaintenancePlan extends Backbone.Model
  defaults:
    begin_at: new Date().toString()
    end_at: new Date(new Date().getTime() + 21600000).toString()

  urlRoot: () ->
    "/template/maintenance_plans"

  toJSON: () ->
    {maintenance_plan: @attributes}