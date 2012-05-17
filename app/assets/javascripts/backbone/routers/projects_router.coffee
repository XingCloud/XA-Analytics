class Analytics.Routers.ProjectsRouter extends Backbone.Router
  routes:
    "/404" : "error_404"

  initialize: () ->
    @projects = new Analytics.Collections.Projects()

  error_404: () ->
    $('#main-container').html(JST['backbone/templates/utils/404']())
