<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReportAndCompanyRelation.aspx.cs" Inherits="Audit.ct.ExportReport.ReportAndCompanyRelation" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
   <title>角色管理</title>
      <script src="../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <link href="../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="../../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script src="../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <link href="../../Styles/Common.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/json2.js" type="text/javascript"></script>
    <script type="text/javascript">
        var urls = {
            gridUrl: "../../handler/ExportReport.ashx?ActionType=" + ExportAction.ActionType.Grid + "&MethodName=" + ExportAction.Methods.TemplateMethod.GetReportTemplateDataGrid + "&FunctionName=" + ExportAction.Functions.ReportTemplate,
            functionsUrl: "../../handler/ExportReport.ashx",
            TreeUrl: "../../handler/AuditPaperHandler.ashx?ActionType=" + AuditPaperAction.ActionType.Grid + "&MethodName=" + AuditPaperAction.Methods.AuditPaperManagerMenu.TreeNodesAuditPaperAuthorities + "&FunctionName=" + AuditPaperAction.Functions.AuditPaperManagerMenu

        };
        $(function () {
            $("#panel").panel({
                title: "<div class='title'>组织机构保存</div>",
                fit: true,
                tools: [
                {
                    iconCls: 'icon-save',
                    handler: function () {
                        var row = $("#TemplateGrid").datagrid("getSelected");
                        if (!row || row == undefined) { alert("请选择模板"); return; }
                        var notes = $("#companyTree").tree('getChecked', ['checked']);
                        var companies = [];
                        $.each(notes, function (index) {
                            var parameter = { Id: "", AuditPaperId: "", CompanyId: "", State: "" };
                            parameter.CompanyId = notes[index].id;
                            parameter.State = "1";
                            companies.push(parameter);
                        });
                        notes = $("#companyTree").tree('getChecked', ['indeterminate']);
                        $.each(notes, function (index) {
                            var parameter = { Id: "", AuditPaperId: "", CompanyId: "", State: "" };
                            parameter.CompanyId = notes[index].id;
                            parameter.State = "0";
                            companies.push(parameter);
                        });
                        var obj = {};
                        obj.companies = JSON2.stringify(companies);
                        obj.Id = row.Id;
                        var para = CreateParameter(ExportAction.ActionType.Post, ExportAction.Functions.ReportTemplate, ExportAction.Methods.RelevantMethod.BatchUpdate, obj);
                        DataManager.sendData(urls.functionsUrl, para, resultManagers.success, resultManagers.fail);
                    }
                }
                ]
            });
            $("#TCode").keypress(function (e) {
                var curKey = e.which;
                if (curKey == 13) {
                    SearchManager.doSearch();
                }
            });
            $("#TName").keypress(function (e) {
                var curKey = e.which;
                if (curKey == 13) {
                    SearchManager.doSearch();
                }
            });
        });
        var resultManagers = {
            success: function (data) {
                if (data.success) {
                    MessageManager.InfoMessage(data.sMeg);
                } else {
                    MessageManager.ErrorMessage(data.sMeg);
                }
            },
            successLoadCompany:function(data){
                if (data.success) {
                    $("#JlDiv").css("display", "block");
                    $("#JlCheckbox").attr({ checked: true});
                    $('#companyTree').tree({ cascadeCheck: $("#JlCheckbox").is(':checked') });
                    $("#companyTree").tree("loadData", data.obj);
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
                var para = { Id: rowData.Id };
                para = CreateParameter(ExportAction.ActionType.Post, ExportAction.Functions.ReportTemplate, ExportAction.Methods.RelevantMethod.TemplateAndCompanies, para);
                DataManager.sendData(urls.functionsUrl, para, resultManagers.successLoadCompany, resultManagers.fail);
            }
        };
       var SearchManager = {
             doSearch: function () {
                 var para = { Code: "", Name: ""};
                 para.Code = $("#TCode").val();
                 para.Name = $("#TName").val();
                 $("#TemplateGrid").datagrid('reload', para);
             },
             freeSearch: function () {
                 $("#TCode").val("");
                 $("#TName").val("");
                 $("#TemplateGrid").datagrid('reload', {});
             }        
         }
    </script>
    <style type="text/css">
        .title {
	        font-family: helvetica, tahoma, verdana, sans-serif;
	        font-size: 12px;
	        margin: 0;
        }
    </style>
</head>
<body  class="easyui-layout" data-options="fit:true">
   <div data-options="region:'center'"title="<div class='title'>报告模板</div>" >
     <div id="toolbar" style=" min-width:650px">
                <table style=" width:100%">
                <tr>
                    <td style=" width:60px">模板编号</td><td style=" width:170px"><input id="TCode" type="text" class="easyui-validatebox textbox" /></td>
                    <td style=" width:60px">模板名称</td><td><input id="TName" type="text" class="easyui-validatebox textbox" /></td>
                    <td style=" float:right"><a class="easyui-linkbutton" onclick="SearchManager.freeSearch()" iconcls="icon-undo" style="">重置</a></td>
                    <td style=" float:right"><a class="easyui-linkbutton" onclick="SearchManager.doSearch()" iconcls="icon-search" style=" margin-right:10px;">查询</a></td>
                </tr>
                </table>
            </div>
    <table class="easyui-datagrid"  id="TemplateGrid"
            data-options="singleSelect:true,method:'post',fit:true,fitColumns:true,toolbar:'#toolbar',url:urls.gridUrl,border:false,sortName:'CreateTime',sortOrder:'DESC',onSelect:eventManager.selectEvent">
        <thead>
            <tr>
                <th data-options="field:'Code',width:150,align:'left'">模板编号</th>
                <th data-options="field:'Name',width:200,align:'left'">模板名称</th>
                <th data-options="field:'Id',width:200,align:'left',hidden:true">Id</th>                
            </tr>
        </thead>
    </table>
   </div>
   <div data-options="region:'east',title:'',split:true,border:false" style="width:250px;background:#eee; height:100%">
    <div id="panel" style=" height:100%">
    <div id="JlDiv" style="display:none"><input  type="checkbox" id="JlCheckbox"  checked="checked" style=" margin-left:18px;" onchange="$('#companyTree').tree({cascadeCheck:$(this).is(':checked')})"/>级联选择</div> 
   <ul id="companyTree" class="easyui-tree" data-options="method:'post',animate:true,checkbox:true" ></ul>
   </div>
   </div>
</body>
</html>


