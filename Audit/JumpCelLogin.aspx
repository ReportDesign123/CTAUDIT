<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="JumpCelLogin.aspx.cs" Inherits="Audit.JumpCelLogin" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>系统登录</title>
    <script src="lib/jquery/jquery-1.5.2.min.js" type="text/javascript"></script>
    <script src="Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <script src="Scripts/FunctionMethodManager.js" type="text/javascript"></script> 
    <script src="lib/Cookie/jquery.cookie.js" type="text/javascript"></script>
    <script src="Scripts/Cookie/Cookie.js" type="text/javascript"></script>
     <script type="text/javascript">
         var _Userid;
         var _Password;
         var _href;
         var LoginManager = {
             LoginBtnClick: function () {
                 var para = {};
                 para["Code"] = _Userid;
                 para["Password"] = _Password;
                 para = CreateParameter(BasicAction.ActionType.Post, BasicAction.Functions.UserManager, BasicAction.Methods.UserManagerMethods.Login, para);
                 DataManager.sendData("handler/BasicHandler.ashx", para, resultManagers.success, resultManagers.fail, false);
             },
             CancelBtnClick: function () {
               
             }
         };
        
         var resultManagers = {

             success: function (data) {
                 if (data.success) {
                     window.location.href = _href;
                 } else {
                     $("#spanM").text(data.sMeg);
                 }
             },
             fail: function (data) {
                 if (data) {
                     $("#spanM").text(data.sMeg);
                 }
             }
         };
         function LogIn() {
             LoginManager.LoginBtnClick();
         }
       </script>
</head>
<body  onload ="LogIn()" style="MARGIN: 0px"    >
    <form id="form1" runat="server">
    <div>
     <span id="spanM" style="color: Red"></span>
    </div>
    </form>
</body>
</html>
