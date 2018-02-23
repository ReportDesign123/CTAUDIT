<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AuditDesignManager.aspx.cs" Inherits="Audit.ct.ReportAudit.AuditDesignManager" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>审计联查设置</title>
    <meta http-equiv="X-UA-Compatible" content="IE=10" />
     <meta http-equiv="X-UA-Compatible" content="IE=9" />
     <meta http-equiv="X-UA-Compatible" content="IE=8" />
     <meta http-equiv="X-UA-Compatible" content="IE=7" />
    <script src="../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
   <script src="../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
     <script src="../../Scripts/Ct_Controls.js" type="text/javascript"></script>
    <link href="../../Styles/Ct_Controls.css" rel="stylesheet" type="text/css" />
     <link href="../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    
   <script src="../../lib/json2.js" type="text/javascript"></script>
    <script src="../../lib/Base64.js" type="text/javascript"></script>
    <link href="../../Styles/Common.css" rel="stylesheet" type="text/css" />
    <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script src="../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <script src="../../Scripts/ct/pub/PubHelp.js" type="text/javascript"></script>

    
       <script src="../../Scripts/ct_dialog.js" type="text/javascript"></script>
    <script type="text/javascript">
        var urls = {
            FormatUrl: "../../handler/FormatHandler.ashx",
            FormularUrlGS: "../Format/NewFormular.aspx",
            FormularUrlDZ: "../pub/ContentInfo.aspx",
            IndexUrl: "../pub/ReportParameters.aspx",
            AduitUrl: "../../handler/ReportAuditHandler.ashx",
            reportAuditUrl: "../../handler/ReportAuditHandler.ashx"
        };
        var BBData = { Id: "", bbCode: "", bbName: "", bbClassifyId: "", bbData: {}, bdq: { bdNum: 0, BdRowNum: 0, BdColNum: 0, BdqMaps: {}, Bdqs: [] }, bbRows: "", bbCols: "", zq: "", MergeCells: [], MaxNum: "0" };
        var cellData = { row: "", col: "", cells: {}, settingCells: {}, setedCells: [], report: {}, DesignData: {} };


        var control = { InEdit: "", IndexList: [], ReportList: [], Checked_ZQ: "Year", LinkType: "", LinkContent: "",DbType:"" };
        var DesignData = {};
        var comboxData = [{ Code: "xgzb", Name: "相关指标"}];
        $(function () {
            DesignData = ControlManager.NewDesign();
            $("#moduleCombox").combobox({
                data: comboxData,
                textField: 'Name',
                valueField: 'Code',
                onSelect: ModuleManager.setModules,
                onLoadSuccess: function (data) {
                    if (data.length > 0) {
                        $("#Div_module").css("display", "block");
                        $("#moduleCombox").combobox("select", data[0].Code);
                    } else {
                        $("#Div_module").css("display", "none");
                        $("#moduleCombox").combobox("setValue", null);
                    }
                }
            });
            $("#LinkType").combobox({
                data: [
                { text: '取数公式', value: 'formular' },
                { text: '地址链接', value: 'url' }
                ],
                textField: 'text',
                valueField: 'value',
                onSelect: function (type) {
                    if (type.value == 'formular' && control.LinkType == "formular") {
                        $("#reportFormular").text(control.LinkContent);
                        return;
                    }
                    if (type.value == 'url' && control.LinkType == "url") {
                        $("#reportFormular").text(control.LinkContent);
                        return;
                    }
                    $("#reportFormular").text("");
                }
            });
            var url = location.href;
            var paraStr = url.split("?")[1];
            cellData.report = {};
            cellData.report.Id = paraStr.split("=")[1];
            ControlManager.LoadCellDatas();
            ReportCellManager.ImportReportCell(cellData.report);
        });
        var EventManager = {
            setComboxData: function () {
                var data = $("#moduleCombox").combobox("getData");
                dialog.Open("ct/ReportAudit/ChooseModules.aspx", "帮助", data, function (result) {
                    if (result) {
                        $("#moduleCombox").combobox("loadData", result);
                        DesignData.ExistsModules = result;
                        cellManager.GeneralLoadCellDataValue();
                        $.each(cellData.settingCells, function (code, node) {
                            cellData.cells[node] = { Data: JSON.stringify(DesignData), ReportId: cellData.report.Id, IndexCode: node };
                        });
                    }
                }, { width: 350, height: 350 });

                
            },
            addBtn_Click: function () {
                switch (control.InEdit) {
                    case "zbgc": //指标构成
                        ControlManager.OpenDialog(urls.IndexUrl, "添加指标", "indexGrid");
                        break;
                    case "bblc": //报表联查
                        ControlManager.OpenDialog(urls.IndexUrl, "添加报表", "report");
                        break;
                }
            },
            ZQ_Check: function (id, check) {
                if (check) {
                    control.Checked_ZQ = id;
                } else (control.Checked_ZQ = "");
                saveChange("DurationType");
            },
            GridManager: {
                RowColChange_Event: function (row, col) {
                    cellManager.GeneralLoadCellDataValue(row, col);
                    ControlManager.initializeCellModules();
                }
            }
        };
        var ControlManager = {
            LoadCellDatas: function () {
                var param = { ReportId: cellData.report.Id };
                param = CreateParameter(ReportAuditAction.ActionType.Post, ReportAuditAction.Functions.ReportAudit, ReportAuditAction.Methods.ReportAuditDefinitionMethods.GetAuditDefinition, param);
                DataManager.sendData(urls.AduitUrl, param, resultManager.success_LoadCellDatas, resultManager.fail,true);
            },
            //自定义联查 创建公式
            ShowFormularDialog: function () {
                var type = $("#LinkType").combobox("getValue");
                var content = $("#reportFormular").text();
                var result;
                if (type == "formular") {
                    dialog.Open(urls.FormularUrlGS, "帮助", { content: content, DataSource: control.DbType }, function (result) {
                        if (result) {
                            control.LinkType = $("#LinkType").combobox("getValue");
                            $("#reportFormular").text(result.content);
                            control.LinkContent = result.content;
                            control.DbType = result.DataSource;
                            saveChange("LinkType");
                            saveChange("DbType");
                            saveChange("Content");
                        }
                    }, { width: 800, height: 600 });

                    
                } else if (type == "url") {
                    dialog.Open(urls.FormularUrlDZ, "帮助", content, function (result) {
                        if (result) {
                            control.LinkType = $("#LinkType").combobox("getValue");
                            $("#reportFormular").text(result);
                            control.LinkContent = result;
                            saveChange("LinkType");
                            saveChange("Content");
                        }
                    }, { width: 400, height: 300 });

                   
                }
            },
            //相关报表、相关指标参数选择界面
            OpenDialog: function (url, title, type) {
                dialog.Open(url, "帮助", type, function (result) {
                    if (result) {
                        var find = false;
                        if (type == "indexGrid") {
                            for (var i = 0; i < result.length; ++i) {
                                if (!find) {
                                    control.IndexList.push(result[i]);
                                    find = false;
                                }
                            }
                            control[type].datagrid("loadData", control.IndexList);
                            saveChange("Indexs");
                        } else {
                            for (var j = 0; j < result.length; ++j) {
                                if (!find) {
                                    control.ReportList.push(result[j]);
                                    find = false;
                                }
                            }
                            control[type].datagrid("loadData", control.ReportList);
                            saveChange("Reports");
                        }
                    }
                }, { width: 950, height: 550 });

                 
            },
            //导入相关指标
            LoadIndexList: function (data) {
                control.indexGrid = $("#gridTable").datagrid({
                    fit: true,
                    fitColumns: true,
                    sortName: "IndexCode",
                    sortOrder: 'ASC',
                    data: data,
                    columns: [[
                    { field: 'ReportCode', checkbox: true },
                    { field: 'IndexName', title: '指标', width: 100, formatter: function (value, row, index) {
                        if (value != "") return value;
                        else return row.IndexCode;
                    }
                    },
                    { field: 'ReportName', title: '报表', width: 100 },
                    { field: 'CompanyName', title: '单位', width: 80 }
                    ]]
                });
            },
            //导入相关报表
            LoadReportList: function (data) {
                control.report = $("#gridTable").datagrid({
                    fit: true,
                    fitColumns: true,
                    sortName: "ReportCode",
                    sortOrder: 'ASC',
                    data: data,
                    columns: [[
                    { field: 'CompanyCode', checkbox: true },
                    { field: 'ReportCode', title: '编号', width: 80 },
                    { field: 'ReportName', title: '名称', width: 100 },
                    { field: 'CompanyName', title: '单位', width: 100 }
                    ]]
                });
            },
            DeltList: function (type) {
                var selected = control[type].datagrid("getSelections");
                if (type == "indexGrid") {
                    for (var i = 0; i < selected.length; ++i) {
                        $.each(control.IndexList, function (nodeIndex, node) {
                            if (node == selected[i]) {
                                control.IndexList.remove(nodeIndex);
                                return false;
                            }
                        });
                    }
                    control.indexGrid.datagrid("loadData", control.IndexList);
                    saveChange("Indexs");
                } else {
                    for (var j = 0; j < selected.length; ++j) {
                        $.each(control.ReportList, function (nodeIndex, node) {
                            if (node == selected[j]) {
                                control.ReportList.remove(nodeIndex);
                                return false;
                            }
                        });
                    }
                    control.report.datagrid("loadData", control.ReportList);
                    saveChange("Reports");
                }
            },
            clearFormular: function () {
                control.LinkContent = "";
                saveChange("Content");
                $("#reportFormular").text("");
            },
            NewDesign: function () {
                var Design = {
                    IndexConclusion: { IsOrNotMobile: "1" }, //结论
                    IndexTrend: { IsOrNotMobile: "1", DurationType: "Year" }, //趋势
                    IndexConstitution: { IsOrNotMobile: "1", Indexs: [] }, //体质，构造{ IndexCode:"", IndexName: "", Parameters: {}}
                    ReportJoin: { IsOrNotMobile: "1", Reports: [] }, //报表联查{ ReportCode: "", ReportName: "", Parameters: []}
                    CustomerJoin: { IsOrNotMobile: "1", LinkType: "", DbType: "", Content: "" }, //自定义联查
                    IndexRelations: { IsOrNotMobile: "1", Indexs: [{ Code: "SQS", Name: "上期数" }, { Code: "TQS", Name: "同期数" }, { Code: "HBS", Name: "环比数" }, { Code: "TBS", Name: "同比数"}] }, //关系{ Code: "", Name: ""}
                    ExistsModules: []//已设置过的模块
                };
                return Design;
            },
            getDesignData: function () {
                var data = "";
                if (cellData.cells[cellData.settingCells[0]]) {
                    data = cellData.cells[cellData.settingCells[0]].Data;
                } else if (cellData.DesignData[cellData.settingCells[0]]) {
                    data = cellData.DesignData[cellData.settingCells[0]].Data;
                }
                return data;
            },
            //初始化 设置信息
            initializeCellModules: function () {
                control = { InEdit: "", IndexList: [], ReportList: [], Checked_ZQ: "Year", LinkType: "", LinkContent: "", DbType: "" };
                var data = ControlManager.getDesignData();
                if (cellData.settingCells.length == 1 && data != "") {
                    DesignData = $.parseJSON(data);
                    $("#moduleCombox").combobox("loadData", DesignData.ExistsModules);
                    if (DesignData.ExistsModules == 0) { return; }
                    ControlManager.initializeMobileState();
                    $("#check_SQS").prop('checked', false);
                    $("#check_TQS").prop('checked', false);
                    $("#check_HBS").prop('checked', false);
                    $("#check_TBS").prop('checked', false);
                    $.each(DesignData.IndexRelations.Indexs, function (index, node) {
                        $("#check_" + node.Code).prop('checked', true);
                    });
                    control.IndexList = DesignData.IndexConstitution.Indexs;
                    control.ReportList = DesignData.ReportJoin.Reports;
                    $("#" + DesignData.IndexTrend.DurationType).prop('checked', true);
                    $("#LinkType").combobox("setValue", DesignData.CustomerJoin.LinkType);
                    control.LinkType = DesignData.CustomerJoin.LinkType;
                    $("#reportFormular").text(DesignData.CustomerJoin.Content);
                    control.LinkContent = DesignData.CustomerJoin.Content;
                    control.DbType = DesignData.CustomerJoin.DbType;
                } else {
                    DesignData = ControlManager.NewDesign();
                    $("#moduleCombox").combobox("loadData", comboxData);
                    $("#check_Mobile").prop('checked', true);
                    $("#check_SQS").prop('checked', true);
                    $("#check_TQS").prop('checked', true);
                    $("#check_HBS").prop('checked', true);
                    $("#check_TBS").prop('checked', true);
                    $("#Year").prop('checked', true);
                    $("#LinkType").combobox("setValue", "");
                    control.LinkType = "";
                    control.DbType = "";
                    control.LinkContent = "";
                    $("#reportFormular").text("");
                }
            },
            //初始化 是否订阅
            initializeMobileState: function () {
                var Module = ModuleManager.getModule();
                var state = DesignData[Module]["IsOrNotMobile"];
                if (state == "1") {
                    $("#check_Mobile").prop('checked', true);
                } else {
                    $("#check_Mobile").prop('checked', false);
                }
            }
        };
        var ModuleManager = {
            setModules: function (node) {
                control.InEdit = node.Code;
                $("#module").panel("setTitle", node.Name);
                $("#formularContent").text(node.Name);
                $("#ZhiBiao").css("display", "none");
                $("#Tr_QuShu").css("display", "none");
                $("#Tr_Report").css("display", "none");
                $("#Tr_ZqList").css("display", "none");
                $("#Tr_ZhiBiao").css("display", "none");
                $("#Tr_Formular").css("display", "none");
                $("#Tr_datagrid").css("display", "none");
                $("#ZhiBiao_about").css("display", "none");
                switch (node.Code) {
                    case "sjjl": //审计结论
                        break;
                    case "xgzb": //相关指标
                        $("#ZhiBiao").css("display", "block");
                        $("#ZhiBiao_about").css("display", "inline");
                        break;
                    case "zbgc": //指标构成
                        $("#ZhiBiao").css("display", "none");
                        $("#Tr_datagrid").css("display", "inline");
                        $("#Tr_ZhiBiao").css("display", "inline");
                        ControlManager.LoadIndexList(control.IndexList);
                        break;
                    case "bblc": //报表联查
                        $("#Tr_datagrid").css("display", "inline");
                        $("#Tr_Report").css("display", "inline");
                        ControlManager.LoadReportList(control.ReportList);
                        break;
                    case "zbqs": //指标趋势
                        $("#Tr_ZqList").css("display", "inline");
                        break;
                    case "zdylc": //自定义联查
                        $("#Tr_QuShu").css("display", "inline");
                        $("#Tr_Formular").css("display", "inline");
                        break;
                }
                ControlManager.initializeMobileState();
            },
            //相关指标
            Save_RelationIndexs: function () {
                var list = [];
                if ($("#check_SQS").is(":checked")) {
                    list.push({ Code: "SQS", Name: "上期数" });
                }
                if ($("#check_TQS").is(":checked")) {
                    list.push({ Code: "TQS", Name: "同期数" });
                }
                if ($("#check_HBS").is(":checked")) {
                    list.push({ Code: "HBS", Name: "环比数" });
                }
                if ($("#check_TBS").is(":checked")) {
                    list.push({ Code: "TBS", Name: "同比数" });
                }
                return list;
            },
            Save_AllSetting: function () {
                data = JSON.stringify(cellData.cells);
                var para = { data: data };
                para = CreateParameter(ReportAuditAction.ActionType.Post, ReportAuditAction.Functions.ReportAudit, ReportAuditAction.Methods.ReportAuditDefinitionMethods.SaveAuditDefinition, para);
                DataManager.sendData(urls.AduitUrl, para, resultManager.successSave, resultManager.fail);
                ControlManager.LoadCellDatas();
                cellData.cells = {};
            },
            getModule: function () {
                var Code = "";
                var Module = $("#moduleCombox").combobox("getValue");
                switch (Module) {
                    case "sjjl": //审计结论
                        Code = "IndexConclusion";
                        break;
                    case "xgzb": //相关指标
                        Code = "IndexRelations";
                        break;
                    case "zbgc": //指标构成
                        Code = "IndexConstitution";
                        break;
                    case "zbqs": //指标趋势
                        Code = "IndexTrend";
                        break;
                    case "bblc": //报表联查
                        Code = "ReportJoin";
                        break;
                    case "zdylc": //自定义联查
                        Code = "CustomerJoin";
                        break;
                }
                return Code;
            }, getChange: function (Module, item) {
                var result;
                if (item == "IsOrNotMobile") {
                    if ($("#check_Mobile").is(":checked")) {
                        result = "1";
                    }
                    else { result = "0"; }
                    return result;
                }
                switch (Module) {
                    case "IndexRelations":
                        if (item == "Indexs") { result = ModuleManager.Save_RelationIndexs(); }
                        break;
                    case "IndexConstitution":
                        if (item == "Indexs") { result = control.IndexList; }
                        break;
                    case "IndexTrend":
                        if (item == "DurationType") { result = control.Checked_ZQ; }
                        break;
                    case "ReportJoin":
                        if (item == "Reports") { result = control.ReportList; }
                        break;
                    case "CustomerJoin":
                        if (item == "Content") { result = control.LinkContent; }
                        if (item == "LinkType") { result = control.LinkType; }
                        if (item == "DbType") { result = control.DbType; }
                        break;
                }
                return result;


            }
        }
        var ReportCellManager = {
            //导入报表格式
            ImportReportCell: function (report) {
                if (report && report.Id != undefined) {
                    var para = { Id: "" };
                    para.Id = report.Id;
                    para = CreateParameter(ReportFormatAction.ActionType.Post, ReportFormatAction.Functions.ReportFormatMenu, ReportFormatAction.Methods.ReportFormatMenuMethods.LoadReportFormat, para);
                    DataManager.sendData(urls.FormatUrl, para, resultManager.LoadSuccess, resultManager.fail, false);
                }
            }
        };
        var resultManager = {
            successSave: function (data) {
                if (data.success) {
                    alert(data.sMeg);
                } else {
                    alert(data.sMeg);
                }
            },
            fail: function (data) {
                alert(data.toString);
            },
            LoadSuccess: function (data) {
                if (data.success) {
                    Grid1.NewFile();
                    Grid1.AutoRedraw = false;
                    Grid1.LoadFromXMLString(Base64.fromBase64(data.obj.formatStr));
                    if (Grid1.attachEvent) {
                        Grid1.attachEvent("RowColChange", EventManager.GridManager.RowColChange_Event);
                        Grid1.AutoRedraw = true;
                    }
                    Grid1.Refresh();
                    BBData = JSON2.parse(data.obj.itemStr);
                    for (var i = 0; i < Grid1.Rows; i++) {
                        for (var j = 0; j < Grid1.Cols; j++) {
                            Grid1.Cell(i, j).Locked = true;
                        }
                    }
                } else {
                    alert(data.sMeg);
                }
            },
            success_LoadCellDatas: function (data) {
                if (data.success) {
                    cellData.DesignData = data.obj;
                } else {
                    alert(data.sMeg);
                }
            }
        };
        var cellManager = {
            GeneralLoadCellDataValue: function (row, col) {
                cellData.row = Grid1.Selection.FirstRow;
                cellData.col = Grid1.Selection.FirstCol;
                var cells = [];
                var selection = Grid1.Selection;
                for (var i = selection.FirstRow; i <= selection.LastRow; i++) {
                    for (var j = selection.FirstCol; j <= selection.LastCol; j++) {
                        var cell = cellManager.CreateCode(i, j);
                        if (cell) {
                            cells.push(cell);
                        }
                    }
                }
                cellData.settingCells = cells;
            },
            CreateCode: function (row, col) {
                if (BBData.bbData[row] && BBData.bbData[row][col]) {
                    return BBData.bbData[row][col].CellCode;
                } else { return null; }
            },
            GetCellData: function (row, col) {
                return BBData.bbData[row][col];
            }
        }
        function overBtn() {
            $("#titleBtn").css("top", "4px");
        }
        function outBtn() {
            $("#titleBtn").css("top", "5px");
        }
        function saveChange(item) {
            var Module = ModuleManager.getModule();
            DesignData[Module][item]= ModuleManager.getChange(Module,item);
            cellManager.GeneralLoadCellDataValue();
            $.each(cellData.settingCells, function (code, node) {
                cellData.cells[node] = { Data: JSON.stringify(DesignData), ReportId: cellData.report.Id, IndexCode: node };
            });
        }
    </script>
</head>
<body style=" overflow:hidden" class="easyui-layout">
    <div data-options="region:'center',title:'表格部分',split:false,tools:[{
                iconCls: 'icon-save',
                handler: ModuleManager.Save_AllSetting
            }]">
	    <OBJECT CLASSID = "clsid:5220cb21-c88d-11cf-b347-00aa00a28331" VIEWASTEXT>
            <PARAM NAME="LPKPath" VALUE="../lpk/flexCell.LPK">
        </OBJECT> 
        <OBJECT TYPE="application/x-itst-activex"  ID="Grid1" Width=100% Height=96%    CLASSID="clsid:4331220A-1077-4630-BEE3-0D7142D6ABD0" >
            <PARAM NAME="_ExtentX" VALUE="0">
            <PARAM NAME="_ExtentY" VALUE="0">       
        </OBJECT>
	</div>
     <div data-options="region:'east',split:true,collapsible:false" title="模块设置 <img id='titleBtn' src='../../lib/ligerUI/skins/icons/settings.gif' style='left:60px;top:5px;position:absolute;cursor:pointer'onmousemove='overBtn()'onmouseout='outBtn()' onclick='EventManager.setComboxData()'/>" style="width:450px; padding:1px; overflow-x:hidden">
        <div style="width:450px; height:22%; padding:15px">
            模块选择<div style=" float:right ;margin-right:45px"><input id="moduleCombox" class="easyui-combobox" style="width:310px;margin-right:10px" data-options="panelHeight:'auto'"/></div>
        </div>
        <div id="Div_module" style="height:auto;width:auto">
            <div id="module" class="easyui-panel" title="疑点问题" style="width:450px;border:0px;">
                <table style=" font-size:13px; width:100%; padding:12px">
                    <tr><td>模块描述<textarea id="formularContent" cols="35" rows="5" style="border:1px solid  #99aaff; float:right; padding:5px; margin-right:20px; margin-bottom:15px" readonly="readonly"></textarea></td></tr>
                    <tr style=" display:none"><td style=" padding: 10px 0px 10px 90px"><input type="checkbox" id="check_Mobile" checked="checked"onclick="saveChange('IsOrNotMobile')" />手机是否订阅</td></tr>
                    <tr id="ZhiBiao"><td> 指标选择</td></tr>
                    <tr id="Tr_Report"><td>相关报表<a class="easyui-linkbutton" style="width:140px;height:25px; margin-left:40px; background:#E0ECFF" onclick="EventManager.addBtn_Click()" iconcls="icon-add">添加报表...</a><a class="easyui-linkbutton" style="width:130px;height:25px; margin-left:25px; background:#E0ECFF" onclick="ControlManager.DeltList('report')" iconcls="icon-cut">删除选中</a></td></tr>
                    <tr id="Tr_QuShu"><td><div style="width:390px">联查类型<div style="float:right;">
                    <input id="LinkType" class="easyui-combobox" style="width:150px;margin-left:38px"data-options="panelHeight:'auto'"/>
                    <a class="easyui-linkbutton" style="width:60px; height:25px; margin-left:10px; background:#E0ECFF" onclick="ControlManager.ShowFormularDialog()" iconcls="icon-edit">编辑</a>
                    <a class="easyui-linkbutton" style="width:60px; height:25px; margin-left:10px; background:#E0ECFF" onclick="ControlManager.clearFormular()" iconcls="icon-cut">清除</a>
                    </div></div>
                    </td></tr>
                    <tr id="ZhiBiao_about"><td style="padding-left:90px;">
                        <div><input type="checkbox" checked="checked" id="check_SQS" onclick="saveChange('Indexs')"/>上期数</div>
                        <div style="margin:8px 0px 8px 0px"><input type="checkbox" onclick="saveChange('Indexs')" checked="checked" id="check_TQS"/>同期数</div>
                        <div><input type="checkbox" checked="checked" id="check_HBS" onclick="saveChange('Indexs')"/>环比数
                        <div style="margin-top:8px"><input type="checkbox" onclick="saveChange('Indexs')" checked="checked" id="check_TBS"/>同比数</div>
                        </div></td></tr>
                    <tr id="Tr_ZhiBiao"><td>指标选择<a class="easyui-linkbutton" style="width:140px;height:25px; margin-left:40px; background:#E0ECFF" iconcls="icon-add" onclick="EventManager.addBtn_Click()" >指标添加...</a><a class="easyui-linkbutton" style="width:130px;height:25px; margin-left:25px; background:#E0ECFF"iconcls="icon-cut" onclick="ControlManager.DeltList('indexGrid')" >删除选中</a></td></tr>
                    <tr id="Tr_datagrid"><td style="width:395px;height:170px;"><table id="gridTable"></table></td></tr>
                    <tr id="Tr_ZqList"><td style=" padding:15px 0px 0px 87px;"><div id="Div2" style="width:310px;height:140px;border:1px solid  #99aaff;">
                        <div><input type="radio" id="Year" name="DurationType" onclick="EventManager.ZQ_Check(this.id,$(this).is(':checked'))" style="margin-top:8px" checked="checked" />当前年</div>
                        <div><input type="radio" id="Quarter" name="DurationType" onclick="EventManager.ZQ_Check(this.id,$(this).is(':checked'))" style="margin-top:8px;margin-bottom:8px" />当前季度</div>
                        <div><input type="radio" id="Month" name="DurationType" onclick="EventManager.ZQ_Check(this.id,$(this).is(':checked'))" style="margin-bottom:8px"/>当前月</div>
                        <div><input type="radio" id="Week" name="DurationType" onclick="EventManager.ZQ_Check(this.id,$(this).is(':checked'))"/>当前周</div>
                        </div>
                    </td></tr>
                    <tr id="Tr_Formular"><td><textarea id="reportFormular" cols="47" rows="10" style="border:1px solid  #99aaff;"  readonly="readonly"></textarea></td></tr>
                </table> 
            </div> 
        </div> 
    </div>
    <div id="Dialog"></div>  
</body>
</html>
