<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WorkFlowBusinessManager.aspx.cs" Inherits="Audit.ct.WorkFlow.WorkFlowBusinessManager" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
       <title>业务流程管理</title>
        <script src="../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <link href="../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="../../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script src="../../Scripts/AjaxTrigger.js" type="text/javascript"></script>

     <script src="../../Scripts/Ct_Controls.js" type="text/javascript"></script>
    <link href="../../Styles/Ct_Controls.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript">
        var urls = {
            WorkFlowGridUrl: "../../handler/WorkFlowHandler.ashx?ActionType=" + WorkFlowAction.ActionType.Grid + "&MethodName=" + WorkFlowAction.Methods.WorkFlowMethods.DataGridBusinessEntity + "&FunctionName=" + WorkFlowAction.Functions.WorkFlow,
            functionsUrl: "../../handler/WorkFlowHandler.ashx",
            WorkFlowAddUrl: "AddWorkFlowBusiness.aspx"
        };
        ///功能图标toolbar
        var toolBar = [{
            text: '新建流程',
            iconCls: 'icon-add',
            handler: function () {
                menuManager.AddMenu();
            }
        }, '-', {
            text: '流程编辑',
            iconCls: 'icon-edit',
            handler: function () {
                menuManager.EditMenu();
            }
        }, '-', {
            text: '删除流程',
            iconCls: 'icon-cut',
            handler: function () {
                menuManager.RemoveMenu();
            }
        }];
        ///菜单管理器
        ///包含功能：增加、编辑、删除
        ///张双义
        var menuManager = {
            ///增加
            AddMenu: function () {
                menuManager.OpenDialog(urls.WorkFlowAddUrl, "新建流程", "add");
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
                menuManager.OpenDialog(urls.WorkFlowAddUrl + ur, "编辑流程", "edit");
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
                        var parameters = CreateParameter(WorkFlowAction.ActionType.Post, WorkFlowAction.Functions.WorkFlow, WorkFlowAction.Methods.WorkFlowMethods.DeleteBusinessEntity, para);
                        DataManager.sendData(urls.functionsUrl, parameters, resultManagers.successDel, resultManagers.fail);
                    }
                });
            },
            ///弹窗界面
            OpenDialog: function (url, title, type) {
                $('#Dialog').dialog({
                    title: title,
                    width: 350,
                    height: 250,
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
                            if (type == "add") {
                                parameters = getParameters(WorkFlowAction.ActionType.Post, WorkFlowAction.Methods.WorkFlowMethods.AddBusinessEntity);
                                if (parameters == "" || parameters == null) { return; }
                                DataManager.sendData(urls.functionsUrl, parameters, resultManagers.success, resultManagers.fail);
                            } else if (type == "edit") {
                                parameters = getParameters(WorkFlowAction.ActionType.Post, WorkFlowAction.Methods.WorkFlowMethods.EditBusinessEntity);
                                if (parameters == "" || parameters == null) { return; }
                                DataManager.sendData(urls.functionsUrl, parameters, resultManagers.success, resultManagers.fail);
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
        ///消息处理菜单 
        ///输出：提示框
        ///张双义
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
    </script>
</head>
<body>
  <table class="easyui-datagrid"  id="roleGrid"
           data-options="singleSelect:true,method:'post',fit:true,url:urls.WorkFlowGridUrl,sortName:'BeginTime',sortOrder:'DESC',toolbar:toolBar,pagination:true">
        <thead>
            <tr>
                <th data-options="field:'Id',width:150,align:'center',hidden:true"></th>
                <th data-options="field:'BusinessCode',width:150,align:'center'">业务流程编号</th>
                <th data-options="field:'Name',width:150,align:'center'">业务流程名称</th>
                <th data-options="field:'WorkFlowId',width:100,align:'center',hidden:true">工作流Id</th>
                <th data-options="field:'WorkFlowName',width:150,align:'center'">工作流</th>
                <th data-options="field:'BeginTime',width:150,align:'center'">创建时间</th>
            </tr>
        </thead>
  </table>
     <div id="Dialog" />
</body>
</html>