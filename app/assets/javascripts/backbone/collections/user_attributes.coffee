class Analytics.Collections.UserAttributes extends Backbone.Collection
  model: Analytics.Models.UserAttribute

  initialize: (models, options) ->
    @resource_name = "用户属性"
    if options?
      @project = options.project

  url: () ->
    "/projects/" + @project.id + "/user_attributes"