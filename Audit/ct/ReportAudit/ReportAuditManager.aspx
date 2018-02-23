<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReportAuditManager.aspx.cs"
    Inherits="Audit.ct.ReportAudit.ReportAuditManager" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>审计资料</title>
    <script src="../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <script src="../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <link href="../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script src="../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <script src="../../lib/Cookie/jquery.cookie.js" type="text/javascript"></script>
    <script src="../../Scripts/Cookie/Cookie.js" type="text/javascript"></script>
    <link href="../../Styles/Common.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/json2.js" type="text/javascript"></script>
    
       <script src="../../Scripts/ct_dialog.js" type="text/javascript"></script>
    <script type="text/javascript">
        var urls = {
            ProblemHandlerUrl: "../../handler/ReportProblemHandler.ashx",
            ReportAduitUrl: "../../handler/ReportAuditHandler.ashx",
            goProblemsUrl: "ct/ReportAudit/ProblemsManager.aspx",
            getReportsUrl: "../../handler/FormatHandler.ashx",
            getCompanyUrl: "../../handler/BasicHandler.ashx",
            goAuditReport: "ct/ReportAudit/ReportAudit.aspx"
        };

        var currentState = { ReportState: { auditPaperVisible: "1", auditZqVisible: "1"},readyTask:false,batchSelect:false };
        var control = { Companys: {}, Reports: {} };
        var editIndex = undefined;
        var ReportViewStateComboData = [{
            value: "0", text: '未查看'
        }, { value: "1", text: '已查看'
        }, { value: "", text: '所有'
        }
		];
        var ReportStateComboData = [{
            value: "0", text: '未封存'
        }, { value: "1", text: '已封存'
        }, { value: "", text: '所有'
        }
		];
        //菜单管理器
        var menuManager = {
            ///跳转 问题管理 界面
            GoProblemsManager: function () {
                var rows = $("#roleGrid").datagrid("getSelections");
                var ur = "";
                if (rows.length == 1) {
                    var para = { Id: "", TaskId: "", PaperId: "", Year: "", Zq: "", ReportType: "", CompanyId: "", ReportId: "", ReportName: "" };
                    para.TaskId = currentState.ReportState.AuditTask.value;
                    para.PaperId = currentState.ReportState.AuditPaper.value;
                    para.Year = currentState.ReportState.Nd;
                    para.Zq = currentState.ReportState.Zq;
                    para.ReportId = rows[0].ReportId;
                    para.CompanyId = rows[0].CompanyId;
                    para.Id = rows[0].Id;
                    para = JSON2.stringify(para);
                    para = encodeURI(para);
                    ur = "?para=" + para;
                } else {
                    MessageManager.InfoMessage("请选择要编辑的报表,然后再进行此操作！");
                    return;
                }
                parent.NavigatorNode({ id: "055", text: "问题管理", attributes: { url: urls.goProblemsUrl + ur} });
            },
            ///审计报表
            AuditReport: function () {
                var rows = $("#roleGrid").datagrid("getSelections");
                if (rows.length == 1) {
                    var para = { TaskId: "", PaperId: "", Year: "", Cycle: "", ReportType: "", CompanyId: "", ReportId: "", ReportName: "" };
                    para.TaskId = currentState.ReportState.AuditTask.value;
                    para.PaperId = currentState.ReportState.AuditPaper.value;
                    para.Year = currentState.ReportState.Nd;
                    para.Cycle = currentState.ReportState.Zq;
                    para.ReportType = currentState.ReportState.auditZqType;
                    para.ReportId = rows[0].ReportId;
                    para.CompanyId = rows[0].CompanyId;
                    para.ReportName = rows[0].ReportName;

                    if (parent.NavigatorNode) {
                        var url = CreateGeneralUrl(urls.goAuditReport, para);
                        parent.NavigatorNode({ id: "0001", text: "报表审计", attributes: { url: url} });
                    } else {
                        url = CreateGeneralUrl("ReportAudit.aspx", para);
                        window.open(url, '报表审计', 'top=0,left=0,toolbar=no,menubar=no,scrollbars=no, status=no');
                    }

                } else {
                    MessageManager.InfoMessage("请选择要编辑的报表，然后再进行此操作");
                }
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
        }
        $(
        function () {
            ///combobox 选项加载
            $("#ReportViewSt").combobox({
                data: ReportViewStateComboData,
                valueField: 'value',
                textField: 'text'
            });
            $("#ReportSt").combobox({
                data: ReportStateComboData,
                valueField: 'value',
                textField: 'text'
            });
            //cookie
            var tempState = CookieDataManager.GetCookieData(ReportAuditAction.Functions.ReportAuditManager);
            if (tempState) {
                ChangeTask(tempState);
            } else {
                ChangeTask("");
            }
            $(document).keypress(function (e) {
                var curKey = e.which;
                if (curKey == 13) {
                    searchReport();
                }
            });
        });
        ///生成table列表
        ///参数：{url，id，toobr}
        function LoadDataGrid(url, id) {
            $("#" + id).datagrid({
                url: url,
                columns: [[
                { field: 'Id', checkbox: true, width: 30 },
                    { field: 'ReportCode', title: '报表编号', width: 120, sortable: true },
                    { field: 'ReportName', title: '报表名称', width: 190, sortable: true },
                    { field: 'CompanyCode', title: '单位编号', width: 120, sortable: true },
                    { field: 'CompanyName', title: '单位名称', width: 190, sortable: true },
                    { field: 'State', title: '封存状态', width: 100, align: 'center', sortable: true, formatter: function (value, row, index) {
                        if (row.State == 1) {
                            return "已封存";
                        } else {
                            return "未封存";
                        }
                    }
                    },
                    { field: 'IsOrNotRead', title: '是否查看', align: 'center', width: 100, sortable: true,
                        formatter: function (value, row) {
                            if (row.IsOrNotRead == "1") {
                                return "已查看";
                            } else {
                                return "未查看";
                            }
                        },
                        editor: { type: 'checkbox', options: { on: "1", off: "0"} }
                    },
                     { field: 'ReportId', title: '报表ID', width: 150, hidden: true },
                    { field: 'CompanyId', title: '单位ID', width: 150, hidden: true }
                ]],
                fit: true,
                fitColumns: true,
                idField: "",
                toolbar: "#toolbar",
                fitColumns: true,
                singleSelect: true,
                pagination: true,
                rownumbers: true,
                selectOnCheck: true,
                checkOnSelect: true,
                sortName: "CreateTime",
                sortOrder: "DESC",
                onDblClickRow: menuManager.AuditReport,
                onClickCell: function (rowIndex, field, value) {
                    if (field == "IsOrNotRead") {
                        EditManager.onClickCell(rowIndex);
                    } else {
                        EditManager.onClickCell();
                    }
                }
            });
        }
        ///报表查看
        ///编辑处理
        $(document).delegate("body", "click", function (e) {
            if (editIndex != undefined) {
                $('#roleGrid').datagrid('endEdit', editIndex);
                $('#roleGrid').datagrid('selectRow', editIndex);
                editIndex = undefined;
            }
        });
        var EditManager = {
            onClickCell: function (index) {
                if (EditManager.endEditing()) {
                    $('#roleGrid').datagrid('selectRow', index).datagrid('beginEdit', index);
                    editIndex = index;
                } else {
                    $('#roleGrid').datagrid('selectRow', editIndex);
                }
            },
            endEditing: function () {
                if (editIndex == undefined) { return true }
                if ($('#roleGrid').datagrid('validateRow', editIndex)) {
                    var ed = $('#roleGrid').datagrid('getEditor', { index: editIndex, field: 'IsOrNotRead' });
                    if (!ed) { return true }
                    var IsOrNotRead = $(ed.target).is(':checked');
                    $('#roleGrid').datagrid('endEdit', editIndex);
                    var para = {};
                    para.Id = $('#roleGrid').datagrid('getRows')[editIndex].Id;
                    if (IsOrNotRead) {
                        para.IsOrNotRead = 1;
                    } else {
                        para.IsOrNotRead = 0;
                    }
                    var parameters = CreateParameter(ReportAuditAction.ActionType.Post, ReportAuditAction.Functions.ReportAudit, ReportAuditAction.Methods.ReportAuditMethods.Update, para);
                    DataManager.sendData(urls.ReportAduitUrl, parameters, resultManagers.successUpdate, resultManagers.fail);
                    editIndex = undefined;
                    return true;
                } else {
                    return false;
                }
            }
        }
        ///审计任务切换
        ///参数：在弹出的帮助窗口中选择筛选条件
        ///张双义
        function ChangeTask(cookie) {
            var result = {};
            currentState.ReportState["auditPaperVisible"] = "1";
            currentState.ReportState["auditZqVisible"] = "1";
            if (cookie && cookie != "") {
                result = cookie;
                if (result && result != undefined) {
                    currentState.ReportState = result;
                    currentState.readyTask = true;
                    var para = { TaskId: "", PaperId: "", Year: "", Zq: "", ReportType: "" };
                    para.TaskId = result.AuditTask.value;
                    para.PaperId = result.AuditPaper.value;
                    para.Year = result.Nd;
                    para.Zq = result.Zq;
                    para.ReportType = result.auditZqType;
                    var url = CreateUrl(urls.ReportAduitUrl, ReportAuditAction.ActionType.Grid, ReportAuditAction.Functions.ReportAudit, ReportAuditAction.Methods.ReportAuditMethods.DataGridReportAuditEntity, para);
                    LoadDataGrid(url, "roleGrid");
                    ///保存cookie
                    CookieDataManager.SetCookieData(ReportAuditAction.Functions.ReportAuditManager, result);
                }
            } else {
                dialog.Open("ct/ReportData/ChooseAuditTask.aspx", "切换任务", currentState.ReportState, function (result) {
                    if (result && result != undefined) {
                        currentState.ReportState = result;
                        currentState.readyTask = true;
                        var para = { TaskId: "", PaperId: "", Year: "", Zq: "", ReportType: "" };
                        para.TaskId = result.AuditTask.value;
                        para.PaperId = result.AuditPaper.value;
                        para.Year = result.Nd;
                        para.Zq = result.Zq;
                        para.ReportType = result.auditZqType;
                        var url = CreateUrl(urls.ReportAduitUrl, ReportAuditAction.ActionType.Grid, ReportAuditAction.Functions.ReportAudit, ReportAuditAction.Methods.ReportAuditMethods.DataGridReportAuditEntity, para);
                        LoadDataGrid(url, "roleGrid");
                        ///保存cookie
                        CookieDataManager.SetCookieData(ReportAuditAction.Functions.ReportAuditManager, result);
                    }
                }, { width: 440, height: 500 });

                 }
           
        }
        ///查询方法
        ///参数：查询条件 { companyCode: "", reportCode: "", State: "", IsOrNotRead: "",companyName:"" }
        ///返回：页面刷新数据查询结果
        ///张双义
        function searchReport() {
            if (!currentState.readyTask) return;
            var para = { companyCode: "", reportCode: "", State: "", IsOrNotRead: "",companyName:"",reportName:"" };
            para.companyCode = $("#companyCode").val();
            para.companyName = $("#companyName").val();
            para.reportCode = $("#reportCode").val();
            para.reportName = $("#reportName").val();
            para.IsOrNotRead = $("#ReportViewSt").combobox("getValue");
            para.State = $("#ReportSt").combobox("getValue");
            $('#roleGrid').datagrid('reload', para);
        }
        function freeSearch() {
            if (!currentState.readyTask) return;
            $("#companyCode").val("");
            $("#companyName").val("");
            $("#reportCode").val("");
            $("#reportName").val("");
            $("#ReportViewSt").combobox("setValue","");
            $("#ReportSt").combobox("setValue","");
            $('#roleGrid').datagrid('reload');
        }        
    </script>
</head>
<body  class="easyui-layout">
    <div data-options="region:'north',title:'',collapsible:false" style="height:32px; padding:2px;background-color:#E0ECFF ;overflow:hidden">
        <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-audit'" onclick="menuManager.AuditReport()" style="width:90px; float:left"plain="true">审计报表</a>
        <div class="datagrid-btn-separator"></div>
        <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="menuManager.GoProblemsManager()" style="width:90px; float:left"plain="true">问题管理</a>
        <div class="datagrid-btn-separator"></div>
        <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-print'" onclick="menuManager.ExcelProblem()" style="width:90px; float:left"plain="true">导出问题</a>
        <div class="datagrid-btn-separator"></div>
        <a href="#" class="easyui-linkbutton" id="unSingleSelect" onclick="menuManager.BatchSelect()" plain="true"><span id="selectType">批量操作</span></a>
    </div>
    <div data-options="region:'center'" style=" border:0px">
    <div id="toolbar" class="datagrid-toolbar" style=" min-width:900px">
            <table style="width:100%">
                <tr>
                    <td style=" width:60px">报表编号</td><td style=" width:170px"> <input id = "reportCode"class="easyui-validatebox textbox"  /></td>
                    <td style=" width:60px">报表名称</td><td style=" width:170px"><input id = "reportName"class="easyui-validatebox textbox"  /></td>
                    <td style=" width:60px">单位编号</td><td style=" width:170px"> <input id = "companyCode"class="easyui-validatebox textbox"  /></td>
                    <td style=" width:60px">单位名称</td><td><input id = "companyName"class="easyui-validatebox textbox"  /></td>
                </tr>
                <tr>
                    <td style=" width:60px">封存状态:</td><td><input id="ReportSt" value="" type="text" class="easyui-combobox" data-options="panelHeight:'auto'" /></td>
                    <td style=" width:60px">查看状态:</td><td><input id="ReportViewSt" value="" type="text" class="easyui-combobox" data-options="panelHeight:'auto'" /></td>
                    <td style=" text-align:right" colspan="4">
                    <a class="easyui-linkbutton" onclick="searchReport()" iconcls="icon-search" style=" margin-right:10px">查询</a>
                    <a class="easyui-linkbutton" onclick="freeSearch()" iconcls="icon-undo" style="">重置</a>
                </td>
                </tr>
            </table>
        </div>
        <table id="roleGrid"></table>
    </div>
     <div data-options="region:'south',collapsible:false" style="height:30px; text-align:center;font-size:12px;overflow:hidden;">
     <p><a href="#" onclick="ChangeTask();return false;">审计任务切换</a></p>        
     </div>
</body>
</html>
