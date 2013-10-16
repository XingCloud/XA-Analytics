Analytics.Views.Projects ||= {}

class Analytics.Views.Projects.InitView extends Backbone.View
  template: JST['backbone/templates/projects/project_init']
  el: "#container"

  initialize: () ->
    _.bindAll(this, "render")
    @has_errors = false

  render: () ->
    $(@el).html(@template())

  render_init_success: (message, percentage) ->
    if not @has_errors
      $(@el).find(".bar").css({width: parseInt(percentage*100) + "%"})
      $(@el).find(".init-message").html(message + parseInt(percentage*100) + "%")

  render_init_error: () ->
    if not @has_errors
      $(@el).find(".init-message").hide()
      $(@el).find(".error-message").show()
      @has_errors = true