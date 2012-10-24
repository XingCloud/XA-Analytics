class Analytics.Models.Broadcasting extends Backbone.Model
  defaults:
    message: ""

  toJSON: () ->
    {broadcasting: {message: @get("message")}}
