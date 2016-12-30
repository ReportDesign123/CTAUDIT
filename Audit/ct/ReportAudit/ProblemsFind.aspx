<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProblemsFind.aspx.cs" Inherits="Audit.ct.ReportAudit.ProblemsFind" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
       <title>问题发现</title>

    <script src="../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <link href="../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="../../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script src="../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <script src="../../lib/json2.js" type="text/javascript"></script>

    <script src="../../lib/Editor/kindeditor-min.js" type="text/javascript"></script>
    <link href="../../lib/Editor/themes/default/default.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/Editor/lang/zh_CN.js" type="text/javascript"></script>

    <script src="../../Scripts/Ct_Controls.js" type="text/javascript"></script>
    <link href="../../Styles/Ct_Controls.css" rel="stylesheet" type="text/css" />
    <script src="../../Scripts/ct/pub/PubHelp.js" type="text/javascript"></script>

    <script type="text/javascript">
        var urls = {
            HandlerUrl: "../../handler/ReportProblemHandler.ashx",
            ReportAduitUrl: "../../handler/ReportAuditHandler.ashx",
            ProblemIfUrl: "AddEditProblem.aspx"
        };
        ///参数应该来自上级页面
        var control = { Paras: { ReportAuditId: "<%=rae.Id %>" }, Reports: {},ReportAuditParam:{ PaperId: "<%=rae.PaperId%>", ReportType: "<%=rae.ReportType%>", TaskId: "<%=rae.TaskId%>", Year: "<%=rae.Year%>", Zq: "<%=rae.Zq%>"} };
        var ReportPrblemGridUrl = CreateUrl(urls.HandlerUrl, ReportProblemAvtion.ActionType.Grid, ReportProblemAvtion.Functions.ReportProblem, ReportProblemAvtion.Methods.ReportProblemMethods.DataGridReportProblemEntity, control.Paras);

        $(function () {
            ///帮助窗口声明
            control.Reports = $("#Report").PopEdit();
            control.Reports.btn.bind("click", function () {
                report_ClickEvent();
            });
        }
        )
        //菜单管理器
        var menuManager = {
            ///查看问题
            ViewProblem: function () {
                var row = $("#roleGrid").datagrid("getSelected");
                var ur = "";
                if (row) {
                    ur = "?Id=" + row.Id;
                } else {
                    MessageManager.WarningMessage("请先选择一行！");
                    return;
                }
                menuManager.OpenDialog(urls.ProblemIfUrl + ur, "问题信息", "view");
            },
            ///弹窗界面
            OpenDialog: function (url, title, type) {
                $('#Dialog').dialog({
                    title: title,
                    width: 430,
                    height: 470,
                    closed: false,
                    cache: false,
                    href: url,
                    modal: true,
                    buttons: [
                    {
                        text: '返回',
                        iconCls: "icon-back",
                        handler: function () {
                            $('#Dialog').dialog("close");
                        }
                    }
                    ]
                });
            }
        };
        ///结果处理
        var resultManagers = {
            success: function (data) {
                $("#roleGrid").datagrid('loadData', data);
            },
            fail: function (data) {
                MessageManager.ErrorMessage(data.toString);
            }
        }
        ///报表编号 帮助窗口触发
        ///输出参数：{name：report.bbCode, value: report.bbCode}
        ///张双义
        function report_ClickEvent() {
            var paras = { url: "", columns: [], sortName: "", sortOrder: "" };
            paras.url = CreateUrl(urls.ReportAduitUrl, ReportAuditAction.ActionType.Grid, ReportAuditAction.Functions.ReportAudit, ReportAuditAction.Methods.ReportAuditMethods.DataGridReportAuditEntity, control.ReportAuditParam);
            ///窗口table显示字段
            paras.columns = [[
                { field: "Id", title: "id", hidden: true, width: 120 },
                { field: "ReportCode", title: "报表编号", width: 100 },
                    { field: "ReportName", title: "报表名称", width: 180 },
                    { field: 'CompanyName', title: '单位名称', width: 180 }
                    ]];
            paras.sortName = "CreateTime";
            paras.sortOrder = "DESC";
             paras.width = 500;
            paras.height = 420;
            pubHelp.setParameters(paras);
            pubHelp.OpenDialogWithHref("Dialog", "报表切换", "../pub/HelpDialogEasyUi.htm", getClassifyChoice, paras.width, paras.height, true);
        }
       
        function getClassifyChoice() {
            var result = pubHelp.getResultObj();
            if (result && result.ReportCode) {
                control.Reports.name.val(result.ReportName + ":" + result.CompanyName);
                control.Paras.ReportAuditId = result.Id;
                ///此处需要获取新的数据包
                //$('#roleGrid').datagid();
                // var ReportPrblemGridUrl = CreateUrl(urls.HandlerUrl, ReportProblemAvtion.ActionType.Grid, ReportProblemAvtion.Functions.ReportProblem, ReportProblemAvtion.Methods.ReportProblemMethods.DataGridReportProblemEntity, control.Paras);
                var paramet = CreateParameter(ReportProblemAvtion.ActionType.Post, ReportProblemAvtion.Functions.ReportProblem, ReportProblemAvtion.Methods.ReportProblemMethods.DataGridReportProblemEntity, control.Paras);
                paramet.sort = "CreateTime";
                DataManager.sendData(urls.HandlerUrl, paramet, resultManagers.success, resultManagers.fail);
            }
        }
        ///类型和级别
        ///显示替换
        function TextType(value, row, index) {
            return value + " 类";
        }
        function TextRank(value, row, index) {
            return value + " 级";
        }
    </script>
</head>
<body>

    <div id="toobar">
    <table><tr>
         <td><a href="#" class="easyui-linkbutton" onclick="menuManager.ViewProblem()" iconcls="icon-search" plain="true">问题查看</a></td>
         <td>报表切换：</td><td><div id="Report"></div></td>
    </tr></table>
    </div>
    <table class="easyui-datagrid"  id="roleGrid"
                    data-options="singleSelect:true,method:'post',fit:true,url:ReportPrblemGridUrl,sortName:'CreateTime',sortOrder:'DESC',toolbar:toobar,pagination:true">
            <thead>
                <tr>
                     <th data-options="field:'Id',width:150,align:'center',hidden:true"></th>
                    <th data-options="field:'Title',width:110,align:'center'">疑点标题</th>
                    <th data-options="field:'DependOn',width:150,align:'center'">创建依据</th>
                    <th data-options="field:'Type',width:100,align:'center',formatter:TextType">疑点类型</th>
                    <th data-options="field:'Rank',width:100,align:'center',formatter:TextType">疑点级别</th>
                    <th data-options="field:'Replay',width:100,align:'center'">答复内容</th>
                    <th data-options="field:'State',width:100,align:'center'">是否答复</th>
                </tr>
            </thead>
    </table>
    <div id="Dialog" />
</body>
</html>


