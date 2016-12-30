<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProblemManager.aspx.cs" Inherits="Audit.ct.ProblemTrace.ProblemManager" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
 <title>审计问题管理</title>
    <script src="../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <link href="../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="../../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <link href="../../Styles/Common.css" rel="stylesheet" type="text/css" />
    <script src="../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <link href="../../Styles/Ct_Controls.css" rel="stylesheet" type="text/css" />
    <script src="../../Scripts/Ct_Controls.js" type="text/javascript"></script>
    <script src="../../Scripts/ct/pub/PubHelp.js" type="text/javascript"></script>
    <script src="../../Scripts/Ct_Tool.js" type="text/javascript"></script>
    <script type="text/javascript">
        var urls = {
            functionsUrl: "../../handler/ProblemTraceHandler.ashx",
            problemListUrl: "../../handler/ProblemTraceHandler.ashx?ActionType=" + ProblemTraceAction.ActionType.Grid + "&MethodName=" + ProblemTraceAction.Methods.ProblemManagerMethods.DataGridReportProblemEntity + "&FunctionName=" + ProblemTraceAction.Functions.ProblemTraceAction,
            problemTypeUrl: "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Get + "&MethodName=GetDictionaryListByClassType&FunctionName=" + BasicAction.Functions.DictionaryManager + "&ClassType=WTLB",
            CompanyTreeHelp: "../../handler/ExportReport.ashx?ActionType=" + ExportAction.ActionType.Grid + "&MethodName=" + ExportAction.Methods.CreatReportMethod.GetCompaniesByAuthority + "&FunctionName=" + ExportAction.Functions.CreateReport,
            CompanyListHelp: "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Grid + "&MethodName=" + BasicAction.Methods.CompanyManagerMethods.CompanyDataGrid + "&FunctionName=" + BasicAction.Functions.CompanyManager,
            ReportHelpUrl: "../../handler/ProblemTraceHandler.ashx?ActionType=" + ProblemTraceAction.ActionType.Grid + "&MethodName=" + ProblemTraceAction.Methods.ProblemManagerMethods.GetReportsByPaperId + "&FunctionName=" + ProblemTraceAction.Functions.ProblemTraceAction,
            ParameterUrl: "../pub/ChooseProblemParameters.aspx",
            ProblemUrl: "AddProblem.aspx"
        };
        var currentState = { problemParamter: { AuditType: { name: "", value: "" }, AuditPaper: { name: "", value: "" }, AuditDate: "", AuditTask: { name: "", value: "" }, Reports: { names: "", Ids: "" }, Companies: { names: "", Ids: "" }, Year: "", Zq: "", ReportType: "" }
     
        };
        var mainControl = {};
        $(function () {
            mainControl.CompanyHelp = $("#CompanyHelp").PopEdit();
            mainControl.CompanyHelp.btn.bind("click", function () {
                MainManager.HelpManager.CompanyHelp_Click();
            });
            mainControl.ReportHelp = $("#ReportHelp").PopEdit();
            mainControl.ReportHelp.btn.bind("click", function () {
                MainManager.HelpManager.ReportHelp_Click();
            });
            $("#taskBtn").bind("click", function () {
                MainManager.problemManager.openParamDialog();
            });
            MainManager.problemManager.openParamDialog();
        });

        var MainManager = {
            problemManager: {
                //参数弹窗 
                openParamDialog: function () {
                    currentState.paramDialog = $("#paramDialog").dialog({
                        title: '选择问题参数',
                        iconCls: 'icon-audit',
                        href: urls.ParameterUrl,
                        width: 450,
                        height: 450,
                        cache: false,
                        modal: true,
                        closed: false,
                        maximizable: false,
                        resizable: false,
                        buttons: [{
                            text: '获取审计问题',
                            iconCls: 'icon-reload',
                            handler: function () {
                                var param = DialogManager.getProblemParam();
                                if (!param) { return; }
                                currentState.problemParamter = param;
                                currentState.paramDialog.dialog("close");
                                MainManager.problemManager.SetAuditParameter(param);
                            }
                        }]
                    });
                },
                //记录并显示 问题参数
                SetAuditParameter: function (result) {
                    currentState.problemParamter = result;
                    MainManager.problemManager.LoadProblem();
                    //填报底稿、周期信息显示
                    $("#auditTaskTypeSpan").text(currentState.problemParamter.AuditType.name);
                    $("#auditTaskSpan").text(currentState.problemParamter.AuditTask.name);
                    $("#auditPaperSpan").text(currentState.problemParamter.AuditPaper.name);
                    var reportZq;
                    switch (currentState.problemParamter.auditZqType) {
                        case "01":
                            reportZq = currentState.problemParamter.Year + "年"
                            break;
                        case "02":
                            reportZq = currentState.problemParamter.Year + "年" + currentState.problemParamter.Zq + "月";
                            break;
                        case "03":
                            reportZq = currentState.problemParamter.Year + "年" + currentState.problemParamter.Zq + "季度"
                            break;
                        case "04":
                            reportZq = currentState.problemParamter.Zq + "日";
                            break;
                    }
                    $("#auditDateSpan").text(reportZq);
                },
                //加载问题列表
                LoadProblem: function () {
                    var parameter = MainManager.problemManager.creatParameter();
                    var url = CreateUrl(urls.functionsUrl, ProblemTraceAction.ActionType.Grid, ProblemTraceAction.Functions.ProblemTraceAction, ProblemTraceAction.Methods.ProblemManagerMethods.DataGridReportProblemEntity, {});
                    $("#problemList").datagrid({
                        url: url,
                        queryParams: parameter
                    });
                },
                //获取 后台方法需要的问题参数
                creatParameter: function (para) {
                    if (!para) {
                        para = { TaskId: "", PaperId: "", ReportId: "", CompanyId: "", Year: "", Zq: "" };
                        para.ReportId = currentState.problemParamter.Reports.Ids;
                        para.CompanyId = currentState.problemParamter.Companies.Ids;
                    }
                    para.PaperId = currentState.problemParamter.AuditPaper.value;
                    para.TaskId = currentState.problemParamter.AuditTask.value;
                    para.Year = currentState.problemParamter.Year;
                    para.Zq = currentState.problemParamter.Zq;
                    return para;
                },
                //核查问题参数 是否完整
                checkParameter: function () {
                    if (!currentState.problemParamter.AuditTask.value) {
                        alert("缺少参数：审计任务"); return;
                    }
                    if (!currentState.problemParamter.AuditPaper.value) {
                        alert("缺少参数：审计底稿"); return;
                    }
                    if (!currentState.problemParamter.Year) {
                        alert("缺少参数：年度"); return;
                    }
                    if (!currentState.problemParamter.Zq) {
                        alert("缺少参数：周期"); return;
                    }
                    return true;
                }
            },
            // toolbar 按钮方法 增加、删除、修改和问题弹窗
            menuManager: {
                AddMenu: function () {
                    if (MainManager.problemManager.checkParameter()) {
                        MainManager.menuManager.OpenDialog(urls.ProblemUrl, "创建问题", "add");
                    }
                },
                EditMenu: function () {
                    var rows = $("#problemList").datagrid("getSelections");
                    var ur = "";
                    if (rows.length == 1) {
                        ur = "?Id=" + rows[0].Id;
                    } else if (rows.length > 1) {
                        MessageManager.ErrorMessage("每次只能编辑一条记录！");
                        return;
                    } else {
                        MessageManager.ErrorMessage("请先选择一行在进行编辑！");
                        return;
                    }
                    MainManager.menuManager.OpenDialog(urls.ProblemUrl + ur, "修改问题", "edit");
                },
                RemoveMenu: function () {
                    var rows = $("#problemList").datagrid("getSelections");
                    var para = {};
                    if (rows.length > 1) {
                        $.messager.confirm('系统提示', '确定要删除所选记录?', function (r) {
                            if (r) {
                                var Ids = "";
                                $.each(rows, function (index, problem) {
                                    Ids += problem.Id + ",";
                                });
                                Ids = Ids.substring(0, Ids.length - 1);
                                para["ids"] = Ids;
                                var parameters = CreateParameter(ProblemTraceAction.ActionType.Post, ProblemTraceAction.Functions.ProblemTraceAction, ProblemTraceAction.Methods.ProblemManagerMethods.Delete, para);
                                DataManager.sendData(urls.functionsUrl, parameters, resultManagers.successDel, resultManagers.fail);
                            } 
                        });
                    } else {
                        MessageManager.WarningMessage("请先选择一行在进行删除！");
                        return;
                    }
                },
                OpenDialog: function (url, title, type) {
                    $('#Dialog').dialog({
                        title: title,
                        width: 550,
                        height: 470,
                        closed: false,
                        cache: false,
                        href: url,
                        left: 200,
                        top: 100,
                        modal: false,
                        buttons: [{
                            text: '保存',
                            iconCls: "icon-ok",
                            handler: function () {
                                var parameters = {};
                                if (type == "add") {
                                    parameters = getParameters(ProblemTraceAction.ActionType.Post, ProblemTraceAction.Methods.ProblemManagerMethods.AddProblem);
                                    if (!parameters) return;
                                    parameters = MainManager.problemManager.creatParameter(parameters);
                                    DataManager.sendData(urls.functionsUrl, parameters, resultManagers.success, resultManagers.fail);
                                } else if (type == "edit") {
                                    parameters = getParameters(ProblemTraceAction.ActionType.Post, ProblemTraceAction.Methods.ProblemManagerMethods.EditProblem);
                                    if (!parameters) return;
                                    parameters = MainManager.problemManager.creatParameter(parameters);
                                    DataManager.sendData(urls.functionsUrl, parameters, resultManagers.success, resultManagers.fail);
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
            },
            //查询栏帮助 相关方法
            HelpManager: {
                CompanyHelp_Click: function () {
                    var treeParas = { idField: "", treeField: "", columns: [], url: "" };
                    treeParas.url = urls.CompanyTreeHelp;
                    treeParas.idField = "Id";
                    treeParas.treeField = "Code";
                    treeParas.columns = [[
                { title: 'id', field: 'Id', width: 180, hidden: true },
                { title: '组织机构编号', field: 'Code', width: 180 },
                { title: '组织机构名称', field: 'Name', width: 210 }
                        ]];
                    treeParas.UseTo = "search";
                    treeParas.singleSelect = true;
                    treeParas.dataUrl = urls.CompanyListHelp;
                    treeParas.sortName = 'Code';
                    treeParas.sortOrder = 'ASC';
                    treeParas.width = 450;
                    treeParas.height = 450;
                    pubHelp.setParameters(treeParas);
                    pubHelp.OpenDialogWithHref("paramHelpDialog", "系统帮助", "../pub/HelpTreeDialog.aspx", MainManager.HelpManager.CompanyHelp_save, treeParas.width, treeParas.height, true);
                },
                ReportHelp_Click: function () {
                    var paras = { url: "", columns: [], sortName: "bbCode", sortOrder: "ASC", NameField: "bbName", CodeField: "bbCode", defaultField: { dftBy: "Id", dft: ""} };
                    var PaperId = currentState.problemParamter.AuditPaper.value;
                    paras.url = urls.ReportHelpUrl + "&PaperId=" + PaperId;
                    paras.columns = [[
                    { title: 'id', field: 'Id', width: 180, hidden: true },
			       { field: 'bbCode', title: '编号', width: 150, sortable: true },
                   { field: 'bbName', title: '名称', width: 190, sortable: true }
                        ]];
                    paras.defaultField.dft = mainControl.ReportHelp.value.val();
                    paras.width = 450;
                    paras.height = 450;
                    pubHelp.setParameters(paras);
                    pubHelp.OpenDialogWithHref("paramHelpDialog", "系统帮助", "../pub/HelpDialogEasyUi.htm", MainManager.HelpManager.ReportHelp_Save, paras.width, paras.height, true);
                },
                CompanyHelp_save: function () {
                    var result = pubHelp.getResultObj();
                    if (result) {
                        if (result.length > 0) {
                            mainControl.CompanyHelp.name.val(result[0].Name);
                            mainControl.CompanyHelp.value.val(result[0].Id);
                        }
                    }
                },
                ReportHelp_Save: function () {
                    var result = pubHelp.getResultObj();
                    if (result) {
                        mainControl.ReportHelp.name.val(result.bbName);
                        mainControl.ReportHelp.value.val(result.Id);
                    }
                }
            },
            //查询和重置
            SearchManager: {
                DoSearch: function () {
                    var obj = MainManager.problemManager.creatParameter();
                    obj.Type = $("#pType").combobox("getValue");
                    obj.State = $("#pState").combobox("getValue");
                    if (mainControl.CompanyHelp.value.val()) {
                        obj.CompanyId = mainControl.CompanyHelp.value.val();
                    }
                    if (mainControl.ReportHelp.value.val()) {
                        obj.ReportId = mainControl.ReportHelp.value.val();
                    }
                    $("#problemList").datagrid("reload", obj);
                },
                FreeSearch: function () {
                    var obj = MainManager.problemManager.creatParameter();
                    $("#pType").combobox("setValue", ""); ;
                    $("#pState").combobox("setValue", ""); ;
                    mainControl.CompanyHelp.name.val("");
                    mainControl.CompanyHelp.value.val("");
                    mainControl.ReportHelp.name.val("");
                    mainControl.ReportHelp.value.val("");
                    $("#problemList").datagrid("reload", obj);
                }
            }
        };
        var resultManagers = {
            success: function (data) {
                if (data.success) {
                    MessageManager.InfoMessage(data.sMeg);
                    $("#problemList").datagrid('reload');
                    $('#Dialog').dialog("close");
                    $("#problemList").datagrid('unselectAll');

                } else {
                    MessageManager.ErrorMessage(data.sMeg);
                }
            },
            successDel: function (data) {
                if (data.success) {
                    MessageManager.InfoMessage(data.sMeg);
                    $("#problemList").datagrid('reload');
                    $("#problemList").datagrid('unselectAll');
                } else {
                    MessageManager.ErrorMessage(data.sMeg);
                }
            },
            fail: function (data) {
                MessageManager.ErrorMessage(data.toString);
            }
        };
        function stateFormatter(value,row,index) {
            if (value == "0") {
                return "未处理";
            }
            if (value == "1") {
                return "已处理";
            }
        };

    </script>
</head>
<body class="easyui-layout" style="background: #F4F4F4;">
    <div data-options="region:'north',collapsible:false" style=" height:32px; padding:2px;background-color:#E0ECFF ;overflow:hidden">
        <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add',iconAlign:'left',line:true" onclick="MainManager.menuManager.AddMenu()" style="width:70px; float:left "plain="true">增加</a>
        <div class="datagrid-btn-separator"></div>
        <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-edit',iconAlign:'left'" onclick="MainManager.menuManager.EditMenu()" style="width:70px;float:left "plain="true">修改</a>
        <div class="datagrid-btn-separator"></div>
        <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-cut',iconAlign:'left'" onclick="MainManager.menuManager.RemoveMenu()" style="width:70px;float:left "plain="true">删除</a>
    </div>
    <div data-options="region:'center'">
     <div id="toolbar" style="">
            <table style="width:100%">
            <tr>
            <td style="width:30px">单位</td><td style="width:170px"><div id="CompanyHelp"></div></td>
            <td style="width:30px">报表</td><td style="width:170px"><div id="ReportHelp"></div></td>
            <td style="width:55px">问题类型</td>
            <td style="width:170px"><input id="pType" type="text" class="easyui-combobox" data-options=" valueField:'Code', textField:'Name',url:urls.problemTypeUrl,panelHeight:'auto'" /></td>
            <td style="width:55px">问题状态</td>
            <td ><input id="pState" type="text" class="easyui-combobox" 
                data-options=" valueField:'Code', textField:'Name',data:[{Code:'0',Name:'启用'},{Code:'1',Name:'下达'},{Code:'2',Name:'反馈'},{Code:'3',Name:'封存'}],
                panelHeight:'auto'" /></td>
            <td style=" float:right"><a class="easyui-linkbutton" onclick="MainManager.SearchManager.FreeSearch()" iconcls="icon-undo" style="">重置</a></td>
            <td style=" float:right"><a class="easyui-linkbutton" onclick="MainManager.SearchManager.DoSearch()" iconcls="icon-search" style=" margin-right:10px">查询</a></td>
            </tr>
            </table>
        </div>
        <table class="easyui-datagrid" id="problemList" data-options="border:false,singleSelect:false,method:'post',fit:true,fitColumns:true,sortName:'CreateTime',sortOrder:'ASC',toolbar:'#toolbar',pagination:true">
            <thead>
                <tr>
                  <%--  <th data-options="field:'CompanyCode',width:100">单位编号</th>
                    <th data-options="field:'CompanyName',width:150,align:'left'">单位名称</th>
                    <th data-options="field:'ReportCode',width:100">报表编号</th>
                    <th data-options="field:'ReportName',width:150,align:'left'">报表名称</th>--%>

                    <th data-options="field:'Id',checkbox:true,width:20">复选框</th>
                    <th data-options="field:'Title',width:150,align:'left'">问题标题</th>
                    <th data-options="field:'Content',width:190,align:'left'">问题内容</th>
                    <th data-options="field:'Type',width:100,align:'left'">问题类型</th>
                    <th data-options="field:'State',width:100,align:'left'">问题状态</th>
                    <th data-options="field:'CreaterName',width:100,align:'left'">创建者</th>
                    <th data-options="field:'CreateTime',width:100,align:'left'">创建时间</th>
                </tr>
            </thead>
        </table>
    </div>
    <div data-options="region:'south'"style = "height:30px;text-align:center;padding:5px">
        <a href="#"  id="taskBtn">审计任务切换</a>&nbsp <span>审计类型:</span><span id="auditTaskTypeSpan"></span>&nbsp <span>审计任务:</span><span id="auditTaskSpan"></span>&nbsp <span>审计底稿:</span><span id="auditPaperSpan"></span>&nbsp <span>审计周期:</span><span id="auditDateSpan"></span>
    </div>
    <div id="Dialog" />
    <div id="HelpDialog"></div>
    <div id="paramDialog"></div>
    <div id="paramHelpDialog"></div>
</body>
</html>
