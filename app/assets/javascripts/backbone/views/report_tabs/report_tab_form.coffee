Analytics.Views.ReportTabs ||= {}

#model Analytics.Models.ReportTab
class Analytics.Views.ReportTabs.FormHeaderView extends Backbone.View
  template: JST["backbone/templates/report_tabs/report_tab_form_header"]
  tagName: "li"
  events:
    "click i.close" : "close"
    "click a span" : 'active'

  initialize: () ->
    _.bindAll(this, "render")

  render: () ->
    attributes = _.clone(@model.attributes)
    attributes.index = @model.index
    $(@el).html(@template(attributes))
    this

  active: () ->
    @report_form.remove_tab_active_class()
    $(@el).addClass('active')
    $(@body.el).addClass('active')

  close: (ev) ->
    if @model.id?
      $(@body.el).find('#report_tabs_attributes_'+@model.index+'__destroy').val(1)
    @report_form.close_tab(@model, this)

#model Analytics.Models.ReportTab
class Analytics.Views.ReportTabs.FormBodyView extends Backbone.View
  template: JST["backbone/templates/report_tabs/report_tab_form_body"]

  events:
    "click button.type-btn" : "change_chart_type"
    "click a#toggle-advanced-options" : "toggle_advanced_options"
    "click button.interval" : "change_interval"
    "change input#compare-checkbox" : "change_compare"
    "change input#show-table-checkbox": "change_show_table"
    "change input#show-summary-checkbox": "change_show_summary"
    "blur #advanced-options input": "validate_date_range"
  initialize: () ->
    _.bindAll this, "render", "validate_date_range"

  render: () ->
    attributes = _.clone(@model.attributes)
    attributes.index = @model.index
    $(@el).html(@template(attributes))
    @render_metrics()
    @render_dimensions()
    this

  render_metrics: () ->
    $(@el).find("#report_tabs_"+@model.index+"_metrics").html(new Analytics.Views.Metrics.FormListView({
      model: {
        index: @model.index # report_tab
        metric_ids: _.clone(@model.get("metric_ids"))
        project_id: @model.get("project_id")
      }
    }).render().el)

  render_dimensions: () ->
    $(@el).find("#report_tabs_"+@model.index+"_dimensions").html(new Analytics.Views.Dimensions.FormListView({
      model: {
        index: @model.index
        dimensions: @model.get("dimensions_attributes")
      }
    }).render().el)

  change_chart_type: (ev) ->
    $(@el).find('button.type-btn').removeClass('active')
    $(ev.currentTarget).addClass('active')
    $('#report_tabs_attributes_'+@model.index+'_chart_type').val($(ev.currentTarget).attr("value"))

  toggle_advanced_options: (ev) ->
    if $(ev.currentTarget).hasClass('active')
      $(ev.currentTarget).removeClass('active')
    else
      $(ev.currentTarget).addClass('active')
    $(@el).find('#advanced-options').toggle()

  change_interval: (ev) ->
    $(@el).find("button.interval").removeClass('active')
    $(ev.currentTarget).addClass('active')
    $('#report_tabs_attributes_'+@model.index+'_interval').val($(ev.currentTarget).attr("value"))
    @validate_date_range()

  change_compare: (ev) ->
    if $(ev.currentTarget)[0].checked
      $('#report_tabs_attributes_'+@model.index+'_compare').val(1)
    else
      $('#report_tabs_attributes_'+@model.index+'_compare').val(0)

  change_show_table: (ev) ->
    if $(ev.currentTarget)[0].checked
      $('#report_tabs_attributes_'+@model.index+'_show_table').val(1)
    else
      $('#report_tabs_attributes_'+@model.index+'_show_table').val(0)

  change_show_summary: (ev) ->
    if $(ev.currentTarget)[0].checked
      $('#report_tabs_attributes_'+@model.index+'_show_summary').val(1)
    else
      $('#report_tabs_attributes_'+@model.index+'_show_summary').val(0)

  validate_date_range: () ->
    @clear_error()
    index = @model.index
    length = parseInt($(@el).find("#report_tabs_attributes_"+index+"_length").val())
    day_offset = parseInt($(@el).find("#report_tabs_attributes_"+index+"_day_offset").val())
    now = new Date()
    #end_time = new Date(now.getFullYear(), now.getMonth(), now.getDate()).getTime()-day_offset*86400000
    end_time = now.getTime()-day_offset*86400000
    interval = $(@el).find("#report_tabs_attributes_"+index+"_interval").val()
    ret = Analytics.Utils.validateDateRange(end_time,length,interval)
    if !ret.result
      switch ret.message
        when "err_future"
          $(@el).find("#report_tabs_attributes_"+index+"_day_offset").addClass("error")
        when "err_days"
          $(@el).find("#report_tabs_attributes_"+index+"_length").addClass("error")
        when "err_points"
          $(@el).find("#report_tabs_attributes_"+index+"_length").addClass("error")
          $(@el).find(".btn.interval.active").addClass("error")
        when "err_today"
          $(@el).find("#report_tabs_attributes_"+index+"_day_offset").addClass("error")
          $(@el).find(".btn.interval.active").addClass("error")
      $(@report_form.el).find("span.error-message").text(I18n.t("templates.report_tabs.show_custom_range.error."+ret.message))
    ret

  clear_error: () ->
    $(@el).find(".error").removeClass("error")
    $(@report_form.el).find("span.error-message").text("")

