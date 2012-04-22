class Analytics.Collections.Reports extends Backbone.Collection
  model : Analytics.Models.Report

  initialize: (options, category_options) ->
    for option in options
      @add new Analytics.Models.Report(option)
    @categories = new Analytics.Collections.ReportCategories(category_options)

  url: () ->
    if @project?
      "/projects/"+@project.id+"/reports"
    else
      "/templates/reports"

  view_options: () ->
    options = {
      categories: [],
      reports: [],
      project: @project
    }
    for category in @categories.models
      options.categories.push(category.attributes)
    @each((report) ->
      if not report.get("report_category_id")?
        options.reports.push(report.attributes)
    )
    options

