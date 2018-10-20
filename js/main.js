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

    $(".content-encrypt-display").click(function() {
        var password = $(this).prev(".content-encrypt-password").val();
        $(".content-encrypt-display").each(function(index) {
            var content = CryptoJS.AES.decrypt($(this).attr("content"), password).toString(CryptoJS.enc.Utf8);
            var encryptDiv = $(this).parents(".content-encrypt-div");
            $(this).parents(".content-encrypt-div").after(content);
            encryptDiv.hide();
        });
        return false;
    });

    if (document.body.scrollWidth < 768) {
        $(".col-toc").hide();
        $(".col-content").removeClass("col-10 col-8").addClass("col-12");
    } else {
        var project = window.location.href.match(/\/posts\/(.*)\/\?project=([^&]*)/);
        if (project) {
            var projectName = decodeURI(project[2]);
            var postName = decodeURI(project[1]);
            $.get("/data/projects.json", function(data) {
                for (var index in data) {
                    if (data[index].title == projectName) {
                        var toc = '<div class="col-2 pt-3 pl-0 position-fixed" style="overflow-y:auto; height:100%; width:100%"><h6 class="text-success">【项目】' + data[index].title  + '</h6><hr class="mt-0"><ol class="toc">';
                        for (var index1 in data[index].posts) {
                            if (data[index].posts[index1].url == "" || data[index].posts[index1].url == "#") {
                                toc += '<li class="toc-item toc-level-1">' + data[index].posts[index1].title + '</li>';
                            } else {
                                var text = '<li class="toc-item toc-level-1"><a href="' + data[index].posts[index1].url + '?project=' + data[index].title + '">&nbsp' + data[index].posts[index1].title + '</a></li>';
                                toc += data[index].posts[index1].title == postName ? "<strong>" + text + "</strong>" : text;
                            }
                            
                            if ("subPosts" in data[index].posts[index1] && data[index].posts[index1].subPosts.length > 0) {
                                toc += '<ol class="toc-child">';
                                for (var index2 in data[index].posts[index1].subPosts) {
                                    var text = '<li class="toc-item toc-level-1"><a href="' + data[index].posts[index1].subPosts[index2].url + '?project=' + data[index].title + '">&nbsp' + data[index].posts[index1].subPosts[index2].title + '</a></li>';
                                    toc += data[index].posts[index1].subPosts[index2].title == postName ? "<strong>" + text + "</strong>" : text;
                                }
                                toc += '</ol>';
                            }
                        }
                        toc += '</ol></div></div>';
                        $(".col-content").removeClass("col-10 col-12").addClass("offset-2 col-8").before(toc);
                        $(".pre-next-link").hide();
                        break;
                    }
                }
            });
        }
    }
})
