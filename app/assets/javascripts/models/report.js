(function () {
    // $.xhrPool = [];
    // $.xhrPool.abortAll = function() {
    //   _.each(this, function(jqXHR) {
    //     jqXHR.abort();
    //   });
    // };
    // 
    // $.ajaxSetup({
    //   beforeSend: function(jqXHR) {
    //     $.xhrPool.push(jqXHR);
    //   }
    // });
    
    window.DEBUG = false;
    
    Highcharts.setOptions({
        global:{
            useUTC: false
        }
    });

    format_data = function (data) {
        return _.map(data, function (item) {
            item[0] = Date.parse(item[0])
            return item;
        });
    }

    window.Report = Backbone.Model.extend({
        initialize:function (options) {
            this.set(options);
            this.metrics = new MetricList;
            this.metrics.report = this;
        },

        add_period:function (options) {
            this.period = new Period(options);
            this.period.report = this;
        },

        draw:function () {
            this.trigger("draw", this);
        },

        redraw:function () {
            this.chart.destroy();
            this.chart = new Highcharts.Chart(this.chart_options());
            this.metrics.each(function (metric) {
                metric.drawed = false;
                metric.draw();
            });
        },
        
        chart_options:function () {
            if (this.get("type_name") == "line_report") {
                return this.line_chart_option();
            }
            if (this.get("type_name") == "bar_report") {
                return this.bar_chart_option();
            }
            if (this.get("type_name") == "stack_report") {
                return this.stack_chart_option();
            }
        },

        line_chart_option:function () {
            var options = {
                credits:{
                    text:""
                },
                chart:{
                    renderTo:"chart_container",
                    events:{
                        tooltipRefresh:function (obj) {
                            var html = "";
                            _.each(obj.textConfig.points, function (point) {
                                html += "<div style='color:" + point.series.color + "; float:left;margin-left:5px;'>" + point.series.name + " " + point.y + "</div>";
                            })

                            html += "<div style='text-align:right'>" + Highcharts.dateFormat(this.options.tooltip.xDateFormat, new Date(obj.textConfig.x)) + "</div>";

                            $("#report_desc").html(html);
                        }
                    }
                },
                title:{
                    text: "Chart Analytics"
                },
                subtitle:{
                    text:"XingCloud"
                },
                xAxis:{
                    labels:{
                        align:"left",
                        x:0,
                        y:10,
                        formatter: function() {
                           return Highcharts.dateFormat('%m-%d %l时', this.value);
                        }
                    },
                    gridLineWidth:0,
                    tickWidth:0,
                    showFirstLabel:true,
                    type:"datetime",
                    dateTimeLabelFormats:{
                        second:'%H:%M:%S',
                        minute:'%H时%M分',
                        hour:'%H时',
                        day:'%b%e日 %H时',
                        week:'%b%e日',
                        month:'%b \'%y',
                        year:'%Y'
                    }
                },

                yAxis: {
                    min:0,
                    gridLineWidth:0.5,
                    title:{
                        text:null
                    },
                    labels:{
                        align:'right',
                        x:3,
                        y:16,
                        formatter:function () {
                            return Highcharts.numberFormat(this.value, 0);
                        }
                    },
                    showFirstLabel:true
                },
                
                tooltip:{
                    enabled:true,
                    shared:true,
                    crosshairs:[
                        {
                            color:"#C98657"
                        },
                        false
                    ],
                    borderWidth:0.5
                },
                
                loading: {
                    hideDuration: 500,
                    showDuration: 500
                },
                legend:{
                    enabled:false,
                    borderWidth:0,
                    align:"left",
                    floating:true,
                    layout:"vertical",
                    verticalAlign:'top',
                    y:-10,
                    labelFormatter:function () {
                        
                        if (this.options.timeout) {
                            return this.name + " 超时";
                        } else {
                            return this.name + " 峰值 " + (_.max(this.yData, function (item) {
                                return item
                            }) || "");
                        }
                        
                    }
                }
            };

            options.chart.renderTo = this.view.el;
            //options.title.text = this.get("title");
            //options.subtitle.text = this.period.range();
            
            options.title.text = "";
            options.subtitle.text = "";
            
            options.xAxis.type = this.period.type();
            if (this.period.compare) {
                options.xAxis.tickInterval = this.period.tickInterval();
            }

            options.tooltip.xDateFormat = this.period.dateformat();
            
            return options;
        },

        bar_chart_option: function () {
            var options = this.line_chart_option();
            options.chart.type = "column";
            options.tooltip.crosshairs = null;
            options.xAxis.labels.align = "center";
            options.xAxis.tickInterval = this.period.get("interval") * 1000;
            return options;

        },

        stack_chart_option: function(){
            var options = this.line_chart_option();
            options.chart.type = "column";
            options.tooltip.crosshairs = null;
            options.xAxis.labels.align = "center";
            options.xAxis.tickInterval = this.period.get("interval") * 1000;
            options["plotOptions"] = {
                column:{
                    stacking:'normal'
                }
            };
            return options;
        }

    });

    window.Metric = Backbone.Model.extend({
        initialize:function (options) {
            this.set(options);
        },
        
        max_val: function() {
            if (this.data) {
                var max = _.max(this.data, function(item) {
                    return item[1];
                });
                console.log(max[1])
                return max[1];
            } else {
                return "";
            }
            
        },
        
        sum_val: function() {
            if (this.data) {
                var total = 0;
                _.each(this.data, function(item) {
                    if (typeof item[1] == "number") {
                        total += item[1];
                    }
                });
                return total;
            } else {
                return "";
            }
            
        },
        
        draw:function () {
            console.log("metric draw")
            var self = this;

            this.request_data(function () {
                self.trigger("draw", self);
            });
        },

        request_params:function () {
            return {
                start_time : moment(this.report.period.get("start_time")).format("YYYY-MM-DD"),
                end_time : moment(this.report.period.get("end_time")).format("YYYY-MM-DD")
            }
        },

        request_url:function () {
            return "/projects/" + this.report.get("project_id") + "/reports/" + this.report.id + "/request_data?metric_id=" + this.id + (window.DEBUG ? "&test=true" : "");
        },

        request_data:function (callback) {
            var self = this, params = this.request_params();

            console.log(params);

            $.ajax({
                url:this.request_url(),
                dataType:"json",
                type:"post",
                data:params,
                async: true,
                beforeSend: function() {
                  self.report.chart.showLoading();  
                },
                success:function (resp) {
                    self.report.chart.hideLoading();  
                    if (resp.result) {
                        self.data = resp.data;
                        self.timeout = false;
                        callback();
                    } else {
                        self.data = [];
                        self.timeout = resp.timeout;
                        callback();
                    }
                },
                error: function(resp) {
                    self.report.chart.hideLoading();
                    self.data = [];
                    callback();
                }
            });
            
        },

        series_options:function () {
            return {
                name:this.get("name"),
                realname:this.get("name"),
                data:format_data(this.data),
                timeout: this.timeout,
                marker:{
                    enabled:false,
                    fillColor:'#FFFFFF',
                    lineColor:null,
                    lineWidth:1,
                    states:{
                        hover:{
                            enabled:true
                        }
                    }
                }
            };
        }

    });

    window.CompareMetric = Metric.extend({
        initialize:function (options) {
            this.set(options);
            this.set("metric_id", this.id);
            this.set("id", null);
        },
        
        max_val: function() {
            if (this.data) {
                return _.max(this.data);
            } else {
                return ""
            }
        },
        sum_val: function() {
            if (this.data) {
                var total = 0;
                _.each(this.data, function(item) {
                    if (typeof item == "number") {
                        total += item;
                    }
                });

                return total;
            } else {
                return ""
            }
        },
        request_params:function () {
            console.log("compare metric request params");
            var params = {
                start_time : this.get("start_time").format("YYYY-MM-DD"),
                end_time : this.get("end_time").format("YYYY-MM-DD")
            }
            console.log(params);
            return params;
        },

        request_url:function () {
            return "/projects/" + this.report.get("project_id") + "/reports/" + this.report.id + "/request_data?metric_id=" + this.get("metric_id") + (window.DEBUG ? "&test=true" : "");
        },

        assign_start_time:function (val) {
            this.set("start_time", moment(val));
            this.set("end_time", moment(val).add("ms", this.report.period.compare_length()));
            this.set("name", val + this.get("realname"));
        },

        series_options:function () {
            return {
                name:this.get("name"),
                realname:this.get("name"),
                data:this.data,
                pointStart:moment(this.report.period.get("start_time")),
                pointInterval:this.report.period.get("interval") * 1000,
                marker:{
                    enabled:false,
                    fillColor:'#FFFFFF',
                    lineColor:null,
                    lineWidth:1,
                    states:{
                        hover:{
                            enabled:true
                        }
                    }
                }
            }
        }
    });

    window.Period = Backbone.Model.extend({
        initialize:function (options) {
            this.set(options);
            this.set_default_time();
            this.compare = (this.get("compare_number") > 0)
            this.view = new PeriodView({model:this});
        },

        range:function () {
            return moment(this.get("start_time")).format("YYYY-MM-DD") + " 至 " + moment(this.get("end_time")).format("YYYY-MM-DD");
        },

        dateformat:function () {
            var format;

            switch (this.get("rate")) {
                case "hour":
                    format = "%Y-%m-%d %H时"
                    break;
                default:
                    format = "%Y-%m-%d"
                    break;
            }

            return format;
        },

        set_default_time:function () {
            if (!this.get("start_time")) {
                var start_time;

                start_time = moment().subtract("ms", this.compare_length());
                this.set({start_time:start_time });
            }

            if (!this.get("end_time")) {
                this.set({end_time:moment()});
            }
        },

        compare_start_time:function (index) {
            var base_time = moment(this.get("start_time"));

            return base_time.clone().subtract("ms", index * this.compare_length());
        },

        compare_end_time:function (index) {
            var base_time = moment(this.get("end_time"));

            return base_time.clone().subtract("ms", index * this.compare_length());
        },

        compare_length:function () {
            var length;
            switch (this.get("rule")) {
                case "last_week":
                    length = 7 * 24 * 3600 * 1000;
                    break;
                case "last_day":
                    length = 24 * 3600 * 1000;
                    break;
                case "last_month":
                    length = 30 * 24 * 3600 * 1000;
                    break;
            }

            return length;
        },

        type:function () {
            return "datetime";
        },

        tickInterval:function () {
            if (this.compare) {
                return 24 * 3600 * 1000;
            } else {
                return null;
            }
        },


        assign_start_time:function (val) {
            this.set("start_time", val);
            this.set("end_time", moment(val).add("ms", this.compare_length()).format("YYYY-MM-DD"));
        }
    });

    window.MetricList = Backbone.Collection.extend({
        model:Metric,
        batch_create:function (metric_options) {
            var self = this;

            if (this.report.period.get("compare_number") < 1) {
                _.each(metric_options, function (item) {
                    var metric = new Metric(item);
                    metric.report = this.report;
                    metric.set("target_legend", "metric_" + metric.get("id"));
                    self.add(metric);
                });
            } else {
                _.each(metric_options, function (item, idx) {
                    console.log(self.report.period)
                    //多个对比时间
                    for (var i = 0; i <= self.report.period.get("compare_number"); i++) {
                        var metric = new CompareMetric(item);

                        metric.set({
                            start_time:self.report.period.compare_start_time(i),
                            end_time:self.report.period.compare_end_time(i),
                            compare_index:i
                        });
                        
                        console.log("metric_" + metric.get("metric_id") + "_" + metric.get("start_time").format("YYYY-MM-DD"))
                        metric.set("realname", metric.get("name"));
                        metric.set("name", metric.get("start_time").format("YYYY-MM-DD") + " " + metric.get("name"));
                        metric.set("target_legend", "metric_" + metric.get("metric_id") + "_" + metric.get("start_time").format("YYYY-MM-DD"));
                        
                        metric.report = this.report;
                        self.add(metric);
                    }
                });
            }
        }

    });

    window.PeriodView = Backbone.View.extend({
        el:$("#period"),
        events:{
            "click a#search":"refresh",
        },
        
        initialize:function () {
            _.bindAll(this, "refresh");
        },

        refresh:function () {
            this.assign_time();
            this.model.report.redraw();
        },
        
        assign_time:function () {
            if (this.model.compare) {
                var self = this;
                this.model.assign_start_time(self.$("#compare_time_1").val());
                this.model.report.metrics.each(function (metric) {
                    metric.assign_start_time(
                        self.$("#compare_time_" + Number(metric.get("compare_index") + 1)).val()
                    );
                });
            } else {
                this.model.set("start_time", moment(this.$("#start_time").val()));
                this.model.set("end_time", moment(this.$("#end_time").val()));
            }
        }
    });

    window.MetricView = Backbone.View.extend({
        el: $("#report_legend"),
        initialize:function () {
            this.model.view = this;
            _.bindAll(this, "drawMetric");

            this.model.bind("draw", this.drawMetric);
        },

        drawMetric:function (metric) {
            var series = metric.report.chart.addSeries(metric.series_options());
            this.updateLegend(metric, series);
        },
        
        updateLegend: function(metric, series) {
            var $legend = this.$el.find("#" + metric.get("target_legend"));
            
            $legend.find(".name").css("color", series.color)
            $legend.find(".max_val").html( String(metric.max_val()) );
            $legend.find(".sum_val").html( String(metric.sum_val()) );
            $legend.find(".name").html(metric.get("name"));
            
            $legend.unbind("click").click(function() {
                if (series.visible) {
                    series.hide();
                    $(this).css("color", "silver");
                } else {
                    series.show();
                    $(this).css("color", "");
                }
            })
        }
    });

    window.ReportView = Backbone.View.extend({
        el:$("#report_chart"),
        initialize:function () {
            this.model.view = this;
            
        },

        render:function () {
            report.chart = new Highcharts.Chart(this.model.chart_options());
        }
        
       
    });

    window.AppView = Backbone.View.extend({
        el:$("#chart_container"),
        initialize:function () {
            _.bindAll(this, "drawChart", "addMetric");

            report.bind("draw", this.drawChart);
            report.metrics.bind("add", this.addMetric);
        },

        drawChart:function (report) {
            console.log("draw chart")
            var view = new ReportView({model:report}).render();
        },

        addMetric:function (metric) {
            var view = new MetricView({model:metric});
            metric.draw();
            this.drawLegend(metric)
        },
        
        drawLegend: function(metric) {
            console.log("Drawlegend")
            var template = window.JST["reports/_legend"];
            var html = template(metric);
            console.log(metric.get("target_legend"));
            this.$el.find("#report_legend").append(html);
            
            
        }
    })

    window.report = new Report;
    window.App = new AppView;

})();