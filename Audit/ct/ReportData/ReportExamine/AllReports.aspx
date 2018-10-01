<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AllReports.aspx.cs" Inherits="Audit.ct.ReportData.ReportExamine.AllReports" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>报表状态查看</title>
     <script src="../../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <script src="../../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <link href="../../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../../../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script src="../../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <script src="../../../Scripts/Ct_WorkFlow.js" type="text/javascript"></script>
    <link href="../../../Styles/Common.css" rel="stylesheet" type="text/css" />
    <script src="../../../lib/json2.js" type="text/javascript"></script>
       <script src="../../../Scripts/ct_dialog.js" type="text/javascript"></script>
    <script type="text/javascript">
        var urls = {
            ReportDataUrl: "ct/ReportData/ReportAggregation/ReportDataCell.aspx",
            ReportHistoryUrl: "ct/ReportData/ReportExamine/ReportStateHistory.aspx",
            ReportUrls: "../../../handler/ReportDataHandler.ashx"
        };
        var currentState = { ReportState: { auditPaperVisible: "1", auditZqVisible: "1", WeekReport: { ID: "", Name: "", Ksrq: "", Jsrq: ""} } };
        var controls = {};
        var PaperState = false;
        var EventManager = {
            ReportData: function () {
                if (!PaperState) return;
                var row = controls.allReports.datagrid("getSelected");
                if (!row || row == undefined) { alert("选择要查看的报表"); return; }
                var para = { ReportId: row.ReportId, CompanyId: row.CompanyId, Cycle: currentState.ReportState.Zq, Year: currentState.ReportState.Nd, PaperId: currentState.ReportState.AuditPaper.value, TaskId: currentState.ReportState.AuditTask.value };
                para = JSON2.stringify(para);
                para = encodeURI(para);
                parent.NavigatorNode({ id: "060", text: row.ReportName + "(" + row.ReportCode + ")", attributes: { url: urls.ReportDataUrl + "?para=" + para} });

            },
            ExamHistory: function () {
                if (!PaperState) return;
                var para = loadManager.GetLoadParam();
                var row = controls.allReports.datagrid("getSelected");
                if (!row || row == undefined) { alert("选择要查看的报表"); return; }
                para.ReportId = row.ReportId;
                para.CompanyId = row.CompanyId;
                var para = "?ReportId=" + row.ReportId + "&CompanyId=" + row.CompanyId + "&Zq=" + currentState.ReportState.Zq + "&Nd=" + currentState.ReportState.Nd + "&PaperId=" + currentState.ReportState.AuditPaper.value + "&TaskId=" + currentState.ReportState.AuditTask.value + "&ReportType=" + currentState.ReportState.auditZqType;
                parent.NavigatorNode({ id: "061", text:  row.ReportName + "(" + row.ReportCode + ")_状态信息", attributes: { url: urls.ReportHistoryUrl + para} });
            },
            SearchReport: function () {
                if (!PaperState) return;
                var ReportCode = $("#ReportCode").val();
                var ReportName = $("#ReportName").val();
                var CompanyName = $("#Company").val();
                var data = { ReportName: ReportName, CompanyName: CompanyName, ReportCode: ReportCode };
                $('#allReports').datagrid("reload", data);
            },
            FreeSearch: function () {
                if (!PaperState) return;
                $("#ReportCode").val("");
                $("#ReportName").val("");
                $("#Company").val("");
                $("#allReports").datagrid("reload", {});
            }
        };
        $(function () {
            currentState.ReportState["auditPaperVisible"] = "1";
            currentState.ReportState["auditZqVisible"] = "1";
            dialog.Open("ct/ReportData/ChooseAuditTask.aspx", "切换任务", currentState.ReportState, function (result) {
                if (result && result != undefined) {
                    if (result.auditZqType == "05") {
                        if (result.WeekReport.ID == "") {
                            alert("请定义周报周期");
                            var curTabTitle = "资料状态查看";

                        }
                        else {
                            currentState.ReportState = result;
                            var para = loadManager.GetLoadParam();
                            var url = CreateUrl(urls.ReportUrls, ReportDataAction.ActionType.Grid, ReportDataAction.Functions.FillReport, ReportDataAction.Methods.FillReportMethods.GetAllReportsStateDataGrid, para);
                            loadManager.LoadExamGrid(url, "allReports");
                            PaperState = true;
                        }
                    }
                    else {
                        currentState.ReportState = result;
                        var para = loadManager.GetLoadParam();
                        var url = CreateUrl(urls.ReportUrls, ReportDataAction.ActionType.Grid, ReportDataAction.Functions.FillReport, ReportDataAction.Methods.FillReportMethods.GetAllReportsStateDataGrid, para);
                        loadManager.LoadExamGrid(url, "allReports");
                        PaperState = true;
                    }

                }
            }, { width: 440, height: 500 });
             
         
            $("#ReportCode").keypress(function (e) {
                var curKey = e.which;
                if (curKey == 13) {
                    EventManager.SearchReport();
                }
            });
            $("#ReportName").keypress(function (e) {
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
        var loadManager = {
            LoadExamGrid: function (url, id) {
                var height = document.body.clientHeight - 40;
                controls[id] = $("#" + id).datagrid({
                    fitColumns: true,
                    fit: true,
                    url: url,
                    columns: [[
                      { field: 'CompanyId', title: 'CompanyId', width: 100, hidden: true },
                       { field: 'ReportCode', title: '报表编号', width: 100, sortable: true },
                       { field: 'ReportName', title: '报表名称', width: 180, sortable: true },
                       { field: 'CompanyName', title: '单位名称', width: 200, sortable: true },
                       { field: "State", title: "报表当前状态", width: 120, sortable: true } 
                   ]],
                   onDblClickRow: EventManager.ReportData,
                   toolbar: "#toolbar",
                    idField: "",
                    pagination: true,
                    rownumbers: false,
                    singleSelect: true,
                    sortName: "CreateTime",
                    sortOrder: "DESC"
                });
            },
            GetLoadParam: function () {
                var param = { TaskId: "", PaperId: "", Nd: "", Zq: "", ReportType: "" };
                param.TaskId = currentState.ReportState.AuditTask.value;
                param.PaperId = currentState.ReportState.AuditPaper.value;
                param.Nd = currentState.ReportState.Nd;
                param.Zq = currentState.ReportState.Zq;
                param.ReportType = currentState.ReportState.auditZqType;
                return param;
            }
        }
        function ChangeTask() {
            currentState.ReportState["auditPaperVisible"] = "1";
            currentState.ReportState["auditZqVisible"] = "1";
            dialog.Open("ct/ReportData/ChooseAuditTask.aspx", "切换任务", currentState.ReportState, function (result) {
                if (result && result != undefined) {

                    if (result.auditZqType == "05") {
                        if (result.WeekReport.ID == "") {
                            alert("请定义周报周期");
                            var curTabTitle = "资料状态查看";

                        }
                        else {
                            currentState.ReportState = result;
                            var para = loadManager.GetLoadParam();
                            var url = CreateUrl(urls.ReportUrls, ReportDataAction.ActionType.Grid, ReportDataAction.Functions.FillReport, ReportDataAction.Methods.FillReportMethods.GetAllReportsStateDataGrid, para);
                            loadManager.LoadExamGrid(url, "allReports");
                            PaperState = true;
                        }
                    }
                    else {
                        currentState.ReportState = result;
                        var para = loadManager.GetLoadParam();
                        var url = CreateUrl(urls.ReportUrls, ReportDataAction.ActionType.Grid, ReportDataAction.Functions.FillReport, ReportDataAction.Methods.FillReportMethods.GetAllReportsStateDataGrid, para);
                        loadManager.LoadExamGrid(url, "allReports");
                        PaperState = true;
                    }
                }
            }, { width: 440, height: 500 });
          
        }

    </script>
    <style type="text/css">
       
    .MyTd_box
    { 
        width:170px;
    }
    .MyTd_text
    { 
        width:60px;
    }
    </style>
</head>
<body class ="easyui-layout" style=" overflow:hidden">
<div data-options="region:'north'" style="height:32px; padding:2px; overflow:hidden;background-color:#E0ECFF ;">
            <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="EventManager.ReportData()" style="width:110px; float:left"plain="true">报表数据查看</a>
            <div class="datagrid-btn-separator"></div>
            <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="EventManager.ExamHistory()" style="width:110px;"plain="true">报表状态信息</a>
    </div>
    <div data-options="region:'center'" style="border:0px;">
       <div id="toolbar" class ="datagrid-toolbar" style=" min-width:850px">
            <table style=" font-size:12px; width:100%;"><tr>   
                <td class="MyTd_text">报表编号</td> <td class="MyTd_box"> <input id = "ReportCode"class="easyui-validatebox textbox" /></td>
                <td class="MyTd_text">报表名称</td> <td class="MyTd_box"> <input id = "ReportName"class="easyui-validatebox textbox" /></td>
                <td class="MyTd_text">单位名称</td> <td> <input id = "Company"class="easyui-validatebox textbox" /></td>
                <td style=" float:right"><a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-undo'" onclick="EventManager.FreeSearch()" style="margin-left:10px">重置</a></td>
                <td style=" float:right"><a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="EventManager.SearchReport()" style="">查询</a></td>
                </tr>
            </table>
      </div>
       <table id="allReports"></table>
    </div>
    <div data-options="region:'south'"style ="height:22px; overflow:hidden; text-align:center; font-size:13px; padding-top:2px">
     <a href="#" onclick="ChangeTask();return false;">审计任务切换</a>
     </div>
</body>
</html>
