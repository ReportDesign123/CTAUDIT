<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FormularManager.aspx.cs" Inherits="Audit.ct.Format.FormularManager" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>公式管理</title>
   
    <script src="../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <link href="../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="../../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script src="../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <link href="../../Styles/Common.css" rel="stylesheet" type="text/css" />
    
       <script src="../../Scripts/ct_dialog.js" type="text/javascript"></script>

    <script type="text/javascript">

        var urls = {
            datagrid: "../../handler/FormatHandler.ashx?ActionType=" + ReportFormatAction.ActionType.Grid + "&MethodName=" + ReportFormatAction.Methods.FormularMenuMethods.DataGrid + "&FunctionName=" + ReportFormatAction.Functions.FormularMenu,
            functionsUrl: "../../handler/FormatHandler.ashx",
            AddFormular: "ct/Format/AddFormular.aspx"
        };
        var classifiyData;

        var FormularManager = {
            AddFormular: function () {
                var node = $("#reportGrid").datagrid("getSelected");
                //               var width = window.screen.width-10;
                //               var height = window.screen.height-10;
                //               window.showModalDialog(urls.AddFormular, node, "dialogHeight:" + height + "px;dialogWidth:" + width + "px;resizable:no;");
                if (node) {
                    var url = CreateGeneralUrl(urls.AddFormular, node);
                    parent.NavigatorNode({ id: "0001", text: node.bbName, attributes: { url: url} });
                } else {
                    alert("请选择要编辑的报表");
                }
            }
        };

       var resultManagers = {
           successLoad: function (data) {
               classifiyData = data.obj.Rows;
           }
       }
       /**获取查询参数*/
       //并查询
       function doSearch() {
           var par = { bbCode: "", bbName: "" };
           var bbCode = $("#bbCode").val();
           var bbName = $("#bbName").val();
           if (bbCode && bbCode != "") { par.bbCode = bbCode; }
           if (bbName && bbName != "") { par.bbName = bbName; }
           $("#reportGrid").datagrid('reload', par);
       }
       function cancelSearch() {
           $("#bbCode").val("");
           $("#bbName").val("");
           $("#reportGrid").datagrid('reload',{});
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
    <a class="easyui-linkbutton" data-options="iconCls:'icon-examine16'" style=" width:90px" onclick="FormularManager.AddFormular();" plain="true"> 公式管理</a>
</div>
<div data-options="region:'center'">
    <div id="toobar" style="min-width:650px " class="datagrid-toolbar">
        <table style=" width:100%"><tr>   
            <td style="width:60px">报表编号</td>
            <td style="width:170px"><input id = "bbCode"class="easyui-validatebox textbox" /></td>
            <td style="width:60px">报表名称</td>
            <td style="width:170px"> <input id = "bbName"class="easyui-validatebox textbox" /></td>
            <td style=" float:right"><a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-undo'" onclick="cancelSearch()" style="">重置</a></td>
            <td style=" float:right"><a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="doSearch()" style=" margin-right:10px">查询</a></td>
            </tr>
        </table>
    </div>
    <table class="easyui-datagrid"  id="reportGrid"
            data-options="singleSelect:true,method:'post',fit:true,border:false,fitColumns:true,toolbar:toobar,url:urls.datagrid,sortName:'bbCode',sortOrder:'ASC',pagination:true,onDblClickRow:FormularManager.AddFormular">
        <thead>
            <tr>
                <th data-options="field:'Id',width:80,align:'left',hidden:true">Id</th>
                <th data-options="field:'bbCode',width:180,align:'left',sortable:true">报表编号</th>
                <th data-options="field:'bbName',width:190,align:'left',sortable:true">报表名称</th>
                <th data-options="field:'createTime',width:150,align:'left',sortable:true">创建时间</th>
            </tr>
        </thead>
    </table>
</div>
    <div id="Dialog" />
</body>
</html>
