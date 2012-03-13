var Metric = function(options) {
  this.set_attributes(options);
}

Metric.build = function(data) {
  var list = []
  for(var i =0 ;i< data.length; i++) {
    list.push(new Metric(data[i]))
  }
  return list;
}

Metric.prototype = {
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
}