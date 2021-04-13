;

function debug(text) {
    console.log(text);
}

function select_bind_data($select, $data, $value, $name) {
    $select.empty();
    for (var index in $data) {
        var json = $data[index];
        var option = $("<option value='" + json[$value] + "'>" + json[$name] + "</option>");
        $select.append(option);
    }
}

function startWait() {
    stopWait();
    $('body').append("<div id='waiting'>" +
        "<p class='tip' style=''>请稍候....... <a href='#' class='close_btn'>关闭</a></p></div>");
    var screenWidth = $(window).width();//当前窗口宽度
    var screenHeight = $(window).height();//当前窗口高度

    $("#waiting").css({
        "display": "",
        "position": "fixed",
        "background": "#000",
        "z-index": "9999",
        "-moz-opacity": "0.3",
        "opacity": ".30",
        "filter": "alpha(opacity=30)",
        "width": screenWidth,
        "height": screenHeight,
        "top": 0,
        "text-align": "center",
        "color": '#000000',
        "padding-top": screenHeight / 2
    });
    $("#waiting .tip").css({
        "text-align": "center",
        "color": "#ff0000",
        "background-color": "#FFFFFF",
        "width": "200px",
        "margin": "0px auto",
        "height": "100px",
        "padding-top": "40px"
    });
    $("#waiting .close_btn").click(function (event) {
        event.preventDefault();
        stopWait();
    });
}

function stopWait() {
    $("#waiting").remove();
}

$(function () {

    $(".default_table").addClass('table table-striped table-condensed').removeClass('default_table');
    $('.default-btn').addClass('btn btn-default')

    $("form").attr("autocomplete", "off");
    $("body").on("shown.bs.modal", ".modal", function () {
        $(this).find("form").attr("autocomplete", "off");
    });
    // 每次都获取新的
    $("body").on("hidden.bs.modal", ".modal", function () {
        $(this).removeData("bs.modal");
        $(this).remove();

    });

    $(document).on('focus', '.form_datetime', function (event) {
        $(this).datetimepicker({
            language: "zh-CN",
            format: 'yyyy-mm-dd hh:ii:ss',
            autoclose: 1,
            todayBtn: 0,
            todayHighlight: 1,
            startView: 2,
            minView: 0
        });
    });

    $(document).on('focus', '.date_start', function (event) {
        $(this).datetimepicker({
            language: "zh-CN",
            format: 'yyyy-mm-dd 00:00:00',
            autoclose: 1,
            todayBtn: 0,
            todayHighlight: 1,
            startView: 2,
            minView: 2
        });
    });

    $(document).on('focus', '.date_end', function (event) {
        $(this).datetimepicker({
            language: "zh-CN",
            format: 'yyyy-mm-dd 23:59:59',
            autoclose: 1,
            todayBtn: 0,
            todayHighlight: 1,
            startView: 2,
            minView: 2
        });
    });

    $(document).on('click', '.modal_action', function (event) {
        event.preventDefault();
        var self = $(this);
        var url = self.attr("href");

        $.get(url, function (resp) {
            if (resp.redirect_url) {
                top.window.location.href = resp.redirect_url;
                return;
            }
            if (resp.error_url) {
                top.window.location.href = resp.error_url;
                return;
            }
            var title = self.html();
            var html = '<div class="modal" id="normal_modal" data-backdrop="static">' +
                '<div class="modal-dialog">' +
                '<div class="modal-content">' +
                '<div class="modal-header">' +
                '<button type="button" class="close" data-dismiss="modal">&times;</button>' +
                '<h4 class="modal-title">' + title + '</h4>' +
                '</div>' +

                '<div class="modal-body">' +
                resp +
                '</div>' +
                '</div>' +
                '</div>' +
                '</div>';


            $("#normal_modal").remove();
            $("body").append(html);
            $("#normal_modal").modal('show');

        });

        return false;

    });


    //单张图片查看大图
    $(document).on('click', '.image_once_click', function (event) {
        event.preventDefault();
        var self = $(this);
        var url = self.attr("src");

        var title = '预览';
        var html = '<div class="modal" id="normal_modal" data-backdrop="static">' +
            '<div class="modal-dialog">' +
            '<div class="modal-content">' +
            '<div class="modal-header">' +
            '<button type="button" class="close" data-dismiss="modal">&times;</button>' +
            '<h4 class="modal-title">' + title + '</h4>' +
            '</div>' +

            '<div class="modal-body">' +
            '<img src="' + url + '" style="width:auto;max-width: 100%">' +
            '</div>' +
            '</div>' +
            '</div>' +
            '</div>';


        $("#normal_modal").remove();
        $("body").append(html);
        $("#normal_modal").modal('show');

        return false;

    });

    //多张图片查看大图
    $(document).on('click', '.image_swiper_click', function (event) {
        event.preventDefault();
        var self = $(this);
        var imgs = self.attr("data-img_ids");//多张图片id且用英文,分隔
        var current_img_id = self.attr('target');//当前图片id
        var img_arr = imgs.split(',');

        var html = '<div class="modal fade bs-example-modal-lg" tabindex="-1" role="dialog" id="normal_modal">' +
            '<div class="modal-dialog modal-lg" role="document">' +
            '<div class="modal-content">' +
            '<div class="modal-header">' +
            '<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>' +
            '<h4 class="modal-title">图片</h4>' +
            '</div>' +
            '<div class="modal-body">' +
            '<div id="carousel-example-generic" class="carousel slide" data-ride="carousel">' +

            '<ol class="carousel-indicators">';


        for (var i = 0; i < img_arr.length; i++) {
            html += '<li data-target="#carousel-example-generic" data-slide-to="' + i + '"';
            var img_id = img_arr[i];
            if (img_id == current_img_id) {
                html += ' class="active"';
            }
            html += '></li>';
        }
        html += '</ol>' +

            '<div class="carousel-inner" role="listbox">';

        for (var j = 0; j < img_arr.length; j++) {
            var img_id = img_arr[j];
            if (img_id == current_img_id) {
                html += '<div class="item active">';
            } else {
                html += '<div class="item">';
            }
            var img_url = $('#' + img_id).attr('data-origin_img');//图片url
            html += '<img src="' + img_url + '" width="100%" alt="图片">';

            html += '<div class="carousel-caption">' +
                '</div>' +
                '</div>';
        }

        html += ' </div>' +

            '<a class="left carousel-control" href="#carousel-example-generic" role="button" data-slide="prev">' +
            '<span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>' +
            '<span class="sr-only">Previous</span>' +
            '</a>' +
            '<a class="right carousel-control" href="#carousel-example-generic" role="button" data-slide="next">' +
            '<span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>' +
            '<span class="sr-only">Next</span>' +
            '</a>' +
            '</div>' +
            '</div>' +
            '<div class="modal-footer">' +
            '<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>' +
            '</div>' +
            '</div>' +
            '</div>' +
            '</div>';

        $("#normal_modal").remove();
        $("body").append(html);
        $("#normal_modal").modal('show');

        return false;

    });


    //  $('.datetime').datetimepicker();

    $(document).on('submit', ".ajax_form", function (event) {
        event.preventDefault();
        var self = $(this);
        var url = self.attr("action");
        self.ajaxSubmit({
            success: function (resp, status, xhr) {

                if (resp.code < 0) {
                    alert(resp.msg)
                }

                var loc=xhr.getResponseHeader('Location')
                if (loc) {
                    top.window.location.href = loc;
                    return;
                }

                if (resp.reload) {
                    top.window.location.reload();
                    return;
                }
            }
        });

        return false;
    });

    $(document).on('submit', '.ajax_model_form', function (event) {
        event.preventDefault();
        var self = $(this);
        var url = self.attr("action");
        var model = self.data("model");
        if (!model) {
            alert('没有定义data-model');
            return;
        }
        var action = "edit";
        if (url.match(/create/i)) {
            action = "create";
        }
        startWait();
        self.ajaxSubmit({
            error: function (xhr, status, error) {
                stopWait();
                alert('服务器错误 ' + error);
            },

            success: function (resp, status, xhr) {

                stopWait();
                var loc=xhr.getResponseHeader('Location')
                if (loc) {
                    top.window.location.href = loc;
                    return;
                }
                if (resp.reload) {
                    top.window.location.reload();
                    return;
                }
                if (resp.code < 0) {
                    alert(resp.msg);
                    // self.find(".msg").html(resp.msg);
                    // self.find(".msg").show();
                } else {
                    top.window.location.reload();
                    return

                    var tpl = $("#" + model + "_tpl").html();
                    if (tpl && resp[model]) {
                        var compiled_tpl = juicer(tpl);
                        var html = compiled_tpl.render(resp);


                        if (action == "edit") {
                            $("#" + model + "_" + resp[model].id).replaceWith(html);
                        } else {
                            var list = $('#' + model + '_list');

                            if (list.length < 1) {
                                list = $('#_list');
                            }

                            if (list.hasClass("fix_top")) {
                                list.find(":first").after(html);
                            } else {
                                list.prepend(html);
                            }
                        }
                    }
                    self.parents('.modal').modal("hide");
                }

            }
        });

        return false;

    });


    $('.ajax_action').click(function (event) {
        event.preventDefault();
        var self = $(this);

        $.ajax({url: self.attr("href")}).done(function (resp) {
            var loc=xhr.getResponseHeader('Location')
            if (loc) {
                top.window.location.href = loc;
                return;
            }
            if (resp.reload) {
                top.window.location.reload();
                return;
            }

            if (0 != resp.code) {
                alert(resp.msg);
            } else {
                var model = self.parents("[data-model]").data('model');
                $.each(resp, function (k, v) {
                    $('#' + model + "_" + resp.id + "_" + k).html(v);
                });
            }
        });
    });

    $(document).on('click', '.delete_action', function (event) {
        event.preventDefault();
        if (confirm('确定删除?')) {

            var self = $(this);
            var url = self.attr("href");
            $.get(url, function (resp) {
                var loc=xhr.getResponseHeader('Location')
                if (loc) {
                    top.window.location.href = loc;
                    return;
                }
                if (resp.reload) {
                    top.window.location.reload();
                    return;
                }
                if (resp.code == 0) {
                    $(self.data("target")).remove();
                } else {
                    alert(resp.msg);
                }


            });
        }
        return false;
    });


    $(".submit_btn").click(function (event) {

        event.preventDefault();

        $(this).parents("form").ajaxSubmit({
            success: function (resp) {
                var loc=xhr.getResponseHeader('Location')
                if (loc) {
                    top.window.location.href = loc;
                    return;
                }
                if (resp.reload) {
                    top.window.location.reload();
                    return;
                }

                if (0 != resp.code) {

                    alert(resp.msg);
                } else {
                    location.reload();
                }
                $('.ui.modal').modal('hide');
            }
        });
    });

    $('.once_click').click(function (event) {
        event.preventDefault();
        var self = $(this);
        var url = self.attr("href");
        $.get(url, function (resp) {
            var loc=xhr.getResponseHeader('Location')
            if (loc) {
                top.window.location.href = loc;
                return;
            }
            if (resp.reload) {
                top.window.location.reload();
                return;
            }
            alert(resp.msg);
        });
        return false;
    });

    $("body").on('submit', '.page_form', function (event) {

        event.preventDefault();
        action = $(this).attr('action');
        page = $(this).find('[name=page]').val();
        page = parseInt(page);
        if (isNaN(page)) {
            page = 1;
        }
        if (action.indexOf('?') > 0) {
            action += '&page=' + page;
        }
        target = $(this).parents('.ajax_content');
        if (target.length > 0) {

            $.get(action, function (resp) {
                target.html(resp);
            });
            return;
        }
        location.href = action;
        return false;
    });
});
