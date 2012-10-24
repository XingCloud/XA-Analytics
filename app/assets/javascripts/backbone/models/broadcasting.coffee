class Analytics.Models.Broadcasting extends Backbone.Model
  defaults:
    message: ""

  urlRoot: () ->
    "/template/broadcasting"

  toJSON: () ->
    {broadcasting: {message: @get("message")}}
