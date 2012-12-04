Analytics.Views.ProjectUsers ||= {}

class Analytics.Views.ProjectUsers.FormView extends Backbone.View
  template: JST["backbone/templates/project_users/form"]
  className: "modal"
  events:
    "click a.btn.submit" : "submit"

  initialize: (options)->
    _.bindAll this, "render"

  render:() ->
    $(@el).html(@template(@model.attributes))

    $(@el).modal()