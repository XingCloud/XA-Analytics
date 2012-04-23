class Analytics.Models.Report extends Backbone.Model
  active_tab: 0

  initialize: (options) ->
    report_tabs = []
    if options? and options.report_tabs_attributes?
      _.each(options.report_tabs_attributes, (report_tab_attributes) ->
        report_tabs.push(new Analytics.Models.ReportTab(report_tab_attributes))
      )
    @report_tabs = _.clone(report_tabs)

  show_attributes: () ->
    attr = _.clone(@attributes)
    attr.report_tabs_attributes = []
    _.each(@report_tabs, (report_tab) -> attr.report_tabs_attributes.push(report_tab.attributes))
    attr

  parse: (resp) ->
    if resp.report_tabs_attributes?
      for report_tab in @report_tabs
        if not _.find(resp.report_tabs_attributes, (item) -> item.id == report_tab.id)?
          @report_tabs.splice(@report_tabs.indexOf(report_tab), 1)
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
