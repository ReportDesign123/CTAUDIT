<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="BookmarkTemplateManager.aspx.cs" Inherits="Audit.ct.ExportReport.BookmarkTemplateManager" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
   <title>标签模板源管理</title>
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
            DataGridUrl: "../../handler/ExportReport.ashx?ActionType=" + ExportAction.ActionType.Grid + "&MethodName=" + ExportAction.Methods.reportMarkMethod.GetBookmarkTemplateDataGrid + "&FunctionName=" + ExportAction.Functions.ReportTemplate,
            TypeUrl: "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Get + "&MethodName=GetDictionaryListByClassType&FunctionName=" + BasicAction.Functions.DictionaryManager + "&ClassType=BQLX",
            DataSourceUrl: "../../handler/FormatHandler.ashx?ActionType=" + ReportFormatAction.ActionType.Grid + "&MethodName=" + ReportFormatAction.Methods.FormularMenuMethods.GetDataSourceList + "&FunctionName=" + ReportFormatAction.Functions.FormularMenu,
            functionUrl: "../../handler/ExportReport.ashx",
            FormularUrl: "../Format/NewFormular.aspx",
            AddMarkUrl: "AddBookmarkTemplate.aspx"
        };
        //菜单管理器
        var menuManager = {
            AddMenu: function () {
                menuManager.OpenDialog(urls.AddMarkUrl, "增加标签模板", "add");
            },
            ///编辑
            EditMenu: function () {
                var row = $("#gridTable").datagrid("getSelected");
                var ur = "";
                if (row) {
                    ur = "?Id=" + row.Id;
                } else {
                    MessageManager.WarningMessage("请先选择一行再进行编辑！");
                    return;
                }
                menuManager.OpenDialog(urls.AddMarkUrl + ur, "编辑标签模板", "edit");
            },
            ///删除
            RemoveMenu: function () {
                var node = $("#gridTable").datagrid("getSelected");
                var para = {};
                if (node != null) {
                    para["Id"] = node.Id;
                } else {
                    MessageManager.WarningMessage("请先选择一行在进行删除！");
                    return;
                } $.messager.confirm('系统提示', '你确定要删除当前单位?', function (r) {
                    if (!r) { return; }
                    else {
                        var parameters = CreateParameter(ExportAction.ActionType.Post, ExportAction.Functions.ReportTemplate, ExportAction.Methods.reportMarkMethod.DeleteBookmarkTemplate, para);
                        DataManager.sendData(urls.functionUrl, parameters, resultManager.successDel, resultManager.fail);
                    }
                });
            },
            ///弹窗界面
            OpenDialog: function (url, title, type) {
                $('#Dialog').dialog({
                    title: title,
                    width: 430,
                    height: 550,
                    closed: false,
                    cache: false,
                    href: url,
                    modal: true,
                    buttons: [
                    {
                        text: '保存',
                        iconCls: "icon-save",
                        handler: function () {
                            var parameters = AddManager.getPatameter();
                            if (!parameters) return;
                            if (type == "add") {
                                parameters = CreateParameter(ExportAction.ActionType.Post, ExportAction.Functions.ReportTemplate, ExportAction.Methods.reportMarkMethod.SaveBookmarkTemplate, parameters);
                                DataManager.sendData(urls.functionUrl, parameters, resultManager.success, resultManager.fail);
                            } else if (type == "edit") {
                                parameters = CreateParameter(ExportAction.ActionType.Post, ExportAction.Functions.ReportTemplate, ExportAction.Methods.reportMarkMethod.UpdateBookmarkTempalte, parameters);
                                DataManager.sendData(urls.functionUrl, parameters, resultManager.success, resultManager.fail);
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
                var para = { Name: "", Type: ""};
                para.Name = $("#Name").val();
                para.Type = $("#Type").combobox("getValue");
                $("#gridTable").datagrid('reload', para);
            },
            freeSearch: function () {
                $("#Name").val("");
                $("#Type").combobox("setValue","");
                $("#gridTable").datagrid('reload', {});
            }
        }
        var resultManager = {
            success: function (data) {
                if (data.success) {
                    MessageManager.InfoMessage(data.sMeg);
                    $("#gridTable").datagrid('reload');
                    $('#Dialog').dialog("close");
                    $("#gridTable").datagrid('unselectAll');
                } else {
                    if (data.rank && data.rank == "1") {
                        $.messager.confirm("系统提示", data.sMeg, function (r) {
                            if (r) {
                                var param = data.obj;
                                param.IsOrNotContinue = "1";
                                param = CreateParameter(ExportAction.ActionType.Post, ExportAction.Functions.ReportTemplate, ExportAction.Methods.reportMarkMethod.SaveBookmarkTemplate, param);
                                DataManager.sendData(urls.functionUrl, param, resultManager.success, resultManager.fail);
                            }
                        });
                    } else {
                        MessageManager.ErrorMessage(data.sMeg);
                    }
                }
            },
            successDel: function (data) {
                if (data.success) {
                    MessageManager.InfoMessage(data.sMeg);
                    $("#gridTable").datagrid('reload');
                    $("#gridTable").datagrid('unselectAll');
                } else {
                    MessageManager.ErrorMessage(data.sMeg);
                }
            },
            fail: function (data) {
                MessageManager.ErrorMessage(data.toString);
            }
        }
        function format(value) {
            if (value == "01") {
                return "指标";
            } else if (value == "02") {
                return "表格";
            } else if (value == "03") {
                return "文本";
            } else {
                return value;
            }
        }
    </script>
</head>
<body class="easyui-layout">
 <div data-options="region:'north',collapsible:false" style="height:32px; padding:2px;background-color:#E0ECFF ;overflow:hidden">
      <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add',iconAlign:'left',line:true" onclick="menuManager.AddMenu()" style="width:90px; float:left "plain="true">增加标签</a>
    <div class="datagrid-btn-separator"></div>
    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-edit',iconAlign:'left'" onclick="menuManager.EditMenu()" style="width:90px;float:left "plain="true">修改标签</a>
    <div class="datagrid-btn-separator"></div>
    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-cut',iconAlign:'left'" onclick="menuManager.RemoveMenu()" style="width:90px;float:left "plain="true">删除标签</a>
</div>
 <div data-options="region:'center'">
 <div id="toolBar" style="min-width:920px;display:none">
     <table  style="width:100%">
        <tr>
            <td style=" width:60px">标签编号</td><td style=" width:170px"><input id="markCode" type="text" class="easyui-validatebox textbox" /></td>
            <td style=" width:60px">标签名称</td><td style=" width:170px"><input id="markName" type="text" class="easyui-validatebox textbox" /></td>
            <td style=" width:60px">标签类型</td><td><input id="marrkType" type="text"  class="easyui-combobox" data-options="url:urls.TypeUrl,valueField:'Code',textField:'Name',panelHeight:'auto'" /></td>
            <td style=" float:right"><a class="easyui-linkbutton" onclick="SearchManager.freeSearch()" iconcls="icon-undo" style=" margin-left:10px">重置</a></td>
            <td style=" float:right"><a class="easyui-linkbutton" onclick="SearchManager.doSearch()" iconcls="icon-search" style="">查询</a></td>
        </tr>
     </table>
 </div>
<table class="easyui-datagrid"  id="gridTable"
        data-options="singleSelect:true,method:'post',fit:true,fitColumns:true,border:false,toolbar:'#toolBar',url:urls.DataGridUrl,sortName:'CreateTime',sortOrder:'DESC',pagination:true">
    <thead>
        <tr>
            <th data-options="field:'Code',width:120,fixed:false,sortable:true">标签编号</th>
            <th data-options="field:'Name',width:120,fixed:false,sortable:true">标签名称</th>
            <th data-options="field:'Type',width:120,fixed:false,sortable:true, formatter:format">标签类型</th>
            <th data-options="field:'CreateTime',width:120,sortable:true">创建时间</th>
        </tr>
    </thead>
</table>
</div>
    <div id="Dialog" > </div>
</body>
</html>
