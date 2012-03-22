(function(){
  
  Highcharts.setOptions({
    global : {
      useUTC: false
    }
  });
  
  format_data = function(data) {
    return _.map(data, function(item) {
      item[0] = Date.parse(item[0])
      return item;
    })
  }
  
  window.Report = Backbone.Model.extend({
    initialize: function(options) {
      this.set(options);
      this.metrics = new MetricList;
      this.metrics.report = this;
    },
    
    add_period: function(options) {
      this.period = new Period(options);
      this.period.report = this;
      this.trigger("add_period", this.period);
    },
    
    draw: function() {
      this.trigger("draw", this);
    },
    
    redraw: function() {
      this.chart.destroy();
      this.chart = new Highcharts.Chart(this.chart_options());
      this.metrics.each(function(metric){
        metric.draw();
      });
    },
    chart_options: function() {
      var options = {
        credits: {
          text: ""
        },
    		chart: {
    			renderTo: "chart_container",
    			events: {
    			  tooltipRefresh: function(obj) {
    			    var html = "";
    		      _.each(obj.textConfig.points, function(point) {
    		        html += "<div style='color:" + point.series.color + "; float:left;margin-left:5px;'>" + point.series.name + " " + point.y + "</div>";
    		      })
    		      
    		      html += "<div style='text-align:right'>" + Highcharts.dateFormat(this.options.tooltip.xDateFormat, new Date(obj.textConfig.x)) + "</div>";
    		      
    		      $("#report_desc").html(html);
    			  }
    			}
    		},
    		title: {
    			text: "Chart Analytics"
    		},
        subtitle: {
          text: "XingCloud"
        },
    		xAxis: {
    		  labels : {
            align : "left",
            x : 0,
            y : 10
          },
          gridLineWidth : 0,
          tickWidth : 0,
          showFirstLabel: true,
          type: "datetime",
          dateTimeLabelFormats: {
          	second: '%H:%M:%S',
          	minute: '%H:%M',
          	hour: '%H:%M',
          	day: '%b%e日',
          	week: '%b%e日',
          	month: '%b \'%y',
          	year: '%Y'
          }
    		},
        
    		yAxis: [{
    		  min: 0,
    		  gridLineWidth : 0.5,
    			title: {
    				text: null
    			},
    			labels: {
    				align: 'right',
    				x: 3,
    				y: 16,
    				formatter: function() {
    					return Highcharts.numberFormat(this.value, 0);
    				}
    			},
    			showFirstLabel: true
    		}],

    		tooltip: {
    		  enabled: true,
    			shared: true,
    			crosshairs: [
    			  {
    			    color: "#C98657"
    			  },
    			  false
    			],
    			borderWidth: 0.5    			
    		},
    		
    		legend: {
    		  borderWidth: 0,
    		  align: "left",
    		  floating: true,
    		  layout: "vertical",
    		  verticalAlign: 'top',
    		  y: -10,
    		  labelFormatter: function() {
          	return this.name + " 峰值 " + _.max(this.yData, function(item) { return item } );
          }
    		}
    	};
    	
    	options.chart.renderTo = this.view.el;
    	options.title.text = this.get("title");
    	options.xAxis.type = this.period.type();
    	options.tooltip.xDateFormat = this.period.dateformat();
    	options.subtitle.text = this.period.range();
    	return options;
    }
    
  });
  
  window.Metric = Backbone.Model.extend({
    initialize: function(options) {
      this.set(options);
    },
    
    draw: function() {
      console.log("metric draw action")
      // if (this.drawed) {
      //         this.trigger("redraw", this);
      //       } else {
        this.trigger("draw", this);
      //   this.drawed = true;
      // }
    },
    
    chart_options: function() {
      return { 
        name: this.get("name"),
        realname: this.get("name"),
        data: format_data(this.data),
        marker: {
          enabled: false,
          fillColor: '#FFFFFF',
          lineColor: null,
          lineWidth: 1,
          states: {
            hover: {
              enabled: true
            }
          }
        }
      }
    }
    
  })
  
  window.MetricList = Backbone.Collection.extend({
    model: Metric,
    initialize: function() {
      
    },
    
    batch_create: function(array) {
      var self = this;
      
      _.each(array, function(item) {
        var metric = new Metric(item);
        metric.report = this.report;
        self.add(metric);
      });
    }
    
  })
  
  window.Period = Backbone.Model.extend({
    initialize: function(options) {
      this.set(options);
      this.set_default_time();
      this.view = new PeriodView({model: this});
    },
    
    range: function() {
      return this.get("start_time") + " 至 " + this.get("end_time");
    },
    
    dateformat: function() {
      var format;
      
      switch(this.get("rate")) {
        case "hour":
          format = "%Y-%m-%d %H"
          break;
        default:
          format = "%Y-%m-%d"
          break;
      }
      
      return format;
    },
    
    set_default_time: function() {
      if (!this.get("start_time")) {
        var start_time;
        
        switch (this.get("rule")) {
          case "last_week": 
            start_time = moment().subtract("weeks", 1);
            break;
          case "last_day":
            start_time = moment().subtract("days", 1);
            break;
          case "last_month":
            start_time = moment().subtract("months", 1);
            break;
        }
        this.set({start_time : start_time.format("YYYY-MM-DD") });
      }
      
      if (!this.get("end_time")) {
        this.set({end_time : moment().format("YYYY-MM-DD")});
      }
    },
    
    calculate: function() {
      
    },
    
    tickInterval: function() {
      
    },
    
    type: function() {
      return "datetime";
    }
  })
  
  window.PeriodView = Backbone.View.extend({
    el: $("#period"),
    events: {
      "click a#search"      : "refresh",
    },
    initialize: function() {
      _.bindAll(this, "refresh");
    },
    
    refresh: function() {
      this.model.set("start_time", this.$("#start_time").val());
      this.model.set("end_time", this.$("#end_time").val());
      
      this.model.report.redraw();
    }
  });
  
  window.MetricView = Backbone.View.extend({
    initialize: function() {
      this.model.view = this;
      _.bindAll(this, "drawMetric", "redrawMetric");
      
      this.model.bind("draw", this.drawMetric);
      this.model.bind("redraw", this.redrawMetric);
    },
    
    request_data: function(call_back) {
      var self = this;
      
      var params = {
        start_time: this.model.report.period.get("start_time"),
        end_time: this.model.report.period.get("end_time")
      }
      
      console.log(params);
      
      $.ajax({
        url: "/projects/" + this.model.report.get("project_id") + "/reports/" + this.model.report.id + "/request_data?metric_id=" + this.model.id + "&test=true",
        dataType: "json",
        type: "post",
        data: params,
        success: function(resp) {
          if (resp.result) {
            self.model.data = resp.data;
            call_back();
          } else {
            alert(resp.error);
          }
        }
      });
    },
    
    drawMetric: function(metric) {
      console.log("draw metric")
      this.request_data(function() {
        metric.report.chart.addSeries(metric.chart_options());
      })
      
    },
    
    redrawMetric: function(metric) {
      console.log("redraw metric")
      var index = report.metrics.indexOf(metric);
      this.request_data(function() {
        metric.report.chart.series[index].data = metric.data;
        metric.report.chart.series[index].redraw();
        metric.report.chart.redraw();
      });
    }
  });
  
  window.ReportView = Backbone.View.extend({
    el: $("#report_chart"),
    initialize: function() {
      this.model.view = this;
    },
    
    render: function() {
      report.chart = new Highcharts.Chart(this.model.chart_options());
    }
  })
  
  window.AppView = Backbone.View.extend({
    el: $("#chart_container"),
    initialize: function() {
      _.bindAll(this, "drawChart", "addMetric");
      
      report.bind("draw", this.drawChart);
      report.metrics.bind("add", this.addMetric);
    },
    
    drawChart: function(report) {
      console.log("draw chart")
      var view = new ReportView({model : report});
      view.render();
    },
    
    addMetric: function(metric) {
      var view = new MetricView({model : metric});
      metric.draw();
    }
  })
  
  window.report = new Report;
  window.App = new AppView;
  
})();