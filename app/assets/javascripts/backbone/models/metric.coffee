class Analytics.Models.Metric extends Backbone.Model
  defaults:
    "scale": 1
    "value_type": "origin"
  urlRoot: () ->
    if Instances.Models.project?
      "/projects/" + Instances.Models.project.id + "/metrics"
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
    scale_startdate = @get("scale_startdate") 
    if not scale_startdate then scale_startdate = Analytics.Utils.formatUTCDate(new Date(0).getTime(), 'YYYY-MM-DD')
    options = {
      items: [@item_options("x", segment_id, filters)]
      formula: "x*" + @get("scale")+"|x*1|"+scale_startdate
    }
    if @get("combine_attributes")?
      combine = new Analytics.Models.Metric(@get("combine_attributes"))
      options.items.push(combine.item_options("y", segment_id, filters))
      switch @get("combine_action").toUpperCase()
        when "ADDITION" then options.formula = "x*"+@get("scale")+"+y*"+combine.get("scale")+"|x+y|"+scale_startdate
        when "DIVISION" then options.formula = "(x*"+@get("scale")+")/(y*"+combine.get("scale") + ")"+"|x/y|"+scale_startdate
        when "MULTIPLICATION" then options.formula = "x*"+@get("scale")+"*y*"+combine.get("scale")+"|x*y|"+scale_startdate
        when "SUBDUCTION" then options.formula = "x*"+@get("scale")+"-y*"+combine.get("scale")+"|x-y|"+scale_startdate
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

    #deal the segment metric binding to
    if @get("segment_id")?
      segment = Instances.Collections.segments.get(@get("segment_id"))
      if segment?
        options["segment"] = segment.serialize()
        options["segmentv2"] = segment.serialize_to_sql()

    #deal the segment from segment selector and dimension filters on the
    if options["segment"]?
      _.extend(options["segment"], @segment_options(segment_id, filters))
      options["segmentv2"] += @segment_sql_options(segment_id, filters)
    else
      options["segment"] = @segment_options(segment_id, filters)
      options["segmentv2"] = @segment_sql_options(segment_id, filters)

    #serialize to string
    if options["segment"]?
      options["segment"] = JSON.stringify(options["segment"])

    if @get("filter_operator")? and @get("filter_operator") != ""
      if @get("filter_operator") == "BETWEEN"
        values = @get("filter_value").split(",")
        if values.length >= 2
          options["filter"] = {
            "comparison_operator": @get("filter_operator")
            "comparison_value": parseFloat(values[0])
            "comparison_value2": parseFloat(values[1])
          }
      else
        options["filter"] = {
          "comparison_operator": @get("filter_operator")
          "comparison_value": parseFloat(@get("filter_value"))
        }

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

  segment_sql_options: (segment_id, filters) ->
    options = ""
    if segment_id? and segment_id != 0
      options = Instances.Collections.segments.get(segment_id).serialize_to_sql()
    if filters?
      for filter in filters
        if filter.dimension.dimension_type.toUpperCase() == "USER_PROPERTIES"
          dimension = new Analytics.Models.Dimension(filter.dimension)
          if options?
            options+=dimension.serialize_to_sql(filter.value)
          else
            options = dimension.serialize_to_sql(filter.value)
    options