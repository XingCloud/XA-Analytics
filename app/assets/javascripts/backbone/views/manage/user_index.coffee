Analytics.Views.Manage ||= {}
class Analytics.Views.Manage.UserIndexView extends Backbone.View
  template: JST["backbone/templates/manage/user_index"]
  events:
    "click a.remove-user" : "remove_user"
    "click a.edit-user" : "edit_user"
    "click a.search" : "search"
    "click a.list-unapproved" : "list_unapproved"
    "click li.pre.enabled a" : "pre_page"
    "click li.nex.enabled a" : "nex_page"
    "keyup .form-search input" : "keyup_toggle"
    "change input#approved-checkbox": "change_approved"
    "click .modal a.submit" : "update_user"
    "hidden .modal" : "remove_modal"


  initialize: ()->
    _.bindAll(this, "render", "redraw")
    Instances.Collections.Users = new Analytics.Collections.Users();
    Instances.Collections.Users.fetch({
      async: false
      reset: true
    })
    @users = Instances.Collections.Users
    @users.bind "all", @redraw
    @page = 1
    @show_unapproved = false

  render: ()->
    @calc_page()
    $(@el).html(@.template({
      users: @users_to_show()
      filter_value: @filter_value
      unapproved: @unapproved
      page: @page
      max_page: @max_page
    }))
    $("#container").html(@el)
    $(".form-search input").focus()

  redraw: ()->
    @remove()
    @render()
    @delegateEvents(@events)

  search: (ev) ->
    @filter_value = $(".form-search input").val().trim()
    @redraw()

  keyup_toggle: (ev) ->
    switch ev.keyCode
      when 13 then @search(ev)

  list_unapproved:()->
    @show_unapproved = not @show_unapproved
    @search()

  users_to_show: ()->
    _this = @
    if @filter_value and @filter_value != ""
      models = _.filter(@users.models, (x) -> x.get("name").indexOf(_this.filter_value)!=-1 or x.get("email").indexOf(_this.filter_value)!=-1 or x.get("role").indexOf(_this.filter_value)!=-1)
    else
      models = @users.models

    @unapproved = _.filter(models, (x)->x.get("approved") == false).length
    if @show_unapproved
      _.filter(models, (x)->x.get("approved") == false)
    else
      models

  edit_user: (ev)->
    id = $(ev.currentTarget).attr("value")
    @current_edit_user = @users.get(id)
    $(@el).append(JST["backbone/templates/manage/user_form"]({user:@current_edit_user}))
    $(@el).find(".modal").modal().css({
      "min-width":"300px"
      'margin-left': () -> -($(this).width() / 2)
    })

  change_approved: (ev)->
    if $(ev.currentTarget)[0].checked
      $('#approved').val(1)
    else
      $('#approved').val(0)

  update_user: (ev)->
    role = $(@el).find(".modal .role").val()
    approved = $(@el).find(".modal #approved").val()
    $(@el).find(".modal").modal("hide")
    @current_edit_user.save({role:role, approved:approved}, {
      success:()->
    })

  remove_user: (ev) ->
    id = $(ev.currentTarget).attr("value")
    user = @users.get(id)
    if confirm(I18n.t('commons.confirm_delete'))
      user.destroy({wait: true})

  remove_modal: ()->
    $(@el).find(".modal").remove()

  pre_page: (ev) ->
    @page = @page - 1
    @redraw()

  nex_page: (ev) ->
    @page = @page + 1
    @redraw()

  calc_page: () ->
    ret = @users_to_show()
    @max_page = (if ret.length == 0 then 1 else Math.ceil(ret.length / 50))
    if @page > @max_page
      @page = @max_page




