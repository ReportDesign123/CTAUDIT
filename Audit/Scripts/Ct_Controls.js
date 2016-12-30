/// <reference path="../lib/jquery/jquery-1.11.1.min.js" />

(function ($) {

    $.fn.PopEdit = function (options) {

        var g = $(this);
        g.id = g.attr("id");
        g.html('<input type="text" style=" width:131px; height:18px;" id="' + g.id + 'name"  class="ctPopEdit"/><input type="button" value="..."   id="' + g.id + 'btn"  style=" width:18px; height:22px;border-left:0px; text-align:left; padding-left:0px;" class=" ctPopEdit PopButton"/><input  id="' + g.id + 'value"  type="hidden" />');
         g.value = $("#" + g.id + "value");
           g.name = $("#" + g.id + "name");
            g.btn = $("#" + g.id + "btn");        
        return g;
    }

    $.fn.Btn = function (options) {
        var defaultO = {
            click: "",
            text: "",
            icon: "",
            id: ""
        };
        $.extend(defaultO, options);

        var g = $(this);
        defaultO.id = g.attr("id");
        g.txtSpan = $("<span>" + defaultO.text + "</span>");
        g.btnL = $("<div id='lef'></div>");
        g.btnR = $("<div id='l'></div>");
        g.Icon = $(" <div id='r' ></div>");

        g.append(g.txtSpan);
        g.append(g.btnL);
        g.append(g.btnR);
        g.append(g.Icon);

        g.addClass("ctBtn ctBtnHasIcon ctBtnPanel");
        g.Icon.addClass("ctBtnIcon");
        if (defaultO.icon != "") {
            g.Icon.addClass("ct-" + defaultO.icon + "-Icon");
        }
        g.bind("mouseover", function () {
            $(this).addClass("ctBtnOver");
            g.btnL.addClass("ctBtnPanelLeft");
            g.btnR.addClass("ctBtnPanelRight");
        });
        g.bind("click", defaultO.click);
        g.bind("mouseout", function () {
            $(this).removeClass("ctBtnOver");
            g.btnL.removeClass("ctBtnPanelLeft");
            g.btnR.removeClass("ctBtnPanelRight");
        });
        return g;
    }

})(jQuery);