Analytics.Views.Projects ||= {}

class Analytics.Views.Projects.SettingsView extends Backbone.View
  template: JST["backbone/templates/projects/settings"]

  initialize: (options) ->
    _.bindAll this, "render"
    @user_attributes_view = new Analytics.Views.UserAttributes.IndexView({collection: Instances.Collections.user_attributes})
    @event_levels_view = new Analytics.Views.Settings.EventLevelsFormView({model: Instances.Models.setting})
    @project_users_view = new Analytics.Views.ProjectUsers.IndexView({collection: Instances.Collections.project_users})
    @segments_view = new Analytics.Views.Segments.IndexView({collection: Instances.Collections.segments})
    @metrics_view = new Analytics.Views.Metrics.IndexView({collection: Instances.Collections.metrics})
    @active = options.active
  
  render: () ->
    $(@el).html(@template({
      active: @active
    }))
    $(@el).find('#user_attributes').html(@user_attributes_view.render().el)
    $(@el).find('#event_levels').html(@event_levels_view.render().el)
    $(@el).find('#project_users').html(@project_users_view.render().el)
    $(@el).find('#segments_management').html(@segments_view.render().el)
    $(@el).find('#metrics_management').html(@metrics_view.render().el)
    this