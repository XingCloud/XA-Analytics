class Analytics.Models.Setting extends Backbone.Model

  url: () ->
    "/projects/" + Instances.Models.project.id + "/settings"

  toJSON: () ->
    event_levels = []
    for num in [0..5]
      if @get("event_level_"+num)?
        event_levels.push(@get("event_level_"+num))
      else
        event_levels.push("")
    {setting: {
      event_level: event_levels.join(".")
    }}
