class Analytics.Routers.ProjectsRouter extends Backbone.Router
  routes:
    "/404" : "error_404"
    "/settings" : "settings"

  initialize: () ->
    @projects = new Analytics.Collections.Projects()

  error_404: () ->
    $('#main-container').html(JST['backbone/templates/utils/404']())

  settings: () ->
    view = new Analytics.Views.Projects.SettingsView({model: project})
    $('#main-container').html(view.render().el)
    $('.reports-nav ul li').removeClass('active')
