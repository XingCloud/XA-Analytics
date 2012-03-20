(function() {
  window.render_metric = function(url, idx) {
    
    jQuery.get(url, null, function(resp, state, xhr) {
      data = format_data(resp.data);
            // 
            // console.log(data)
            // 
            // _.each(data, function(item) {
            //   chart.series[idx].data[Date.parse(item[0])] = item[1];
            // })
            // 
            // chart.series[idx].redraw();
            // 
      chart.addSeries({
        data: data
      });
      
      // chart.redraw();
  	});
  }
  
  window.format_data = function(data) {
    return _.map(data, function(item) {
      item[0] = Date.parse(item[0])
      return item;
    })
  }
  
})();

