(function(){
  window.Report = Backbone.Model.extend({
    initialize: function(options) {
      this.set(options);
    },
    
    draw: function() {
      
    },
    
    redraw: function() {
      
    }
    
  });
  
  window.Metric = Backbone.Model.extend({
    initialize: function(options) {
      this.set(options)
    }
  })
  
  window.Period = Backbone.Model.extend({
    initalize: function(options) {
      this.set(options)
    }
  })
  
  window.report = new Report;
  
  window.MetricView = Backbone.View.extend({
    initialize: function() {
      this.model.view = this;
    },
    
    draw: function() {
      
    }
    
    
  })
  
  window.AppView = Backbone.View.extend({
    el: 
    initialize: function() {
      
    }
  })
  
  window.App = new AppView;
  
})();