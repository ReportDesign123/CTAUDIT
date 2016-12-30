<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AuditTaskCompanies.aspx.cs" Inherits="Audit.ct.AuditTask.AuditTaskCompanies" %>


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
            roleGridUrl: "../../handler/AuditTaskHandler.ashx?ActionType=" + AuditTaskAction.ActionType.Grid + "&MethodName=" + AuditTaskAction.Methods.AuditTaskManagerMethods.GetDataGrid + "&FunctionName=" +AuditTaskAction.Functions.AuditTaskManager,
            functionsUrl: "../../handler/AuditTaskHandler.ashx",
            TreeUrl: "../../handler/AuditTaskHandler.ashx?ActionType=" + AuditTaskAction.ActionType.Grid + "&MethodName=" + AuditTaskAction.Methods.AuditTaskManagerMethods.TreeNodesAuditTaskAuthorities + "&FunctionName=" + AuditTaskAction.Functions.AuditTaskManager

        };
        var roleGrid;

        $(
        function () {
            $("#panel").panel({
                title: "组织机构保存",
                fit: true,
                tools: [
            {
                iconCls: 'icon-save',
                handler: function () {
                    var row = $("#roleGrid").datagrid("getSelected");
                    var notes = $("#tree").tree('getChecked', ['checked']);
                    var rows = [];
                    $.each(notes, function (index) {
                        var parameter = { Id: "", TaskId: "", CompanyId: "", State: "" };
                        parameter.CompanyId = notes[index].id;
                        parameter.TaskId = row.Id;
                        parameter.State = "1";
                        rows.push(parameter);
                    });

                    notes = $("#tree").tree('getChecked', ['indeterminate']);
                    $.each(notes, function (index) {
                        var parameter = { Id: "", TaskId: "", CompanyId: "", State: "" };
                        parameter.CompanyId = notes[index].id;
                        parameter.TaskId = row.Id;
                        parameter.State = "2";
                        rows.push(parameter);
                    });
                    var obj = {};
                    obj.rows = rows;
                    obj.AuditTaskId = row.Id;

                    var para = CreateParameter(AuditTaskAction.ActionType.Post, AuditTaskAction.Functions.AuditTaskManager, AuditTaskAction.Methods.AuditTaskManagerMethods.BatchUpdate, obj);
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
   <div data-options="region:'center'" title="<div class='title'>审计任务</div>">
    <table class="easyui-datagrid"  id="roleGrid"
            data-options="singleSelect:true,method:'post',border:false,fit:true,fitColumns:true,url:urls.roleGridUrl,sortName:'CreateTime',sortOrder:'DESC',onSelect:eventManager.selectEvent">
        <thead>
            <tr>
                <th data-options="field:'Code',width:160,align:'left'">审计任务编号</th>
                <th data-options="field:'Name',width:200,align:'left'">审计任务名称</th>
                <th data-options="field:'Id',width:200,align:'left',hidden:true">Id</th>                
            </tr>
        </thead>
    </table>
   </div>
   <div data-options="region:'east',title:'',split:true,border:false" style="width:200px;background:#eee;">
   <div id="panel">
   <ul id="tree" class="easyui-tree" data-options="method:'post',animate:true,checkbox:true"></ul>
   </div>
   </div>
   <div id="Dialog" />
</body>
</html>


