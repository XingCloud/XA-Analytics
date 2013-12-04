Analytics.Views.Manage ||= {}
class Analytics.Views.Manage.UserIndexView extends Backbone.View
  template: JST["backbone/templates/manage/user_index"]
  events:
    "click a.remove-user" : "remove_user"
    "click a.edit-user" : "edit_user"
    "click a.search" : "search"
    "click li.pre.enabled a" : "pre_page"
    "click li.nex.enabled a" : "nex_page"
    "keyup .form-search input" : "keyup_toggle"


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

  render: ()->
    @calc_page()
    $(@el).html(@.template({
      users: @users_to_show()
      page: @page
      max_page: @max_page
    }))
    $("#container").html(@el)

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

  users_to_show: ()->
    _this = @
    if @filter_value and @filter_value != ""
      _.filter(@users.models, (x) -> x.get("name").indexOf(_this.filter_value)!=-1 or x.get("email").indexOf(_this.filter_value)!=-1 or x.get("role").indexOf(_this.filter_value)!=-1)
    else
      @users.models

  edit_user: (ev)->
    id = $(ev.currentTarget).attr("value")
    @current_edit_user = @users.get(id)
    $(@el).append(JST["backbone/templates/manage/project_user_form"]({project_user:@current_edit_user}))
    $(@el).find(".modal").modal().css({
      "min-width":"300px"
      'margin-left': () -> -($(this).width() / 2)
    })

  update_user: (ev)->
    role = $(@el).find(".modal .role").val()
    $(@el).find(".modal").modal("hide")
    @current_edit_user.save({role:role}, {
      success:()->
    })

  remove_user: (ev) ->
    id = $(ev.currentTarget).attr("value")
    user = @users.get(id)
    if confirm(I18n.t('commons.confirm_delete'))
      user.destroy({wait: true})


  pre_page: (ev) ->
    @page = @page - 1
    @redraw()

  nex_page: (ev) ->
    @page = @page + 1
    @redraw()

  calc_page: () ->
    ret = @users_to_show()
    @max_page = (if ret.length == 0 then 1 else Math.ceil(ret.length / 100))
    if @page > @max_page
      @page = @max_page




