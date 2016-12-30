<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProblemSender.aspx.cs" Inherits="Audit.ct.ProblemTrace.ProblemSender" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>审计问题下达</title>
    <script src="../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <link href="../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="../../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <link href="../../Styles/Common.css" rel="stylesheet" type="text/css" />
    <script src="../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <link href="../../Styles/Ct_Controls.css" rel="stylesheet" type="text/css" />
    <script src="../../Scripts/Ct_Controls.js" type="text/javascript"></script>
    <script src="../../Scripts/Ct_Tool.js" type="text/javascript"></script>
    <script src="../../Scripts/ct/pub/PubHelp.js" type="text/javascript"></script>
    <script type="text/javascript">
        var urls = {
            functionsUrl: "../../handler/ProblemTraceHandler.ashx",
            problemTypeUrl: "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Get + "&MethodName=GetDictionaryListByClassType&FunctionName=" + BasicAction.Functions.DictionaryManager + "&ClassType=WTLB",
            CompanyTreeHelp: "../../handler/ExportReport.ashx?ActionType=" + ExportAction.ActionType.Grid + "&MethodName=" + ExportAction.Methods.CreatReportMethod.GetCompaniesByAuthority + "&FunctionName=" + ExportAction.Functions.CreateReport,
            CompanyListHelp:"../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Grid + "&MethodName=" + BasicAction.Methods.CompanyManagerMethods.CompanyDataGrid + "&FunctionName=" + BasicAction.Functions.CompanyManager,
            ReportHelpUrl: "../../handler/ProblemTraceHandler.ashx?ActionType=" + ProblemTraceAction.ActionType.Grid + "&MethodName=" + ProblemTraceAction.Methods.ProblemManagerMethods.GetReportsByPaperId + "&FunctionName=" + ProblemTraceAction.Functions.ProblemTraceAction,
            ParameterUrl:"../pub/ChooseProblemParameters.aspx"
        };
        var problemList;
        var currentState = { problemParamter: { AuditType: { name: "", value: "" }, AuditDate: "", AuditTask: { name: "", value: "" }, AuditPaper: { name: "", value: "" }, auditZqType: "01", Year: "", Zq: "", Reports: { names: "", Ids: "" }, Companies: { names: "", Ids: ""}} };
        var mainControl = {};
        $(function () {
            $("#topTab").tabs({
                border:false,
                fit: true,
                onSelect: MainManager.TabManager.selectTab
            });
            mainControl.CompanyHelp = $("#CompanyHelp").PopEdit();
            mainControl.CompanyHelp.btn.bind("click", function () {
                MainManager.HelpManager.CompanyHelp_Click();
            });
            mainControl.ReportHelp = $("#ReportHelp").PopEdit();
            mainControl.ReportHelp.btn.bind("click", function () {
                MainManager.HelpManager.ReportHelp_Click();
            });
            MainManager.openParamDialog();
        });
        var MainManager = {
            openParamDialog: function () {
                currentState.paramDialog = $("#paramDialog").dialog({
                    title: '选择问题参数',
                    iconCls: 'icon-audit',
                    href: urls.ParameterUrl,
                    width: 450,
                    height: 450,
                    cache: false,
                    modal: true,
                    closed: false,
                    maximizable: false,
                    resizable: false,
                    buttons: [{
                        text: '获取审计问题',
                        iconCls: 'icon-reload',
                        handler: function () {
                            var param = DialogManager.getProblemParam();
                            if (!param) { return; }
                            currentState.problemParamter = param;
                            currentState.paramDialog.dialog("close");
                            MainManager.SetAuditParameter(param);
                        }
                    }]
                });
            },
            SetAuditParameter: function (result) {
                currentState.problemParamter = result;
                MainManager.loadProblem();
                //填报底稿、周期信息显示
                $("#auditTaskTypeSpan").text(currentState.problemParamter.AuditType.name);
                $("#auditTaskSpan").text(currentState.problemParamter.AuditTask.name);
                $("#auditPaperSpan").text(currentState.problemParamter.AuditPaper.name);
                var reportZq;
                switch (currentState.problemParamter.auditZqType) {
                    case "01":
                        reportZq = currentState.problemParamter.Year + "年"
                        break;
                    case "02":
                        reportZq = currentState.problemParamter.Year + "年" + currentState.problemParamter.Zq + "月";
                        break;
                    case "03":
                        reportZq = currentState.problemParamter.Year + "年" + currentState.problemParamter.Zq + "季度"
                        break;
                    case "04":
                        reportZq = currentState.problemParamter.Zq + "日";
                        break;
                }
                $("#auditDateSpan").text(reportZq);
            },
            loadProblem: function () {
                var parameter = MainManager.creatParameter();
                var tab = $('#topTab').tabs('getSelected');
                var index = $('#topTab').tabs('getTabIndex', tab);
                var state = index.toString();
                var url = CreateUrl(urls.functionsUrl, ProblemTraceAction.ActionType.Grid, ProblemTraceAction.Functions.ProblemTraceAction, ProblemTraceAction.Methods.ProblemManagerMethods.DataGridReportProblemEntity, { State: state });
                $("#problemList").datagrid({
                    url: url,
                    queryParams: parameter
                });
            },
            publishProblem: function () {
                var rows = $("#problemList").datagrid("getSelections");
                if (rows.length > 0) {
                    var para = { ids: "" };
                    $.each(rows, function (index, problem) {
                        para.ids += problem.Id + ',';
                    });
                    para.ids = para.ids.substring(0, para.ids.length - 1);
                    para = CreateParameter(ProblemTraceAction.ActionType.Post, ProblemTraceAction.Functions.ProblemTraceAction, ProblemTraceAction.Methods.ProblemManagerMethods.publishProblem, para);
                    DataManager.sendData(urls.functionsUrl, para, resultManager.success, resultManager.fail, false);
                } else {
                    MessageManager.ErrorMessage("请先选择一行再进行编辑！");
                    return;
                }
            },
            canclePublishProblem: function () {
                var rows = $("#problemList").datagrid("getSelections");
                if (rows.length > 0) {
                    var para = { ids: "" };
                    $.each(rows, function (index, problem) {
                        para.ids += problem.Id + ',';
                    });
                    para.ids = para.ids.substring(0, para.ids.length - 1);
                    para = CreateParameter(ProblemTraceAction.ActionType.Post, ProblemTraceAction.Functions.ProblemTraceAction, ProblemTraceAction.Methods.ProblemManagerMethods.canclePublishProblem, para);
                    DataManager.sendData(urls.functionsUrl, para, resultManager.success, resultManager.fail, false);
                } else {
                    MessageManager.ErrorMessage("请先选择一行再进行编辑！");
                    return;
                }
            },
            creatParameter: function (para) {
                if (!para) {
                    para = { TaskId: "", PaperId: "", ReportId: "", CompanyId: "", Year: "", Zq: "" };
                }
                para.TaskId = currentState.problemParamter.AuditTask.value;
                para.PaperId = currentState.problemParamter.AuditPaper.value;
                para.ReportId = currentState.problemParamter.Reports.Ids;
                para.CompanyId = currentState.problemParamter.Companies.Ids;
                para.Year = currentState.problemParamter.Year;
                para.Zq = currentState.problemParamter.Zq;
                return para;
            },
            checkParameter: function () {
                if (!currentState.problemParamter.AuditTask.value) { return; }
                if (!currentState.problemParamter.AuditPaper.value) { return; }
                if (!currentState.problemParamter.Year) { return; }
                if (!currentState.problemParamter.Zq) { return; }
                //if (!currentState.problemParamter.Reports.Ids) { return; }
                //if (!currentState.problemParamter.Companies.Ids) { return; }
                return true;
            },
            TabManager: {
                selectTab: function (title, index) {
                    if (!MainManager.checkParameter()) return;
                    var parameter = MainManager.creatParameter();
                    var url = "";
                    if (index == 0) {
                        url = CreateUrl(urls.functionsUrl, ProblemTraceAction.ActionType.Grid, ProblemTraceAction.Functions.ProblemTraceAction, ProblemTraceAction.Methods.ProblemManagerMethods.DataGridReportProblemEntity, { State: '0' });
                    } else {
                        url = CreateUrl(urls.functionsUrl, ProblemTraceAction.ActionType.Grid, ProblemTraceAction.Functions.ProblemTraceAction, ProblemTraceAction.Methods.ProblemManagerMethods.DataGridReportProblemEntity, { State: '1' });
                    }
                    $("#problemList").datagrid({
                        url: url,
                        queryParams: parameter
                    });
                    $("#pType").combobox("setValue", ""); ;
                    mainControl.CompanyHelp.name.val("");
                    mainControl.CompanyHelp.value.val("");
                    mainControl.ReportHelp.name.val("");
                    mainControl.ReportHelp.value.val("");
                }
            },
            //查询栏帮助 相关方法
            HelpManager: {
                CompanyHelp_Click: function () {
                    var treeParas = { idField: "", treeField: "", columns: [], url: "" };
                    treeParas.url = urls.CompanyTreeHelp;
                    treeParas.idField = "Id";
                    treeParas.treeField = "Code";
                    treeParas.columns = [[
                { title: 'id', field: 'Id', width: 180, hidden: true },
                { title: '组织机构编号', field: 'Code', width: 180 },
                { title: '组织机构名称', field: 'Name', width: 210 }
                        ]];
                    treeParas.UseTo = "search";
                    treeParas.singleSelect = true;
                    treeParas.dataUrl = urls.CompanyListHelp;
                    treeParas.sortName = 'Code';
                    treeParas.sortOrder = 'ASC';
                    treeParas.width = 450;
                    treeParas.height = 450;
                    pubHelp.setParameters(treeParas);
                    pubHelp.OpenDialogWithHref("paramHelpDialog", "系统帮助", "../pub/HelpTreeDialog.aspx", MainManager.HelpManager.CompanyHelp_save, treeParas.width, treeParas.height, true);
                },
                ReportHelp_Click: function () {
                    var paras = { url: "", columns: [], sortName: "bbCode", sortOrder: "ASC", NameField: "bbName", CodeField: "bbCode", defaultField: { dftBy: "Id", dft: ""} };
                    var PaperId = currentState.problemParamter.AuditPaper.value;
                    paras.url = urls.ReportHelpUrl + "&PaperId=" + PaperId;
                    paras.columns = [[
                    { title: 'id', field: 'Id', width: 180, hidden: true },
			       { field: 'bbCode', title: '编号', width: 150, sortable: true },
                   { field: 'bbName', title: '名称', width: 190, sortable: true }
                        ]];
                    paras.defaultField.dft = mainControl.ReportHelp.value.val();
                    paras.width = 450;
                    paras.height = 450;
                    pubHelp.setParameters(paras);
                    pubHelp.OpenDialogWithHref("paramHelpDialog", "系统帮助", "../pub/HelpDialogEasyUi.htm", MainManager.HelpManager.ReportHelp_Save, paras.width, paras.height, true);
                },
                CompanyHelp_save: function () {
                    var result = pubHelp.getResultObj();
                    if (result) {
                        if (result.length > 0) {
                            mainControl.CompanyHelp.name.val(result[0].Name);
                            mainControl.CompanyHelp.value.val(result[0].Id);
                        }
                    }
                },
                ReportHelp_Save: function () {
                    var result = pubHelp.getResultObj();
                    if (result) {
                        mainControl.ReportHelp.name.val(result.bbName);
                        mainControl.ReportHelp.value.val(result.Id);
                    }
                }
            },
            SearchManager: {
                DoSearch: function () {
                    var obj = MainManager.creatParameter();
                    obj.Type = $("#pType").combobox("getValue");
                    if (mainControl.CompanyHelp.value.val()) {
                        obj.CompanyId = mainControl.CompanyHelp.value.val();
                    }
                    if (mainControl.ReportHelp.value.val()) {
                        obj.ReportId = mainControl.ReportHelp.value.val();
                    }
                    $("#problemList").datagrid("reload", obj);
                },
                FreeSearch: function () {
                    var obj = MainManager.creatParameter();
                    $("#pType").combobox("setValue", ""); ;
                    mainControl.CompanyHelp.name.val("");
                    mainControl.CompanyHelp.value.val("");
                    mainControl.ReportHelp.name.val("");
                    mainControl.ReportHelp.value.val("");
                    $("#problemList").datagrid("reload", obj);
                }
            }
        };
        var resultManager = {
            success: function (data) {
                if (data.success) {
                    MessageManager.InfoMessage(data.sMeg);
                    $("#problemList").datagrid('reload');
                    $("#problemList").datagrid('unselectAll');
                } else {
                    MessageManager.ErrorMessage(data.sMeg);
                }
            },
            fail: function (data) {
                MessageManager.ErrorMessage(data.toString);
            }
        }
       
       
    </script>
    
</head>
<body class="easyui-layout">
    <div data-options="region:'north',collapsible:false" style=" height:61px;overflow:hidden">
        <div id="topTab">
            <div title="下达问题" style="padding:2px;background-color:#E0ECFF;">
            <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-publish'" onclick="MainManager.publishProblem()" style="width:90px; float:left "plain="true">问题下达</a>
            <div class="datagrid-btn-separator"></div>
            <%--<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-reload'" onclick="MainManager.openParamDialog()" style="width:110px;float:left "plain="true">审计问题切换</a>--%>
        </div>
        <div title="已下达问题" style="padding:2px;background-color:#E0ECFF;">
            <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-cancelPul'" onclick="MainManager.canclePublishProblem()" style="width:90px; float:left "plain="true">取消下达</a>
            <div class="datagrid-btn-separator"></div>
        </div>
        </div>
    </div>
    <div data-options="region:'center'" style="border:0px">
        <div id="toolbar" style="">
            <table style="width:100%">
            <tr>
            <td style="width:30px">单位</td><td style="width:170px"><div id="CompanyHelp"></div></td>
            <td style="width:30px">报表</td><td style="width:170px"><div id="ReportHelp"></div></td>
            <td style="width:55px">问题类型</td>
            <td style="width:170px"><input id="pType" type="text" class="easyui-combobox" data-options=" valueField:'Code', textField:'Name',url:urls.problemTypeUrl,panelHeight:'auto'" /></td>
            <td style=" float:right"><a class="easyui-linkbutton" onclick="MainManager.SearchManager.FreeSearch()" iconcls="icon-undo" style="">重置</a></td>
            <td style=" float:right"><a class="easyui-linkbutton" onclick="MainManager.SearchManager.DoSearch()" iconcls="icon-search" style=" margin-right:10px">查询</a></td>
            </tr>
            </table>
        </div>
        <table class="easyui-datagrid" id="problemList" data-options="singleSelect:false,method:'post',fit:true,fitColumns:true,sortName:'CreateTime',sortOrder:'ASC',pagination:true,toolbar:'#toolbar'">
            <thead>
                <tr>
                    <%--<th data-options="field:'CompanyCode',width:100">单位编号</th>
                    <th data-options="field:'CompanyName',width:150,align:'left'">单位名称</th>
                    <th data-options="field:'ReportCode',width:100">单位编号</th>
                    <th data-options="field:'ReportName',width:150,align:'left'">单位名称</th>--%>
                     <th data-options="field:'Id',checkbox:true,width:20">复选框</th>
                    <th data-options="field:'Title',width:150,align:'left'">问题标题</th>
                    <th data-options="field:'Content',width:190,align:'left'">问题内容</th>
                    <th data-options="field:'Type',width:100,align:'left'">问题类型</th>
                    <%--<th data-options="field:'State',width:100,align:'left'">问题状态</th>--%>
                    <th data-options="field:'CreaterName',width:100,align:'left'">创建者</th>
                    <th data-options="field:'CreateTime',width:100,align:'left'">创建时间</th>
                </tr>
            </thead>
        </table>
    </div>
    <div data-options="region:'south'"style = "height:30px;text-align:center;padding:5px">
        <a href="#"  id="taskBtn" onclick="MainManager.openParamDialog()">审计任务切换</a>&nbsp <span>审计类型:</span><span id="auditTaskTypeSpan"></span>&nbsp <span>审计任务:</span><span id="auditTaskSpan"></span>&nbsp <span>审计底稿:</span><span id="auditPaperSpan"></span>&nbsp <span>审计周期:</span><span id="auditDateSpan"></span>
    </div>
    <div id="paramHelpDialog"></div>
    <div id="paramDialog"></div>
</body>
</html>
