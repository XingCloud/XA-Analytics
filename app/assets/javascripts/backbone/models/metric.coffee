class Analytics.Models.Metric extends Backbone.Model
  urlRoot: () ->
    if @get("project_id")?
      "/projects/"+@get("project_id")+"/metrics"
    else
      "/template/metrics"

  toJSON: () ->
    {
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
      items: [@item_options("x", segment_id, filters)]
      formula: "x*" + @get("scale")
    }
    if @get("combine_attributes")?
      combine = new Analytics.Models.Metric(@get("combine_attributes"))
      options.items.push(combine.item_options("y", segment_id, filters))
      switch @get("combine_action").toUpperCase()
        when "ADDITION" then options.formula = "x*"+@get("scale")+"+y*"+combine.get("scale")
        when "DIVISION" then options.formula = "x*"+@get("scale")+"/y*"+combine.get("scale")
        when "MULTIPLICATION" then options.formula = "x*"+@get("scale")+"*y*"+combine.get("scale")
        when "SUBDUCTION" then options.formula = "x*"+@get("scale")+"-y*"+combine.get("scale")
    options


  item_options: (name, segment_id, filters) ->
    options = {
      name: name
      event_key: @event_key(filters)
      count_method: @get("condition").toUpperCase()
    }
    if @get("number_of_day")?
      options["number_of_day"] = @get("number_of_day")

    if @get("number_of_day_origin")?
      options["number_of_day_origin"] = @get("number_of_day_origin")

    if @get("segment_id")?
      segment = Instances.Collections.segments.get(@get("segment_id"))
      if segment?
        options["segment"] = segment.serialize()

    if options["segment"]?
      _.extend(options["segment"], @segment_options(segment_id, filters))
    else
      options["segment"] = @segment_options(segment_id, filters)

    if options["segment"]?
      options["segment"] = JSON.stringify(options["segment"])

    options


  segment_options: (segment_id, filters) ->
    if segment_id? and segment_id != 0
      options = Instances.Collections.segments.get(segment_id).serialize()
    if filters?
      for filter in filters
        if filter.dimension.dimension_type.toUpperCase() == "USER_PROPERTIES"
          dimension = new Analytics.Models.Dimension(filter.dimension)
          if options?
            _.extend(options, dimension.serialize(filter.value))
          else
            options = dimension.serialize(filter.value)
    options