(function(){
  window.Metric = Backbone.Model.extend({

    initialize: function(options) {
      this.set(options)
      this.id = options["id"];
      this.name = options["name"];
      this.project_id = options["project_id"];
    },
    
    edit_url: function() {
      return "/projects/" + this.attributes.project_id + "/metrics/" + this.attributes.id + "/edit";
    },
    
    delete_url: function() {
      return "/projects/" + this.attributes.project_id + "/metrics/" + this.attributes.id;
    },
    
    destroy: function() {
      this.view.remove();
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
    model: Metric,
    
    addItem: function( options) {
      this.add(new Metric(options))
    },
    
    updateItem: function( options ) {
      this.find(function(metric) {
        return metric.id == options.id
      }).set(options);
      
    }
  })
  
  window.Metrics = new MetricList;
  
  window.MetricView = Backbone.View.extend({
    template: JST["metrics/_show"],
    events: {
      "click img.del"      : "delete",
    },
    
    initialize: function() {
      _.bindAll(this, 'render');
      
      this.model.bind("change", this.render())
      this.model.view = this;
      
      console.log(this)
    },
    
    render: function() {
      $(this.el).html(this.template(this.model));
      
      return this;
    },
    
    delete: function() {
      Metrics.remove(this.model)
      this.model.destroy();
    },
    
    addOne: function(metric) {
      console.log(metric)
    }
    
    
  })
  
  window.AppView = Backbone.View.extend({
    el: $("#metric_list"),
    template: JST["metric/_list"],
            
    initialize: function() {
      _.bindAll(this, "render", "addOne");
      
      Metrics.bind("add", this.addOne);
    },
    
    
    addOne: function(metric) {
      var view = new MetricView({model: metric}).render().el;
      
      this.$el.append(view);
    },
    
    render: function() {
      
    },
    
    
    
  })
  
  window.App = new AppView;
   
}());
