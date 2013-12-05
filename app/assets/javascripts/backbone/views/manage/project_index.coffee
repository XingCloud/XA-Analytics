Analytics.Views.Manage ||= {}
class Analytics.Views.Manage.ProjectIndexView extends Backbone.View
  template: JST["backbone/templates/manage/project_index"]
  events:
#    "click .list-project .dropdown-toggle": "dropdown_toggle"
    "click li .project-item": "click_project_item"
    "click a.add-to-project" : "add_user_to_project"
    "click .project-search" : "click_search"
    "click a.add-to-user" : "add_project_to_user"
    "click a.remove-project-user" : "remove_user_from_project"
    "click a.edit-project-user" : "edit_project_user"
    "click a.remove-project" : "remove_project"
    "mouseover .project-list .project" : "highlight_project"
    "keyup .project-search input" : "keyup_toggle"
    "keydown .project-search input" : "keydown_toggle"
    "hidden .modal" : "remove_modal"
    "click .modal a.submit" : "update_project_user"
    "click li.pre.enabled a" : "pre_page"
    "click li.nex.enabled a" : "nex_page"


  initialize: ()->
    _.bindAll(this, "render", "redraw") # need context to be set to this for "@project_users.bind "all", @redraw" can work
    @current_project = Instances.Collections.UserProjects.models[0]
    @change_project(@current_project.get("project_id"),false)

  render: ()->
    @calc_page()
    $(@el).html(@.template({
        current_project:@current_project,
        user_projects:Instances.Collections.UserProjects,
        project_users:@project_users.models
        page: @page
        max_page: @max_page
      }))
    $("#container").html(@el)

  redraw: () ->
    @remove()
    @render()
    @delegateEvents(@events)

  click_project_item: (ev) ->
    @change_project(parseInt($(ev.currentTarget).attr("project_id")))

  add_user_to_project: (ev) ->
    email = $("#email").val()
    role =  $("#role").val()
    project_user = new Analytics.Models.ProjectUser({email:email, role:role, project_id: @current_project.get("project_id")},{project_id:@current_project})
    project_users = @project_users
    project_user.save({}, {wait:true, success: (model ,resp) ->
      project_users.add(model)
    })

  remove_user_from_project: (ev) ->
    id = $(ev.currentTarget).attr("value")
    project_user = @project_users.get(id) # collection ProjectUser id is user_id, ref ProjectUser
    if confirm(I18n.t('commons.confirm_delete'))
      project_user.destroy({wait: true})

  edit_project_user: (ev)->
    id = $(ev.currentTarget).attr("value")
    @current_edit_project_user = @project_users.get(id)
    $(@el).append(JST["backbone/templates/manage/project_user_form"]({project_user:@current_edit_project_user}))
    $(@el).find(".modal").modal().css({
      "min-width":"300px"
      'margin-left': () -> -($(this).width() / 2)
    })

  update_project_user: (ev)->
    role = $(@el).find(".modal .role").val()
    $(@el).find(".modal").modal("hide")
    @current_edit_project_user.save({role:role}, {
      success:()->
    })

  add_project_to_user: (ev) ->  # create a project and add to this user
    name = $(@el).find("form.new-project .name").val()
    identifier = $(@el).find("form.new-project .identifier").val()
    user_project = new Analytics.Models.UserProject({name:name, identifier:identifier})
    user_project.save({},{
      success: () ->
        window.location.reload()
    })

  remove_project:(ev)->
    if confirm(I18n.t('commons.confirm_delete'))
      @current_project.destroy({wait:true}, {
        success:()->
          window.location.reload()
      })

  click_search: (ev) ->
    ev.stopPropagation()

  dropdown_toggle: (ev) ->
    ev.stopPropagation()
    dropdown = $(@el).find(".dropdown")
    if dropdown.hasClass("open")
      dropdown.removeClass("open")
    else
      dropdown.addClass("open")
      dropdown.find(".project-search input").focus()


  change_project: (project_id, redraw=true) ->
    if project_id != @current_project.get("project_id") or not @project_user?
      @current_project = _.find(Instances.Collections.UserProjects.models,(x)->x.get("project_id") == project_id)
      @project_users = new Analytics.Collections.ProjectUsers([],{project:{id:@current_project.get("project_id")}})
      @project_users.fetch({
        async: false
        reset: true
      })
      @project_users.bind "all", @redraw
      @page = 1
      if redraw
        @redraw()

  keyup_toggle: (ev) ->
    switch ev.keyCode
      when 40 then break
      when 38 then break
      when 13 then break
      else @filter_project(ev)

  keydown_toggle: (ev) ->
    switch ev.keyCode
      when 40 then @highlight_next_project()
      when 38 then @highlight_prev_project()
      when 13 then @confirm_search(ev)

  confirm_search: (ev)->
    selected_project = $(@el).find(".project-list .project.selected")
    if selected_project.length > 0
      @change_project(parseInt(selected_project.attr("project_id")))

  highlight_next_project: () ->
    all_display_projects = $(@el).find(".project-list .project").not(".hide")
    selected_project = $(@el).find(".project-list .project.selected")
    new_selected_project = all_display_projects.first()
    if selected_project.length > 0  # it must be 1
      selected_project.removeClass("selected")
      index = all_display_projects.index(selected_project)
      if index != all_display_projects.length - 1
        new_selected_project = $(all_display_projects.get(index + 1))
    @highligh_project_with_scroll(new_selected_project)

  highlight_prev_project: () ->
    all_display_projects = $(@el).find(".project-list .project").not(".hide")
    selected_project = $(@el).find(".project-list .project.selected")
    new_selected_project = all_display_projects.first()
    if selected_project.length > 0
      selected_project.removeClass("selected")
      index = all_display_projects.index(selected_project)
      if index != 0
        new_selected_project = $(all_display_projects.get(index - 1))
      else
        new_selected_project = all_display_projects.last()
    @highligh_project_with_scroll(new_selected_project)

  filter_project: () ->
    $(@el).find(".project-list .projects-no-match").addClass("hide")
    filter = $(@el).find(".project-search input").val()
    if filter? and filter.length > 0
      filter = filter.toLowerCase()
      no_data = true
      $(@el).find(".project-list .project").each((index, project) ->
        name = $(project).attr("name").toLowerCase()
        identifier = $(project).attr("identifier").toLowerCase()
        contains = (name.indexOf(filter) != -1 or identifier.indexOf(filter) != -1)
        if contains
          no_data = false
        if not contains and not $(project).hasClass('hide')
          $(project).addClass("hide")
        else if contains and $(project).hasClass('hide')
          $(project).removeClass("hide")
      )
      if no_data
        $(@el).find(".project-list .projects-no-match").removeClass("hide")
    else
      $(@el).find(".project-list .project").removeClass("hide")
    @highlight_first_project()

  highlight_project: (ev) ->
    $(@el).find(".project-list .project").removeClass("selected")
    $(ev.currentTarget).addClass("selected")

  highligh_project_with_scroll: (project) ->
    project.addClass("selected")
    maxHeight = parseInt($(@el).find(".project-list").css("height"), 10)
    visible_top = $(@el).find(".project-list").scrollTop()
    visible_bottom = maxHeight + visible_top
    high_top = project.position().top + visible_top
    high_bottom = high_top + project.outerHeight()
    if high_bottom >= visible_bottom
      $(@el).find(".project-list").scrollTop((if high_bottom > maxHeight then high_bottom - maxHeight else 0))
    else if high_top < visible_top
      $(@el).find(".project-list").scrollTop(high_top)

  highlight_first_project: () ->
    $(@el).find(".project-list .project").removeClass("selected")
    new_selected_project = $(@el).find(".project-list .project").not(".hide").first()
    if new_selected_project.length > 0
      @highligh_project_with_scroll(new_selected_project)

  remove_modal: ()->
    $(@el).find(".modal").remove()

  pre_page: (ev) ->
    @page = @page - 1
    @redraw()

  nex_page: (ev) ->
    @page = @page + 1
    @redraw()

  calc_page: () ->
    @max_page = (if @project_users.length == 0 then 1 else Math.ceil(@project_users.length / 100))
    if @page > @max_page
      @page = @max_page