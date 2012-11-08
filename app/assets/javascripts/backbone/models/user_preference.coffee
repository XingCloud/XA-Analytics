class Analytics.Models.UserPreference extends Backbone.Model

  urlRoot: () ->
    "/user_preferences"

  toJSON: () ->
    {user_preference: {
      key: @get("key")
      value: @get("value")
    }}