<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ExamReportManager.aspx.cs" Inherits="Audit.ct.ExportReport.ExamReportManager" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>报告审核</title>
   <script src="../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <script src="../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <link href="../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script src="../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <script src="../../Scripts/Ct_Controls.js" type="text/javascript"></script>
    <link href="../../Styles/Ct_Controls.css" rel="stylesheet" type="text/css" />
    <script src="../../Scripts/ct/pub/PubHelp.js" type="text/javascript"></script>
    <script type="text/javascript">
        var urls = {
            zqUrl: "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Get + "&MethodName=GetDictionaryListByClassType&FunctionName=" + BasicAction.Functions.DictionaryManager + "&ClassType=BBZQ",
            TemplateUrl: "../../handler/ExportReport.ashx?ActionType=" + ExportAction.ActionType.Grid + "&MethodName=" + ExportAction.Methods.TemplateMethod.GetReportTemplateDataGrid + "&FunctionName=" + ExportAction.Functions.ReportTemplate,
            ExamGridUrl: "../../handler/ExportReport.ashx?ActionType=" + ExportAction.ActionType.Grid + "&MethodName=" + ExportAction.Methods.ReportStateMethod.GetExamReportDataGrid + "&FunctionName=" + ExportAction.Functions.ReportTempalteInstanceState,
            CancleGridUrl: "../../handler/ExportReport.ashx?ActionType=" + ExportAction.ActionType.Grid + "&MethodName=" + ExportAction.Methods.ReportStateMethod.GetCancelExamReportDataGrid + "&FunctionName=" + ExportAction.Functions.ReportTempalteInstanceState,
            treeGridUrl: "../../handler/ExportReport.ashx?ActionType=" + ExportAction.ActionType.Grid + "&MethodName=" + ExportAction.Methods.CreatReportMethod.GetCompaniesByAuthority + "&FunctionName=" + ExportAction.Functions.CreateReport,
            functionUrl: "../../handler/ExportReport.ashx"
        };
        //报表state ：{01：未审核 ，02 审核通过，03审核不通过， 04：封存}
        var currentState = { TemplateType: "", HistoryReport: {} };
        $(function () {
            var height = document.body.clientHeight - 40;
            $("#center").tabs({
                fit: true,
                height: height,
                onSelect: ControlManager.TabManager.SelectedTab
            });
            currentState.CompanyHelp = $("#CompanyHelp").PopEdit();
            currentState.TemplateHelp = $("#ReportTemplate").PopEdit();
            currentState.CompanyHelp.btn.bind("click", function () {
                ControlManager.SearchManager.CompanyHelp_click("");
            });
            currentState.TemplateHelp.btn.bind("click", function () {
                ControlManager.SearchManager.TemplateHelp_click("");
            });
            currentState.CancleCompanyHelp = $("#CancleCompanyHelp").PopEdit();
            currentState.CancleTemplateHelp = $("#CancleReportTemplate").PopEdit();
            currentState.CancleCompanyHelp.btn.bind("click", function () {
                ControlManager.SearchManager.CompanyHelp_click('Cancle');
            });
            currentState.CancleTemplateHelp.btn.bind("click", function () {
                ControlManager.SearchManager.TemplateHelp_click('Cancle');
            });
        });
        var ControlManager = {
            //选中周期后加载单位信息
            SelectTemplateType: function (node) {
                currentState.TemplateType = node.Code;
                var parameter = { CycleType: node.Code };
                parameter = CreateParameter(ExportAction.ActionType.Post, ExportAction.Functions.CreateReport, ExportAction.Methods.CreatReportMethod.GetCreateTemplateData, parameter);
                DataManager.sendData(urls.functionUrl, parameter, resultManager.successLoadTemplateCycle, resultManager.fail);
            },
            TabManager: {
                SelectedTab: function (title, index) {
                    if (index == 0) {
                        if (!currentState.ExamGrid) {
                            ControlManager.ExamMmanager.LoadExamList();
                        } else {
                            currentState.ExamGrid.datagrid("reload");
                        }
                    } else if (index == 1) {
                        if (!currentState.CancleGrid) {
                            ControlManager.ExamMmanager.LoadCancleList();
                        } else {
                            currentState.CancleGrid.datagrid("reload");
                        }
                    } else if (index == 2) {
                        ControlManager.ExamMmanager.ReportExamHistory(currentState.HistoryReport);
                    }
                },
                addExamHistiryTab: function (param) {
                    var para = { Id: param };
                    if (param == "Exam") {
                        var selectedRow = currentState.ExamGrid.datagrid("getSelected");
                        if (selectedRow) {
                            para.Id = selectedRow.Id;
                        } else {
                            MessageManager.ErrorMessage("请选择要编辑的报告！");
                            return;
                        }
                    } else if (param == "CancleExam") {
                        var row = currentState.CancleGrid.datagrid("getSelected");
                        if (row) {
                            para.Id = row.Id;
                        } else {
                            MessageManager.ErrorMessage("请选择要编辑的报告！");
                            return;
                        }
                    }
                    currentState.HistoryReport = para;
                    var title = '报告审批历史';
                    if ($('#center').tabs('exists', title)) {
                        $('#center').tabs('select', title);
                    } else {
                        $('#center').tabs('add', {
                            title: title,
                            content: '<table style ="width:100%;height:100%"><tr><td><table id="HistoryGrid" style="margin:1px"></table></td></tr></table>',
                            closable: true
                        });
                    }
                },
                getInViewTab: function () {
                    var tab = $("#center").tabs("getSelected");
                    var index = $('#center').tabs('getTabIndex', tab);
                    if (index == 0) {
                        return "";
                    } else if (index == 1) {
                        return "Cancle";
                    } else {
                        return "History";
                    }
                }
            },
            CycleFormatter: function (value, row, index) {
                var cycle = value;
                switch (row.CycleType) {
                    case "01":
                        cycle = cycle + "年";
                        break;
                    case "02":
                        cycle = cycle + "月";
                        break;
                    case "03":
                        cycle = cycle + "季度";
                        break;
                    case "04":
                        cycle = cycle + "日";
                        break;
                }
                return cycle;
            },
            ExamMmanager: {
                LoadExamList: function () {
                    currentState.ExamGrid = $("#ExamGrid").datagrid({
                        url: urls.ExamGridUrl, //换成要审批的列表
                        fit: true,
                        nowrap: true,
                        pagination: true,
                        rownumbers: true,
                        fitColumns: true,
                        frozenColumns: true,
                        singleSelect: true,
                        sortOrder: 'desc',
                        toolbar: "#toolbar",
                        sortName: 'CreateTime',
                        columns: [[
			                { field: 'Id', checkbox: true },
			                { field: 'CompanyCode', title: '单位编号', width: 120, sortable: true },
			                { field: 'CompanyName', title: '单位名称', width: 190, sortable: true },
                            { field: 'TemplateCode', title: '模板编号', width: 120, sortable: true },
                            { field: 'TemplateName', title: '模板名称', width: 160, sortable: true },
			                { field: 'Year', title: '年度 ', width: 100, sortable: true },
			                { field: 'Cycle', title: '周期', width: 100, sortable: true, formatter: ControlManager.CycleFormatter },
			                { field: 'InstanceAddress', title: '审核报告', width: 80, align: 'center', formatter: function (value, row, index) {
			                    return '<img src="../../lib/easyUI/themes/icons/Exam.ico" onclick="ControlManager.ExamMmanager.OpenDialog(this.id)" id="' + row.Id + '"  style="cursor:pointer"/>';
			                }
			                },
                            { field: 'TemplateInstanceId', title: '审核历史', width: 80, align: 'center', formatter: function (value, row, index) {
                                return '<img src="../../lib/easyUI/themes/icons/History.png" onclick="ControlManager.TabManager.addExamHistiryTab(this.id)" id="' + row.Id + '" style="cursor:pointer"/>';
                            }
                            }
                        ]],
                        onDblClickRow: function (rowIndex, rowData) { ControlManager.TabManager.addExamHistiryTab(rowData.Id); }
                    });
                },
                LoadCancleList: function () {
                    currentState.CancleGrid = $("#CancleGrid").datagrid({
                        url: urls.CancleGridUrl, //换成要取消的列表
                        fit: true,
                        nowrap: true,
                        pagination: true,
                        rownumbers: true,
                        fitColumns: true,
                        frozenColumns: true,
                        singleSelect: true,
                        sortOrder: 'desc',
                        toolbar: "#CancleToolbar",
                        sortName: 'CreateTime',
                        columns: [[
			                { field: 'Id', checkbox: true },
			                { field: 'CompanyCode', title: '单位编号', width: 120, sortable: true },
			                { field: 'CompanyName', title: '单位名称', width: 190, sortable: true },
                            { field: 'TemplateCode', title: '模板编号', width: 120, sortable: true },
                            { field: 'TemplateName', title: '模板名称', width: 160, sortable: true },
			                { field: 'Year', title: '年度 ', width: 100, sortable: true },
			                { field: 'Cycle', title: '周期', width: 100, sortable: true, formatter: ControlManager.CycleFormatter },
			                { field: 'InstanceAddress', title: '取消审核', width: 80, align: 'center', formatter: function (value, row, index) {
			                    return '<img src="../../lib/easyUI/themes/icons/CancleExam.png" onclick="ControlManager.ExamMmanager.CancelExamReportState(this.id)" id="' + row.Id + '"  style="cursor:pointer"/>';
			                }
			                },
                            { field: 'TemplateInstanceId', title: '审核历史', width: 80, align: 'center', formatter: function (value, row, index) {
                                return '<img src="../../lib/easyUI/themes/icons/History.png" onclick="ControlManager.TabManager.addExamHistiryTab(this.id)" id="' + row.Id + '" style="cursor:pointer"/>';
                            }
                            }
                        ]],
                        onDblClickRow: function (rowIndex, rowData) { ControlManager.TabManager.addExamHistiryTab(rowData.Id); }
                    });
                },
                LoadReportHistoryGrid: function (url) {
                    currentState.HistoryGrid = $("#HistoryGrid").datagrid({
                        url: url,
                        fit: true,
                        pagination: true,
                        rownumbers: true,
                        fitColumns: true,
                        frozenColumns: true,
                        singleSelect: true,
                        sortOrder: 'desc',
                        toolbar: "#CancleToolbar",
                        sortName: 'CreateTime',
                        columns: [[
			                {field: 'UserName', title: '审核人', width: 120, sortable: true },
			                { field: 'CreateTime', title: '审核时间', width: 190, sortable: true },
                            { field: 'Content', title: '审核内容', width: 160, sortable: true },
			                { field: 'State', title: '审核状态', width: 100, sortable: true },
			                { field: 'Type', title: '审核操作 ', width: 100, sortable: true }
                            ]]
                    });

                },
                ReportExamHistory: function (param) {
                    var url = CreateUrl(urls.functionUrl, ExportAction.ActionType.Grid, ExportAction.Functions.ReportTempalteInstanceState, ExportAction.Methods.ReportStateMethod.GetExamReportHistory, param);
                    ControlManager.ExamMmanager.LoadReportHistoryGrid(url);
                },
                OpenDialog: function (id) {
                    if (!id) {
                        var rows = currentState.ExamGrid.datagrid("getSelections");
                        if (rows.length == 0) {
                            MessageManager.ErrorMessage("请选择要编辑的报告！");
                            return;
                        }
                        id = rows[0].Id;
                    }
                    $("#dialog").css("display", "block");
                    $('#dialog').dialog({
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
                                ControlManager.ExamMmanager.ExamReportState(suggest, result, id);
                            }
                        },
                   { text: "关闭",
                       iconCls: 'icon-cut', handler: function () {
                           $('#dialog').dialog("close");
                       }
                   }]
                    });
                    $("#suggest").text('');
                },
                ExamReportState: function (discription, stageResult, id) {
                    var para = { Ids: "", Content: discription, TemplateInstanceId: id };
                    if (stageResult == "P") {
                        para = CreateParameter(ExportAction.ActionType.Grid, ExportAction.Functions.ReportTempalteInstanceState, ExportAction.Methods.ReportStateMethod.ExamReportPass, para);
                    } else {
                        para = CreateParameter(ExportAction.ActionType.Grid, ExportAction.Functions.ReportTempalteInstanceState, ExportAction.Methods.ReportStateMethod.ExamReportFail, para);
                    }
                    DataManager.sendData(urls.functionUrl, para, resultManager.ExamSuccess, resultManager.Fail);
                },
                CancelExamReportState: function (id) {
                    var para = { TemplateInstanceId: id };
                    if (!id) {
                        var row = currentState.CancleGrid.datagrid("getSelected");
                        if (row) {
                            para.TemplateInstanceId = row.Id;
                        } else {
                            MessageManager.ErrorMessage("请选择要编辑的报告！");
                            return;
                        }
                    }
                    para = CreateParameter(ExportAction.ActionType.Grid, ExportAction.Functions.ReportTempalteInstanceState, ExportAction.Methods.ReportStateMethod.CancelExamReport, para);
                    DataManager.sendData(urls.functionUrl, para, resultManager.CanceExamReport_Success, resultManager.Fail);
                }

            },
            SearchManager: {
                CompanyHelp_click: function (type) {
                    var treeParas = { idField: "", treeField: "", columns: [], url: "" };
                    treeParas.url = urls.treeGridUrl;
                    treeParas.idField = "Id";
                    treeParas.treeField = "Code";
                    treeParas.columns = [[
            { title: 'id', field: 'Id', width: 180, hidden: true },
            { title: '组织机构编号', field: 'Code', width: 180 },
            { title: '组织机构名称', field: 'Name', width: 210 }
                    ]];
                    treeParas.singleSelect = true;
                    treeParas.sortName = 'Code';
                    treeParas.sortOrder = 'ASC';
                    treeParas.dataUrl = "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Grid + "&MethodName=" + BasicAction.Methods.CompanyManagerMethods.CompanyDataGrid + "&FunctionName=" + BasicAction.Functions.CompanyManager;
                    treeParas.UseTo = "search";
                    treeParas.width = 450;
                    treeParas.height = 450;
                    pubHelp.setParameters(treeParas);
                    pubHelp.OpenDialogWithHref("HelpDialog", "单位选择", "../pub/HelpTreeDialog.aspx", ControlManager.SearchManager.CompanyHelp_save, treeParas.width, treeParas.height, true);
                },
                CompanyHelp_save: function () {
                    var result = pubHelp.getResultObj();
                    if (result) {
                        var Tab = ControlManager.TabManager.getInViewTab();
                        if (result.length > 0) {
                            currentState[Tab + "CompanyHelp"].name.val(result[0].Name);
                            ControlManager.SearchManager.doSearch(Tab);
                        }
                    }
                },
                TemplateHelp_click: function (type) {
                    var paras = { url: "", columns: [], sortName: "", sortOrder: "", NameField: "Name", CodeField: "Code", defaultField: { dftBy: "Name", dft: ""} };
                    paras.url = urls.TemplateUrl;
                    paras.columns = [[
            { title: 'id', field: 'Id', width: 180, hidden: true },
			   { field: 'Code', title: '编号', width: 150, sortable: true },
               { field: 'Name', title: '名称', width: 190, sortable: true }
                    ]];
                    paras.sortName = 'CreateTime';
                    parassortOrder = 'desc';
                    paras.defaultField.dft = currentState.TemplateHelp.name.val();
                    paras.width = 450;
                    paras.height = 450;
                    pubHelp.setParameters(paras);
                    pubHelp.OpenDialogWithHref("HelpDialog", "报告模板选择", "../pub/HelpDialogEasyUi.htm", ControlManager.SearchManager.TemplateHelp_Save, paras.width, paras.height, true);
                    //var result = window.showModalDialog("../pub/HelpDialog.aspx", paras, "dialogHeight:450px;dialogWidth:400px");

                },
                TemplateHelp_Save: function () {
                    var result = pubHelp.getResultObj();
                    if (result) {
                        var Tab = ControlManager.TabManager.getInViewTab();
                        //currentState[Tab + "TemplateHelp"].value.val(result.Code);
                        currentState[Tab + "TemplateHelp"].name.val(result.Name);
                        ControlManager.SearchManager.doSearch(Tab);
                    }
                },
                doSearch: function (type) {
                    var para = { CompanyName: "", Year: "", CycleType: "", Cycle: "", TemplateName: "" };
                    para.CompanyName = currentState[type + "CompanyHelp"].name.val();
                    para.TemplateName = currentState[type + "TemplateHelp"].name.val();
                    para.CycleType = $("#" + type + "CycleType").combobox("getValue");
                    para.Year = $("#" + type + "Year").combobox("getValue");
                    para.Cycle = $("#" + type + "Cycle").combobox("getValue");
                    if (type == "Cancle") {
                        $('#CancleGrid').datagrid('reload', para);
                    } else {
                        $('#ExamGrid').datagrid('reload', para);
                    }
                },
                //type :""|Cancle 区分从属的toolbar
                freeSearch: function (type) {
                    $("#" + type + "CycleType").combobox("setValue", "");
                    $("#" + type + "Year").combobox("setValue", "");
                    $("#" + type + "Year").combobox("loadData", []);
                    $("#" + type + "Cycle").combobox("setValue", "");
                    $("#" + type + "Cycle").combobox("loadData", []);
                    currentState[type + "CompanyHelp"].name.val("");
                    currentState[type + "TemplateHelp"].name.val("");
                    if (type == "Cancle") {
                        $('#CancleGrid').datagrid('reload', {});
                    } else {
                        $('#ExamGrid').datagrid('reload', {});
                    }
                }
            }
        }
        var resultManager = {
            ExamSuccess: function (data) {
                if (data.success) {
                    MessageManager.InfoMessage(data.sMeg);
                    $('#dialog').dialog("close");
                    currentState.ExamGrid.datagrid("reload");
                } else {
                    MessageManager.ErrorMessage(data.sMeg);
                }
            },
            CanceExamReport_Success: function (data) {
                if (data.success) {
                    MessageManager.InfoMessage(data.sMeg);
                    currentState.CancleGrid.datagrid("reload");
                } else {
                    MessageManager.ErrorMessage(data.sMeg);
                }
            },
            successLoadTemplateCycle: function (data) {
                if (data.success) {
                    var tab = "#" + ControlManager.TabManager.getInViewTab();
                    $(tab + "Year").combobox("loadData", data.obj.reportCycleStruct.Nds);
                    $(tab + "Year").combobox("setValue", data.obj.reportCycleStruct.CurrentNd);
                    $(tab + "Cycle").combobox("loadData", data.obj.reportCycleStruct.Cycles);
                    $(tab + "Cycle").combobox("setValue", data.obj.reportCycleStruct.CurrentZq);
                } else {
                    MessageManager.ErrorMessage(data.sMeg);
                }
            },
            fail: function (data) {
                MessageManager.ErrorMessage(data.toString());
            }
        }
    </script>   
</head>
<body>
<div  id="center">
    <div title="审核">
        <div style="overflow:hidden" class ="easyui-layout" data-options="fit:true">
            <div data-options="region:'north',collapsible:false" style=" margin-top:1px; height:32px; padding:2px;background-color:#E0ECFF ;overflow:hidden">
            <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-Exam',iconAlign:'left'" onclick="ControlManager. ExamMmanager.OpenDialog()" style="width:90px; "plain="true">审核报告</a>
            <%--<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-History',iconAlign:'left'" onclick="ControlManager.addExamHistiryTab('Exam')" style="width:110px; margin-left:10px ; "plain="true">报告审核历史</a>--%>
            </div>
            <div data-options="region:'center'" style=" border:0px">
                <div id="toolbar" class="datagrid-toolbar" style="display:none;min-width:900px">
                    <table style="padding:0px;width:100%" cellspacing="5px">
                        <tr>
                            <td style=" width:60px">周期类型</td>
                            <td style=" width:170px"><input id="CycleType" type="text"  class="easyui-combobox" data-options="url:urls.zqUrl,valueField:'Code',textField:'Name',panelHeight:'auto',onSelect:ControlManager.SelectTemplateType" /></td>
                            <td style=" width:30px">年度</td>
                            <td style=" width:170px"><input id="Year"  class="easyui-combobox" data-options="valueField:'value',textField:'name',panelHeight:'auto'" /></td> 
                            <td style=" width:30px">周期</td>
                            <td style=" width:170px"><input id="Cycle"  class="easyui-combobox" data-options="valueField:'value',textField:'name',panelHeight:'auto'"  /></td>
                            <td style=" width:30px">单位</td>
                            <td ><div id="CompanyHelp"></div></td>
                        </tr>
                    </table>
                    <div style=" width:100%; height:30px">
                        <div style=" width:68px;float:left; margin-left:5px">模板</div><div id="ReportTemplate" style=" display:inline"></div>
                        <a class="easyui-linkbutton" onclick="ControlManager.SearchManager.freeSearch('')" iconcls="icon-undo" style=" margin-right:5px;margin-left:10px;float:right">重置</a>
                        <a class="easyui-linkbutton" onclick="ControlManager.SearchManager.doSearch('')" iconcls="icon-search" style=" float:right">查询</a>
                    </div>
                </div>
                <table id="ExamGrid"></table>
            </div>            
        </div>
    </div>
    <div title="取消审核">
        <div style="overflow:hidden" class ="easyui-layout" data-options="fit:true">
            <div data-options="region:'north',collapsible:false" style=" margin-top:1px; height:32px; padding:2px;background-color:#E0ECFF ;overflow:hidden">
            <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-CancleExam',iconAlign:'left'" onclick="ControlManager.ExamMmanager.CancelExamReportState()" style="width:90px;"plain="true">取消审核</a>
            <%--<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-History',iconAlign:'left'" onclick="ControlManager.addExamHistiryTab('CancleExam')" style="width:110px; "plain="true">报告审核历史</a>--%>
            </div>
            <div data-options="region:'center'" style=" border:0px">
                <div id="CancleToolbar" class="datagrid-toolbar" style="display:none;min-width:900px">
                    <table style="padding:0px; width:100%" cellspacing="5px">
                        <tr>
                            <td style=" width:60px">周期类型</td>
                            <td style=" width:170px"><input id="CancleCycleType" type="text"  class="easyui-combobox" data-options="url:urls.zqUrl,valueField:'Code',textField:'Name',panelHeight:'auto',onSelect:ControlManager.SelectTemplateType" /></td>
                            <td style=" width:30px">年度</td>
                            <td style=" width:170px"><input id="CancleYear"  class="easyui-combobox" data-options="valueField:'value',textField:'name',panelHeight:'auto'" /></td> 
                            <td style=" width:30px">周期</td>
                            <td style=" width:170px"><input id="CancleCycle"  class="easyui-combobox" data-options="valueField:'value',textField:'name',panelHeight:'auto'" /></td>
                            <td style=" width:30px">单位</td>
                            <td  ><div id="CancleCompanyHelp"></div></td>
                        </tr>
                    </table>
                    <div style=" width:100%; height:30px">
                        <div style=" width:68px;float:left; margin-left:5px">模板</div><div id="CancleReportTemplate" style=" display:inline"></div>
                        <a class="easyui-linkbutton" onclick="ControlManager.SearchManager.freeSearch('Cancle')" iconcls="icon-undo" style=" margin-right:5px;margin-left:10px;float:right">重置</a>
                        <a class="easyui-linkbutton" onclick="ControlManager.SearchManager.doSearch('Cancle')" iconcls="icon-search" style=" float:right">查询</a>
                    </div>
                </div>
                <table id="CancleGrid"></table>
            </div>
        </div>    
    </div>
</div>
<div id="dialog" style="display:none">
    <table style="width:100%; height:90%;font-size:13px; padding-top:15px; padding-left:15px"  > 
        <tr><td>是否通过</td><td><select class="easyui-combobox" id="result" style="width:261px; height:30px"data-options="panelHeight:'auto'"><option value="P">是</option>
            <option value="F">否</option>
            </select> </td></tr>
        <tr><td>审核意见</td><td><textarea id="suggest" cols="30" rows="8" style=" overflow:auto; border: 1px solid #c4DADF" ></textarea></td></tr>
    </table>
</div>
<div id="HelpDialog"></div>
</body>
</html>
