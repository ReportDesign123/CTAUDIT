<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReportDownloadManager.aspx.cs" Inherits="Audit.ct.ExportReport.ReportDownloadManager" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>报告下载</title>
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
            zqUrl :"../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Get + "&MethodName=GetDictionaryListByClassType&FunctionName=" + BasicAction.Functions.DictionaryManager + "&ClassType=BBZQ",
            TemplateUrl: "../../handler/ExportReport.ashx?ActionType=" + ExportAction.ActionType.Grid + "&MethodName=" + ExportAction.Methods.TemplateMethod.GetReportTemplateDataGrid + "&FunctionName=" + ExportAction.Functions.ReportTemplate,
            dataGridUrl: "../../handler/ExportReport.ashx?ActionType=" + ExportAction.ActionType.Grid + "&MethodName=" + ExportAction.Methods.CreatReportMethod.GetTemplateLogList + "&FunctionName=" + ExportAction.Functions.CreateReport,
            downLoadUrl: "../../handler/ExportReport.ashx?ActionType=" + ExportAction.ActionType.Get + "&MethodName=" + ExportAction.Methods.CreatReportMethod.DownloadReport + "&FunctionName=" + ExportAction.Functions.CreateReport,
            uploadUrl: "../../handler/ExportReport.ashx?ActionType=" + ExportAction.ActionType.Get + "&MethodName=" + ExportAction.Methods.CreatReportMethod.UploadReport + "&FunctionName=" + ExportAction.Functions.CreateReport,
            treeGridUrl: "../../handler/ExportReport.ashx?ActionType=" + ExportAction.ActionType.Grid + "&MethodName=" + ExportAction.Methods.CreatReportMethod.GetCompaniesByAuthority + "&FunctionName=" + ExportAction.Functions.CreateReport,
            functionUrl: "../../handler/ExportReport.ashx"
        };
        var currentState = { TemplateType: "", inEditTemplate: {} };
        $(function () {
            currentState.CompanyHelp = $("#CompanyHelp").PopEdit();
            currentState.TemplateHelp = $("#ReportTemplate").PopEdit();
            currentState.CompanyHelp.btn.bind("click", function () {
                ControlManager.SearchManager.CompanyHelp_click();
            });
            currentState.TemplateHelp.btn.bind("click", function () {
                ControlManager.SearchManager.TemplateHelp_click();
            });
            currentState.reportGrid = $("#reportGrid").datagrid({
                url: urls.dataGridUrl,
                fit: true,
                nowrap: true,
                border: false,
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
			    { field: 'InstanceAddress', title: '下载报告', width: 80, align: 'center', formatter: function (value, row, index) {
			        return '<img src="../../lib/easyUI/themes/icons/downLoad.ico" onclick="ControlManager.DownLoadReport(this.id)" title="下载报告" id="' + index + '"  style="cursor:pointer"/>';
			    }
			    },
//                { field: 'type', title: '下载格式', width: 60, align: 'center',
//                     formatter: function (value, row) {
//                            if (row == "1") {
//                                return "WORD";
//                            } else {
//                                return "PDF";
//                            }
//                        },
//                        editor: { type: 'checkbox', options: { on: "1", off: "0"}
//                }
//                },
			    { field: 'down', title: '上传报告', width: 80, align: 'center', formatter: function (value, row, index) {
			        return '<img src="../../lib/easyUI/themes/icons/Upload.png" onclick="ControlManager.uploadDialogOpen(this.id)"  title="上传报告" id="' + index + '"  style="cursor:pointer"/>';
			    }
			    }
                    ]]
            });
        });
        var ControlManager = {
            //选中周期后加载单位信息
            SelectTemplateType: function (node) {
                if (!node) {
                    node = { Code: "" };
                }
                currentState.TemplateType = node.Code;
                var parameter = { CycleType: node.Code };
                parameter = CreateParameter(ExportAction.ActionType.Post, ExportAction.Functions.CreateReport, ExportAction.Methods.CreatReportMethod.GetCreateTemplateData, parameter);
                DataManager.sendData(urls.functionUrl, parameter, resultManager.successLoadTemplateCycle, resultManager.fail);
            },
            //格式化周期
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
            //报告下载
            DownLoadReport: function (index) {
                var para = {};
                if (index != undefined) {
                    var rows = $("#reportGrid").datagrid("getRows");
                    para = rows[index];
                } else {
                    var rows = $("#reportGrid").datagrid("getSelections");
                    if (rows.length == 1) {
                        para = rows[0];
                    } else if (rows.length == 0) {
                        MessageManager.ErrorMessage("请选择模板");
                        return;
                    } else {
                        MessageManager.ErrorMessage("同一时间只能编辑一条记录");
                        return;
                    }
                }
                window.location = urls.downLoadUrl + "&InstanceAddress=" + para.InstanceAddress + "&AttatchName=" + para.AttatchName;
            },
            uploadDialogOpen: function (index) {
                var rows = currentState.reportGrid.datagrid("getRows");
                var paras = rows[index];
                if (paras.State == "报告封存") {
                    $.messager.alert("系统提示", "报告已封存，请解除封存后再上传！", 'warning');
                    return;
                }
                currentState.inEditTemplate = paras;
                $("#upFrame").attr("src", "TemplateUpload.htm");
                $("#uploadDialog").dialog({
                    buttons: [{
                        text: '保存',
                        iconCls: "icon-ok",
                        handler: function () {
                            var upfram = window.frames["upFrame"];
                            upfram.upload();
                            $('#uploadDialog').dialog("close");
                            currentState.reportGrid.datagrid("reload", {});
                        }
                    },
                    {
                        text: '取消',
                        iconCls: "icon-cancel",
                        handler: function () {
                            $('#uploadDialog').dialog("close");
                        }
                    }
                    ]
                });
                $("#uploadDialog").dialog("open");
            },
            SearchManager: {
                CompanyHelp_click: function () {
                    var treeParas = { idField: "", treeField: "", columns: [], url: "" };
                    treeParas.url = urls.treeGridUrl;
                    treeParas.idField = "Id";
                    treeParas.treeField = "Code";
                    treeParas.columns = [[
            { title: 'id', field: 'Id', width: 180, hidden: true },
            { title: '组织机构编号', field: 'Code', width: 120 },
            { title: '组织机构名称', field: 'Name', width: 160 }
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
                        if (result.length > 0) {
                            currentState.CompanyHelp.name.val(result[0].Name);
                            ControlManager.SearchManager.doSearch();
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
                    paras.sortName = 'Code';
                    paras.sortOrder = 'ASC';
                    paras.defaultField.dft = currentState.TemplateHelp.name.val();
                    paras.width = 450;
                    paras.height = 450;
                    pubHelp.setParameters(paras);
                    pubHelp.OpenDialogWithHref("HelpDialog", "报告模板选择", "../pub/HelpDialogEasyUi.htm", ControlManager.SearchManager.TemplateHelp_Save, paras.width, paras.height, true);
                },
                TemplateHelp_Save: function () {
                    var result = pubHelp.getResultObj();
                    if (result) {
                        currentState["TemplateHelp"].name.val(result.Name);
                        ControlManager.SearchManager.doSearch();
                    }
                },
                doSearch: function () {
                    var para = { CompanyName: "", Year: "", CycleType: "", Cycle: "", TemplateName: "" };
                    para.CompanyName = currentState.CompanyHelp.name.val();
                    para.TemplateName = currentState.TemplateHelp.name.val();
                    para.CycleType = $("#CycleType").combobox("getValue");
                    para.Year = $("#Year").combobox("getValue");
                    para.Cycle = $("#Cycle").combobox("getValue");
                    $('#reportGrid').datagrid('reload', para);
                },
                freeSearch: function () {
                    $("#CycleType").combobox("setValue", "");
                    $("#Year").combobox("setValue", "");
                    $("#Year").combobox("loadData", []);
                    $("#Cycle").combobox("setValue", "");
                    $("#Cycle").combobox("loadData", []);
                    currentState.CompanyHelp.value.val("");
                    currentState.CompanyHelp.name.val("");
                    currentState.TemplateHelp.name.val("");
                    $('#reportGrid').datagrid('reload', {});
                }
            }
        }
        var resultManager = {
            successLoadTemplateCycle: function (data) {
                if (data.success) {
                    $("#Year").combobox("loadData", data.obj.reportCycleStruct.Nds);
                    $("#Year").combobox("setValue", data.obj.reportCycleStruct.CurrentNd);
                    $("#Cycle").combobox("loadData", data.obj.reportCycleStruct.Cycles);
                    $("#Cycle").combobox("setValue", data.obj.reportCycleStruct.CurrentZq);
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
<body  class="easyui-layout">
    <div data-options="region:'north',collapsible:false" style="height:32px;  padding:2px;background-color:#E0ECFF ;overflow:hidden">
        <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-downLoad',iconAlign:'left'" onclick="ControlManager.DownLoadReport()" style="width:90px; float:left "plain="true">下载报告</a>
        <div class="datagrid-btn-separator"></div>
        <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-Upload',iconAlign:'left'" onclick="ControlManager.UpLoadReport()" style="width:90px; float:left "plain="true">上传报告</a>
        <div class="datagrid-btn-separator"></div>
    </div>
    <div data-options="region:'center'" style=" ">
        <div id="toolbar" class="datagrid-toolbar" style="display:none;min-width:900px">
            <table style="padding:0px;width:100%">
                <tr>
                    <td style=" width:60px">周期类型</td>
                    <td style=" width:170px"><input id="CycleType" type="text"  class="easyui-combobox" data-options="url:urls.zqUrl,valueField:'Code',textField:'Name',panelHeight:'auto',onSelect:ControlManager.SelectTemplateType" /></td>
                    <td style=" width:30px">年度</td>
                    <td style=" width:170px"><input id="Year"  class="easyui-combobox" data-options="valueField:'value',textField:'name',panelHeight:'auto'" /></td> 
                    <td style=" width:30px">周期</td>
                    <td style=" width:170px"><input id="Cycle"  class="easyui-combobox" data-options="valueField:'value',textField:'name',panelHeight:'auto'"  /></td>
                    <td style=" width:30px">单位</td>
                    <td><div id="CompanyHelp"></div></td>
                </tr>
                <tr>
                <td>模板</td><td id="ReportTemplate"></td>
                <td style=" text-align:right" colspan="6">
                    <a class="easyui-linkbutton" onclick="ControlManager.SearchManager.doSearch()" iconcls="icon-search" style=" margin-right:10px;">查询</a>
                    <a class="easyui-linkbutton" onclick="ControlManager.SearchManager.freeSearch()" iconcls="icon-undo" style="">重置</a>
                </td>
                </tr>
            </table>
        </div>
        <table id="reportGrid"></table>
    </div>
    <div id="uploadDialog" class="easyui-dialog" data-options="
            title:'报告上传',
            width: 330,
                height: 240,
                closed: true,
                cache: false,
                modal: true
    ">
        <iframe id="upFrame"  frameborder="0" width="100%" height="150px" ></iframe>
    </div>
<div id="HelpDialog"></div>
</body>
</html>
