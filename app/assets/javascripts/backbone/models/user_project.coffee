class Analytics.Models.UserProject extends Backbone.Model
  idAttribute: 'project_id'
  initialize:(options) ->


  urlRoot: ()->
    if Instances.Models.user?
      "/users/"+ Instances.Models.user.id + "/projects"