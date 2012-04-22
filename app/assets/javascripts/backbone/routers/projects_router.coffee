class Analytics.Routers.ProjectsRouter extends Backbone.Router
  initialize: () ->
    @projects = new Analytics.Collections.Projects()
