class Analytics.Models.User extends Backbone.Model
  initialize:(options) ->
    
  set_project_user: () ->
    id = @id
    @project_user = _.find(Instances.Collections.project_users.models, (model) -> model.get("user_id") == id) || new Analytics.Models.ProjectUser({role:"normal",privilege:{report_ids:[]}})

  urlRoot: ()->
    if Instances.Models.project?
      "projects"+ Instances.Models.project.id + "/users"

  is_mgriant: () ->
    (not (@get("role")=="admin")) && @project_user.get("role") == "mgriant" #project_user不存在说明是管理员

  can_access_report: (report_id) ->
    @get("role")=="admin" || @project_user.get("role") == "normal" || _.contains(@project_user.get("privilege").report_ids, report_id)