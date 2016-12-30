<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ChooseModules.aspx.cs" Inherits="Audit.ct.ReportAudit.ChooseModules" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
 <title>公式管理</title>
   
    <script src="../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <link href="../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="../../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script src="../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
   
</head>
<body style=" overflow:hidden">
 <script type="text/javascript">
     var urls = {
         datagrid: "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Get + "&MethodName=GetDictionaryListByClassType&FunctionName=" + BasicAction.Functions.DictionaryManager + "&ClassType=SJMK"
     };
     $(function () {
         allRow = $("#ListGrid").datagrid("getRows");
         if (!allRow.length > 0) {
             $("#ListGrid").datagrid("reload");
         }
     });
     function checkSaved() {
         var para = dialogArguments;
         var allRow = $("#ListGrid").datagrid("getRows");
         $.each(para, function (code, node) {
             $.each(allRow, function (index, row) {
                 if (node.Code == row.Code) {
                     $("#ListGrid").datagrid("selectRow", index);
                 }
             });
         });
     }

     function ChangeModuleList() {
         var Modules = $("#ListGrid").datagrid("getSelections");
         var data = [];
         $.each(Modules, function (index, node) {
             data.push({Code:node.Code,Name:node.Name});
         });
         window.returnValue = data;
         window.close();
     };
    </script>
  <table class="easyui-datagrid"  id="ListGrid"
            data-options="singleSelect:false,method:'post',height:260,fitColumns:true,url:urls.datagrid,sortName:'Code',sortOrder:'ASC',onLoadSuccess:checkSaved">
        <thead>
            <tr>
              <th data-options="field:'Id',align:'left',checkbox:true">报表编号</th>
                <th data-options="field:'Code',width:120,sortable:true">模块编号</th>
                <th data-options="field:'Name',width:150,sortable:true">模块名称</th>
            </tr>
        </thead>
    </table>
    <div style="bottom:0px;position:absolute;height:35px; padding-top:10px; width:100%" class="datagrid-toolbar" >
        <a  href="#" class="easyui-linkbutton"  style="right:30px; position:absolute; float:right; outline:none; width:60px" iconcls="icon-save" onclick="ChangeModuleList()" >保存</a>
    </div>
</body>
</html>
