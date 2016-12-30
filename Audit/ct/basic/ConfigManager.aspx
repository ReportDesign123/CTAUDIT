<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ConfigManager.aspx.cs" Inherits="Audit.ct.basic.ConfigManager" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>参数管理</title>
      <script src="../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <link href="../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="../../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script src="../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <script type="text/javascript">
        var urls = {
            ConfigGridUrl: "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Grid + "&MethodName=" + BasicAction.Methods.SystemMethods.DataGrid + "&FunctionName=" + BasicAction.Functions.System, //.DataSource,
            functionsUrl: "../../handler/BasicHandler.ashx",
            AddConfigUrl: "AddConfig.aspx"
        };
        //菜单管理器
        var menuManager = {
            ///编辑
            EditMenu: function () {
                var row = $("#roleGrid").datagrid("getSelected");
                var ur = "";
                if (row) {
                    ur = "?Id=" + row.Id;
                } else {
                    MessageManager.WarningMessage("请先选择一行再进行编辑！");
                    return;
                }
                menuManager.OpenDialog(urls.AddConfigUrl + ur, "修改参数", "edit");
            },
            ///弹窗界面
            OpenDialog: function (url, title, type) {
                $('#Dialog').dialog({
                    title: title,
                    width: 290,
                    height: 220,
                    closed: false,
                    cache: false,
                    href: url,
                    modal: true,
                    buttons: [
                    {
                        text: '保存',
                        iconCls: "icon-ok",
                        handler: function () {
                            var parameters = {};
                            parameters = getParameters(BasicAction.ActionType.Post, BasicAction.Methods.SystemMethods.Edit);
                            DataManager.sendData(urls.functionsUrl, parameters, resultManagers.success, resultManagers.fail);
                        }
                    },
                     {
                         text: '取消',
                         iconCls: "icon-cancel",
                         handler: function () {
                             $('#Dialog').dialog("close");
                         }
                     }
                    ]
                });
            }
        };
        var resultManagers = {
            success: function (data) {
                if (data.success) {
                    MessageManager.InfoMessage(data.sMeg);
                    $("#roleGrid").datagrid('reload');
                    $('#Dialog').dialog("close");
                    $("#roleGrid").datagrid('unselectAll');
                } else {
                    MessageManager.ErrorMessage(data.sMeg);
                }
            },
            fail: function (data) {
                MessageManager.ErrorMessage(data.toString);
            }
        }
        var eventManager = {
            selectEvent: function (rowIndex, rowData) {
                var id = rowData.Id;
                var ur = urls.TreeUrl + "&Id=" + id;
                $("#tree").tree({ url: ur });
            }
        };
      
        function search(value,name) {
            $('#testa').searchbox('selectName', name);
            $('#testa').searchbox('setValue', value);
            var ur="&Name=" + value;
            $('#roleGrid').datagrid({
                url: urls.ConfigGridUrl + ur 
            });
        }	
    </script>
</head>
<body>
    <div id="toobar">
      <a href="#" class="easyui-linkbutton" onclick="menuManager.EditMenu()" iconcls="icon-edit" plain="true">编辑参数</a>
     <input id="testa" class="easyui-searchbox" value="" prompt="参数名"searcher="search" name="Name" />
     <a class="easyui-linkbutton" style="float:right" iconcls="icon-undo" plain="true" >重置</a>
     </div>
    <table class="easyui-datagrid"  id="roleGrid"
           data-options="singleSelect:true,method:'post',fit:true,fitColumns:true,url:urls.ConfigGridUrl,sortName:'Name',sortOrder:'ASC',toolbar:toobar,pagination:true">
        <thead>
            <tr>
                <th data-options="field:'Name',width:200,align:'left',query:true">参数名</th>
                <th data-options="field:'Value',width:200,align:'left'">参数值</th>
                <th data-options="field:'Remark',width:500,align:'left'">参数说明</th>
                <th data-options="field:'Id',width:200,align:'center',hidden:true">ID</th>  
             
                         
            </tr>
        </thead>

    </table> 
     <div id="Dialog" />
   
         

</body>
</html>
