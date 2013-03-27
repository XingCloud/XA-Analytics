Analytics.Views.Projects ||= {}
class Analytics.Views.Projects.HeaderView extends Backbone.View
  template: JST["backbone/templates/projects/header"]
  el: ".navbar .project-select"
  events:
    "click .dropdown-toggle": "dropdown_toggle"
    "click .project-search input" : "click_search"
    "mouseover .project-list .project" : "highlight_project"
    "keyup .project-search input" : "keyup_toggle"
    "keydown .project-search input" : "keydown_toggle"

  initialize: (options) ->
    _.bindAll this, "render"
    @project = options.project
    @projects = []
    @fetched = false

  render: () ->
    $(@el).html(@template({
      project: @project
      fetched: @fetched
      projects: @projects
    }))
    if not @fetched
      @fetch()

  fetch: () ->
    view = this
    Analytics.Request.get({
      url: "/projects_summary"
      success: (data, status, jqXHR) ->
        view.projects = data
        view.fetched = true
        view.render()
    })

  dropdown_toggle: (ev) ->
    ev.stopPropagation()
    if $(@el).hasClass("open")
      $(@el).removeClass("open")
    else
      $(@el).addClass("open")
      $(@el).find(".project-search input").focus()

  click_search: (ev) ->
    ev.stopPropagation()

  keyup_toggle: (ev) ->
    switch ev.keyCode
      when 40 then break
      when 38 then break
      when 13 then break
      else @filter_project()

  keydown_toggle: (ev) ->
    switch ev.keyCode
      when 40 then @highlight_next_project()
      when 38 then @highlight_prev_project()
      when 13 then @select_project(ev)

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

  select_project: (ev) ->
    selected_project = $(@el).find(".project-list .project.selected")
    if selected_project.length > 0
      identifier = selected_project.attr("identifier")
      location.href = "/projects/" + identifier

  highlight_next_project: () ->
    all_display_projects = $(@el).find(".project-list .project").not(".hide")
    selected_project = $(@el).find(".project-list .project.selected")
    new_selected_project = all_display_projects.first()
    if selected_project.length > 0
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

  highlight_first_project: () ->
    $(@el).find(".project-list .project").removeClass("selected")
    new_selected_project = $(@el).find(".project-list .project").not(".hide").first()
    if new_selected_project.length > 0
      @highligh_project_with_scroll(new_selected_project)

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

  highlight_project: (ev) ->
    $(@el).find(".project-list .project").removeClass("selected")
    $(ev.currentTarget).addClass("selected")