<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RoleManager.aspx.cs" Inherits="Audit.ct.basic.RoleManager" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>角色管理</title>
    <script src="../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <link href="../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="../../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script src="../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <script src="../../lib/json2.js" type="text/javascript"></script>
    <script type="text/javascript">
        var urls = {
            roleGridUrl: "../../handler/BasicHandler.ashx?ActionType=grid&MethodName=DataGrid&FunctionName=Role",
            functionsUrl: "../../handler/BasicHandler.ashx",
            AddRole: "AddRole.aspx"
        };
        var roleGrid;

        $(
        function () {
            $("#panel").panel({
                title: "权限保存",
                fit: true,
                tools: [
            {
                iconCls: 'icon-save',
                handler: function () {
                    var row = $("#roleGrid").datagrid("getSelected");
                    if (!row) { alert("请选择角色"); return; }
                    var notes = $("#tree").tree('getChecked', ['checked']);
                    var rows = [];
                    $.each(notes, function (index) {
                        var parameter = { Id: "", RoleId: "", FunctionId: "", State: "" };
                        parameter.FunctionId = notes[index].id;
                        parameter.RoleId = row.Id;
                        parameter.State = "01";
                        rows.push(parameter);
                    });

                    notes = $("#tree").tree('getChecked', ['indeterminate']);
                    $.each(notes, function (index) {
                        var parameter = { Id: "", RoleId: "", FunctionId: "", State: "" };
                        parameter.FunctionId = notes[index].id;
                        parameter.RoleId = row.Id;
                        parameter.State = "02";
                        rows.push(parameter);
                    });
                    var obj = {};
                    rows = JSON2.stringify(rows);
                    obj.rows = rows;

                    var para = CreateParameter(BasicAction.ActionType.Post, BasicAction.Functions.RoleMenu, BasicAction.Methods.RoleMenuMethods.BatchUpdate, obj);
                    DataManager.sendData(urls.functionsUrl, para, resultManagers.success, resultManagers.fail);
                }
            }
            ]
            });
        }
        );
        var toolBar = [
       {
           text: '增加',
           iconCls: 'icon-add',
           handler: function () {
               menuManager.AddMenu();
           }
       },'-', {
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
                menuManager.OpenDialog(urls.AddRole, "创建角色", "add");
            },
            EditMenu: function () {
                var row = $("#roleGrid").datagrid("getSelected");
                var ur = "";
                if (row) {
                    ur = "?Id=" + row.Id;
                } else {
                    MessageManager.WarningMessage("请先选择一行在进行编辑！");
                    return;
                }
                menuManager.OpenDialog(urls.AddRole + ur, "编辑角色", "edit");
            },
            RemoveMenu: function () {
                var node = $("#roleGrid").datagrid("getSelected");
                var para = {};
                if (node != null) {
                    para["Id"] = node.Id;
                } else {
                    MessageManager.WarningMessage("请先选择一行在进行删除！");
                    return;
                }
                var parameters = CreateParameter(BasicAction.ActionType.Post, BasicAction.Functions.RoleMenu, BasicAction.Methods.RoleMenuMethods.Delete, para);
                DataManager.sendData(urls.functionsUrl, parameters, resultManagers.successDel, resultManagers.fail);
            },
            OpenDialog: function (url, title, type) {
                $('#Dialog').dialog({
                    title: title,
                    width: 300,
                    height: 200,
                    closed: false,
                    cache: false,
                    href: url,
                    modal: true,
                    buttons: [{
                        text: '保存',
                        iconCls: "icon-ok",
                        handler: function () {
                            var parameters = {};
                            if (type == "add") {
                                parameters = getParameters(BasicAction.ActionType.Post, BasicAction.Methods.RoleMenuMethods.Save);
                                DataManager.sendData(urls.functionsUrl, parameters, resultManagers.successSave, resultManagers.fail);
                            } else if (type == "edit") {
                                parameters = getParameters(BasicAction.ActionType.Post, BasicAction.Methods.RoleMenuMethods.Edit);
                                DataManager.sendData(urls.functionsUrl, parameters, resultManagers.successSave, resultManagers.fail);
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
                } else {
                    MessageManager.ErrorMessage(data.sMeg);
                }
            },
            successSave: function (data) {
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
            successLoadAuthority: function (data) {
                if (data.success) {
                    $("#ckSpan").css({ display: "block" });
                    $("#checkChild").prop({ checked: false });
                    $('#tree').tree({ cascadeCheck: $(this).is(':checked') });
                    $("#tree").tree("loadData", data.obj);
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
                var para = { id: rowData.Id };
                para = CreateParameter(BasicAction.ActionType.Post, BasicAction.Functions.RoleMenu, BasicAction.Methods.RoleMenuMethods.GetRoleFunctions, para);
                DataManager.sendData(urls.functionsUrl, para, resultManagers.successLoadAuthority, resultManagers.fail);
            }
        };
       
    </script>
<style type="text/css">
    .title {
	    font-family: helvetica, tahoma, verdana, sans-serif;
	    font-size: 12px;
	    margin: 0;
    }
</style>
</head>
<body class="easyui-layout" data-options="fit:true">
    <div data-options="region:'center'"title="<div class='title'>角色管理</div>" style="background: #eee;">
        <table class="easyui-datagrid" id="roleGrid" data-options="singleSelect:true,fitColumns: true,border:false,method:'post',fit:true,url:urls.roleGridUrl,sortName:'Code',sortOrder:'ASC',toolbar:toolBar,onSelect:eventManager.selectEvent">
            <thead>
                <tr>
                    <th data-options="field:'Code',width:120,align:'left'">
                        角色编号
                    </th>
                    <th data-options="field:'Name',width:200,align:'left'">
                        角色名称
                    </th>
                    <th data-options="field:'Id',width:200,align:'left',hidden:true">
                        权限
                    </th>
                </tr>
            </thead>
        </table>
    </div>
    <div data-options="region:'east',title:'',split:true,border:false" style="width: 250px;height:100%;">
        <div id="panel"  >
            <span id="ckSpan" style="display:none;"><input type="checkbox" id="checkChild" style=" margin-left:16px" onchange="$('#tree').tree({cascadeCheck:$(this).is(':checked')})" />级联选择</span>
            <ul id="tree" class="easyui-tree" data-options="method:'post',animate:true,checkbox:true,cascadeCheck:false">
            </ul>
        </div>
    </div>
    <div id="Dialog" />
</body>
</html>
