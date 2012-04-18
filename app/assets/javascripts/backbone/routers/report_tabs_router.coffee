class Analytics.Routers.ReportTabsRouter extends Backbone.Router

  initialize: () ->
    @report_tabs = new Analytics.Collections.ReportTabs()

  set_tabs : (options) ->
    @index_increment = 0
    if options.length > 0
      for i in [0..options.length - 1]
        @addTab options[i], (i==0)

  add : () ->
    @addTab({}, false).headerView.click()

  del : (index) ->
    if @report_tabs.length > 1
      report_tab = @report_tabs.findTab parseInt(index)
      if report_tab?
        @report_tabs.remove report_tab
        if $(report_tab.headerView.el).hasClass('active')
          @report_tabs.firstTab().headerView.click()

        report_tab.bodyView.destroy()
        report_tab.headerView.destroy()

  showMetrics: (metrics_router, metrics_map) ->
    @report_tabs.each (report_tab) ->
      if report_tab.get("id")?
        for metric in metrics_map[report_tab.get("id").toString()]
          metrics_router.add(report_tab.get('index'), metric)

  addTab : (option, active) ->
    option['index'] = @index_increment
    report_tab = new Analytics.Models.ReportTab(option)
    @report_tabs.add report_tab

    id = "report_tab_header" + @index_increment
    className = if active then "active tab_header" else "tab_header"
    $('#add_tab').before('<li class="'+className+'" id="'+id+'"></li>')
    new Analytics.Views.ReportTabs.EditHeaderView({model : report_tab, el: "#"+id}).render()

    id = "report_tab" + @index_increment
    className = if active then "active tab-pane" else "tab-pane"
    $('#tab_body_container').append('<div class="'+className+'" id="'+id+'"></div>')
    new Analytics.Views.ReportTabs.EditBodyView({model : report_tab, el: "#"+id}).render()

    @index_increment = @index_increment + 1

    report_tab

