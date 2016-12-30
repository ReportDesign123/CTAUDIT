<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WorkFlowDefinitionManager.aspx.cs" Inherits="Audit.ct.WorkFlow.WorkFlowDefinitionManager" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
       <title>流程管理</title>

        <script src="../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <link href="../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="../../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script src="../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <script src="../../lib/json2.js" type="text/javascript"></script>
    <script src="../../Scripts/Ct_WorkFlow.js" type="text/javascript"></script>
    <script type="text/javascript">
        var urls = {
            WorkFlowGridUrl: "../../handler/WorkFlowHandler.ashx?ActionType=" + WorkFlowAction.ActionType.Grid + "&MethodName=" + WorkFlowAction.Methods.WorkFlowMethods.DataGridWorkFlow + "&FunctionName=" + WorkFlowAction.Functions.WorkFlow,
            functionsUrl: "../../handler/WorkFlowHandler.ashx",
            WorkFlowDfAddUrl: "AddWorkFlowDefinition.aspx"
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
        //菜单管理器
        var menuManager = {
            AddMenu: function () {
                menuManager.OpenDialog(urls.WorkFlowDfAddUrl, "新建流程", "add");
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
                menuManager.OpenDialog(urls.WorkFlowDfAddUrl + ur, "编辑流程", "edit");
            },
            ///删除
            RemoveMenu: function () {
                var node = $("#roleGrid").datagrid("getSelected");
                var para = {};
                if (node != null) {
                    para["Id"] = node.Id;
                } else {
                    MessageManager.WarningMessage("请先选择一行再进行删除！");
                    return;
                } $.messager.confirm('系统提示', '你确定要删除当前单位?', function (r) {
                    if (!r) { return; }
                    else {
                        var parameters = CreateParameter(WorkFlowAction.ActionType.Post, WorkFlowAction.Functions.WorkFlow, WorkFlowAction.Methods.WorkFlowMethods.DeleteWorkFlow, para);
                        DataManager.sendData(urls.functionsUrl, parameters, resultManagers.successDel, resultManagers.fail);
                    }
                });
            },
            ///弹窗界面
            OpenDialog: function (url, title, type) {
                $('#Dialog').dialog({
                    title: title,
                    width: 673,
                    height: 460,
                    closed: false,
                    cache: false,
                    href: url,
                    modal: true,
                    style: "overflow:hidden",
                    buttons: [
                    {
                        text: '保存',
                        iconCls: "icon-ok",
                        handler: function () {
                            saveDatas();
                            ///首先保存workFolwOrder
                            if (!setWorkFlowOrder()) {
                                return;
                            }
                            if (type == "add") {
                                parameters = getParameters(WorkFlowAction.ActionType.Post, WorkFlowAction.Methods.WorkFlowMethods.AddWorkFlow);
                                if (parameters == null || parameters == "") { return; }
                                DataManager.sendData(urls.functionsUrl, parameters, resultManagers.success, resultManagers.fail);
                            } else if (type == "edit") {
                                parameters = getParameters(WorkFlowAction.ActionType.Post, WorkFlowAction.Methods.WorkFlowMethods.EditWorkFlowEntity);
                                if (parameters == null || parameters == "") { return; }
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
        var resultManagers = {
            success: function (data) {
                if (data.success) {
                    MessageManager.InfoMessage(data.sMeg);
                    $("#roleGrid").datagrid('reload');
                    $('#Dialog').dialog('close');
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
        function workFlowView(value, row, index) {
            var stageArr = value.split(";");
            return NodeManager.CreateTaskNode(stageArr[1], "");
        }

    </script>
</head>
<body>
    <table class="easyui-datagrid"  id="roleGrid"
                    data-options="singleSelect:true,method:'post',fit:true,fitColumns:true,url:urls.WorkFlowGridUrl,sortName:'CreateTime',sortOrder:'DESC',toolbar:toolBar,pagination:true">
            <thead>
                <tr>
                    <th data-options="field:'Id',width:100,align:'left',hidden:true"></th>
                    <th data-options="field:'Code',width:100,align:'left'">流程编号</th>
                    <th data-options="field:'Name',width:120,align:'left'">流程名称</th>
                    <th data-options="field:'Data',width:100,align:'center',hidden:true">Data</th>
                    <th data-options="field:'WorkFlowOrder',width:300,align:'left',formatter:workFlowView">流程过程</th>
                    <th data-options="field:'Creater',width:80">创建人</th>
                    <th data-options="field:'CreateTime',width:100,align:'left'">创建时间</th>
                </tr>
            </thead>
    </table>
    <div id="Dialog" />

    <script type="text/javascript">
    </script>
</body>
</html>

