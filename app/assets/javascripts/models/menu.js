$(function() {
    $("[add_menu]").live("click", function() {
        $.get($('[add_menu]').attr('add_menu'),
            function(data, status) {
                if (status == 'success') {
                    $("#menu").html(data);
                }
            }, 'html')
        $("#menu").modal();
    });


    $("[reorder_menu]").live("click", function() {
        $.get($('[reorder_menu]').attr('reorder_menu'),
            function(data, status) {
                if (status == 'success') {
                    $("#menu").html(data);
                }
            }, 'html')
        $("#menu").modal();
    });

});

function edit_menu(url) {
    $.get(url, function(data, status) {
        if (status == 'success') {
            $("#menu").html(data);
        }
    }, 'html')
    $("#menu").modal();
}