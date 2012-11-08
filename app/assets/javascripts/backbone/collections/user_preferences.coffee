class Analytics.Collections.UserPreferences extends Backbone.Collection
  model: Analytics.Models.UserPreference

  initialize: (models, options) ->
    @resource_name = I18n.t("resources.user_preference")

  url: () ->
    "/user_preferences"

  get_preference: (key) ->
    preference = @find((preference) -> preference.get("key") == key)
    if preference?
      preference.get("value")
    else
      null

  set_preference: (key, value, options = {}) ->
    preference = @find((preference) -> preference.get("key") == key)
    update = true
    if not preference?
      preference = new Analytics.Models.UserPreference({key: key, value: value})
      update = false
    preference.save({key: key, value: value}, options)