class Analytics.Models.Report extends Backbone.Model
  active_tab: 0

  initialize: (options) ->
    @report_tab_index = 0
    if not @get("report_tabs_attributes")?
      @set({report_tabs_attributes: []})

  show_attributes: () ->
    attr = _.clone(@attributes)
    attr.report_tab_index = @report_tab_index
    attr

  parse: (resp) ->
    if resp.report_tabs_attributes?
      for report_tab_attributes in resp.report_tabs_attributes
        report_tab = Instances.Collections.report_tabs.get(report_tab_attributes.id)
        if report_tab?
          report_tab.set(report_tab_attributes)
        else
          Instances.Collections.report_tabs.add(new Analytics.Models.ReportTab(report_tab_attributes))
    resp

  urlRoot: () ->
    if Instances.Models.project?
      "/projects/" + Instances.Models.project.id + '/reports'
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