
<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LogManager.aspx.cs" Inherits="Audit.ct.basic.LogManager" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>日志查询</title>
    <script src="../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <link href="../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="../../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script src="../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <link href="../../Styles/Common.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">

        var urls = {
            LogGridUrl: "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Grid + "&MethodName=" + BasicAction.Methods.SystemMethods.LogDataGrid + "&FunctionName=" + BasicAction.Functions.System,
            ConfigGridUrl: "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Grid + "&MethodName=" + BasicAction.Methods.SystemMethods.DataGrid + "&FunctionName=" + BasicAction.Functions.System, //.DataSource,
            functionsUrl: "../../handler/BasicHandler.ashx"
        };
        var toolBar = [
        ];
    </script>
</head>
<body>
  <table class="easyui-datagrid"  id="logGrid"
            data-options="singleSelect:true,method:'post',fit:true,fitColumns:true,toolbar:toolBar,url:urls.LogGridUrl,sortName:'CreateTime',sortOrder:'DESC',pagination:true">
        <thead>
            <tr>
                <th data-options="field:'UserCode',width:40,align:'left'">用户账号</th>
                <th data-options="field:'UserName',width:100,align:'left'">用户名称</th>     
                <th data-options="field:'CreateTime',width:220,align:'left'">登录时间</th>   
                       
                <th data-options="field:'Id',width:120,align:'center',hidden:true">ID</th>
            </tr>
        </thead>
    </table>
</body>
</html>
