Analytics.Views.Charts ||= {}

###
collection: charts (DimensionCharts)
render_to: render_to
###
class Analytics.Views.Charts.DimensionsView extends Backbone.View
  template: JST["backbone/templates/charts/dimensions"]

  events:
    "mouseenter .dimensions-table" : "mouseenter_table"
    "mouseleave .dimensions-table" : "mouseleave_table"
    "mouseenter .dimension-column-desc" : "tryshow_desc_icon"
    "mouseleave .dimension-column-desc" : "tryhide_desc_icon"
    "click i.no_category" : "no_dimension_guide"
    "click i.no_event" : "no_event"

  initialize: (options) ->
    _.bindAll this, "render", "redraw"
    @render_to = options.render_to
    @collection.on "change", @redraw # DimensionCharts


  render: () ->
    $(@el).html(@template(@collection))
    $(@render_to).html(@el)
    $(@el).find("span.dimension-column-desc").popover({
      html: false
      trigger: "hover"
      placement: "top"
    })

  redraw: (options = {}) ->
    @remove()
    if options.render_to
      @render_to = options.render_to
    @render()
    @delegateEvents(@events)

  mouseenter_table: (event) ->
    $(@el).find("a.download-table").show()

  mouseleave_table: (event)->
    $(@el).find("a.download-table").hide()

  tryshow_desc_icon: (event) ->
    $("i", event.currentTarget).fadeTo('fast', 1)

  tryhide_desc_icon: (event) ->
    $("i", event.currentTarget).fadeTo('fast', 0.4)

  block: () ->
    $(@render_to).block({message: "<strong>" + I18n.t('commons.pending') + "</strong>"})

  unblock: () ->
    if $(@render_to).find(".blockOverlay").length > 0
      $(@render_to).unblock()

  no_dimension_guide: (event) ->
    Analytics.Guide.no_dimension(@collection.selector)

  no_event: (event) ->
    Analytics.Guide.no_event(@collection.selector)
