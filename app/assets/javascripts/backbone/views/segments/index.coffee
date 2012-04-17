Analytics.Views.Segments ||= {}

class Analytics.Views.Segments.IndexView extends Backbone.View
  el: "#segment_list"
  events:
    "click span#segment_apply":"segment_query"
    "click span#segment_cancel":"segment_cancel"


  initialize: () ->
    _.bindAll(this, "segment_query","segment_cancel","select_segment")

  segment_query: () ->
    segment_list =  $(".H5").find("input:checked")
    segments =  (new_segment(segment) for segment in segment_list)
    console.log(segment_ids)
    project.set("segments",segments);

  new_segment: (segment) ->
    {"id": $(segment).attr("value"),"name":$(segment).next().text()}

  segment_cancel: () ->
    $("#segment_list").hide();






