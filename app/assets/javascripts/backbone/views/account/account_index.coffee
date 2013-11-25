Analytics.Views.Account ||= {}
class Analytics.Views.Account.IndexView extends Backbone.View
  template: JST["backbone/templates/account/account_index"]
  el: "#container"

  initialize: ()->
    @current_project = Instances.Collections.UserProjects[0]

  render: ()->
    $(@el).html(@template({current_project:@current_project, projects:Instances.Collections.UserProjects}))

