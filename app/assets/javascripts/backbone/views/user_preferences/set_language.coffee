Analytics.Views.UserPreferences ||= {}
class Analytics.Views.UserPreferences.SetLanguageView extends Backbone.View
  template: JST["backbone/templates/user_preferences/set_language"]
  className: "modal"
  events:
    "click a.submit": "submit"

  initialize: () ->
    _.bindAll this, "render"

  render: () ->
    $(@el).html(@template())
    $(@el).modal()

  submit: () ->
    language = $(@el).find("select option:selected").attr("value")
    el = @el
    Instances.Collections.user_preferences.set_preference("language", language, {
      wait: true
      success: (model, response, options) ->
        $(el).modal('hide')
        location.reload(true)
      error: (model, xhr, options) ->
        $(el).modal('hide')
    })