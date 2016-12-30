<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReportLockManager.aspx.cs" Inherits="Audit.ct.ReportLock.ReportLockManager" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>报表批量处理</title>
    <script src="../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <link href="../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="../../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <link href="../../Styles/Common.css" rel="stylesheet" type="text/css" />
    <script src="../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <script type="text/javascript">
        var urls = {
            ReportFunctionsUrl:"../../handler/ReportDataHandler.ashx",
            ReportsUrl: "../../handler/ReportDataHandler.ashx?ActionType=" + ReportDataAction.ActionType.Post + "&MethodName=" + ReportDataAction.Methods.ReportReadWriteLockMethods.GetReportLockEntiesDataGrid + "&FunctionName=" + ReportDataAction.Functions.ReportReadWriteLockAction
        };
        $(function () {
            $("#reportGrid").datagrid({
                url:urls.ReportsUrl,
                singleSelect: false,
                fit: true,
                toolbar: '#toobar',
                sortName: 'ReportCode',
                sortOrder: 'ASC',
                fitColumns:true,
                pagination: true,
                columns: [[
                { field: 'Id', width: 80, align: 'left', checkbox: true, title: 'Id' },
                { field: 'ReportCode', width: 100, align: 'left', sortable: true, title: "报表编号" },
                { field: 'ReportName', width: 190, align: 'left', sortable: true, title: "报表名称" },
                { field: 'CompanyName', width: 190, align: 'left', sortable: true, title: "单位名称" },
                { field: 'UserName', width: 140, align: 'left', sortable: true, title: "锁定用户" },
                { field: 'CreateTime', width: 140, align: 'left', sortable: true, title: "锁定时间" },
                { field: 'Year', width: 100, align: 'left', sortable: true, title: "年度" },
                { field: 'Cycle', width: 120, align: 'left', sortable: true, title: "周期" }
                ]]
            });
                $("#Code").keypress(function (e) {
                    var curKey = e.which;
                    if (curKey == 13) {
                        EventManager.SearchReport();
                    }
                });
                $("#Name").keypress(function (e) {
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
            SearchReport: function () {
                ReportCode = $("#Code").val();
                ReportName = $("#Name").val();
                CompanyName = $("#Company").val();
                var data = { ReportCode: ReportCode, ReportName: ReportName, CompanyName: CompanyName };
                $('#reportGrid').datagrid("reload", data);
            },
            FreeSearch: function () {
                $("#Code").val("");
                $("#Name").val("");
                $("#Company").val("");
                $("#reportGrid").datagrid("reload", {});
            },
            RemoveLock: function (type) {
                var obj = ControlManager.GetParameter();
                if (!obj) return;
                obj = CreateParameter(ReportDataAction.ActionType.Post, ReportDataAction.Functions.ReportReadWriteLockAction, ReportDataAction.Methods.ReportReadWriteLockMethods.RemoveLocks, obj);
                DataManager.sendData(urls.ReportFunctionsUrl, obj, resultManager.success, resultManager.fail);
            }
        };
        var ControlManager = {
            GetParameter: function () {
                var Reports = $("#reportGrid").datagrid("getSelections");
                var para = {Ids:""};
                if (Reports.length == 0) { alert("请选择要操作的报表！"); return; }
                $.each(Reports, function (index, report) {
                    if (para.Ids != "") {
                        para.Ids = para.Ids + "," + report.Id;
                    } else {
                        para.Ids = report.Id;
                    }
                });
                return para;
            }
        };
        var resultManager = {
            success: function (data) {
                if (data.success) {
                    MessageManager.InfoMessage(data.sMeg);
                    $("#reportGrid").datagrid("reload");
                } else {
                    alert(data.sMeg);
                }
            },
            fail: function (data) {
                MessageManager.ErrorMessage(data.toString);
            }
        }
    </script>
</head>
<body class ="easyui-layout">
    <div data-options="region:'north'" style="height:32px; padding:2px; overflow:hidden;background-color:#E0ECFF ;">
            <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-undo'" onclick="EventManager.RemoveLock()" style="width:90px;"plain="true">解除锁定</a>
    </div>
    <div data-options="region:'center'" style="border:0px;">
       <div id="toobar" style=" min-width:850px">
            <table style=" width:100%"><tr>   
                <td style=" width:60px">报表编号</td><td style=" width:170px"> <input id = "Code"class="easyui-validatebox textbox" /></td>
                <td style=" width:60px">报表名称</td><td style=" width:170px"> <input id = "Name"class="easyui-validatebox textbox"/></td>
                <td style=" width:60px">单位名称</td><td> <input id = "Company"class="easyui-validatebox textbox"/></td>
                <td><div id="zqDiv"></div></td>
                <td style=" float:right"><a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-undo'" onclick="EventManager.FreeSearch()" style=" margin-left:10px">重置</a></td>
                <td style=" float:right"><a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="EventManager.SearchReport()" >查询</a></td>
                </tr>
            </table>
      </div>
      <table id="reportGrid" style=" overflow:auto"></table>
    </div>
</body>
</html>