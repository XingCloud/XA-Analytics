Analytics.Views.ReportCategories ||= {}

class Analytics.Views.ReportCategories.FormView extends Backbone.View
  model: Analytics.Models.ReportCategory
  template: JST['backbone/templates/report_categories/report_category_form']
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
    if Analytics.Utils.checkFormFields($(@el).find('form'))
      if @model.id?
        @model.save($("#edit_report_category_form_"+@model.id).toJSON(), {wait: true, success: (model, resp) ->
          model.form.remove()
          Analytics.Utils.actionFinished()
        })
      else
        @model.save($("#new_report_category_form").toJSON(), {wait: true, success: (model, resp) ->
          Instances.Collections.report_categories.add(model)
          model.form.remove()
          Analytics.Utils.actionFinished()
        })


  cancel: () ->
    @remove()
    Analytics.Utils.actionFinished()
