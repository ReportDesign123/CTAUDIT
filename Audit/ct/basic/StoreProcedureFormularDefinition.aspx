<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StoreProcedureFormularDefinition.aspx.cs" Inherits="Audit.ct.basic.StoreProcedureFormularDefinition" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>存储过程函数定义</title>
     <script src="../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <link href="../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="../../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <link href="../../Styles/Ct_Controls.css" rel="stylesheet" type="text/css" /> 
    <link href="../../Styles/Common.css" rel="stylesheet" type="text/css" />
    <script src="../../Scripts/Ct_Controls.js" type="text/javascript"></script> 
    <link href="../../Styles/Ct_TextInput.css" rel="stylesheet" type="text/css" />
    <script src="../../Scripts/Ct_TextInput.js" type="text/javascript"></script>
    <script src="../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <script src="../../lib/json2.js" type="text/javascript"></script>
    <script src="../../Scripts/ct/pub/PubHelp.js" type="text/javascript"></script>

    <script type="text/javascript">
        var urls = {
            procedureUrl: "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Grid + "&MethodName=" + BasicAction.Methods.ProcedureMethods.DataGridProcedureFormularEntities + "&FunctionName=" + BasicAction.Functions.Procedure,
            DataSourceUrl: "../../handler/FormatHandler.ashx?ActionType=" + ReportFormatAction.ActionType.Grid + "&MethodName=" + ReportFormatAction.Methods.FormularMenuMethods.GetDataSourceList + "&FunctionName=" + ReportFormatAction.Functions.FormularMenu,
            addProFormularUrl: "AddProcedureFormular.aspx",
            functionsUrl: "../../handler/BasicHandler.ashx"
        }; 
        var menuManager = {
            AddMenu: function () {
                menuManager.OpenDialog(urls.addProFormularUrl, "创建公式", "add");
            },
            EditMenu: function () {
                var row = $("#procedureGrid").datagrid("getSelected");
                var ur = "";
                if (row) {
                    ur = "?Id=" + row.Id;
                } else {
                    MessageManager.WarningMessage("请先选择一行在进行编辑！");
                    return;
                }
                menuManager.OpenDialog(urls.addProFormularUrl + ur, "编辑公式", "edit");
            },
            RemoveMenu: function () {
                var node = $("#procedureGrid").datagrid("getSelected");
                var para = {};
                if (node != null) {
                    para["Id"] = node.Id;
                } else {
                    MessageManager.WarningMessage("请先选择一行在进行删除！");
                    return;
                }
                var parameters = CreateParameter(BasicAction.ActionType.Post, BasicAction.Functions.Procedure, BasicAction.Methods.ProcedureMethods.DeleteProcedureFormularEntity, para);
                DataManager.sendData(urls.functionsUrl, parameters, resultManagers.DeleteSuccess, resultManagers.fail);
            },
            OpenDialog: function (url, title, type) {
                $('#Dialog').dialog({
                    title: title,
                    width: 600,
                    height: 450,
                    closed: false,
                    cache: false,
                    href: url,
                    modal: true,
                    buttons: [{
                        text: '保存',
                        iconCls: "icon-ok",
                        handler: function () {
                            var parameters = GetParameter();
                            if (type == "add") {
                                parameters = CreateParameter(BasicAction.ActionType.Post, BasicAction.Functions.Procedure, BasicAction.Methods.ProcedureMethods.AddProcedureFormularEntity, parameters);
                                DataManager.sendData(urls.functionsUrl, parameters, resultManagers.success, resultManagers.fail);
                            } else if (type == "edit") {
                                parameters = CreateParameter(BasicAction.ActionType.Post, BasicAction.Functions.Procedure, BasicAction.Methods.ProcedureMethods.EditProcedureFormularEntity, parameters);
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
        var SearchManager = {
            doSearch: function () {
                var para = { Name: "", NameValue: "" };
                para.NameValue = $("#ProcedureValue").val();
                para.Name = $("#ProcedureName").val();
                $("#procedureGrid").datagrid('reload', para);
            },
            freeSearch: function () {
                $("#ProcedureValue").val("");
                $("#ProcedureName").val("");
                $("#procedureGrid").datagrid('reload', {});
            }
        }
        var resultManagers = {

            success: function (data) {
                if (data.success) {

                    $("#procedureGrid").datagrid('reload');
                    $('#Dialog').dialog("close");
                    MessageManager.InfoMessage(data.sMeg);
                } else {
                    MessageManager.ErrorMessage(data.sMeg);
                }
            },
            fail: function (data) {

                MessageManager.ErrorMessage(data.toString);
            },
            DeleteSuccess: function (data) {
                if (data.success) {

                    $("#procedureGrid").datagrid('reload');
                    MessageManager.InfoMessage(data.sMeg);
                } else {
                    MessageManager.ErrorMessage(data.sMeg);
                }
            }
        }
        $(function () {
            $("#ProcedureName").keypress(function (e) {
                var curKey = e.which;
                if (curKey == 13) {
                    SearchManager.doSearch();
                }
            });
            $("#ProcedureValue").keypress(function (e) {
                var curKey = e.which;
                if (curKey == 13) {
                    SearchManager.doSearch();
                }
            });        
        });
    </script>
</head>
<body class="easyui-layout">
<div data-options="region:'north',collapsible:false" style=" padding:2px; height:32px;background-color:#E0ECFF ">
    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add',iconAlign:'left',line:true" onclick="menuManager.AddMenu()" style="width:90px; float:left "plain="true">增加</a>
    <div class="datagrid-btn-separator"></div>
    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-edit',iconAlign:'left'" onclick="menuManager.EditMenu()" style="width:90px;float:left "plain="true">修改</a>
    <div class="datagrid-btn-separator"></div>
    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-cut',iconAlign:'left'" onclick="menuManager.RemoveMenu()" style="width:90px;float:left "plain="true">删除</a>
</div>
<div data-options="region:'center'"  style="overflow: hidden;">
    <div id="toolBar" style="min-width:650px;display:none">
        <table  style="width:100%">
            <tr>
                <td style=" width:70px">存储过程名</td>
                <td style=" width:170px"><input id="ProcedureName" type="text" class="easyui-validatebox textbox" /></td>
                <td style=" width:70px">存储过程值</td>
                <td style=" width:170px"><input id="ProcedureValue" type="text" class="easyui-validatebox textbox" /></td>
                <td style=" float:right">
                    <a class="easyui-linkbutton" onclick="SearchManager.doSearch()" iconcls="icon-search" style=" margin-right:10px">查询</a>
                    <a class="easyui-linkbutton" onclick="SearchManager.freeSearch()" iconcls="icon-undo" >重置</a>
                </td>
            </tr>
        </table>
    </div>
   <table class="easyui-datagrid"  id="procedureGrid"
           data-options="singleSelect:true,method:'post',fit:true,fitColumns: true,border:false,url:urls.procedureUrl,sortName:'CreateTime',sortOrder:'DESC',toolbar:'#toolBar',pagination:true">
        <thead>
            <tr>
                <th data-options="field:'Name',width:200,align:'left',query:true">存储过程名</th>
                <th data-options="field:'NameValue',width:200,align:'left'">存储过程值</th>
                <th data-options="field:'CreateTime',width:200,align:'left'">创建时间</th>
                <th data-options="field:'Id',width:200,align:'center',hidden:true">ID</th> 
            </tr>
        </thead>

    </table>
   </div> 
    <div id="Dialog"></div>
    <div id="HelpDialog"></div>
</body>
</html>
