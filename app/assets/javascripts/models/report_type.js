(function() {
  
  window.ReportType = Backbone.Model.extend({
    
    initialize: function(options) {
      this.set(options);
    }
    
    
  });
  
  window.ReportList = Backbone.Collection.extend({
    model: ReportType,
    
    current: function() {
      return this.find(function() {
        return this.get("selected");
      });
    },
    
    select: function(report_type) {
      //先把所有选中的取消
      this.each(function(item) {
        item.set("selected", false);
      });
      //在把当前的选中
      report_type.set("selected", true);
    },
    
    addItem: function( options) {
      this.add(new Metric(options))
    },

    updateItem: function( options ) {
      this.find(function(metric) {
        return metric.id == options.id
      }).set(options);
    }
    
  });
  
  window.ReportTypes = new ReportList;
  
  window.ReportTypeView = Backbone.View.extend({
    tagName: "a",
    className: "btn metric-btn",
    events: {
      "click" : "select"
    },
    
    initialize: function() {
      _.bindAll(this, "render");
      this.$el.attr("href", "#type_" + this.model.get("type_name")).data("type", this.model.get("name"))
      
      this.model.bind("change", this.render)
      this.model.view = this;
    },
    
    select: function() {
      ReportTypes.select(this.model);
      
      return false;
    },
    
    render: function() {
      if (this.model.get("selected")) {
        $(this.el).addClass("active");
        $("#report_type").val(this.model.get("name"));
      } else {
        $(this.el).removeClass("active");
      }
      
      $(this.el).html(this.model.get("human_name"));
      
      return this;
    }
    
  });
  
  window.ReportTypesView = Backbone.View.extend({
    el: $("#report_types"),
    
    initialize: function() {
      _.bindAll(this, "addOne");
      
      ReportTypes.bind("add", this.addOne);
    },
    
    addOne: function(report_type) {
      var view = new ReportTypeView({model: report_type}).render().el;
      
      this.$el.append(view);
    }
    
  })
  
  window.ReportTypesAppView = new ReportTypesView;
  
})();