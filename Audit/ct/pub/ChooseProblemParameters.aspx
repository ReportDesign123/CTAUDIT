<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ChooseProblemParameters.aspx.cs" Inherits="Audit.ct.pub.ChooseProblemParameters" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
  <title>选择问题参数</title>
    <link href="../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <link href="../../Styles/Common.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <script src="../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="../../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script src="../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <script src="../../Scripts/Ct_Controls.js" type="text/javascript"></script>
    <script src="../../Scripts/Ct_Tool.js" type="text/javascript"></script>
    <script src="../../Scripts/ct/pub/PubHelp.js" type="text/javascript"></script>
    <link href="../../Styles/Ct_Controls.css" rel="stylesheet" type="text/css" />
</head>
<body>
<script src="../../Scripts/ct/pub/PubHelp.js" type="text/javascript"></script>
   <table style="margin:20px auto;" cellspacing="10px">
        <tr style="display:none"><td>审计日期</td><td><input class="easyui-datebox" id="auditDate"/></td></tr> 
            <tr><td>审计类型</td><td><div id="auditType"></div></td></tr>
            <tr><td>审计任务</td><td><div id="auditTask"></div></td></tr> 
            <tr><td>审计底稿</td><td><div id="auditPaper"></div></td></tr>
            <tr><td>报表周期</td><td><input id="zqType" type="text" readonly="readonly" class="easyui-combobox" data-options="url:pUrls.ReportZq,valueField:'Code',textField:'Name',panelHeight:'auto',onLoadSuccess:DialogManager.initializeParam" /></td></tr>
            <tr id="YearTr"><td>年度</td><td><input id="Year" type="text"  class="easyui-combobox" /></td></tr>
            <tr id="CycleTr"><td><span id="CycleSpan">周期</span></td><td id="CycleTd"><input id="Cycle" class="easyui-combobox" /></td></tr>
            <tr><td>报表</td><td><div id="auditReport"></div></td></tr>
            <tr><td>单位</td><td><div id="auditCompany"></div></td></tr>
    </table>
    <script type="text/javascript">
        var pUrls = {
            functionsUrl: "../../handler/BasicHandler.ashx",
            AuditTypeUrl: "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Get + "&MethodName=GetDictionaryListByClassType&FunctionName=" + BasicAction.Functions.DictionaryManager + "&ClassType=RWLX",
            AuditTaskUrl: "../../handler/ReportDataHandler.ashx?ActionType=" + ReportDataAction.ActionType.Grid + "&MethodName=" + ReportDataAction.Methods.FillReportMethods.GetAuditTasksDataGrid + "&FunctionName=" + ReportDataAction.Functions.FillReport,
            AuditPaperUrl: "../../handler/ReportDataHandler.ashx?ActionType=" + ReportDataAction.ActionType.Grid + "&MethodName=" + ReportDataAction.Methods.ReportAggregationMethods.GetAuditPaperDataGrid + "&FunctionName=" + ReportDataAction.Functions.ReportAggregation,
            CompanyTreeHelp: "../../handler/ExportReport.ashx?ActionType=" + ExportAction.ActionType.Grid + "&MethodName=" + ExportAction.Methods.CreatReportMethod.GetCompaniesByAuthority + "&FunctionName=" + ExportAction.Functions.CreateReport,
            CompanyListHelp:"../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Grid + "&MethodName=" + BasicAction.Methods.CompanyManagerMethods.CompanyDataGrid + "&FunctionName=" + BasicAction.Functions.CompanyManager,
            ReportZq: "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Get + "&MethodName=GetDictionaryListByClassType&FunctionName=" + BasicAction.Functions.DictionaryManager + "&ClassType=BBZQ",
            ReportCycle: "../../handler/ReportDataHandler.ashx",
            ReportHelpUrl: "../../handler/ProblemTraceHandler.ashx?ActionType=" + ProblemTraceAction.ActionType.Grid + "&MethodName=" + ProblemTraceAction.Methods.ProblemManagerMethods.GetReportsByPaperId + "&FunctionName=" + ProblemTraceAction.Functions.ProblemTraceAction
        };
        var controls = { stateParam: { AuditType: { name: "", value: "" }, AuditDate: "", AuditTask: { name: "", value: "" }, AuditPaper: { name: "", value: "" }, Reports: { names: "", Ids: "" }, Companies: { names: "", Ids: "" }, auditZqType: "01", Year: "", Zq: ""} };

        var DialogManager = {
            //初始化
            initializeParam: function () {
                var para = controls.stateParam;
                controls.auditType.value.val(para.AuditType.value);
                controls.auditType.name.val(para.AuditType.name);
                controls.auditTask.value.val(para.AuditTask.value);
                controls.auditTask.name.val(para.AuditTask.name);
                controls.auditPaper.value.val(para.AuditPaper.value);
                controls.auditPaper.name.val(para.AuditPaper.name);
                controls.auditReport.name.val(para.Reports.names);
                controls.auditReport.value.val(para.Reports.Ids);
                controls.auditCompany.name.val(para.Companies.names);
                controls.auditCompany.value.val(para.Companies.Ids);
                if (para.AuditDate) {
                    $("#auditDate").datebox("setValue", controls.stateParam.AuditDate);
                } else {
                    $("#auditDate").datebox("setValue", Ct_Tool.GetCurrentDate());
                }
                $("#zqType").combobox("setValue", para.auditZqType);
                DialogManager.HelpManager.LoadZq(para.auditZqType);

            },
            //提交时 整理参数
            getProblemParam: function () {
                var para = { AuditType: { name: "", value: "" }, AuditDate: "", AuditTask: { name: "", value: "" }, AuditPaper: { name: "", value: "" }, Reports: { names: "", Ids: "" }, Companies: { names: "", Ids: "" }, auditZqType: "01", Year: "", Zq: "" };
                if (controls.auditTask.value.val() == "") {
                    alert("审计任务不能为空"); return;
                }
                para.AuditType.value = controls.auditType.value.val();
                para.AuditType.name = controls.auditType.name.val();
                para.AuditTask.value = controls.auditTask.value.val();
                para.AuditTask.name = controls.auditTask.name.val();
                para.AuditPaper.name = controls.auditPaper.name.val();
                para.AuditPaper.value = controls.auditPaper.value.val();
                para.Companies.names = controls.auditCompany.name.val();
                para.Companies.Ids = controls.auditCompany.value.val();
                para.Reports.names = controls.auditReport.name.val();
                para.Reports.Ids = controls.auditReport.value.val();

                para.auditZqType = $("#zqType").combobox("getValue");
                switch (para.auditZqType) {
                    case "01":
                        para.Year = $('#Year').combobox("getValue");
                        para.Zq = para.Year;
                        break;
                    case "02":
                    case "03":
                        para.Year = $('#Year').combobox("getValue");
                        para.Zq = $('#Cycle').combobox("getValue");
                        break;
                    case "04":
                        para.Zq = $('#Cycle').datebox("getValue");
                        para.Year = paras.Zq.substr(0, 4);
                        break;
                }
                return para;
            },
            HelpManager: {
                auditType_ClickEvent: function () {
                    var paras = { url: "", columns: [], sortName: "", sortOrder: "", NameField: "Name", CodeField: "Code" };
                    paras.url = "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Grid + "&MethodName=GetDictionaryDataGridByClassType&FunctionName=" + BasicAction.Functions.DictionaryManager + "&ClassType=RWLX";
                    paras.columns = [[
                    { field: "Code", title: "编号", width: 120 },
                     { field: "Name", title: "名称", width: 180 }
                    ]];
                    paras.sortName = "Code";
                    paras.sortOrder = "ASC";

                    paras.width = 450;
                    paras.height = 450;
                    pubHelp.setParameters(paras);
                    pubHelp.OpenDialogWithHref("paramHelpDialog", "审计类型选择", "../pub/HelpDialogEasyUi.htm", DialogManager.helpSaveManager.auditType_Save, paras.width, paras.height, true);
                },
                auditTask_ClickEvent: function () {
                    var paras = { url: "", columns: [], sortName: "", sortOrder: "", NameField: "Name", CodeField: "Code" };
                    var auditType = controls.auditType.value.val();
                    var auditDate = $("#auditDate").datebox("getValue");
                    paras.url = pUrls.AuditTaskUrl + "&AuditType=" + auditType + "&AuditDate=" + auditDate;
                    paras.columns = [[
                        { field: "Id", title: "Id", width: 80, hidden: true },
                        { field: "Code", title: "编号", width: 120 },
                        { field: "Name", title: "名称", width: 180 }
                    ]];
                    paras.sortName = "CreateTime";
                    paras.sortOrder = "DESC";
                    paras.width = 450;
                    paras.height = 450;
                    pubHelp.setParameters(paras);
                    pubHelp.OpenDialogWithHref("paramHelpDialog", "审计任务选择", "../pub/HelpDialogEasyUi.htm", DialogManager.helpSaveManager.auditTask_Save, paras.width, paras.height, true);
                },
                auditPaper_Click: function () {
                    var paras = { url: "", columns: [], sortName: "", sortOrder: "", NameField: "Name", CodeField: "Code" };
                    var taskId = controls.auditTask.value.val();

                    paras.url = pUrls.AuditPaperUrl + "&taskId=" + taskId;
                    paras.columns = [[
                { field: "Id", title: "Id", width: 80, hidden: true },
                    { field: "Code", title: "编号", width: 120 },
                     { field: "Name", title: "名称", width: 180 }
                    ]];
                    paras.sortName = "CreateTime";
                    paras.sortOrder = "DESC";
                    paras.width = 450;
                    paras.height = 450;
                    pubHelp.setParameters(paras);
                    pubHelp.OpenDialogWithHref("paramHelpDialog", "审计底稿选择", "../pub/HelpDialogEasyUi.htm", DialogManager.helpSaveManager.auditPaper_Save, paras.width, paras.height, true);
                },
                ReportHelp_Click: function () {
                    var paras = { url: "", columns: [], sortName: "bbCode", sortOrder: "ASC", NameField: "bbName", CodeField: "bbCode", defaultField: { dftBy: "Id", dft: ""} };
                    paras.url = pUrls.ReportHelpUrl + "&paperId=" + controls.auditPaper.value.val();
                    paras.columns = [[
                        { title: 'id', field: 'Id', width: 180, hidden: true },
			            { field: 'bbCode', title: '编号', width: 150, sortable: true },
                        { field: 'bbName', title: '名称', width: 190, sortable: true }
                            ]];
                    paras.choiceMore = true;
                    paras.defaultField.dft = controls.auditReport.value.val();
                    paras.width = 450;
                    paras.height = 450;
                    pubHelp.setParameters(paras);
                    pubHelp.OpenDialogWithHref("paramHelpDialog", "系统帮助", "../pub/HelpDialogEasyUi.htm", DialogManager.helpSaveManager.ReportHelp_Save, paras.width, paras.height, true);
                },
                CompanyHelp_Click: function () {
                    var treeParas = { idField: "", treeField: "", columns: [], url: "" };
                    treeParas.url = pUrls.CompanyTreeHelp;
                    treeParas.idField = "Id";
                    treeParas.treeField = "Code";
                    treeParas.columns = [[
                { title: 'id', field: 'Id', width: 180, hidden: true },
                { title: '组织机构编号', field: 'Code', width: 180 },
                { title: '组织机构名称', field: 'Name', width: 210 }
                        ]];
                    //treeParas.UseTo = "search";
                    treeParas.singleSelect = false;
                    treeParas.dataUrl = pUrls.CompanyListHelp;
                    treeParas.sortName = 'Code';
                    treeParas.sortOrder = 'ASC';
                    treeParas.width = 450;
                    treeParas.height = 450;
                    pubHelp.setParameters(treeParas);
                    pubHelp.OpenDialogWithHref("paramHelpDialog", "系统帮助", "../pub/HelpTreeDialog.aspx", DialogManager.helpSaveManager.CompanyHelp_save, treeParas.width, treeParas.height, true);
                },
                //获取 年度、周期数据
                LoadZq: function (zqType) {
                    var para = { ReportType: zqType };
                    para = CreateParameter(ReportDataAction.ActionType.Post, ReportDataAction.Functions.FillReport, ReportDataAction.Methods.FillReportMethods.GetReportCycle, para);
                    DataManager.sendData(pUrls.ReportCycle, para, successLoadCycle, fail, false);
                }
            },
            helpSaveManager: {
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
                        DialogManager.HelpManager.LoadZq(result.DefaultZq);
                    }
                },
                ReportHelp_Save: function () {
                    var result = pubHelp.getResultObj();
                    if (result.length > 0) {
                        var Ids = "";
                        var Names = "";
                        var old = { Ids: "", Names: "" };
                        old.Ids = controls.auditReport.value.val();
                        old.Names = controls.auditReport.name.val();
                        if (old.Ids.length > 0) {
                            var oldIds = old.Ids.split(",");
                            Ids = old.Ids + ",";
                            Names = old.Names + ",";
                            $.each(result, function (index, report) {
                                var seleted = false;
                                $.each(oldIds, function (index, Id) {
                                    if (report.Id == Id) {
                                        seleted = true;
                                        return false;
                                    }
                                });
                                if (!seleted) {
                                    Ids += report.Id + ",";
                                    Names += report.bbName + ",";
                                }
                            });
                        } else {
                            $.each(result, function (index, report) {
                                Ids += report.Id + ",";
                                Names += report.bbName + ",";
                            });
                        }
                        if (Ids.length > 0) {
                            Ids = Ids.substr(0, Ids.length - 1);
                            Names = Names.substr(0, Names.length - 1);
                        }
                        controls.auditReport.value.val(Ids);
                        controls.auditReport.name.val(Names);
                    }
                },
                CompanyHelp_save: function () {
                    var result = pubHelp.getResultObj();
                    if (result) {
                        if (result.length > 0) {
                            var Ids = "";
                            var Names = "";
                            $.each(result, function (index, company) {
                                Ids += company.Id + ",";
                                Names += company.Name + ",";
                            });
                            if (Ids.length > 0) {
                                Ids = Ids.substr(0, Ids.length - 1);
                                Names = Names.substr(0, Names.length - 1);
                            }
                            controls.auditCompany.value.val(Ids);
                            controls.auditCompany.name.val(Names);
                        }
                    }
                }
            }
        };
        //成功获取周期数据后 初始年度、周期
        function successLoadCycle (data) {
            if (data.success) {
                var zqType = $("#zqType").combobox("getValue");
                if (controls.stateParam.Zq && controls.stateParam.auditZqType == zqType) data.obj.CurrentZq = controls.stateParam.Zq;
                if (controls.stateParam.Year) data.obj.CurrentNd = controls.stateParam.Year;
                $("#CycleTd").empty();
                $("#CycleTd").append("<input id='Cycle' />");
                if (zqType == "04") {
                    $("#YearTr").css("display", 'none');
                    $("#CycleTr").css("display", 'table-row');
                    $('#CycleSpan').text("日期");
                    $('#Cycle').datebox({});
                    $('#Cycle').datebox("setValue", data.obj.CurrentZq);
                } else {
                    $("#YearTr").css("display", 'table-row');
                    $('#Year').combobox({
                        data: data.obj.Nds,
                        valueField: 'value',
                        textField: 'name'
                    });
                    $('#Year').combobox("setValue", data.obj.CurrentNd);
                    if (zqType == "01") {
                    
                        $("#CycleTr").css("display", "none");
                    } else {
                        $("#CycleTr").css("display", 'table-row');
                        $('#Cycle').combobox({
                            data: data.obj.Cycles,
                            valueField: 'value',
                            textField: 'name',
                            panelHeight: 'auto'
                        });
                        $("#CycleTr").css("display", 'table-row');
                        $('#Cycle').combobox("setValue", data.obj.CurrentZq);
                        if (zqType == "02") { $('#CycleSpan').text("月份"); }
                        if (zqType == "03") { $('#CycleSpan').text("季度"); }
                    }
                }
            } else {
                MessageManager.ErrorMessage(data.sMeg);
            }
        }
        function fail(data) {
            MessageManager.ErrorMessage(data.toString);
        }
        //此处开始执行 对象声明和绑定
        $(function () {
            controls.auditType = $("#auditType").PopEdit();
            controls.auditTask = $("#auditTask").PopEdit();
            controls.auditPaper = $("#auditPaper").PopEdit();
            controls.auditReport = $("#auditReport").PopEdit();
            controls.auditCompany = $("#auditCompany").PopEdit();
            controls.auditTask.btn.bind("click", function () {
                DialogManager.HelpManager.auditTask_ClickEvent();
            });
            controls.auditType.btn.bind("click", function () {
                DialogManager.HelpManager.auditType_ClickEvent();
            });
            controls.auditPaper.btn.bind("click", function () {
                DialogManager.HelpManager.auditPaper_Click();
            });
            controls.auditCompany.btn.bind("click", function () {
                DialogManager.HelpManager.CompanyHelp_Click();
            });
            controls.auditReport.btn.bind("click", function () {
                DialogManager.HelpManager.ReportHelp_Click();
            });
            //绑定onchange事件 以完成 value数据删除
            controls.auditReport.name.bind("change ", function () {
                if (!this.value) {
                    controls.auditReport.value.val("");
                }
            });
            //绑定onchange事件 以完成 value数据删除
            controls.auditCompany.name.bind("change ", function () {
                if (!this.value) {
                    controls.auditCompany.value.val("");
                }
            });
            controls.stateParam = currentState.problemParamter;
        });

    </script>
</body>
</html>
