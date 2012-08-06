class Analytics.Models.UserAttribute extends Backbone.Model
  defaults:
    atype: "sql_string"

  initialize: (options) ->


  urlRoot: () ->
    "/projects/"+@get('project_id')+'/user_attributes'

  toJSON: () ->
    {user_attribute: @attributes}