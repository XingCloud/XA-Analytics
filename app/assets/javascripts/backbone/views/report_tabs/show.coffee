Analytics.Views.ReportTabs ||= {}

class Analytics.Views.ReportTabs.ShowView extends Backbone.View
  template: JST["backbone/templates/report_tabs/show"]
  events:
    "click #interval .btn-group button" : "change_interval"
    "click #length-control button" : "change_length"
    "click #compare" : "change_compare"

  initialize: () ->
    _.bindAll this, "render", "redraw"
    @model.bind "change", @redraw
    @model.view = this

  render: () ->
    $(@el).html(@template(@model.attributes))
    @render_datepicker()
    $(@report_view.el).find('#tab-container').html($(@el))

  redraw: () ->
    @render()
    @delegateEvents(this.events)

  render_datepicker: () ->
    el = @el
    $(@el).find('.datepicker-input').datepicker({format: 'yyyy/mm/dd'}).on('changeDate', (ev) ->
      $(el).find('.datepicker-input').datepicker('hide')
      $(el).find('.datepicker-input').blur()
    )

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
      @mode.set({compare: ( if $('#compare')[0].checked then 1 else 0)})

