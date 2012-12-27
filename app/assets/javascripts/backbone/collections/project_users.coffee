class Analytics.Collections.ProjectUsers extends Backbone.Collection
  model: Analytics.Models.ProjectUser

  initialize: (options) ->
    @resource_name = I18n.t("resources.project_users")
    @project = options.project
    
  url:()->
    "/projects/"+@project.id+"/project_users"