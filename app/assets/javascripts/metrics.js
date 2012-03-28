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
    $("#metric_combine_attributes__destroy").val("0");
  } else {
    $("#combine_fields").hide();
    $("#metric_combine_attributes__destroy").val("1");
  }
}

function load_event(link) {
  var matches = $(link).prev().attr("id").match(/^(.*?)(\d+)$/);
  var prev_str = matches[1];
  var target_row = "l" + matches[2];
  var modal = $("#" + $(link).attr("data-target"))
  var target_body = modal.find(".modal-body");
  var siblings = $("input[id^='" + prev_str + "']");
  var condition = {}
  
  siblings.each(function() {
    condition["l" + $(this).attr("id").match(/(\d+)$/)[1]] = $(this).val();
  });
  
  $.ajax({
    url : "/projects/" + PROJECT_IDENTIFIER + "/event_item?target_row=" + target_row,
    data : {condition: condition},
    dataType: "html",
    type: "post",
    beforeSend: function() {
      console.log(modal)
      modal.modal("show");
      target_body.html(
        '<div class="progress progress-striped active">' +
          '<div class="bar" style="width: 100%;"></div>' +
        '</div>'
      );
      
    },
    success : function(resp) {
      target_body.html(resp);
    },
    error: function() {
      target_body.html("error");
    }
  });
}