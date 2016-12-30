<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AuditTaskManager.aspx.cs" Inherits="Audit.ct.AuditTask.AuditTaskManager" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>用户管理</title>
    <script src="../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <link href="../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="../../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script src="../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <link href="../../Styles/Common.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        var gridTb;
        var urls = {
            userGridUrl: "../../handler/AuditTaskHandler.ashx?ActionType=" + AuditTaskAction.ActionType.Grid + "&MethodName=" +AuditTaskAction.Methods.AuditTaskManagerMethods.GetDataGrid + "&FunctionName=" +AuditTaskAction.Functions.AuditTaskManager,
            functionsUrl: "../../handler/AuditTaskHandler.ashx",
            AddRole: "AddTask.aspx"
        };

        $(
        function () {
            InitializeDataTable();
        }
        );

        function InitializeDataTable() {
            gridTb = $("#gridTb").datagrid(
            {
                toolbar: toolBar,
                url: urls.userGridUrl,
                pagination: true,
                fitColumns: true,
                rownumbers: true,
                singleSelect: true,
                fit: true,
                sortName: "CreateTime",
                sortOrder: "DESC",
                columns: [[
            { field: "Id", title: "Id", hidden: true },
            { field: "Code", title: "编号", width: 100 },
            { field: "Name", title: "名称", width: 150 },
            { field: "TaskType", title: "审计计划类型", width: 150,
                formatter: function (value, row, index) {
                    if (value == "01") {
                        return "经营业绩审计";
                    } else if (value == "02") {
                        return "专项审计";
                    } else if (value == "03") {
                        return "离任审计";
                    }
                }
            },
             { field: "BeginDate", title: "开始日期", width: 120 },
              { field: "EndDate", title: "结束日期", width: 120 },
            { field: "State", title: "状态", width: 100,
                formatter: function (value, row, index) {
                    if (value == "1") {
                        return "启用";
                    } else {
                        return "禁用";
                    }
                }
            },
            { field: "CreateTime", title: "创建时间", width: 120 }
            ]]
            }
            );
        }
        var toolBar = [
       {
           text: '增加',
           iconCls: 'icon-add',
           handler: function () {
               menuManager.AddMenu();
           }
       }, {
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
       }
        ];

        var menuManager = {
            AddMenu: function () {
                menuManager.OpenDialog(urls.AddRole, "创建报表底稿", "add");
            },
            EditMenu: function () {
                var row = $("#gridTb").datagrid("getSelected");
                var ur = "";
                if (row) {
                    ur = "?Id=" + row.Id;
                } else {
                    MessageManager.WarningMessage("请先选择一行在进行编辑！");
                    return;
                }
                menuManager.OpenDialog(urls.AddRole + ur, "编辑报表底稿", "edit");

            },
            RemoveMenu: function () {
                var node = $("#gridTb").datagrid("getSelected");
                var para = {};
                if (node != null) {
                    para["Id"] = node.Id;
                } else {
                    MessageManager.WarningMessage("请先选择一行在进行删除！");
                    return;
                }
                var parameters = CreateParameter(AuditTaskAction.ActionType.Post,AuditTaskAction.Functions.AuditTaskManager, AuditTaskAction.Methods.AuditTaskManagerMethods.Delete, para);
                DataManager.sendData(urls.functionsUrl, parameters, resultManagers.RemoveSuccess, resultManagers.fail);
            },
            OpenDialog: function (url, title, type) {
                $('#Dialog').dialog({
                    title: title,
                    width: 400,
                    height: 300,
                    closed: false,
                    cache: false,
                    href: url,
                    modal: true,
                    buttons: [{
                        text: '保存',
                        iconCls: "icon-ok",
                        handler: function () {
                            if (type == "add") {
                                var parameters = getParameters(AuditTaskAction.ActionType.Post, AuditTaskAction.Methods.AuditTaskManagerMethods.Save);
                                DataManager.sendData(urls.functionsUrl, parameters, resultManagers.success, resultManagers.fail);
                            } else if (type == "edit") {
                                var parameters = getParameters(AuditTaskAction.ActionType.Post, AuditTaskAction.Methods.AuditTaskManagerMethods.Edit);
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
                $('#Dialog').dialog('open');
            }

        };

        var resultManagers = {

            success: function (data) {
                if (data.success) {
                    resultManagers.RemoveSuccess(data);
                    $('#Dialog').dialog("close");

                } else {
                    MessageManager.ErrorMessage(data.sMeg);
                }
            },
            fail: function (data) {

                MessageManager.ErrorMessage(data.toString);
            },
            RemoveSuccess: function (data) {
                MessageManager.InfoMessage(data.sMeg);
                $("#gridTb").datagrid('reload');
                $("#gridTb").datagrid('unselectAll');
            }
        };

        var eventManager = {
            selectEvent: function (rowIndex, rowData) {
                var id = rowData.Id;
                var ur = urls.TreeUrl + "&Id=" + id;
                $("#tree").tree({ url: ur });
            }
        };
    </script>
</head>
<body>
<table id="gridTb"></table>
<div id="Dialog"></div>
</body>
</html>


