class Analytics.Models.ProjectUser extends Backbone.Model
  initialize:(options) ->
    

  urlRoot: ()->
    if Instances.Models.project?
      "projects"+ Instances.Models.project.id + "/project_users"