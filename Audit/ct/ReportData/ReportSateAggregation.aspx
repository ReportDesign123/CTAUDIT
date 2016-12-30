<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReportSateAggregation.aspx.cs" Inherits="Audit.ct.ReportData.ReportSateAggregation" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
  <title>资料状态汇总</title>
     <script src="../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
     <link href="../../Styles/Ct_Controls.css" rel="stylesheet" type="text/css" />
    <script src="../../Scripts/Ct_Controls.js" type="text/javascript"></script>
    <link href="../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="../../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script src="../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <link href="../../Styles/Common.css" rel="stylesheet" type="text/css" />
    <script src="../../Scripts/Ct_Tool.js" type="text/javascript"></script>
    <script src="../../Scripts/ct/pub/PubHelp.js" type="text/javascript"></script>
    <script src="../../lib/json2.js" type="text/javascript"></script>
    <script type="text/javascript">
        var controls = { auditType: {}, auditTask: {}, auditPaper: {}, ReportList: {} ,zqType:""};
        var urls = {
            AuditTypeUrl: "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Get + "&MethodName=GetDictionaryListByClassType&FunctionName=" + BasicAction.Functions.DictionaryManager + "&ClassType=RWLX",
            AuditTaskUrl: "../../handler/ReportDataHandler.ashx?ActionType=" + ReportDataAction.ActionType.Grid + "&MethodName=" + ReportDataAction.Methods.FillReportMethods.GetAuditTasksDataGrid + "&FunctionName=" + ReportDataAction.Functions.FillReport,
            AuditPaperUrl: "../../handler/ReportDataHandler.ashx?ActionType=" + ReportDataAction.ActionType.Grid + "&MethodName=" + ReportDataAction.Methods.ReportAggregationMethods.GetAuditPaperDataGrid + "&FunctionName=" + ReportDataAction.Functions.ReportAggregation,
            StateUrl:"../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Get + "&MethodName=GetDictionaryListByClassType&FunctionName=" + BasicAction.Functions.DictionaryManager + "&ClassType=BBZT",
            ReportZq: "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Get + "&MethodName=GetDictionaryListByClassType&FunctionName=" + BasicAction.Functions.DictionaryManager + "&ClassType=BBZQ",
            FunctionUrl: "../../handler/ReportDataHandler.ashx",
            ResultUrl: "ct/ReportData/ReportStateAggregationDetail.aspx"
        };
        $(function () {
            controls.auditType = $("#auditType").PopEdit();
            controls.auditTask = $("#auditTask").PopEdit();
            controls.auditPaper = $("#auditPaper").PopEdit();
            controls.auditTask.btn.bind("click", function () {
                eventManager.auditTask_ClickEvent();
            });
            controls.auditType.btn.bind("click", function () {
                eventManager.auditType_ClickEvent();
            });
            controls.auditPaper.btn.bind("click", function () {
                eventManager.auditPaper_Click();
            });
            controls.auditType.value.val("01");
            controls.auditType.name.val("经营业绩审计");
            $("#auditDate").datebox("setValue", Ct_Tool.GetCurrentDate());
            ReportManager.LoadRepeort();
        });

        var eventManager = {
            auditType_ClickEvent: function () {
                var paras = { url: "", columns: [], sortName: "", sortOrder: "", NameField: "Name", CodeField: "Code" };
                paras.url = "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Grid + "&MethodName=GetDictionaryDataGridByClassType&FunctionName=" + BasicAction.Functions.DictionaryManager + "&ClassType=RWLX";
                paras.columns = [[
                    { field: "Code", title: "编号", width: 120 },
                     { field: "Name", title: "名称", width: 180 }
                    ]];
                paras.sortName = "Code";
                paras.sortOrder = "ASC";

                paras.width = 340;
                paras.height = 420;
                pubHelp.setParameters(paras);
                pubHelp.OpenDialogWithHref("Dialog", "审计类型选择", "../pub/HelpDialogEasyUi.htm", DialogSave.auditType_Save, paras.width, paras.height, true);
            },
            auditTask_ClickEvent: function () {
                var paras = { url: "", columns: [], sortName: "", sortOrder: "", NameField: "Name", CodeField: "Code" };
                var auditType = controls.auditType.value.val();
                var auditDate = $("#auditDate").datebox("getValue");

                paras.url = urls.AuditTaskUrl + "&AuditType=" + auditType + "&AuditDate=" + auditDate;
                paras.columns = [[
                { field: "Id", title: "Id", width: 80, hidden: true },
                    { field: "Code", title: "编号", width: 120 },
                     { field: "Name", title: "名称", width: 180 }
                    ]];
                paras.sortName = "CreateTime";
                paras.sortOrder = "DESC";
                paras.width = 340;
                paras.height = 420;
                pubHelp.setParameters(paras);
                pubHelp.OpenDialogWithHref("Dialog", "审计任务选择", "../pub/HelpDialogEasyUi.htm", DialogSave.auditTask_Save, paras.width, paras.height, true);
            },
            auditPaper_Click: function () {
                var paras = { url: "", columns: [], sortName: "", sortOrder: "", NameField: "Name", CodeField: "Code" };
                var taskId = controls.auditTask.value.val();

                paras.url = urls.AuditPaperUrl + "&taskId=" + taskId;
                paras.columns = [[
                { field: "Id", title: "Id", width: 80, hidden: true },
                    { field: "Code", title: "编号", width: 120 },
                     { field: "Name", title: "名称", width: 180 }
                    ]];
                paras.sortName = "CreateTime";
                paras.sortOrder = "DESC";
                paras.width = 340;
                paras.height = 420;
                pubHelp.setParameters(paras);
                pubHelp.OpenDialogWithHref("Dialog", "审计底稿选择", "../pub/HelpDialogEasyUi.htm", DialogSave.auditPaper_Save, paras.width, paras.height, true);
            }
        };
        var ReportManager = {
            LoadRepeort: function () {
                controls.ReportList = $("#ReportList").datagrid({
                    fit: true,
                    title: "报表列表",
                    border: false,
                    fitColumns: true,
                    singleSelect: false,
                    sortOrder: 'desc',
                    //toolbar: "#toolbar",
                    sortName: 'CreateTime',
                    columns: [[
			        { field: 'Id', checkbox: true },
			        { field: 'bbCode', title: '报表编号', width: 120, sortable: true },
			        { field: 'bbName', title: '报表名称', width: 190, sortable: true }
                    ]]
                });
            },
            setReportParam: function (param) {
                var para = CreateParameter(ReportDataAction.ActionType.Post, ReportDataAction.Functions.FillReport, ReportDataAction.Methods.FillReportMethods.GetReportFirstLoadStruct, param);
                DataManager.sendData(urls.FunctionUrl, para, resultManager.LoadReport_Success, resultManager.fail);
            },
            searchReport: function () {
                if (controls.auditTask.value.val() == "") {
                    MessageManager.ErrorMessage("审计任务不能为空！");
                    return;
                }
                var para = { TaskId: "", PaperId: "", ReportId: "", Nd: "", Zq: "", State: "" };
                var rows = controls.ReportList.datagrid("getSelections");
                if (rows.length > 0) {
                    var Ids = "";
                    $.each(rows, function (index, report) {
                        Ids += report.Id + ",";
                    })
                    para.ReportId = Ids.substring(0, Ids.length - 1);
                } else {
                    MessageManager.ErrorMessage("请选择要查看的报表！");
                    return;
                }
                var States = $("#reportState").combobox("getValues");
                if (States.length > 0) {
                    $.each(States, function (index, node) {
                        para.State += node + ",";
                    })
                    para.State = para.State.substring(0, para.State.length - 1);
                } else {
                    para.State = "00,01,02,03,04,08,09";
                }
                para.TaskId = controls.auditTask.value.val();
                para.PaperId = controls.auditPaper.value.val();
                para.Nd = $("#Year").combobox("getValue");
                if (controls.zqType != '01') {
                    para.Zq = $("#Cycle").combobox("getValue");
                } else {
                    para.Zq = $("#Year").combobox("getValue");
                }
                var paramStr = JSON2.stringify(para);
                paramStr = encodeURI(paramStr);
                parent.NavigatorNode({ id: "095", text: "状态汇总列表", attributes: { url: urls.ResultUrl + "?para=" + paramStr} });
            }
        };
        var DialogSave = {
            auditType_Save: function () {
                var result = pubHelp.getResultObj();
                if (result && result.Code) {
                    if (controls.auditType.value.val() != result.Code) {
                        controls.auditType.name.val(result.Name);
                        controls.auditType.value.val(result.Code);
                        controls.auditTask.name.val("");
                        controls.auditTask.value.val("");
                        controls.auditPaper.name.val("");
                        controls.auditPaper.value.val("");
                    }
                }
            },
            auditTask_Save: function () {
                var result = pubHelp.getResultObj();
                if (result && result.Id) {
                    if (controls.auditTask.value.val() != result.Id) {
                        controls.auditTask.name.val(result.Name);
                        controls.auditTask.value.val(result.Id);
                        controls.auditPaper.name.val("");
                        controls.auditPaper.value.val("");
                    }
                }
            },
            auditPaper_Save: function () {
                var result = pubHelp.getResultObj();
                if (result && result.Id) {
                    controls.auditPaper.name.val(result.Name);
                    controls.auditPaper.value.val(result.Id);
                    $('#zqType').combobox("setValue", result.DefaultZq);
                    var para = {};
                    para.TaskId = controls.auditTask.value.val();
                    para.PaperId = controls.auditPaper.value.val();
                    ReportManager.setReportParam(para);
                    LoadZq(result.DefaultZq);

                }
            }
        };
        function LoadZq(zqType) {
            controls.zqType = zqType;
            var para = { ReportType: zqType };
            para = CreateParameter(ReportDataAction.ActionType.Post, ReportDataAction.Functions.FillReport, ReportDataAction.Methods.FillReportMethods.GetReportCycle, para);
            DataManager.sendData(urls.FunctionUrl, para, resultManager.success, resultManager.fail, false);
        }
        var resultManager = {
            LoadReport_Success: function (data) {
                if (data.success) {
                    controls.ReportList.datagrid("loadData", data.obj.reports);
                } else {
                    MessageManager.ErrorMessage(data.sMeg);
                }
            },
            success: function (data) {
                if (data.success) {
                    $('#Year').combobox("loadData", data.obj.Nds);
                    $('#Year').combobox("setValue", data.obj.CurrentNd);
                    var zqType = controls.zqType;
                    $("#CycleTd").empty();
                    $("#CycleTd").append("<input id='Cycle' />");
                    if (zqType == "04") {
                        $("#CycleTr").css("display", 'table-row');
                        $('#CycleSpan').text("日期");
                        $('#Cycle').datebox({});
                        $('#Cycle').datebox("setValue", data.obj.CurrentZq);
                    } else {
                        switch (zqType) {
                            case "01":
                                $("#CycleTr").css("display", "none");
                                break;
                            case "02":
                                $('#Cycle').combobox({
                                    data: data.obj.Cycles,
                                    valueField: 'value',
                                    textField: 'name',
                                    panelHeight: 'auto'
                                });
                                $("#CycleTr").css("display", 'table-row');
                                $('#CycleSpan').text("月份");
                                $('#Cycle').combobox("setValue", data.obj.CurrentZq);
                                break;
                            case "03":
                                $('#Cycle').combobox({
                                    data: data.obj.Cycles,
                                    valueField: 'value',
                                    textField: 'name',
                                    panelHeight: 'auto'
                                });
                                $("#CycleTr").css("display", 'table-row');
                                $('#CycleSpan').text("季度");
                                $('#Cycle').combobox("setValue", data.obj.CurrentZq);
                                break;
                        }
                    }
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

<body class="easyui-layout">
<div data-options="region:'north'" style=" height:32px; padding:2px;background-color:#E0ECFF ;overflow:hidden">
      <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add',iconAlign:'left',line:true" onclick="ReportManager.searchReport()" style="width:120px; float:left "plain="true">汇总查询</a>
    <div class="datagrid-btn-separator"></div>
</div>
<div data-options="region:'west',split:true"  style="width:300px">
<div style="display:none" ><input class="easyui-datebox"  id="auditDate" /></div>
    <table style=" clear:both;  margin:auto; margin-top:30px;" cellspacing="20px">
    <tr><td>审计类型</td><td><div id="auditType"></div></td></tr>
    <tr><td>审计任务</td><td><div id="auditTask"></div></td></tr> 
    <tr><td>审计底稿</td><td><div id="auditPaper"></div></td></tr>
    </table>
</div>
<div data-options="region:'center',split:true,border:false">
    <div class="easyui-layout" fit="true">
        <div data-options="region:'north'" style="height:150px">
            <div id="toolbar" >
                <table style="padding-left:20px" cellspacing="15px">
                    <tr><td>年度</td><td><input id="Year" type="text"  class="easyui-combobox" data-options="url:urls.ReportZq,valueField:'value',textField:'name',panelHeight:'auto'" /></td></tr>
                    <tr id="CycleTr"><td><span id="CycleSpan">周期</span></td><td id="CycleTd"><input id="Cycle"  class="easyui-combobox" /></td></tr>
                    <tr><td>报表状态</td><td><input id = "reportState"  class="easyui-combobox" data-options="url:urls.StateUrl,valueField:'Code',textField:'Name',panelHeight:'auto',multiple:true" /></td></tr>
                </table>
            </div>
        </div>
        <div data-options="region:'center'">
            <table id="ReportList"></table>
        </div>
    </div>
</div>
    <div id="Dialog"></div>
</body>
</html>
