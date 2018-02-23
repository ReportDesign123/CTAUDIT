<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="BatchProcess.aspx.cs" Inherits="Audit.ct.ReportData.BatchProcess" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>报表批量处理</title>
   
    <script src="../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <link href="../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="../../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script src="../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <script src="../../lib/Cookie/jquery.cookie.js" type="text/javascript"></script>
    <script src="../../Scripts/Cookie/Cookie.js" type="text/javascript"></script>
    <script src="../../Scripts/Ct_Controls.js" type="text/javascript"></script>
    <link href="../../Styles/Ct_Controls.css" rel="stylesheet" type="text/css" />
    <link href="../../Styles/Common.css" rel="stylesheet" type="text/css" />
    <script src="../../Scripts/ct/pub/PubHelp.js" type="text/javascript"></script>
       <script src="../../Scripts/ct_dialog.js" type="text/javascript"></script>
    <script type="text/javascript">
        var urls = {
            functionsUrl: "../../handler/FormatHandler.ashx",
            fillReportUrl: "../../handler/ReportDataHandler.ashx"
        };
        var currentState = { ReportState: { AuditType: { name: "", value: "" }, AuditPaper: { name: "", value: "" }, AuditDate: "", AuditTask: { name: "", value: "" }, Nd: "", Zq: "", ReportType: "", auditPaperVisible: "1", auditZqVisible: "1", WeekReport: { ID: "", Name: "", Ksrq: "", Jsrq: ""} },
         BatchParameter: {auditReports:[],ReportsId:[]}, CompanyId: ""
        };
        var controls = { Nd: "", Zq: "", ReportsGridData: [], CompanyGridDdata: [], reportClassify: {}, parameter: {} };
        var LoadingMessage = {};

        //回车监听
        $("#bbCode").ready(function () {
            $("#bbCode").keypress(function (e) {
                var curKey = e.which;
                if (curKey == 13) {
                    EventManager.SearchReport();
                }
            });
        });
        $("#bbName").ready(function () {
            $("#bbName").keypress(function (e) {
                var curKey = e.which;
                if (curKey == 13) {
                    EventManager.SearchReport();
                }
            });
        });
        $("#reportClassify").ready(function () {
            $("#reportClassify").keypress(function (e) {
                var curKey = e.which;
                if (curKey == 13) {
                    EventManager.SearchReport();
                }
            });
        });
        $(function () {
            $("#taskBtn").bind("click", EventManager.taskBtn_ClickEvent);
            controls.reportClassify = $("#reportClassify").PopEdit({ width: 100 });
            controls.reportClassify.btn.bind("click", function () {
                EventManager.ChooseClassify();
            });
            $("#reportGrid").datagrid({
                singleSelect: false,
                fit: true,
                fitColumns: true,
                toolbar: '#toobar',
                sortName: 'bbCode',
                sortOrder: 'ASC',
                pagination: false,
                columns: [[
                { field: 'Id', width: 80, align: 'left', checkbox: true, title: 'Id' },
                { field: 'bbCode', width: 100, align: 'left', sortable: false, title: "报表编号" },
                { field: 'bbName', width: 160, align: 'left', sortable: false, title: "报表名称" },
                { field: 'ReportClassifyName', width: 150, align: 'left', sortable: false, title: "报表类别" }
                ]]
            });
        var cookie = CookieDataManager.GetCookieData(ReportDataAction.Functions.BatchProcessCooike);
        if (cookie) {
            ControlManager.SetAuditTask(cookie);
        } else {
            EventManager.taskBtn_ClickEvent();
        }
    });
    var EventManager = {
        LoadReports: function (data) {
            $("#reportGrid").datagrid("loadData", data);
            controls.ReportsGridData = data;
        },
        LoadCompanys: function (data) {
            $("#companyTree").tree("loadData", data);
            controls.CompanyGridDdata = $("#companyTree").tree("getData");
        },
        taskBtn_ClickEvent: function () {
            currentState.ReportState["auditPaperVisible"] = "1";
            currentState.ReportState["auditZqVisible"] = "1";
            dialog.Open("ct/ReportData/ChooseAuditTask.aspx", "切换任务", currentState.ReportState, function (result) {
                if (result && result != undefined) {
                    if (result.auditZqType == "05") {
                        if (result.WeekReport.ID == "") {
                            alert("请定义周报周期");
                        }
                        else {
                            ControlManager.SetAuditTask(result);
                        }
                    }
                    else {
                        ControlManager.SetAuditTask(result);
                    }
                }
            }, { width: 440, height: 500 });

           
        },
        ChooseClassify: function () {
            var paras = { sortOrder: "ASC", sortName: "Code" }
            paras.parameter = CreateParameter(ReporClassifyAction.ActionType.Post, ReporClassifyAction.Functions.ReportClassify, ReporClassifyAction.Methods.ReportClassifyMethods.GetClassifiesList, {});
            paras.functionsUrl = urls.functionsUrl;
            paras.columns = [[
                { field: "Id", title: "id", hidden: true, width: 120 },
                { field: "Code", title: "分类编号", width: 80 },
                    { field: "Name", title: "分类名称", width: 100 }
                    ]]
            paras.width = 375;
            paras.height = 420;
            pubHelp.setParameters(paras);
            pubHelp.OpenDialogWithHref("Dialog", "报表分类选择", "../pub/HelpList.aspx", EventManager.getClassifyChoice, paras.width, paras.height, true);
        },
        getClassifyChoice: function () {
            var result = pubHelp.getResultObj();
            if (result && result.Id != undefined) {
                controls.reportClassify.name.val(result.Name);
                controls.reportClassify.value.val(result.Name);
            }
        },
        SearchReport: function () {
            var bbCode = $("#bbCode").val();
            var bbName = $("#bbName").val();
            var classifyName = controls.reportClassify.name.val();
            var data = controls.ReportsGridData;
            data = ControlManager.DoSearch(bbCode, "bbCode", data);
            data = ControlManager.DoSearch(bbName, "bbName", data);
            data = ControlManager.DoSearch(classifyName, "ReportClassifyName", data);
            $('#reportGrid').datagrid("loadData", data);
        },
        FreeSearch: function () {
            $("#bbCode").val("");
            $("#bbName").val("");
            $("#reportGrid").datagrid('loadData', controls.ReportsGridData);
        },
        BatchProcess: function (type) {
            var obj = ControlManager.GetBatchParameter();
            if (!obj) return;
            EventManager.showProgress("批量" + type);
            //LoadingMessage = window.showModelessDialog("../pub/Progress.htm", null, "DialogHeight:120px;DialogWidth:450px;help:no;status:no;scroll:no;");
            switch (type) {
                case "取数":
                    obj = CreateParameter(ReportDataAction.ActionType.Post, ReportDataAction.Functions.FillReport, ReportDataAction.Methods.FillReportMethods.BatchDeserializeFatchFormular, obj);
                    DataManager.sendData(urls.fillReportUrl, obj, resultManager.success_BatchProcess, resultManager.FailResult, true);
                    break;
                case "计算":
                    obj = CreateParameter(ReportDataAction.ActionType.Post, ReportDataAction.Functions.FillReport, ReportDataAction.Methods.FillReportMethods.BatchDeserializeCaculateFormular, obj);
                    DataManager.sendData(urls.fillReportUrl, obj, resultManager.success_BatchProcess, resultManager.FailResult, true);
                    break;
                case "校验":
                    obj = CreateParameter(ReportDataAction.ActionType.Post, ReportDataAction.Functions.FillReport, ReportDataAction.Methods.FillReportMethods.BatchDeserializeVerifyFormular, obj);
                    DataManager.sendData(urls.fillReportUrl, obj, resultManager.success_BatchProcess, resultManager.FailResult, true);
                    break;
            }
        },
        BatchDownLon: function () {
            var obj = ControlManager.GetBatchParameter();
            if (!obj) return;
            EventManager.showProgress("正在请求数据");
            obj = CreateParameter(ReportDataAction.ActionType.Post, ReportDataAction.Functions.FillReport, ReportDataAction.Methods.FillReportMethods.BatchDownLoadAttatches, obj);
            DataManager.sendData(urls.fillReportUrl, obj, resultManager.success_DowLoadpath, resultManager.FailResult, true);
            //            var url = CreateUrl(urls.fillReportUrl, ReportDataAction.ActionType.Get, ReportDataAction.Functions.FillReport, ReportDataAction.Methods.FillReportMethods.BatchDownLoadAttatches, obj);
            //            window.location.href = url;
        },
        BatchExcil: function () {
            var obj = ControlManager.GetBatchExcilParameter();
            if (!obj) return;
            $.messager.prompt('提示信息', '默认情况下导出到<br/>C:\\Users\\Administrator\\Desktop\\ct问卷夹下（即C盘桌面的ct文件夹,<span style="color:red">此文件夹必须存在</span>）。<br/>如果想更改文件夹地址请在输入框中填写，例如c:\\ct', function (r) {
                if (r) {
                    obj["path"] = r;
                    controls.parameter = obj;
                    EventManager.showExportProgress();
                } else if (r == "") {
                    controls.parameter = obj;
                    EventManager.showExportProgress();
                }
            });
        },
        showExportProgress: function () {
            $("#ExportProgressDialog").show().dialog({
                title: '批量导出',
                modal: true,
                closable: false,
                maximizable: false,
                resizable: false,
                closed: false,
                onBeforeClose: function () {
                    var ExportProgressIframe = window.frames["ExportProgressIframe"];
                    if (ExportProgressIframe.ExportManager) {
                        if (ExportProgressIframe.exporting) { EventManager.getExportResult() }
                        if (ExportProgressIframe.ExportManager) {
                            ExportProgressIframe.ExportManager.stopExport();
                        }
                    }
                }
            });
            document.getElementById("ExportProgressIframe").src = "../pub/ReprtExportProgress.htm";
        },
        showProgress: function (title) {
            $("#progressDialog").show().dialog({
                title: title,
                modal: true,
                closable: false,
                href: "../pub/Progress.htm",
                maximizable: false,
                resizable: false,
                closed: false,
                onBeforeClose: function () {
                    //EventManager.getExportResult()
                }
            });
        },
        getExportResult: function (result) {
            if (result) {
                if (result.success) {
                    MessageManager.InfoMessage(result.msg);
                } else {
                    MessageManager.ErrorMessage(result.msg);
                }
                $("#ExportProgressDialog").dialog("close");
            } else {
                MessageManager.ErrorMessage("导出已被终止！");
            }
        }
    };
        var ControlManager = {
            SetAuditTask: function (result) {
                CookieDataManager.SetCookieData(ReportDataAction.Functions.BatchProcessCooike, result);
                currentState.ReportState = result;
                ControlManager.LoadBatchProcessData();
                $("#auditTaskTypeSpan").text(currentState.ReportState.AuditType.name);
                $("#auditTaskSpan").text(currentState.ReportState.AuditTask.name);
                $("#auditDateSpan").text(currentState.ReportState.AuditDate);
            },
            LoadBatchProcessData: function () {
                var para = { TaskId: "", PaperId: "", CompanyId: "", ReportId: "", Year: "", Cycle: "", AuditDate: "", ReportType: "" };
                para.TaskId = currentState.ReportState.AuditTask.value;
                para.Cycle = currentState.ReportState.Zq;
                para.Year = currentState.ReportState.Nd;
                para.PaperId = currentState.ReportState.AuditPaper.value;
                para.ReportType = currentState.ReportState.auditZqType;
                para = CreateParameter(ReportDataAction.ActionType.Post, ReportDataAction.Functions.FillReport, ReportDataAction.Methods.FillReportMethods.GetReportBatchProcessStruct, para);
                DataManager.sendData(urls.fillReportUrl, para, resultManager.GetFirstReportStruct_Success, resultManager.FailResult);
            },
            GetBatchParameter: function () {
                var Companys = $("#companyTree").tree("getChecked");
                if (Companys.length == 0) { alert("请选择单位！"); return; }
                var Reports = $("#reportGrid").datagrid("getSelections");
                if (Reports.length == 0) { alert("请选择要操作的报表！"); return; }
                var para = { TaskId: "", PaperId: "", Nd: "", Zq: "", ReportType: "", Reports: "", Companies: "",ReportCodes:""};
                para.TaskId = currentState.ReportState.AuditTask.value;
                para.PaperId = currentState.ReportState.AuditPaper.value;
                para.Year = currentState.ReportState.Nd;
                para.Cycle = currentState.ReportState.Zq;
                para.ReportType = currentState.ReportState.auditZqType;
                $.each(Reports, function (index, report) {
                    if (para.Reports != "") {
                        para.Reports = para.Reports + "," + report.Id;
                        para.ReportCodes = para.ReportCodes + "," + report.bbCode;
                    } else {
                        para.Reports = report.Id;
                        para.ReportCodes=report.bbCode;
                    }
                });
                $.each(Companys, function (index, node) {
                    if (para.Companies != "") {
                        para.Companies = para.Companies + "," + node.id;
                    } else {
                        para.Companies = node.id;
                    }
                });
                return para;
            },
            GetBatchExcilParameter: function () {
                var Companys = $("#companyTree").tree("getChecked");
                if (Companys.length == 0) { alert("请选择单位！"); return; }
                var Reports = $("#reportGrid").datagrid("getSelections");
                if (Reports.length == 0) { alert("请选择要操作的报表！"); return; }
                var para = { TaskId: "", PaperId: "", Nd: "", Zq: "", ReportType: "", Reports:[], Companies:[]};
                para.TaskId = currentState.ReportState.AuditTask.value;
                para.PaperId = currentState.ReportState.AuditPaper.value;
                para.Year = currentState.ReportState.Nd;
                para.Cycle = currentState.ReportState.Zq;
                para.ReportType = currentState.ReportState.auditZqType;
                $.each(Reports, function (index, report) {
                        var report = {Id:report.Id,Name:report.bbName};
                        para.Reports.push(report);
                });
                $.each(Companys, function (index, node) {
                    var company = { Id: node.id, Name: node.text };
                    para.Companies.push(company);
                });
                return para;
            },
            //查询方法
            DoSearch: function (kay, type, data) {
                if (kay == "") return data;
                var result;
                var newData = [];
                for (var i = 0; i < data.length; i++) {
                    result = ControlManager.FindKey(kay, data[i][type]);
                    if (result) { newData.push(data[i]); }
                }
                return newData;
            },
            FindKey: function (sFind, sObj) {
                var nSize = sFind.length;
                var nLen = sObj.length;
                var sCompare;
                if (nSize <= nLen) {
                    for (var i = 0; i <= nLen - nSize + 1; i++) {
                        sCompare = sObj.substring(i, i + nSize);
                        if (sCompare == sFind) {
                            return true;
                        }
                    }
                }
                return null;
            }
        };

        var resultManager = {
            GetFirstReportStruct_Success: function (data) {
                if (data.success) {
                    EventManager.LoadCompanys(data.obj.companiesTree);
                    EventManager.LoadReports(data.obj.reports);
                } else {
                    alert(data.sMeg);
                }
            },
            successLoad: function (data) {
                classifiyData = data.obj.Rows;
            },
            success_DowLoadpath: function (data) {
                if (data.obj) {
                    $("#progressDialog").dialog("close");
                    window.location.href = data.obj;
                }
            },
            success_BatchProcess: function (data) {
                $("#progressDialog").dialog("close");
                if (data.success) {
                    MessageManager.InfoMessage(data.sMeg);
                    // ControlManager.LoadBatchProcessData();
                } else {
                    MessageManager.ErrorMessage(data.sMeg);
                }
            },
            FailResult: function (data) {
                $("#progressDialog").dialog("close");
                MessageManager.ErrorMessage(data.toString);
            }
        }
    </script>
    <style type="text/css">
        .icon-excil{
        background:url('../../images/ReportData/导出Excel-16.png') no-repeat center center;
        }
        .MyTd_box
    { 
        width:170px;
    }
    .MyTd_text
    { 
        width:60px;
    }
    </style>
</head>
<body class ="easyui-layout">
    <div data-options="region:'north'" style="height:32px; padding:2px; overflow:hidden;background-color:#E0ECFF ;">
    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="EventManager.BatchProcess('取数')" style="width:90px; float:left;"plain="true">批量取数</a>
        <div class="datagrid-btn-separator"></div>
    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-sum'" onclick="EventManager.BatchProcess('计算')" style="width:90px; float:left;"plain="true">批量计算</a>
        <div class="datagrid-btn-separator"></div>
    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-tip'" onclick="EventManager.BatchProcess('校验')" style="width:90px; float:left;"plain="true">批量校验</a>
        <div class="datagrid-btn-separator"></div>
    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-excil'" onclick="EventManager.BatchExcil()" style="width:90px; float:left;"plain="true">批量导出</a>
        <div class="datagrid-btn-separator"></div>
    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-downLoad'" onclick="EventManager.BatchDownLon()" style="width:110px;"plain="true">批量下载附件</a>
    </div>
    <div data-options="region:'center'" style="border:0px;">
       <div id="toobar" style="min-width:830px">
        <table style=" width:100%">
            <tr>   
                <td class="MyTd_text">报表编号</td><td class="MyTd_box"><input id = "bbCode"class="easyui-validatebox textbox"  /></td>
                <td class="MyTd_text">报表名称</td><td class="MyTd_box"><input id = "bbName"class="easyui-validatebox textbox" /></td>
                <td class="MyTd_text">报表类别</td><td><div id ="reportClassify"></div></td>
                <td style="float:right"><a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-undo'" onclick="EventManager.FreeSearch()" style=" margin-left:10px">重置</a></td>
                <td style="float:right"><a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="EventManager.SearchReport()" style="">查询</a></td>
            </tr>
        </table>
      </div>
      <table id="reportGrid" style=" overflow:auto"></table>
    </div>
    <div data-options="region:'south'" style=" border:1px solid #95B8E7; height:25px">
        <div style=" text-align:center; font-size:13px; margin-top:4px">
        <a href="#"  id="taskBtn">审计任务切换</a>&nbsp <span>审计任务类型:</span><span id="auditTaskTypeSpan"></span>&nbsp <span>审计任务:</span><span id="auditTaskSpan"></span>&nbsp <span>审计日期:</span><span id="auditDateSpan"></span>
        </div>
    </div>
    <div data-options="region:'east',split:true,collapsible:false" title="组织机构选择" style=" width:230px; border-bottom:0px">
       <div style="font-size:13px">
        <input type="checkbox" checked="checked" style=" margin-left:18px" onchange="$('#companyTree').tree({cascadeCheck:$(this).is(':checked')})"/>级联选择</div> 
        <ul id="companyTree" class="easyui-tree" data-options="method:'post',animate:false,checkbox:true" ></ul>
    </div>
    <div id="Dialog" />
    <div id = "classifiyTable"></div>
    <div id="ExportProgressDialog" style="display:none;width:430px;height:140px;overflow:hidden">
        <iframe id="ExportProgressIframe" scrolling="auto" frameborder="0"  style="height:100%;width:100%"></iframe>
    </div>
    <div id="progressDialog" style="width:300px;height:120px;overflow:hidden;"></div>
</body>
</html>