<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReportTemplateManager.aspx.cs" Inherits="Audit.ct.ExportReport.ReportTemplateManager" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>报告模板管理</title>
    <script src="../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <link href="../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="../../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script src="../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <link href="../../Styles/Ct_Controls.css" rel="stylesheet" type="text/css" />
    <script src="../../Scripts/Ct_Controls.js" type="text/javascript"></script>
    <link href="../../Styles/Common.css" rel="stylesheet" type="text/css" />
<%--
    .datagrid-btable tr{
	height:40px;
	} 
    grid 间距调整
--%>
<script type="text/javascript">
    var urls = {
        gridUrl: "../../handler/ExportReport.ashx?ActionType=" + ExportAction.ActionType.Grid + "&MethodName=" + ExportAction.Methods.TemplateMethod.GetReportTemplateDataGrid + "&FunctionName=" + ExportAction.Functions.ReportTemplate,
        addUrl: "../../handler/ExportReport.ashx?ActionType=" + ExportAction.ActionType.Grid + "&MethodName=" + ExportAction.Methods.TemplateMethod.SaveReportTemplate + "&FunctionName=" + ExportAction.Functions.ReportTemplate,
        uploadUrl:"../../handler/ExportReport.ashx?ActionType=" + ExportAction.ActionType.Grid + "&MethodName=" + ExportAction.Methods.TemplateMethod.UploadTemplate + "&FunctionName=" + ExportAction.Functions.ReportTemplate,
        downloadUrl:"../../handler/ExportReport.ashx?ActionType=" + ExportAction.ActionType.Grid + "&MethodName=" + ExportAction.Methods.TemplateMethod.DownloadTemplate + "&FunctionName=" + ExportAction.Functions.ReportTemplate,
        uploadUrl:"../../handler/ExportReport.ashx?ActionType=" + ExportAction.ActionType.Grid + "&MethodName=" + ExportAction.Methods.TemplateMethod.UploadTemplate + "&FunctionName=" + ExportAction.Functions.ReportTemplate,
        zqUrl: "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Get + "&MethodName=GetDictionaryListByClassType&FunctionName=" + BasicAction.Functions.DictionaryManager + "&ClassType=BBZQ",
        aboutReportUrl: "ExportRelationReports.aspx",
        functionUrl:"../../handler/ExportReport.ashx",
        TemplateUrl: "CreateTemplate.aspx",
        DesignUrl: "ct/ExportReport/TemplateDesign.aspx"
    }
    var currentState = { inEditTemplate: {} };
     $(function () {
         currentState.TemplateGrid = $('#TemplateGrid').datagrid({
             url: urls.gridUrl,
             pagePosition: 'bottom',
             sortName: 'CreateTime',
             sortOrder: 'desc',
             idField: 'Id',
             toolbar: "#toolbar",
             fit: true,
             nowrap: true,
             border: false,
             pagination: true,
             rownumbers: true,
             fitColumns: true,
             frozenColumns: true,
             singleSelect: true,
             columns: [[
			//{ field: 'Id', checkbox: true },
			   { field: 'Code', title: '模板编号', width: 120, sortable: true },
               { field: 'Name', title: '模板名称', width: 160, sortable: true },
			   { field: 'Cycle', title: '周期类型', width: 100, sortable: true,
				    formatter: function (value, row, index) {
				        if (value == "") return value;
				        var Cycle = "";
				        switch (value) {
				            case "01":
				                Cycle = "年报";
				                break;
				            case "02":
				                Cycle = "月报";
				                break;
				            case "03":
				                Cycle = "季报";
				                break;
				            case "04":
				                Cycle = "日报";
				                break;
				        }
				        return Cycle;
				    }
				},
				{ field: 'CreateTime', title: '修改时间', align: 'center', width: 100, sortable: true },
				{ field: 'upload', title: '上传模板 ', align: 'center', width: 100, sortable: true,
				    formatter: function (value, row, index) {
				        return "<img onclick='controlManager.dialogManager.uploadDialogOpen(this.id)' id='" + index + "' src='../../images/layout/upload.png'style='cursor:pointer' title='上传模板'/></a>";
				    }
				},
				{ field: 'download', title: '下载模板', align: 'center', width: 100, sortable: true,
				    formatter: function (value, row, index) {
				        return " <img onclick='controlManager.dialogManager.DownloadTemplate(this.id)' style='cursor:pointer'  id='" + index + "' src='../../lib/easyUI/themes/icons/downLoad.ico' title='上传模板'/></a>";
				    }
				},
				{ field: 'design', title: '设计', align: 'center', width: 100, sortable: true,
				    formatter: function (value, row, index) {
				        return "<img onclick='controlManager.dialogManager.DesignTemplate(this.id)' id='" + index + "' style='cursor:pointer' src='../../images/layout/design.png'title='设计' /></a>";
				    }
				}
			 ]]
        });
        $("#TCode").keypress(function (e) {
            var curKey = e.which;
            if (curKey == 13) {
                controlManager.SearchManager.doSearch();
            }
        });
        $("#TName").keypress(function (e) {
            var curKey = e.which;
            if (curKey == 13) {
                controlManager.SearchManager.doSearch();
            }
        });
     });
     var controlManager = {
         templateManager: {
             add: function () {
                 controlManager.dialogManager.OpenDialog(urls.TemplateUrl, '新建模板', 'add');
             },
             edit: function () {
                 var rows = currentState.TemplateGrid.datagrid('getSelections');
                 if (rows.length == 1) {
                     currentState.inEditTemplate = rows[0];
                     controlManager.dialogManager.OpenDialog(urls.TemplateUrl + "?Id=" + rows[0].Id, '编辑模板', 'edit');

                 } else if (rows.length > 1) {
                     $.messager.alert('提示', '同一时间只能编辑一条记录！', 'error');
                 } else {
                     $.messager.alert('提示', '请选择要编辑的记录！', 'error');
                 }
             },
             cut: function () {
                 var rows = currentState.TemplateGrid.datagrid('getSelections');
                 var para = {};
                 if (rows.length == 1) {
                     para.Id = rows[0].Id;
                     $.messager.confirm('确认', '您是否要删除当前选中的项目？', function (r) {
                         if (r) {
                             var parameters = CreateParameter(ExportAction.ActionType.Post, ExportAction.Functions.ReportTemplate, ExportAction.Methods.TemplateMethod.DeleteReportTemplate, para);
                             DataManager.sendData(urls.functionUrl, parameters, resultManager.successDelete, resultManager.fail);

                         }
                     });
                 } else if (rows.length > 1) {
                     $.messager.alert('提示', '同一时间只能编辑一条记录！', 'error');
                 } else {
                     $.messager.show({
                         title: '提示',
                         msg: '请勾选要删除的记录！'
                     });
                 }
             }
         },
         dialogManager: {
             OpenDialog: function (url, title, type) {
                 $('#templateDialog').dialog({
                     title: title,
                     width: 450,
                     height: 380,
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
                                 parameters = getParameters(ExportAction.ActionType.Post, ExportAction.Methods.TemplateMethod.SaveReportTemplate);
                                 DataManager.sendData(urls.functionUrl, parameters, resultManager.successSave, resultManager.fail);
                             } else if (type == "edit") {
                                 parameters = getParameters(ExportAction.ActionType.Post, ExportAction.Methods.TemplateMethod.EditReportTemplate);
                                 DataManager.sendData(urls.functionUrl, parameters, resultManager.successSave, resultManager.fail);
                             }
                         }
                     },
                        {
                            text: '取消',
                            iconCls: "icon-cancel",
                            handler: function () {
                                $("#templateDialog").dialog("close");
                            }
                        }
                        ]
                 });
             },
             uploadDialogOpen: function (index) {
                 var rows = currentState.TemplateGrid.datagrid("getRows");
                 var paras = rows[index];
                 currentState.inEditTemplate = paras;
                 $("#upFrame").attr("src", "TemplateUpload.htm");
                 $("#uploadDialog").dialog({
                     buttons: [{
                         text: '保存',
                         iconCls: "icon-ok",
                         handler: function () {
                             var upfram = window.frames["upFrame"];
                             upfram.upload();
                             $('#uploadDialog').dialog("close");
                             currentState.TemplateGrid.datagrid("reload");
                         }
                     },
                    {
                        text: '取消',
                        iconCls: "icon-cancel",
                        handler: function () {
                            $('#uploadDialog').dialog("close");
                        }
                    }
                    ]
                 });
                 $("#uploadDialog").dialog("open");
             },
             DownloadTemplate: function (index) {
                 var rows = currentState.TemplateGrid.datagrid("getRows");
                 var paras = rows[index];
                 window.location = urls.downloadUrl + "&Id=" + paras.Id;
             },
             DesignTemplate: function (index) {
                 var rows = currentState.TemplateGrid.datagrid("getRows");
                 var paras = rows[index];
                 //var para = JSON2.stringify(paras);
                 parent.NavigatorNode({ id: "101", text: "报告模板设计", attributes: { url: urls.DesignUrl + "?Id=" + paras.Id} });
             }
         },
         SearchManager: {
             doSearch: function () {
                 var para = { Code: "", Name: "", Cycle: ""};
                 para.Code = $("#TCode").val();
                 para.Name = $("#TName").val();
                 para.Cycle = $("#TCycle").combobox("getValue");
                 currentState.TemplateGrid.datagrid('reload', para);
             },
             freeSearch: function () {
                 $("#TCode").val("");
                 $("#TName").val("");
                 $("#TCycle").combobox("setValue", "");
                 currentState.TemplateGrid.datagrid('reload', {});
             }        
         }
     }
     var resultManager = {
         successSave: function (data) {
             if (data.success) {
                 currentState.TemplateGrid.datagrid("reload");
                 $("#templateDialog").dialog("close");
                 MessageManager.InfoMessage(data.sMeg);
             } else {
                 MessageManager.ErrorMessage(data.sMeg);
             }
         },
         successDelete: function (data) {
             if (data.success) {
                 currentState.TemplateGrid.datagrid("reload");
                 MessageManager.InfoMessage(data.sMeg);
             } else {
                 MessageManager.ErrorMessage(data.sMeg);
             }
         },
         fail: function (data) {
             MessageManager.ErrorMessage(data.toString());
         }
     }
</script>
</head>
<body>
	<div class="easyui-layout" data-options="fit:true" style="">
        <div data-options="region:'north',collapsible:false" style="height:32px; padding:2px;background-color:#E0ECFF ;overflow:hidden">
        <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add',iconAlign:'left'" onclick="controlManager.templateManager.add()" style="width:90px; float:left "plain="true">新建模板</a>
        <div class="datagrid-btn-separator"></div>
        <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-edit',iconAlign:'left'" onclick="controlManager.templateManager.edit()" style="width:90px; float:left "plain="true">修改模板</a>
        <div class="datagrid-btn-separator"></div>    
        <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-cut',iconAlign:'left'" onclick="controlManager.templateManager.cut()" style="width:90px; float:left "plain="true">删除模板</a>
    </div>
        <div region="center" style=" ">
		    <div id="toolbar" style=" min-width:850px">
                <table style=" width:100%">
                <tr>
                <td style=" width:60px">模板编号</td><td style=" width:170px"><input id="TCode" type="text" class="easyui-validatebox textbox" /></td>
                <td style=" width:60px">模板名称</td><td style=" width:170px"><input id="TName" type="text" class="easyui-validatebox textbox" /></td>
                <td style=" width:60px">周期类型</td><td style=" width:170px"><input id="TCycle" type="text"  class="easyui-combobox" data-options="url:urls.zqUrl,valueField:'Code',textField:'Name',panelHeight:'auto'" /></td>
                <td style=" float:right"><a class="easyui-linkbutton" onclick="controlManager.SearchManager.freeSearch()" iconcls="icon-undo" style="">重置</a></td>
                <td style=" float:right"><a class="easyui-linkbutton" onclick="controlManager.SearchManager.doSearch()" iconcls="icon-search" style=" margin-right:10px;">查询</a></td>
                </tr>
                </table>
            </div>
		    <table id="TemplateGrid"></table>
	    </div>
	    <div id="templateDialog"></div>
         <div id="uploadDialog" class="easyui-dialog" data-options="
                    title:'模板上传',
                    width: 330,
                     height: 240,
                     closed: true,
                     cache: false,
                     modal: true
         ">
          <iframe id="upFrame"  frameborder="0" width="100%" height="150px" ></iframe>
         </div>
           
    </div>

</body>
</html>