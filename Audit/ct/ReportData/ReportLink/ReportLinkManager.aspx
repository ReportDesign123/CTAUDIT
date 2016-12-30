<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReportLinkManager.aspx.cs" Inherits="Audit.ct.ReportData.ReportLink.ReportLinkManager" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
   <title>填报联查设置导入</title>
    <script src="../../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <link href="../../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="../../../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script src="../../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <link href="../../../Styles/Common.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        var urls = {
            datagrid: "../../../handler/FormatHandler.ashx?ActionType=" + ReportFormatAction.ActionType.Grid + "&MethodName=" + ReportFormatAction.Methods.FormularMenuMethods.DataGrid + "&FunctionName=" + ReportFormatAction.Functions.FormularMenu,
            DesignManager: "ct/ReportData/ReportLink/ReportLinkDefinition.aspx"
        };
        var FormularManager = {
            EidtLinkInf: function () {
                var node = $("#reportGrid").datagrid("getSelected");
                if (node) {
                    parent.NavigatorNode({ id: "080", text: "填报联查设置", attributes: { url: urls.DesignManager + "?Id=" + node.Id} });
                } else {
                    MessageManager.ErrorMessage("请选择一条要编辑的记录！");
                }
            }
        };
        /**获取查询参数*/
        //并查询
        function doSearch() {
            var par = { bbCode: "", bbName: "" };
            bbCode = $("#bbCode").val();
            bbName = $("#bbName").val();
            if (bbCode && bbCode != "") { par.bbCode = bbCode; }
            if (bbName && bbName != "") { par.bbName = bbName; }
            $("#reportGrid").datagrid('reload', par);
        }
        function cancelSearch() {
            $("#bbCode").val("");
            $("#bbName").val("");
            $("#reportGrid").datagrid('reload', {});
        }
        //回车监听
        //待改进
        //张双义
        $("#bbCode").ready(function () {
            $("#bbCode").keypress(function (e) {
                var curKey = e.which;
                if (curKey == 13) {
                    doSearch();
                }
            });
        });
        $("#bbName").ready(function () {
            $("#bbName").keypress(function (e) {
                var curKey = e.which;
                if (curKey == 13) {
                    doSearch();
                }
            });
        }); 
    </script>
</head>
<body class="easyui-layout">
    <div data-options="region:'north'" style="height:32px; padding:2px; background-color:#E0ECFF;overflow:hidden">
    <a class="easyui-linkbutton" data-options="iconCls:'icon-examine16'" style=" width:90px" onclick="FormularManager.EidtLinkInf();" plain="true"> 联查设置</a>
    </div>
    <div data-options="region:'center'">
        <div id="toobar" style=" min-width:800px" class="datagrid-toolbar">
            <table style=" width:100%"><tr>
            <td style=" width:60px">报表编号</td><td style=" width:170px"><input id = "bbCode"class="easyui-validatebox textbox" /></td>
            <td style=" width:60px">报表名称</td><td><input id = "bbName"class="easyui-validatebox textbox" /></td>
                <td style=" float:right"> <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-undo'" onclick="cancelSearch()" style=" margin-left:10px">重置</a></td>
                <td style=" float:right"> <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="doSearch()" style="" >查询</a></td>
            </tr>
            </table>
        </div>
        <table class="easyui-datagrid"  id="reportGrid"
                data-options="singleSelect:true,method:'post',fit:true,border:false,fitColumns:true,toolbar:toobar,url:urls.datagrid,sortName:'bbCode',sortOrder:'ASC',pagination:true,onDblClickRow:FormularManager.EidtLinkInf">
            <thead>
                <tr>
                    <th data-options="field:'Id',width:80,align:'left',hidden:true">报表编号</th>
                    <th data-options="field:'bbCode',width:180,align:'left',sortable:true">报表编号</th>
                    <th data-options="field:'bbName',width:190,align:'left',sortable:true">报表名称</th>
                    <th data-options="field:'createTime',width:150,align:'left',sortable:true">创建时间</th>     
                </tr>
            </thead>
        </table>
    </div>
    <div id="Dialog" />
    <div id = "classifiyTable"></div>
</body>
</html>
