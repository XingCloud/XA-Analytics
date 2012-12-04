class Analytics.Models.User extends Backbone.Model
  initialize:(options) ->
    

  urlRoot: ()->
    if Instances.Models.project?
      "projects"+ Instances.Models.project.id + "/users"