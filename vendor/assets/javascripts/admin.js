// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require rails-ujs
//= require turbolinks
//= require select2
//= require_tree .

handle_date_picker_fields = function () {
    $('.datepicker').datepicker();

    // Correctly display range dates
    $('.date-range-filter .datepicker-from').datepicker('option', 'onSelect', function (selectedDate) {
        $(".date-range-filter .datepicker-to").datepicker("option", "minDate", selectedDate);
    });
    $('.date-range-filter .datepicker-to').datepicker('option', 'onSelect', function (selectedDate) {
        $(".date-range-filter .datepicker-from").datepicker("option", "maxDate", selectedDate);
    });
}

$(document).on('turbolinks:load', function () {
    $('select.select2').chosen({width: '100%'});
    handle_date_picker_fields();
});