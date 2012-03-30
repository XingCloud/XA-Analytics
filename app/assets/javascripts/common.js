$.extend({
	'dialog': {
		'open': function (opts) {
			/**
			 * 前端JS直接绘制一个对话框,加载特定URL的iframe
			 * openDialog(opts)
			 */		    
			if (typeof(opts) != 'object') { alert('please input options'); return false; }
			opts.iframeUrl && !opts.url && (opts.url = opts.iframeUrl);
			opts.url.match("http:") || (opts.url = opts.url);
			console.log(opts)
			var len = $.dialog.list.length;
			
		    //当前对话框
		    var $dlg = top.$('<div><iframe frameborder="0" width="100%" height="100%" src="' + opts.url + '"></iframe></div>');
		    var option = {
		        title   : opts.title || 'title',
		        height  : opts.height || $(top).height() * 0.95,
		        width   : opts.width || '95%',
		        zIndex  : 99999,
		        modal   : opts.modal || true,
		        bgiframe: true,
		        create: function(event, ui) {
              $("body").css({ overflow: 'hidden' })
             },
             beforeClose: function(event, ui) {
              $("body").css({ overflow: 'inherit' })
             },
		        close: function() {
		            //判断是否是登录页面
		            if (/passport\.oa\.com\/modules\/passport\/signin\.ashx/.test(opts.url)) {
		                top.removeQueryString && top.removeQueryString('isLogining');
		            }
		            
		            (typeof(opts.close) == 'function') && opts.close();
		            $.dialog.list[len] = null;
		            var ll = $.dialog.list.length;
		            while(ll--) {
		            	if ($.dialog.list[ll] != null) {
		            		$.dialog.curr = $.dialog.list[ll];
		            		break;
		            	}
		            }
		            
		            $dlg.find('iframe').remove();
		            $dlg.remove();
		            $dlg.dialog('destroy');
		            
		        },
		        focus: function (ev, data) {
		        	$.dialog.curr = $dlg;
		        },
		    	buttons: opts.buttons || null
		    };
		    
		    //设置iframe的参数
		    $dlg.dialog(option);
		    $dlg.dialog('open');
		    $.dialog.list.push($dlg);
		    //$dlg.find('iframe')[0].contentWindow.__parent = $dlg;
		},
		'list': [], /** 当前打开的对话框列表 */
		'curr': null, /** 当前激活的对话框 */
		'self': null /** 父框架当前激活的对话框，即本身 */
	}, 	
	'url': function (attr, value) {
		switch (attr) {
			case 'all':
				break;
			case 'uri':
				break;
			case 'anchor':
				break;
			default:
				if (value) {
					//setter
				} else {
					//getter
					var i = url.indexOf('&' + name + '=');
			    	var j = url.indexOf('&', i + 1);
			    	var next = j == -1 ? '' : url.substr(j);                   
			    	return url.substr(0, i) + "&" + name + "=" + value + next;
				}
				break;
		}
	},
	'cookie': function (name, value, options) {
	    if (typeof value != 'undefined') {
	        options = options || {};
	        if (value === null) {
	            value = '';
	            options = $.extend({}, options);
	            options.expires = -1;
	        }
	        var expires = '';
	        if (options.expires && (typeof options.expires == 'number' || options.expires.toUTCString)) {
	            var date;
	            if (typeof options.expires == 'number') {
	                date = new Date();
	                date.setTime(date.getTime() + (options.expires * 24 * 60 * 60 * 1000));
	            } else {
	                date = options.expires;
	            }
	            expires = '; expires=' + date.toUTCString();
	        }
	        var path = options.path ? '; path=' + (options.path) : '';
	        var domain = options.domain ? '; domain=' + (options.domain) : '';
	        var secure = options.secure ? '; secure' : '';
	        document.cookie = [name, '=', encodeURIComponent(value), expires, path, domain, secure].join('');
	    } else {
	        var cookieValue = null;
	        if (document.cookie && document.cookie != '') {
	            var cookies = document.cookie.split(';');
	            for (var i = 0; i < cookies.length; i++) {
	                var cookie = jQuery.trim(cookies[i]);
	                if (cookie.substring(0, name.length + 1) == (name + '=')) {
	                    cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
	                    break;
	                }
	            }
	        }
	        return cookieValue;
	    }
	},
	'msg': function (msg, type) {
	},
	'json': {
		'encode': (function () {
			var useHasOwn = !!{}.hasOwnProperty;  
			var pad = function(n) {  
				return n < 10 ? "0" + n : n;  
			};  
			var m = {  
				"\b" : '\\b',  
				"\t" : '\\t',  
				"\n" : '\\n',  
				"\f" : '\\f',  
				"\r" : '\\r',  
				'"' : '\\"',  
				"\\" : '\\\\'  
			}; 
			return (function(o) {  
				if (typeof o == "undefined" || o === null) {  
					return "null";  
				} else if (Object.prototype.toString.call(o) === '[object Array]') {  
					var a = ["["], b, i, l = o.length, v;  
					for (i = 0; i < l; i += 1) {  
						v = o[i];  
						switch (typeof v) {  
							case "undefined" :  
							case "function" :  
							case "unknown" :  
								break;  
							default :  
								if (b) {  
									a.push(',');  
								}  
								a.push(v === null ? "null" : Cmdb.Json.encode(v));  
								b = true;  
						}  
					}  
					a.push("]");  
					return a.join("");  
				} else if ((Object.prototype.toString.call(o) === '[object Date]')) {  
					return '"' + o.getFullYear() + "-" + pad(o.getMonth() + 1) + "-" + pad(o.getDate()) + "T" + pad(o.getHours()) + ":" + pad(o.getMinutes()) + ":" + pad(o.getSeconds()) + '"';  
				} else if (typeof o == "string") {  
					if (/["\\\x00-\x1f]/.test(o)) {  
						return '"' + o.replace(/([\x00-\x1f\\"])/g, function(a, b) {  
							var c = m[b];  
							if (c) {  
								return c;  
							}  
							c = b.charCodeAt();  
							return "\\u00" + Math.floor(c / 16).toString(16) + (c % 16).toString(16);  
						}) + '"';  
					}  
					return '"' + o + '"';  
				} else if (typeof o == "number") {  
					return isFinite(o) ? String(o) : "null";  
				} else if (typeof o == "boolean") {  
					return String(o);  
				} else {  
					var a = ["{"], b, i, v;  
					for (i in o) {  
						if (!useHasOwn || o.hasOwnProperty(i)) {  
							v = o[i];  
							if (v === null) {  
								continue;  
							}  
							switch (typeof v) {  
								case "undefined" :  
								case "function" :  
								case "unknown" :  
									break;  
								default :  
									if (b) {  
										a.push(',');  
									}  
									a.push(this.encode(i), ":", this.encode(v));  
									b = true;  
							}  
						}  
					}  
					a.push("}");  
					return a.join("");  
				}  
			});  
		})(),
		'decode': function (json) {
			return eval("(" + json + ')');
		}
	}
});
$.openDialog = $.dialog.open;

function close_dialog(){
	
	for(var i = 0; i < parent.$.dialog.list.length; i ++ ) {
		var dialog = parent.$.dialog.list[i];
		
		if (dialog) {
			dialog.dialog("close");
		}
	}
	
}

$(function() {
	$("[data-popup]").live("click", function() {
		var attrs = String($(this).data("popup")).split(";");
		var link = {};
		for(var i = 0; i < attrs.length; i++) {
			link[attrs[i].split(":")[0]] = attrs[i].split(":")[1];
		}
		
		//console.log(link)
		var options = {width: link.width || "1000px", url: $(this).attr("href"), title: $(this).attr("title"), height: link.height }
		$.openDialog(options)
		return false;
	})
})