<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddTask.aspx.cs" Inherits="Audit.ct.AuditTask.AddTask" %>

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
<body>
    <script src="../../Scripts/Ct_Controls.js" type="text/javascript"></script>
    <link href="../../Styles/Ct_Controls.css" rel="stylesheet" type="text/css" />
  <script type="text/javascript">
      //获取参数
      var template;
      var lxUrl = "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Get + "&MethodName=GetDictionaryListByClassType&FunctionName=" + BasicAction.Functions.DictionaryManager + "&ClassType=RWLX";
      function getParameters(actionType, methodName) {
          var params = {};
          params["Code"] = $("#Code").val();
          params["Name"] = $("#Name").val();
          params["TaskType"] = $("#TaskType").combobox('getValue');
          params["BeginDate"] = $("#BeginDate").datebox('getValue');
          params["EndDate"] = $("#EndDate").datebox('getValue');
          params["ActionType"] = actionType;
          params["FunctionName"] = AuditTaskAction.Functions.AuditTaskManager;
          params["MethodName"] = methodName;
          var id = $("#Id").val();
          if (id != null && id != undefined && id != "") {
              params["Id"] = id;
          }
          return params;

      }
 

    </script>
 <input id="Id" value="<%=ate.Id %>"  type="hidden"/>
 <input id="type" value="<%=ate.TaskType %>"  type="hidden"/>

   <table style="margin:auto; padding:20px;">
   <tr style="height:30px;"><td>编号</td><td><input id="Code" value="<%=ate.Code %>" type="text" class="easyui-validatebox textbox"  style="height:20px;width:147px;line-height: 25px;"/></td></tr>
   <tr><td>名称</td><td><input id="Name" type="text"value="<%=ate.Name %>"  class="easyui-validatebox textbox right"  style="height:20px;width:147px"/></td></tr>
    <tr><td>任务类型</td><td><input id="TaskType" class="easyui-combobox"   value="<%=ate.TaskType %>" name="TaskType" 
    data-options="valueField:'Code',textField:'Name',url:lxUrl"></td></tr>
     <tr><td>开始日期</td><td><input id="BeginDate" name="BeginDate" type="text" value="<%=ate.BeginDate %>" class="easyui-datebox" ></td></tr>
      <tr><td>结束日期</td><td><input id="EndDate" name="EndDate"  value="<%=ate.EndDate %>" type="text" class="easyui-datebox"></td></tr>
      </table>

</body>
</html>