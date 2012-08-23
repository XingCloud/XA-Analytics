class Analytics.Routers.ProjectsRouter extends Backbone.Router
  routes:
    "/404" : "error_404"
    "/settings" : "settings"

  initialize: () ->

  error_404: () ->
    $('#main-container').html(JST['backbone/templates/utils/404']())

  settings: () ->
    view = new Analytics.Views.Projects.SettingsView({model: Instances.Models.project})
    $('#main-container').html(view.render().el)
    $('.nav-report').removeClass('active')
