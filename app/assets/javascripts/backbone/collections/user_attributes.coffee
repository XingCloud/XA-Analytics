class Analytics.Collections.UserAttributes extends Backbone.Collection
  model: Analytics.Models.UserAttribute

  initialize: (options) ->

  url: () ->
    "/projects/" + @project.id + "/user_attributes"