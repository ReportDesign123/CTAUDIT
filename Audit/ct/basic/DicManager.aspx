<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DicManager.aspx.cs" Inherits="Audit.ct.basic.DicManager" %>

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
    <link href="../../Styles/Common.css" rel="stylesheet" type="text/css" />
    <script src="../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <link href="../../Styles/Ct_Controls.css" rel="stylesheet" type="text/css" />
    <script src="../../Scripts/Ct_Controls.js" type="text/javascript"></script>
    <script src="../../Scripts/ct/pub/PubHelp.js" type="text/javascript"></script>
    <script type="text/javascript">
        var urls = {
            DicCGridUrl: "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Grid + "&MethodName=" + BasicAction.Methods.DicManagerMethods.GetDictionaryList + "&FunctionName=" + BasicAction.Functions.DictionaryManager,
            DicClassUrl: "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Grid + "&MethodName=" + BasicAction.Methods.DicManagerMethods.GetDicClassifyDataGridFilter + "&FunctionName=" + BasicAction.Functions.DictionaryManager,
            functionsUrl: "../../handler/BasicHandler.ashx",
            AddDicC: "AddDic.aspx"
        };
        var roleGrid;
        var classHelp;
        $(
        function () {
            $("#dicCode").keypress(function (e) {
                var curKey = e.which;
                if (curKey == 13) {
                    menuManager.DoSearch();
                }
            });
            $("#dicName").keypress(function (e) {
                var curKey = e.which;
                if (curKey == 13) {
                    menuManager.DoSearch();
                }
            });
            classHelp = $("#dicClass").PopEdit();
            classHelp.btn.bind("click", function () {
                menuManager.ClassHelp_click();
            });
            $("#dicClass").keypress(function (e) {
                var curKey = e.which;
                if (curKey == 13) {
                    menuManager.DoSearch();
                }
            });
        }
        );

        var menuManager = {
            AddMenu: function () {
                menuManager.OpenDialog(urls.AddDicC, "创建字典分类", "add");
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
                menuManager.OpenDialog(urls.AddDicC + ur, "编辑字典分类", "edit");
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
                var parameters = CreateParameter(BasicAction.ActionType.Post, BasicAction.Functions.DictionaryManager, BasicAction.Methods.DicManagerMethods.DeleteDictionary, para);
                DataManager.sendData(urls.functionsUrl, parameters, resultManagers.successDel, resultManagers.fail);
            },
            DoSearch: function () {
                var obj = { Code: "", Name: "", CName: "" };
                obj.Code = $("#dicCode").val();
                obj.Name = $("#dicName").val();
                obj.CName = classHelp.name.val();
                $("#roleGrid").datagrid("reload", obj);
            },
            ClaerSearch: function () {
                $("#dicCode").val("");
                $("#dicName").val("");
                classHelp.name.val("");
                $("#roleGrid").datagrid("reload", {});
            },
            OpenDialog: function (url, title, type) {
                $('#Dialog').dialog({
                    title: title,
                    width: 300,
                    height: 250,
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
                                parameters = getParameters(BasicAction.ActionType.Post, BasicAction.Methods.DicManagerMethods.SaveDictionary);
                                DataManager.sendData(urls.functionsUrl, parameters, resultManagers.success, resultManagers.fail);
                            } else if (type == "edit") {
                                parameters = getParameters(BasicAction.ActionType.Post, BasicAction.Methods.DicManagerMethods.UpdateDictionary);
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
            },
            ClassHelp_click: function () {
                var paras = { url: "", columns: [], sortName: "", sortOrder: "", NameField: "Name", CodeField: "Code", defaultField: { dftBy: "Name", dft: ""} };
                paras.url = urls.DicClassUrl;
                paras.columns = [[
            { title: 'id', field: 'Id', width: 180, hidden: true },
			   { field: 'Code', title: '编号', width: 150, sortable: true },
               { field: 'Name', title: '名称', width: 190, sortable: true }
                    ]];
                paras.sortName = 'Code';
                paras.sortOrder = 'ASC';
                paras.defaultField.dft = classHelp.name.val();
                paras.width = 450;
                paras.height = 450;
                pubHelp.setParameters(paras);
                pubHelp.OpenDialogWithHref("HelpDialog", "报告模板选择", "../pub/HelpDialogEasyUi.htm", menuManager.ClassHelp_save, paras.width, paras.height, true);
            },
            ClassHelp_save: function () {
                var result = pubHelp.getResultObj();
                if (result) {
                    classHelp.name.val(result.Name);
                }
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
       
       
    </script>
</head>
<body class="easyui-layout">
    <div data-options="region:'north'" style="height:32px; padding:2px; background-color: #E0ECFF;
        overflow: hidden; border: 1 solid #E0ECFF">
                    <a href="#" icon="icon-add" style=" float:left ;width:70px" class="easyui-linkbutton" plain="true" onclick="menuManager.AddMenu()">增加</a>
    <div class="datagrid-btn-separator"></div>
                    <a href="#" icon="icon-edit"style=" float:left;width:70px" class="easyui-linkbutton" plain="true" onclick="menuManager.EditMenu()">修改</a> 
    <div class="datagrid-btn-separator"></div>
                    <a href="#" icon="icon-cut"style=" float:left;width:70px" class="easyui-linkbutton" plain="true" onclick="menuManager.RemoveMenu()">删除</a>
    </div>
    <div data-options="region:'center'" style="border: 0px">
        <div id="toolBar" style=" min-width:850px">
            <table style=" width:100%">
                <tr>
                    <td style=" width:60px">字典编号</td>
                    <td style=" width:170px"><input id="dicCode" class="easyui-validatebox textbox" /></td>
                    <td style=" width:60px">字典名称</td>
                    <td style=" width:170px"><input id="dicName" class="easyui-validatebox textbox" /></td>
                    <td style=" width:60px">字典类别</td>
                    <td style=" width:170px"><div id="dicClass"></div></td>
                    <td style=" float:right"><a href="#" class="easyui-linkbutton" icon="icon-undo" style="margin-left: 10px"onclick="menuManager.ClaerSearch()">重置</a></td>
                    <td style=" float:right"><a href="#" class="easyui-linkbutton" icon="icon-search" onclick="menuManager.DoSearch()">查询</a></td>
                </tr>
            </table>
        </div>
        <table class="easyui-datagrid" id="roleGrid" data-options="singleSelect:true,method:'post',fit:true,fitColumns:true,sortName:'ClassifyId',sortOrder:'ASC',url:urls.DicCGridUrl,toolbar:toolBar,pagination:true">
            <thead>
                <tr>
                    <th data-options="field:'Code',width:140">
                        字典编号
                    </th>
                    <th data-options="field:'Name',width:150,align:'left'">
                        字典名称
                    </th>
                    <th data-options="field:'CName',width:150,align:'left'">
                        字典类别
                    </th>
                    <th data-options="field:'Remarks',width:140,align:'left'">
                        字典备注
                    </th>
                    <th data-options="field:'Id',width:200,align:'center',hidden:true">
                    </th>
                </tr>
            </thead>
        </table>
    </div>
    <div id="Dialog" />
    <div id="HelpDialog"></div>
</body>
</html>
