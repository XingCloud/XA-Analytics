function check_keys(scope) {
  var $scope = $(scope);
  
  /* 取得所有的选项的值 */
  var values = $scope.find(".chzn-select").map(function() { 
    return $(this).val();
  });
  
  $scope.find(".chzn-select").each(function(idx, item) {
    /* 当前选项为任意可选 */
    var copy_values = values.slice();
    copy_values[idx] = "*";
    
    /* 组合正则表达式 */
    var regexp = [];
    for(var i = 0; i < copy_values.length; i++) {
      if (copy_values[i] == "*") {
        regexp.push("\\w*");
      } else {
        regexp.push(copy_values[i]);
      }
    }
    regexp = new RegExp(regexp.join("\\.?"))
    
    /* 取得可选的选项 */
    var available_events = [];
    for(var i = 0; i < events.length; i++) {
      if (events[i].match(regexp)) {
        var part = events[i].split(".")[idx];
        if (typeof part == "undefined") {
          continue;
        }
        
        if (available_events.indexOf(part) < 0) {
          available_events.push(part);
        }
      }
    }
    
    $(this).find("option").each(function(option_idx, item) {
      /*  隐藏或显示 chosen 的选项 */
      var chosen_item = $(this).parent("select").next("div").find(".chzn-results .active-result:eq(" + option_idx + ")");
      
      if (available_events.indexOf( $(this).val() ) >= 0 || option_idx == 0) {
        /* $(this).removeAttr("disabled"); */
        chosen_item.show();
      } else {
        /* $(this).attr("disabled", true) */
        chosen_item.hide();
      }  
    })
    
  })
  
}

function toggle_combine_fieldset() {
  if ($("#metric_combine_action").val()) {
    $("#combine_fields").show();
  } else {
    $("#combine_fields").hide();
  }
}

$(function() {
  $("#base .chzn-select").chosen().change(function() {
    check_keys("#base");
  })
  
  $("#combine .chzn-select}").chosen().change(function() {
    check_keys("#combine")
  })
  
  $("#metric_combine_action").change(function() {
    toggle_combine_fieldset()
  })
  toggle_combine_fieldset()
})