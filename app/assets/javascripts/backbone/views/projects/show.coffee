Analytics.Views.Projects ||= {}

class Analytics.Views.Projects.ShowView extends Backbone.View
  template: JST['backbone/templates/projects/show']
  el: "#container"

  initialize: () ->
    _.bindAll(this, "render")
    @model.view = this

  render: () ->
    $(@el).html(@template(@model.attributes))

    new Analytics.Views.Reports.NavView({
      reports : reports_router.templates,
      categories: report_categories_router.templates,
      el: "#templates-nav-list"
    }).render()

    new Analytics.Views.Reports.NavView({
      reports : reports_router.reports,
      categories: report_categories_router.categories,
      el: "#reports-nav-list"
    }).render()

    @render_datepicker()

    if @model.first_report()?
      reports_router.show(@model.first_report().id)
    else
      $(@el).find('#main-container').html(JST['backbone/templates/projects/no-report']())


  render_datepicker: () ->
    el = @el
    $(@el).find('.datepicker-input').datepicker({format: 'yyyy/mm/dd'}).on('changeDate', (ev) ->
      $(el).find('.datepicker-input').datepicker('hide')
      $(el).find('.datepicker-input').blur()
    )