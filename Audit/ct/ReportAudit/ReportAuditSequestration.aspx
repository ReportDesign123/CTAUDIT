<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReportAuditSequestration.aspx.cs" Inherits="Audit.ct.ReportAudit.ReportAuditSequestration" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>审计封存</title>

    <script src="../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <script src="../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <link href="../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script src="../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <link href="../../Styles/Common.css" rel="stylesheet" type="text/css" /> 
     <script src="../../lib/Cookie/jquery.cookie.js" type="text/javascript"></script>
    <script src="../../Scripts/Cookie/Cookie.js" type="text/javascript"></script>
    <script type="text/javascript">
        var urls = {
            getReportsUrl: "../../handler/FormatHandler.ashx",
            getCompanyUrl: "../../handler/BasicHandler.ashx",
            ReportAduitUrl: "../../handler/ReportAuditHandler.ashx"
        };

        var currentState = { ReportState: { auditPaperVisible: "1", auditZqVisible: "1"},readyTask:false };
        var control = { Companys: {}, Reports: {} };
        var ReportViewStateComboData = [{
            value: "0", text: '未查看'
        }, { value: "1", text: '已查看'
        }, { value: "", text: '所有'
        }];
        var ReportStateComboData = [{
            value: "0", text: '未封存'
        }, { value: "1", text: '已封存'
        }, { value: "", text: '所有'
        }];
        ///参数：Type
        ///用途：审计状态改变
        ///张双义
        function Sequestrate(Type) {
            var Ids="";
            var rows = $("#roleGrid").datagrid('getChecked');
            if (rows.length>0) {
                $.each(rows, function (index) {
                    if (index == 0) {
                        Ids = rows[index].Id;
                    } else {
                        Ids = Ids + "," + rows[index].Id;
                    }
                });
            } else {
                MessageManager.WarningMessage("请先选择一行再进行编辑！");
                return;
            }
            var para = {};
            para["Ids"] =Ids;
            if (Type == "1") {
                var parameters = CreateParameter(ReportAuditAction.ActionType.Post, ReportAuditAction.Functions.ReportAudit, ReportAuditAction.Methods.ReportAuditMethods.AuditClose, para);
                DataManager.sendData(urls.ReportAduitUrl, parameters, resultManagers.success, resultManagers.fail);
            } else if (Type == "0") {
                var parameters = CreateParameter(ReportAuditAction.ActionType.Post, ReportAuditAction.Functions.ReportAudit, ReportAuditAction.Methods.ReportAuditMethods.CancelAuditClose, para);
                DataManager.sendData(urls.ReportAduitUrl, parameters, resultManagers.success, resultManagers.fail);
            }
        }
        ///返回消息处理
        var resultManagers = {
            success: function (data) {
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
        $(
        function () {
            ///combobox 选项加载
            $("#ReportSt").combobox({
                data: ReportStateComboData,
                valueField: 'value',
                textField: 'text'
            });
            //cookiie
            var tempState = CookieDataManager.GetCookieData(ReportAuditAction.Functions.ReportAuditSequestration);
            if (tempState) {
                ChangeTask(tempState);
            } else {
                ChangeTask("");
            }
            //回车监听
            $(document).keypress(function (e) {
                var curKey = e.which;
                if (curKey == 13) {
                    searchReport();
                }
            });
        });
        function LoadDataGrid(url, id) {
            control[id] = $("#" + id).datagrid({
                url: url,
                columns: [[
                { field: 'Id', checkbox: true, width: 30 },
                      { field: 'ReportId', title: 'CompanyId', width: 100, hidden: true },
                      { field: 'CompanyId', title: 'CompanyId', width: 100, hidden: true },
                      { field: 'ReportCode', title: '报表编号', width: 150 },
                       { field: 'ReportName', title: '报表名称', width: 190 },
                       { field: 'CompanyCode', title: '单位编号', width: 150 },
                       { field: 'CompanyName', title: '单位名称', width: 190 },
                       { field: 'State', title: '封存状态', width: 100, align: 'center', formatter: function (value, row, index) {
                           if (row.State == 1) {
                               return "已封存";
                           } else {
                               return "未封存";
                           }
                       }
                       }
                   ]],
                   fit: true,
                   fitColumns:true,
                idField: "",
                toolbar: "#toolbar",
                pagination: true,
                rownumbers: true,
                checkOnSelect: true,
                sortName: "CreateTime",
                sortOrder: "DESC"
            });
        }
        ///报表切换
        function ChangeTask( cookie) {
            var result;
            currentState.ReportState["auditPaperVisible"] = "1";
            currentState.ReportState["auditZqVisible"] = "1";
            if (cookie&&cookie!="") {
                result = cookie;
            } else {
                result = window.showModalDialog("../ReportData/ChooseAuditTask.aspx", currentState.ReportState, "dialogHeight:500px;dialogWidth:440px;scroll:no");
            }
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
                CookieDataManager.SetCookieData(ReportAuditAction.Functions.ReportAuditSequestration, result);
            }
        }
        ///查询方法
        ///参数：查询条件 { companyCode: "", reportCode: "", State: "", IsOrNotRead: "" }
        ///返回：页面刷新数据查询结果
        ///张双义
        function searchReport() {
            if (!currentState.readyTask) return;
            var para = { companyCode: "", reportCode: "", State: "", IsOrNotRead: "",companyName:"",reportName:"" };
            para.companyCode = $("#companyCode").val();
            para.reportCode = $("#reportCode").val();
            para.reportName = $("#reportName").val();
            para.companyName = $("#companyName").val();
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
<body  class="easyui-layout">
    <div data-options="region:'north',title:'',collapsible:false" style="height:32px; padding:2px;background-color:#E0ECFF ;overflow:hidden">
        <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-print'" onclick="Sequestrate('1')" style="width:90px; float:left"plain="true">审计封存</a>
        <div class="datagrid-btn-separator"></div>
        <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-undo'" onclick="Sequestrate('0')" style="width:90px;"plain="true">取消封存</a>
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
                    <td style=" text-align:right" colspan="6">
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

