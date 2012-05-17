class Analytics.Routers.ReportCategoriesRouter extends Backbone.Router
  routes:
    "/report_categories/new" : "new"
    "/report_categories/:id/edit" : "edit"
    "/report_categories/:id/delete" : "delete"
    "/report_categories/:id/shift_up" : "shift_up"
    "/report_categories/:id/shift_down" : "shift_down"

  initialize: (options) ->
    @project = options.project
    @categories = new Analytics.Collections.ReportCategories(options.categories)
    if @project?
      @templates = new Analytics.Collections.ReportCategories(options.templates)

  new: () ->
    if @project?
      report_category = new Analytics.Models.ReportCategory({project_id : @project.id})
    else
      report_category = new Analytics.Models.ReportCategory()
    new Analytics.Views.ReportCategories.FormView({model: report_category, id : "new_report_category"}).render()

  edit: (id) ->
    category = @categories.get(id)
    if category?
      new Analytics.Views.ReportCategories.FormView({model: category, id : "edit_report_category"+id}).render()
    else
      window.location.href = "#/404"

  delete: (id) ->
    category = @categories.get(id)
    if category? and confirm("确认删除分类"+category.get("name"))
      category.destroy({wait: true, success : (model, resp) ->
          reports_router.reports.each((report) ->
            if report.get("report_category_id") == model.id
              report.set({report_category_id : null}, {silent: true})
          )
          reports_router.reports.trigger('change')
          window.location.href = "#/reports"
        }
      )
    else
      window.location.href = "#/404"

  shift_up: (id) ->
    category = @categories.get(id)
    if category?
      category.shift("up", {success: (resp, status, xhr) ->
        window.location.href = "#/reports"
      })
    else
      window.location.href = "#/404"

  shift_down: (id) ->
    category = @categories.get(id)
    if category?
      category.shift("down", {success: (resp, status, xhr) ->
        window.location.href = "#/reports"
      })
    else
      window.location.href = "#/404"