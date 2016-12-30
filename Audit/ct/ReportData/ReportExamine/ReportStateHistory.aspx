<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReportStateHistory.aspx.cs" Inherits="Audit.ct.ReportData.ReportExamine.ReportStateHistory" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>报表审核历史</title>
    <script src="../../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <script src="../../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <link href="../../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../../../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script src="../../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <script type="text/javascript">
        var urls={
            ReportUrls: "../../../handler/ReportDataHandler.ashx"
        };
        $(function () {
            var url = CreateUrl(urls.ReportUrls, ReportDataAction.ActionType.Grid, ReportDataAction.Functions.FillReport, ReportDataAction.Methods.FillReportMethods.GetExamAllHistoryGrid, rsde);
            EventManager.LoadExamGrid(url);
            $("#Report").keypress(function (e) {
                var curKey = e.which;
                if (curKey == 13) {
                    EventManager.SearchReport();
                }
            });
            $("#Company").keypress(function (e) {
                var curKey = e.which;
                if (curKey == 13) {
                    EventManager.SearchReport();
                }
            });
        });
        var EventManager = {
            LoadExamGrid: function (url) {
                $("#dataGrid").datagrid({
                    url: url,
                    columns: [[
                    { field: 'ReportId', hidden: true, width: 30 },
                    { field: 'CompanyId', title: 'CompanyId', width: 100, hidden: true },
                    { field: 'CreaterName', title: '操作人', width: 120 },
                    { field: 'OperationType', title: '操作类型', width: 80 },
                    { field: 'Discription', title: '描述', width: 250 },
                    { field: 'CreateTime', title: '操作时间', align: 'center', width: 150, sortable: true }
                ]],
                    toolbar: "#toobar",
                    fit: true,
                    idField: "",
                    fitColumns: true,
                    pagination: true,
                    rownumbers: true,
                    sortName: "CreateTime",
                    sortOrder: "DESC"
                });
            },
            SearchReport: function () {
                ReportName = $("#Report").val();
                CompanyName = $("#Company").val();
                var data = { ReportName: ReportName, CompanyName: CompanyName };
                $('#dataGrid').datagrid("reload", data);
            },
            FreeSearch: function () {
                $("#Report").val("");
                $("#Company").val("");
                $("#dataGrid").datagrid("reload", {});
            }
        };
        
    </script>
</head>
<body>
    <div id="toobar"class="datagrid-toolbar">
        <table style=" font-size:13px"><tr>   
            <td>单位名称</td> <td> <input id = "Company"class="easyui-validatebox textbox" style="width:100px;"/></td>
            <td>报表名称</td> <td> <input id = "Report"class="easyui-validatebox textbox" style="width:100px;"/></td>
            <td> <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="EventManager.SearchReport()" style="width:60px">查询</a></td>
            <td> <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-undo'" onclick="EventManager.FreeSearch()" style="width:60px">重置</a></td>
            </tr>
        </table>
    </div>
    <table id="dataGrid"></table>
</body>
</html>