﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="HigherExamine.aspx.cs" Inherits="Audit.ct.ReportData.ReportExamine.HigherExamine" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
<script src="../../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <script src="../../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <link href="../../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../../../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script src="../../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <script src="../../../Scripts/Ct_WorkFlow.js" type="text/javascript"></script>
    <script src="../../../Scripts/Ct_Tool.js" type="text/javascript"></script>
    <link href="../../../Styles/Common.css" rel="stylesheet" type="text/css" />
    <script src="../../../lib/json2.js" type="text/javascript"></script>
       <script src="../../../Scripts/ct_dialog.js" type="text/javascript"></script>
    <script type="text/javascript">
        var controls = { selectedRow: { ReportId: "", CompanyId: "" }, ReportBox: {} };
        var currentState = { ReportState: { auditPaperVisible: "1", auditZqVisible: "1", WeekReport: { ID: "", Name: "", Ksrq: "", Jsrq: ""} }, AuditData: {} };
        var urls = {
            ReportDataUrl: "ct/ReportData/ReportAggregation/ReportDataCell.aspx",
            ReportAduitUrl: "../../../handler/ReportAuditHandler.ashx",
            ReportUrls: "../../../handler/ReportDataHandler.ashx"
        };
        function clickFunc(obj) {
            menuManager.OpenDialog(obj.id);
        }
        function ExamedClickFunc(obj) {
            menuManager.CancelExamReportState(obj.id);
        }
        $(function () {
            var height = document.body.clientHeight - 40;
            $("#center").tabs({
                fit: true,
                height: height,
                onSelect: EventManager.onSelect_Event
            });
            ChangeTask();
            Ct_Tool.KeyPress("ExamCompany", EventManager.SearchReport);
            Ct_Tool.KeyPress("ExamReportCode", EventManager.SearchReport);
            Ct_Tool.KeyPress("ExamReportName", EventManager.SearchReport);
            Ct_Tool.KeyPress("MyReportCode", EventManager.SearchReport);
            Ct_Tool.KeyPress("MyReportName", EventManager.SearchReport);
            Ct_Tool.KeyPress("MyCompany", EventManager.SearchReport);
            Ct_Tool.KeyPress("ExamedCompany", EventManager.SearchReport);
            Ct_Tool.KeyPress("ExamedReportCode", EventManager.SearchReport);
            Ct_Tool.KeyPress("ExamedReportName", EventManager.SearchReport);
        });
        var loadManager = {
            LoadExamGrid: function (url, id) {
                controls[id] = $("#" + id).datagrid({
                    url: url,
                    columns: [[
                     { field: 'ReportId', checkbox: true, width: 30 },
                      { field: 'CompanyId', title: 'CompanyId', width: 100, hidden: true },
                       { field: 'Nd', title: '报表年度', width: 100, sortable: true },
                       { field: 'Zq', title: '报表周期', width: 190, sortable: true },
                       { field: 'ReportCode', title: '报表编号', width: 100, sortable: true },
                       { field: 'ReportName', title: '报表名称', width: 180, sortable: true },
                       { field: 'CompanyName', title: '单位名称', width: 180, sortable: true },
                       { field: 'Id', title: '审批', align: 'center', width: 80, formatter: function (value, row, index) {
                           return "<a href='#' id=" + value + " onclick='clickFunc(this)'>审批</a>";
                       }
                       },
                       { field: 'PaperId', title: '历史数据查看', align: 'center', width: 100, formatter: function (value, row, index) {
                           return "<a href='#' id=" + row.ReportId + ";" + row.CompanyId + " onclick='EventManager.ReportExamHistiry(this.id)'>审批历史查看</a>";
                       }
                       }
                   ]],
                    onDblClickRow: EventManager.ViewReportData,
                    fit: true,
                    idField: "",
                    toolbar: "#ExamingBar",
                    pagination: true,
                    rownumbers: true,
                    checkOnSelect: true,
                    sortName: "CreateTime",
                    sortOrder: "DESC"
                });
            },
            LoadCancelExamGrid: function (url, id) {
                var height = document.body.clientHeight - 100;
                controls[id] = $("#" + id).datagrid({
                    height: height,
                    url: url,
                    columns: [[
                     { field: 'ReportId', checkbox: true, width: 30 },
                      { field: 'CompanyId', title: 'CompanyId', width: 100, hidden: true },
                       { field: 'Nd', title: '报表年度', width: 100, sortable: true },
                       { field: 'Zq', title: '报表周期', width: 190, sortable: true },
                       { field: 'ReportCode', title: '报表编号', width: 100, sortable: true },
                       { field: 'ReportName', title: '报表名称', width: 190, sortable: true },
                       { field: 'CompanyName', title: '单位名称', width: 180, sortable: true },
                       { field: "State", title: "报表当前状态", width: 120, sortable: true },
                       { field: 'CreateTime', title: '审批时间', aligin: 'left', width: 100, sortable: true },
                       { field: 'Id', title: '取消审批', align: 'center', width: 100, formatter: function (value, row, index) {
                           return "<a href='#' id=" + value + " onclick='ExamedClickFunc(this)'>取消审批</a>";
                       }
                       },
                       { field: 'PaperId', title: '历史数据查看', align: 'center', width: 100, formatter: function (value, row, index) {
                           return "<a href='#' id=" + row.ReportId + ";" + row.CompanyId + " onclick='EventManager.ReportExamHistiry(this.id)'>审批历史查看</a>";
                       }
                       }
                   ]],
                    onDblClickRow: EventManager.ViewReportData,
                    fit: true,
                    idField: "",
                    toolbar: "#ExamedBar",
                    pagination: true,
                    rownumbers: true,
                    checkOnSelect: true,
                    sortName: "CreateTime",
                    sortOrder: "DESC"
                });
            },
            LoadReportHistoryGrid: function (url, id) {
                controls[id] = $("#" + id).datagrid({
                    url: url,
                    columns: [[
                     { field: 'ReportId', hidden: true, width: 30 },
                      { field: 'CompanyId', title: 'CompanyId', width: 100, hidden: true },
                       { field: 'CreaterName', title: '审批人', width: 120 },
                       { field: 'OperationType', title: '操作', width: 80 },
                       { field: 'Discription', title: '审批意见', width: 200 },
                       { field: 'CreateTime', title: '审批时间', width: 100, sortable: true }
                   ]],
                    fit: true,
                    idField: "",
                    pagination: true,
                    rownumbers: true,
                    sortName: "CreateTime",
                    sortOrder: "DESC"
                });
            }
        };
        var ClickManager = {
            ExamReport: function () {
                if (!controls["ExamingTable"]) return;
                var row = controls["ExamingTable"].datagrid("getSelected");
                if (row) { clickFunc(row); }
            },
            lookReportdata: function (type) {
                var row = ClickManager.getSeclecRow(type);
                if (row) EventManager.ViewReportData(null, row);
            },
            CancleExamReport: function () {
                if (!controls["ExamedTable"]) return;
                var row = controls["ExamedTable"].datagrid("getSelected");
                if (row) { ExamedClickFunc(row); }
            },
            lookReportHistory: function (type) {
                var row = ClickManager.getSeclecRow(type);
                if (row) {
                    itemId = row.ReportId + ";" + row.CompanyId;
                    EventManager.ReportExamHistiry(itemId);
                }
            },
            getSeclecRow: function (type) {
                if (!controls["ExamingTable"]) return;
                switch (type) {
                    case "Examing":
                        var row = controls["ExamingTable"].datagrid("getSelected");
                        break;
                    case "Examed":
                        row = controls["ExamedTable"].datagrid("getSelected");
                        break; 
                }
                return row;
            }
        };
        var EventManager = {
            onSelect_Event: function (title, index) {
                if (!currentState.ReportState.AuditPaper) { return; }
                if (index == "1") {
                    if (controls["ExamedTable"] == undefined) {
                        var para = menuManager.GetLoadParam();
                        var url = CreateUrl(urls.ReportUrls, ReportDataAction.ActionType.Grid, ReportDataAction.Functions.FillReport, ReportDataAction.Methods.FillReportMethods.GetHigherCancelReportStateDataGrid, para);
                        loadManager.LoadCancelExamGrid(url, "ExamedTable", ExamedBar);
                    } else {
                        controls["ExamedTable"].datagrid("reload");
                    }
                } else if (index == "2") {
                    EventManager.select_ReportExamHistory(controls.selectedRow);
                }
            },
            select_ReportExamHistory: function () {
                var para = menuManager.GetLoadParam();
                para.ReportId = controls.selectedRow.ReportId;
                para.CompanyId = controls.selectedRow.CompanyId;
                var url = CreateUrl(urls.ReportUrls, ReportDataAction.ActionType.Grid, ReportDataAction.Functions.FillReport, ReportDataAction.Methods.FillReportMethods.GetExamAllHistoryGrid, para);
                loadManager.LoadReportHistoryGrid(url, "ReportExamHistory");
            },
            //报表详细数据查看
            ViewReportData: function (value, row, Index) {
                //张双义
                var para = { ReportId: row.ReportId, CompanyId: row.CompanyId, Cycle: currentState.ReportState.Zq, Year: currentState.ReportState.Nd, PaperId: currentState.ReportState.AuditPaper.value, TaskId: currentState.ReportState.AuditTask.value };
                para = JSON2.stringify(para);
                para = encodeURI(para);
                parent.NavigatorNode({ id: "059", text: row.ReportName, attributes: { url: urls.ReportDataUrl + "?para=" + para} });
            },
            ReportExamHistiry: function (id) {
                var row = id.split(";");
                controls.selectedRow.ReportId = row[0];
                controls.selectedRow.CompanyId = row[1];
                var title = '报表审批历史';
                if ($('#center').tabs('exists', title)) {
                    $('#center').tabs('select', title);
                } else {
                    $('#center').tabs('add', {
                        title: title,
                        content: '<table id="ReportExamHistory" ></table></div>',
                        closable: true
                    });
                }
            },
            SearchReport: function () {
                var tab = $("#center").tabs("getSelected");
                var index = $('#center').tabs('getTabIndex', tab);
                switch (index) {
                    case 0:
                        ReportName = $("#ExamReportName").val();
                        ReportCode = $("#ExamReportCode").val();
                        CompanyName = $("#ExamCompany").val();
                        var data = { ReportCode: ReportCode, ReportName: ReportName, CompanyName: CompanyName };
                        $('#ExamingTable').datagrid("reload", data);
                        break;
                    case 1:
                        ReportName = $("#ExamedReportName").val();
                        ReportCode = $("#ExamedReportCode").val();
                        CompanyName = $("#ExamedCompany").val();
                        var data = { ReportCode: ReportCode, ReportName: ReportName, CompanyName: CompanyName };
                        $('#ExamedTable').datagrid("reload", data);
                        break;
                }
            },
            FreeSearch: function () {
                var tab = $("#center").tabs("getSelected");
                var index = $('#center').tabs('getTabIndex', tab);
                var data = {};
                switch (index) {
                    case 0:
                        $("#ExamReportName").val("");
                        $("#ExamReportCode").val("");
                        $("#ExamCompany").val("");
                        $('#ExamingTable').datagrid("reload", data);
                        break;
                    case 1:
                        $("#ExamedReportName").val("");
                        $("#ExamedReportCode").val("");
                        $("#ExamedCompany").val("");
                        $('#ExamedTable').datagrid("reload", data);
                        break;
                }
            }
        };
        function ChangeTask() {
            currentState.ReportState["auditPaperVisible"] = "1";
            currentState.ReportState["auditZqVisible"] = "1";
            dialog.Open("ct/ReportData/ChooseAuditTask.aspx", "切换任务", currentState.ReportState, function (result) {
                if (result && result != undefined) {
                    if (result.auditZqType == "05") {
                        if (result.WeekReport.ID == "") {
                            alert("请定义周报周期");
                        }
                    }
                    currentState.ReportState = result;
                    var para = menuManager.GetLoadParam();
                    var url = CreateUrl(urls.ReportUrls, ReportDataAction.ActionType.Grid, ReportDataAction.Functions.FillReport, ReportDataAction.Methods.FillReportMethods.GetHigherExamReportStateDataGrid, para);
                    loadManager.LoadExamGrid(url, "ExamingTable");
                    var tab = $("#center").tabs("getSelected");
                    var index = $('#center').tabs('getTabIndex', tab);
                    if (controls["ExamedTable"] || index == 1) {
                        url = CreateUrl(urls.ReportUrls, ReportDataAction.ActionType.Grid, ReportDataAction.Functions.FillReport, ReportDataAction.Methods.FillReportMethods.GetHigherCancelReportStateDataGrid, para);
                        loadManager.LoadCancelExamGrid(url, "ExamedTable", ExamedBar);
                    }
                }
            }, { width: 440, height: 500 });

         
        }
        var menuManager = {
            ExamReportState: function (discription, stageResult, id) {
                var para = { Ids: "", Discription: discription, StageResult: stageResult, Id: id };
                var selectedRows = controls["ExamingTable"].datagrid("getSelections");
                $.each(selectedRows, function (index, row) {
                    para.Ids += row.Id + ",";
                });
                if (para.Ids.length > 0) {
                    para.Ids = para.Ids.substr(0, para.Ids.length - 1);
                }
                if (id) { para.Ids = ""; }
                para = CreateParameter(ReportDataAction.ActionType.Grid, ReportDataAction.Functions.FillReport, ReportDataAction.Methods.FillReportMethods.HigherCheck, para);
                DataManager.sendData(urls.ReportUrls, para, resultManager.ExamReport_Success, resultManager.Fail);
            },
            CancelExamReportState: function (id) {
                var para = { Ids: "", Id: id, stageResult: "1" };
                var selectedRows = controls["ExamedTable"].datagrid("getSelections");
                $.each(selectedRows, function (index, row) {
                    para.Ids += row.Id + ",";
                });
                if (para.Ids.length > 0) {
                    para.Ids = para.Ids.substr(0, para.Ids.length - 1);
                }
                if (id) { para.Ids = ""; }
                para = CreateParameter(ReportDataAction.ActionType.Grid, ReportDataAction.Functions.FillReport, ReportDataAction.Methods.FillReportMethods.CancelHigherCheck, para);
                DataManager.sendData(urls.ReportUrls, para, resultManager.CanceExamReport_Success, resultManager.Fail);
            },
            OpenDialog: function (id) {
                $("#dialog").css("display", "block");
                controls.dialog = $('#dialog').dialog({
                    title: '审批对话框',
                    width: 400,
                    height: 300,
                    closed: false,
                    cache: false,
                    modal: true,
                    toobar: [],
                    buttons: [{ text: "保存",
                        iconCls: 'icon-ok', handler: function () {
                            var suggest = $("#suggest").text();
                            var result = $("#result").combobox("getValue");

                            menuManager.ExamReportState(suggest, result, id);
                        }
                    },
                   { text: "关闭",
                       iconCls: 'icon-close', handler: function () {
                           controls.dialog.dialog("close");
                       }
                   }]
                });
                $("#suggest").text('');
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
        };
        var resultManager = {
            ExamReport_Success: function (data) {
                if (data.success) {
                    MessageManager.InfoMessage(data.sMeg);
                    controls["ExamingTable"].datagrid("reload");
                    controls.dialog.dialog("close");

                    if (controls["ExamedTable"] != undefined) {
                        controls["ExamedTable"].datagrid("reload");
                    }
                } else {
                    MessageManager.ErrorMessage(data.sMeg);
                }
            },
            Fail: function (data) {
                MessageManager.ErrorMessage(data.toString);
            },
            CanceExamReport_Success: function (data) {
                if (data.success) {
                    MessageManager.InfoMessage(data.sMeg);
                    controls["ExamedTable"].datagrid("reload");

                    if (controls["ExamingTable"] != undefined) {
                        controls["ExamingTable"].datagrid("reload");
                    }
                } else {
                    MessageManager.ErrorMessage(data.sMeg);
                }
            }
        };
    </script>
</head>
<body  style=" overflow:hidden">
    <div  id="center">
        <div title="审批">
            <div style="overflow:hidden" class ="easyui-layout" data-options="fit:true">
                <div data-options="region:'north'" style="height:32px; padding:2px; overflow:hidden;background-color:#E0ECFF ;">
                    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-ok'" onclick="ClickManager.ExamReport()" style="width:70px; float:left"plain="true">审批</a>
                    <div class="datagrid-btn-separator"></div>
                    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="ClickManager.lookReportdata('Examing')" style="width:110px; float:left"plain="true">报表数据查看</a>
                    <div class="datagrid-btn-separator"></div>
                    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="ClickManager.lookReportHistory('Examing')" style="width:110px; float:left"plain="true">报表审批历史</a>
                </div>
                <div data-options="region:'center'" style="border:0px;">
                    <div id="ExamingBar" class ="datagrid-toolbar" style=" display:none; width:100%">
                        <table style=" font-size:13px; width:100%"><tr>   
                            <td style=" width:60px">单位名称</td> <td style=" width:170px"> <input id = "ExamCompany"class="easyui-validatebox textbox"/></td>
                            <td style=" width:60px">报表编号</td> <td style=" width:170px"> <input id = "ExamReportCode"class="easyui-validatebox textbox" /></td>
                            <td style=" width:60px">报表名称</td> <td> <input id = "ExamReportName"class="easyui-validatebox textbox"/></td>
                            <td style=" float:right"> 
                                <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="EventManager.SearchReport()" style="width:60px; margin-right:10px;">查询</a>
                                <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-undo'" onclick="EventManager.FreeSearch()" style="width:60px; margin-right:10px;">重置</a>
                            </td>
                            </tr>
                        </table>
                    </div>
                    <table id="ExamingTable"></table>
                </div>
                <div   data-options="region:'south'"style="height:30px; text-align:center;  overflow:hidden; font-size:12px;">
                    <p><a href="#" onclick="ChangeTask();return false;">审计任务切换</a></p>
                </div>     
            </div>
        </div>
        <div title="取消审批">
            <div style="overflow:hidden" class ="easyui-layout" data-options="fit:true">
                <div data-options="region:'north'" style="height:32px;padding:2px; overflow:hidden;background-color:#E0ECFF ;">
                    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-ok'" onclick="ClickManager.CancleExamReport()" style="width:90px; float:left"plain="true">取消审批</a>
                    <div class="datagrid-btn-separator"></div>
                    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="ClickManager.lookReportdata('Examed')" style="width:110px; float:left"plain="true">报表数据查看</a>
                    <div class="datagrid-btn-separator"></div>
                    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="ClickManager.lookReportHistory('Examed')" style="width:110px; float:left"plain="true">报表审批历史</a>
                </div>
                <div data-options="region:'center'" style="border:0px;">
                    <div id="ExamedBar" class ="datagrid-toolbar" style=" display:none; width:100%">
                        <table style=" font-size:13px; width:100%"><tr>   
                            <td style=" width:60px">单位名称</td> <td style=" width:170px"> <input id = "ExamedCompany"class="easyui-validatebox textbox" /></td>
                            <td style=" width:60px">报表编号</td> <td style=" width:170px"> <input id = "ExamedReportCode"class="easyui-validatebox textbox" /></td>
                            <td style=" width:60px">报表名称</td> <td> <input id = "ExamedReportName"class="easyui-validatebox textbox" /></td>
                            <td style=" float:right"> 
                                <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="EventManager.SearchReport()" style="width:60px; margin-right:10px;">查询</a>
                                <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-undo'" onclick="EventManager.FreeSearch()" style="width:60px; margin-right:10px;">重置</a>
                            </td>
                            </tr>
                        </table>
                    </div>
                    <table id="ExamedTable"></table>
                </div>
                <div   data-options="region:'south'"style="height:30px; text-align:center;  overflow:hidden; font-size:12px;">
                    <p><a href="#" onclick="ChangeTask();return false;">审计任务切换</a></p>
                </div> 
            </div>
        </div>
    </div>
    <div id="dialog" style="display:none">
         <table style="width:100%; height:90%;font-size:13px; padding-top:15px; padding-left:15px"  > 
         <tr><td>是否通过</td><td><select class="easyui-combobox" id="result" style="width:261px; height:30px"data-options="panelHeight:'auto'"><option value="1">是</option>
        <option value="0">否</option>
        </select> </td></tr>
        <tr><td>审计意见</td><td><textarea id="suggest" cols="30" rows="8" style=" overflow:auto; border: 1px solid #c4DADF" ></textarea></td></tr>
    </table>
    </div>
           
</body>
</html>
