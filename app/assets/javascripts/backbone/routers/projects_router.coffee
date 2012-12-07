class Analytics.Routers.ProjectsRouter extends Backbone.Router
  routes:
    "/404" : "error_404"
    "/settings" : "settings"
    "/action_logs": "action_logs"
    "/action_logs/:page": "action_logs"

  initialize: () ->

  error_404: () ->
    $('#main-container').html(JST['backbone/templates/utils/404']())

  settings: () ->
    if Instances.Models.user.is_mgriant()
      window.location.href = "#/404"
      return
    view = new Analytics.Views.Projects.SettingsView({model: Instances.Models.project})
    $('#main-container').html(view.render().el)
    $('.nav-report').removeClass('active')

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
