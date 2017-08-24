
/// <reference path="../lib/jquery/jquery-1.11.1.min.js" />
//$.ajaxSetup("beforeSend", function () {
//    top.loader && loader.open();
//});
//$.ajaxSetup("complete", function () {
//    top.loader && loader.close();
//});
//数据管理
var DataManager = {
    sendData: function (url, parameters, successFunc, failFunc, isOrNotAsync) {
      
        if (isOrNotAsync == null || isOrNotAsync == "undefined") isOrNotAsync = false;
         
        $.ajax(
        {
            url: url,
            data: parameters,
            dataType:"json",
            type: "post",
            success: successFunc,
            async: isOrNotAsync,
            error: failFunc
        }
        );
    }
};

var MessageManager = {
    InfoMessage: function (message) {
        $.messager.show({
            title: '系统提示',
            msg: message,
            timeout: 5000,
            showType: 'slide'
        });
    },
    ErrorMessage: function (message) {

        $.messager.alert('系统提示', message, 'error');
    },
    WarningMessage: function (message) {
        $.messager.alert('系统提示', message, 'warning');
    }
};
