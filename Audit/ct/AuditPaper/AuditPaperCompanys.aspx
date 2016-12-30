<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AuditPaperCompanys.aspx.cs" Inherits="Audit.ct.AuditPaper.AuditPaperCompanys" %>

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
    <script type="text/javascript">
        var urls = {
            roleGridUrl: "../../handler/AuditPaperHandler.ashx?ActionType=" + AuditPaperAction.ActionType.Grid + "&MethodName=" + AuditPaperAction.Methods.AuditPaperManagerMenu.getDataGrid + "&FunctionName=" + AuditPaperAction.Functions.AuditPaperManagerMenu,
            functionsUrl: "../../handler/AuditPaperHandler.ashx",           
            TreeUrl:  "../../handler/AuditPaperHandler.ashx?ActionType=" + AuditPaperAction.ActionType.Grid + "&MethodName=" + AuditPaperAction.Methods.AuditPaperManagerMenu.TreeNodesAuditPaperAuthorities + "&FunctionName=" + AuditPaperAction.Functions.AuditPaperManagerMenu

        };
        var roleGrid;

        $(
        function () {
            // roleGrid = $("#roleGrid").datagrid({url:urls.gridUrl()});
            $("#panel").panel({
                title: "<div class='title'>组织机构保存</div>",
                fit: true,
                tools: [
            {
                iconCls: 'icon-save',
                handler: function () {
                    var row = $("#roleGrid").datagrid("getSelected");
                    var notes = $("#tree").tree('getChecked', ['checked']);
                    var rows = [];
                    $.each(notes, function (index) {
                        var parameter = { Id: "", AuditPaperId: "", CompanyId: "", State: "" };
                        parameter.CompanyId = notes[index].id;
                        parameter.AuditPaperId = row.Id;
                        rows.push(parameter);
                        parameter.State = "1";
                    });
                    notes = $("#tree").tree('getChecked', ['indeterminate']);
                    $.each(notes, function (index) {
                        var parameter = { Id: "", AuditPaperId: "", CompanyId: "", State: "" };
                        parameter.CompanyId = notes[index].id;
                        parameter.AuditPaperId = row.Id;
                        rows.push(parameter);
                        parameter.State = "2";
                    });
                    var obj = {};
                    obj.rows = rows;
                    obj.AuditPaperId = row.Id;

                    var para = CreateParameter(AuditPaperAction.ActionType.Post, AuditPaperAction.Functions.AuditPaperManagerMenu, AuditPaperAction.Methods.AuditPaperManagerMenu.BatchUpdate, obj);
                    DataManager.sendData(urls.functionsUrl, para, resultManagers.success, resultManagers.fail);
                }
            }
            ]
            });
        }
        );



        var resultManagers = {

            success: function (data) {
                if (data.success) {
                    MessageManager.InfoMessage(data.sMeg);                    
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
                var ur = urls.TreeUrl + "&Id=" + id;
                $("#tree").tree({ url: ur });
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
<body  class="easyui-layout" data-options="fit:true">
   <div data-options="region:'center'" title="<div class='title'>审计底稿</div>">
    <table class="easyui-datagrid"  id="roleGrid"
            data-options="singleSelect:true,method:'post',border:false,fit:true,fitColumns:true,url:urls.roleGridUrl,sortName:'CreateTime',sortOrder:'DESC',onSelect:eventManager.selectEvent">
        <thead>
            <tr>
                <th data-options="field:'Code',width:150,align:'left'">审计底稿编号</th>
                <th data-options="field:'Name',width:250,align:'left'">审计底稿名称</th>
                <th data-options="field:'Id',width:200,align:'left',hidden:true">Id</th>                
            </tr>
        </thead>
    </table>
   </div>
   <div data-options="region:'east',title:'',split:true,border:false" style="width:200px;background:#eee; height:100%">
   <div id="panel" style=" height:100%">
   <ul id="tree" class="easyui-tree" data-options="method:'post',animate:true,checkbox:true" style=" height:100%"></ul>
   </div>
   </div>
   <div id="Dialog" />
</body>
</html>


