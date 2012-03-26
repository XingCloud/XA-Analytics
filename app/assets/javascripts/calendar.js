
jQuery(function($) {
	// $.datepicker.regional['zh-CN'] = { 
	//         clearText: '清除', 
	//         clearStatus: '清除已选日期', 
	//         closeText: '关闭', 
	//         closeStatus: '不改变当前选择', 
	//         prevText: '<上月', 
	//         prevStatus: '显示上月', 
	//         prevBigText: '<<', 
	//         prevBigStatus: '显示上一年', 
	//         nextText: '下月>', 
	//         nextStatus: '显示下月', 
	//         nextBigText: '>>', 
	//         nextBigStatus: '显示下一年', 
	//         currentText: '今天', 
	//         currentStatus: '显示本月', 
	//         monthNames: ['一月','二月','三月','四月','五月','六月', '七月','八月','九月','十月','十一月','十二月'], 
	//         monthNamesShort: ['一','二','三','四','五','六', '七','八','九','十','十一','十二'], 
	//         monthStatus: '选择月份', 
	//         yearStatus: '选择年份', 
	//         weekHeader: '周', 
	//         weekStatus: '年内周次', 
	//         dayNames: ['星期日','星期一','星期二','星期三','星期四','星期五','星期六'], 
	//         dayNamesShort: ['周日','周一','周二','周三','周四','周五','周六'], 
	//         dayNamesMin: ['日','一','二','三','四','五','六'], 
	//         dayStatus: '设置 DD 为一周起始', 
	//         dateStatus: '选择 m月 d日, DD', 
	//         dateFormat: 'yy-mm-dd', 
	//         firstDay: 1, 
	//         initStatus: '请选择日期', 
	//         isRTL: false}; 
	//   $.datepicker.setDefaults($.datepicker.regional['zh-CN']);
	// 
	$("[data-datepicker]").datetimepicker(
		{"datepicker":
			{"dateFormat":"yy-mm-dd",
			"dayNames":['星期日','星期一','星期二','星期三','星期四','星期五','星期六'],
			"dayNamesShort":['周日','周一','周二','周三','周四','周五','周六'],
			"dayNamesMin":['日','一','二','三','四','五','六'],
			"firstDay":1,
			"monthNames":['一月','二月','三月','四月','五月','六月', '七月','八月','九月','十月','十一月','十二月'],
			"monthNamesShort":['一','二','三','四','五','六', '七','八','九','十','十一','十二'],
			"showOn": "button",
			"buttonImage": "/assets/calendar.png",
			"buttonImageOnly": true
			},
		"timepicker":
			{"amPmText":["",""],
				"hourText":"小时",
				"minuteText":"分钟",
				"showPeriod":false,
				"value":""},
			"showTime":false});
});



/*
 * RailsAdmin date/time picker @VERSION
 *
 * License
 *
 * http://www.railsadmin.org
 *
 * Depends:
 *   jquery.ui.core.js
 *   jquery.ui.widget.js
 *   jquery.ui.datepicker.js
 *   jquery.ui.timepicker.js (http://plugins.jquery.com/project/timepicker-by-fgelinas)
 */

(function($) {

  $.widget("ra.datetimepicker", {
    options: {
      showDate: true,
      showTime: true,
      datepicker: {},
      timepicker: {}
    },

    _create: function() {
      var widget = this;
      this.element.hide();

      if (this.options.showTime) {
        this.timepicker = $('<input type="text" value="' + (this.options.timepicker.value || this.element.val()) + '" />');

        this.timepicker.css("width", "60px");

        this.timepicker.insertAfter(this.element);

        this.timepicker.bind("change", function() { widget._onChange(); });

        this.timepicker.timepicker(this.options.timepicker);
      }

      if (this.options.showDate) {
        this.datepicker = $('<input type="text" value="' + (this.options.datepicker.value || this.element.val()) + '" />');

        this.datepicker.css("margin-right", "10px");
        this.datepicker.css("width", "180px");

        this.datepicker.insertAfter(this.element);

        this.datepicker.bind("change", function() { widget._onChange(); });

        this.datepicker.datepicker(this.options.datepicker);
      }
    },

    _onChange: function() {
      var value = [];

      if (this.options.showDate) {
        value.push(this.datepicker.val());
      }

      if (this.options.showTime) {
        value.push(this.timepicker.val());
      }

      this.element.val(value.join(" "));
    }
  });
})(jQuery);