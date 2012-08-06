Analytics.Views.Projects ||= {}

class Analytics.Views.Projects.SettingsView extends Backbone.View
  template: JST["backbone/templates/projects/settings"]

  initialize: (options) ->
    _.bindAll this, "render"
    @user_attributes_view = new Analytics.Views.UserAttributes.IndexView({collection: user_attributes_router.user_attributes})

  render: () ->
    $(@el).html(@template(@model))
    $(@el).find('#user_attributes').html(@user_attributes_view.render().el)
    this