Analytics.Views.ProjectUsers ||= {}

class Analytics.Views.ProjectUsers.FormView extends Backbone.View
  template: JST["backbone/templates/project_users/form"]
  className: "modal"
  events:
    "click a.btn.submit" : "submit"
    "change select#role" : "toggle_reports_picker"
    "click .report-display" : "toggle_access_report"
    "hidden" : "hidden"
    
  initialize: (options)->
    _.bindAll this, "render"
    @model.view = this
    @report_ids = _.clone(@model.get("privilege").report_ids) #拷贝一份出来操作,submit时才替换回去

  render:() ->
    $(@el).html(@template({model:@model, report_ids:@report_ids}))

    $(@el).modal().css({
      "min-width":"800px"
      'margin-left': () -> -($(this).width() / 2)
    })

    $(@el).find("select").change()

  submit: () ->
    @model.get("privilege").report_ids = _.uniq(_.map(@report_ids, (x)->parseInt(x)))
    form = $(@el).find("form").toJSON()
    model = @model
    @model.save(form, {wait:true, silent:true,  success: (model, resp) ->
      $(model.view.el).modal('hide')
      model.trigger("change")
    })

  toggle_reports_picker: (ev) ->
    if $(@el).find("select option:selected").attr("value") == "normal"
      $(@el).find("#access-reports-picker").hide()
    else
      $(@el).find("#access-reports-picker").show()

  toggle_access_report: (ev) ->
    target = $(ev.currentTarget)
    report_id = parseInt(target.attr("report_id"))
    if target.hasClass("access")
      @report_ids = _.without(@report_ids, report_id)
      target.removeClass("access")
    else
      @report_ids.push(report_id)
      target.addClass("access")

  hidden: (ev) ->
    @remove()