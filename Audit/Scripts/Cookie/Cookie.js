/// <reference path="../../lib/jquery/jquery-1.11.1.min.js" />
/// <reference path="../../lib/Cookie/jquery.cookie.js" />
//Function：{UserId：{ { AuditType: { name: "", value: "" }, AuditDate: "", AuditTask: { name: "", value: "" }, AuditPaper: { name: "", value: ""} ,auditZqVisible:"0",auditPaperVisible:"0",auditZqType:"01",Nd:"",Zq:""}}}
var CookieDataManager = {
    //公式类型1为取数公式；2为计算公式；3为平衡公式
    General: { GeneralFunction: "General", GeneralData: { DataBase: ""} },
    CurrentUserId: "",
    SetCookieData: function (functionName, parameters) {
        try {
            if (CookieDataManager.CurrentUserId == "") {
                CookieDataManager.SetUser();
            }
            var option = { expires: 30 };
            var functionData = $.cookie(functionName);
            functionData = {};
            functionData[CookieDataManager.CurrentUserId + CookieDataManager.General.GeneralData.DataBase] = parameters;
            $.cookie(functionName, functionData, option);
        } catch (err) {
            alert(err.Message);
        }
    },
    GetCookieData: function (functionName) {
        try {
            if (CookieDataManager.CurrentUserId == "") {
                CookieDataManager.SetUser();
            }
            var functionData = $.cookie(functionName);
            if (functionData) {
                return functionData[CookieDataManager.CurrentUserId + CookieDataManager.General.GeneralData.DataBase];
            } else {
                return null;
            }
        } catch (err) {
            alert(err.Message);
        }
    },
    SetUser: function () {

        var user = $.cookie("UserInfo");

        if (typeof (user) == "undefined") {
            return;
        }

        var userInfo = user.split("&");
        var obj = {};
        for (var i = 0; i < userInfo.length; i++) {
            var nameValue = userInfo[i].split("=");
            obj[nameValue[0]] = nameValue[1];
        }
        CookieDataManager.CurrentUserId = obj["UserId"];
        CookieDataManager.General.GeneralData.DataBase = obj["DataBase"];

    }

};