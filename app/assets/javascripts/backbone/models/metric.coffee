class Analytics.Models.Metric extends Backbone.Model
  urlRoot: () ->
    if @get("project_id")?
      "/projects/"+@get("project_id")+"/metrics"
    else
      "/template/metrics"

  toJSON: () ->
    json = {
      metric: @attributes
    }

  event_key: (filters) ->
    attributes = @attributes
    event_keys = []
    _.each([0..5], (index) ->
      if attributes["event_key_"+index]?
        event_keys.push(attributes["event_key_"+index])
      else
        event_keys.push("*")
    )
    if filters?
      for filter in filters
        dimension = filter.dimension
        if dimension.dimension_type.toUpperCase() == "EVENT"
          event_keys[parseInt(dimension.value)] = filter.value
    event_keys.join(".")

  sequence_options: (segment_id, filters) ->
    options = {
      event_key: @event_key(filters)
      count_method: @get("condition").toUpperCase()
      avg: (@get("number_of_day")? or @get("number_of_day_origin")?)
    }
    if @get("number_of_day")?
      options["number_of_day"] = @get("number_of_day")

    if @get("number_of_day_origin")?
      options["number_of_day_origin"] = @get("number_of_day_origin")

    if @get("segment_id")?
      options["segment"] = segments_router.get(@get("segment_id")).serialize()

    if options["segment"]?
      _.extend(options["segment"], @segment_options(segment_id, filters))
    else
      options["segment"] = @segment_options(segment_id, filters)

    if @get("combine_attributes")?
      combine = new Analytics.Models.Metric(@get("combine_attributes"))
      options["combine"] = {action: @get("combine_action").toUpperCase()}
      _.extend(options["combine"], combine.sequence_options(segment_id, filters))

    if options["segment"]?
      options["segment"] = JSON.stringify(options["segment"])

    options


  segment_options: (segment_id, filters) ->
    if segment_id? and segment_id != 0
      options = segments_router.get(segment_id).serialize()
    if filters?
      for filter in filters
        if filter.dimension.dimension_type.toUpperCase() == "USER_PROPERTIES"
          dimension = new Analytics.Models.Dimension(filter.dimension)
          if options?
            _.extend(options, dimension.serialize(filter.value))
          else
            options = dimension.serialize(filter.value)
    options