Analytics.Guide ||= {}
Analytics.Guide.no_dimension=(report_tab)->
  $("#guide-info").remove()
  $('#main-container').append((JST['backbone/templates/guide/no_dimension_guide']({selector:report_tab})))
  $('body').animate({
    scrollTop: $("#guide-info").offset().top
  })

Analytics.Guide.no_event = (report_tab, metirc_id=null)->
  $("#guide-info").remove()

  $('#main-container').append((JST['backbone/templates/guide/no_event_guide']({selector:report_tab, metirc_id:metirc_id})))
  $('body').animate({
    scrollTop: $("#guide-info").offset().top
  })

Analytics.Views.Guide ||= {}
class Analytics.Views.Guide.NoEvent extends Backbone.View
  template: JST['backbone/templates/guide/no_event_guide']
  events:
    "click a.metric" : "display_metric"

  initialize: (options) ->
    _.bindAll(this, "render")
    @metric_id = options.metric_id
    @report_tab = options.report_tab

  render: ()->
    $("#guide-info").remove()
    $(@el).html(@template({metric_id:@metric_id}))
    $('#main-container').append(@el)
    $('body').animate({
      scrollTop: $("#guide-info").offset().top
    })

  display_metric: (ev)->
    id = $(ev.currentTarget).attr("metric_id")
    @model = Instances.Collections.metrics.get(id)
    if Instances.Models.project? and not @model.get("project_id")?
      template_model = new Analytics.Models.Metric(@model.attributes)
      Instances.Collections.metrics.remove(@model)  # todo ok to remove?
      Instances.Collections.metrics.add(template_model)
      @model.collection = Instances.Collections.metrics
      @model.set({id: null, project_id: Instances.Models.project.id}, {silent: true})
      if @model.get("combine_attributes")?
        @model.get("combine_attributes")["id"] = null
        @model.get("combine_attributes")["project_id"] = Instances.Models.project.id

    @model.set({just_show:true},{slient:true})
    form = new Analytics.Views.Metrics.FormView({
      model: @model
      clone: template_model
      id: (if @model.id? then "edit_metric_"+@model.id else "clone_metric")
    }).render()
    1+1
    $(form.el).find("input").attr("disabled","disabled")
    $(form.el).find("select").attr("disabled","disabled")