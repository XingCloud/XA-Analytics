Analytics.Views.Projects ||= {}

class Analytics.Views.Projects.ShowView extends Backbone.View
  template: JST['backbone/templates/projects/show']
  el: "#container"

  events:
    "click td.nav-toggle" : "toggle_left_nav"
    "click .dashboard-toggle .btn" : "toggle_dashboard"
    "click a.change_language" : "change_language"
    "click a.previous-version" : "degrade"

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
    if @model.first_can_access_report()?
      if Instances.Models.user.is_mgriant()
        Analytics.Utils.redirect("reports/" + @model.first_can_access_report().id)
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
    Analytics.Utils.redirect("dashboard")

  change_language: (ev) ->
    new Analytics.Views.UserPreferences.SetLanguageView().render()

  degrade: (ev) ->
    XA.action("click.banner.degrade")
    identifier = @model.get("identifier")
    setTimeout( () ->
      window.location = "http://p.xingcloud.com/analytics/overview?project_id="+identifier
    , 500)
