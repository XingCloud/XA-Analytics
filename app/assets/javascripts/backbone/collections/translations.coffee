class Analytics.Collections.Translations extends Backbone.Collection
  model: Analytics.Models.Translation
  resources: [
    {
      name: "report_category"
      fields: ["name"]
      value: "ReportCategory"
      collection: "report_categories"
    },
    {
      name: "report"
      fields: ["title"]
      value: "Report"
      collection: "reports"
    },
    {
      name: "report_tab"
      fields: ["title"]
      value: "ReportTab"
      collection: "report_tabs"
    },
    {
      name: "metric"
      fields: ["name", "description"]
      value: "Metric"
      collection: "metrics"
    },
    {
      name: "segment"
      fields: ["name"]
      value: "Segment"
      collection: "segments"
    },
    {
      name: "widget"
      fields: ["title"]
      value: "Widget"
      collection: "widgets"
    },
    {
      name: "maintenance_plan"
      fields: ["announcement"]
      value: "MaintenancePlan"
      collection: "maintenance_plans"
    }
  ]
  languages: ["en", "zh"]

  initialize: (models, options) ->
    @resource_name = I18n.t("resources.translation")
    @synced = false
    @resource = @resources[0]
    @field = @resource.fields[0]
    @language = @languages[0]
    @page = 1
    @page_size = 10
    @unfinished = false

  url: () ->
    if Instances.Models.project?
      "/projects/" + Instances.Models.project.id + "/translations"
    else
      "/template/translations"

  sync_wrapper: (options = {}) ->
    @synced = true
    options.wait = true
    success = options.success
    options.success = (collection, response, options) ->
      if success?
        success(collection, response, options)
    options.error = (collection, xhr, options) ->
      collection.synced = false
    @fetch(options)

  get_with_condition: (resource_id) ->
    resource = @resource.value
    field = @field
    language = @language
    @find((translate) ->
      (translate.get("rid") == resource_id and
       translate.get("rtype") == resource and
       translate.get("rfield") == field and
       translate.get("locale") == language))

  comparator: (translation) ->
    0 - Date.parse(translation.get("updated_at"))

  attach_translation: () ->
    for translation in @models
      resource = _.find(@resources, (resource) -> resource.value == translation.get("rtype"))
      collection = Instances.Collections[resource.collection]
      if collection?
        model = collection.get(translation.get("rid"))
      if model?
        attributes = {}
        attributes[translation.get("rfield")] = translation.get("content")
        model.set(attributes, {silent: true})

