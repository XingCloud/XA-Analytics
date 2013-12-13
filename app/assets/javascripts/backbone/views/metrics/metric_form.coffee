Analytics.Views.Metrics ||= {}
class Analytics.Views.Metrics.FormView extends Backbone.View
  template: JST['backbone/templates/metrics/metric_form']
  className: 'modal'
  events:
    "click #metric-cancel" : "cancel"
    "click #metric-submit" : "submit"
    "focus input.event-input" : "event_input_focus"
    "change input.event-input" : "event_input_change"
    "change select#metric_combine_action" : "toggle_combine"
    "change .filter select": "change_filter"
    "click button.type-btn" : "change_value_type"
    "click .scale .icon-plus-sign" : "add_scale"
    "click .scale .icon-remove-sign" : "remove_scale"

  initialize: (options) ->
    _.bindAll(this, "render")
    @clone = options.clone
    @event_list_sync = [false, false, false, false, false, false]
    @combine_event_list_sync = [false, false, false, false, false, false]
    @scales = _.map(@model.get("scales").split('|'), (x)->{scale_startdate:x.split(":")[0], scale_value:x.split(":")[1]})
    if @model.get("combine_attributes")? and @model.get("combine_attributes").scales?
      @combine_scales = _.map(@model.get("combine_attributes").scales.split('|'), (x)->{scale_startdate:x.split(":")[0], scale_value:x.split(":")[1]})
    else
      @combine_scales = [{sale_startdate:"1970-01-01", scale_value:"1.0"}]

    @init_bind()

  init_bind: () ->
    clone = @clone
    model = @model
    $(@el).on('hidden', () ->
      $(this).remove()
      if clone? and not model.id?
        model.set(clone.attributes)
        Instances.Collections.metrics.remove(clone)
        Instances.Collections.metrics.add(model)
    )

  render: () ->
    attributes = _.clone(@model.attributes)
    attributes.is_clone = @clone?
    $(@el).html(@template(attributes))
    $(@el).modal().css({
      'width': 'auto'
      'min-width': '800px'
      'margin-left': () -> -($(this).width() / 2)
    })
#    $(@el).find('.event-key-select').chosen() #todo catch error
    @render_scale(@scales, ".scales")
    @render_scale(@combine_scales, ".combine-scales")

    @render_datepicker()

    this

  render_datepicker: () ->
    el = @el
    $(el).find('.datepicker').datepicker({format: 'yyyy-mm-dd'}).on('changeDate', (ev) ->
      $(el).find('.datepicker').datepicker('hide')
      $(el).find('.datepicker').blur()
    )

  render_scale: (scales, target) ->
    scales = _.uniq(_.sortBy(scales, (x)-> x.scale_startdate),true,(x)->x.scale_startdate)
    $(@el).find(target+" .controls").remove()
    for scale in scales
      $(@el).find(target).append(JST["backbone/templates/metrics/metric_scale"]({
        target: if target == ".scales" then "scales" else "combine_attributes[scales]"
        index:scales.indexOf(scale),
        length: scales.length
        scale_startdate:scale.scale_startdate,
        scale_value:scale.scale_value}))
    @render_scale_datepicker()

  render_scale_datepicker: ()->
    el = @el
    _this = @
    $(el).find('.scale .datepicker').datepicker({format: 'yyyy-mm-dd'}).on('changeDate', (ev) ->
      $(el).find('.datepicker').datepicker('hide')
      $(el).find('.datepicker').blur()
      is_combine = $(ev.currentTarget).parent().parent().hasClass("combine-scales")
      if not is_combine
        scales =  $(el).find('form').toJSON().scales
        _this.render_scale(scales, ".scales")
      else
        combine_scales =  $(el).find('form').toJSON().combine_attributes.scales
        _this.render_scale(combine_scales, ".combine-scales")
    )

  remove_scale: (ev) ->
    index = $(ev.currentTarget).attr("index")
    is_combine = $(ev.currentTarget).parent().parent().hasClass("combine-scales")
    $(ev.currentTarget).parent().remove()
    if not is_combine
      scales = _.compact($(@el).find('form').toJSON().scales)
      @render_scale(scales, ".scales")
    else
      combine_scales = _.compact($(@el).find('form').toJSON().combine_attributes.scales)
      @render_scale(combine_scales, ".combine-scales")

  add_scale: (ev) ->
    is_combine = $(ev.currentTarget).parent().parent().hasClass("combine-scales")
    if not is_combine
      scales =  $(@el).find('form').toJSON().scales
      last_date = Analytics.Utils.formatUTCDate(Analytics.Utils.parseUTCDate(scales[scales.length-1].scale_startdate, 86400000), "YYYY-MM-DD")
      scales.push({scale_startdate:last_date, scale_value:"1.0"})
      @render_scale(scales, ".scales")
    else
      combine_scales = $(@el).find('form').toJSON().combine_attributes.scales
      last_date = Analytics.Utils.formatUTCDate(Analytics.Utils.parseUTCDate(combine_scales[combine_scales.length-1].scale_startdate, 86400000), "YYYY-MM-DD")
      combine_scales.push({scale_startdate:last_date, scale_value:"1.0"})
      @render_scale(combine_scales, ".combine-scales")

  submit: () ->
    if Analytics.Utils.checkFormFields($(@el).find('form'))
      update = @model.id?
      is_clone = @clone?
      el = @el
      @model.save(@form_attributes(), {
        wait: true,
        success: (model, resp) ->
          $(el).modal('hide')
          if not update
            model.collection.add(model)
            if is_clone
              model.list_item_view.render()
            else
              model.list_view.add_metric(model.id)
          else
            model.list_item_view.render()
        error: (xhr, options, error) ->
          $(el).modal('hide')
      })

  form_attributes: ()->
    form = $(@el).find('form').toJSON()
    form_attributes = _.clone(form)

    form_attributes.scales = @serialize_scales(form.scales)
    form_attributes.combine_attributes.scales = @serialize_scales(form.combine_attributes.scales)

    form_attributes

  serialize_scales: (scales) ->
    s = ""
    for scale in  _.sortBy(scales, (x)->x.scale_startdate)
      s += scale["scale_startdate"]+":"+parseFloat(scale["scale_value"]).toString()+"|"

    s = s[0..-2] # remove the tail "|"

    s

  cancel : () ->
    $(@el).modal('hide')

  event_input_focus : (ev) ->
    if @model.get("project_id")?
      level = parseInt($(ev.currentTarget).attr("level"))
      combine = $(ev.currentTarget).attr("combine")
      if combine == "0"
        event_list_sync = @event_list_sync
        event_list_sync_el = ".event-list-sync"
        params = @event_list_params("l"+level, false)
      else
        event_list_sync = @combine_event_list_sync
        event_list_sync_el = ".event-list-sync-combine"
        params = @event_list_params("l"+level, true)

      if not event_list_sync[level]
        $(event_list_sync_el).show()
        if $(ev.currentTarget).data('typeahead')?
          $(ev.currentTarget).data('typeahead').source = []
        element = ev.currentTarget
        jQuery.post("/projects/"+@model.get("project_id")+"/event_item", params, (data) ->
          if $(element).data('typeahead')?
            $(element).data('typeahead').source = data
          else
            $(element).typeahead({source: data})
          $(event_list_sync_el).hide()
          event_list_sync[level] = true
        ).error((xhr,options,error) ->
          $(event_list_sync_el).hide()
          event_list_sync[level] = true
        )

  event_input_change : (ev) ->
    level = parseInt($(ev.currentTarget).attr("level"))
    combine = $(ev.currentTarget).attr("combine")
    if @model.get("project_id")? and level < 5
      for i in [level+1..5]
        $(@el).find('form .event-input[level='+i+'][combine="'+combine+'"]').val("*")
        if combine == "0"
          @event_list_sync[i] = false
        else
          @combine_event_list_sync[i] = false

  event_list_params : (target_row, combine) ->
    form_object = $(@el).find('form').toJSON()
    params = {target_row : target_row, condition : {}, id : @model.get("project_id")}
    for i in [0..5]
      if combine
        params.condition["l"+i] = form_object['combine_attributes']['event_key_'+i]
      else
        params.condition["l"+i] = form_object['event_key_'+i]
    params

  toggle_combine : (ev) ->
    if $(ev.currentTarget).find(":selected").val() == ""
      $(@el).find('#combine-fields').hide()
      $(@el).find('#metric_combine_attributes__destroy').val(1)
    else
      $(@el).find('#combine-fields').show()
      $(@el).find('#metric_combine_attributes__destroy').val(0)

  change_value_type:(ev) ->
    $(@el).find('button.type-btn').removeClass('active')
    $(ev.currentTarget).addClass('active')
    $(@el).find("#value-type").val($(ev.currentTarget).attr("value"))

  change_filter: (ev) ->
    identifier = $(ev.currentTarget).attr("identifier")
    filter = $(@el).find(".filter."+identifier)
    input = $(filter).find("input")
    if $(ev.currentTarget).find(":selected").val() == ""
      $(filter).removeClass("should-check should-check-empty should-check-float should-check-pattern")
      $(input).removeAttr("pattern")
      $(input).hide()
    else
      $(filter).addClass("should-check")
      $(input).addClass("should-check-empty")
      if $(ev.currentTarget).find(":selected").val() == "BETWEEN"
        $(input).removeClass("should-check-float")
        $(input).addClass("should-check-pattern")
        $(input).attr("pattern", "^[0-9]+,[0-9]+$")
        $(input).attr("placeholder", I18n.t("templates.metrics.form.filter_between_placeholder"))
        $(input).show()
      else
        $(input).addClass("should-check-float")
        $(input).removeClass("should-check-pattern")
        $(input).removeAttr("pattern")
        $(input).attr("placeholder", "")
        $(input).show()
