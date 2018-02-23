<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ExportRelationReports.aspx.cs" Inherits="Audit.ct.ExportReport.ExportRelationReports" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>模板关联报表选择</title>
    <script src="../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <link href="../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="../../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>

    <link href="../../Styles/Ct_Controls.css" rel="stylesheet" type="text/css" />
    <script src="../../Scripts/Ct_Controls.js" type="text/javascript"></script>
    <script src="../../lib/json2.js" type="text/javascript"></script>
    <script src="../../Scripts/ct/pub/PubHelp.js" type="text/javascript"></script>
    <script src="../../Scripts/ct_dialog.js"></script>
     <script type="text/javascript">
         var urls = {
             zqUrl: "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Get + "&MethodName=GetDictionaryListByClassType&FunctionName=" + BasicAction.Functions.DictionaryManager + "&ClassType=BBZQ",
             paperUrl: "../../handler/FormatHandler.ashx?ActionType=" + ReportFormatAction.ActionType.Grid + "&MethodName=" + ReportFormatAction.Methods.FormularMenuMethods.GetDataGridByTaskCode + "&FunctionName=" + ReportFormatAction.Functions.FormularMenu,
             reporturl: "../../handler/FormatHandler.ashx?ActionType=" + ReportFormatAction.ActionType.Grid + "&MethodName=" + ReportFormatAction.Methods.FormularMenuMethods.GetReportsByPaperCode + "&FunctionName=" + ReportFormatAction.Functions.FormularMenu
         }
         var paramControl = {}
         var resultParam = {};
         var parentparam;
         $(function () {
             parentparam = dialog.para();// window.dialogArguments;
             paramControl.Task = $("#Task").PopEdit();
             paramControl.Task.btn.bind("click", function () {
                 ControlManager.TaskBt_click();
             });
             paramControl.Paper = $("#paperList").datagrid({
                 sortName: 'CreateTime',
                 sortOrder: 'DESC',
                 fit: true,
                 nowrap: true,
                 border: false,
                 pagination: true,
                 rownumbers: false,
                 fitColumns: true,
                 frozenColumns: true,
                 singleSelect: false,
                 columns: [[{ field: "Id", title: "Id", width: 80, hidden: true },
{ field: "Code", title: "审计底稿编号", width: 100 },
{ field: "Name", title: "审计底稿名称", width: 100 }
                    ]],
                 onSelect: function (index, paper) { ControlManager.LoadRepoer(paper); }
             });
             paramControl.Report = $("#reportList").datagrid({
                 sortName: 'bbCode',
                 sortOrder: 'DESC',
                 fit: true,
                 nowrap: true,
                 border: false,
                 toolbar: "#toolbar",
                 pagination: true,
                 rownumbers: false,
                 fitColumns: true,
                 frozenColumns: true,
                 singleSelect: false,
                 columns: [[{ field: "Id", title: "Id", checkbox: true },
{ field: "bbCode", title: "报表编号", width: 100 },
{ field: "bbName", title: "报表名称", width: 100 }
                ]]
             });
         });

         var ControlManager = {
             TaskBt_click: function () {
                 var paras = { url: "", columns: [], sortName: "", sortOrder: "", NameField: "Name", CodeField: "Code", defaultField: { dftBy: "Code", dft: ""} };
                 paras.url = "../../handler/AuditTaskHandler.ashx?ActionType=" + AuditTaskAction.ActionType.Grid + "&MethodName=" + AuditTaskAction.Methods.AuditTaskManagerMethods.GetDataGrid + "&FunctionName=" + AuditTaskAction.Functions.AuditTaskManager;
                 paras.columns = [[{ field: "Id", title: "Id", width: 80, hidden: true },
{ field: "Code", title: "任务编号", width: 80 },
{ field: "Name", title: "任务名称", width: 200}]];
                 paras.sortName = "CreateTime";
                 paras.sortOrder = "DESC";
                 paras.defaultField.dft = paramControl.Task.name.val();
                 paras.width = 340;
                 paras.height = 420;
                 pubHelp.setParameters(paras);
                 pubHelp.OpenDialogWithHref("HelpDialog", "审计类型选择", "../pub/HelpDialogEasyUi.htm", ControlManager.TaskBt_Save, paras.width, paras.height, true);

             },
             TaskBt_Save: function () {
                 var result = pubHelp.getResultObj();
                 if (result && result.Id) {
                     paramControl.Task.name.val(result.Name);
                     paramControl.Task.value.val(result.Code);
                     resultParam.Task = result;
                     ControlManager.LoadPaper(result);
                 }
             },
             LoadPaper: function (Task) {
                 var url = urls.paperUrl + "&TaskCode=" + Task.Code;
                 paramControl.Paper.datagrid({
                     url: url
                 });
             },
             LoadRepoer: function (paper) {
                 var url = urls.reporturl + "&PaperCode=" + paper.Code;
                 paramControl.Report.datagrid({
                     url: url
                 });
             },
             SetCycle: function () {
                 if (parentparam && parentparam.CycleType) {
                     $("#CycleType").combobox("setValue", parentparam.CycleType);
                 }
             },
             resultManager: {
                 suerBtnClick: function () {
                     var rows = paramControl.Report.datagrid("getSelections");
                     window.returnValue = rows;
                     window.close();
                 },
                 CancleBtnClick: function () {
                     window.close();
                 }
             }

         }
         function ReportSearch(value, name) {
             var para = {};
             para[name] = value;
             paramControl.Report.datagrid("reload", para);
         }
         function freeSearch() {
             $("#searchReport").searchbox("setValue", "");
             paramControl.Report.datagrid("reload", {});
         }
       </script>
</head>
<body class="easyui-layout" style=" border:0px;overflow:hidden">
   
    <div id="west" data-options="region:'west',split:true" style=" border:0px;width:400px">
        <div class="easyui-layout" data-options="fit:true" >
            <div id="leftNorth" data-options="region:'north',split:false"style=" height:150px;">               
                <table style="margin:auto; padding-left:35px; padding-top:15px;width:100%" cellspacing="10px">
                    <tr><td>审计任务</td><td><div id="Task"></div></td></tr>
                   <%-- <tr><td>报表年度</td><td><input id="year" type="text" value=""  class="easyui-combobox" /></td></tr>--%>
                    <tr><td>周期类型</td><td><input id="CycleType" type="text"  class="easyui-combobox" data-options="url:urls.zqUrl,valueField:'Code',textField:'Name',panelHeight:'auto',onLoadSuccess:ControlManager.SetCycle" /></td></tr>
                </table>
            </div>
             <div id="leftCenter" data-options="region:'center'"  style=" height:200px;">
                    <table id="paperList"></table>
            </div>
        </div>
    </div>
    <div id="center" data-options="region:'center'">
        <div id="toolbar" style=" padding:4px" class="datagrid-toolbar">
            <input id="searchReport" class="easyui-searchbox" style="width:300px" data-options="searcher:ReportSearch,prompt:'请输入查询内容',menu:'#searchMenu'"></input> 
            <div id="searchMenu" style="width:120px"> 
                <div data-options="name:'bbCode',iconCls:'icon-search'">报表编号</div> 
                <div data-options="name:'bbName',iconCls:'icon-search'">报表名称</div> 
            </div> 
            <a href="#" class="easyui-linkbutton" onclick="freeSearch()" iconcls="icon-undo" style=" margin-left:15px">重置</a>
        </div>
        <table id="reportList"></table>
    </div>
    <div id="south" data-options="region:'south'" style="height:45px;padding-top:5px; background-color:#E0E0E0" >
        <a  href="#" class="easyui-linkbutton" style="margin-right:20px;float:right;width:75px; height:28px; padding-top:5px; outline:none;" iconcls="icon-save" onclick="ControlManager.resultManager.CancleBtnClick()"><span style="font-size:14px">返回</span></a>
        <a  href="#" class="easyui-linkbutton" style="margin-right:15px;float:right;width:75px; height:28px; padding-top:5px; outline:none;" iconcls="icon-add" onclick="ControlManager.resultManager.suerBtnClick()" ><span style="font-size:14px">保存</span></a>
    </div>
    <div id="HelpDialog"></div>
</body>
</html>
