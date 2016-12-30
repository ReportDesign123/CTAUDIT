<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AuditPaperReportTemplateManager.aspx.cs" Inherits="Audit.Scripts.AuditPaper.AuditPaperReportTemplateManager" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>用户管理</title>
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
            userGridUrl: "../../handler/AuditPaperHandler.ashx?ActionType=" + AuditPaperAction.ActionType.Grid + "&MethodName=" + AuditPaperAction.Methods.AuditPaperMenuMethods.getDataGrid + "&FunctionName=" + AuditPaperAction.Functions.AuditPaperMenu,
            functionsUrl: "../../handler/AuditPaperHandler.ashx",
            AddRole: "AddTemplate.aspx"


        };
        var toolBar = [
       {
           text: '增加',
           iconCls: 'icon-add',
           handler: function () {
               menuManager.AddMenu();
           }
       }, {
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
               menuManager.OpenDialog(urls.AddRole, "新建模板", "add");
           },
           EditMenu: function () {
               var row = $("#userGrid").datagrid("getSelected");
               var ur = "";
               if (row) {
                   ur = "?Id=" + row.Id;
               } else {
                   MessageManager.WarningMessage("请先选择一行在进行编辑！");
                   return;
               }
               menuManager.OpenDialog(urls.AddRole + ur, "编辑模板", "edit");
           },
           RemoveMenu: function () {
               var node = $("#userGrid").datagrid("getSelected");
               var para = {};
               if (node != null) {
                   para["Id"] = node.Id;
               } else {
                   MessageManager.WarningMessage("请先选择一行在进行删除！");
                   return;
               }
               var parameters = CreateParameter(AuditPaperAction.ActionType.Post, AuditPaperAction.Functions.AuditPaperMenu, AuditPaperAction.Methods.AuditPaperMenuMethods.Delete, para);
               DataManager.sendData(urls.functionsUrl, parameters, resultManagers.success, resultManagers.fail);
           },
           OpenDialog: function (url, title, type) {
               $('#Dialog').dialog({
                   title: title,
                   width: 600,
                   height: 400,
                   closed: false,
                   cache: false,
                   href: url,
                   modal: true,
                   buttons: [{
                       text: '保存',
                       iconCls: "icon-ok",
                       handler: function () {
                           if (type == "add") {
                               var action = urls.functionsUrl;
                               $("#TemplateForm").attr("action", action);
                               $("#TemplateForm").submit();                              
                           }else if(type=="edit"){
                                var action = urls.functionsUrl;
                               $("#TemplateForm").attr("action", action);
                               $("#Hidden2").val("Edit");
                               $("#TemplateForm").submit();                              
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
                    $("#userGrid").datagrid('reload');                  
                    $("#userGrid").datagrid('unselectAll');

                } else {
                    MessageManager.ErrorMessage(data.sMeg);
                }
            },
            fail: function (data) {

                MessageManager.ErrorMessage(data.toString);
            }
        };

        var eventManager = {
            selectEvent: function (rowIndex, rowData) {
                var id = rowData.Id;
                var ur = urls.TreeUrl + "&Id=" + id;
                $("#tree").tree({ url: ur });
            }
        };
    </script>
</head>
<body>
  <table class="easyui-datagrid"  id="userGrid"
            data-options="singleSelect:true,method:'post',fit:true,fitColumns:true,toolbar:toolBar,url:urls.userGridUrl,sortName:'CreateTime',sortOrder:'DESC',pagination:true">
        <thead>
            <tr>
              <th data-options="field:'Id',width:80,align:'left',hidden:true">Id</th>
                <th data-options="field:'Code',width:80,align:'left'">编号</th>
                <th data-options="field:'Name',width:120,align:'left'">名称</th>
                <th data-options="field:'Description',width:240,align:'left'">描述</th>     

            </tr>
        </thead>
    </table>
    <div id="Dialog"></div>
</body>
</html>

