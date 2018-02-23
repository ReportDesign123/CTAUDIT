<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="HelpDialog.aspx.cs" Inherits="Audit.ct.pub.HelpDialog" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>系统帮助</title>
        <script src="../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <script src="../../lib/easyUI/easyloader.js" type="text/javascript"></script>
    <script src="../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <link href="../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
<link href="../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
         <script src="../../Scripts/ct_dialog.js"></script>
    <script type="text/javascript">
//*********************************
        //推荐弹窗高度：大于等于400px
        //推荐弹窗宽度325px/大于400px
        //@张双义
//*********************************
        var helpGrid;
        var para;
        var gridData;
        var urls = {
            DicCGridUrl: "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Grid + "&MethodName=" + BasicAction.Methods.DicManagerMethods.GetDictionaryListByClass + "&FunctionName=" + BasicAction.Functions.DictionaryManager + "&classId=HHS"
        };
        $(function () {
            para = dialog.para();// window.dialogArguments;
            var url = para.url;
            helpManager.InitializeHelp(url, para.sortName, para.sortOrder, para.columns);
      
        });
        
        var helpManager = {
            InitializeHelp: function (url, sortName, sortOrder, columns) {

                helpGrid = $("#helpGrid").datagrid(
                {
                    fit: true,
                    url: url,
                    sortName: sortName,
                    sortOrder:sortOrder,
                    pagination: true,
                    title: "",
                    fitColumns: true,
                    columns: columns,
                    onDblClickRow: function (rowIndex, rowData) {
                        window.returnValue = rowData;
                        window.close();
                    },
                    toolbar:"#tb",
                    onLoadSuccess: function (data) {
                        if (para.defaultField && para.defaultField.dftBy && para.defaultField.dft) {
                            if (para.defaultField.dftBy.length > 0 && para.defaultField.dft.length > 0) {
                                var namesArr = para.defaultField.dftBy;
                                var rows = data.rows;
                                var dft = para.defaultField.dft;
                                for (var i = 0; i < rows.length; i++) {
                                    var temp = rows[i][namesArr];
                                    if (temp == dft) {
                                        $(this).datagrid('selectRow', i);
                                        break;
                                    }
                                }
                            }
                        }
                    }
                }
                );
            }
        };

        //增加了一条对code的查询。
        //使用条件：引入时参数内需声明CodeField
        //张双义
        function doSearch(value, name) {
            var obj = {};
            var name = $("#Name").searchbox("getValue");
            var code = $("#Code").searchbox("getValue");
            if (name && name != "") {
                if (para.NameField && para.NameField.length > 0) {
                    var namesArr = para.NameField.split(",");
                    for (var i = 0; i < namesArr.length; i++) {
                        obj[namesArr[i]] = name;
                    }
                }
            }
            if (code && code != "") {
                if (para.CodeField && para.CodeField.length > 0) {
                    var namesArr = para.CodeField.split(",");
                    for (var i = 0; i < namesArr.length; i++) {
                        obj[namesArr[i]] = code;
                    }
                }
            }

            var data = helpGrid.datagrid('reload', obj);
        }
    </script>
</head>
<body>
  <div id="tb" style="padding:5px;height:auto; font-size:12px; width:100%">
     编号: <input class="easyui-searchbox" id="Code" name ="code" data-options="prompt:'过滤编号或值',searcher:doSearch" style="width:110px"/>
     名称: <input class="easyui-searchbox" id="Name" name="name" data-options="prompt:'过滤名称',searcher:doSearch" style="width:110px"/>
     </div>
   <table id="helpGrid"></table>
   
</body>
</html>
