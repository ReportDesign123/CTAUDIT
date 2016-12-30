<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReportStateAggregationCompanies.aspx.cs" Inherits="Audit.ct.ReportData.ReportStateAggregationCompanies" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
   <title>指定状态下的单位列表</title>
     <script src="../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <link href="../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="../../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script src="../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <script src="../../lib/json2.js" type="text/javascript"></script>
    <script type="text/javascript">
        var urls = {
            functiontUrl: "../../handler/ReportDataHandler.ashx"
        };
        var currentState = { param: { TaskId: "", PaperId: "", ReportId: "", Nd: "", Zq: "", State: ""} };
        $(function () {
            //解析url 获取参数 
            var location = window.location.toString();
            var paramStr = location.split("=")[1];
            paramStr = decodeURI(paramStr);
            currentState.param = JSON2.parse(paramStr);
            $("#ReportList").datagrid({
                fit: true,
                title: "状态列表",
                border: false,
                fitColumns: true,
                singleSelect: true,
                sortOrder: 'desc',
                sortName: 'Code',
                columns: [[
                    { field: 'id', hidden: true },
                    { field: 'bbCode', title: '报表编号', sortable: true, width: 150 },
                    { field: 'bbName', title: '报表名称', sortable: true, width: 200 }
                ]]
            });
            LoadData();
        });
        function LoadData() {
            var paramter = CreateParameter(ReportDataAction.ActionType.Grid, ReportDataAction.Functions.ReportStateAggregation, ReportDataAction.Methods.ReportStateAggregationMethods.GetReportStateAggregationReports, currentState.param);
            DataManager.sendData(urls.functiontUrl, paramter, resultManager.successLoad, resultManager.fail);
        }
        var resultManager = {
            successLoad: function (data) {
                if (data.success) {
                    $("#ReportList").datagrid("loadData", data.obj);
                } else {
                    MessageManager.ErrorMessage(data.sMeg);
                }
            },
            fail: function (data) {
                MessageManager.ErrorMessage(data.toString);
            }
        };
      </script>
</head>
<body>
   <table id="ReportList"></table>
</body>
</html>
