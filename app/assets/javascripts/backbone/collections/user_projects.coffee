class Analytics.Collections.UserProjects extends Backbone.Collection
  model: Analytics.Models.UserProject

  initialize: () ->
    @resource_name = I18n.t("resources.user_projects")
    @fetch({
      success:()->
        new Analytics.Views.Manage.ProjectIndexView().render();
    })

  url:()->
    "/users/"+Instances.Models.user.id+"/projects"

  comparator: (user) ->
    user.get("username")