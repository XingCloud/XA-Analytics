Analytics.Views.Widgets ||= {}

###
model: Instances.Collections.widgets[i]:Analytics.Models.Widget
###
class Analytics.Views.Widgets.FormView extends Backbone.View
  template: JST["backbone/templates/widgets/form"]
  className: "modal widget-form"
  events:
    "click .widget-type" : "choose_type"
    "click .widget-cancel" : "cancel"
    "click .widget-submit" : "submit"
    "click .widget-remove" : "remove"

  initialize: () ->
    _.bindAll this,"render"

  render: () ->
    $(@el).html(@template(@model.attributes))
    $(@el).on("hidden", () -> $(@).remove())
    @render_metric()
    $(@el).modal()

  render_metric: () ->
    @metric_view = new Analytics.Views.Widgets.FormMetricView({
      metric_id: @model.get("metric_id")
    })
    $(@el).find(".widget-metric").html(@metric_view.render().el)

  choose_type: (ev) ->
    $(@el).find(".widget-type").removeClass("active")
    $(ev.currentTarget).addClass("active")
    type = $(ev.currentTarget).attr("value")
    $(@el).find("input.widget_type").val(type)

    if type == 'table'
      $(@el).find(".widget-dimension").show()
    else
      $(@el).find(".widget-dimension").hide()

    if type == 'time'
      $(@el).find(".widget-interval").show()
    else
      $(@el).find(".widget-interval").hide()

  cancel: () ->
    $(@el).modal("hide")

  submit: () ->
    form_el = $(@el).find("form")
    if Analytics.Utils.checkFormFields(form_el)
      form = form_el.toJSON()
      el = @el
      update = @model.id?
      @model.save(form, {
        wait: true
        success: (model, resp) ->
          if not update
            model.collection.add(model)
          $(el).modal("hide")
        error: (xhr, options, error) ->
          $(el).modal("hide")
      })

  remove: () ->
    collection = @model.collection
    el = @el
    @model.destroy({
      wait: true
      success: (model, resp) ->
        $(el).modal("hide")
      error: (xhr, options, error) ->
        $(el).modal("hide")
    })


class Analytics.Views.Widgets.FormMetricView extends Backbone.View
  template: JST["backbone/templates/widgets/form-metric"]
  events:
    "click .metric-remove" : "remove_metric"

  initialize: (options) ->
    _.bindAll this, "render"
    @metric_id = options.metric_id

  render: () ->
    $(@el).html(@template({metric_id: @metric_id}))
    if not @metric_id?
      @render_metrics_dropdown()
    this

  add_metric: (metric_id) ->
    @metric_id = metric_id
    @render()

  render_metrics_dropdown: () ->
    metrics_dropdown_view = new Analytics.Views.Metrics.IndexDropdownView({
      list_view: this
      disable_add_metric: true
      height: 100
    })
    metrics_dropdown_view.render()
    $(@el).find(".metric-add-dropdown").append(metrics_dropdown_view.el)

  remove_metric: () ->
    @metric_id = null
    @render()