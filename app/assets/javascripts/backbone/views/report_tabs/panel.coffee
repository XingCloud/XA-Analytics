Analytics.Views.ReportTabs ||= {}

class Analytics.Views.ReportTabs.PanelView extends Backbone.View
  template: JST["backbone/templates/report_tabs/panel"]
  events:
    "click .refresh-report-tab": "refresh_report_tab"

  initialize: (options) ->
    _.bindAll this, "render", "redraw"
    @model.panel_view = this
    @parent_view = options.parent_view

  render: () ->
    $(@el).html(@template(@model.show_attributes()))
    @render_range_picker()
    @render_dimension_tags()
    @render_segment_tags()
    this

  render_range_picker: () ->
    if not @model.range_picker_view?
      new Analytics.Views.ReportTabs.ShowRangePickerView({
        model: @model
      })
      $(@el).find('.report-tab-range-picker').html(@model.range_picker_view.render().el)
    else
      $(@el).find('.report-tab-range-picker').html(@model.range_picker_view.redraw().el)

  render_dimension_tags: () ->
    if not @dimension_tags_view?
      @dimension_tags_view = new Analytics.Views.Dimensions.TagsView({
        model: @model
        parent_view: this
        report_tab_view: @parent_view
      })
      @dimension_tags_view.render()
    else
      @dimension_tags_view.redraw()

  render_segment_tags: () ->
    if not @segment_tags_view?
      @segment_tags_view = new Analytics.Views.Segments.TagsView({
        model: @model
        parent_view: this
        report_tab_view: @parent_view
      })
      @segment_tags_view.render()
    else
      @segment_tags_view.redraw()

  redraw: () ->
    @remove()
    @render()
    @delegateEvents(@events)
    this

  refresh_report_tab: () ->
    XA.action("click.report.refresh")
    @model.force_fetch = true
    @model.trigger("change")


#model: Analytics.Models.ReportTab
class Analytics.Views.ReportTabs.ShowRangePickerView extends Backbone.View
  template: JST['backbone/templates/report_tabs/show-range-picker']
  events:
    "click li a.default-range" : "change_default_range"
    "change .compare-checkbox" : "change_compare"
    "click li a.custom-range" : "show_custom_range"

  initialize: () ->
    _.bindAll this, "render", "redraw"
    @model.range_picker_view = this

  render: () ->
    $(@el).html(@template(@model.show_attributes()))
    @render_compare_datepicker()
    this

  redraw: () ->
    @remove()
    @render()
    @delegateEvents(@events)
    this

  render_compare_datepicker: () ->
    el = @el
    model = @model
    $(@el).find('.compare-datepicker').datepicker({format: 'yyyy/mm/dd'}).on('changeDate', (ev) ->
      $(el).find('.compare-datepicker').datepicker('hide')
      compare_end_time = Analytics.Utils.pickUTCDate(ev.date.valueOf())
      if model.compare_end_time != compare_end_time
        model.compare_end_time = compare_end_time
        if model.get("compare") == 0
          model.set({compare: 1})
        else
          model.trigger("change")
    )

  change_default_range: (ev) ->
    XA.action("click.report.defaultrange")
    day_offset = $(ev.currentTarget).attr("day_offset")
    now = new Date()
    end_time = Analytics.Utils.pickUTCStart() - day_offset*86400000
    range = {
      length: parseInt($(ev.currentTarget).attr("length"))
      interval: $(ev.currentTarget).attr("interval")
    }
    @model.compare_end_time = @model.compare_end_time + end_time - @model.end_time
    @model.end_time = end_time
    @model.set(range)

  change_compare: (ev) ->
    @model.set({compare: ( if $(ev.currentTarget)[0].checked then 1 else 0)})

  show_custom_range: (ev) ->
    $(@el).find(".dropdown").removeClass("open")
    new Analytics.Views.ReportTabs.CustomRangeView({model: @model}).render()

class Analytics.Views.ReportTabs.CustomRangeView extends Backbone.View
  template: JST["backbone/templates/report_tabs/show-custom-range"]
  className: "modal custom-range"
  events:
    "click a.submit-custom-range" : "check_submit"
    "blur input" : "validate_custom_range"
    "blur select" : "validate_custom_range"

  initialize: () ->
    _.bindAll this, "render"

  render: () ->
    $(@el).html(@template(@model.show_attributes()))
    @render_datepicker()
    @clear_error()
    $(@el).modal()

  render_datepicker: () ->
    el = @el
    $(el).find('.custom-datepicker').datepicker({format: 'yyyy/mm/dd'}).on('changeDate', (ev) ->
      $(el).find('.custom-datepicker').datepicker('hide')
      $(el).find('.end-time').val(Analytics.Utils.pickUTCDate(ev.date.valueOf()))
    )

  clear_error: () ->
    $(@el).find(".error").removeClass("error")
    $(@el).find("span.error-message").text("")

  check_submit: (ev) ->
    if @validate_custom_range()
      @change_custom_range()

  change_custom_range: (ev) ->
    XA.action("click.report.customrange")
    range = {
      length: parseInt($(@el).find('.length-input').val())
      interval: $(@el).find('.interval-select option:selected').attr("value")
    }
    end_time = parseInt($(@el).find('.end-time').val())
    change = (@model.end_time != end_time or @model.get("length") != range.length or @model.get("interval") != range.interval)
    $(@el).modal('hide')
    @model.compare_end_time = @model.compare_end_time + end_time - @model.end_time
    @model.end_time = end_time
    @model.set(range, {silent: true})
    if change
      @model.trigger("change")

  # 检查选择的range是否合法。
  validate_custom_range: (ev) ->
    @clear_error()
    length = parseInt($(@el).find('.length-input').val())
    interval = $(@el).find('.interval-select option:selected').attr("value")
    end_time = parseInt($(@el).find('.end-time').val())
    ret = Analytics.Utils.validateDateRange(end_time, length, interval)
    if not ret.result
      $(@el).find("span.error-message").text(I18n.t("templates.report_tabs.show_custom_range.error."+ret.message))
      switch ret.message
        when "err_future"
          $(@el).find("input.custom-datepicker").addClass("error")
        when "err_days"
          $(@el).find("input.length-input").addClass("error")
        when "err_points"
          $(@el).find("input.length-input").addClass("error")
          $(@el).find("select.interval-select").addClass("error")
        when "err_today"
          $(@el).find("input.custom-datepicker").addClass("error")
          $(@el).find("select.interval-select").addClass("error")
      return false
    else
      return true
