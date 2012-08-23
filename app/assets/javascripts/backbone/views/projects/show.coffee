Analytics.Views.Projects ||= {}

class Analytics.Views.Projects.ShowView extends Backbone.View
  template: JST['backbone/templates/projects/show']
  el: "#container"

  events:
    "click td.nav-toggle" : "toggle_left_nav"
    "click .dashboard-toggle .btn" : "toggle_dashboard"

  initialize: () ->
    _.bindAll(this, "render")
    @model.view = this

  render: () ->
    $(@el).html(@template(@model.attributes))
    @render_leftnav()
    @render_default_report()

  render_leftnav: () ->
    new Analytics.Views.Reports.NavView({
      el: "#left-nav"
    }).render()

  render_default_report: () ->
    if @model.first_report()?
      if window.location.href.indexOf('#') == -1
        window.location.href = "#/dashboard"
    else
      $(@el).find('#main-container').html(JST['backbone/templates/projects/no-report']())


  toggle_left_nav: (ev) ->
    $(@el).find('td.left-nav').toggle()
    if $(ev.currentTarget).hasClass("left-nav-hide")
      $(ev.currentTarget).removeClass("left-nav-hide")
    else
      $(ev.currentTarget).addClass("left-nav-hide")
    $('#main-container').trigger("resize")

  toggle_dashboard: (ev) ->
    window.location.href = "#/dashboard"
