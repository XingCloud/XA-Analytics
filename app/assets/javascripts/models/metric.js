(function(){
  
  window.Metric = Backbone.Model.extend({

    initialize: function(options) {
      this.set(options);
    },
    
    edit_url: function() {
      if (this.attributes.project_id != null)
        return "/projects/" + this.attributes.project_id + "/metrics/" + this.attributes.id + "/edit";
      else
        return "/admin/template_metrics/" + this.attributes.id + "/edit";
    },
    
    delete_url: function() {
      if (this.attributes.project_id != null)
        return "/projects/" + this.attributes.project_id + "/metrics/" + this.attributes.id;
      else
        return "/admin/template_metrics/" + this.attributes.id;
    },
    
    destroy: function() {
      Metrics.remove(this)
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
      
      this.model.bind("change", this.render)
      this.model.view = this;
    },
    
    render: function() {
      $(this.el).html(this.template(this.model));
      
      return this;
    },
    
    delete: function() {
      if (confirm("确定删除吗？")) {
        this.model.destroy();
      } else {
        return false;
      }
    },
    
    addOne: function(metric) {
      console.log(metric)
    }
    
    
  })
  
  window.AppView = Backbone.View.extend({
    el: $("#metric_list"),
    className: "btn-group",
    initialize: function() {
      _.bindAll(this, "addOne");
      
      Metrics.bind("add", this.addOne);
    },
    
    
    addOne: function(metric) {
      var view = new MetricView({model: metric}).render().el;
      
      this.$el.append(view);
    }
    
  })
  
  window.App = new AppView;
   
}());
