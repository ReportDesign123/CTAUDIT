<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CompanyManager.aspx.cs" Inherits="Audit.ct.basic.CompanyManager" %>


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
    <link href="../../Styles/Common.css" rel="stylesheet" type="text/css" />
    <script src="../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <script type="text/javascript">
        //参数
        var controls = {InViewGrid:"Tree" };
        var urls = {
            menuGridUrl: "../../handler/BasicHandler.ashx?ActionType="+BasicAction.ActionType.Grid+"&MethodName="+BasicAction.Methods.CompanyManagerMethods.GetCompanyList+"&FunctionName="+BasicAction.Functions.CompanyManager,
            ListGridUrl:"../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Grid + "&MethodName=" + BasicAction.Methods.CompanyManagerMethods.CompanyDataGrid + "&FunctionName=" + BasicAction.Functions.CompanyManager,
            addMenuUrl: "AddCompany.aspx",
            functionsUrl: "../../handler/BasicHandler.ashx"
        };
        $(function () {
            menuManager.LoadTreeGrid();
            $("#CompanyCode").keypress(function (e) {
                var curKey = e.which;
                if (curKey == 13) {
                    SearchManager.doSearch();
                }
            });
            $("#ConpamyName").keypress(function (e) {
                var curKey = e.which;
                if (curKey == 13) {
                    SearchManager.doSearch();
                }
            });            
        });

        //菜单管理器
        var menuManager = {
            addMenu: function () {
                menuManager.OpenDialog(urls.addMenuUrl, "创建组织机构", "add");
            },
            editMenu: function () {
                var node;
                if (controls.InViewGrid == "Tree") {
                    node = controls.TreeGrid.treegrid("getSelected");
                } else {
                    node = controls.DataGrid.datagrid("getSelected");
                }
                var ur = "";
                if (node != null) {
                    ur = "?type=edit&Id=" + node.Id;
                } else {
                    MessageManager.WarningMessage("请先选择一行在进行编辑！");
                    return;
                }
                menuManager.OpenDialog(urls.addMenuUrl + ur, "编辑组织机构", "edit");
            },
            removeMenu: function () {
                var node;
                if (controls.InViewGrid == "Tree") {
                    node = controls.TreeGrid.treegrid("getSelected");
                } else {
                    node = controls.DataGrid.datagrid("getSelected");
                }
                var para = {};
                if (node != null) {
                    para["Nm"] = node.Nm;
                    para["Id"] = node.Id;
                    para["ParentId"] = node.ParentId;
                } else {
                    MessageManager.WarningMessage("请先选择一行在进行编辑！");
                    return;
                } $.messager.confirm('系统提示', '你确定要删除当前单位?', function (r) {
                    if (!r) {
                        return;
                    } else {
                        var parameters = CreateParameter(BasicAction.ActionType.Post, BasicAction.Functions.CompanyManager, BasicAction.Methods.CompanyManagerMethods.Delete, para);
                        DataManager.sendData(urls.functionsUrl, parameters, resultManagers.delete_Success, resultManagers.fail);
                    }
                });

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
                                parameters = getParameters(BasicAction.Functions.CompanyManager, BasicAction.Methods.CompanyManagerMethods.Save);
                            } else if (type == "edit") {
                                parameters = getParameters(BasicAction.Functions.CompanyManager, BasicAction.Methods.CompanyManagerMethods.Edit)
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
            },
            changeView: function () {
                if (controls.InViewGrid == "List") {
                    $("TreeDiv").css("display", "block");
                    $("#ListDiv").css("display", "none");
                    controls.InViewGrid = "Tree";
                    menuManager.LoadTreeGrid();
                } else {
                    $("TreeDiv").css("display", "none");
                    $("#ListDiv").css("display", "block");
                    controls.InViewGrid = "List";
                    menuManager.LoadDataGrid();
                }
            },
            LoadTreeGrid: function () {
                if (!controls.TreeGrid) {
                    controls.TreeGrid = $("#TreeGrid").treegrid({
                        url: urls.menuGridUrl,
                        title: "",
                        fit: true,
                        border: false,
                        fitColumns: true,
                        idField: "Id",
                        treeField: "Code",
                        columns: [[
                    { title: 'id', field: 'Id', width: 180, hidden: true },
                    { title: '内码', field: 'ParentId', width: 120, hidden: true },
                    { title: '组织机构编号', field: 'Code', width: 180 },
                    { title: '组织机构名称', field: 'Name', width: 210 },
                    { title: '内码', field: 'Nm', width: 120 },
                    { title: '是否明细', field: 'Mx', width: 200, formatter: function (value, row, index) {
                        if (row.Mx == 1) {
                            return "明细";
                        } else {
                            return "非明细";
                        }
                    }
                    },
                    { title: '顺序号', field: 'Sequence', width: 80 }
                    ]]
                    });
                } else {
                    controls.TreeGrid.treegrid('reload');
                }
            },
            LoadDataGrid: function () {
                if (!controls.DataGrid) {
                    controls.DataGrid = $("#ListGrid").datagrid({
                        url: urls.ListGridUrl,
                        fit: true,
                        nowrap: true,
                        border: false,
                        pagination: true,
                        rownumbers: true,
                        fitColumns: true,
                        frozenColumns: true,
                        singleSelect: true,
                        sortOrder: 'Asc',
                        sortName: 'Code',
                        columns: [[
			        { field: 'Id', hidden: true },
                        //			        { field: 'ParentId', title: '内码', width: 120, sortable: true },
			        {field: 'Code', title: '组织机构编号', width: 120, sortable: true },
			        { field: 'Name', title: '组织机构名称', width: 190, sortable: true },
                    { field: 'Nm', title: '内码', width: 120, sortable: true },
			        { field: 'Mx', title: '是否明细', width: 150, formatter: function (value, row, index) {
			            if (row.Mx == 1) {
			                return "明细";
			            } else {
			                return "非明细";
			            }
			        }
			        },
                    { field: 'Sequence', title: '顺序号', width: 80, sortable: true }
                    ]]
                    });
                } else {
                    controls.DataGrid.datagrid('reload');
                }
            }
        };
        var SearchManager = {
            doSearch: function () {
                if (controls.InViewGrid == "Tree") {
                    $("TreeDiv").css("display", "none");
                    $("#ListDiv").css("display", "block");
                    controls.InViewGrid = "List";
                    if (!controls.DataGrid) {
                        menuManager.LoadDataGrid();
                    }
                }
                var para = { Name: "", Code: "" };
                para.Code = $("#CompanyCode").val();
                para.Name = $("#ConpamyName").val();
                $("#ListGrid").datagrid('reload', para);
            },
            freeSearch: function () {
                $("#CompanyCode").val("");
                $("#ConpamyName").val("");
                try {
                    $("#ListGrid").datagrid('reload', {});
                } catch (Exception) {
                    return;
                }
            }
        };
        var resultManagers = {
            success: function (data) {
                if (data.success) {
                    MessageManager.InfoMessage(data.sMeg);
                    controls.TreeGrid.treegrid('reload');
                    if (controls.DataGrid) {
                        controls.DataGrid.datagrid('reload');
                    }
                    $('#Dialog').dialog("close");
                } else {
                    MessageManager.ErrorMessage(data.sMeg);
                }
            },
            fail: function (data) {

                MessageManager.ErrorMessage(data.toString);
            },
            delete_Success: function (data) {
                if (data.success) {
                    MessageManager.InfoMessage(data.sMeg);
                    controls.TreeGrid.treegrid('reload');
                    if (controls.DataGrid) {
                        controls.DataGrid.datagrid('reload');
                    }
                    controls.TreeGrid.treegrid('unselectAll');
                    controls.DataGrid.datagrid('unselectAll');
                } else {
                    MessageManager.ErrorMessage(data.sMeg);
                }
            }

        }
            function ExpandTo(data) {
                var obj = data.obj;
                var paraArr = obj.split("|");
                if (paraArr[0]) {
                    var ids = paraArr[0].split(",");
                    $.each(ids, function (index, item) {

                        $("#TreeGrid").treegrid('expand', item);
                    });
                    $("#TreeGrid").treegrid('select', paraArr[1]);

                } else {
                    $("#TreeGrid").treegrid('select', paraArr[1]);
                }

            }
    </script>
</head>
<body class="easyui-layout">
<div data-options="region:'north',collapsible:false" style=" height:68px;border-bottom:0px; overflow:hidden">
    <div style="height:28px; padding:2px 0px 0px 2px; background-color:#E0ECFF; border-bottom:1px solid #95B8E7; width:100%; overflow:hidden">
        <a class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="menuManager.addMenu()" style="width:70px; float:left "plain="true">增加</a>
        <div class="datagrid-btn-separator"></div>
        <a class="easyui-linkbutton" data-options="iconCls:'icon-edit'" onclick="menuManager.editMenu()" style="width:70px; float:left"plain="true">修改</a>
        <div class="datagrid-btn-separator"></div>
        <a class="easyui-linkbutton" data-options="iconCls:'icon-cut'" onclick="menuManager.removeMenu()" style="width:70px; float:left"plain="true">删除</a>
    </div>
    <div id="toolBar" style=" height:32px; min-width:750px;" class="datagrid-toolbar">
        <table  style="width:100%">
            <tr>
                <td style=" width:90px">组织机构编号</td><td style=" width:180px"><input id="CompanyCode" type="text" class="easyui-validatebox textbox" /></td>
                <td style=" width:90px">组织机构名称</td><td><input id="ConpamyName" type="text" class="easyui-validatebox textbox" /></td>
                <td style=" float:right"><a class="easyui-linkbutton" onclick="menuManager.changeView()" iconcls="icon-reload" style=" margin-left:10px">切换</a></td>
                <td style=" float:right"><a class="easyui-linkbutton" onclick="SearchManager.freeSearch()" iconcls="icon-undo" style=" margin-left:10px">重置</a></td>
                <td style=" float:right"><a class="easyui-linkbutton" onclick="SearchManager.doSearch()" iconcls="icon-search" style=" ">查询</a></td>
            </tr>
        </table>
    </div>
</div>
<div data-options="region:'center'"  style="overflow: hidden;">
   <div id="ListDiv" style=" width:100%; height:100%; display:none" ><table id="ListGrid"></table></div> 
   <div id="TreeDiv" style=" width:100%; height:100%" ><table id="TreeGrid"></table></div> 
</div>
<div id="Dialog"></div>
</body>
</html>
