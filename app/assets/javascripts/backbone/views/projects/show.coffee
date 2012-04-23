Analytics.Views.Projects ||= {}

class Analytics.Views.Projects.ShowView extends Backbone.View
  template: JST['backbone/templates/projects/show']
  el: "#container"

  initialize: () ->
    _.bindAll(this, "render")
    @model.view = this

  render: () ->
    $(@el).html(@template(@model.attributes))
    @render_datepicker()
    new Analytics.Views.Reports.NavView({collection : reports_router.reports}).render()
    if @model.first_report()?
      reports_router.show(@model.first_report().id)


  render_datepicker: () ->
    el = @el
    $(@el).find('.datepicker-input').datepicker({format: 'yyyy/mm/dd'}).on('changeDate', (ev) ->
      $(el).find('.datepicker-input').datepicker('hide')
      $(el).find('.datepicker-input').blur()
    )