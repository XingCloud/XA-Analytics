Analytics.Views.ReportTabs ||= {}

class Analytics.Views.ReportTabs.ShowView extends Backbone.View
  template: JST["backbone/templates/report_tabs/show"]
  events:
    "click .choose-dimension" : "choose_dimension"
    "click .legend-info-container" : "click_legend_info"

  initialize: () ->
    _.bindAll this, "render", "redraw"
    @model.bind "change", @redraw
    @model.view = this
    @chart_sequences = new Analytics.Collections.ChartSequences([], {report_tab: @model})
    @dimensions_sequence = new Analytics.Models.DimensionsSequence({
      metrics: @model.metrics_attributes()
      dimensions: @model.get("dimensions_attributes")
      filters: @model.dimensions_filters
    })
    @dimensions_sequence.report_tab = @model

  render: () ->
    $(@el).html(@template(@model.show_attributes()))
    $(@report_view.el).find('.tab-container').html($(@el))
    @render_range_picker()
    @render_chart()
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

  render_chart: () ->
    @chart_sequences.init()
    $(@el).find('#legend').html(JST['backbone/templates/report_tabs/show-legend'](@chart_sequences.legend()))


  render_dimensions: () ->
    @dimensions_sequence.init()
    $(@el).find('#dimensions').html(new Analytics.Views.Dimensions.ShowView({
      model: @dimensions_sequence
      report_tab_view: this
    }).render().el)

  redraw_chart: () ->
    $(@el).find('#legend').html(JST['backbone/templates/report_tabs/show-legend'](@chart_sequences.legend()))
    @chart_sequences.chart_render()

  fetch_data: () ->
    if @model.get("metric_ids").length > 0
      $.blockUI({message: $('#loader-message')})
      @fetch_request_count = (if @dimensions_sequence.get("dimension")? then 2 else 1)
      @chart_sequences.fetch_data()
      if @dimensions_sequence.get("dimension")?
        @dimensions_sequence.fetch_data()

  fetch_complete: () ->
    if @fetch_request_count > 0
      @fetch_request_count = @fetch_request_count - 1
      if @fetch_request_count == 0
        $.unblockUI()

  click_legend_info: (ev) ->
    if($(ev.currentTarget).hasClass('deactive'))
      @chart_sequences.chart.get($(ev.currentTarget).attr('sequence-id')).show()
      if @model.get("compare") != 0
        @chart_sequences.chart.get($(ev.currentTarget).attr('compare-sequence-id')).show()
      $(ev.currentTarget).removeClass('deactive')
    else
      @chart_sequences.chart.get($(ev.currentTarget).attr('sequence-id')).hide()
      if @model.get("compare") != 0
        @chart_sequences.chart.get($(ev.currentTarget).attr('compare-sequence-id')).hide()
      $(ev.currentTarget).addClass('deactive')

  resize_chart: (expand, size) ->
    if expand
      @chart_sequences.chart.setSize($(@el).find('#chart').width())
    else
      @chart_sequences.chart.setSize(size)

  choose_dimension: (ev) ->
    value = $(ev.currentTarget).attr("value")
    type = $(ev.currentTarget).attr("type")
    if type.toUpperCase() == 'ALL'
      dimension = @model.get("dimensions_attributes")[0]
      @model.dimensions_filters.splice(0, @model.dimensions_filters.length)
    else
      dimension = _.find(@model.get("dimensions_attributes"), (item) ->
        item.value == value and item.dimension_type == type
      )
      dimension_filter = _.find(@model.dimensions_filters, (item) ->
        item.dimension.value == value and item.dimension.dimension_type == type
      )
      dimension_filter_index = @model.dimensions_filters.indexOf(dimension_filter)
      @model.dimensions_filters.splice(dimension_filter_index, @model.dimensions_filters.length - dimension_filter_index)

    @dimensions_sequence.set({dimension: dimension}, {silent: true})
    @redraw()


class Analytics.Views.ReportTabs.ShowRangePickerView extends Backbone.View
  template: JST['backbone/templates/report_tabs/show-range-picker']
  events:
    "click .range-control-dropdown-menu li a.default-range" : "change_default_range"
    "change .compare-checkbox" : "change_compare"
    "click a.submit-custom-range" : "change_custom_range"

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
      $(el).find('.end-time').val(ev.date.valueOf())
    )

  render_compare_datepicker: () ->
    el = @el
    model = @model
    $(@el).find('.compare-datepicker').datepicker({format: 'yyyy/mm/dd'}).on('changeDate', (ev) ->
      $(el).find('.compare-datepicker').datepicker('hide')
      if model.compare_end_time != ev.date.valueOf()
        model.compare_end_time = ev.date.valueOf()
        if model.get("compare") == 0 and model.get("project_id")?
          model.save({compare: 1},{wait: true})
        else if model.get("compare") == 0
          model.set({compare: 1})
        else
          model.trigger("change")
    )

  change_default_range: (ev) ->
    range = {
      length: parseInt($(ev.currentTarget).attr("length"))
      interval: $(ev.currentTarget).attr("interval")
    }
    @model.compare_end_time = @model.end_time - range.length*86400000
    if @model.get("project_id")?
      @model.save(range, {wait: true})
    else
      @model.set(range)

  change_compare: (ev) ->
    if @model.get("project_id")?
      @model.save({compare: ( if $(ev.currentTarget)[0].checked then 1 else 0)}, {wait: true})
    else
      @model.set({compare: ( if $(ev.currentTarget)[0].checked then 1 else 0)})

  change_custom_range: (ev) ->
    range = {
      length: parseInt($(@el).find('.length-input').val())
      interval: $(@el).find('.interval-select option:selected').attr("value")
    }
    end_time = parseInt($(@el).find('.end-time').val())
    change = (@model.end_time != end_time or @model.get("length") != range.length or @model.get("interval") != range.interval)
    $(@el).find('#custom-range-'+@model.id).modal('hide')
    @model.compare_end_time = @model.compare_end_time + end_time - @model.end_time
    @model.end_time = end_time
    if @model.get("project_id")?
      @model.save(range, {
        wait: true
        silent: true
        success: (model, resp) ->
          if change
            model.trigger("change")
      })
    else
      @model.set(range, {silent: true})
      if change
        @model.trigger("change")


