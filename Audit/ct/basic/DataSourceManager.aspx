<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DataSourceManager.aspx.cs" Inherits="Audit.ct.basic.DataSourceManager" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>数据源管理</title>
        <script src="../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <link href="../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="../../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script src="../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <link href="../../Styles/Common.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        var urls = {
            DataSourceGridUrl: "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Grid + "&MethodName=" + BasicAction.Methods.DataSourceMethods.DataGrid + "&FunctionName=" + BasicAction.Functions.DataSource,
            functionsUrl: "../../handler/BasicHandler.ashx",
            DataSourceAddU: "DataSourceAdd.aspx"
        };
        ///功能图标toolbar
        var toolBar = [
       {
           text: '增加',
           iconCls: 'icon-add',
           handler: function () {
               menuManager.AddMenu();
           }
       }, '-', {
           text: '修改',
           iconCls: 'icon-edit',
           handler: function () {
               menuManager.EditMenu();
           }
       }, '-', {
           text: '删除',
           iconCls: 'icon-cut',
           handler: function () {
               menuManager.RemoveMenu();
           }
       }, '-', {
           text: '设为默认',
           iconCls: 'icon-tip',
           handler: function () {
               menuManager.SetDefaultMenu();
           }
       }
       ];
       //菜单管理器
       var menuManager = {
           AddMenu: function () {
               menuManager.OpenDialog(urls.DataSourceAddU, "增加数据源", "add");
           },
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
               menuManager.OpenDialog(urls.DataSourceAddU + ur, "编辑数据源", "edit");
           },
           ///删除
           RemoveMenu: function () {
               var node = $("#roleGrid").datagrid("getSelected");
               var para = {};
               if (node != null) {
                   para["Id"] = node.Id;
               } else {
                   MessageManager.WarningMessage("请先选择一行在进行删除！");
                   return;
               } $.messager.confirm('系统提示', '你确定要删除当前单位?', function (r) {
                   if (!r) { return; }
                   else {
                       var parameters = CreateParameter(BasicAction.ActionType.Post, BasicAction.Functions.DataSource, BasicAction.Methods.DataSourceMethods.Delete, para);
                       DataManager.sendData(urls.functionsUrl, parameters, resultManagers.successDel, resultManagers.fail);
                   }
               });
           },
           ///设置默认
           SetDefaultMenu: function () {
               var node = $("#roleGrid").datagrid("getSelected");
               var para = {};
               if (node != null) {
                   para["Id"] = node.Id;
               } else {
                   MessageManager.WarningMessage("请先选择一行再进行操作！");
                   return;
               }
               var parameters = CreateParameter(BasicAction.ActionType.Post, BasicAction.Functions.DataSource, BasicAction.Methods.DataSourceMethods.SetDefault, para);
               DataManager.sendData(urls.functionsUrl, parameters, resultManagers.successDel, resultManagers.fail);
           },
           ///弹窗界面
           OpenDialog: function (url, title, type) {
               $('#Dialog').dialog({
                   title: title,
                   width: 380,
                   height: 460,
                   closed: false,
                   cache: false,
                   href: url,
                   modal: true,
                   buttons: [
                    {
                        text: '保存',
                        iconCls: "icon-ok",
                        handler: function () {
                            ///选择测试链接的提示内容
                            sesectMassage(true);
                            testLink();
                            if (getTestResult()) {
                                var parameters = {};
                                if (type == "add") {
                                    parameters = getParameters(BasicAction.ActionType.Post, BasicAction.Methods.DataSourceMethods.Save);
                                    DataManager.sendData(urls.functionsUrl, parameters, resultManagers.success, resultManagers.fail);

                                } else if (type == "edit") {
                                    parameters = getParameters(BasicAction.ActionType.Post, BasicAction.Methods.DataSourceMethods.Edit);
                                    DataManager.sendData(urls.functionsUrl, parameters, resultManagers.success, resultManagers.fail);
                                }
                            }
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
           successDel: function (data) {
               if (data.success) {
                   MessageManager.InfoMessage(data.sMeg);
                   $("#roleGrid").datagrid('reload');
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
        function inUsing(value, row, index) {
             if (value==1) {
                return "默认数据源";
            } else {
                return "非默认";
            }
        }
        function inWorking(value, row, index) {
            if (value == 1) {
                return "已启用";
            } else {
                return "未启用";
            }
        }
    </script>
</head>
<body >
  <table class="easyui-datagrid"  id="roleGrid"
           data-options="singleSelect:true,method:'post',fit:true,fitColumns:true,url:urls.DataSourceGridUrl,sortName:'Name',sortOrder:'ASC',toolbar:toolBar,pagination:true">
        <thead>
            <tr>
                <th data-options="field:'Id',width:150,align:'left',hidden:true"></th>
                <th data-options="field:'Name',width:150,align:'left'">服务器名</th>
                
                 <th data-options="field:'DbType',width:100,align:'left'">数据库类型</th>
                 <th data-options="field:'Db',width:150,align:'left'">数据库名</th>
                 <th data-options="field:'Server',width:150,align:'left'">服务器地址</th>
                 <th data-options="field:'UserName',width:150,align:'left'">用户名</th>
                 <th data-options="field:'UserPassword',width:150,align:'center',hidden:true">密码</th>
                 <th data-options="field:'Default',width:300,align:'left',formatter:inUsing">是否默认</th>

                 <th data-options="field:'State',width:150,align:'left',formatter:inWorking ,hidden:true">是否启用</th>

                                
            </tr>
        </thead>
    </table>
     <div id="Dialog" />
</body>
</html>
