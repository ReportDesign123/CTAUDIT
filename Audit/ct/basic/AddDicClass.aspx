<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddDicClass.aspx.cs" Inherits="Audit.ct.basic.AddDicClass" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
        <script src="../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <link href="../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="../../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
   
</head>
<body runat="server">
  <script type="text/javascript">
      //获取参数
      function getParameters(actionType, methodName) {
          var params = {};
          params["Code"] = $("#Code").val();
          params["Name"] = $("#Name").val();
          params["Remarks"] = $("#Remarks").val();
          params["ActionType"] = actionType;
          params["FunctionName"] = BasicAction.Functions.DictionaryManager;
          params["MethodName"] = methodName;
          var id = $("#Id").val();
          if (id != null && id != undefined && id != "") {
              params["Id"] = id;
          }
          return params;

      }

    </script>
 <input id="Id" value="<%=dce.Id %>"  type="hidden"/>
   <table style="margin:auto; padding:20px;">

   <tr style="height:30px;"><td>类别编号</td><td><input id="Code"  value="<%=dce.Code %>" type="text" class="easyui-validatebox textbox"  style="height:20px;width:170px;line-height: 25px;"/></td></tr>
   <tr><td>类别名称</td><td><input id="Name" type="text"  value="<%=dce.Name %>" class="easyui-validatebox textbox right"  style="height:20px;width:170px"/></td></tr>
    <tr><td>类别备注</td><td><input id="Remarks" type="text"  value="<%=dce.Remarks %>" class="easyui-validatebox textbox right"  style="height:20px;width:170px"/></td></tr>
      </table>

</body>
</html>
