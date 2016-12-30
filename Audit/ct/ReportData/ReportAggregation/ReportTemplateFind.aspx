<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReportTemplateFind.aspx.cs" Inherits="Audit.ct.ReportData.ReportAggregation.ReportTemplateFind" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="../../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <script src="../../../lib/easyUI14/jquery.easyui.min.js" type="text/javascript"></script>
    <link href="../../../lib/easyUI14/themes/icon.css" rel="stylesheet" type="text/css" />
    <link href="../../../lib/easyUI14/themes/color.css" rel="stylesheet" type="text/css" />
    <link href="../../../lib/easyUI14/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <script src="../../../lib/easyUI14/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <title>模板选择</title>
   
</head>
<body>

  <script type="text/javascript">
      var templateUrl = "../../../handler/ReportDataHandler.ashx?ActionType=" + ReportDataAction.ActionType.Grid + "&MethodName=" + ReportDataAction.Methods.ReportAggregationMethods.GetAggregationTemplates + "&FunctionName=" + ReportDataAction.Functions.ReportAggregation;
      function doSearch() {
          $("#tdg").datagrid("reload", { Code: $("#tcode").val(), Name: $("#tname").val() });
      }

      var EventManager = {
          DbClick_Event: function (rowIndex, rowData) {
              SetTemplate(rowData);
          }
      };
    </script>
  <table class="easyui-datagrid" id="tdg" style="width:700px;height:250px"
            data-options="rownumbers:true,singleSelect:true,method:'get',toolbar:'#toolBar',fit:true,pagination:true,url:templateUrl,sortName:'Code',sortOrder:'ASC',onDblClickRow:EventManager.DbClick_Event">
        <thead>
            <tr>
                <th data-options="field:'Id',hidden:true">Item ID</th>
                <th data-options="field:'Code',width:100">模板编号</th>
                <th data-options="field:'Name',width:250,align:'left'">模板名称</th>
            </tr>
        </thead>
    </table>
    <div id="toolBar">
           <table>
           <tr>
           <td>编号</td> <td><input id = "tcode"class="easyui-validatebox textbox" style="width:120px;height:22px;" /></td>
            <td>名称</td> <td><input id = "tname"class="easyui-validatebox textbox" style="width:120px;height:22px;" /></td>
             <td> <a href="#" id="searcher" class="easyui-linkbutton" iconCls="icon-search" onclick="doSearch()">查询</a></td> 
           </tr>
           </table>
           
    </div>

   
</body>
</html>
