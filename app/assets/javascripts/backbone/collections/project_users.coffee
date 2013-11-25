class Analytics.Collections.ProjectUsers extends Backbone.Collection
  model: Analytics.Models.ProjectUser

  initialize: (models, options) ->
    @resource_name = I18n.t("resources.project_users")
    @project = options.project
    
  url:()->
    "/projects/"+@project.id+"/users"

  comparator: (user) ->
    user.get("username")