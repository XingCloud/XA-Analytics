Analytics.Views.Metrics ||= {}
class Analytics.Views.Metrics.FormView extends Backbone.View
  template: JST['backbone/templates/metrics/form']
  className: 'modal'
  events:
    "click #metric-cancel" : "cancel"
    "click #metric-submit" : "submit"
    "focus input.event-input" : "event_input_focus"
    "change input.event-input" : "event_input_change"
    "change select#metric_combine_action" : "toggle_combine"

  initialize: (options) ->
    _.bindAll(this, "render")
    @clone = options.clone
    @event_list_sync = [false, false, false, false, false, false]
    @combine_event_list_sync = [false, false, false, false, false, false]
    @init_bind()

  init_bind: () ->
    clone = @clone
    model = @model
    $(@el).on('hidden', () ->
      $(this).remove()
      if clone? and not model.id?
        model.set(clone.attributes)
        metrics_router.templates.remove(clone)
        metrics_router.templates.add(model)
    )

  render: () ->
    attributes = _.clone(@model.attributes)
    attributes.is_clone = @clone?
    $(@el).html(@template(attributes))
    $(@el).modal().css({
      'width': 'auto'
      'min-width': '750px'
      'margin-left': () -> -($(this).width() / 2)
    })
    $(@el).find('.event-key-select').chosen()

  submit: () ->
    if Analytics.Utils.checkFormFields($(@el).find('form'))
      form = $(@el).find('form').toJSON()
      update = @model.id?
      is_clone = @clone?
      el = @el
      @model.save(form, {wait: true, success: (model, resp) ->
        $(el).modal('hide')
        if not update
          model.collection.add(model)
          if is_clone
            model.list_item_view.render()
          else
            model.list_view.render_metric(model.id)
        else
          model.list_item_view.render()
      })

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
        jQuery.post("/projects/"+@model.get("project_id")+"/event_item", params, (data) ->
          if $(ev.currentTarget).data('typeahead')?
            $(ev.currentTarget).data('typeahead').source = data
          else
            $(ev.currentTarget).typeahead({source: data})
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