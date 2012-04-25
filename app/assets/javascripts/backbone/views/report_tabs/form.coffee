Analytics.Views.ReportTabs ||= {}

class Analytics.Views.ReportTabs.FormHeaderView extends Backbone.View
  template: JST["backbone/templates/report_tabs/form-header"]
  tagName: "li"
  events:
    "click i.close" : "close"

  initialize: () ->
    _.bindAll(this, "render")

  render: () ->
    attributes = _.clone(@model.attributes)
    attributes.index = @model.index
    $(@el).html(@template(attributes))
    this

  close: (ev) ->
    @report_form.close_tab(this)


class Analytics.Views.ReportTabs.FormBodyView extends Backbone.View
  template: JST["backbone/templates/report_tabs/form-body"]
  #dimension template follow
  template_dimension_display: JST["backbone/templates/report_tabs/dimension_display"]
  template_dimension_add_display: JST["backbone/templates/report_tabs/dimension_add_display"]
  template_dimension_select: JST["backbone/templates/report_tabs/dimension_select"]

  events:
    "click button.type-btn" : "change_chart_type"
    "click .metrics .action-add" : "new_metric"
    "click a#toggle-advanced-options" : "toggle_advanced_options"
    "click button.interval" : "change_interval"
    "change input#compare-checkbox" : "change_compare"
  #dimension event follow
    "click .dimension_add":"dimension_add"
    "click .dimension_display":"dimension_edit"
    "change .dimension_select":"dimension_select"
    "click .dimension_del":"dimension_del"


  initialize: () ->

    _.bindAll this, "render"

  render: () ->
    #init dimension
    dimension_array=@model.get("dimension")
    @model.set("dimension",new Array())
    @model.set("dimension_edit_index",-1)
    if(dimension_array!= undefined && dimension_array.length>0)
      @model.get("dimension").push(dimension) for dimension in dimension_array.split ","

    attributes = _.clone(@model.attributes)
    attributes.index = @model.index
    $(@el).html(@template(attributes))
    @dimension_render()
    for metric_id in @model.get("metric_ids")
      @render_metric(metric_id)
    this


  render_metric: (metric_id) ->
    metric = metrics_router.metrics.get(metric_id)
    metric.index = @model.index
    metric_view = new Analytics.Views.Metrics.FormListView({model: metric})
    $(@el).find('#report_tab_'+@model.index+'_metric_list').append(metric_view.render().el)



  new_metric: () ->
    metric = new Analytics.Models.Metric({project_id : @model.get("project_id")})
    metric.report_tab_view = this
    metric.collection = metrics_router.metrics
    new Analytics.Views.Metrics.FormView({
      model: metric,
      id: "new_metric"
    }).render()

  change_chart_type: (ev) ->
    $(@el).find('button.type-btn').removeClass('active')
    $(ev.currentTarget).addClass('active')
    $('#report_tabs_attributes_'+@model.index+'_chart_type').val($(ev.currentTarget).attr("value"))

  toggle_advanced_options: () ->
    $(@el).find('#advanced-options').toggle()

  change_interval: (ev) ->
    $(@el).find("button.interval").removeClass('active')
    $(ev.currentTarget).addClass('active')
    $('#report_tabs_attributes_'+@model.index+'_interval').val($(ev.currentTarget).attr("value"))

  change_compare: (ev) ->
    if $(ev.currentTarget)[0].checked
      $('#report_tabs_attributes_'+@model.index+'_compare').val(1)
    else
      $('#report_tabs_attributes_'+@model.index+'_compare').val(0)

  #dimension follow

  dimension_render:()->
    $(@el).find('#report_tabs_attributes_'+@model.index+'_dimension').attr("value",@model.get("dimension"))
    dimension_list=$(@el).find('#report_tabs_'+@model.index+'_dimension_list')
    dimension_list.html("")
    index=0;
    edit_index=@model.get("dimension_edit_index")
    for dimension in @model.get("dimension")
      if( parseInt(index) == parseInt(edit_index))
        dimension_list.append(@template_dimension_select({"index":index,"dimension":dimension,"del":true,"select_array":this.dimension_select_array()}))
      else
        dimension_list.append(@template_dimension_display({"index":index,"dimension":dimension}))
      index++
    if index<5
      if(parseInt(index) == parseInt(edit_index))
        dimension_list.append(@template_dimension_select({"index":index,"dimension":"","del":true,"select_array":this.dimension_select_array()}))
      else
        dimension_list.append(@template_dimension_add_display({"index":index}))

  dimension_add:(ev)->
    index=$(ev.target).attr("index")
    @model.set("dimension_edit_index",index)
    #@model.set("dimension_edit_index",index)
    @dimension_render()

  dimension_select:(ev)->
    index=$(ev.target).attr("index")
    @model.set("dimension_edit_index",-1)
    @model.get("dimension")[index]=$(ev.target).val()
    #@model.set("dimension_edit_index",-1)
    @dimension_render()

  dimension_edit:(ev)->
    index=$(ev.target).attr("index")
    @model.set("dimension_edit_index",index)
    #@model.set("dimension_edit_index",index)
    @dimension_render()

  dimension_del:(ev)->
    index=$(ev.target).attr("index")
    @model.get("dimension").splice(index,index+1)
    # @model.set("dimension",dimension_arry.splice(0,index-1).concat(dimension_arry.splice(index+1)))
    # @model.set("dimension_edit_index",-1)
    @dimension_render()


  dimension_select_array:()->
    dimension_array=["a","b"];
