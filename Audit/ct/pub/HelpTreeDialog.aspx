<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="HelpTreeDialog.aspx.cs" Inherits="Audit.ct.pub.HelpTreeDialog" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>系统帮助</title>
    <%--<title> 树形系统帮助</title>--%>
        <script src="../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <link href="../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="../../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script src="../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <script src="../../Scripts/ct/pub/PubHelp.js" type="text/javascript"></script>
   <%--报告上传下载--%>
   <%--报告封存--%>
   <%--报告报告审核--%>
   <%--新建用户角色添加--%>
   <%--新建用户职务添加--%>
   <%--问题参数单位选择--%>
   
</head>
<body class="easyui-layout">
 <script type="text/javascript">
     var cascading = true; //是否级联选择
     var dataTable = {};
     var HelpTreeDialogManager = {
         doSearch: function (value, name) {
             $("#TreeDiv").css("display", "none");
             $("#DataDiv").css("display", "block");
             $("#RankCheckbox").attr("disabled", "true");
             var para = {};
             para[name] = value;
             if (!dataTable.datagrid) {
                 var url = pubHelp.getParameters().dataUrl;
                 HelpTreeDialogManager.LoadDataTable(pubHelp.getParameters(), url);
                 dataTable.datagrid("reload", para);
             } else {
                 dataTable.datagrid("reload", para);
             }
         },
         freeSearch: function () {
             $("#SearchBox").searchbox("setValue", "");
             dataTable.datagrid("reload", {});
         },
         changeCascad: function () {
             cascading = !cascading;
         },
         surBtnClick: function () {
             var results;
             if ($("#TreeDiv").css("display") == "block") {
                 results = $("#treeTable").treegrid("getSelections");
             } else {
                 results = $("#dataTable").treegrid("getSelections");
             }
             return results;
         },
         changeView: function () {
             if ($("#TreeDiv").css("display") == "block") {
                 $("#TreeDiv").css("display", "none");
                 $("#DataDiv").css("display", "block");
                 $("#RankCheckbox").attr("disabled", "true");
                 if (!dataTable.datagrid) {
                     var url = pubHelp.getParameters().dataUrl;
                     HelpTreeDialogManager.LoadDataTable(pubHelp.getParameters(), url);
                 }
             } else {
                 $("#RankCheckbox").attr("disabled", false);
                 $("#TreeDiv").css("display", "block");
                 $("#DataDiv").css("display", "none");
             }
         },
         LoadDataTable: function (dataParam, url) {
             dataTable = $("#dataTable").datagrid({
                 url: url,
                 height: 340,
                 border: false,
                 pagination: true,
                 rownumbers: false,
                 fitColumns: true,
                 frozenColumns: true,
                 sortName: dataParam.sortName,
                 sortOrder: dataParam.sortOrder,
                 singleSelect: dataParam.singleSelect,
                 columns: dataParam.columns,
                 onDblClickRow: function (rowIndex, rowData) {
                     pubHelp.setResultObj([rowData]);
                     pubHelp.CloseDialog();
                 }
             });
         }
     };
     $(function () {
         var treeParas = pubHelp.getParameters();
         pubHelp.setResultObjFunc(HelpTreeDialogManager.surBtnClick);
         InitializeTreeGrid(treeParas);
     });
     function InitializeTreeGrid(treeParas) {
         if (treeParas.UseTo && treeParas.UseTo == "search") {
             $("#RankCheckbox").attr("disabled", "true");
             $("#treeTable").treegrid({
                 url: treeParas.url,
                 singleSelect: treeParas.singleSelect,
                 border:false,
                 fitColumns: true,
                 idField: treeParas.idField,
                 treeField: treeParas.treeField,
                 columns: treeParas.columns,
                 onDblClickRow: function (row) {
                     pubHelp.setResultObj([row]);
                     pubHelp.CloseDialog();
                 }
             });
         } else {
             $("#treeTable").treegrid({
                 url: treeParas.url,
                 border: false,
                 fitColumns: true,
                 singleSelect: treeParas.singleSelect,
                 idField: treeParas.idField,
                 treeField: treeParas.treeField,
                 columns: treeParas.columns,
                 onSelect: function (row) {
                     if (!cascading) return;
                     var children = $("#treeTable").treegrid("getChildren", row.Id);
                     $.each(children, function (index, child) {
                         $("#treeTable").treegrid("select", child.Id);
                     });
                 },
                 onUnselect: function (row) {
                     if (!cascading) return;
                     var children = $("#treeTable").treegrid("getChildren", row.Id);
                     $.each(children, function (index, child) {
                         $("#treeTable").treegrid("unselect", child.Id);
                     });
                 }
             });
         }
     }    
    </script>
    <div data-options="region:'north'">
        <div id="toolbar" class="datagrid-toolbar" style="height:100%;">
            <table>
                <tr>
                <td><input type="checkbox" id="RankCheckbox" checked="checked" style="width:15px; height:15px; margin-top:-2px" onchange="HelpTreeDialogManager.changeCascad()"/></td>
                <td>级联</td>
                <td style="padding-left:15px">
                <input id="SearchBox" class="easyui-searchbox" style="width:180px" data-options="searcher:HelpTreeDialogManager.doSearch,prompt:'请输入查询内容',menu:'#SearchMenu'"/> 
                <div id="SearchMenu" style="width:100px"> 
                    <div data-options="name:'Code',iconCls:'icon-search'">编号</div> 
                    <div data-options="name:'Name',iconCls:'icon-search'">名称</div> 
                </div> 
                </td><td>
                    <a class="easyui-linkbutton" onclick="HelpTreeDialogManager.freeSearch()" iconcls="icon-undo" style=" margin-left:15px">重置</a>
                    <a class="easyui-linkbutton" onclick="HelpTreeDialogManager.changeView()" iconcls="icon-reload" style=" margin-left:10px">切换</a>
                </td>
            </tr>
            </table>
              </div>
    </div>
    <div data-options="region:'center'" style="overflow:auto;height:342px">
        <div id="DataDiv" style=" height:100%; width:100%; display:none"><table id="dataTable"></table></div>
        <div id="TreeDiv" style=" height:100%; width:100%;"><table id="treeTable" ></table></div>
    </div>
</body>
</html>
