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
      this.each(function() {
        this.set("selected", false);
      });
      
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
    
    template: JST["reports/_type"],
    events: {
      "click .metric-btn" : "select"
    },
    
    initialize: function() {
      _.bindAll(this, "render")
      
      this.model.view = this;
    },
    
    select: function() {
      ReportTypes.select(this.model);
    },
    
    render: function() {
      $(this.el).html(this.template(this.model));
      
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