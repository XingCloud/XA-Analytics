Analytics.Views.Reports ||= {}

class Analytics.Views.Reports.NavView extends Backbone.View
  template: JST['backbone/templates/reports/report_left_nav']
  events:
    "mouseenter .accordion-heading": "mouseenter_category"
    "mouseleave .accordion-heading": "mouseleave_category"
    "mouseenter .accordion-inner .nav.nav-list li": "mouseenter_report"
    "mouseleave .accordion-inner .nav.nav-list li": "mouseleave_report"
    "click .dropdown-toggle": "toggle_dropdown"
    "click .dropdown-menu li a": "click_dropdown_item"
    "mousedown .dropdown-toggle": "mousedown_dropdown_toggle"
    "mousedown .dropdown-menu li a": "mousedown_dropdown_item"

  initialize: (options) ->
    _.bindAll(this, "render")
    Instances.Collections.report_categories.bind "all", @render
    Instances.Collections.reports.bind "all", @render

  render: () ->
    $(@el).html(@template({
      reports: Instances.Collections.reports,
      report_categories: Instances.Collections.report_categories
    }))

  mouseenter_category: (ev) ->
    $(ev.currentTarget).find(".dropdown-toggle").attr("mouseenter", "1")
    $(ev.currentTarget).find(".dropdown-toggle").show()

  mouseleave_category: (ev) ->
    $(ev.currentTarget).find(".dropdown-toggle").attr("mouseenter", "0")
    if not $(ev.currentTarget).find(".dropdown").hasClass("open")
      $(ev.currentTarget).find(".dropdown-toggle").hide()

  mouseenter_report: (ev) ->
    $(ev.currentTarget).find(".dropdown-toggle").attr("mouseenter", "1")
    $(ev.currentTarget).find(".dropdown-toggle").show()

  mouseleave_report: (ev) ->
    $(ev.currentTarget).find(".dropdown-toggle").attr("mouseenter", "0")
    if not $(ev.currentTarget).find(".dropdown").hasClass("open")
      $(ev.currentTarget).find(".dropdown-toggle").hide()

  toggle_dropdown: (ev) ->
    value = $(ev.currentTarget).attr("value")
    offset = $(ev.currentTarget).offset()
    parent = $(ev.currentTarget).parent()
    if parent.find(".dropdown-menu").length == 0
      $(@el).find("#dropdown-"+value).css({
        top: offset.top + $(ev.currentTarget).outerHeight() - $(".main").offset().top
        left: offset.left
      })
#      # todo wcl :element that with absolute position its left/top/... attr value is relative to its first parent with relative position
#      # doesn't equal to the offset attr that relative on the document(here is offset.top), so we cannot assign offset to absolute position.
#      $(@el).find("#dropdown-"+value).offset({top:offset.top+$(ev.currentTarget).outerHeight(),left:offset.left})
    if parent.hasClass("open")
      $(document).off("mousedown", @hide_dropdown)
    else
      ev.currentTarget.hide_dropdown = @hide_dropdown
      $(document).on("mousedown", $.proxy(ev.currentTarget.hide_dropdown, ev.currentTarget))
    $(@el).find("#dropdown-"+value).toggle()
    parent.toggleClass("open")

  hide_dropdown: () ->
    value = $(@).attr("value")
    $("#dropdown-"+value).hide()
    $(@).parent().removeClass("open")
    $(document).off("mousedown", @hide_dropdown)
    if $(@).attr("mouseenter") == "0"
      $(@).hide()

  mousedown_dropdown_toggle: (ev) ->
    if $(ev.currentTarget).parent().hasClass("open")
      ev.stopPropagation()
      ev.preventDefault()

  mousedown_dropdown_item: (ev) ->
    ev.stopPropagation()
    ev.preventDefault()

  click_dropdown_item: (ev) ->
    $("body").trigger("mousedown")
