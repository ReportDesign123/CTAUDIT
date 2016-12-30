<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProblemsManager.aspx.cs" Inherits="Audit.ct.ReportAudit.ProblemsManager" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
       <title>问题管理</title>

    <script src="../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <link href="../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="../../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script src="../../Scripts/AjaxTrigger.js" type="text/javascript"></script>


    <script src="../../lib/Editor/kindeditor-min.js" type="text/javascript"></script>
    <link href="../../lib/Editor/themes/default/default.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/Editor/lang/zh_CN.js" type="text/javascript"></script>


    <script type="text/javascript">
        var urls = {
            HandlerUrl: "../../handler/ReportProblemHandler.ashx",
            AddProblemUrl: "AddReportProblem.aspx",
            toAddUrl: "AddEditProblem.aspx"
        };

        ///参数应该来自上级页面
        var reportAuditId;
        var paramet = { ReportAuditId: reportParam.Id };
        var ReportPrblemGridUrl = CreateUrl(urls.HandlerUrl, ReportProblemAvtion.ActionType.Grid, ReportProblemAvtion.Functions.ReportProblem, ReportProblemAvtion.Methods.ReportProblemMethods.DataGridReportProblemEntity, paramet);
        $(function () {
            reportAuditId = reportParam.Id;
        }
        );      
        ///功能图标toolbar
        var toolBar = [{
            text: '增加',
            iconCls: 'icon-add',
            handler: function () {
                menuManager.AddMenu();
            }
        }, '-', {
            text: '编辑查看',
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
        }];
        //菜单管理器
        var menuManager = {
            AddMenu: function () {
                menuManager.OpenDialog(urls.toAddUrl, "添加疑点", "add");
            },
            ///编辑
            EditMenu: function () {
                var row = $("#roleGrid").datagrid("getSelected");
                var ur = "";
                if (row) {
                    ur = "?Id=" + row.Id;
                } else {
                    MessageManager.WarningMessage("请先选择一行再进行编辑！");
                    return;
                }

                menuManager.OpenDialog(urls.toAddUrl + ur, "修改疑点", "edit");

            },
            ///删除
            RemoveMenu: function () {
                var node = $("#roleGrid").datagrid("getSelected");
                var para = {};
                if (node != null) {
                    para["Id"] = node.Id;
                } else {
                    MessageManager.WarningMessage("请先选择一行再进行删除！");
                    return;
                } $.messager.confirm('系统提示', '你确定要删除此问题?', function (r) {
                    if (!r) { return; }
                    else {
                        var parameters = CreateParameter(ReportProblemAvtion.ActionType.Post, ReportProblemAvtion.Functions.ReportProblem, ReportProblemAvtion.Methods.ReportProblemMethods.Delete, para);
                        DataManager.sendData(urls.HandlerUrl, parameters, resultManagers.successDel, resultManagers.fail);
                    }
                });
            },
            ///弹窗界面
            OpenDialog: function (url, title, type) {
                $('#Dialog').dialog({
                    title: title,
                    width: 430,
                    height: 470,
                    href: url,
                    closed: false,
                    cache: false,
                    buttons: [
                    {
                        text: '保存',
                        iconCls: "icon-ok",
                        handler: function () {
                            if (type == "add") {
                                parameters = getParameters(ReportProblemAvtion.ActionType.Post, ReportProblemAvtion.Methods.ReportProblemMethods.Add);
                                if (!parameters) { return; }
                                parameters.ReportAuditId = reportParam.Id;
                                parameters.CompanyId = reportParam.CompanyId;
                                parameters.TaskId = reportParam.TaskId;
                                parameters.PaperId = reportParam.PaperId;
                                parameters.ReportId = reportParam.ReportId;
                                parameters.Year = reportParam.Year;
                                parameters.Zq = reportParam.Zq;
                                DataManager.sendData(urls.HandlerUrl, parameters, resultManagers.success, resultManagers.fail);
                            } else if (type == "edit") {
                                parameters = getParameters(ReportProblemAvtion.ActionType.Post, ReportProblemAvtion.Methods.ReportProblemMethods.Edit);
                                if (!parameters) { return; }
                                DataManager.sendData(urls.HandlerUrl, parameters, resultManagers.success, resultManagers.fail);
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
                    $("#roleGrid").datagrid('reload');
                    $('#Dialog').dialog('close');
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
<body>
    <table class="easyui-datagrid"  id="roleGrid"
                    data-options="singleSelect:true,method:'post',fit:true,url:ReportPrblemGridUrl,sortName:'CreateTime',sortOrder:'DESC',toolbar:toolBar,pagination:true">
            <thead>
                <tr>
                     <th data-options="field:'Id',width:150,align:'center',hidden:true"></th>
                    <th data-options="field:'Title',width:110,align:'center'">疑点标题</th>
                    <th data-options="field:'DependOn',width:150,align:'center'">创建依据</th>
                    <th data-options="field:'Type',width:100,align:'center'">疑点类型</th>
                    <th data-options="field:'Rank',width:100,align:'center'">疑点级别</th>
                    <th data-options="field:'Replay',width:100,align:'center'">答复内容</th>
                    <th data-options="field:'State',width:100,align:'center'">是否答复</th>
                </tr>
            </thead>
    </table>
    <div id="Dialog" >
       
    </div>
</body>
</html>


