Analytics.Views.Dimensions ||= {}

class Analytics.Views.Dimensions.FormListItemView extends Backbone.View
  template: JST['backbone/templates/dimensions/form-list-item']

  events:
    "click .dimension-remove" : "remove_dimension"
    "change select" : "change_dimension"

  initialize: (options) ->
    _.bindAll(this, "render")
    @model.bind "change", @render
    @model.view = this
    @report_tab_index = options.report_tab_index
    @list_view = options.list_view
    @index = options.index

  render: () ->
    attributes = _.clone(@model.attributes)
    attributes.report_tab_index = @report_tab_index
    attributes.index = @index
    $(@el).html(@template(attributes))
    this

  remove_dimension: () ->
    $(@el).hide()
    $(@el).find('#report_tabs_'+@report_tab_index+'_dimensions_'+@index+'__destroy').val(1)
    @list_view.remove_dimension(@model)

  change_dimension: (ev) ->
    option = $(@el).find('select option:selected')
    @model.set({
      name: option.attr('name')
      value: option.attr('value')
      dimension_type: option.attr('dimension_type')
      value_type: option.attr('value_type')
    })

class Analytics.Views.Dimensions.FormListView extends Backbone.View
  template: JST['backbone/templates/dimensions/form-list']
  className: 'control-group'

  events:
    "click .dimension-add" : "add_dimension"

  initialize: () ->
    _.bindAll(this, "render")
    @dimensions = []
    @index = 0

  render: () ->
    $(@el).html(@template(@model))
    @level = 0
    dimensions = _.sortBy(@model.dimensions, (dimension) -> dimension.level)
    for dimension in dimensions
      dimension_model = new Analytics.Models.Dimension(dimension)
      @render_dimension(dimension_model)
      @dimensions.push(dimension_model)
    this

  render_dimension: (dimension) ->
    dimension.set({level: @level})
    $(@el).find('.dimensions').append(new Analytics.Views.Dimensions.FormListItemView({
      model: dimension
      report_tab_index: @model.index
      list_view: this
      index: @index
    }).render().el)
    @level = @level+1
    $(@el).find('.dimension-add').css('margin-left': @level*20+"px")
    @index = @index + 1


  remove_dimension: (dimension) ->
    @dimensions.splice(@dimensions.indexOf(dimension), 1)
    @level = 0
    for dimension_model in @dimensions
      dimension_model.set({level: @level})
      @level = @level + 1
    $(@el).find('.dimension-add').css('margin-left': @level*20+"px")

  add_dimension: () ->
    if @level >= 6
      alert(I18n.t("views.dimensions.form_list.alert"))
    else
      dimension = new Analytics.Models.Dimension()
      @render_dimension(dimension)
      @dimensions.push(dimension)