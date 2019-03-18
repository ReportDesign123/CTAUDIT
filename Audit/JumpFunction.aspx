<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="JumpFunction.aspx.cs" Inherits="Audit.JumpFunction" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
   
    <script src="lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <link href="lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />

    <script src="lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <script src="Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script src="Scripts/ct_dialog.js"></script>
    <script src="Scripts/layer/layer.js"></script>

     <script type="text/javascript">
         var para = {};
         loader = {
             open: function () {
                 if (layer) {
                     layer.msg('<table class="ui_dialog"><tbody><tr><td class="ui_icon"><img src="Scripts/layer/skin/default/loading-2.gif" class="ui_icon_bg"></td><td class="ui_main" style="width: auto; height: auto;"><div class="ui_content" style="padding: 10px;"><span class="loading">报表正在加载数据，请稍后</span></div></td></tr><tr><td colspan="2"><div class="ui_buttons" style="display: none;"></div></td></tr></tbody></table>', {
                         icon: -1,
                         time: 0,
                         shade: 0.4,
                         area: ['410px', '90px'],

                     });
                 }
             },
             close: function () {
                 if (layer) {
                     layer.close(layer.index);
                 }
             }
         };
         function openDialog(modelID, opts) {
             $('#' + modelID).dialog(opts);
         }
         function showDialog(modelID) {
             $('#' + modelID).dialog('open');
         }
         function closeDialog(modelID) {
             $('#' + modelID).dialog('close');
         }
         $(function () {
             para["Code"] = "9999";// GetQueryString("UserCode");
            // para["UserUrl"] = GetQueryString("UserUrl");

             para = CreateParameter(BasicAction.ActionType.Post, BasicAction.Functions.UserManager, BasicAction.Methods.UserManagerMethods.SingleLogin, para);
             DataManager.sendData("handler/BasicHandler.ashx", para, resultManagers.success, resultManagers.fail, false);
         });
         var resultManagers = {
             success: function (data) {
                 if (data.success) {
                    $('iframe').attr('src', '/ct/ReportData/FillReport.aspx');
                    // window.location.href = "/ct/ReportData/FillReport.aspx";
                     //if (para["AuditType"] && para["AuditType"] != "") {
                     //    para = CreateParameter(BasicAction.ActionType.Post, BasicAction.Functions.UserManager, BasicAction.Methods.UserManagerMethods.SingleData, para);
                     //    DataManager.sendData("handler/BasicHandler.ashx", para, resultDataManagers.success, resultDataManagers.fail, false);
                     //}
                     //else {
                     //    window.location.href = "/ct/ReportData/FillReport.aspx";
                     //}
                 } else {

                 }
             },
             fail: function (data) {
                 if (data) {
                     //                    $("#spanM").text(data.sMeg);
                 }
             }

         };
         function GetQueryString(name) {
             var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
             var r = window.location.search.substr(1).match(reg);
             if (r != null) return (r[2]); return null;
         }
        
   
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    <iframe src=""  width="100%" height="700px" name="listUrl">  </iframe>
    </div>
    </form>
</body>
</html>
