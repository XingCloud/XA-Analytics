Analytics.Views.UserAttributes ||= {}

class Analytics.Views.UserAttributes.FormView extends Backbone.View
  template: JST["backbone/templates/user_attributes/form"]
  className: "modal"
  events:
    "change select.atype": "change_type"
    "click a.btn.submit": "submit"

  initialize: (options) ->
    _.bindAll this, "render"
    @model.view = this

  render: () ->
    $(@el).html(@template(@model.attributes))
    if @model.get("atype") != "sql_bigint"
      $(@el).find(".control-group.gpattern").hide()
    $(@el).modal()

  change_type: () ->
    type = $(@el).find("select.atype option:selected").attr("value")
    if type == "sql_bigint"
      $(@el).find(".control-group.gpattern").show()
    else
      $(@el).find(".control-group.gpattern").hide()

  submit: () ->
    is_create = (not @model.id?)
    collection = @collection
    if Analytics.Utils.checkFormFields($(@el).find('form'))
      form = $(@el).find('form').toJSON()
      @model.save(form, {wait:true, success: (model ,resp) ->
        $(model.view.el).modal('hide')
        if is_create
          collection.add(model)
      })