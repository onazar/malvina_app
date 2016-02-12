// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require bootstrap-sprockets
//= require jquery_ujs
// require turbolinks
//= require_tree .

$(function() {
  var $rows = $('.table tbody tr');
  $('#search').keyup(function () {
    var val = $.trim($(this).val()).replace(/ +/g, ' ').toLowerCase();

    $rows.show().filter(function () {
      var text = $(this).text().replace(/\s+/g, ' ').toLowerCase();
      return !~text.indexOf(val);
    }).hide();
  });

  $('.table tbody tr').click(function () {
    window.location.href = $(this).data('url');
  });
});
