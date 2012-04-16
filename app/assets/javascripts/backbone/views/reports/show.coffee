Analytics.Views.Reports ||= {}

class Analytics.Views.Reports.DatePickerView extends Backbone.View
  template: JST["backbone/templates/reports/datepicker"]
  id: "date-range"
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
        $('.date-input.active input.start').val(dates[0].getFullYear()+'-'+(dates[0].getMonth()+1)+'-'+dates[0].getDate())
        $('.date-input.active input.end').val(dates[1].getFullYear()+'-'+(dates[1].getMonth()+1)+'-'+dates[1].getDate())
        $('.date-input.active input.date').val($.format.date(dates[0], "yyyy/MM/dd") + ' - ' + $.format.date(dates[1], "yyyy/MM/dd"))
        if $('#choose-range').val() != 'custom'
          $('#choose-range').val('custom')
    })

  set_date: (element, from, to) ->
    $(element+' input.start').val(from.getFullYear()+'-'+(from.getMonth()+1)+'-'+from.getDate())
    $(element+' input.end').val(to.getFullYear()+'-'+(to.getMonth()+1)+'-'+to.getDate())
    $(element+' input.date').val(@range_text(from, to))

  parse_date: (element) ->
    [new Date(Date.parse($(element+' input.start').val())), new Date(Date.parse($(element+' input.end').val()))]

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
        to = new Date(Date.parse(to.getFullYear()+"/"+(to.getMonth()+1)+"/1") - 1000 * 60 * 60 * 24)
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

class Analytics.Views.Reports.ShowView extends Backbone.View

  initialize: () ->
    _.bindAll(this, "render")
    @model.bind "change", @render
    @model.view = this