class Analytics.Routers.ProjectsRouter extends Backbone.Router
  routes:
    "404" : "error_404"
    "settings" : "settings"
    "settings/:active" : "settings_with_active"
    "action_logs": "action_logs"
    "action_logs/:page": "action_logs"
    "ads" : "ads"
    "ads/:active" : "ads_with_active"

  initialize: () ->

  error_404: () ->
    $('#main-container').html(JST['backbone/templates/utils/404']())

  settings: () ->
    @do_settings()

  settings_with_active: (active) ->
    @do_settings(active)

  action_logs: (page = 1) ->
    if Instances.Collections.action_logs.view?
      Instances.Collections.action_logs.view.redraw()
    else
      Instances.Collections.action_logs.view = new Analytics.Views.ActionLogs.IndexView({collection: Instances.Collections.action_logs})
      Instances.Collections.action_logs.view.render()
    $('#main-container').html(Instances.Collections.action_logs.view.el)
    $('.nav-report').removeClass('active')
    Instances.Collections.action_logs.page = parseInt(page)
    Instances.Collections.action_logs.fetch()

  do_settings: (active = null) ->
    if Instances.Models.user.is_mgriant()
      Analytics.Utils.redirect("404")
      return
    view = new Analytics.Views.Projects.SettingsView({
      model: Instances.Models.project
      active: active
    })
    $('#main-container').html(view.render().el)
    $('.nav-report').removeClass('active')

  ads: ()->
    @do_ads()

  ads_with_active: (active) ->
    @do_ads(active)

  do_ads:(active = null) ->
    view = new Analytics.Views.Projects.AdsView({active: active})
    $('#main-container').html(view.render().el)
    $('.nav-report').removeClass('active')