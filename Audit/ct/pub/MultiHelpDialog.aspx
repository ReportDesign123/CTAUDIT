<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MultiHelpDialog.aspx.cs" Inherits="Audit.ct.pub.MultiHelpDialog" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>系统帮助</title>
        <script src="../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <script src="../../lib/easyUI/easyloader.js" type="text/javascript"></script>
    <script src="../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <link href="../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
<link href="../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script type="text/javascript">
        var helpGrid;
        var para;
        var urls = {
            DicCGridUrl: "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Grid + "&MethodName=" + BasicAction.Methods.DicManagerMethods.GetDictionaryListByClass + "&FunctionName=" + BasicAction.Functions.DictionaryManager + "&classId=HHS"
        };
        $(
        function () {
            para = window.dialogArguments;
            var url = para.url;
            helpManager.InitializeHelp(url, para.sortName, para.sortOrder, para.columns,para.height);
        }
        );

        var helpManager = {
        
            InitializeHelp: function (url, sortName, sortOrder, columns,height) {
             height=height-76;
                helpGrid = $("#helpGrid").datagrid(
                {               
                    url: url,
                    height:height,
                    sortName: sortName,
                    sortOrder: sortOrder,
                    pagination: true,
                    title: "",
                    columns: columns,
                    onDblClickRow: function (rowIndex, rowData) {
                        window.returnValue = rowData;
                        window.close();
                    },
                    toolbar: "#tb"
                }
                );
            }
        };

        function doSearch(value, name) {
            var obj = {};
            if (para.NameField && para.NameField.length > 0) {
                var namesArr = para.NameField.split(",");
                for (var i = 0; i < namesArr.length; i++) {
                    obj[namesArr[i]] = value;
                }
            }

            helpGrid.datagrid('load', obj);

        }

        var ClickManager = {
            SelectClick: function () {

                window.returnValue = helpGrid.datagrid("getSelections");
                 window.close();
            },
            CancelClick: function () {
                window.close();
            }
        };
    </script>
</head>
<body>
  <div id="tb" style="padding:5px;height:auto; font-size:12px;">
     名称: <input class="easyui-searchbox" id="search" data-options="prompt:'过滤名称',searcher:doSearch" style="width:220px"></input>
     </div>
   <table id="helpGrid"></table>
   <div id="bottom" style=" height:23px; position:absolute;  bottom:10px; right:5px;">
    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-save',onClick:ClickManager.SelectClick">选择</a>
        <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-cut',onClick:ClickManager.CancelClick">取消</a>
   </div>
</body>
</html>