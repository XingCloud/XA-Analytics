Analytics.Views.Account ||= {}
class Analytics.Views.Account.IndexView extends Backbone.View
  template: JST["backbone/templates/account/account_index"]
  el: "#container"
  events:
    "click li .project-item": "click_project_item"
    "click buuton[type=submit]" : "add_user_to_project"

  initialize: ()->
    @current_project = Instances.Collections.UserProjects[0]

  render: ()->
    $(@el).html(@template({current_project:@current_project, user_projects:Instances.Collections.UserProjects}))


  click_project_item: () ->
    project_id = $(ev.currentTarget).attr("project_id")
    @current_project = _.find(Instances.Collections.UserProjects.models,(x)->x.get("project_id") == parseInt(project_id))

  add_user_to_project: () ->
    email = $("#email").val()
    role =  $("#role").val()

    project_user = new Analytics.Models.ProjectUser({email:email, role:role})
    project_user.save({


    })                                       _

  add_project_to_user: () ->  # create a project and add to this user

    user_project = new Analytics.Models.UserProject()