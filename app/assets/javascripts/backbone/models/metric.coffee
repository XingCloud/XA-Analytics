class Analytics.Models.Metric extends Backbone.Model

  defaults:
    name: "新建指标"

  urlRoot: () ->
    if @get("project_id")?
      "/projects/"+@get("project_id")+"/metrics"
    else
      "/template/metrics"

  toJSON: () ->
    json = {
      metric: @attributes
    }

  edit: (options) ->
    success = options.success
    if project?
      options.url = "/projects/"+project.id+"/metrics/"+@id
    else
      options.url = @urlRoot()+"/"+@id
    options.success = (resp, status, xhr) ->
      success(resp, status, xhr)

    Backbone.sync("read", this, options)