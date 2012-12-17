Analytics.Views.ReportTabs ||= {}

#model: Analytics.Models.ReportTab
class Analytics.Views.ReportTabs.ShowView extends Backbone.View
  template: JST["backbone/templates/report_tabs/show"]
  events:
    "click .select-filter" : "select_filter"

  initialize: () ->
    _.bindAll this, "render", "redraw"
    @model.bind "change", @redraw
    @model.view = this
    @timelines = new Analytics.Collections.TimelineCharts([], {
      selector: @model
      filters: @model.dimensions_filters()
    })

  render: () ->
    $(@el).html(@template(@model.show_attributes()))
    $(@report_view.el).find('.tab-container').html($(@el))
    @render_range_picker()
    @render_timelines()
    @render_kpis()
    @render_dimensions()
    @fetch_data()

  redraw: () ->
    @remove()
    @render()
    @delegateEvents(@events)

  render_range_picker: () ->
    if not @model.range_picker_view?
      new Analytics.Views.ReportTabs.ShowRangePickerView({
        model: @model
      })
      $(@report_view.el).find('.report-tab-range-picker').html(@model.range_picker_view.render().el)
    else
      $(@report_view.el).find('.report-tab-range-picker').html(@model.range_picker_view.redraw().el)

  render_timelines: () ->
    segment_ids = Instances.Collections.segments.selected()
    @timelines.initialize_charts(@model.get("metric_ids"), segment_ids, @model.get("compare") != 0)
    render_to = $(@el).find("#report_tab_" + @model.id + "_timelines")[0]
    if not @timelines_view?
      @timelines_view = new Analytics.Views.Charts.TimelinesView({
        collection: @timelines
        render_to: render_to
      })
      @timelines_view.render()
    else
      @timelines_view.redraw({render_to: render_to})

  render_kpis: () ->
    render_to = $(@el).find("#report_tab_" + @model.id + "_kpis")[0]
    if not @kpis_view?
      @kpis_view = new Analytics.Views.Charts.KpisView({
        collection: @timelines
        render_to: render_to
        timelines_view: @timelines_view
      })
      @kpis_view.render()
    else
      @kpis_view.redraw({render_to: render_to})

  render_dimensions: () ->
    render_to = $(@el).find("#report_tab_" + @model.id + "_dimensions")[0]
    if not @dimensions_view?
      @dimensions_view = new Analytics.Views.Dimensions.ListView({
        model: @model
        render_to: render_to
        parent_view: this
      })
      @dimensions_view.render(false)
    else
      @dimensions_view.redraw({render_to: render_to, should_fetch: false})

  fetch_data: (blocking = true) ->
    if @model.get("metric_ids").length > 0
      @timelines.activate()
      if blocking?
        @timelines_view.block()
        if @model.dimension?
          @dimensions_view.block()
      timelines_view = @timelines_view
      kpis_view = @kpis_view
      dimensions_view = @dimensions_view
      @timelines.fetch_charts({
        success: (resp) ->
          timelines_view.unblock()
        error: (xhr, options, err) ->
          timelines_view.unblock()
      }, @model.force_fetch)
      if @model.dimension?
        @dimensions_view.dimensions.activate()
        @dimensions_view.dimensions.fetch_charts({
          success: (resp) ->
            dimensions_view.dimensions_chart_view.redraw()
            dimensions_view.unblock()
          error: (xhr, options, err) ->
            dimensions_view.unblock()
        }, @model.force_fetch)
      @model.force_fetch = false


  select_filter: (ev) ->
    value = $(ev.currentTarget).attr("value")
    type = $(ev.currentTarget).attr("type")
    if type.toUpperCase() == 'ALL'
      @model.dimension = @model.dimensions[0]
      @model.dimensions_filters().splice(0, @model.dimensions_filters().length)
    else
      @model.dimension = _.find(@model.dimensions, (item) ->
        item.value == value and item.dimension_type == type
      )
      dimension_filter = _.find(@model.dimensions_filters(), (item) ->
        item.dimension.value == value and item.dimension.dimension_type == type
      )
      dimension_filter_index = @model.dimensions_filters().indexOf(dimension_filter)
      @model.dimensions_filters().splice(dimension_filter_index + 1, @model.dimensions_filters().length - dimension_filter_index - 1)
    @redraw()


#model: Analytics.Models.ReportTab
class Analytics.Views.ReportTabs.ShowRangePickerView extends Backbone.View
  template: JST['backbone/templates/report_tabs/show-range-picker']
  events:
    "click li a.default-range" : "change_default_range"
    "change .compare-checkbox" : "change_compare"
    "click li a.custom-range" : "show_custom_range"
    "click a.submit-custom-range" : "check_submit"
    "blur input" : "validate_custom_range"
    "blur select" : "validate_custom_range"

  initialize: () ->
    _.bindAll this, "render", "redraw"
    @model.range_picker_view = this

  render: () ->
    $(@el).html(@template(@model.show_attributes()))
    @render_datepicker()
    @render_compare_datepicker()
    this

  redraw: () ->
    @remove()
    @render()
    @delegateEvents(@events)
    this

  render_datepicker: () ->
    el = @el
    $(el).find('.custom-datepicker').datepicker({format: 'yyyy/mm/dd'}).on('changeDate', (ev) ->
      $(el).find('.custom-datepicker').datepicker('hide')
      $(el).find('.end-time').val(Analytics.Utils.pickUTCDate(ev.date.valueOf()))
    )

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
    end_time = now.getTime()-day_offset*86400000
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
    $(@el).find('#custom-range-'+@model.id).modal()
    @clear_error()

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
    $(@el).find('#custom-range-'+@model.id).modal('hide')
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

  clear_error: () ->
    $(@el).find(".error").removeClass("error")
    $(@el).find("span.error-message").text("")

