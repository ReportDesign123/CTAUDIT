<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Audit.Login" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
       <title>浩物机电</title>
    <script src="lib/jquery/jquery-1.5.2.min.js" type="text/javascript"></script>
    <script src="Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <script src="Scripts/FunctionMethodManager.js" type="text/javascript"></script> 
    <script src="lib/Cookie/jquery.cookie.js" type="text/javascript"></script>
    <script src="Scripts/Cookie/Cookie.js" type="text/javascript"></script>
     <script type="text/javascript">
         var LoginManager = {
             LoginBtnClick: function () {
                 var para = {};
                 para["Code"] = $("#username").val();
                 para["Password"] = $("#Password").val();
                 para = CreateParameter(BasicAction.ActionType.Post, BasicAction.Functions.UserManager, BasicAction.Methods.UserManagerMethods.Login, para);
                 DataManager.sendData("handler/BasicHandler.ashx", para, resultManagers.success, resultManagers.fail, false);
             },
             CancelBtnClick: function () {
                 $("#username").val('');
                 $("#password").val('');
             }
         };
         var HelpManager = {
             DownLoadPlug: function () {
             var url =  "handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Get + "&MethodName=" + BasicAction.Methods.SystemMethods.DownLoadPlug + "&FunctionName=" + BasicAction.Functions.System
                 window.location = url; 
             }
         }
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
         $(document).keypress(function (e) {
             var curKey = e.which;
             if (curKey == 13) {
                 LoginManager.LoginBtnClick();
             }
         });
         $(function () {
             resizeWindow();
         });
         
         function resizeWindow() {
             var height = $(window).height() - 480;
             var width = $(window).width() - 1110;
             height = height * 0.5 -30;
             $("#main").css("margin-top", height);
             $("#main").css("margin-left", width*0.5);
         }
    </script>
    
    <style type="text/css">
        body
        {
            font-family: "微软雅黑";
            font-size: 14px;
            width: 100%;
            height: 100%;
        }
        .style1
        {
            width: 60px;
        }
        
        #btnlogin
        {
            background: url(images/HWLogin/login1.png);
            font-size: 18px;
            font-weight: bold;
            border-top-style: none;
            border-right-style: none;
            border-bottom-style: none;
            border-left-style: none;
            width: 250px;
            color: White;
            height: 40px;
        }
        .inp
        {
            border-top: #d2d2d2 1px solid;
            width: 250px;
            height: 25px;
            font-family: "微软雅黑";
            border-right: #d2d2d2 1px solid;
            border-bottom: #d2d2d2 1px solid;
            padding-bottom: 0px;
            padding-top: 0px;
            padding-left: 5px;
            border-left: #d2d2d2 1px solid;
            line-height: 29px;
            padding-right: 5px;
            -moz-border-radius: 1px;
            -webkit-border-radius: 1px;
            border-radius: 5px;
            _line-height: 30px;
        }
        .userinfo
        {
            color: #777777;
        }
        #rightmain
        {
            border-left: 1px solid #f2f2f2;
        }
        #header
        {
            float: left;
            width: 100%; /* height: 112px;*/
            height: 100px;
            border-bottom: 4px solid #f9b428;
        }
        #main
        {
            float: left;
            width: 100%; /*  height: 312px;*/
            height: 450px;
        }
        #leftmain
        {
            float: left;
            height: 100%;
        }
        #rightmain
        {
            float: right;
            width: 400px;
            height: 100%;
        }
        #footer
        {
            background-color: #f2f2f2;
            height: 60px;
            float: left;
            width: 100%;
            text-align: center;
            font-size: 12px;
            bottom:0px;
            position:absolute;
        }
        .icon
        {
            background: url(images/HWLogin/icon.png);
            height: 27px;
            background-position: 0px -251px;
            float: left;
            width: 19px;
            margin-right: 6px;
        }
        #leftheader1
        {
            float: right;
            width: 380px;
            height: 50px;
            text-align: left;
            margin-right: 140px;
            margin-top: 30px;
            font-size: 16px;
            font-weight: bold;
            color: #66bbd8;
        }
    </style>
</head>
<body style=" overflow:hidden" >
    <div id="header" >
        <img src="images/HWLogin/title.png" style="margin-left: 40px; float:left;" />
        <div id="leftheader1">
            <span>
            <em class="icon"></em>
            身入审计、心入审计、求真务实、探索创新
            </span>
        </div>
    </div>
    <div id="main" style=" width:1150px; height:400px; margin-left:100px; text-align:center">
        <div id="leftmain" >
            <img src="images/HWLogin/leftamain.png" id="leftImg" width="713px" height="312px"/>
        </div>
        <div id="rightmain" >
            <table id="userinfo" style="width:360px; height: 200px; padding-left:10px; margin-top:50px">
                <tr style="height: 20px;">
                </tr>
                <tr>
                    <td class="style1">
                        用户名：
                    </td>
                    <td>
                        <input class="inp" type="text" name="usernmae" id="username" />
                    </td>
                </tr>
                <tr style="height:100px">
                    <td class="style1">
                        密&nbsp; &nbsp;码：
                    </td>
                    <td>
                        <input class="inp" type="password" name="paw" id="Password"  />
                    </td>
                </tr>
                <tr>
                </tr>
                <tr style="height:50px">
                    <td class="style1">
                    </td>
                    <td>
                        <input type="button" id="btnlogin" value="登录" onclick="LoginManager.LoginBtnClick()" />
                        <%--<a href="javascript:void(0)">忘记密码？</a>--%>
                    </td>
                </tr>
                <tr style="height:25px">
                    <td colspan="2">
                        <span id="spanM" style="color: Red"></span>
                    </td>
                </tr>
            </table>
        </div>
        </div>
    <div id="footer">
        <div style=" margin-top: 20px; height: 30px;">
            <a href="javascript:void(0)">联系我们</a> | <a href="javascript:void(0)" onclick= "HelpManager.DownLoadPlug()">插件下载</a> | <a href="javascript:void(0)" onclick= "window.open('ocxInstruction/ocxInstruction.html')">插件安装说明</a>| <a href="Register.aspx" >软件注册</a> 
        </div>
    </div>
</body>
</html>