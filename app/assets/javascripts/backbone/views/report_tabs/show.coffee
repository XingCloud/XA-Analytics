Analytics.Views.ReportTabs ||= {}

class Analytics.Views.ReportTabs.ShowView extends Backbone.View
  template: JST["backbone/templates/report_tabs/show"]
  events:
    "click #interval .btn-group button" : "change_interval"
    "click #length-control button" : "change_length"
    "click #compare" : "change_compare"
    "click .legend-info-container" : "click_legend_info"

  initialize: () ->
    _.bindAll this, "render", "redraw"
    @model.bind "change", @redraw
    @model.view = this
    @chart_sequences = new Analytics.Collections.ChartSequences([], {report_tab: @model})

  render: () ->
    $(@el).html(@template(@model.show_attributes()))
    $(@report_view.el).find('#tab-container').html($(@el))
    @render_datepicker()
    @render_chart()

  redraw: () ->
    @remove()
    @render()
    @delegateEvents(this.events)

  render_datepicker: () ->
    el = @el
    model = @model
    $(@el).find('.datepicker-input').datepicker({format: 'yyyy/mm/dd'}).on('changeDate', (ev) ->
      $(el).find('.datepicker-input').datepicker('hide')
      $(el).find('.datepicker-input').blur()
      if model.compare_end_time != ev.date.valueOf()
        model.compare_end_time = ev.date.valueOf()
        model.trigger("change")
    )

  render_chart: () ->
    @chart_sequences.init()
    $(@el).find('#legend').html(JST['backbone/templates/report_tabs/show-legend'](@chart_sequences.legend()))
    @chart_sequences.fetch_data()

  redraw_chart: () ->
    $(@el).find('#legend').html(JST['backbone/templates/report_tabs/show-legend'](@chart_sequences.legend()))
    @chart_sequences.chart_render()

  change_interval: (ev) ->
    if @model.get("project_id")?
      @model.save({interval: $(ev.currentTarget).attr("value")}, {wait: true})
    else
      @model.set({interval: $(ev.currentTarget).attr("value")})

  change_length: (ev) ->
    if @model.get("project_id")?
      @model.save({length: $('#length').val()}, {wait: true})
    else
      @model.set({length: $('#length').val()})

  change_compare: (ev) ->
    if @model.get("project_id")?
      @model.save({compare: ( if $('#compare')[0].checked then 1 else 0)}, {wait: true})
    else
      @model.set({compare: ( if $('#compare')[0].checked then 1 else 0)})

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

