Analytics.Views.Projects ||= {}

class Analytics.Views.Projects.ShowView extends Backbone.View
  template: JST['backbone/templates/projects/show']
  el: "#container"

  events:
    "click td.nav-toggle" : "toggle_left_nav"

  initialize: () ->
    _.bindAll(this, "render")
    @model.view = this

  render: () ->
    $(@el).html(@template(@model.show_attributes()))


    new Analytics.Views.Reports.NavView({
      reports : reports_router.templates,
      categories: report_categories_router.templates,
      el: "#template-reports"
      is_template: true
    }).render()


    new Analytics.Views.Reports.NavView({
      reports : reports_router.reports,
      categories: report_categories_router.categories,
      el: "#custom-reports"
      is_template: false
    }).render()


    if @model.first_report()? and window.location.href.indexOf('#') == -1
      window.location.href = "#/reports/"+@model.first_report().id
    else
      $(@el).find('#main-container').html(JST['backbone/templates/projects/no-report']())


  toggle_left_nav: (ev) ->
    $(@el).find('td.left-nav').toggle()
    if $(ev.currentTarget).hasClass("left-nav-hide")
      @model.active_tab.view.resize_chart(false)
      $(ev.currentTarget).removeClass("left-nav-hide")
    else
      @model.active_tab.view.resize_chart(true)
      $(ev.currentTarget).addClass("left-nav-hide")
