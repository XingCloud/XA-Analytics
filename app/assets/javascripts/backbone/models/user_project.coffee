class Analytics.Models.UserProject extends Backbone.Model
  initialize:(options) ->


  urlRoot: ()->
    if Instances.Models.user?
      "/users/"+ Instances.Models.user.id + "/projects"