<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReportDeleteManager.aspx.cs" Inherits="Audit.ct.basic.ReportDeleteManager" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
   <title>系统帮助</title>
    <script src="../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <link href="../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="../../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <link href="../../Styles/Common.css" rel="stylesheet" type="text/css" />
    <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
     <link href="../../Styles/Ct_Controls.css" rel="stylesheet" type="text/css" />
    <script src="../../Scripts/Ct_Controls.js" type="text/javascript"></script>
    <script src="../../lib/json2.js" type="text/javascript"></script>
    <script src="../../Scripts/ct/pub/PubHelp.js" type="text/javascript"></script>
    <script type="text/javascript">
        var ReportGrid;
        var urls = {
            ReportGridUrl:"../../handler/FormatHandler.ashx?ActionType=" + ReportFormatAction.ActionType.Grid + "&MethodName=" + ReportFormatAction.Methods.ReportFormatMenuMethods.ReportDataGrid + "&FunctionName=" + ReportFormatAction.Functions.ReportFormatMenu,
            functionsUrl: "../../handler/FormatHandler.ashx"
        };
        var classifiyHelp;
        //开始加载数据
        $(function () {
            classifiyHelp = $("#classifiy").PopEdit();
            classifiyHelp.btn.bind("click", function () {
                SearchManager.classifiyHelp();
            });
            ReportGrid = $("#ReportGrid").datagrid(
            {
                fit: true,
                toolbar: "#toolbar",
                url: urls.ReportGridUrl,
                sortOrder: "ASC",
                sortName: "bbCode",
                fitColumns: true,
                singleSelect: false,
                border: false,
                pagination: true,
                columns: [[
                { field: "Id", title: "id", checkbox: true, width: 120 },
                { field: "bbCode", title: "报表编号", width: 140 },
                { field: "bbName", title: "报表名称", width: 210 },
                { field: "ReportClassifyName", title: "报表分类", width: 100 }
                ]]
            });
        });
        //回车监听
        $("#bbCode").ready(function () {
            $("#bbCode").keypress(function (e) {
                var curKey = e.which;
                if (curKey == 13) {
                    SearchManager.doSearch();
                }
            });
        });
        $("#bbName").ready(function () {
            $("#bbName").keypress(function (e) {
                var curKey = e.which;
                if (curKey == 13) {
                   SearchManager.doSearch();
                }
            });
        });
        $("#classifiy").ready(function () {
            $("#classifiy").keypress(function (e) {
                var curKey = e.which;
                if (curKey == 13) {
                    SearchManager.doSearch();
                }
            });
        });
        function DeletReports() {
            var Reports = $("#ReportGrid").datagrid("getChecked");
            if (Reports.length == 0) { alert("请选择要删除的报表"); return; }
            $.messager.confirm('系统提示', '删除的数据将不可修复，是否确定要删除所选报表 ？', function (r) 
            {
                if (!r) { return; }
                var Ids="";
                Ids=(Reports[0].Id);
                for (var i = 1; i < Reports.length; ++i) {
                    Ids = Ids + "," + Reports[i].Id;
                }
                var param = { ids: Ids };
                param = CreateParameter(ReportFormatAction.ActionType.Post, ReportFormatAction.Functions.ReportFormatMenu, ReportFormatAction.Methods.ReportFormatMenuMethods.DeleteReports, param);
                DataManager.sendData(urls.functionsUrl, param, resultManagers.successDelet, resultManagers.fail);
            });
        }
        var resultManagers = {
            successDelet: function (data) {
                if (data.success) {
                    ReportGrid.datagrid("reload");
                    MessageManager.InfoMessage(data.sMeg);
                } else {
                    MessageManager.ErrorMessage(data.sMeg);
                }
            },
            fail: function (data) {
                MessageManager.ErrorMessage(data.sMeg);
            }
        }
        var SearchManager = {
            classifiyHelp: function () {
                var paras = { sortOrder: "ASC", sortName: "Code" }
                paras.parameter = CreateParameter(ReporClassifyAction.ActionType.Post, ReporClassifyAction.Functions.ReportClassify, ReporClassifyAction.Methods.ReportClassifyMethods.GetClassifiesList, {});
                paras.functionsUrl = "../../handler/FormatHandler.ashx";
                paras.columns = [[
                { field: "Id", title: "id", hidden: true, width: 120 },
                { field: "Code", title: "分类编号", width: 80 },
                    { field: "Name", title: "分类名称", width: 100 }
                    ]]
                paras.width = 375;
                paras.height = 420;
                pubHelp.setParameters(paras);
                pubHelp.OpenDialogWithHref("Dialog", "报表分类选择", "../pub/HelpList.aspx", SearchManager.getClassifyChoice, paras.width, paras.height, true);
            },
            getClassifyChoice: function () {
                var result = pubHelp.getResultObj();
                if (result && result.Id != undefined) {
                    classifiyHelp.name.val(result.Name);
                }
            },
            //查询接口
            doSearch: function () {
                var code = $("#bbCode").val();
                var name = $("#bbName").val();
                var classifyName = classifiyHelp.name.val();
                var obj = { bbCode: "", bbName: "", ReportClassifyName: "" };
                if (name && name != "") {
                    obj.bbName = name;
                }
                if (code && code != "") {
                    obj.bbCode = code;
                }
                if (classifyName && classifyName != "") {
                    obj.ReportClassifyName = classifyName;
                }
                var data = ReportGrid.datagrid('reload', obj);
            },
            //还原查询前的报表列表
            //参数：预存的box1Data
            restoreSearch: function () {
                $("#bbCode").val("");
                $("#bbName").val("");
                classifiyHelp.name.val("");
                ReportGrid.datagrid('reload', {});
            }
        };
        
        
      </script>
</head>
<body class="easyui-layout">
    <div data-options="region:'north',collapsible:false" style="height:32px; padding:2px;background-color:#E0ECFF ;overflow:hidden">
            <a href="#" class="easyui-linkbutton"  onclick="DeletReports()" iconcls="icon-cut" plain="true" style=" width:110">删除报表</a>
    </div>
    <div data-options="region:'center'">
        <div id="toolbar" style=" min-width:850px"  >
            <table style=" width:100%">
                <tr>
                    <td style=" width:60px">报表编号：</td><td style=" width:170px"><input class="easyui-validatebox textbox" id="bbCode" style="height:19px"/></td>
                    <td style=" width:60px">报表名称：</td><td style=" width:170px"><input class="easyui-validatebox textbox" id="bbName" style="height:19px"/></td>
                    <td style=" width:60px">报表分类：</td><td><div id="classifiy"></div></td>
                    <td style=" float:right"><a href="#" class="easyui-linkbutton" onclick="SearchManager.restoreSearch()" iconcls="icon-undo" plain="false">还原</a></td>
                    <td style=" float:right"><a href="#" class="easyui-linkbutton" onclick="SearchManager.doSearch()" iconcls="icon-search" plain="false" style=" margin-right:10px">查询</a></td>
                </tr>
            </table>
        </div>        
        <div id="ReportGrid" ></div>
    </div>
    <div id="Dialog"></div>
</body>
</html>