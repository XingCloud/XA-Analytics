Analytics.Views.Reports ||= {}

class Analytics.Views.Reports.DatePickerView extends Backbone.View
  template: JST["backbone/templates/reports/datepicker"]
  el: "#report-datepicker"
  events:
    "click .date-input": "click_input"
    "click #date-range-field": "click_range"
    "click #datepicker-ok": "click_ok"
    "click #datepicker-cancel": "click_cancel"
    "change #choose-range": "change_range"
    "change #compared": "change_compare"

  initialize: () ->
    _.bindAll(this, "render")

  render: () ->
    $(@el).html(@template({model: @model}))
    @toggle()
    @setup()

  remove: () ->
    $(@el).empty()

  setup: () ->
    $('#datepicker-calendar').DatePickerSetDate([@model.get("start_time"), @model.get("end_time")], true)
    $('#date-range-field span').text(@range_text(@model.get("start_time"), @model.get("end_time")))
    $('#choose-range').val('custom')
    @set_date('#date-control', @model.get("start_time"), @model.get("end_time"))
    $('#compared')[0].checked = @model.get("compare")
    if @model.get("compare")
      $('#compare-control').show()
      @set_date('#date-control', @model.get("compare_start_time"), @model.get("compare_end_time"))
    else
      $('#compare-control').hide()


  toggle: () ->
    $('#datepicker-calendar').DatePicker({
      inline: true,
      calendars: 3,
      mode: 'range',
      onChange: (dates,el) ->
        $('.date-input.active input.start').val($.format.date(dates[0], "yyyy-MM-dd"))
        $('.date-input.active input.end').val($.format.date(dates[1], "yyyy-MM-dd"))
        $('.date-input.active input.date').val($.format.date(dates[0], "yyyy/MM/dd") + ' - ' + $.format.date(dates[1], "yyyy/MM/dd"))
        if $('#choose-range').val() != 'custom'
          $('#choose-range').val('custom')
    })

  set_date: (element, from, to) ->
    $(element+' input.start').val($.format.date(from, "yyyy-MM-dd"))
    $(element+' input.end').val($.format.date(to, "yyyy-MM-dd"))
    $(element+' input.date').val(@range_text(from, to))

  parse_date: (element) ->
    [new Date(Analytics.Utils.parseDate($(element+' input.start').val())), new Date(Analytics.Utils.parseDate($(element+' input.end').val()))]

  range_text: (from, to) ->
    $.format.date(from, "yyyy/MM/dd") + ' - ' + $.format.date(to, "yyyy/MM/dd")

  click_input: (ev) ->
    if not $(ev.currentTarget).hasClass('active')
      $('.date-input').removeClass('active')
      $(ev.currentTarget).addClass('active')
      $('#datepicker-calendar').DatePickerSetDate(@parse_date('#'+$(ev.currentTarget).attr('id')), true)

  click_range: (ev) ->
    $('#datepicker-container').toggle();
    if $('#date-range-field a').text().charCodeAt(0) == 9660
      $('#date-range-field a').html('&#9650;')
      $('#date-range-field').css({borderBottomLeftRadius:0, borderBottomRightRadius:0})
      $('#date-range-field a').css({borderBottomRightRadius:0})
    else
      $('#date-range-field a').html('&#9660;')
      $('#date-range-field').css({borderBottomLeftRadius:5, borderBottomRightRadius:5})
      $('#date-range-field a').css({borderBottomRightRadius:5})

  click_ok: (ev) ->
    dates = @parse_date('#date-control')
    $('#date-range-field span').text(@range_text(dates[0], dates[1]))
    $('#datepicker-container').toggle();
    $('#date-range-field a').html('&#9660;')
    $('#date-range-field').css({borderBottomLeftRadius:5, borderBottomRightRadius:5})
    $('#date-range-field a').css({borderBottomRightRadius:5})
    @set_model()

  click_cancel: (ev) ->
    @setup()
    $('#datepicker-container').toggle();
    $('#date-range-field a').html('&#9660;')
    $('#date-range-field').css({borderBottomLeftRadius:5, borderBottomRightRadius:5})
    $('#date-range-field a').css({borderBottomRightRadius:5})

  change_range: (ev) ->
    from = new Date()
    to = new Date()
    toggle = true
    switch $('#choose-range').val()
      when "today" then toggle = true
      when "yesterday"
        to = new Date(to.getTime() - 1000 * 60 * 60 * 24)
        from = new Date(to.getTime())
        toggle = true
      when "last_week"
        to = new Date()
        from = new Date(to.getTime() - 1000 * 60 * 60 * 24 * 6)
        toggle = true
      when "last_month"
        to = new Date(Analytics.Utils.parseDate(to.getFullYear()+"/"+(to.getMonth()+1)+"/1") - 1000 * 60 * 60 * 24)
        from = new Date(to.getTime() - 1000 * 60 * 60 * 24 * (to.getDate()-1))
        toggle = true
      else toggle = false

    if toggle
      @set_date('#date-control', from, to)
      if $('#compared').is(":checked")
        compare_to = new Date(from.getTime() - 1000 * 60 * 60 * 24)
        if $('#choose-range').val() == 'last_month'
          compare_from = new Date(compare_to.getTime() - 1000 * 60 * 60 * 24 * (compare_to.getDate()-1))
        else
          compare_from = new Date(compare_to.getTime() - (to.getTime() - from.getTime()))
        @set_date('#compare-control', compare_from, compare_to)
      $('#datepicker-calendar').DatePickerSetDate(@parse_date('.date-input.active'), true)

  change_compare: (ev) ->
    $('#compare-control').toggle()
    if $('#compared').is(":checked")
      dates = @parse_date('#date-control')
      to = new Date(dates[0].getTime() - 1000 * 60 * 60 * 24)
      if $('#choose-range').val() == 'last_month'
        from = new Date(to.getTime() - 1000 * 60 * 60 * 24 * (to.getDate()-1))
      else
        from = new Date(to.getTime() - (dates[1].getTime() - dates[0].getTime()))
      @set_date('#compare-control', from, to)
      $('#date-control').removeClass('active')
      $('#compare-control').addClass('active')
      $('#datepicker-calendar').DatePickerSetDate([from, to], true)
    else
      $('#compare-control').removeClass('active')
      $('#date-control').addClass('active')
      dates = @parse_date('#date-control')
      $('#datepicker-calendar').DatePickerSetDate(dates, true)

  set_model: () ->
    dates = @parse_date('#date-control')
    options =
      "start_time": dates[0]
      "end_time": dates[1]
      "compare": $('#compared')[0].checked
    if $('#compared')[0].checked
      compare_dates = @parse_date('#compare-control')
      options["compare_start_time"] = compare_dates[0]
      options["compare_end_time"] = compare_dates[1]
    @model.set(options)

class Analytics.Views.Reports.RateView extends Backbone.View
  template: JST["backbone/templates/reports/rate"]
  el: "#rate-container"
  events:
    "click .btn.rate": "change_rate"

  initialize: () ->
    _.bindAll(this, "render")

  render: () ->
    $(@el).html(@template({model: @model}))

  change_rate: (ev) ->
    $('button.btn.rate').removeClass('active')
    $(ev.currentTarget).addClass('active')
    $('#rate').val($(ev.currentTarget).attr("value"))
    @model.set({"rate": $(ev.currentTarget).attr("value")})

class Analytics.Views.Reports.ShowView extends Backbone.View

  el: "#block-container"
  events:
    "click #segment-btn": "toggle_segment"
    "click #refresh-btn": "render"

  chart_options: () ->
    "credits":
      "enabled": false
    "title":
      "text": ""
    "chart":
      "renderTo": "chart"
      "height": 200
      "type": @model.get("report_tab").chart_type
    "yAxis":
      "min": 0
      "gridLineWidth": 0.5
      "showFirstLabel": true
      "title":
        "text": ""
    "xAxis":
      "tickInterval": @tick_interval()
      "gridLineWidth": 0
      "tickWidth": 0
      "showFirstLabel": true
      "type": "datetime"
      "labels":
        "align": "center"
        "formatter": () -> Highcharts.dateFormat('%b %d', this.value)
    "tooltip":
      "enabled": true
      "shared": true
    "legend":
      "enabled": true
      "align": "top"
      "verticalAlign": "top"
      "borderWidth": 0
      "margin": 20

  initialize: () ->
    _.bindAll(this, "render")
    @model.bind "change", @render
    project.bind "change",@render
    @model.view = this
    @date_picker = new Analytics.Views.Reports.DatePickerView({model: @model})
    @rate = new Analytics.Views.Reports.RateView({model: @model});
    @segment_view = new Analytics.Views.Segments.IndexView();
    @date_picker.render()
    @rate.render()
    @segment_view.render()

  init_chart: () ->
    options = @chart_options()

    if (@model.get("end_time").getTime() - @model.get("start_time").getTime() <= 1000 * 60 * 60 * 24) and (@model.get("rate") == "hour" or @model.get("rate") == "min5")
      options.xAxis.labels.formatter = () ->
        Highcharts.dateFormat('%b %d %H:%M', this.value)

    if @model.get("compare")
      options.xAxis = [options.xAxis, options.xAxis]
    options.series = []

    metrics = @model.get("report_tab").metrics
    segments = project.get("segments")
    if not segments? or segments.length == 0
      segments = [null]
    for segment in segments
      for metric in metrics
        name = metric.name
        id = "metric"+metric.id
        if segment?
          name = name + "(" + segment.name + ")"
          id = id+"_segment"+segment.id
        options.series.push({
          name: name,
          id: id,
          data: []
        })
        if @model.get("compare")
          options.series.push({
            name: name+"(对比)",
            id: "compare_"+id,
            data: [],
            xAxis: 1
          })

    @chart = new Highcharts.Chart(options)

  render: () ->
    if @chart?
      @chart.destroy()
    @init_chart()
    params = @model.ajax_params(project.get("segments"))
    if params.length > 0
      $.blockUI({
        message: $('#loader-message')
      })
    Analytics.Request.counter = params.length
    for param in params
      $.ajax({
        url: @base_url(@model) + "/data",
        dataType: "json",
        type: "get",
        data: param,
        success: @success_resp,
        error: @error_resp
      })

  destroy: () ->
    @date_picker.remove()
    @rate.remove()
    @segment_view.remove()
    @remove()


  error_resp: (resp) ->
    Analytics.Request.counter = Analytics.Request.counter - 1
    if Analytics.Request.counter == 0
      $.unblockUI()

  success_resp: (resp) ->
    report = reports_router.reports.find((item) -> item.id == resp.report_id)
    if report?
      if resp["result"]
        data = ([Analytics.Utils.parseUTCDate(num[0]), num[1]] for num in resp["data"])
        id = "metric"+resp["metric_id"]
        if resp["segment_id"]?
          id = id+"_segment"+resp["segment_id"]
        if resp["compare"]
          id = "compare_"+id
        report.view.chart.get(id).setData(data)
    Analytics.Request.counter = Analytics.Request.counter - 1
    if Analytics.Request.counter == 0
      $.unblockUI()

  tick_interval: () ->
    rate = @model.get("rate")
    period = @model.get("end_time").getTime() - @model.get("start_time").getTime()
    if period <= 0
      1000 * 60 * 60 * 2
    if period <= 1000 * 60 * 60 * 24
      1000 * 60 * 60 * 3
    else if period <= 1000 * 60 * 60 * 24 * 14
      1000 * 60 * 60 * 24
    else if period <= 1000 * 60 * 60 * 24 * 72
      1000 * 60 * 60 * 24 * 7
    else
      1000 * 60 * 60 * 24 * 30

  point_interval: () ->
    switch @model.get("rate")
      when "min5" then 1000 * 60 * 5
      when "hour" then 1000 * 60 * 60
      when "day" then 1000 * 60 * 60 * 24
      when "week" then 1000 * 60 * 60 * 24 * 7
      when "month" then 1000 * 60 * 60 * 30

  base_url: () ->
    "/projects/"+project.id+"/reports/"+@model.get("id")+"/report_tabs/"+$('#report_tab_id').val()

  toggle_segment: () ->
    Analytics.Request.get "/projects/"+project.id+"/reports/"+@model.get("id") + "/render_segment",{}, (data) ->
      $("#segment_list").html(data)
    $('#segment_list').toggle()
