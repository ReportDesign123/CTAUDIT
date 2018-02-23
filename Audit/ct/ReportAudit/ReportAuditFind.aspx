<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReportAuditFind.aspx.cs" Inherits="Audit.ct.ReportAudit.ReportAuditFind" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>报表问题查看</title>

    <script src="../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <script src="../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <link href="../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script src="../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <script src="../../Scripts/Ct_WorkFlow.js" type="text/javascript"></script>
    <script src="../../lib/Cookie/jquery.cookie.js" type="text/javascript"></script>
    <script src="../../Scripts/Cookie/Cookie.js" type="text/javascript"></script>
    <link href="../../Styles/Common.css" rel="stylesheet" type="text/css" />

    <script src="../../Scripts/ct_dialog.js" type="text/javascript"></script>
    <script type="text/javascript">
        var urls = {
            goProblemsFind: "ct/ReportAudit/ProblemsFind.aspx",
            ReportAduitUrl: "../../handler/ReportAuditHandler.ashx",
            getReportsUrl: "../../handler/FormatHandler.ashx",
            getCompanyUrl: "../../handler/BasicHandler.ashx"
        };
        var currentState = { ReportState: { auditPaperVisible: "1", auditZqVisible: "1" }, readyTask: false };
        var control = { Companys: {}, Reports: {} };
        var ReportStateComboData = [{
            value: "0", text: '未封存'
        }, {
            value: "1", text: '已封存'
        }, {
            value: "", text: '所有'
        }
        ];
        //菜单管理器
        var menuManager = {
            ///跳转到 问题查看 页面
            ViewProblemsFind: function () {
                var rows = $("#roleGrid").datagrid("getSelections");
                var ur = "";
                if (rows.length == 1) {
                    ur = "?Id=" + rows[0].Id + "&TaskId=" + currentState.ReportState.AuditTask.value + "&PaperId=" + currentState.ReportState.AuditPaper.value + "&Year=" + currentState.ReportState.Nd + "&Zq=" + currentState.ReportState.Zq + "&ReportType=" + currentState.ReportState.auditZqType;
                } else {
                    MessageManager.InfoMessage("请选择要编辑的报表,然后再进行此操作！");
                    return;
                }
                parent.NavigatorNode({ id: "055", text: "问题查看", attributes: { url: urls.goProblemsFind + ur } });
            },
            ///导出问题
            ExcelProblem: function () {
                var rows = $("#roleGrid").datagrid("getChecked");
                var Datas = [];
                if (rows.length) {
                    $.each(rows, function (index) {
                        var par = {};
                        par.Id = rows[index].Id;
                        par.ReportName = rows[index].ReportName;
                        par.CompanyName = rows[index].CompanyName;
                        Datas.push(par);
                    });
                } else {
                    MessageManager.WarningMessage("请先选择要导出问题的报表，然后再进行此操作！");
                    return;
                }
                var parm = { datas: JSON.stringify(Datas) };
                var ExportUrl = CreateUrl(urls.ReportAduitUrl, ReportAuditAction.ActionType.Post, ReportAuditAction.Functions.ReportAudit, ReportAuditAction.Methods.ReportAuditMethods.ExportProblems, parm);
                window.location.href = ExportUrl;

            },
            BatchSelect: function () {
                if (currentState.batchSelect) {
                    $("#selectType").text("批量操作");
                    currentState.batchSelect = false;
                    $("#roleGrid").datagrid({ singleSelect: true });
                } else {
                    $("#selectType").text("取消批量操作");
                    currentState.batchSelect = true;
                    $("#roleGrid").datagrid({ singleSelect: false });
                }
            }
        };
        ///结果处理 
        var resultManagers = {
            successExport: function (data) {
                if (data.success) {
                    $("#roleGrid").datagrid('reload');
                    $("#roleGrid").datagrid('unselectAll');
                } else {
                    MessageManager.ErrorMessage(data.sMeg);
                }
            },
            successUpdate: function (data) {
                if (data.success) {
                } else {
                    MessageManager.ErrorMessage(data.sMeg);
                }
            },
            fail: function (data) {
                MessageManager.ErrorMessage(data.toString);
            }
        };
        $(
        function () {
            $("#ReportSt").combobox({
                data: ReportStateComboData,
                valueField: 'value',
                textField: 'text'
            });
            var tempState = CookieDataManager.GetCookieData(ReportAuditAction.Functions.ReportAuditFind);
            //cookie
            if (tempState) {
                ChangeTask(tempState);
            } else { ChangeTask(); }
            //回车监听
            $(document).keypress(function (e) {
                var curKey = e.which;
                if (curKey == 13) {
                    searchReport();
                }
            });
        });
        ///报表数据加载
        ///输入参数：{url， id：roleGrid }
        ///张双义
        function LoaddataGrid(url, id) {
            $("#" + id).datagrid({
                url: url,
                columns: [[
                      { field: 'CompanyId', title: 'CompanyId', width: 100, hidden: true },
                       { field: 'Id', title: 'checkbox', checkbox: true },
                       { field: 'ReportCode', title: '报表编号', width: 120 },
                       { field: 'ReportName', title: '报表名称', width: 190 },
                       { field: 'CompanyCode', title: '单位编号', width: 120 },
                       { field: 'CompanyName', title: '单位名称', width: 200 },
                       {
                           field: 'State', title: '封存状态', width: 100, align: 'center', formatter: function (value, row, index) {
                               if (row.State == "1") {
                                   return "已封存";
                               }
                               else { return "未封存"; }
                           }
                       },
                       {
                           field: 'NotProcessNumber', title: '未处理', align: 'right', width: 100, styler: function (value, row, index) { return 'color:red;'; }
                       },
                       {
                           field: 'ProcessNumber', title: '已处理', align: 'right', width: 100, styler: function (value, row, index) { return 'color:green;'; }
                       }
                ]],
                fit: true,
                fitColumns: true,
                idField: "",
                toolbar: "#toolbar",
                pagination: true,
                singleSelect: true,
                rownumbers: true,
                checkOnSelect: true,
                sortName: "CreateTime",
                sortOrder: "DESC"
            });
        }
        function ChangeTask(cookie) {
            var result = {};
            currentState.ReportState["auditPaperVisible"] = "1";
            currentState.ReportState["auditZqVisible"] = "1";
            if (cookie) {
                result = cookie;
                if (result && result != undefined) {
                    currentState.ReportState = result;
                    currentState.readyTask = true;
                    var para = { TaskId: "", PaperId: "", Nd: "", Zq: "", ReportType: "" };
                    para.TaskId = result.AuditTask.value;
                    para.PaperId = result.AuditPaper.value;
                    para.Year = result.Nd;
                    para.Zq = result.Zq;
                    para.ReportType = result.auditZqType;

                    var url = CreateUrl(urls.ReportAduitUrl, ReportAuditAction.ActionType.Grid, ReportAuditAction.Functions.ReportAudit, ReportAuditAction.Methods.ReportAuditMethods.DataGridReportAuditEntity, para);
                    LoaddataGrid(url, "roleGrid");
                    ///保存cookie
                    CookieDataManager.SetCookieData(ReportAuditAction.Functions.ReportAuditFind, result);
                }
            } else {
                dialog.Open("ct/ReportData/ChooseAuditTask.aspx", "切换任务", currentState.ReportState, function (result) {
                    if (result && result != undefined) {
                        currentState.ReportState = result;
                        currentState.readyTask = true;
                        var para = { TaskId: "", PaperId: "", Nd: "", Zq: "", ReportType: "" };
                        para.TaskId = result.AuditTask.value;
                        para.PaperId = result.AuditPaper.value;
                        para.Year = result.Nd;
                        para.Zq = result.Zq;
                        para.ReportType = result.auditZqType;

                        var url = CreateUrl(urls.ReportAduitUrl, ReportAuditAction.ActionType.Grid, ReportAuditAction.Functions.ReportAudit, ReportAuditAction.Methods.ReportAuditMethods.DataGridReportAuditEntity, para);
                        LoaddataGrid(url, "roleGrid");
                        ///保存cookie
                        CookieDataManager.SetCookieData(ReportAuditAction.Functions.ReportAuditFind, result);
                    }
                }, { width: 440, height: 500 });

            }

        }
        ///查询方法
        ///参数  查询条件 { companyCode: "", reportCode: "", State: "", ReportType: "" }
        ///返回：页面刷新数据查询结果
        ///张双义
        function searchReport() {
            if (!currentState.readyTask) return;
            var para = { companyCode: "", companyName: "", reportCode: "", reportName: "", State: "", ReportType: "" };
            para.companyCode = $("#companyCode").val();
            para.companyName = $("#companyName").val();
            para.reportCode = $("#reportCode").val();
            para.reportName = $("#reportName").val();
            para.State = $("#ReportSt").combobox("getValue");

            $('#roleGrid').datagrid('reload', para);
        }
        function freeSearch() {
            if (!currentState.readyTask) return;
            $("#companyCode").val("");
            $("#companyName").val("");
            $("#reportCode").val("");
            $("#reportName").val("");
            $("#ReportViewSt").combobox("setValue", "");
            $("#ReportSt").combobox("setValue", "");
            $('#roleGrid').datagrid('reload');
        }
    </script>
</head>
<body class="easyui-layout">
    <div data-options="region:'north',title:'',collapsible:false" style="height: 32px; padding: 2px; background-color: #E0ECFF; overflow: hidden">
        <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="menuManager.ViewProblemsFind()" style="width: 90px; float: left" plain="true">问题查看</a>
        <div class="datagrid-btn-separator"></div>
        <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-print'" onclick="menuManager.ExcelProblem()" style="width: 90px; float: left" plain="true">导出问题</a>
        <div class="datagrid-btn-separator"></div>
        <a href="#" class="easyui-linkbutton" id="unSingleSelect" onclick="menuManager.BatchSelect()" plain="true"><span id="selectType">批量操作</span></a>
    </div>
    <div data-options="region:'center'" style="border: 0px">
        <div id="toolbar" class="datagrid-toolbar" style="min-width: 900px">
            <table style="width: 100%">
                <tr>
                    <td style="width: 60px">报表编号</td>
                    <td style="width: 170px">
                        <input id="reportCode" class="easyui-validatebox textbox" /></td>
                    <td style="width: 60px">报表名称</td>
                    <td style="width: 170px">
                        <input id="reportName" class="easyui-validatebox textbox" /></td>
                    <td style="width: 60px">单位编号</td>
                    <td style="width: 170px">
                        <input id="companyCode" class="easyui-validatebox textbox" /></td>
                    <td style="width: 60px">单位名称</td>
                    <td>
                        <input id="companyName" class="easyui-validatebox textbox" /></td>
                </tr>
                <tr>
                    <td style="width: 60px">封存状态:</td>
                    <td>
                        <input id="ReportSt" value="" type="text" class="easyui-combobox" data-options="panelHeight:'auto'" /></td>
                    <td style="text-align: right" colspan="6">
                        <a class="easyui-linkbutton" onclick="searchReport()" iconcls="icon-search" style="margin-right: 10px">查询</a>
                        <a class="easyui-linkbutton" onclick="freeSearch()" iconcls="icon-undo" style="">重置</a>
                    </td>
                </tr>
            </table>
        </div>
        <table id="roleGrid"></table>
    </div>
    <div data-options="region:'south',collapsible:false" style="height: 30px; text-align: center; font-size: 12px; overflow: hidden;">
        <p><a href="#" onclick="ChangeTask();return false;">审计任务切换</a></p>
    </div>
</body>
</html>


