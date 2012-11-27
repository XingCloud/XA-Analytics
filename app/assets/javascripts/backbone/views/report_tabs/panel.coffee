Analytics.Views.ReportTabs ||= {}

class Analytics.Views.ReportTabs.PanelView extends Backbone.View
  template: JST["backbone/templates/report_tabs/panel"]

  initialize: () ->
    _.bindAll this, "render", "redraw"
    @model.panel_view = this

  render: () ->
    $(@el).html(@template(@model.show_attributes()))
    @render_range_picker()
    @render_dimension_tags()
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
      @dimension_tags_view = new Analytics.Views.Dimensions.TagsView({model: @model})
      $(@el).find(".dimensions-panel").html(@dimension_tags_view.render().el)
    else
      $(@el).find(".dimensions-panel").html(@dimension_tags_view.redraw().el)

  redraw: () ->
    @remove()
    @render()
    @delegateEvents(@events)
    this


class Analytics.Views.ReportTabs.ShowRangePickerView extends Backbone.View
  template: JST['backbone/templates/report_tabs/show-range-picker']
  events:
    "click li a.default-range" : "change_default_range"
    "change .compare-checkbox" : "change_compare"
    "click li a.custom-range" : "show_custom_range"
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
    range = {
      length: parseInt($(ev.currentTarget).attr("length"))
      interval: $(ev.currentTarget).attr("interval")
    }
    @model.compare_end_time = @model.end_time - range.length*86400000
    @model.set(range)

  change_compare: (ev) ->
    @model.set({compare: ( if $(ev.currentTarget)[0].checked then 1 else 0)})

  show_custom_range: (ev) ->
    $(@el).find(".dropdown").removeClass("open")
    $(@el).find('#custom-range-'+@model.id).modal()

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
    @model.set(range, {silent: true})
    if change
      @model.trigger("change")



