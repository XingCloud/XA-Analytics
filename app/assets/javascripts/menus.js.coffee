jQuery ->
    $('#sortable').nestedSortable({
            listType: 'ul',
            items: 'li',
            maxLevels: 2
    })

    $("#sortable form").submit ->
        serialization = $("#sortable ul:first-child").nestedSortable('serialize')
        input = $("<input>").attr("type", "hidden").attr("name", "menu").val(serialization)
        $(this).append($ input)
