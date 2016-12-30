/// <reference path="../../../lib/jquery/jquery-1.11.1.min.js" />
/// <reference path="../../../lib/easyUI/jquery.easyui.min.js" />
//生产者：设置参数、获取结果
//消费者：获取参数、设置获取选中数据的函数

var pubHelp = {
    parameters: {},
    resultObj: {},
    DialogId: "",
    SaveFunc: "",
    FuncGetObj: "",
    IframeDialog: {  DialogId: "", SaveFunc: "",FunctionGetObj:"" },
    getParameters: function () {
        //消费者参数
        return pubHelp.parameters;
    },
    getIframeParentParameters: function () {
        return parent.pubHelp.parameters;
    },
    setParameters: function (parameters) {
        //生产者
        pubHelp.parameters = parameters;
    },
    getResultObj: function () {
        return pubHelp.resultObj;
    },
    setResultObj: function (result) {
        pubHelp.resultObj = result;
    },

    setResultObjFunc: function (FuncGetObj) {
        pubHelp.FuncGetObj = FuncGetObj;
    },
    setResultObjIframeFunc:function(FuncGetObj){
        parent.pubHelp.IframeDialog.FunctionGetObj = FuncGetObj;
    },
    OpenDialogNoHref: function (Id, title, SaveFunction, width, height, isOrModal) {
        pubHelp.SaveFunc = SaveFunction;
        pubHelp.DialogId = Id;
        $('#' + Id).dialog({
            title: title,
            width: width,
            height: height,
            closed: false,
            cache: false,
            inline: false,
            modal: isOrModal,
            buttons: [
    {
        text: '确定',
        iconCls: "icon-ok",
        handler: function () {
            if (pubHelp.FuncGetObj) {
                pubHelp.setResultObj(pubHelp.FuncGetObj());
            }
            if (SaveFunction) {
                SaveFunction();
            }
            $('#' + Id).dialog("close");
        }

    },
    {
        text: '取消',
        iconCls: "icon-cancel",
        handler: function () {
            $('#' + Id).dialog("close");
        }
    }
    ]
        });
    },
    OpenDialogWithHref: function (Id, title, url, SaveFunction, width, height, isOrModal) {
        pubHelp.SaveFunc = SaveFunction;
        pubHelp.DialogId = Id;
        $('#' + Id).dialog({
            title: title,
            width: width,
            height: height,
            closed: false,
            cache: false,
            inline:false,
            href: url,
            modal: isOrModal,
            buttons: [{
                text: '保存',
                iconCls: "icon-ok",
                handler: function () {
                    if (pubHelp.FuncGetObj) {
                        pubHelp.setResultObj(pubHelp.FuncGetObj());
                    }
                    if (SaveFunction) {
                        SaveFunction();
                    }

                    $('#' + Id).dialog("close");
                }
            },
                        {
                            text: '取消',
                            iconCls: "icon-cancel",
                            handler: function () {
                                $('#' + Id).dialog("close");
                            }
                        }
                        ]
        });
    },
    OpenDialogWithIframe: function (Id, title, SaveFunction, width, height, isOrModal) {

        pubHelp.IframeDialog.SaveFunc = SaveFunction;
        pubHelp.IframeDialog.DialogId = Id;
        $('#' + Id).dialog({
            title: title,
            width: width,
            height: height,
            closed: false,
            cache: false,
            inline: false,
            modal: isOrModal,
            buttons: [
    {
        text: '确定',
        iconCls: "icon-ok",
        handler: function () {
           
            if (pubHelp.IframeDialog.FunctionGetObj) {
                pubHelp.setResultObj(pubHelp.IframeDialog.FunctionGetObj());
            }
            if (SaveFunction) {
                SaveFunction();
            }
            $('#' + Id).dialog("close");
        }

    },
    {
        text: '取消',
        iconCls: "icon-cancel",
        handler: function () {
            $('#' + Id).dialog("close");
        }
    }
    ]
        });
    },
    CloseDialog: function () {
        if (pubHelp.DialogId != "") {
            $('#' + pubHelp.DialogId).dialog("close");
        }
        if (pubHelp.SaveFunc != "") {
            pubHelp.SaveFunc();
        }

    }
};