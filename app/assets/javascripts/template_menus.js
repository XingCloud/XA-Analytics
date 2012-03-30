$(function() {
    $("[add_menu]").live("click", function() {
        $.get('/admin/template_menus/new',
            function(data, status) {
                if (status == 'success') {
                    $("#menu").html(data);
                }
            }, 'html')
        $("#menu").modal();
    });

    $("[reorder_menu]").live("click", function() {
        $.get('/admin/template_menus/reorder',
            function(data, status) {
                if (status == 'success') {
                    $("#menu").html(data);
                }
            }, 'html')
        $("#menu").modal();
    });

});

//
function edit_menu(url) {
    $.get(url, function(data, status) {
        if (status == 'success') {
            $("#menu").html(data);
        }
    }, 'html')
    $("#menu").modal();
}
