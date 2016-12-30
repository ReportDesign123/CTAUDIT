<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CreateReport.aspx.cs" Inherits="Audit.ct.ExportReport.CreateReport" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>生成报告</title>
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
            zqUrl :"../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Get + "&MethodName=GetDictionaryListByClassType&FunctionName=" + BasicAction.Functions.DictionaryManager + "&ClassType=BBZQ",
            treeGridUrl: "../../handler/ExportReport.ashx?ActionType=" + ExportAction.ActionType.Grid + "&MethodName=" + ExportAction.Methods.CreatReportMethod.GetCompaniesByAuthority + "&FunctionName=" + ExportAction.Functions.CreateReport,
            functionUrl: "../../handler/ExportReport.ashx"
        };
        var currentState = { TemplateType: "" };
        var ReportCreatObj = { };
        var IsCreating = false;

        $(function () {
            //声明 单位树
            currentState.CompanyTree = $("#companyTree").treegrid({
                url: urls.treeGridUrl,
                title: "",
                fit: true,
                fitColumns: true,
                idField: "Id",
                treeField: "Code",
                columns: [[
         { title: 'id', field: 'Id', width: 180, hidden: true },
        { title: '组织机构编号', field: 'Code', width: 180 },
        { title: '组织机构名称', field: 'Name', width: 210 }
                    ]],
                onSelect: ControlManager.SelectCompany
            });

            //声明 模板列表
            currentState.TemplateGrid = $('#TemplateGrid').datagrid({
                pagePosition: 'bottom',
                sortName: 'CreateTime',
                sortOrder: 'desc',
                idField: 'Id',
                //toolbar: toolBar,
                fit: true,
                nowrap: true,
                border: false,
                pagination: true,
                rownumbers: true,
                fitColumns: true,
                frozenColumns: true,
                singleSelect: false,
                columns: [[
			    { field: 'Id', checkbox: true },
			   { field: 'Code', title: '模板编号', width: 120, sortable: true },
               { field: 'Name', title: '模板名称', width: 160, sortable: true }
               ]],
                onLoadSuccess: ControlManager.OnLoadTempGrid,
                onSelect: ControlManager.SelectTemplate,
                onUnselect: ControlManager.UnSelectTemplate
            });
        });
        var ControlManager = {
            //选中周期后加载单位信息
            SelectTemplateType: function (node) {
                currentState.TemplateType = node.Code;
                var parameter = { CycleType: node.Code };
                parameter = CreateParameter(ExportAction.ActionType.Post, ExportAction.Functions.CreateReport, ExportAction.Methods.CreatReportMethod.GetCreateTemplateData, parameter);
                DataManager.sendData(urls.functionUrl, parameter, resultManager.successLoadCreatData, resultManager.fail);
            },
            //选中单位后加载模板信息
            SelectCompany: function (node) {
                var parameter = { CompanyId: node.Id };
                parameter = CreateParameter(ExportAction.ActionType.Post, ExportAction.Functions.CreateReport, ExportAction.Methods.CreatReportMethod.GetReportTemplatesByCompanyId, parameter);
                DataManager.sendData(urls.functionUrl, parameter, resultManager.successLoadTemplate, resultManager.fail);
            },
            setTemplateType: function () {
                $("#TemplateCycle").combobox("select", "02");
            },
            //添加选择的模板
            SelectTemplate: function (index, row) {
                if (!IsCreating) {
                    var template = { Id: row.Id };
                    var company = currentState.CompanyTree.treegrid("getSelected");
                    if (!ReportCreatObj[company.Id]) ReportCreatObj[company.Id] = [];
                    ReportCreatObj[company.Id].push(template);
                }
            },
            //删除不再勾选的模板
            UnSelectTemplate: function (index, row) {
                if (!IsCreating) {
                    var company = currentState.CompanyTree.treegrid("getSelected");
                    if (ReportCreatObj[company.Id]) {
                        $.each(ReportCreatObj[company.Id], function (code, template) {
                            if (row.Id == template.Id) {
                                ReportCreatObj[company.Id].remove(code);
                                return false;
                            }
                        });
                    }
                }
            },
            //初始选中已经勾选的模板
            OnLoadTempGrid: function (data) {
                IsCreating = true;
                var company = currentState.CompanyTree.treegrid("getSelected");
                currentState.TemplateGrid.datagrid("unselectAll");
                if (data.rows.length > 0 && ReportCreatObj[company.Id] && ReportCreatObj[company.Id].length > 0) {
                    for (var i = 0; i < ReportCreatObj[company.Id].length; ++i) {
                        $.each(data.rows, function (index, node) {
                            if (node.Id == ReportCreatObj[company.Id][i].Id) {
                                currentState.TemplateGrid.datagrid("selectRow", index);
                                return false;
                            }
                        });
                    }
                }
                IsCreating = false;
            },
            CreatReport: function () {
                var CreateTemplateReportStruct = { templateLog: {}, templates: {} };
                var templateLog = {};
                templateLog.CycleType = $("#TemplateCycle").combobox("getValue");
                templateLog.Year = $("#Year").combobox("getValue");
                templateLog.Cycle = $("#Cycle").combobox("getValue");
                CreateTemplateReportStruct.templateLog = templateLog;
                CreateTemplateReportStruct.templates = ReportCreatObj;
                var isNull = true;
                for (var p in ReportCreatObj) { // 方法 
                    isNull = false;
                    break;
                }
                if (isNull) {
                    alert("请选择模板");
                    return;
                }
                var parameter = { dataStr: "" };
                parameter.dataStr = JSON2.stringify(CreateTemplateReportStruct);
                parameter = CreateParameter(ExportAction.ActionType.Post, ExportAction.Functions.CreateReport, ExportAction.Methods.CreatReportMethod.CreateReport, parameter);
                DataManager.sendData(urls.functionUrl, parameter, resultManager.successSave, resultManager.fail);
            }
        };
        var resultManager = {
            successLoadCreatData: function (data) {
                if (data.success) {
                    $("#Year").combobox("loadData", data.obj.reportCycleStruct.Nds);
                    $("#Year").combobox("setValue", data.obj.reportCycleStruct.CurrentNd);
                    $("#Cycle").combobox("loadData", data.obj.reportCycleStruct.Cycles);
                    $("#Cycle").combobox("setValue", data.obj.reportCycleStruct.CurrentZq);
                } else {
                    MessageManager.ErrorMessage(data.sMeg);
                }
            },
            successLoadTemplate: function (data) {
                if (data.success) {
                    currentState.TemplateGrid.datagrid("loadData", data.obj);
                } else {
                    MessageManager.ErrorMessage(data.sMeg);
                }
            },
            successSave: function (data) {
                if (data.success) {
                    ReportCreatObj = {};
                    $.messager.alert('提示', "创建成功！", 'info');
//                    currentState.CompanyTree.treegrid("unselectAll");
                    currentState.TemplateGrid.datagrid("unselectAll");
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
<body class="easyui-layout" style=" border:0px">
    <div data-options="region:'north'" style="  height:45px;background-color:#E0ECFF ;border-bottom:1px solid #95B8E7; padding:5px; overflow:hidden">
     <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="ControlManager.CreatReport() " style="width:140px; height:26px;padding-top:3px;"plain="false"><span style="font-size:12px;">&nbsp;形&nbsp;成&nbsp;报&nbsp;告</span></a>
    </div>
    <div data-options="region:'west',split:true" style="width:500px; border:0px;">
        <div class="easyui-layout" data-options="fit:true" style="border:0px;">
            <div style="height:160px;border:null;" data-options="region:'north'">
                <table cellspacing="10px" style=" margin-left:40px; margin-top:10px">
                    <tr><td>模板周期类型</td><td><input id="TemplateCycle" type="text"  class="easyui-combobox" data-options="url:urls.zqUrl,valueField:'Code',textField:'Name',panelHeight:'auto',onSelect:ControlManager.SelectTemplateType,onLoadSuccess:ControlManager.setTemplateType" style="height:28px;width:250px"/></td></tr>
                    <tr><td>年度</td><td><input id="Year"  class="easyui-combobox" data-options="valueField:'value',textField:'name',panelHeight:'auto'" style="height:28px;width:250px"/></td></tr>
                    <tr><td>周期</td><td><input id="Cycle"  class="easyui-combobox" data-options="valueField:'value',textField:'name',panelHeight:'auto'" style="height:28px;width:250px"/></td></tr>
                </table>
            </div>
            <div style="width:100%;border:0px;" data-options="region:'center'">
            <table id="companyTree" style="border:0px"></table>
            </div>
            <div data-options="region:'south'" style="height:32px; border-top:1px solid #d0d0d0;background-color:#F0F0F0;" ></div>
        </div>
    </div>
    <div data-options="region:'center'" style=" border:null">
        <table id="TemplateGrid" style=""></table>
    </div>
    
</body>
</html>
