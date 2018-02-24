<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="NewFormular.aspx.cs" Inherits="Audit.ct.Format.NewFormular" %> 

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 

<html xmlns="http://www.w3.org/1999/xhtml"> 
<head id="Head1" runat="server"> 
<title>新建公式　　　</title> 
       <meta http-equiv="X-UA-Compatible" content="IE=10" />
     <meta http-equiv="X-UA-Compatible" content="IE=9" />
     <meta http-equiv="X-UA-Compatible" content="IE=8" />
     <meta http-equiv="X-UA-Compatible" content="IE=7" />　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　
<script src="../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script> 
<%--<script src="../../lib/easyUI/easyloader.js" type="text/javascript"></script>--%> 
<script src="../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script> 
<link href="../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" /> 
<link href="../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" /> 
<script src="../../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script> 
<script src="../../Scripts/AjaxTrigger.js" type="text/javascript"></script> 
<script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script> 
<script src="../../lib/json2.js" type="text/javascript"></script> 
<script src="../../lib/Base64.js" type="text/javascript"></script>
    <script src="../../Scripts/ct/pub/PubHelp.js" type="text/javascript"></script>
<link href="../../lib/ligerUI/skins/ligerui-icons.css" rel="stylesheet" type="text/css" /> 
<link href="../../Styles/Ct_Controls.css" rel="stylesheet" type="text/css" /> 
<script src="../../Scripts/Ct_Controls.js" type="text/javascript"></script> 
         <script src="../../Scripts/ct_dialog.js"></script>
<style type="text/css"> 
.fontSize 
{ 
font-size:12px; 
} 
.table
{
    width:100%;
    height:80%;
}
.divcss5{border:1px solid #F00} 
</style> 

<script type="text/javascript">
    var urls = {
        DataSourceUrl: "../../handler/FormatHandler.ashx?ActionType=" + ReportFormatAction.ActionType.Grid + "&MethodName=" + ReportFormatAction.Methods.FormularMenuMethods.GetDataSourceList + "&FunctionName=" + ReportFormatAction.Functions.FormularMenu,
        InfoContent: "../pub/ContentInfo.aspx",
        BasicUrl: "../../handler/BasicHandler.ashx",
        DataTypeUrl: "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Get + "&MethodName=GetDictionaryListByClassType&FunctionName=" + BasicAction.Functions.DictionaryManager + "&ClassType=KMYEINSPUR",
        HelpDialog: "../pub/HelpDialogEasyUi.htm",
        MultiHelpDialog: "../pub/MultiHelpDialog.htm",
        ContentInfo: "../pub/ContentInfo.htm"
    };
    var formularData = [
{ id: "SQL", text: "SQL公式" },
{ id: "YYDX", text: "语义对象取数" },
{ id: "BBQS", text: "报表内码取数" },
{ id: "BBHLQS", text: "报表行列取数" },
{ id: "BBQKQS", text: "报表区块取数" },
{ id: "CCGC", text: "存储过程取数" },
{ id: "KMYE", text: "科目余额函数" },
{ id: "CCGCGS", text: "存储过程通用公式取数" }
];
    var controls = { bbCode: {}, company: {}, task: {}, menu: {}, cells: {}, nd: {}, zq: {}, ProcedureControls: [], ProcedureData: [], CurrentProcedure: "",IsOrNotSwap:0};
    var editParas = { fType: "", DataSource: "", DataSourceTemp: "", content: "", formularContent: "" }; //formularContent:纯公式部分
    var dialogWithHeight = { width: 400, height: 500 };
    var flag = false;
    var editPopNameCurrent = "";//当前存储过程编辑框名称
    var formularManager = {
        CreateFormular: function () {
            var ftype = $("#fType").combobox('getValue');
            var content = $("#fContentT").text();
            if (ftype == "SQL") {
                $("#fContent").val("SQL(" + content + ")");

            } else if (ftype == "YYDX") {
                $("#fContent").val("SIMA(" + content + ")");
            } else if (ftype == "BBQS" || ftype == "BBHLQS" || ftype == "BBQKQS") {
                if (controls.bbCode.name.val() == "") {
                    alert("报表编号不能为空");
                    return;
                }
                if (controls.company.name.val() == "") {
                    alert("组织机构不能为空");
                    return;
                }
                var str = "";
                str = "bbCode:" + controls.bbCode.name.val() + ";";
                str += "company:" + controls.company.name.val() + ";";
                str += "task:" + controls.task.name.val() + ";";
                str += "paper:" + controls.menu.name.val() + ";";
                str += "cells:" + controls.cells.name.val() + ";";                
                str += "nd:" + controls.nd.name.val() + ";";
                str += "zq:" + controls.zq.name.val() + ";";
                if (ftype == "BBQKQS") {
                    var layoutType = $("#layoutType").combobox("getValue");
                    str += "layoutType:" + layoutType + ";";
                }
                str += "IsOrNotSwap:" + controls.IsOrNotSwap;
                $("#fContent").val(ftype + "(" + str + ")");

            } else if (ftype == "CCGC" || ftype == "CCGCGS") {
                $.each(controls.ProcedureData, function (index, item) {
                    var cname = controls.ProcedureControls[index];
                    item.Value = $("#" + cname).val();
                });
                var pf = { name: "", parameters: [] };
                pf.name = controls.CurrentProcedure;
                pf.parameters = controls.ProcedureData;
                $("#fContent").val("CCGC(" + JSON.stringify(pf) + ")");
            } else if (ftype == "KMYE") {
                $("#fContent").val("KMYE(" + content + ")");
            }

        },
        FoumulerTypeSelected: function () {
            var record = { id: "" };
            record.id = $("#fType").combobox("getValue");
            if (record.id == "SQL") {
                $("#sqlDiv").css("display", "block");
                $("#bbDiv").css("display", "none");
                $("#qDiv").css("display", "none");
                $("#fContentT").text("");
            } else if (record.id == "YYDX") {
                $("#sqlDiv").css("display", "block");
                $("#bbDiv").css("display", "none");

                var paras = { url: "", columns: [], sortName: "", sortOrder: "", NameField: "Desc", CodeField: "Obid" };
                paras.url = "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Grid + "&MethodName=" + BasicAction.Methods.SimaMethods.GetDataGrid + "&FunctionName=" + BasicAction.Functions.Sima;
                paras.columns = [[{ field: "Obid", title: "语义对象编号" },
{ field: "Desc", title: "语义对象名称" }

]];
                paras.sortName = "Obid";
                paras.sortOrder = "ASC";
                //改造后的代码    

                pubHelp.setParameters(paras);
                pubHelp.OpenDialogWithHref("Dialog", "语义对象选择", urls.HelpDialog, formularManager.DialogSave.YydxSave, dialogWithHeight.width, dialogWithHeight.height, true);

            } else if (record.id == "BBQS" || record.id == "BBHLQS") {
                $("#bbDiv").css("display", "block");
                $("#sqlDiv").css("display", "none");
                $("#qDiv").css("display", "none");
                $("#fContentT").text("");
                $("#checkSpan").text("行列转换 ");
                $("#RowColCheckBox").css("display", "block");
                $("#layoutDiv").css("display", "none");
                controls.cells.name.val("");
            } else if (record.id == "BBQKQS") {
                $("#DataSource").combobox("setValue","");
                $("#bbDiv").css("display", "block");
                $("#sqlDiv").css("display", "none");
                $("#qDiv").css("display", "none");
                $("#fContentT").text("");
                $("#checkSpan").text("布局方式");
                $("#layoutDiv").css("display", "block");
                $("#RowColCheckBox").attr("checked", false);
                $("#RowColCheckBox").css("display", "none");
                controls.cells.name.val("");
            } else if (record.id == "CCGC") {
                $("#bbDiv").css("display", "none");
                $("#sqlDiv").css("display", "none");
                $("#qDiv").css("display", "block");
                $("#qDiv").empty();
                $("#fContentT").text("");
                var paras = { url: "", columns: [], sortName: "", sortOrder: "", DataSourceId: "", NameField: "Name", CodeField: "Id" };
                paras.DataSourceId = $("#DataSource").combobox('getValue');
                if (paras.DataSourceId == "") {
                    if (editParas.DataSourceTemp == "") {
                        alert("数据源不能为空"); return;
                    } else {
                        paras.DataSourceId = editParas.DataSourceTemp;
                        editParas.DataSourceTemp = "";
                    }
                };
                paras.url = "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Grid + "&MethodName=" + BasicAction.Methods.ProcedureMethods.GetProcedureDataGrid + "&FunctionName=" + BasicAction.Functions.Procedure + "&DataSourceId=" + paras.DataSourceId;
                paras.columns = [[{ field: "Id", title: "存储过程ID", width: 120 },
{ field: "Name", title: "存储过程名称", width: 200 }

]];
                paras.sortName = "Id";
                paras.sortOrder = "DESC";

                pubHelp.setParameters(paras);
                pubHelp.OpenDialogWithHref("Dialog", "存储过程选择", urls.HelpDialog, formularManager.DialogSave.CCGCSave, dialogWithHeight.width, dialogWithHeight.height, true);
            } else if (record.id == "KMYE") {
                $("#sqlDiv").css("display", "block");
                $("#bbDiv").css("display", "none");
                $("#qDiv").css("display", "none");
                $("#Dialog").empty();
                var kmye = "<table class='table'>" +
"<tr><td>单位编号<div id='dwbh' ></div></td><td>科目体系<br><input id='kmtx' class='easyui-validatebox textbox' style='width:140px'/></td></tr>" +
"<tr><td>会计年度<br/><div id='kjnd' ></div></td><td>会计期间<br/><div id='kjqj' ></div></td></tr>" +
"<tr><td>科目编号<br/><div id='kmbh'></div></td><td>当期余额<br/><input id='dataType'/></td></tr>" + "</table>";
                $("#Dialog").append(kmye);
                controls.dwbh = $("#dwbh").PopEdit();
                controls.kmbh = $("#kmbh").PopEdit();
                controls.kjqj = $("#kjqj").PopEdit();
                controls.kjnd = $("#kjnd").PopEdit();
                controls.dataType = $("#dataType").combobox({ url: urls.DataTypeUrl, valueField: 'Code',
                    textField: 'Name', multiple: true
                });

                controls.dwbh.btn.bind("click", function () {
                    formularManager.KmyeFunctionClick("dwbh");
                });
                controls.kjnd.btn.bind("click", function () {
                    formularManager.KmyeFunctionClick("kjnd");
                });
                controls.kjqj.btn.bind("click", function () {
                    formularManager.KmyeFunctionClick("kjqj");
                });
                controls.kmbh.btn.bind("click", function () {
                    formularManager.KmyeFunctionClick("kmbh");
                });
                // OpenDialog('科目余额函数', formularManager.KmyeSaveFunction);
                pubHelp.OpenDialogNoHref("Dialog", "科目余额函数", formularManager.KmyeSaveFunction, 400, 300, true);
            } else if (record.id == "CCGCGS") {
                $("#bbDiv").css("display", "none");
                $("#sqlDiv").css("display", "none");
                $("#qDiv").css("display", "block");
                $("#qDiv").empty();
                $("#fContentT").text("");

                var paras = { url: "", columns: [], sortName: "", sortOrder: "", DataSourceId: "", NameField: "NameValue", CodeField: "Name" };
                paras.DataSourceId = $("#DataSource").combobox('getValue');
                if (paras.DataSourceId == "") {
                    if (editParas.DataSourceTemp == "") {
                        alert("数据源不能为空"); return;
                    } else {
                        paras.DataSourceId = editParas.DataSourceTemp;
                        editParas.DataSourceTemp = "";
                    }
                };
                paras.url = "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Grid + "&MethodName=" + BasicAction.Methods.ProcedureMethods.DataGridProcedureFormularEntities + "&FunctionName=" + BasicAction.Functions.Procedure;
                paras.columns = [[{ field: "NameValue", title: "存储过程名称", width: 120 },
{ field: "Name", title: "存储过程值", width: 200 },
{ field: "Parameters", title: "", hidden: true }

]];
                paras.sortName = "CreateTime";
                paras.sortOrder = "DESC";

                pubHelp.setParameters(paras);
                pubHelp.OpenDialogWithHref("Dialog", "存储过程通用公式选择", urls.HelpDialog, formularManager.DialogSave.CCGCGSSave, dialogWithHeight.width, dialogWithHeight.height, true);
            }
        },
        BBFormularClick: function (type) {
            switch (type) {
                case "bbCode":
                    if (controls.menu.name.val() == "") { alert("请先选择审计底稿！"); return }
                    var paras = { url: "", columns: [], sortName: "", sortOrder: "", NameField: "bbName", CodeField: "bbCode", defaultField: { dftBy: "bbCode", dft: ""} };
                    paras.url = "../../handler/FormatHandler.ashx?ActionType=" + ReportFormatAction.ActionType.Grid + "&MethodName=" + ReportFormatAction.Methods.FormularMenuMethods.GetReportsByPaperCode + "&FunctionName=" + ReportFormatAction.Functions.FormularMenu + "&PaperCode=" + controls.menu.name.val();
                    paras.columns = [[{ field: "Id", title: "Id", width: 80, hidden: true },
{ field: "bbCode", title: "报表编号", width: 100 },
{ field: "bbName", title: "报表名称", width: 190 }
]];
                    paras.sortName = "bbCode";
                    paras.sortOrder = "ASC";


                    pubHelp.setParameters(paras);
                    pubHelp.OpenDialogWithHref("Dialog", "报表选择", urls.HelpDialog, formularManager.DialogSave.BBFormularSave.BBSave, dialogWithHeight.width, dialogWithHeight.height, true);
                    break;
                case "company":
                    var paras = { idField: "", sortName: "", sortOrder: "", columns: [], url: "", NameField: "Name", CodeField: "Code", defaultField: { dftBy: "Code", dft: ""} };
                    paras.url = "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Grid + "&MethodName=" + BasicAction.Methods.CompanyManagerMethods.CompanyDataGrid + "&FunctionName=" + BasicAction.Functions.CompanyManager;
                    paras.columns = [[
{ title: 'id', field: 'Id', width: 180, hidden: true },
{ title: '组织机构编号', field: 'Code', width: 105 },
{ title: '组织机构名称', field: 'Name', width: 180 }
]];
                    paras.sortName = "Code";
                    paras.sortOrder = "ASC";

                    paras.defaultField.dft = controls.company.name.val();


                    pubHelp.setParameters(paras);
                    pubHelp.OpenDialogWithHref("Dialog", "单位选择", urls.HelpDialog, formularManager.DialogSave.BBFormularSave.CompanySave, dialogWithHeight.width, dialogWithHeight.height, true);
                    break;

                case "task":
                    var paras = { url: "", columns: [], sortName: "", sortOrder: "", NameField: "Name", CodeField: "Code", defaultField: { dftBy: "Code", dft: ""} };
                    paras.url = "../../handler/AuditTaskHandler.ashx?ActionType=" + AuditTaskAction.ActionType.Grid + "&MethodName=" + AuditTaskAction.Methods.AuditTaskManagerMethods.GetDataGrid + "&FunctionName=" + AuditTaskAction.Functions.AuditTaskManager;
                    paras.columns = [[{ field: "Id", title: "Id", width: 80, hidden: true },
{ field: "Code", title: "任务编号", width: 80 },
{ field: "Name", title: "任务名称", width: 200 }
]];
                    paras.sortName = "Code";
                    paras.sortOrder = "ASC";


                    pubHelp.setParameters(paras);
                    pubHelp.OpenDialogWithHref("Dialog", "任务选择", urls.HelpDialog, formularManager.DialogSave.BBFormularSave.TaskSave, dialogWithHeight.width, dialogWithHeight.height, true);
                    break;
                case "menu":
                    if (controls.task.name.val() == "") { alert("请先选择审计任务！"); return }

                    var paras = { url: "", columns: [], sortName: "", sortOrder: "", NameField: "Name", CodeField: "Code", defaultField: { dftBy: "Code", dft: ""} };
                    paras.url = "../../handler/FormatHandler.ashx?ActionType=" + ReportFormatAction.ActionType.Grid + "&MethodName=" + ReportFormatAction.Methods.FormularMenuMethods.GetDataGridByTaskCode + "&FunctionName=" + ReportFormatAction.Functions.FormularMenu + "&TaskCode=" + controls.task.name.val();
                    paras.columns = [[{ field: "Id", title: "Id", width: 80, hidden: true },
{ field: "Code", title: "审计底稿编号", width: 100 },
{ field: "Name", title: "审计底稿名称", width: 190 }
]];
                    paras.sortName = "Code";
                    paras.sortOrder = "ASC";

                    pubHelp.setParameters(paras);
                    pubHelp.OpenDialogWithHref("Dialog", "底稿选择", urls.HelpDialog, formularManager.DialogSave.BBFormularSave.MenuSave, dialogWithHeight.width, dialogWithHeight.height, true);

                    break;
                case "nd":
                    var paras = { url: "", columns: [], sortName: "", sortOrder: "", NameField: "Name", CodeField: "Code", defaultField: { dftBy: "Code", dft: ""} };
                    paras.url = "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Grid + "&MethodName=" + BasicAction.Methods.DicManagerMethods.GetDictionaryListByClass + "&FunctionName=" + BasicAction.Functions.DictionaryManager + "&classId=HHS";
                    paras.columns = [[{ field: "Code", title: "编号", width: 120 },
{ field: "Name", title: "名称", width: 190 }
]];
                    paras.sortName = "Code";
                    paras.sortOrder = "ASC";
                    if (controls.nd.name.val().length > 4) {
                        paras.defaultField.dft = controls.nd.name.val().substr(2, controls.nd.name.val().length - 4);
                    }


                    pubHelp.setParameters(paras);
                    pubHelp.OpenDialogWithHref("Dialog", "系统帮助", urls.HelpDialog, formularManager.DialogSave.BBFormularSave.SaveNd, dialogWithHeight.width, dialogWithHeight.height, true);

                    break;
                case "zq":
                    var paras = { url: "", columns: [], sortName: "", sortOrder: "", NameField: "Name", CodeField: "Code", defaultField: { dftBy: "Code", dft: ""} };
                    paras.url = "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Grid + "&MethodName=" + BasicAction.Methods.DicManagerMethods.GetDictionaryListByClass + "&FunctionName=" + BasicAction.Functions.DictionaryManager + "&classId=HHS";
                    paras.columns = [[{ field: "Code", title: "编号", width: 120 },
{ field: "Name", title: "名称", width: 190 }
]];
                    paras.sortName = "Code";
                    paras.sortOrder = "ASC";
                    if (controls.zq.name.val().length > 4) {
                        paras.defaultField.dft = controls.zq.name.val().substr(2, controls.zq.name.val().length - 4);
                    }


                    pubHelp.setParameters(paras);
                    pubHelp.OpenDialogWithHref("Dialog", "系统帮助", urls.HelpDialog, formularManager.DialogSave.BBFormularSave.ZqSave, dialogWithHeight.width, dialogWithHeight.height, true);

                    break;
                case "cells":
                    var node = { Id: "" };
                    if (controls.bbCode.name.val()) {
                        node.Id = controls.bbCode.name.val();
                        node.type = $("#fType").combobox('getValue');
                        if (!flag) {
                            $("#DialogIframe").html('<iframe id="IframeDialog"  src="../pub/CellHelpLingerUi.htm" frameborder="0" style="width:100%;height:100%;"></iframe>');
                            flag = true;
                        } else {
                            var iframe = window.frames["IframeDialog"];
                            iframe.RefreshDataGrid(node);
                        }
                        pubHelp.setParameters(node);
                        pubHelp.OpenDialogWithIframe("DialogIframe", "单元格选择", formularManager.DialogSave.BBFormularSave.CellSave, 650, 520, true);


                    } else {
                        alert("请先选择报表！"); return
                    }
                    break;
            }
        },
        KmyeFunctionClick: function (type) {
            switch (type) {
                case "dwbh":
                    var paras = { url: "", columns: [], sortName: "", sortOrder: "", NameField: "Code,Name", CodeField: "Code", defaultField: { dftBy: "Code", dft: ""} };
                    paras.url = "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Grid + "&MethodName=" + BasicAction.Methods.CompanyManagerMethods.CompanyDataGrid + "&FunctionName=" + BasicAction.Functions.CompanyManager;
                    paras.columns = [[{ field: "Id", title: "Id", width: 80, hidden: true },
{ field: "Code", title: "任务编号", width: 80 },
{ field: "Name", title: "任务名称", width: 200 }
]];
                    paras.sortName = "Code";
                    paras.sortOrder = "ASC";
                    paras.defaultField.dft = controls.dwbh.name.val();
                    pubHelp.setParameters(paras);
                    pubHelp.OpenDialogWithHref("Dialog2", "系统帮助", urls.HelpDialog, formularManager.DialogSave.KmyeSave.DwbhSave, dialogWithHeight.width, dialogWithHeight.height, true);

                    break;
                case "kmbh":
                    var para = { Kmtx: "", Kjnd: "", DataSourceId: "" };
                    para.Kmtx = $("#kmtx").val();
                    para.Kjnd = controls.kjnd.name.val();
                    para.DataSourceId = $("#DataSource").combobox('getValue');
                    var url = CreateUrl(urls.BasicUrl, BasicAction.ActionType.Grid, BasicAction.Functions.AccountBalance, BasicAction.Methods.AccountBalanceMethods.AccountSubjectsDataGrid, para);
                    var paras = { url: "", columns: [], sortName: "", sortOrder: "", NameField: "Kmbh,Kmmc", height: "" };
                    paras.url = url;
                    paras.columns = [[
                    { checkbox: true },
{ field: "Kmbh", title: "科目编号", width: 80 },
{ field: "Kmmc", title: "科目名称", width: 200 }
]];
                    paras.sortName = "Kmbh";
                    paras.sortOrder = "ASC";

                    pubHelp.setParameters(paras);
                    pubHelp.OpenDialogWithHref("Dialog2", "系统帮助", urls.MultiHelpDialog, formularManager.DialogSave.KmyeSave.Kmbh, dialogWithHeight.width, dialogWithHeight.height, true);


                    break;
                case "kjnd":
                    var paras = { url: "", columns: [], sortName: "", sortOrder: "", NameField: "Name", CodeField: "Code", defaultField: { dftBy: "Code", dft: ""} };
                    paras.url = "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Grid + "&MethodName=" + BasicAction.Methods.DicManagerMethods.GetDictionaryListByClass + "&FunctionName=" + BasicAction.Functions.DictionaryManager + "&classId=HHS";
                    paras.columns = [[{ field: "Code", title: "编号", width: 80 },
{ field: "Name", title: "名称", width: 200 }

]];
                    paras.sortName = "Code";
                    paras.sortOrder = "ASC";
                    if (controls.kjnd.name.val().length > 4) {
                        paras.defaultField.dft = controls.kjnd.name.val().substr(2, controls.kjnd.name.val().length - 4);
                    }

                    pubHelp.setParameters(paras);
                    pubHelp.OpenDialogWithHref("Dialog2", "系统帮助", urls.HelpDialog, formularManager.DialogSave.KmyeSave.KjndSave, dialogWithHeight.width, dialogWithHeight.height, true);

                    break;
                case "kjqj":
                    var paras = { url: "", columns: [], sortName: "", sortOrder: "", NameField: "Name", CodeField: "Code", defaultField: { dftBy: "Code", dft: ""} };
                    paras.url = "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Grid + "&MethodName=" + BasicAction.Methods.DicManagerMethods.GetDictionaryListByClass + "&FunctionName=" + BasicAction.Functions.DictionaryManager + "&classId=HHS";
                    paras.columns = [[{ field: "Code", title: "编号", width: 80 },
{ field: "Name", title: "名称", width: 200 }

]];
                    paras.sortName = "Code";
                    paras.sortOrder = "ASC";
                    if (controls.kjqj.name.val().length > 4) {
                        paras.defaultField.dft = controls.kjqj.name.val().substr(2, controls.kjqj.name.val().length - 4);
                    }


                    pubHelp.setParameters(paras);
                    pubHelp.OpenDialogWithHref("Dialog2", "系统帮助", urls.HelpDialog, formularManager.DialogSave.KmyeSave.KjqjSave, dialogWithHeight.width, dialogWithHeight.height, true);

                    break;

            }
        },
        KmyeSaveFunction: function () {
            var parameters = "";
            parameters += "kmtx:" + $("#kmtx").val() + ";";
            parameters += "dwbh:" + controls.dwbh.name.val() + ";";
            parameters += "kjnd:" + controls.kjnd.name.val() + ";";
            parameters += "kjqj:" + controls.kjqj.name.val() + ";";
            parameters += "kmbh:" + controls.kmbh.name.val() + ";";
            var dataValues = controls.dataType.combobox("getValues");
            var values = "";
            $.each(dataValues, function (index, item) {
                values += item + ",";
            });
            if (values.length > 0) values = values.substr(0, values.length - 1);
            parameters += "dataType:" + values;

            $("#fContentT").val(parameters);
        },
        DialogSave: {
            HelpSave: function () {
                var result = pubHelp.getResultObj();
                if (result && result.Code) {
                    add("<!" + result.Code + "!>");
                }
            },
            YydxSave: function () {
                var result = pubHelp.getResultObj();
                if (result && result.Obid) {
                    $("#fContentT").text(result.Obid);
                }
            },
            CCGCSave: function () {
                var result = pubHelp.getResultObj();
                if (result && result.Id) {
                    var para = { procedureId: "", DataSourceId: "" };
                    para.DataSourceId = $("#DataSource").combobox('getValue');
                    para.procedureId = result.Id;
                    controls.CurrentProcedure = result.Name;
                    para = CreateParameter(BasicAction.ActionType.Post, BasicAction.Functions.Procedure, BasicAction.Methods.ProcedureMethods.GetParametersByProcedure, para);

                    DataManager.sendData("../../handler/BasicHandler.ashx", para, resultManagers.success, resultManagers.fail, false);
                }
            },
            CCGCGSSave: function () {
                var result = pubHelp.getResultObj();
                if (result && result.Name) {
                    controls.CurrentProcedure = result.Name;
                    var parameters = JSON2.parse(result.Parameters);
                    controls.ProcedureControls = [];
                    controls.ProcedureData = [];
                    var strHml = "<table cellSpacing='5' cellPadding='0' style=' border: 1px solid #95B8E7; line-height:25px;'>";
                    strHml += '<tr ><th>参数名</th><th>参数类型</th><th>参数值</th></tr>';
                    $.each(parameters, function (index, item) {
                        strHml += '<tr "><td>' + item.Name + '</td><td>' + item.Type + '</td><td><input type="text" style=" width:140px; height:18px;" id="name' + item.Id + '" class="ctPopEdit"/><input type="button" value="..." id="' + item.Id + '" style=" width:15px; height:23px; text-align:left; padding-left:0px;" class=" ctPopEdit PopButton" onclick="ProcedurePopEditClick(this)"/></td></tr>';
                        controls.ProcedureControls.push("name" + item.Id);
                        item.Name = item.Value;
                        controls.ProcedureData.push(item);
                    });

                    strHml += "</table>";
                    $("#qDiv").append(strHml);
                }
            },
            KmyeSave: {
                DwbhSave: function () {
                    var result = pubHelp.getResultObj();
                    if (result && result.Id) {
                        controls.dwbh.name.val(result.Code);
                    }
                },
                Kmbh: function () {
                    var result = pubHelp.getResultObj();
                    if (result && result.length > 0) {

                        var rows = "";
                        $.each(result, function (index, item) {
                            rows += item.Kmbh + ",";
                        });
                        if (rows.length > 0) {
                            rows = rows.substr(0, rows.length - 1);
                        }
                        controls.kmbh.name.val(rows);

                    }
                },
                KjndSave: function () {
                    var result = pubHelp.getResultObj();
                    if (result && result.Code) {
                        var kjnd = ("<!" + result.Code + "!>");
                        controls.kjnd.name.val(kjnd);
                    }
                },
                KjqjSave: function () {
                    var result = pubHelp.getResultObj();
                    if (result && result.Code) {
                        var kjqj = ("<!" + result.Code + "!>");
                        controls.kjqj.name.val(kjqj);
                    }
                }
            },
            BBFormularSave: {
                TaskSave: function () {
                    var result = pubHelp.getResultObj();
                    if (result && result.Id) {
                        controls.task.name.val(result.Code);
                        controls.task.value.val(result.Code);
                    }
                },
                MenuSave: function () {
                    var result = pubHelp.getResultObj();
                    if (result && result.Id) {
                        controls.menu.name.val(result.Code);
                        controls.menu.value.val(result.bbCode);
                    }
                },
                BBSave: function () {
                    var result = pubHelp.getResultObj();
                    if (result && result.Id) {
                        controls.bbCode.name.val(result.bbCode);
                        controls.bbCode.value.val(result.bbCode);
                    }
                },
                CompanySave: function () {
                    var result = pubHelp.getResultObj();
                    if (result) {
                        controls.company.value.val(result.bbCode);
                        controls.company.name.val(result.Code);
                    }
                },
                SaveNd: function () {
                    var result = pubHelp.getResultObj();
                    if (result && result.Code) {
                        controls.nd.name.val("<!" + result.Code + "!>");
                        controls.nd.value.val("<!" + result.Code + "!>");
                    }
                },
                ZqSave: function () {
                    var result = pubHelp.getResultObj();
                    if (result && result.Code) {
                        controls.zq.name.val("<!" + result.Code + "!>");
                        controls.zq.value.val("<!" + result.Code + "!>");
                    }
                },
                CellSave: function () {
                    var result = pubHelp.getResultObj();
                    var type = $("#fType").combobox('getValue');
                    if (result && result.length > 0) {
                        var str = "";
                        $.each(result, function (index, item) { str += item + ","; });
                        if (str.length > 0) str = str.substr(0, str.length - 1);
                        var old = controls.cells.name.val();
                        if (old.length > 0) {
                            if (type == "BBQS") {
                                var oldcells = old.split(",");
                                var cellStr = old + ",";
                                $.each(result, function (index, item) {
                                    var seleted = false;
                                    $.each(oldcells, function (index, cell) {
                                        if (item == cell) {
                                            seleted = true;
                                            return false;
                                        }
                                    });
                                    if (!seleted) {
                                        cellStr += item + ",";
                                    }
                                });
                                if (cellStr.length > 0) cellStr = cellStr.substr(0, cellStr.length - 1);
                                controls.cells.name.val(cellStr);

                            } else if (type == "BBHLQS" || type == "BBQKQS") {
                                controls.cells.name.val(old + ";" + str);
                            }
                        } else {
                            controls.cells.name.val(str);
                        }
                    }
                }
            }
        }
    };
    //初始化数据
    $(
function () {


    controls.bbCode = $("#bbCode").PopEdit();
    controls.company = $("#company").PopEdit();
    controls.task = $("#task").PopEdit();
    controls.menu = $("#menu").PopEdit();
    controls.cells = $("#cells").PopEdit();
    controls.nd = $("#nd").PopEdit();
    controls.zq = $("#zq").PopEdit();
    controls.bbCode.btn.bind("click", function () {
        formularManager.BBFormularClick("bbCode");
    });
    controls.company.btn.bind("click", function () {
        formularManager.BBFormularClick("company");
    });
    controls.task.btn.bind("click", function () {
        formularManager.BBFormularClick("task");
    });
    controls.menu.btn.bind("click", function () {
        formularManager.BBFormularClick("menu");
    });
    controls.cells.btn.bind("click", function () {
        formularManager.BBFormularClick("cells");
    });
    controls.nd.btn.bind("click", function () {
        formularManager.BBFormularClick("nd");
    });
    controls.zq.btn.bind("click", function () {
        formularManager.BBFormularClick("zq");
    });
    $("#addBtn").bind("click", function () {
        formularManager.CreateFormular();
    });

    $("#helpBtn").bind("click", function () {
        var paras = { url: "", columns: [], sortName: "", sortOrder: "", NameField: "Name", CodeField: "Code" };
        paras.url = "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Grid + "&MethodName=" + BasicAction.Methods.DicManagerMethods.GetDictionaryListByClass + "&FunctionName=" + BasicAction.Functions.DictionaryManager + "&classId=HHS";
        paras.columns = [[{ field: "Code", title: "编号", width: 120 },
{ field: "Name", title: "名称", width: 190 }

]];
        paras.sortName = "Code";
        paras.sortOrder = "ASC";
        pubHelp.setParameters(paras);
        pubHelp.OpenDialogWithHref("Dialog", "系统帮助", urls.HelpDialog, formularManager.DialogSave.HelpSave, dialogWithHeight.width, dialogWithHeight.height, true);

    });

    $("#saveBtn").bind("click", function () {
        var Content = $("#fContent").val();
        var cutTo = Content.indexOf("(");
        var fType = Content.substr(0, cutTo);
        if (fType == "BBHLQS" || fType == "BBQKQS") {
            //依靠 公式内容的生成顺序 计算 单元格内容 ,生成顺序有 改变时需要调整 
            if (Content.split("cells").length > 0) {
                var rightStr = Content.split("cells")[1];
                var cellsStr = rightStr.split("nd")[0];
                var cells = cellsStr.substring(1, cellsStr.length - 1);
                Content = Content.replace(cells, Base64.encode(cells));
            }
        }
        var result = { content: "", DataSource: "" };
        result.content = Content
        result.DataSource = $("#DataSource").combobox('getValue');
        result.FormularLevel = $("#fLevel").val();
       
        var modalid = $(window.frameElement).attr("modalid");
        dialog.setVal(result);
        dialog.close(modalid);
      
    });
    var paras = dialog.para();// window.dialogArguments;
    if (paras && paras.content) {
        $("#fContent").val(paras.content);

        editParas.content = paras.content;
        var cutTo = paras.content.indexOf("(");
        editParas.fType = paras.content.substr(0, cutTo);
        editParas.formularContent = paras.content.substring(cutTo + 1, paras.content.length - 1);
        if (paras.DataSource) {
            editParas.DataSource = paras.DataSource;
            editParas.DataSourceTemp = paras.DataSource;
        }
        if ($("#fType").combobox && $("#fType").combobox("getData").length > 0) {
            EditManager.fTypeFirstView($("#fType").combobox("getData"));
        } else {
            $("#fType").combobox({ onLoadSuccess: EditManager.fTypeFirstView });
        }
        if ($("#DataSource").combobox && $("#DataSource").combobox("getData").length > 0) {
            EditManager.DataSourceFirstView();
        } else {
            $("#DataSource").combobox({ onLoadSuccess: EditManager.DataSourceFirstView });
        }
        if (paras["FormularLevel"] != undefined && paras["FormularLevel"] != null) {
            $("#fLevel").val(paras.FormularLevel);
        } else {
            $("#fLevel").val(0);
        }

    } else {
        $("#fLevel").val(0);
    }
}
);

    //根据TextArea生成对象 
    var start = 0;
    var end = 0;
    function add(str) {
        var textBox = document.getElementById("fContentT");
        var pre = textBox.value.substr(0, start);
        var post = textBox.value.substr(end);
        textBox.value = pre + str + post;
    }
    function savePos(textBox) {
        //如果是Firefox(1.5)的话，方法很简单 
        if (typeof (textBox.selectionStart) == "number") {
            start = textBox.selectionStart;
            end = textBox.selectionEnd;
        }
        //下面是IE(6.0)的方法，麻烦得很，还要计算上'\n' 
        else if (document.selection) {
            var range = document.selection.createRange();
            if (range.parentElement().id == textBox.id) {
                // create a selection of the whole textarea 
                var range_all = document.body.createTextRange();
                range_all.moveToElementText(textBox);
                //两个range，一个是已经选择的text(range)，一个是整个textarea(range_all) 
                //range_all.compareEndPoints()比较两个端点，如果range_all比range更往左(further to the left)，则 //返回小于0的值，则range_all往右移一点，直到两个range的start相同。 
                // calculate selection start point by moving beginning of range_all to beginning of range 
                for (start = 0; range_all.compareEndPoints("StartToStart", range) < 0; start++)
                    range_all.moveStart('character', 1);
                // get number of line breaks from textarea start to selection start and add them to start 
                // 计算一下\n 
                for (var i = 0; i <= start; i++) {
                    if (textBox.value.charAt(i) == '\n')
                        start++;
                }
                // create a selection of the whole textarea 
                var range_all = document.body.createTextRange();
                range_all.moveToElementText(textBox);
                // calculate selection end point by moving beginning of range_all to end of range 
                for (end = 0; range_all.compareEndPoints('StartToEnd', range) < 0; end++)
                    range_all.moveStart('character', 1);
                // get number of line breaks from textarea start to selection end and add them to end 
                for (var i = 0; i <= end; i++) {
                    if (textBox.value.charAt(i) == '\n')
                        end++;
                }
            }
        }

    }



    function ContentHelpClick() {
        var content = $("#fContent").val();
        pubHelp.setParameters(content);
        pubHelp.OpenDialogWithHref("Dialog", "系统帮助", urls.ContentInfo, saveFunction.ContentInfoSave,400,300, false);

    }

    //存储过程 
    function ProcedurePopEditClick(data) {
        var name = "name" + data.id;
        var paras = { url: "", columns: [], sortName: "", sortOrder: "" };
        paras.url = "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Grid + "&MethodName=" + BasicAction.Methods.DicManagerMethods.GetDictionaryListByClass + "&FunctionName=" + BasicAction.Functions.DictionaryManager + "&classId=HHS";
        paras.columns = [[{ field: "Code", title: "编号", width: 80 },
{ field: "Name", title: "名称", width: 200 }

]];
        paras.sortName = "Code";
        paras.sortOrder = "ASC";

        editPopNameCurrent = name;
        pubHelp.setParameters(paras);
        pubHelp.OpenDialogWithHref("Dialog", "系统帮助", urls.HelpDialog, saveFunction.ProcedurePopEditSave, dialogWithHeight.width, dialogWithHeight.height, false);

    }
    var saveFunction = {
        ContentInfoSave: function () {
            var result = pubHelp.getResultObj();
            if (result) {
                $("#fContent").val(result);
            }
        },
        ProcedurePopEditSave: function () {
            var result = pubHelp.getResultObj();
            if (result && result.Code) {
                $("#" + editPopNameCurrent).val("<!" + result.Code + "!>");
            }
        }
    };
    var EditManager = {
        //设置comcobox 默认 
        //数据源
        //张双义 
        DataSourceFirstView: function (data) {
            if (data.length > 0 && editParas.DataSource != "") {
                for (var i = 0; i < data.length; i++) {
                    if (data[i].Id == editParas.DataSource) {
                        $('#DataSource').combobox('select', data[i].Id);
                    }
                }
            }
        },
        //公式类型
        //若默认 成功则 显示公式内容
        fTypeFirstView: function (data) {
            if (data.length > 0 && editParas.fType != "") {
                var value = editParas.fType;
                if (editParas.fType == "SIMA") {
                    value = "YYDX";
                }
                switch (editParas.fType) {
                    case "SQL":
                    case "SIMA":
                    case "KMYE":
                    case "CCGC":
                        $("#sqlDiv").css("display", "block");
                        $("#bbDiv").css("display", "none");
                        $("#qDiv").css("display", "none");
                        $("#fContentT").text(editParas.content);
                        break;
                    case "BBQS":
                    case "BBHLQS":
                        $("#bbDiv").css("display", "block");
                        $("#sqlDiv").css("display", "none");
                        $("#qDiv").css("display", "none");
                        $("#fContentT").text("");
                        $("#RowColCheckBox").css("display", "block");
                        $("#layoutDiv").css("display", "none");
                        var ContentObj = EditManager.translateContent(editParas.formularContent);
                        EditManager.presetContent(ContentObj);
                        $("#fContent").val(ContentObj.formularContent);
                        if (ContentObj.IsOrNotSwap == 1) {
                            $("#RowColCheckBox").attr("checked", true);
                            controls.IsOrNotSwap = 1;
                        }
                        break;
                    case "BBQKQS":
                        $("#bbDiv").css("display", "block");
                        $("#sqlDiv").css("display", "none");
                        $("#qDiv").css("display", "none");
                        $("#fContentT").text("");
                        $("#checkSpan").text("布局方式");
                        $("#RowColCheckBox").css("display", "none");
                        $("#layoutDiv").css("display", "block");
                        var ContentObj = EditManager.translateContent(editParas.formularContent);
                        EditManager.presetContent(ContentObj);
                        $("#fContent").val(ContentObj.formularContent);
                        $("#layoutType").combobox("setValue", ContentObj.layoutType);
                        break;
                }
                $('#fType').combobox('setValue', value);
            }
        },
        //反解 公式内容
        translateContent: function (formularContent) {
            var ContentObjList = []; //["bbCode:6062",""]
            var ContentObj = { bbCode: "", company: "", task: "", paper: "", cells: "", nd: "", zq: "", 
                IsOrNotSwap: 0, layoutType: "", formularContent: "" }; //{bbCode:"6062",xx:""}
            var cells = "";                     //formularContent 解析后的公式
ContentObjList = formularContent.split(";");             
            if (ContentObjList.length > 0) {
                $.each(ContentObjList, function (index, objStr) {
                    var objArray = objStr.split(":");
                    ContentObj[objArray[0]] = objArray[1];
                });
            }
            cells = ContentObj.cells;
            if (editParas.fType == "BBHLQS" || editParas.fType == "BBQKQS") {
                ContentObj.cells = Base64.decode(ContentObj.cells);
            }
            formularContent = formularContent.replace(cells, ContentObj.cells);
            ContentObj.formularContent = editParas.fType + "(" + formularContent + ")";
            return ContentObj;
        },
        //预置公式属性
        presetContent: function (ContentObj) {
            controls.bbCode.name.val(ContentObj.bbCode);
            controls.company.name.val(ContentObj.company);
            controls.task.name.val(ContentObj.task);
            controls.menu.name.val(ContentObj.paper);
            controls.cells.name.val(ContentObj.cells);
            controls.nd.name.val(ContentObj.nd);
            controls.zq.name.val(ContentObj.zq);
        }
    };
    //返回值函数 
    var resultManagers = {

        success: function (data) {
            if (data.success) {
                controls.ProcedureControls = [];
                controls.ProcedureData = [];
                var strHml = "<table cellSpacing='5' cellPadding='0' style=' border: 1px solid #95B8E7; line-height:25px;'>";
                strHml += '<tr ><th>参数名</th><th>参数类型</th><th>参数值</th></tr>';
                $.each(data.obj, function (index, item) {
                    strHml += '<tr "><td>' + item.Name + '</td><td>' + item.Type + '</td><td><input type="text" style=" width:140px; height:18px;" id="name' + item.Id + '" class="ctPopEdit"/><input type="button" value="..." id="' + item.Id + '" style=" width:15px; height:23px; text-align:left; padding-left:0px;" class=" ctPopEdit PopButton" onclick="ProcedurePopEditClick(this)"/></td></tr>';
                    controls.ProcedureControls.push("name" + item.Id);
                    controls.ProcedureData.push(item);
                });

                strHml += "</table>";
                $("#qDiv").append(strHml);


            } else {
                alert(data.sMeg);
            }
        },
        fail: function (data) {

            alert(data.sMeg);
        }
    }

    function OpenDialog(title,okFunction) {
        $('#Dialog').dialog({
            title: title,
            width: 400,
            height: 300,
            closed: false,
            cache: false,
            modal: true,
            buttons: [
{
    text: '确定',
    iconCls: "icon-ok",
    handler: function () {
        okFunction();
        $('#Dialog').dialog("close");
    }

},
{
    text: '取消',
    iconCls: "icon-cancel",
    handler: function () {
        $('#Dialog').dialog("close");
    }
}
]
        });
    }
    //选择 是否行列转换
    //张双义    
    function swapState(isSwap) {
        if (isSwap) {
            controls.IsOrNotSwap = 1;
        } else {
            controls.IsOrNotSwap = 0;
        }
    }
    

</script> 
</head> 

<body>
    <div id="content" style="width: 100%; height: 100%; margin: 10px;">
        <div id="header" style="height: 37px;  margin-left:10px">
            <span class=" fontSize">公式内容：</span>
            <input class="textbox" id="fContent" style="width: 590px; height: 22px;" /><a href="#"class="easyui-linkbutton" style="background: linear-gradient(to bottom,#EFF5FF 0,#E0ECFF 100%);
                " onclick="ContentHelpClick()"data-options="iconCls:'icon-search'"></a>
            <a href="#" id="saveBtn" class="easyui-linkbutton" data-options="iconCls:'icon-save'"style="width: 60px; margin-left:10px; ">保存</a>
        </div>
        <div id="body">
            <div id="left" style="width: 180px; height:380px; float: left; border:1px solid #44aacc; margin-left:10px; padding:10px;"class="fontSize">
                
                <div style="display: block;">
                    <span >数据源类型：</span>
                    <div style=" margin-top:3px"> <input  style="" class="easyui-combobox" name="language" id="DataSource" data-options=" 
url:urls.DataSourceUrl, 
method: 'post', 
valueField: 'Id', 
textField: 'Name', 
panelHeight: 'auto'
"/></div>
                </div>
                <div style="display: block; margin-top:10px;">
                    <span>公式类型：</span>
                    <div style=" margin-top:3px"><input class="easyui-combobox" id="fType" name="language" data-options=" 
data:formularData, 
method: 'get', 
valueField: 'id', 
textField: 'text', 
panelHeight: 'auto', 
onHidePanel: formularManager.FoumulerTypeSelected
"/></div>
                </div>
                                <div style="display: block; margin-top:10px;">
                    <span>公式层级：</span>
                    <div style=" margin-top:3px"><input class="easyui-numberbox"  id="fLevel"></input>
                </div>
                <div id="displayDiv" style="display: block">
                    <span id="fIntroduction" class=" fontSize" style="line-height: 30px; margin-top: 5px;">
                       </span>
                </div>
               </div>
        </div>
            <div id="right" style="width: 520px;height:380px; float: left;border:1px solid #44aacc; margin-left:15px; padding:10px" class="fontSize">
                <div id="sqlDiv" style="display: none; padding-left:20px">
                    <span style=" font-size:13px"> 公式内容：</span><br />
                    <textarea id="fContentT" cols="55" rows="15" onkeydown="savePos(this)" onkeyup="savePos(this)"
                        onmousedown="savePos(this)" onmouseup="savePos(this)" onfocus="savePos(this)"
                        style="border:1px solid  #99aaff; margin-top:5px"></textarea>
                </div>
                <div id="bbDiv" style="display: none">
                    <table cellspacing="20px" >
                        <tr>
                            <td>
                                任务编号</td><td><div id="task" style=" display:inline">
                                </div>
                            </td>
                            <td>
                                报表底稿</td><td><div id="menu"  style=" display:inline">
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                报表编号</td><td><div id="bbCode" style=" display:inline">
                                </div>
                            </td>
                            <td>
                                单位</td><td><div id="company" style=" display:inline">
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                单元格</td><td><div id="cells"style=" display:inline">
                                </div>
                            </td>
                            <td>
                                年度</td><td><div id="nd" style=" display:inline">
                                </div>
                            </td>
                        </tr>
                        <tr>
                            
                            <td>
                                报表周期</td><td><div id="zq" style=" display:inline">
                                </div>
                            </td>
                            <td class=" fontSize" style=" text-align:left">
                                <span id="checkSpan">行列转换</span>
                                </td><td>
                                <div style=" display:inline">
                                    <input type="checkbox" id="RowColCheckBox"  onclick="swapState(checked)"/>
                                    <div id="layoutDiv"><input id="layoutType"  value="01" class="easyui-combobox" data-options="valueField:'Code',textField:'Name',panelHeight:'auto',
                                        data:[{Code:'01',Name:'表格布局'},{Code:'02',Name:'行布局'},{Code:'03',Name:'列布局'}] "  style=" display:none" />
                                    </div>
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
                <div id="qDiv" style="display: none; ">
                </div>
                <br />
                <div id="btnDiv" style="display: block; height:30px; padding-left:20px">
                    <p>
                        <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-help'" id="helpBtn"
                            title="参数帮助" style="width: 40px">...</a> <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add'"
                                id="addBtn" style="width: 80px">形成公式</a>
                    </p>
                </div>
            </div>
            <div style="clear:both; height:10px;"></div>
            <div  id="bottom" style="  width:737px;border:1px solid #44aacc; height:60px; margin:10px;   padding:10px" class="fontSize" >
            公式说明：
            </div>
        </div>
    </div>
    <div id="Dialog">    
    </div>
    <div id="DialogIframe"></div>
    <div id="Dialog2"></div>   
</body>
</html> 