<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PasswordChange.aspx.cs" Inherits="Audit.ct.basic.PasswordChange" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
      <script src="../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <link href="../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="../../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script src="../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <script src="../../Scripts/Login.js" type="text/javascript"></script>
    <script type="text/javascript">
        var urls = {
            userUrl:"../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Get + "&MethodName=" + BasicAction.Methods.UserManagerMethods.GetCurrentUserInfo + "&FunctionName=" + BasicAction.Functions.UserManager,
            SaveUrl: "../../handler/BasicHandler.ashx"
        };

        $(function () {
            DataManager.sendData(urls.userUrl, null, resultManager.successLoad, resultManager.fail);
        });
        var resultManager = {
            successLoad: function (data) {
                if (data.success) {
                    $("#Id").val(data.obj.Id);
                    $("#userCode").val(data.obj.Code);
                    $("#userName").val(data.obj.Name);
                    $("#oldPassWord").val(data.obj.Password);
                } else {
                    MessageManager.ErrorMessage(data.sMeg);
                }
            },
            successSave: function (data) {
                if (data.success) {
                    MessageManager.InfoMessage(data.sMeg);
                } else {
                    MessageManager.ErrorMessage(data.sMeg);
                }
            },
            fail: function (data) {
                MessageManager.ErrorMessage(data.toString);
            }
        };
        //获取参数
        function getParameters(actionType, methodName) {
            var params = {};
            params["Id"] = $("#Id").val();
            params["Name"] = $("#userName").val();
            params["Password"] = $("#surePassWord").val();
            params["ActionType"] = actionType;
            params["FunctionName"] = BasicAction.Functions.UserManager;
            params["MethodName"] = methodName;
            return params;
        }
        function sureInput() {
            var password = $("#newPassWord").val();
            if (!password){
                $("#mSpan").css("color", "red");
                $("#mSpan").text(" *密码不能为空");
                return;
            }
            if (password.length > 16 || password.length < 6) {
                $("#mSpan").css("color", "red");
                $("#mSpan").text(" *密码长度应为6—16位");
            } else {
                $("#mSpan").css("color", "Green");
                $("#mSpan").text(" *验证通过");
            }
        }
        function surePassWord() {
            var password = $("#newPassWord").val();
            var surePassWord = $("#surePassWord").val();
            if (!surePassWord) {
                $("#suerSpan").css("color", "red");
                $("#suerSpan").text(" *重复密码不能为空");
                return;
            }
            if (password != surePassWord) {
                $("#suerSpan").css("color", "red");
                $("#suerSpan").text(" *密码输入不一致");
                return;
            }
            if (password.length > 16 || password.length < 6) {
                $("#mSpan").css("color", "red");
                $("#mSpan").text(" *密码长度应为6—16位");
                return;
            }
            $("#suerSpan").css("color", "Green");
            $("#suerSpan").text(" *验证通过");
            return true;
        };
        function saveEdit() {
            if (surePassWord()) {
                var para = getParameters(BasicAction.ActionType.Post, BasicAction.Methods.UserManagerMethods.SaveNewPassWord);
                para = CreateParameter(BasicAction.ActionType.Post, BasicAction.Functions.UserManager, BasicAction.Methods.UserManagerMethods.SaveNewPassWord, para);
                DataManager.sendData(urls.SaveUrl, para, resultManager.successSave, resultManager.fail);
            }
        }
    </script>
</head>
<body style=" font-size:14px; padding:10px">
 <input id="Id" value=""  type="hidden"/>
   <table cellspacing="10px">
   <tr><td>用账户：</td><td><input id="userCode" type="text" value=" " disabled="disabled" class="easyui-validatebox textbox" readonly="readonly" style="height:20px;width:170px"/></td></tr>
   <tr><td>用户密码：</td><td><input id="oldPassWord" type="text" value=" "disabled="disabled" class="easyui-validatebox textbox" readonly="readonly" style="height:20px;width:170px"/></td></tr>
   <tr><td>用户名：</td><td><input id="userName" type="text" value=" " class="easyui-validatebox textbox"  style="height:20px;width:170px"/></td></tr>
   <tr><td>新密码：</td><td><input id="newPassWord"  onblur= "sureInput()" class="easyui-validatebox textbox"  type="password"  value="" style="height:20px;width:170px"/><span id="mSpan" style=" color:red"></span></td></tr>
   <tr><td>重复密码：</td><td><input id="surePassWord" onblur= "surePassWord()" type="password"  value="" class="easyui-validatebox textbox"  style="height:20px;width:170px"/><span id="suerSpan" style=" color:red"></span></td></tr>
   <tr><td></td><td><a  href="#" class="easyui-linkbutton" style="width:170px; text-align:center; outline:none; " iconcls="icon-save" onclick="saveEdit()" >保 存 更 改</a></td></tr>
   </table>
</body>
</html>
