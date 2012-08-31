Analytics.Views.Projects ||= {}

class Analytics.Views.Projects.SettingsView extends Backbone.View
  template: JST["backbone/templates/projects/settings"]

  initialize: (options) ->
    _.bindAll this, "render"
    @user_attributes_view = new Analytics.Views.UserAttributes.IndexView({collection: Instances.Collections.user_attributes})
    @event_levels_view = new Analytics.Views.Settings.EventLevelsFormView({model: Instances.Models.setting})

  render: () ->
    $(@el).html(@template(@model))
    $(@el).find('#user_attributes').html(@user_attributes_view.render().el)
    $(@el).find('#event_levels').html(@event_levels_view.render().el)
    this