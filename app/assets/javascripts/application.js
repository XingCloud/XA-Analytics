// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//

//= require ./cdn.js
//= require base64
//= require jquery.blockUI
//= require jquery.form_to_json
//= require table2CSV
//= require bootstrap-datepicker
//= require i18n
//= require private_pub
//= require jquery.pnotify
//= require ./locales/en
//= require_directory ./backbone
//= require_directory ./backbone/lib
//= require_tree ./backbone/models
//= require_tree ./backbone/collections
//= require_tree ./backbone/templates
//= require_tree ./backbone/views
//= require_tree ./backbone/routers

$.pnotify.defaults.styling = "bootstrap";
$.pnotify.defaults.history = false;
