class Analytics.Collections.ProjectUsers extends Backbone.Collection
  model: Analytics.Models.ProjectUser

  initialize: (options) ->
    @project = options.project
    
  url:()->
    "/projects/"+@project.id+"/project_users"