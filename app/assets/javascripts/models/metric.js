(function(){
  window.Metric = Backbone.Model.extend({

    initialize: function(options) {
      this.set_attributes(options)
    },

    generate_edit_url: function() {
      return "/projects/" + this.project_id + "/metrics/" + this.id + "/edit";
    },

    generate_delete_url : function() {
      return "/projects/" + this.project_id + "/metrics/" + this.id;
    },

    set_attributes: function(options) {
      this.id = options["id"];
      this.name = options["name"];
      this.project_id = options["project_id"];
      this.edit_url = this.generate_edit_url();
      this.delete_url = this.generate_delete_url();
    }

  });


  Metric.build = function(data) {
    var list = []
    for(var i =0 ;i< data.length; i++) {
      list.push(new Metric(data[i]))
    }
    return list;
  }
  
  window.MetricList = Backbone.Collection.extend({
    model: Metric
  })
  
  window.Metrics = new MetricList;
  
  window.MetricView = Backbone.View.extend({
    
    el: $("#metric_list"),
    template: JST["metrics/_show"],
    
    initialize: function() {
      _.bindAll(this, 'render', 'close');
      this.input = this.$("#new-todo");
      
      Metrics.bind("add",     this.addOne);
      Metrics.bind("refresh", this.addAll);
      Metrics.bind('all',     this.render);
    },
    
    render: function() {
      console.log("in render")
      
      $(this.el).set("html", this.template({ 
        
      }))
    },
    
    close: function() {
      console.log("close")
    }
    
    
    
  })
  
  window.App = new MetricView;
   
}());
