class Analytics.Collections.Users extends Backbone.Collection
  model: Analytics.Models.User

  initialize: (options) ->

  url:()->
    "/manage/users"