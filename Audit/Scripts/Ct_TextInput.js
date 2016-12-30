(function ($) {
    $.fn.CTTextBox = function (options) {
        var defaultO = {
            id: "",
            width: 200,
            height: 30,
            innerText: ""
        };
        $.extend(defaultO, options);

        var g = $(this);
        defaultO.id = g.attr("id");

        var b = $('<span id="sp_' + defaultO.id + '" class="ct-textBox" style=" width:' + defaultO.width + 'px; height:' + defaultO.height + 'px;"></span>');
        g.addClass("ct-textbox-prompt ct-textBox-text");
        g.attr("autocomplete", "off");
        g.attr("placeholder", defaultO.innerText);
        g.css("margin-left", 0);
        g.css("margin-right", 0);
        g.css("padding-top", "7px");
        g.css("padding-bottom", "7px");
        g.css("width", defaultO.width - 8);
        g.replaceWith(b);
        b.append(g);


        g.focus(function () {
            b.addClass("ct-textbox-focused");
            g.addClass("ct-textbox-text-focused");
        });
        g.blur(function () {
            b.removeClass("ct-textbox-focused");
            g.removeClass("ct-textbox-text-focused");
        });
        return g;

    }

})(jQuery);