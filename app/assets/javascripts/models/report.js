(function(){
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
    
    chart_options: function() {
      
      console.log(this.view.$el.attr("id"));
      var options = {
    		chart: {
    			renderTo: this.view.el
    		},
    		title: {
    			text: this.get("title")
    		},
        subtitle: {
          text: "XingCloud"
        },
    		xAxis: {
    		  labels : {
            align : "left",
            x : 3,
            y : -3
          },
          gridLineWidth : 1,
          tickWidth : 0,
          tickInterval: this.period.tickInterval(),
          type: this.period.xtype()
    		},

    		yAxis: [{
    		  min: 0,
    			title: {
    				text: null
    			},
    			labels: {
    				align: 'left',
    				x: 3,
    				y: 16,
    				formatter: function() {
    					return Highcharts.numberFormat(this.value, 0);
    				}
    			},
    			showFirstLabel: false
    		}, { // right y axis
    			linkedTo: 0,
    			gridLineWidth: 0,
    			opposite: true,
    			title: {
    				text: null
    			},
    			labels: {
    				align: 'right',
    				x: -3,
    				y: 16,
    				formatter: function() {
    					return Highcharts.numberFormat(this.value, 0);
    				}
    			},
    			showFirstLabel: false
    		}],

    		legend: {
    			align: 'left',
    			verticalAlign: 'top',
    			y: 20,
    			floating: true,
    			borderWidth: 0
    		},

    		tooltip: {
    			shared: true,
    			crosshairs: true
    		}
    	};
    	
    	return options;
    }
    
  });
  
  window.Metric = Backbone.Model.extend({
    initialize: function(options) {
      this.set(options);
    },
    
    draw: function() {
      if (this.drawed) {
        this.trigger("redraw", this);
      } else {
        this.trigger("draw", this);
        this.drawed = true;
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
    initalize: function(options) {
      this.set(options)
    },
    
    tickInterval: function() {
      return 24 * 3600 * 1000;
    },
    
    xtype: function() {
      if (["five_min", "one_hour"].indexOf(this.get("rate")) >= 0) {
        return "datetime"
      } else {
        return "date"
      }
    }
  })
  
  window.MetricView = Backbone.View.extend({
    initialize: function() {
      this.model.view = this;
      _.bindAll(this, "drawMetric");
      
      this.model.bind("draw", this.drawMetric)
    },
    
    render: function() {
      var self = this;
      
      $.ajax({
        url: "/projects/" + this.model.report.get("project_id") + "/reports/" + this.model.id + "/request_data?metric_id=" + this.model.id,
        dataType: "json",
        type: "get",
        success: function(resp) {
          self.model.data = resp.data;
          self.model.draw();
        }
      });
    },
    
    drawMetric: function(metric) {
      report.chart.addSeries({ 
        name: metric.get("name"),
        data: format_data(metric.data) 
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
      view.render();
    }
  })
  
  window.report = new Report;
  window.App = new AppView;
  
})();