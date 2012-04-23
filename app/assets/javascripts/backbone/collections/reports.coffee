class Analytics.Collections.Reports extends Backbone.Collection
  model : Analytics.Models.Report

  initialize: (models, options) ->
    @categories = new Analytics.Collections.ReportCategories(options.categories)

  url: () ->
    if @project?
      "/projects/"+@project.id+"/reports"
    else
      "/template/reports"

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

