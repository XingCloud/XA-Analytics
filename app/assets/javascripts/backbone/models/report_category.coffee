class Analytics.Models.ReportCategory extends Backbone.Model
  urlRoot: () ->
    if Instances.Models.project?
      "/projects/" + Instances.Models.project.id + "/report_categories"
    else
      "/template/report_categories"

  shift_up: (options) ->
    index = @collection.indexOf(@)
    if index > 0
      last_category = @collection.at(index - 1)
      @swap_position(last_category, options)

  shift_down: (options) ->
    index = @collection.indexOf(@)
    if index >=0 and index < @collection.length - 1
      prev_category = @collection.at(index + 1)
      @swap_position(prev_category, options)

  swap_position: (other_category, options) ->
    category = @
    collection = @collection
    other_category_position = other_category.get("position")
    other_category.save({position: @get("position")}, {
      wait: true
      silent: true
      success: (resp, status, xhr) ->
        category.save({position: other_category_position}, {
          wait: true
          silent: true
          success: (resp, status, xhr) ->
            collection.sort()
            options.success(resp, status, xhr)
        })
    })

  toJSON: () ->
    {report_category: @attributes}