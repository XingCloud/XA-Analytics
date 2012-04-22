Analytics.Views.Reports ||= {}

class Analytics.Views.Reports.ShowView extends Backbone.View
  template: JST['backbone/templates/reports/show']

  initialize: () ->
    _.bindAll(this, "render")
    @model.view = this

  render: () ->
    $(@el).html(@template(@model.show_attributes()))
    $('#main-container').html($(@el))
    if @model.report_tabs.length
      report_tab = @model.report_tabs[0]
      @model.active_tab = report_tab.id
      if report_tab.view?
        report_tab.view.remove()
      new Analytics.Views.ReportTabs.ShowView({
        model: report_tab,
        id : 'report_tab_'+report_tab.id
      })
      report_tab.view.report_view = this
      report_tab.view.render()