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
    if @model.get("atype") != "sql_bigint" and @model.get("atype") != "sql_datetime"
      $(@el).find(".control-group.gpattern").hide()
    $(@el).modal()

  change_type: () ->
    type = $(@el).find("select.atype option:selected").attr("value")
    if type == "sql_bigint"
      $(@el).find(".control-group.gpattern .controls input").attr("placeholder", "0,5,10,20,50,100")
      $(@el).find(".control-group.gpattern .controls input").attr("pattern", "^\\d+(,\\d+)*$")
      $(@el).find(".control-group.gpattern .controls p.help-block").text(I18n.t('templates.user_attributes.form.shard_rule_int_helper'))
      $(@el).find(".control-group.gpattern").show()
    else if type == "sql_datetime"
      $(@el).find(".control-group.gpattern .controls input").attr("placeholder", "2012-10-13,2012-11-14")
      $(@el).find(".control-group.gpattern .controls input").attr("pattern", "^\\d{4}-((0\\d)|(1[012]))-(([012]\\d)|3[01])(,\\d{4}-((0\\d)|(1[012]))-(([012]\\d)|3[01]))*$")
      $(@el).find(".control-group.gpattern .controls p.help-block").text(I18n.t('templates.user_attributes.form.shard_rule_date_helper'))
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
