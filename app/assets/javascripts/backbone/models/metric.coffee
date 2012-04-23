class Analytics.Models.Metric extends Backbone.Model
  urlRoot: () ->
    if @get("project_id")?
      "/projects/"+@get("project_id")+"/metrics"
    else
      "/template/metrics"

  toJSON: () ->
    json = {
      metric: @attributes
    }