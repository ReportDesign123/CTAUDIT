<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddDic.aspx.cs" Inherits="Audit.ct.basic.AddDic" %>

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
<body id="Body1" runat="server">
  <script type="text/javascript">
      //获取参数
      function getParameters(actionType, methodName) {
          var params = {};
          params["Code"] = $("#dCode").val();
          params["Name"] = $("#dName").val();
          params["ClassifyId"] = $("#ClassifyId").combobox("getValue");
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
      var dicUrl = "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Get + "&MethodName=" + BasicAction.Methods.DicManagerMethods.GetDicClassifyCombo + "&FunctionName=" + BasicAction.Functions.DictionaryManager;
    </script>
 <input id="Id" value="<%=de.Id %>"  type="hidden"/>
   <table style="margin:auto; padding:20px;">
   <tr style="height:30px;"><td>字典编号</td><td><input id="dCode"  value="<%=de.Code %>" type="text" class="easyui-validatebox textbox"  style="height:20px;width:170px"/></td></tr>
   <tr><td>字典名称</td><td><input id="dName" type="text"  value="<%=de.Name %>" class="easyui-validatebox textbox"  style="height:20px;width:170px"/></td></tr>
   <tr><td>字典类别</td><td><input id="ClassifyId" type="text"  value="<%=de.ClassifyId %>" data-options="valueField:'Id',textField:'Name',url:dicUrl" class="easyui-combobox" style="height:20px;width:170px"/></td></tr>
    <tr><td>字典备注</td><td><input id="Remarks" type="text"  value="<%=de.Remarks %>" class="easyui-validatebox textbox"  style="height:20px;width:170px"/></td></tr>
   </table>

</body>
</html>
