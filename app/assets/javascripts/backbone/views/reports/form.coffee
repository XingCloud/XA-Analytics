Analytics.Views.Reports ||= {}
#Analytics.Models.Report
class Analytics.Views.Reports.FormView extends Backbone.View
  template: JST['backbone/templates/reports/form']
  events:
    "click li#tab-add" : "add_tab"
    "click a#submit" : "check_submit"
    "click a#cancel" : "cancel"


  initialize: (options) ->
    _.bindAll this, "render", "validate_date_range"
    @model.form = this
    @index = 0
    @count = 0
    @tabHeaders = []
    @tabBodies = []
    XA.action("click.report.edit")

  render: () ->
    $(@el).html(@template(@model.attributes))
    for report_tab_attributes in @model.get("report_tabs_attributes")
      report_tab = Instances.Collections.report_tabs.get(report_tab_attributes.id)
      @do_add_tab(report_tab, @index == @model.report_tab_index)
    if @model.get("report_tabs_attributes").length == 0
      @do_add_tab(new Analytics.Models.ReportTab({project_id: @model.get("project_id")}), true)
    $('#main-container').html(@el)

  add_tab: (ev) ->
    report_tab = new Analytics.Models.ReportTab({project_id: @model.get("project_id")})
    @remove_tab_active_class()
    @do_add_tab(report_tab, true)

  close_tab: (report_tab, tab_header_view) ->
    if @count > 1
      tab_header_view.remove()
      if report_tab.id?
        $(tab_header_view.body.el).hide()
      else
        tab_header_view.body.remove()
      if $(tab_header_view.el).hasClass('active')
        @active_first_tab()
      @count = @count - 1
      for header, i in @tabHeaders
        if header is tab_header_view
          @tabHeaders.splice(i, 1)
          break
      for body, i in @tabBodies
        if body is report_tab
          @tabBodies.splice(i ,1)
          break

  remove_tab_active_class: () ->
    $(@el).find('ul li.tab-header').removeClass('active')
    $(@el).find('.tab-pane').removeClass('active')

  active_first_tab: () ->
    @remove_tab_active_class()
    $(@el).find('ul li.tab-header').first().addClass('active')
    index = $(@el).find('ul li.tab-header a').first().attr('value')
    $(@el).find('#report_tab_'+index).addClass('active')

  do_add_tab: (report_tab, active) ->
    report_tab.index = @index
    header = new Analytics.Views.ReportTabs.FormHeaderView({
      id: "report_tab_"+@index+"_header",
      className: (if active then "active tab-header" else 'tab-header'),
      model: report_tab,
    })
    header.report_form = this
    body = new Analytics.Views.ReportTabs.FormBodyView({
      id: "report_tab_"+@index,
      className: (if active then "active tab-pane" else 'tab-pane'),
      model: report_tab,
    })
    body.report_form = this
    header.body = body
    $(@el).find('li#tab-add').before(header.render().el)
    $(@el).find('.tab-content').append(body.render().el)
    @index = @index + 1
    @count = @count + 1
    @tabHeaders.push(header)
    @tabBodies.push(body)

  check_submit: () ->
    ret = @validate_date_range()
    if ret.result
      @submit()

  submit: () ->
    if Analytics.Utils.checkFormFields($(@el).find('form'))
      update = @model.id?
      @model.report_tab_index = parseInt($(@el).find('ul li.tab-header.active a').attr("value"))
      @model.save(@form_attributes(), {wait: true, success: (model ,resp) ->
        if not update
          model.collection.add(model)
        else
          model.collection.trigger("change")

        model.form.remove()
        if model.get("project_id")?
          Analytics.Utils.redirect("reports/" + model.id)
        else
          Analytics.Utils.actionFinished()
      })

  cancel: () ->
    @remove()
    Analytics.Utils.actionFinished()

  form_attributes: () ->
    form = $(@el).find('form').toJSON()
    report_tabs_attributes = form.report_tabs_attributes
    form_attributes = _.clone(form)
    form_attributes.report_tabs_attributes = []
    _.each(report_tabs_attributes, (report_tab_attributes) ->
      if report_tab_attributes?
        form_attributes.report_tabs_attributes.push(report_tab_attributes)
    )
    form_attributes

  ## 检查选择的range是否合法。
  ## return {result: true/false, message: error message}
  validate_date_range: () ->
    @clear_error()
    index = -1
    result = {}
    _.each(@tabBodies, (body, i) ->
      if(index != -1)
        return
      ret = body.validate_date_range()
      if !ret.result
        result = ret
        index = i
    )

    if(index != -1)
      $(@el).find("#report_tab_"+index+"_header a span").click() #show what's happening
      tab = $(@el).find("#report_tab_"+index)
      if(tab.find("#advanced-options").css("display")=="none")
        tab.find("#toggle-advanced-options").click()

      return result
    else
      return ret =
        result: true


  clear_error: () ->
    $(@el).find(".error").removeClass("error")
    $(@el).find("span.error-message").text("")

