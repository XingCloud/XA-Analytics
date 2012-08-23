class Analytics.Collections.Reports extends Backbone.Collection
  model : Analytics.Models.Report

  initialize: (models, options) ->
    @resource_name = "报告"
    if options?
      @project = options.project

  url: () ->
    if @project?
      "/projects/"+@project.id+"/reports"
    else
      "/template/reports"

  comparator: (report) ->
    if report.get("original_report_id")?
      report.get("original_report_id")
    else
      report.id

  report_tabs: () ->
    report_tabs = []
    Instances.Collections.report_categories.each((category) ->
      reports = Instances.Collections.reports.select((report) -> report.get("report_category_id") == category.id)
      for report in reports
        for report_tab_attributes in report.get("report_tabs_attributes")
          report_tab = Instances.Collections.report_tabs.get(report_tab_attributes.id)
          report_tabs.push({title: category.get("name") + "/" + report.get("title") + "/" + report_tab.get("title"), id: report_tab.id})
    )
    reports = @select((report) -> not report.get("report_category_id")?)
    for report in reports
      for report_tab_attributes in report.get("report_tabs_attributes")
        report_tab = Instances.Collections.report_tabs.get(report_tab_attributes.id)
        report_tabs.push({title: "未分类" + "/" + report.get("title") + "/" + report_tab.get("title"), id: report_tab.id})
    report_tabs

  view_options: (categories) ->
    options = {
      categories: [],
      reports: [],
      project: @project
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

  init_report_tabs: () ->
    @each((report) ->
      for report_tab_attributes in report.get("report_tabs_attributes")
        report_tab = Instances.Collections.report_tabs.get(report_tab_attributes.id)
        if report_tab?
          report_tab.set(report_tab_attributes)
        else
          Instances.Collections.report_tabs.add(new Analytics.Models.ReportTab(report_tab_attributes))
    )