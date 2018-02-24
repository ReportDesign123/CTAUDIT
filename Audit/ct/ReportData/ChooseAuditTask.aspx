<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ChooseAuditTask.aspx.cs" Inherits="Audit.ct.ReportData.ChooseAuditTask" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>填报任务切换</title>

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
    <script src="../../Scripts/ct_dialog.js"></script>
    <script src="../../lib/ligerUI/js/core/base.js" type="text/javascript"></script>
    <script src="../../lib/ligerUI/js/core/inject.js" type="text/javascript"></script>
    <script src="../../lib/ligerUI/js/ligerui.min.js" type="text/javascript"></script>

    <script src="../../Scripts/ct/pub/PubHelp.js" type="text/javascript"></script>
    <script type="text/javascript">
        var controls = { auditType: {}, auditTask: {}, auditPaper: {} };
        var paras = { AuditType: { name: "", value: "" }, AuditDate: "", AuditTask: { name: "", value: "" }, AuditPaper: { name: "", value: "" }, auditZqVisible: "0", auditPaperVisible: "0", auditZqType: "01", Nd: "", Zq: "", WeekReport: { ID: "", Code: "", Name: "", Ksrq: "", Jsrq: "" } };
        var urls = {
            AuditTypeUrl: "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Get + "&MethodName=GetDictionaryListByClassType&FunctionName=" + BasicAction.Functions.DictionaryManager + "&ClassType=RWLX",
            AuditTaskUrl: "../../handler/ReportDataHandler.ashx?ActionType=" + ReportDataAction.ActionType.Grid + "&MethodName=" + ReportDataAction.Methods.FillReportMethods.GetAuditTasksDataGrid + "&FunctionName=" + ReportDataAction.Functions.FillReport,
            AuditPaperUrl: "../../handler/ReportDataHandler.ashx?ActionType=" + ReportDataAction.ActionType.Grid + "&MethodName=" + ReportDataAction.Methods.ReportAggregationMethods.GetAuditPaperDataGrid + "&FunctionName=" + ReportDataAction.Functions.ReportAggregation,
            ReportZq: "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Get + "&MethodName=GetDictionaryListByClassType&FunctionName=" + BasicAction.Functions.DictionaryManager + "&ClassType=BBZQ",
            ReportCycle: "../../handler/ReportDataHandler.ashx",
            functionsUrl: "../../handler/BasicHandler.ashx"
        };
        $(
        function () {
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
            $("#sureBtn").bind("click", function () {
                var para = { AuditType: { name: "", value: "" }, AuditDate: "", AuditTask: { name: "", value: "" }, AuditPaper: { name: "", value: "" }, auditZqVisible: "0", auditPaperVisible: "0", auditZqType: "01", Nd: "", Zq: "", WeekReport: { ID: "", Name: "", Ksrq: "", Jsrq: "" } };
                if (controls.auditTask.value.val() == "") {
                    alert("审计任务不能为空"); return;
                }
                para.AuditType.value = controls.auditType.value.val();
                para.AuditType.name = controls.auditType.name.val();
                para.AuditTask.value = controls.auditTask.value.val();
                para.AuditTask.name = controls.auditTask.name.val();
                para.AuditDate = $("#auditDate").datebox("getValue");
                para.AuditPaper.name = controls.auditPaper.name.val();
                para.AuditPaper.value = controls.auditPaper.value.val();


                if (paras && paras.auditZqVisible && paras.auditZqVisible == "1") {

                    para.auditZqType = $("#zqType").combobox("getValue");
                    switch (para.auditZqType) {
                        case "01":
                            para.Nd = $('#txtNd').combobox("getValue");
                            para.Zq = para.Nd;
                            break;
                        case "02":
                            para.Nd = $('#txtNd').combobox("getValue");
                            para.Zq = $('#txtYf').combobox("getValue");
                            break;
                        case "03":
                            para.Nd = $('#txtNd').combobox("getValue");
                            para.Zq = $('#txtJd').combobox("getValue");
                            break;
                        case "04":
                            //$('#txtRq').datebox("setValue", paras["Zq"]);
                            para.Zq = $('#txtRq').datebox("getValue");

                            para.Nd = paras.Zq.substr(0, 4);
                            break;
                        case "05":

                            para.Zq = $('#txtRq').datebox("getValue");
                            para.Nd = para.Zq.substr(0, 4);
                            LoadZBInfor(para.Zq);
                            para.WeekReport.ID = paras.WeekReport.ID;
                            para.WeekReport.Name = paras.WeekReport.Name;
                            para.WeekReport.Ksrq = paras.WeekReport.Ksrq;
                            para.WeekReport.Jsrq = paras.WeekReport.Jsrq;

                            para.Zq = paras.WeekReport.Code;// $('#txtRq').datebox("getValue");

                            break;

                    }
                }
                var modalid = $(window.frameElement).attr("modalid");
                dialog.setVal(para); 
                dialog.close(modalid);
               
            });

            paras =dialog.para();//window.dialogArguments;
            if (paras && paras.AuditTask && paras.AuditTask.value) {
                controls.auditTask.value.val(paras.AuditTask.value);
                controls.auditTask.name.val(paras.AuditTask.name);
                controls.auditType.name.val(paras.AuditType.name);
                controls.auditType.value.val(paras.AuditType.value);

                $("#auditDate").datebox("setValue", paras.AuditDate);
                if (paras.AuditPaper && paras.AuditPaper.value) {
                    controls.auditPaper.value.val(paras.AuditPaper.value);
                    controls.auditPaper.name.val(paras.AuditPaper.name);
                }

            } else {

                controls.auditType.value.val("01");
                controls.auditType.name.val("经营业绩审计");
                $("#auditDate").datebox("setValue", Ct_Tool.GetCurrentDate());
            }
            if (paras && paras.auditPaperVisible && paras.auditPaperVisible == "1") {
                $("#paperTd").css("display", "table-row");
            } else {
                $("#paperTd").css("display", "none");
            }


            if (paras && paras.auditZqVisible && paras.auditZqVisible == "1") {
                $("#auditDateTr").css("display", "none");
                $("#auditTd").append("<tr><td>报表周期</td><td><input id='zqType' readonly ='readonly' /></td>   </tr> ");
                $('#zqType').combobox({
                    url: urls.ReportZq,
                    valueField: 'Code',
                    textField: 'Name',
                    onSelect: eventManager.zqSelect_Event
                });
                if (paras.auditZqType) {
                    $('#zqType').combobox("setValue", paras.auditZqType);
                    LoadZq(paras.auditZqType);
                } else {
                    $('#zqType').combobox("setValue", "01");
                    $('#zqType').combobox("setText", "年报");
                    LoadZq("01");
                }

            }
        }
        );

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
            },
            zqSelect_Event: function (recode) {
                LoadZq(recode.Code);
                paras.auditZqType = recode.Code;
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
                    LoadZq(result.DefaultZq);
                }
            }
        };
        function LoadZq(zqType) {
            var para = { ReportType: zqType };
            para = CreateParameter(ReportDataAction.ActionType.Post, ReportDataAction.Functions.FillReport, ReportDataAction.Methods.FillReportMethods.GetReportCycle, para);
            DataManager.sendData(urls.ReportCycle, para, resultManager.success, resultManager.fail, false);
        }
        //周报信息
        function LoadZBInfor(value) {
            var para = { YWRQ: value };
            para = CreateParameter(BasicAction.ActionType.Post, BasicAction.Functions.CycleManager, BasicAction.Methods.CycManagerMethods.GetCycleInfor, para);
            DataManager.sendData(urls.functionsUrl, para, resultManager.successZB, resultManager.fail, false);

        }
        var resultManager = {
            success: function (data) {
                if (data.success) {
                    var zqType = $("#zqType").combobox("getValue");
                    $("tr[name='zq']").remove();
                    if (!paras.auditZqType || paras.auditZqType != zqType) paras.Zq = data.obj.CurrentZq;
                    if (!paras.Nd || paras.auditZqType != zqType) paras.Nd = data.obj.CurrentNd;
                    switch (zqType) {
                        case "01":
                            $("#auditTd").append('<tr name="zq"><td  >年度</td><td ><input type="text" id="txtNd"/></td></tr>');
                            $('#txtNd').combobox({
                                data: data.obj.Nds,
                                valueField: 'value',
                                textField: 'name'
                            });
                            $('#txtNd').combobox("setValue", paras["Zq"]);
                            break;
                        case "02":
                            $("#auditTd").append('<tr name="zq"><td  >年度</td><td ><input type="text" id="txtNd"/></td></tr>');
                            $("#auditTd").append('<tr name="zq"><td  >月份</td><td ><input type="text" id="txtYf"/></td></tr>');
                            if (!paras.Zq) paras["Zq"] = data.obj.CurrentZq;
                            if (!paras.Nd) paras["Nd"] = data.obj.CurrentNd;
                            $('#txtNd').combobox({
                                data: data.obj.Nds,
                                valueField: 'value',
                                textField: 'name'
                            });
                            $('#txtNd').combobox("setValue", paras["Nd"]);
                            $('#txtYf').combobox({
                                data: data.obj.Cycles,
                                valueField: 'value',
                                textField: 'name'
                            });
                            $('#txtYf').combobox("setValue", paras["Zq"]);
                            break;
                        case "03":
                            $("#auditTd").append('<tr name="zq"><td  >年度</td><td ><input type="text" id="txtNd"/></td></tr>');
                            $("#auditTd").append('<tr name="zq"><td  >季度</td><td ><input type="text" id="txtJd"/></td></tr>');
                            $('#txtNd').combobox({
                                data: data.obj.Nds,
                                valueField: 'value',
                                textField: 'name'
                            });
                            $('#txtNd').combobox("setValue", paras["Nd"]);
                            $('#txtJd').combobox({
                                data: data.obj.Cycles,
                                valueField: 'value',
                                textField: 'name'
                            });
                            $('#txtJd').combobox("setValue", paras["Zq"]);
                            break;
                        case "04":
                            $("#auditTd").append('<tr name="zq"><td  >日期</td><td ><input type="text" id="txtRq"/></td></tr>');
                            $('#txtRq').datebox({
                                required: true
                            });
                            $('#txtRq').datebox("setValue", paras["Zq"]);
                            break;
                        case "05":
                            $("#auditTd").append('<tr name="zq"><td  >日期</td><td ><input type="text" id="txtRq"/></td></tr>');
                            $('#txtRq').datebox({
                                required: true
                            });
                            var mydate = new Date();
                            $('#txtRq').datebox("setValue", mydate.toLocaleDateString());
                            $("#txtRq").ligerDateEditor(
                             {
                                 showTime: false,
                                 onChangeDate: function (value) {
                                 }
                             }
                                );

                            break;
                    }
                } else {
                    MessageManager.ErrorMessage(data.sMeg);
                }
            },
            successZB: function (data) {
                if (data.success) {
                    if (data && data.obj) {
                        paras.WeekReport.ID = data.obj.Id;
                        paras.WeekReport.Name = data.obj.Name;
                        paras.WeekReport.Jsrq = data.obj.JSRQ;
                        paras.WeekReport.Ksrq = data.obj.KSRQ;
                        paras.WeekReport.Code = data.obj.Code;
                    }
                    else {
                        paras.WeekReport.ID = "";
                        paras.WeekReport.Name = "";
                        paras.WeekReport.Jsrq = "";
                        paras.WeekReport.Ksrq = "";
                        paras.WeekReport.Code = "";
                    }
                }
            },
            fail: function (data) {
                MessageManager.ErrorMessage(data.toString);
            }
        };

    </script>
</head>

<body style="background-color: #E0ECFF;">
    <table id="auditTd" style="clear: both; margin-left: auto; margin-right: auto; margin-left: 80px; margin-top: 60px;" cellspacing="20px">

        <tr>
            <td>审计类型</td>
            <td>
                <div id="auditType"></div>
            </td>
        </tr>
        <tr id="auditDateTr">
            <td>审计日期</td>
            <td>
                <input class="easyui-datebox" id="auditDate" /></td>
        </tr>
        <tr>
            <td>审计任务</td>
            <td>
                <div id="auditTask"></div>
            </td>
        </tr>
        <tr id="paperTd" style="display: none">
            <td>审计底稿</td>
            <td>
                <div id="auditPaper"></div>
            </td>
        </tr>
    </table>

    <hr style="border: 0; background-color: #95B8E7; height: 1px; position: absolute; bottom: 55px; left: 0px;" />
    <div style="display: block; padding: 2; text-align: right; margin-right: 10px; position: absolute; bottom: 40px; right: 20px;">

        <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-save'" style="margin-right: 5px" id="sureBtn">确定</a>
        <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-no'" onclick="dialog.close($(window.frameElement).attr('modalid'));">关闭</a>
    </div>
    <div id="Dialog"></div>
</body>
</html>
