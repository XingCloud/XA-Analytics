class Analytics.Models.Report extends Backbone.Model
  active_tab: 0

  defaults:
    title: "新建报告"

  initialize: (options) ->
    report_tabs = []
    if options? and options.report_tabs_attributes?
      _.each(options.report_tabs_attributes, (report_tab_attributes) ->
        report_tabs.push(new Analytics.Models.ReportTab(report_tab_attributes))
      )
    @report_tabs = report_tabs

  show_attributes: () ->
    attr = _.clone(@attributes)
    attr.report_tabs_attributes = []
    attr.report_end_time = project.report_end_time
    _.each(@report_tabs, (report_tab) -> attr.report_tabs_attributes.push(report_tab.attributes))
    attr

  parse: (resp) ->
    if resp.report_tabs_attributes?
      delete_report_tab_indexes = []
      for report_tab in @report_tabs
        if not _.find(resp.report_tabs_attributes, (item) -> item.id == report_tab.id)?
          delete_report_tab_indexes.push(@report_tabs.indexOf(report_tab))
      for report_tab_index in @report_tabs
          @report_tabs.splice(report_tab_index, 1)
      for report_tab_attributes in resp.report_tabs_attributes
        report_tab = _.find(@report_tabs, (item) -> item.id == report_tab_attributes.id)
        if report_tab?
          report_tab.set(report_tab_attributes)
        else
          @report_tabs.push(new Analytics.Models.ReportTab(report_tab_attributes))
    resp

  urlRoot: () ->
    if @get('project_id')?
      "/projects/"+@get('project_id')+'/reports'
    else
      "/template/reports"

  toJSON: () ->
    {report: @attributes}

  set_category: (category_id, options) ->
    success = options.success
    options.url = @urlRoot()+'/'+@id+'/set_category?report_category_id='+category_id
    model = this
    collection = @collection
    options.success =  (resp, status, xhr) ->
      model.set(resp)
      collection.trigger "change"
      success(resp, status, xhr)

    Backbone.sync('read', this, options)

  clone: (options) ->
    success = options.success
    options.url = "/projects/"+project.id+'/reports'+'/'+@id+'/clone'
    options.success = (resp, status, xhr) ->
      report = new Analytics.Models.Report(resp)
      reports_router.do_new(report)
      success(resp, status, xhr)

    Backbone.sync('read', this, options)
