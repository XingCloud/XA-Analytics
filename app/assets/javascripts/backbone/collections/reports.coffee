class Analytics.Collections.Reports extends Backbone.Collection
  model : Analytics.Models.Report

  url: () ->
    if @project?
      "/projects/"+@project.id+"/reports"
    else
      "/template/reports"

  comparator: (report) ->
    if report.get("report_category_id")?
      if report.get("project_id")? or not report_categories_router.templates?
        category = report_categories_router.categories.get(report.get("report_category_id"))
      else
        category = report_categories_router.templates.get(report.get("report_category_id"))
      return category.get("position")
    else
      return 0

  view_options: (categories, is_template) ->
    options = {
      categories: [],
      reports: [],
      project: @project
      is_template: is_template
    }

    for category in categories.models
      category_attributes = _.clone(category.attributes)
      reports = @filter((report) ->
        report.get("report_category_id") == category.id
      )
      category_attributes.reports = (_.clone(report.attributes) for report in reports)
      options.categories.push(category_attributes)

    @each((report) ->
      if not report.get("report_category_id")?
        options.reports.push(_.clone(report.attributes))
    )
    options

  report_tabs: () ->
    report_tabs = []
    @each((report) ->
      category = ""
      if report.get("report_category_id")?
        if report.get("project_id")? or not report_categories_router.templates?
          category = report_categories_router.categories.get(report.get("report_category_id")).get("name")+"/"
        else
          category = report_categories_router.templates.get(report.get("report_category_id")).get("name")+"/"
      for report_tab in report.report_tabs
        title = category + report.get("title") + "/" + report_tab.get("title")
        report_tabs.push({title: title, id: report_tab.id})
    )
    report_tabs

