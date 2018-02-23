var dialog = {
    modalHtml: '<div  id="{modalID}"><iframe modalID="{modalID}" src="{url}" style="height:100%; width:100%;"  frameborder="0"></iframe></div>',
    DialogDefaults: {
        title: "窗口",
        resizable: true,
        width: 500,
        height: 450,
        modal: true,
        onClose: function (d) {//关闭时回调函数
            if (d.isChange == true) {//区分 窗口的 手动关闭方法，确定关闭方法前要设置 d.isChange=true
                //触发回调函数
            }
        },
    },
    guid: function () {
        function S4() {
            return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1);
        }
        return (S4() + S4() + "-" + S4() + "-" + S4() + "-" + S4() + "-" + S4() + S4() + S4());
    },
    GetTopWindow: function (currentWindow) {

        currentWindow = currentWindow || window;

        if (currentWindow.top !== undefined && currentWindow.top !== null && currentWindow.top !== currentWindow) {
            return this.GetTopWindow(currentWindow.top);
        }
        return currentWindow;

    },
    Open: function (url, title, para, callback, options) {

        var opts = $.extend({}, this.DialogDefaults, options || {});
        var modelID = "model" + this.guid();
        opts.modelID = modelID;
        if (title && title.length > 0) {
            opts.title = title;
        }
        if ($.isFunction(callback)) {
            opts.onClose = function () {//关闭时回调函数
                var topWindow = dialog.GetTopWindow();
                var returnValue = topWindow.returnValue || {};

                if (returnValue.isChange == true) {//区分 窗口的 手动关闭方法，确定关闭方法前要设置 d.isChange=true
                    callback(returnValue.Data);
                }
            };
        }
        //根据模板创建界面内容
        var html = this.modalHtml.replace(/\{modalID}/g, modelID).replace(/\{url}/g, url);
        var $modelElement = $(html);
        //将当前html 附加在顶级窗口的body上
        var topWindow = this.GetTopWindow();
        opts.TopDocument = topWindow.document;
        opts.currentDocument = window.document;
        $modelElement.appendTo(topWindow.document.body);
        opts.element = $modelElement;
        if (para!=undefined) {
            this.para(para);
        }
        topWindow.openDialog(modelID, opts);

    },

    show: function (modelID) {
        var topWindow = this.GetTopWindow();

        topWindow.showDialog(modelID);


    },
    close: function (modelID) {
        var topWindow = this.GetTopWindow();

        topWindow.closeDialog(modelID);

    },
    setVal: function (val) {
        var topWindow = this.GetTopWindow();
        topWindow.returnValue = { isChange: true, Data: val };

    },
    para: function (para) {
        var topWindow = this.GetTopWindow();
        if (para == undefined) {
            //取值
            return topWindow.dialogArguments;
        } else {
            //赋值
            topWindow.dialogArguments = para;
        }

    }
};



