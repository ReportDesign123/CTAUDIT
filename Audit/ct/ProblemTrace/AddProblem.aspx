<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddProblem.aspx.cs" Inherits="Audit.ct.ProblemTrace.AddProblem" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>新建问题</title>
    <script src="../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <link href="../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="../../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script src="../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
     <script src="../../Scripts/Ct_Controls.js" type="text/javascript"></script>
    <link href="../../Styles/Ct_Controls.css" rel="stylesheet" type="text/css" />
    <script src="../../Scripts/Ct_Tool.js" type="text/javascript"></script>
    <script src="../../Scripts/ct/pub/PubHelp.js" type="text/javascript"></script>
</head>
<body>
 <script type="text/javascript">
     var problemTypeUrl = "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Get + "&MethodName=GetDictionaryListByClassType&FunctionName=" + BasicAction.Functions.DictionaryManager + "&ClassType=WTLB";
     var problemLevelUrl = "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Get + "&MethodName=GetDictionaryListByClassType&FunctionName=" + BasicAction.Functions.DictionaryManager + "&ClassType=WTJB";
     var ProblemReportId = "<%=rpe.ReportId %>";
     var ProblemCompanyId = "<%=rpe.CompanyId %>";
     var reportHelp;
     var companyHelp;
     //获取参数
     function getParameters(actionType, methodName) {
         var params = {};

         params["Title"] = $("#Title").val();
//         params["DependOn"] = $("#DependOn").val();
         params["Type"] = $('#Type').combobox('getValue');
         params["Rank"] = $("#Rank").combobox('getValue');
         params["ReportId"] = reportHelp.value.val();
         params["CompanyId"] = companyHelp.value.val();

         params["ActionType"] = actionType;
         params["FunctionName"] = ProblemTraceAction.Functions.ProblemTraceAction;
         params["MethodName"] = methodName;

         var contentIf = getGridIframe();
         if (contentIf && contentIf != "") {
             params["Content"] = contentIf.getHtml();
         } else {
             MessageManager.InfoMessage("问题内容获取失败！");
             return;
         }
         if (params.Title == "") {
             MessageManager.InfoMessage("请输入问题标题！");
             return;
         }
         if (params.Type == "") {
             MessageManager.InfoMessage("请选择问题类型");
             return;
         }
         if (params.Content == "") {
             MessageManager.InfoMessage("请添加问题内容！");
             return;
         }
         if (params.ReportId == "") {
             MessageManager.InfoMessage("请选择报表！");
             return;
         }
         if (params.CompanyId == "") {
             MessageManager.InfoMessage("请选择单位！");
             return;
         }
         var id = $("#Id").val();
         if (id != null && id != undefined && id != "") {
             params["Id"] = id;
         }
         return params;
     }
     var pHelpManager = {
         ReportHelp_Click: function () {
             var paras = { url: "", columns: [], sortName: "", sortOrder: "", NameField: "bbName", CodeField: "bbCode", defaultField: { dftBy: "Id", dft: ""} };
             var parameter = MainManager.problemManager.creatParameter();
             paras.url = pUrls.ReportHelpUrl + "&paperId=" + parameter.PaperId;
             paras.columns = [[
                        { title: 'id', field: 'Id', width: 180, hidden: true },
			            { field: 'bbCode', title: '编号', width: 150, sortable: true },
                        { field: 'bbName', title: '名称', width: 190, sortable: true }
                            ]];
             paras.sortName = 'bbCode';
             paras.sortOrder = 'ASC';
             paras.defaultField.dft = reportHelp.value.val();
             paras.width = 450;
             paras.height = 450;
             pubHelp.setParameters(paras);
             pubHelp.OpenDialogWithHref("paramHelpDialog", "系统帮助", "../pub/HelpDialogEasyUi.htm", pHelpManager.ReportHelp_Save, paras.width, paras.height, true);
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
             treeParas.UseTo = "search";
             treeParas.singleSelect = true;
             treeParas.dataUrl = pUrls.CompanyListHelp;
             treeParas.sortName = 'Code';
             treeParas.sortOrder = 'ASC';
             treeParas.width = 450;
             treeParas.height = 450;
             pubHelp.setParameters(treeParas);
             pubHelp.OpenDialogWithHref("paramHelpDialog", "系统帮助", "../pub/HelpTreeDialog.aspx", pHelpManager.CompanyHelp_save, treeParas.width, treeParas.height, true);
         },
         ReportHelp_Save: function () {
             var result = pubHelp.getResultObj();
             if (result) {
                 reportHelp.value.val(result.Id);
                 reportHelp.name.val(result.bbName);
             }
         },
         CompanyHelp_save: function () {
             var result = pubHelp.getResultObj();
             if (result) {
                 if (result.length > 0) {
                     companyHelp.name.val(result[0].Name);
                     companyHelp.value.val(result[0].Id);
                 }
             }
         }
     };
     $(function () {
         reportHelp = $("#Report").PopEdit();
         companyHelp = $("#Company").PopEdit()
         companyHelp.btn.bind("click", function () {
             pHelpManager.CompanyHelp_Click();
         });
         reportHelp.btn.bind("click", function () {
             pHelpManager.ReportHelp_Click();
         });
         reportHelp.name.val(ProblemReportId);
         reportHelp.value.val(ProblemReportId);
         companyHelp.name.val(ProblemCompanyId);
         companyHelp.value.val(ProblemCompanyId);
     });
     ///调用参数：<iframe id="Frame"...></iframe>
     ///用途：获取Frame对象
     ///张双义
     function getGridIframe() {
         gridFrame = window.frames["editFrame"];
         return gridFrame;
     }
     function setFrameHtml() {
         var frame = getGridIframe();
         var htm = document.getElementById("ProblemContent").innerHTML;
         frame.setHtml(htm);
     }
     function setTareaParam() {
         var param = { width: "463px", height: "200px" };
         return param;
     }
     
   </script>
    <div style="display:none" id="ProblemContent"><%=rpe.Content %></div>
     <input id="Id"value="<%=rpe.Id %>" type="hidden"/>
        <table style="margin-top:15px;margin-left:20px" cellspacing="10px">
            <tr><td>问题标题</td><td colspan="3"><input id="Title" type="text" value="<%=rpe.Title %>" class="easyui-validatebox textbox" style=" width:400px; height:25px;"  /></td></tr>
            <%--<tr style=" height:33px"><td>问题依据：</td><td><input id="DependOn" type="text"value="" class="easyui-validatebox textbox" style=" width:240px; height:25px;"/></td></tr>--%>   
            <tr>
                <td>问题类型</td><td><input id="Type" type="text" value="<%=rpe.Type %>" class="easyui-combobox" data-options=" valueField:'Code', textField:'Name',url:problemTypeUrl" /></td>
                <td>问题级别</td><td><input id="Rank" type="text" value="<%=rpe.Rank %>"class="easyui-combobox" data-options=" valueField:'Code', textField:'Name',url:problemLevelUrl" /></td>
            </tr>
            <tr>
                <td>报表</td><td><div id="Report"></div></td>
                <td>单位</td><td><div id="Company"></div></td>
            </tr>
            <tr><td>问题内容</td></tr>
        </table>
        <table style="margin-top:-10px;margin-left:20px">
            <tr><td>
                <iframe id="editFrame" src="../ReportAudit/Editor.aspx" frameborder="0" style=" width:500px; height:220px;padding:0px;overflow:hidden;margin:0px"onload="setFrameHtml();"></iframe>
                </td>
            </tr>
        </table>
</body>
</html>
