<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="HWLogin.aspx.cs" Inherits="Audit.HWLogin" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
  
 <title>浩物机电审计系统</title>
    <script src="lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <link href="lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script> 
    <script src="lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <script src="Scripts/FunctionMethodManager.js" type="text/javascript"></script> 
    <script src="lib/Cookie/jquery.cookie.js" type="text/javascript"></script>
    <script src="Scripts/Cookie/Cookie.js" type="text/javascript"></script>
    <script type="text/javascript">
        var LoginManager = {
            LoginBtnClick: function () {
                var para = {};
                para["Code"] = $("#username").val();
                para["Password"] = $("#password").val();
                para = CreateParameter(BasicAction.ActionType.Post, BasicAction.Functions.UserManager, BasicAction.Methods.UserManagerMethods.Login, para);
                DataManager.sendData("handler/BasicHandler.ashx", para, resultManagers.success, resultManagers.fail, false);
            },
            CancelBtnClick: function () {
                $("#username").val('');
                $("#password").val('');
            }
        };

        var resultManagers = {

            success: function (data) {
                if (data.success) {
                    window.location.href = "Index.aspx";
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
    </script>
    <style type="text/css">
        body
        {
            margin: 0;
            padding: 0;
            font-size: 12px;
            background: url(images/login/bg.jpg) top repeat-x;
        }
        
        .input
        {
            width: 150px;
            height: 17px;
            border-top: 1px solid #404040;
            border-left: 1px solid #404040;
            border-right: 1px solid #D4D0C8;
            border-bottom: 1px solid #D4D0C8;
        }
    </style>
</head>
<body>
    <table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
        <tbody>
            <tr>
                <td height="200">
                    &nbsp;
                </td>
            </tr>
            <tr>
                <td>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tbody>
                            <tr>
                                <td width="423" height="280" valign="top">
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tbody>
                                            <tr>
                                                <td>
                                                    <%--<img src="images/index/ltop.jpg">--%>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <%--<img src="images/index/llogo.png">--%>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </td>
                                <td width="40" align="center" valign="bottom">
                                    <img src="images/login/line.jpg" width="23" height="232">
                                </td>
                                <td valign="top">
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tbody>
                                            <tr>
                                                <td height="90" align="center" valign="bottom">
                                                    <%--<img src="css/images/index/ltitle.jpg">--%>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <div>
                                                    </div>
                                                    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="5">
                                                        <tbody>
                                                            <tr>
                                                                <td colspan="2" align="center">
                                                                    <%--	<font color='red'>登录</font>--%>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td width="91" height="40" align="right">
                                                                    <strong>用户名：</strong>
                                                                </td>
                                                                <td width="211">
                                                                    <input type="text" id="Text1"  name="Code" class="input">
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td height="40" align="right">
                                                                    <strong>密码：</strong>
                                                                </td>
                                                                <td>
                                                                    <input name="Password"  type="password" id="password1" class="input">
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td height="40" colspan="2" align="center">
                                                                    <input type="image" src="images/login/login.jpg" onclick="LoginManager.LoginBtnClick()">
                                                                    &nbsp; &nbsp;
                                                                    <img name="reg" css="cursor: pointer" src="images/login/reset.jpg" onclick="document.forms[0].reset()">
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="2">
                                                                    <span id="spanM" style="color: Red"></span>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </td>
            </tr>
        </tbody>
    </table>
</body>
</html>


