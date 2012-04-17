Analytics.Views.Segments ||= {}

class Analytics.Views.Segments.IndexView extends Backbone.View
  el: "#segment_list"
  events:
    "click span#segment_apply":"segment_query"
    "click span#segment_cancel":"segment_cancel"
    "change .H5 ul li":"select_segment"

  initialize: () ->
    _.bindAll(this, "segment_query","segment_cancel","select_segment")

  segment_query: () ->
    alert('segment_query');

  segment_cancel: () ->
    $("#segment_list").hide();

  select_segment: () ->
    project.set({"": []})



