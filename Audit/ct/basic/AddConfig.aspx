<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddConfig.aspx.cs" Inherits="Audit.ct.basic.AddConfig" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html id="Head1"xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <link href="../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="../../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script src="../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
   
</head>
<body id="Body1" runat="server">
  <script type="text/javascript">
      //获取参数
      function getParameters(actionType, methodName) {
          var params = {};
          params["Value"] = $("#Value").val();
          params["Name"] = $("#Name").val();
          params["Remark"] = $("#Remark").val();
          params["ActionType"] = actionType;
          params["FunctionName"] = BasicAction.Functions.System;
          params["MethodName"] = methodName;
          var id = $("#Id").val();
          if (id != null && id != undefined && id != "") {
              params["Id"] = id;
          }
          return params;
      }
    </script>
 <input id="Id" value="<%=config.Id %>"  type="hidden"/>
   <table style="margin:auto; padding:20px;">
   <tr style="height:30px;"><td>参数名：</td><td><input id="Name"  value="<%=config.Name %>" type="text" class="easyui-validatebox textbox"  style="height:20px;width:150px;line-height: 25px;"/></td></tr>
   <tr style="height:30px;"><td>参数值：</td><td><input id="Value" type="text"  value="<%=config.Value %>" class="easyui-validatebox textbox"  style="height:20px;width:150px"/></td></tr>
   <tr style="height:30px;"><td>参数说明：</td><td><input id="Remark" type="text"  value="<%=config.Remark %>" class="easyui-validatebox textbox"  style="height:20px;width:150px"/></td></tr>
   </table>

</body>
</html>
