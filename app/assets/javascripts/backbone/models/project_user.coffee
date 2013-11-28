class Analytics.Models.ProjectUser extends Backbone.Model
  idAttribute: 'user_id'
  initialize:(options) ->
    @project_id = options.project_id

  urlRoot: ()->
    if Instances.Models.project?
      "/projects/" + Instances.Models.project.id + "/users"
    else
      "/projects/" + @project_id + "/users"