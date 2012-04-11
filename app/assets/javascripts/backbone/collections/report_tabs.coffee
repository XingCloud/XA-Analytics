class Analytics.Collections.ReportTabs extends Backbone.Collection
  model: Analytics.Models.ReportTab

  findTab: (tab_index) ->
    @find((report_tab) -> report_tab.get("index") == tab_index)

  firstTab: () ->
    @at 0
