<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReportParameters.aspx.cs" Inherits="Audit.ct.pub.ReportParameters" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
   <title>参数选择</title>
           <meta http-equiv="X-UA-Compatible" content="IE=10" />
     <meta http-equiv="X-UA-Compatible" content="IE=9" />
     <meta http-equiv="X-UA-Compatible" content="IE=8" />
     <meta http-equiv="X-UA-Compatible" content="IE=7" />
     <script src="../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <link href="../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="../../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script src="../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <script src="../../Scripts/ct/pub/PubHelp.js" type="text/javascript"></script>
     <script src="../../Scripts/Ct_Controls.js" type="text/javascript"></script>
    <link href="../../Styles/Common.css" rel="stylesheet" type="text/css" />
    <link href="../../Styles/Ct_Controls.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/json2.js" type="text/javascript"></script>
        <script src="../../Scripts/ct_dialog.js" type="text/javascript"></script>
    <script type="text/javascript">
        var Pcontrols = { task: {}, paper: {}, report: {}, index: {}, cells: {}, company: {}, reportType: {} };
        var tempData = { cells: {}, type: "" }; //type 记录 上一页面的请求类型[report,index]
        var ReportParamert = { Report: {}, Company:[] };
        var ParentParameter;
        var urls = {
            ReportZq: "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Get + "&MethodName=GetDictionaryListByClassType&FunctionName=" + BasicAction.Functions.DictionaryManager + "&ClassType=BBZQ",
            ReportCycle: "../../handler/ReportDataHandler.ashx"
        };
        var InViewPara;
        var cascading = true;
        function changeCascad() {
            cascading = !cascading;
        }
        $(function () {
            ParentParameter = dialog.para();// window.dialogArguments;
            if (ParentParameter == "report") {
                tempData.type = ParentParameter;
                $("#Td_Index").css("display", "none");
            } else if (ParentParameter && ParentParameter.type) {
                tempData.type = ParentParameter.type;
                $("#Td_Index").css("display", "none");
                initializeManager.initializeView();
            }
            EventManager.itemClick("Task");
        });
        function LoadZq(zqType) {
            var para = { ReportType: zqType };
            para = CreateParameter(ReportDataAction.ActionType.Post, ReportDataAction.Functions.FillReport, ReportDataAction.Methods.FillReportMethods.GetReportCycle, para);
            DataManager.sendData(urls.ReportCycle, para, resultManager.success, resultManager.fail, false);
        }
        var initializeManager = {
            initializeView: function () {
                var param = ParentParameter.Data.Parameters;
                ReportParamert.Report = { Id: "", bbName: "", bbCode: "", bbCycle: "" };
                $("#taskName").val(param.TaskName);
                $("#taskValue").val(param.TaskId);
                $("#paperName").val(param.PaperName);
                $("#paperValue").val(param.PaperId);
                $("#companyValue").val(param.CompanyId);
                $("#companyName").val(ParentParameter.Data.CompanyName);
                $("#reportName").val(ParentParameter.Data.ReportName);
                $("#reportValue").val(param.ReportCode);
                ReportParamert.Report.Id = param.ReportId
                ReportParamert.Report.bbName = param.ReportName;
                ReportParamert.Report.bbCode = param.ReportCode;
                ReportParamert.Report.bbCycle = param.ReportType;
                LoadZq(param.ReportType);
            }
        };
        var EventManager = {
            itemClick: function (type) {
                InViewPara = type;
                switch (type) {
                    case "Task":
                        var paras = { url: "", columns: [], sortName: "", sortOrder: "", NameField: "Name", CodeField: "Code", defaultField: { dftBy: "Code", dft: ""} };
                        paras.url = "../../handler/AuditTaskHandler.ashx?ActionType=" + AuditTaskAction.ActionType.Grid + "&MethodName=" + AuditTaskAction.Methods.AuditTaskManagerMethods.GetDataGrid + "&FunctionName=" + AuditTaskAction.Functions.AuditTaskManager;
                        paras.columns = [[
                            { field: "Id", title: "Id", width: 80, hidden: true },
                            { field: "Code", title: "任务编号", width: 80 },
                            { field: "Name", title: "任务名称", width: 200 }
                        ]];
                        paras.sortName = "CreateTime";
                        paras.sortOrder = "DESC";
                        paras.defaultField.dft = $("#taskValue").val();
                        $("#cellframe").css("display", "none");
                        $("#helpTreeDiv").css("display", "none");
                        $("#helpPaperDiv").css("display", "none");
                        $("#helpReportDiv").css("display", "none");
                        $("#helpTaskDiv").css("display", "block");
                        if (!Pcontrols.TaskGrid) {
                            Pcontrols.TaskGrid = $("#helpSeachGridT").datagrid({
                                fit: true,
                                url: paras.url,
                                sortName: paras.sortName,
                                sortOrder: paras.sortOrder,
                                rownumbers: true,
                                pagination: true,
                                singleSelect: true,
                                title: "",
                                border: false,
                                fitColumns: true,
                                singleSelect: true,
                                toolbar: "#TaskToolbar",
                                columns: paras.columns,
                                onSelect: function (rowIndex, rowData) {
                                    $("#taskName").val(rowData.Name);
                                    $("#taskValue").val(rowData.Code);
                                }

                            });
                        } else {
                            $("#TaskSearchBox").searchbox("setValue", "");
                            Pcontrols.TaskGrid.datagrid("reload", {});
                        }
                        break;
                    case "Paper":
                        if ($("#taskValue").val() == "") {
                            alert("请先选择审计任务！");
                            return;
                        }
                        $("input[name='module']").attr("checked", false)
                        paras = { url: "", columns: [], sortName: "", sortOrder: "", NameField: "Name", CodeField: "Code", defaultField: { dftBy: "Code", dft: ""} };
                        paras.url = "../../handler/FormatHandler.ashx?ActionType=" + ReportFormatAction.ActionType.Grid + "&MethodName=" + ReportFormatAction.Methods.FormularMenuMethods.GetDataGridByTaskCode + "&FunctionName=" + ReportFormatAction.Functions.FormularMenu + "&TaskCode=" + $("#taskValue").val();
                        paras.columns = [[{ field: "Id", title: "Id", width: 80, hidden: true },
                        { field: "Code", title: "审计底稿编号", width: 100 },
                        { field: "Name", title: "审计底稿名称", width: 190 }
                        ]];
                        paras.sortName = "CreateTime";
                        paras.sortOrder = "DESC";
                        paras.defaultField.dft = $("#paperValue").val();
                        $("#cellframe").css("display", "none");
                        $("#helpTreeDiv").css("display", "none");
                        $("#helpPaperDiv").css("display", "block");
                        $("#helpReportDiv").css("display", "none");
                        $("#helpTaskDiv").css("display", "none");
                        if (!Pcontrols.PaperGrid) {
                            Pcontrols.PaperGrid = $("#helpSeachGridP").datagrid({
                                fit: true,
                                url: paras.url,
                                sortName: paras.sortName,
                                sortOrder: paras.sortOrder,
                                pagination: true,
                                rownumbers: true,
                                singleSelect: true,
                                title: "",
                                border: false,
                                toolbar: "#PaperToolbar",
                                fitColumns: true,
                                singleSelect: true,
                                columns: paras.columns,
                                onSelect: function (rowIndex, rowData) {
                                    $("#paperName").val(rowData.Name);
                                    $("#paperValue").val(rowData.Code);
                                }
                            });
                        } else {
                            $("#PaperSearchBox").searchbox("setValue", "");
                            Pcontrols.PaperGrid.datagrid("reload", { TaskCode: $("#taskValue").val() });
                        }
                        break;
                    case "Report":
                        paras = { url: "", columns: [], sortName: "", sortOrder: "", NameField: "bbName", CodeField: "bbCode", defaultField: { dftBy: "bbCode", dft: ""} };
                        paras.url = "../../handler/FormatHandler.ashx?ActionType=" + ReportFormatAction.ActionType.Grid + "&MethodName=" + ReportFormatAction.Methods.FormularMenuMethods.GetReportsByPaperCode + "&FunctionName=" + ReportFormatAction.Functions.FormularMenu + "&PaperCode=" + $("#paperValue").val();
                        paras.columns = [[{ field: "Id", title: "Id", width: 80, hidden: true },
{ field: "bbCode", title: "报表编号", width: 100 },
{ field: "bbName", title: "报表名称", width: 190 }
]];
                        paras.sortName = "bbCode";
                        paras.sortOrder = "Desc";
                        paras.defaultField.dft = $("#reportValue").val();
                        $("#cellframe").css("display", "none");
                        $("#helpTreeDiv").css("display", "none");
                        $("#helpPaperDiv").css("display", "none");
                        $("#helpReportDiv").css("display", "block");
                        $("#helpTaskDiv").css("display", "none");
                        if (!Pcontrols.ReportGrid) {
                            Pcontrols.ReportGrid = $("#helpSeachGridR").datagrid({
                                fit: true,
                                url: paras.url,
                                sortName: paras.sortName,
                                sortOrder: paras.sortOrder,
                                pagination: true,
                                rownumbers: true,
                                singleSelect: true,
                                title: "",
                                border: false,
                                fitColumns: true,
                                toolbar: "#ReportToolbar",
                                singleSelect: true,
                                columns: paras.columns,
                                onSelect: function (rowIndex, rowData) {
                                    $("#reportName").val(rowData.bbName);
                                    $("#reportValue").val(rowData.bbCode);
                                    ReportParamert.Report = rowData;
                                    LoadZq(rowData.bbCycle);
                                }
                            });
                        } else {
                            $("#ReportSearchBox").searchbox("setValue", "");
                            Pcontrols.ReportGrid.datagrid("reload", { PaperCode: $("#paperValue").val() });
                        }
                        break;
                    case "Cells":
                        var node = { Id: "" };
                        if ($("#reportValue").val()) {
                            node.Id = $("#reportValue").val();
                            node.type = "total";
                            var fram = window.frames["cellframe"];
                            fram.loadReport(node);
                            fram.parentParam = node;
                            $("#cellframe").css("display", "block");
                            $("#helpTreeDiv").css("display", "none");
                            $("#helpPaperDiv").css("display", "none");
                            $("#helpReportDiv").css("display", "none");
                            $("#helpTaskDiv").css("display", "none");
                        } else {
                            alert("请先选择报表！");
                        }
                        break;
                    case "Company":
                        $("#cellframe").css("display", "none");
                        $("#helpTreeDiv").css("display", "block");
                        $("#helpPaperDiv").css("display", "none");
                        $("#helpReportDiv").css("display", "none");
                        $("#helpTaskDiv").css("display", "none");
                        if (!Pcontrols.helpTreeGrid) {
                            var treeParas = { idField: "", treeField: "", columns: [], url: "" };
                            treeParas.url = "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Grid + "&MethodName=" + BasicAction.Methods.CompanyManagerMethods.GetCompanyList + "&FunctionName=" + BasicAction.Functions.CompanyManager;
                            treeParas.idField = "Id";
                            treeParas.treeField = "Code";
                            treeParas.columns = [[
                            { title: 'id', field: 'Id', width: 180, checkbox: true },
                            { title: '组织机构编号', field: 'Code', width: 180 },
                            { title: '组织机构名称', field: 'Name', width: 280 }
                            ]];
                            EventManager.CreatTreeGrid(treeParas);
                        } else {
                            Pcontrols.helpTreeGrid.treegrid("reload");
                        }
                        break;
                }
            },
            CreatTreeGrid: function (treeParas) {
                if (ParentParameter.Parent == "ReportLink") {
                    Pcontrols.helpTreeGrid = $("#helpTreeGrid").treegrid({
                        url: treeParas.url,
                        fit: true,
                        singleSelect: true,
                        idField: treeParas.idField,
                        treeField: treeParas.treeField,
                        columns: treeParas.columns,
                        onSelect: function (row) {
                            $("#companyName").val(row.Name);
                            ReportParamert.Company = [row];
                        }
                    });
                } else {
                    Pcontrols.helpTreeGrid = $("#helpTreeGrid").treegrid({
                        url: treeParas.url,
                        fit: true,
                        toolbar: "#CompanyToolbar",
                        singleSelect: false,
                        idField: treeParas.idField,
                        treeField: treeParas.treeField,
                        columns: treeParas.columns,
                        onSelect: function (row) {
                            if (!cascading) return;
                            var children = $("#helpTreeGrid").treegrid("getChildren", row.Id);
                            $.each(children, function (index, child) {
                                $("#helpTreeGrid").treegrid("select", child.Id);
                            });
                        },
                        onUnselect: function (row) {
                            if (!cascading) return;
                            var children = $("#helpTreeGrid").treegrid("getChildren", row.Id);
                            $.each(children, function (index, child) {
                                $("#helpTreeGrid").treegrid("unselect", child.Id);
                            });
                        }
                    });
                }
            },
            HelpResultManager: {
                surBtnClick: function () {
                    var result = $("#helpTreeGrid").treegrid("getSelections");
                    if (result) {
                        var Names = "";
                        $.each(result, function (index, node) {
                            Names += node.Name + ",";
                        });
                        Names = Names.substring(0, Names.length - 1);
                        $("#companyName").val(Names);
                        ReportParamert.Company = result;
                    }
                },
                CellHelpBtnClick: function (result) {
                    if (result && result.length > 0) {
                        var str = $("#cellsName").val();
                        $.each(result, function (index, item) {
                            if (!tempData.cells[item.cellCode] || str.indexOf(item.cellCode) < 0) {
                                tempData.cells[item.cellCode] = item;
                                if (str == "") {
                                    str = item.cellCode;
                                } else {
                                    str += "," + item.cellCode;
                                }
                            }
                        });
                        $("#cellsName").val(str);
                    }
                }
            },
            addBtnClick: function () {
                if (ParentParameter.Parent == "ReportLink") {
                    EventManager.returnLinkParameter();
                    return;
                } else {
                    var returnParm = [];
                    var patameter = EventManager.getParameter();
                    if (tempData.type != "report") {
                        var cells = $("#cellsName").val().split(",");
                        $.each(cells, function (index, code) {
                            if (tempData.cells[code]) {
                                if (ReportParamert.Company.length > 0) {
                                    $.each(ReportParamert.Company, function (idx, node) {
                                        patameter.CompanyId = node.Id;
                                        var temp = { IndexCode: tempData.cells[code].cellCode, IndexName: tempData.cells[code].cellName, ReportName: ReportParamert.Report.bbName, ReportCode: ReportParamert.Report.bbCode, CompanyName: node.Name, Parameters: patameter };
                                        returnParm.push(temp);
                                    });
                                } else {
                                    var temp = { IndexCode: tempData.cells[code].cellCode, IndexName: tempData.cells[code].cellName, ReportName: ReportParamert.Report.bbName, ReportCode: ReportParamert.Report.bbCode, CompanyName: "", Parameters: patameter };
                                    returnParm.push(temp);
                                }
                            }
                        });
                    } else {
                        if (ReportParamert.Company.length > 0) {
                            $.each(ReportParamert.Company, function (idx, node) {
                                patameter.CompanyId = node.Id;
                                returnParm.push({ ReportCode: $("#reportValue").val(), ReportName: $("#reportName").val(), CompanyName: node.Name, Parameters: patameter });
                            });
                        } else {
                            returnParm.push({ ReportCode: $("#reportValue").val(), ReportName: $("#reportName").val(), CompanyName: "", Parameters: patameter });
                        }
                    }
                    var modalid = $(window.frameElement).attr("modalid");
                    dialog.setVal(returnParm);
                    dialog.close(modalid);
                  
                }
            },
            returnLinkParameter: function () {
                var returnParm;
                var patameter = EventManager.getParameter();
                returnParm = { ReportCode: $("#reportValue").val(), ReportName: $("#reportName").val(), CompanyName: $("#companyName").val(), Parameters: patameter };
                var modalid = $(window.frameElement).attr("modalid");
                dialog.setVal(returnParm);
                dialog.close(modalid);
            },
            getParameter: function () {
                var param = { TaskId: "", TaskName: "", PaperId: "", PaperName: "", ReportId: "", CompanyId: "" };
                param.TaskName = $("#taskName").val();
                param.TaskId = $("#taskValue").val();
                param.PaperName = $("#paperName").val();
                param.PaperId = $("#paperValue").val();
                param.CompanyId = $("#companyValue").val();
                param.ReportId = ReportParamert.Report.Id
                param.ReportType = ReportParamert.Report.bbCycle;
                param = EventManager.setCycle(param);
                return param;
            },
            setCycle: function (patameter) {
                switch (patameter.ReportType) {
                    case "01":
                        patameter.Year = $('#txtNd').combobox("getValue");
                        break;
                    case "02":
                        patameter.Year = $('#txtNd').combobox("getValue");
                        patameter.Cycle = $('#txtYf').combobox("getValue");
                        break;
                    case "03":
                        patameter.Year = $('#txtNd').combobox("getValue");
                        patameter.Cycle = $('#txtJd').combobox("getValue");
                        break;
                    case "04":
                        patameter.Cycle = $('#txtRq').datebox("getValue");
                        patameter.Year = patameter.Cycle.substr(0, 4);
                        break;
                }
                return patameter;
            },
            backBtnClick: function () {
                var modalid = $(window.frameElement).attr("modalid");
               
                dialog.close(modalid);
            },
            doSearch: function (value, name) {
                var para = {};
                para[name] = value;
                Pcontrols[InViewPara + "Grid"].datagrid("reload", para);
            },
            freeSearch: function () {
                $("#" + InViewPara + "SearchBox").searchbox("setValue", "");
                Pcontrols[InViewPara + "Grid"].datagrid("reload", {});
            }
        };
        var resultManager = {
            success: function (data) {
                if (data.success) {
                    if (ParentParameter && ParentParameter.Data && ParentParameter.Data.Parameters.Year) {
                        data.obj.CurrentNd = ParentParameter.Data.Parameters.Year;
                        data.obj.CurrentZq = ParentParameter.Data.Parameters.Cycle;
                        ParentParameter.Data.Parameters.Year = "";//只有在初始打开的时候有值
                        ParentParameter.Data.Parameters.Cycle = "";
                    }
                    var zqType = ReportParamert.Report.bbCycle;
                    $("tr[name='zq']").remove();
                    switch (zqType) {
                        case "01":
                            $("#auditTd").append('<tr name="zq"><td  >年度</td><td ><input type="text" panelHeight="150px" id="txtNd"/></td></tr>');
                            $('#txtNd').combobox({
                                data: data.obj.Nds,
                                valueField: 'value',
                                textField: 'name'
                            });
                            $('#txtNd').combobox("setValue", data.obj.CurrentNd);
                            break;
                        case "02":
                            $("#auditTd").append('<tr name="zq"><td>年度</td><td ><input type="text" panelHeight="150px" id="txtNd"/></td></tr>');
                            $("#auditTd").append('<tr name="zq"><td>月份</td><td ><input type="text" panelHeight="150px" id="txtYf"/></td></tr>');
                            $('#txtNd').combobox({
                                data: data.obj.Nds,
                                valueField: 'value',
                                textField: 'name'
                            });
                            $('#txtYf').combobox({
                                data: data.obj.Cycles,
                                valueField: 'value',
                                textField: 'name'
                            });
                            $('#txtNd').combobox("setValue", data.obj.CurrentNd);
                            $('#txtYf').combobox("setValue", data.obj.CurrentZq);
                            break;
                        case "03":
                            $("#auditTd").append('<tr name="zq"><td>年度</td><td><input type="text" panelHeight="150px"  id="txtNd"/></td></tr>');
                            $("#auditTd").append('<tr name="zq"><td>季度</td><td><input type="text" panelHeight="150px"  id="txtJd"/></td></tr>');
                            $('#txtNd').combobox({
                                data: data.obj.Nds,
                                valueField: 'value',
                                textField: 'name'
                            });
                            $('#txtJd').combobox({
                                data: data.obj.Cycles,
                                valueField: 'value',
                                textField: 'name'
                            });
                            $('#txtNd').combobox("setValue", data.obj.CurrentNd);
                            $('#txtJd').combobox("setValue", data.obj.CurrentZq);
                            break;
                        case "04":
                            $("#auditTd").append('<tr name="zq"><td  >日期</td><td ><input type="text"  id="txtRq"/></td></tr>');
                            $('#txtRq').datebox({
                                required: true
                            });
                            $('#txtRq').datebox("setValue", data.obj.CurrentNd);
                            break;
                    }
                } else {
                    MessageManager.ErrorMessage(data.sMeg);
                }
            },
            fail: function (data) {
                MessageManager.ErrorMessage(data.toString);
            }
        };
</script>
<style type="text/css">
    .goRight
    {
        cursor:pointer;
       vertical-align:middle;
        }
    .goRight:hover
    {
       margin-left:2px;
        }
</style>
</head>
<body class="easyui-layout" data-options="fit:true" >
    <div id="west" data-options="region:'west',split: true" style=" width:400px">
        <table  id="auditTd" style="text-align:left; float:inherit; margin-top:40px; padding-left:60px" cellspacing="15px">
            <tr><td>审计任务</td><td>
                <%--<div id="task" style="display:inline-block"></div>--%>
                <input id="taskName" readonly="readonly" class="textbox"/><input id="taskValue" type="hidden"/>
                <img src="../../lib/easyUI/themes/icons/next.png"  onclick="EventManager.itemClick(this.id)" id="Task" class="goRight"/>
            </td></tr>
            <tr><td>任务底稿</td><td><%--<div id="paper"></div>--%>
                <input id="paperName" readonly="readonly" class="textbox"/><input id="paperValue" type="hidden"/>
                <img src="../../lib/easyUI/themes/icons/next.png"  onclick="EventManager.itemClick(this.id)" id="Paper" class="goRight"/>
            </td></tr>
            <tr><td>审计单位</td><td><%--<div id="company"></div>--%>
            <input id="companyName" readonly="readonly" class="textbox"/><input id="companyValue" type="hidden"/>
                <img src="../../lib/easyUI/themes/icons/next.png"  onclick="EventManager.itemClick(this.id)" id="Company" class="goRight"/>
            </td></tr>
            <tr><td>报表选择</td><td><%--<div id="report"></div>--%>
            <input id="reportName" readonly="readonly" class="textbox"/><input id="reportValue" type="hidden"/>
                <img src="../../lib/easyUI/themes/icons/next.png"  onclick="EventManager.itemClick(this.id)" id="Report" class="goRight"/>
            </td></tr>
            <tr id="Td_Index"><td>指标选择</td><td><%--<div id="cells"></div>--%>
            <input id="cellsName" readonly="readonly" class="textbox"/><input type="hidden"/>
                <img src="../../lib/easyUI/themes/icons/next.png"  onclick="EventManager.itemClick(this.id)" id="Cells" class="goRight"/>
            </td></tr>
        </table>
       
    </div>
    <div id="center" data-options="region:'center'" style=" overflow:hidden">
        <iframe id="cellframe" src= "CellHelp.aspx" height="100%" width="100%" style="display:none"  frameborder="0" "></iframe>          
        <div id="helpTreeDiv" style=" width:100%; height:100%;display:none"><table id="helpTreeGrid"  ></table></div>
        <div id="helpTaskDiv" style=" width:100%; height:100%;display:none"><table id="helpSeachGridT" ></table></div>
        <div id="helpPaperDiv" style=" width:100%; height:100%;display:none"><table id="helpSeachGridP"  ></table></div>
        <div id="helpReportDiv" style=" width:100%; height:100%;display:none"><table id="helpSeachGridR" ></table></div>
    </div>
    <div id="south" data-options="region:'south'" style="height:40px;background-color:#D2E9FF ; padding-top:5px; width:100%">
        <a  href="#" class="easyui-linkbutton" style="margin-right:110px;width:60px;float:right; outline:none; " iconcls="icon-save" onclick="EventManager.addBtnClick()" >保存</a><a  href="#" class="easyui-linkbutton"  style="right:30px; position:absolute; float:right; outline:none;width:60px" iconcls="icon-back"  onclick="EventManager.backBtnClick()">返回</a>
    </div>
    <div id="CompanyToolbar" style=" padding:3px; display:none">
        <input type="checkbox" checked="checked" style="height:15px;width:15px; margin-top:2px ;float:left" onchange="changeCascad()"/><span>级联选择</span> 
        <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-ok',plain:false" onclick="EventManager.HelpResultManager.surBtnClick()" style=" outline:none; margin-left:25px">确定</a>
    </div>
    <div id="TaskToolbar" style=" padding:3px; display:none">
         <input id="TaskSearchBox" class="easyui-searchbox" style="width:300px" data-options="searcher:EventManager.doSearch,prompt:'请输入查询内容',menu:'#SearchMenu'"/> 
            <div id="SearchMenu" style="width:120px"> 
                <div data-options="name:'Code',iconCls:'icon-search'">编号</div> 
                <div data-options="name:'Name',iconCls:'icon-search'">名称</div> 
            </div> 
        <a href="#" class="easyui-linkbutton" onclick="EventManager.freeSearch()" iconcls="icon-undo" style=" margin-left:15px">重置</a>
    </div>
    <div id="PaperToolbar" style=" padding:3px; display:none">
         <input id="PaperSearchBox" class="easyui-searchbox" style="width:300px" data-options="searcher:EventManager.doSearch,prompt:'请输入查询内容',menu:'#SearchMenu'"/> 
        <a href="#" class="easyui-linkbutton" onclick="EventManager.freeSearch()" iconcls="icon-undo" style=" margin-left:15px">重置</a>
    </div>
    <div id="ReportToolbar" style=" padding:3px; display:none">
         <input id="ReportSearchBox" class="easyui-searchbox" style="width:300px" data-options="searcher:EventManager.doSearch,prompt:'请输入查询内容',menu:'#bbMenu'"/> 
            <div id="bbMenu" style="width:120px"> 
                <div data-options="name:'bbCode',iconCls:'icon-search'">编号</div> 
                <div data-options="name:'bbName',iconCls:'icon-search'">名称</div> 
            </div> 
        <a href="#" class="easyui-linkbutton" onclick="EventManager.freeSearch()" iconcls="icon-undo" style=" margin-left:15px">重置</a>
    </div>
    <div id="HelpDialog"></div>
</body>
</html>
