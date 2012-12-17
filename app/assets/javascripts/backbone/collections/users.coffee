class Analytics.Collections.Users extends Backbone.Collection
  model: Analytics.Models.User

  initialize: (options) ->
    @project = options.project
    
  url:()->
    "/projects/"+@project.id+"/users"