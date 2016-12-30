<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="Audit.Register" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>软件注册</title>
    <script src="lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <script src="Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <link href="lib/bootstrap334/css/bootstrap-theme.min.css" rel="stylesheet" type="text/css" />
    <link href="lib/bootstrap334/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <script src="Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script type="text/javascript">
        var urls = { systemUrl: "handler/BasicHandler.ashx" };

        var clickManager = {
            getSequenceNumber: function () {
                var para = CreateParameter(BasicAction.ActionType.Get, BasicAction.Functions.System, BasicAction.Methods.SystemMethods.GetSequenceNumber);
                var url = CreateGeneralUrl(urls.systemUrl, para);
                DataManager.sendData(url, null, resultManager.successNumber, resultManager.fail);
            },
            Register: function () {
                var para = CreateParameter(BasicAction.ActionType.Post, BasicAction.Functions.System, BasicAction.Methods.SystemMethods.Register);
                para["Name"] = $("#name").val();
                para["Value"] = $("#value").val();
                if (para["Name"] == "") { $("#info").html("注册序列号不能为空"); return; }
                if (para["Value"] == "") { $("#info").html("注册秘钥不能为空"); return; }

                DataManager.sendData(urls.systemUrl, para, resultManager.RegisterSuccess, resultManager.fail);
            },
            goBack: function () {
                window.location.href = "Login.aspx";
            }
        };
        var resultManager = {
            successNumber: function (data) {
                if (data.success) {
                    $("#name").val(data.obj);
                } else {
                    $("#info").html(data.sMeg);
                }
            },
            fail: function (data) {
                $("#info").html(data.sMeg);
            },
            RegisterSuccess: function (data) {
                if (data.success) {
                    $("#info").html(data.obj);
                } else {
                    $("#info").html(data.sMeg);
                }
            }
        };
    </script>
</head>

<body >

   <p class="bg-primary" style=" height:150px;  font-size:24px;  padding-top:50px; padding-left:20px;">软件注册</p>
   <div id="Register" style=" width:450px; margin:auto;" >
  <table cellpadding="30" cellspacing="3">
  <tr style=" line-height:60px;"><td><label class="control-label">产品序列号</label></td><td><input class="form-control" disabled="disabled" type="text" style=" width:270px;" name="name" value="<%=config.Name %>" id="name" /></td><td><button type="button" class="btn btn-success" onclick="clickManager.getSequenceNumber()">获取</button></td></tr>

    <tr style=" line-height:60px;"><td><label class="control-label">产品秘钥</label></td><td><input class="form-control" value="<%=config.Value %>" type="text" style=" width:270px;" name="value" id="value" /></td><td></td></tr>
      <tr style=" line-height:60px;"><td></td><td  style=" text-align:right;"><button type="button" class="btn btn-danger" style=" width:150px; margin-right:5px" onclick="clickManager.Register()">注册</button></td><td><button type="button" class="btn btn-success" onclick="clickManager.goBack()">返回首页</button></td></tr>
  </table>
      
        <p class="text-danger" id="info"></p>
   </div>

</body>
</html>
