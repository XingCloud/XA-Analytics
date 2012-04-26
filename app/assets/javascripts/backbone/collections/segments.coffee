class Analytics.Collections.Segments extends Backbone.Collection
  model : Analytics.Models.Segment

  selected: () ->
    (segment.id for segment in @filter((segment) -> segment.selected))

  reset_selected: (selected_ids) ->
    @each((segment) -> segment.selected = false)
    for id in selected_ids
      @get(id).selected = true