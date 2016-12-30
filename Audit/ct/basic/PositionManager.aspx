<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PositionManager.aspx.cs" Inherits="Audit.ct.basic.PositionManager" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>功能菜单</title>
    <script src="../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <link href="../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="../../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script src="../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <script type="text/javascript">
        //参数
        var menuGrid;
        var urls = {
            menuGridUrl: "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Grid + "&MethodName=" + BasicAction.Methods.PositionManagerMethods.GetPositionList + "&FunctionName=" + BasicAction.Functions.PositionManager,
            addMenuUrl: "AddPosition.aspx",
            functionsUrl: "../../handler/BasicHandler.ashx"
        };

        $(
            function () {
                menuGrid = $("#menuGrid").treegrid({
                    url: urls.menuGridUrl,
                    title: "",
                    fit: true,
                    fitColumns: true,
                    idField: "Id",
                    treeField: "Code",
                    columns: [[
         { title: 'id', field: 'Id', width: 180, hidden: true },
         { title: '', field: 'ParentId', width: 120, hidden: true },
        { title: '编号', field: 'Code', width: 180 },
        { title: '名称', field: 'Name', width: 120 },
         { title: '内码', field: 'Nm', width: 120 },
        { title: '顺序号', field: 'Sequence', width: 80 }
    ]],
                    toolbar: [
       {
           text: '增加',
           iconCls: 'icon-add',
           handler: function () {
               menuManager.addMenu();
           }
       }, '-',
       {
           text: '修改',
           iconCls: 'icon-edit',
           handler: function () {
               menuManager.editMenu();
           }
       }, '-',
       {
           text: '删除',
           iconCls: 'icon-remove',
           handler: function () {
               menuManager.removeMenu();
           }
       }
       ]
                }
);
            }
        );
        //菜单管理器
        var menuManager = {
            addMenu: function () {
                var node = menuGrid.treegrid("getSelected");
                var ur = "";
                if (node != null) {
                    ur = "?type=add&ParentId=" + node.Id;
                }
                menuManager.OpenDialog(urls.addMenuUrl + ur, "创建职务", "add");
            },
            editMenu: function () {
                var node = menuGrid.treegrid("getSelected");
                var ur = "";
                if (node != null) {
                    ur = "?type=edit&Id=" + node.Id;
                } else {
                    MessageManager.WarningMessage("请先选择一行在进行编辑！");
                    return;
                }
                menuManager.OpenDialog(urls.addMenuUrl + ur, "编辑职务", "edit");
            },
            removeMenu: function () {
                var node = menuGrid.treegrid("getSelected");
                var para = {};
                if (node != null) {
                    para["Nm"] = node.Nm;         
                } else {
                    MessageManager.WarningMessage("请先选择一行在进行编辑！");
                    return;
                }
                var parameters = CreateParameter(BasicAction.ActionType.Post, BasicAction.Functions.PositionManager, BasicAction.Methods.PositionManagerMethods.Delete, para);
                DataManager.sendData(urls.functionsUrl, parameters, resultManagers.DelteSuccess, resultManagers.fail);
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
                            var parameters = {};
                            if (type == "add") {
                                parameters = getParameters(BasicAction.Functions.PositionManager, BasicAction.Methods.PositionManagerMethods.Save);
                            } else if (type == "edit") {
                                parameters = getParameters(BasicAction.Functions.PositionManager, BasicAction.Methods.PositionManagerMethods.Edit)
                            }

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
                    menuGrid.treegrid('reload');
                    $('#Dialog').dialog("close");
                    menuGrid.treegrid('unselectAll');

                } else {
                    MessageManager.ErrorMessage(data.sMeg);
                }
            },
            fail: function (data) {

                MessageManager.ErrorMessage(data.toString);
            },
            DelteSuccess: function (data) {
                if (data.success) {
                    MessageManager.InfoMessage(data.sMeg);
                    menuGrid.treegrid('reload');                 

                } else {
                    MessageManager.ErrorMessage(data.sMeg);
                }
            }
        }
       
    </script>
</head>
<body class="easyui-layout" fit="true">
    <div region="center" border="false" style="overflow: hidden;">
        <table id="menuGrid">
        </table>
    </div>

    <div id="Dialog"></div>
</body>
</html>
