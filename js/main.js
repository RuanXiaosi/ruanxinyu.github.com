$(function () {
    function updateTitleDisplayStatus() {
        $("#questions a").each(function(index) {
            var text = $("#question_search_text").val();
            if (text.trim() == "") {
                $("#questions li").show();
                return false;
            }

            if ($(this).text().toLowerCase().indexOf(text.toLowerCase()) != -1) {
                $(this).parents("li").show();
            } else {
                $(this).parents("li").hide();
            }
        });
    }
    
    $("#question_search_text").keyup( () => {
        updateTitleDisplayStatus();
        return false;
    });

    if (window.location.pathname == "/pages/questions/") {
        var text = window.location.search.match(/[?&]q=([^&]*)/);
        if (text) {
            $("#question_search_text").val(text[1]);
            updateTitleDisplayStatus();
        }
    }

    $("#global_search").click( () => {
        window.location.href = "/pages/questions/?q=" + $("#global_search_text").val();
        return false;
    });
})
