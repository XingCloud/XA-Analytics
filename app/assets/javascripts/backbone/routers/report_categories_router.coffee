class Analytics.Routers.ReportCategoriesRouter extends Backbone.Router
  routes:
    "/report_categories/new" : "new"
    "/report_categories/:id/edit" : "edit"
    "/report_categories/:id/delete" : "delete"
    "/report_categories/:id/shift_up" : "shift_up"
    "/report_categories/:id/shift_down" : "shift_down"

  initialize: () ->

  new: () ->
    if Instances.Models.user.is_mgriant()
      window.location.href = "#/404"
      return
    last_category = Instances.Collections.report_categories.last()
    position = (if last_category? then last_category.get("position") + 1 else 0)
    if Instances.Models.project?
      report_category = new Analytics.Models.ReportCategory({
        project_id : Instances.Models.project.id
        position: position
      })
    else
      report_category = new Analytics.Models.ReportCategory({position: position})
    new Analytics.Views.ReportCategories.FormView({model: report_category, id : "new_report_category"}).render()

  edit: (id) ->
    if Instances.Models.user.is_mgriant()
      window.location.href = "#/404"
      return
    category = Instances.Collections.report_categories.get(id)
    if category? and not @is_system(category)
      new Analytics.Views.ReportCategories.FormView({model: category, id : "edit_report_category"+id}).render()
    else
      window.location.href = "#/404"

  delete: (id) ->
    if Instances.Models.user.is_mgriant()
      window.location.href = "#/404"
      return
    category = Instances.Collections.report_categories.get(id)
    if category? and not @is_system(category) and confirm(I18n.t("commons.confirm_delete"))
      category.destroy({wait: true, success : (model, resp) ->
          reports = Instances.Collections.reports.select((report) -> report.get("report_category_id") == category.id)
          _.each(reports, (report) -> report.set({report_category_id: null}, {silent: true}))
          Analytics.Utils.actionFinished()
        }
      )
    else
      window.location.href = "#/404"

  shift_up: (id) ->
    category = Instances.Collections.report_categories.get(id)
    if category? and not @is_system(category)
      category.shift_up({success: (resp, status, xhr) ->
        Analytics.Utils.actionFinished()
      })
    else
      window.location.href = "#/404"

  shift_down: (id) ->
    category = Instances.Collections.report_categories.get(id)
    if category? and not @is_system(category)
      category.shift_down({success: (resp, status, xhr) ->
        Analytics.Utils.actionFinished()
      })
    else
      window.location.href = "#/404"

  is_system: (category) ->
    Instances.Models.project? and category.id == 2
