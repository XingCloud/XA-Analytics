Analytics.Views.MaintenancePlans ||= {}

class Analytics.Views.MaintenancePlans.FormView extends Backbone.View
  template: JST["backbone/templates/maintenance_plans/form"]
  className: "modal maintenance-plan-form"
  events:
    "click a.maintenance-plan-submit": "submit"
    "change input.keep-running-checkbox": "change_keep_running"

  initialize: () ->
    _.bindAll this, "render"

  render: () ->
    $(@el).html(@template(@model.attributes))
    @render_datepicker()
    $(@el).modal()
    console.log(@parse_time(".begin.controls"))

  render_datepicker: () ->
    el = @el
    $(el).find('.datepicker').datepicker({format: 'yyyy-mm-dd'}).on('changeDate', (ev) ->
      $(el).find('.datepicker').datepicker('hide')
      $(el).find('.datepicker').blur()
    )

  parse_time: (element) ->
    date = $(@el).find(element + " input.datepicker").val()
    hour = $(@el).find(element + " select.hour option:selected").val()
    minute = $(@el).find(element + " select.minute option:selected").val()
    new Date(moment(date + " " + hour + ":" + minute + ":00", "YYYY-MM-DD HH:mm:ss").unix() * 1000)

  submit: () ->
    el = @el
    if Analytics.Utils.checkFormFields($(@el).find("form"))
      form = $(@el).find("form").toJSON()
      begin_at = @parse_time(".begin.controls")
      end_at = @parse_time(".end.controls")
      if end_at.getTime() > begin_at.getTime()
        form["begin_at"] = begin_at
        form["end_at"] = end_at
        update = @model.id?
        @model.save(form, {
          wait: true
          success: (model, resp) ->
            if not update
             Instances.Collections.maintenance_plans.add(model)
            $(el).modal("hide")
          error: (xhr, options, error) ->
            $(el).modal("hide")
        })
      else
        alert("结束时间不能小于起始时间")

  change_keep_running: (ev) ->
    is_checked = $(@el).find("input.keep-running-checkbox").is(":checked")
    if is_checked
      $(@el).find("input.keep-running").val(1)
    else
      $(@el).find("input.keep-running").val(0)