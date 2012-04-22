Analytics.Views.ReportCategories ||= {}

class Analytics.Views.ReportCategories.FormView extends Backbone.View
  model: Analytics.Models.ReportCategory
  template: JST['backbone/templates/report_categories/form']
  events:
    "click #report_category_submit" : "submit"
    "click #report_category_cancel" : "cancel"

  initialize: () ->
    _.bindAll(this, "render")
    @model.form = this

  render: () ->
    $(@el).html(@template(@model.attributes))
    $('#main-container').html($(@el))

  submit: () ->
    if @model.id?
      @model.save($("#edit_report_category_form_"+@model.id).toJSON(), {wait: true, success: (model, resp) ->
        model.form.remove()
        window.location.href = "#/reports"
      })
    else
      @model.save($("#new_report_category_form").toJSON(), {wait: true, success: (model, resp) ->
        reports_router.reports.categories.add(model)
        model.form.remove()
        window.location.href = "#/reports"
      })


  cancel: () ->
    @remove()
    window.location.href = "#/reports"
