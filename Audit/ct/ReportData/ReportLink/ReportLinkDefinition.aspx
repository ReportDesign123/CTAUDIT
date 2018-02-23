<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReportLinkDefinition.aspx.cs" Inherits="Audit.ct.ReportData.ReportLink.ReportLinkDefinition" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
   <title>审计联查设置</title>
    <meta http-equiv="X-UA-Compatible" content="IE=10" />
    <meta http-equiv="X-UA-Compatible" content="IE=9" />
    <meta http-equiv="X-UA-Compatible" content="IE=8" />
    <meta http-equiv="X-UA-Compatible" content="IE=7" />
    <script src="../../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <script src="../../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="../../../Scripts/Ct_Controls.js" type="text/javascript"></script>
    <link href="../../../Styles/Common.css" rel="stylesheet" type="text/css" />
    <link href="../../../Styles/Ct_Controls.css" rel="stylesheet" type="text/css" />
    <link href="../../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../../../lib/json2.js" type="text/javascript"></script>
    <script src="../../../lib/Base64.js" type="text/javascript"></script>
    <script src="../../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script src="../../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <script src="../../../Scripts/ct/pub/PubHelp.js" type="text/javascript"></script>
       <script src="../../Scripts/ct_dialog.js" type="text/javascript"></script>
    <script type="text/javascript">
        var urls = {
            FormatUrl: "../../../handler/FormatHandler.ashx",
            FormularUrlGS: "../../Format/NewFormular.aspx",
            FormularUrlDZ: "../../pub/ContentInfo.aspx",
            ParamUrl: "../../pub/ReportParameters.aspx",
            AduitUrl: "../../../handler/ReportAuditHandler.ashx",
            reportAuditUrl: "../../../handler/ReportAuditHandler.ashx"
        };
        var BBData = { Id: "", bbCode: "", bbName: "", bbClassifyId: "", bbData: {}, bdq: { bdNum: 0, BdRowNum: 0, BdColNum: 0, BdqMaps: {}, Bdqs: [] }, bbRows: "", bbCols: "", zq: "", MergeCells: [], MaxNum: "0" };
        var cellData = { row: "", col: "", cells: {}, settingCells: {}, setedCells: [], report: {}, LinkInfData: [] };
        var control = { ReportList: [], LinkType: "ReportJoin", LinkContent: "", DbType: "", LinkList: {}, InEditRowIndex: null };
        var LinkTypeObj = { ReportJoin: "报表联查", CustomFormular: "取数公式", CustomUrl: "地址链接" };
        var DesignData = {};
        $(function () {
            control.LinkList = $("#gridTable").datagrid({
                title: "联查列表",
                fit: true,
                fitColumns: true,
                sortName: "ReportCode",
                sortOrder: 'ASC',
                toolbar: "#toolbar",
                columns: [[
                    { field: 'Id', checkbox: true },
                    { field: 'Code', title: '联查编号', width: 100 },
                    { field: 'Name', title: '联查名称', width: 150 },
                    { field: 'Type', title: '联查类型', width: 150, formatter: function (value) {
                        if (value) {
                            return LinkTypeObj[value]
                        } else { return value }
                    }
                    }
                ]],
                onSelect: ControlManager.EditLinkInf,
                onUnselect: function (index, row) {
                    if (index == control.InEditRowIndex) {
                        ControlManager.clearLinkInf();
                    }
                }
            });
            $('#tt').panel({
                fit: true,
                title: "联查信息",
                border: false,
                closable: false
            });
            $("#LinkType").combobox({
                data: [
                { text: '报表联查', value: 'ReportJoin' },
                { text: '取数公式', value: 'CustomFormular' },
                { text: '地址链接', value: 'CustomUrl' }
                ],
                textField: 'text',
                valueField: 'value',
                onSelect: function (type) {
                    $("#linkSpan").text(type.text);
                    control.LinkType = type.value;
                    $("#reportFormular").text("");
                    if (type.value == 'ReportJoin') {// && control.LinkType == "report"
                        $("#linkTextTr").css("display", "table-row")
                        $("#btnSpan").text("编辑联查报表");
                    } else if (type.value == 'CustomFormular') {// && control.LinkType == "formular"
                        $("#linkTextTr").css("display", "table-row")
                        $("#btnSpan").text("编辑联查公式");
                        $("#reportFormular").text(control.LinkContent);
                        return;
                    } else if (type.value == 'CustomUrl') {// && control.LinkType == "url"
                        $("#linkTextTr").css("display", "none")
                        $("#reportFormular").text(control.LinkContent);

                        return;
                    }
                }
            });
            var url = location.href;
            var paraStr = url.split("?")[1];
            cellData.report = {};
            cellData.report.Id = paraStr.split("=")[1];
            cellManager.ImportReportCell(cellData.report);
            //ControlManager.LoadCellDatas();
        });
        var cellManager = {
            //导入报表格式
            ImportReportCell: function (report) {
                if (report && report.Id != undefined) {
                    var para = { Id: "" };
                    para.Id = report.Id;
                    para = CreateParameter(ReportFormatAction.ActionType.Post, ReportFormatAction.Functions.ReportFormatMenu, ReportFormatAction.Methods.ReportFormatMenuMethods.LoadReportFormat, para);
                    DataManager.sendData(urls.FormatUrl, para, resultManager.LoadSuccess, resultManager.fail, false);
                }
            },
            LoadCellLinkInf: function (collCode) {
                var param = { ReportId: cellData.report.Id, IndexCode: collCode };
                param = CreateParameter(ReportFormatAction.ActionType.Post, ReportFormatAction.Functions.ReportLinkAction, ReportFormatAction.Methods.ReportLinkMethods.GetReportLinkList, param);
                DataManager.sendData(urls.FormatUrl, param, resultManager.success_LoadLinkInf, resultManager.fail, true);
            },
            RowColChange_Event: function (row, col) {
                cellManager.GeneralLoadCellDataValue(row, col);
                if (cellData.settingCells.length > 0) {
                    cellManager.LoadCellLinkInf(cellData.settingCells[0]);
                } else {
                    cellData.LinkInfData = [];
                    control.LinkList.datagrid("loadData", cellData.LinkInfData);
                    ControlManager.clearLinkInf();
                }
                //ControlManager.initializeCellModules();
            },
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
                if (cells.length <= 1) {
                    cellData.settingCells = cells;
                    ControlManager.clearLinkInf();
                } else if (cells.length > 1) {
                    cellData.settingCells = [];
                    MessageManager.InfoMessage("不支持多单元格同时设置");
                }
            },
            CreateCode: function (row, col) {
                if (BBData.bbData[row] && BBData.bbData[row][col]) {
                    return BBData.bbData[row][col].CellCode;
                } else { return null; }
            },
            GetCellData: function (row, col) {
                return BBData.bbData[row][col];
            }
        };
        var ControlManager = {
            // 创建公式
            ShowFormularParamDialog: function () {
                var type = $("#LinkType").combobox("getValue");
                var content = $("#reportFormular").text();
                var result;
                if (type == "ReportJoin") {
                    var parameter = { type: "report", Parent: "ReportLink", Data: {} };
                    parameter.Data = JSON2.parse(content);
                    dialog.Open(urls.ParamUrl, "创建公式", parameter, function (result) {
                        if (result) {
                            content = JSON2.stringify(result);
                            $("#reportFormular").text(content);
                        }
                    }, { width: 950, height: 550 });

                   
                } else if (type == "CustomFormular") {
                    var CustomLinkStruct = { Content: "", DbType: "" };
                    if (content) {
                        CustomLinkStruct = JSON2.parse(content);
                    }
                    dialog.Open(urls.FormularUrlGS, "创建公式", { content: CustomLinkStruct.Content, DataSource: CustomLinkStruct.DbType }, function (result) {
                        if (result) {
                            CustomLinkStruct.LinkType = $("#LinkType").combobox("getValue");
                            CustomLinkStruct.Content = result.content;
                            CustomLinkStruct.DbType = result.DataSource;
                            content = JSON2.stringify(CustomLinkStruct);
                            $("#reportFormular").text(content);
                        }
                    }, { width: 950, height: 550 });


                   
                }
              
            },
            getUrlContent: function (url) {
                var CustomLinkStruct = {};
                CustomLinkStruct.LinkType = "CustomUrl"
                CustomLinkStruct.Content = url;
                return JSON2.stringify(CustomLinkStruct);
            },
            DeltList: function (type) {
                var selected = control[type].datagrid("getSelections");
                for (var j = 0; j < selected.length; ++j) {
                    $.each(LinkListList, function (nodeIndex, node) {
                        if (node == selected[j]) {
                            LinkListList.remove(nodeIndex);
                            return false;
                        }
                    });
                }
                LinkList.datagrid("loadData", LinkListList);
                saveChange("Reports");
            },
            clearLinkInf: function () {
                $("#linkCode").val("");
                $("#linkName").val("");
                $("#reportFormular").text("");
                control.InEditRowIndex = null;
            },
            getDesignData: function () {
                var data = "";
                if (cellData.cells[cellData.settingCells[0]]) {
                    data = cellData.cells[cellData.settingCells[0]].Data;
                } else if (cellData.LinkInfData[cellData.settingCells[0]]) {
                    data = cellData.LinkInfData[cellData.settingCells[0]].Data;
                }
                return data;
            },
            //初始化 设置信息
            initializeCellModules: function () {
                control = { ReportList: [], LinkType: "", LinkContent: "", DbType: "" };
                var data = ControlManager.getDesignData();
                $("#LinkType").combobox("setValue", "");
                control.LinkType = "";
                control.DbType = "";
                control.LinkContent = "";
                $("#reportFormular").text("");
            },
            EditLinkInf: function (index, row) {
                control.InEditRowIndex = index;
                $("#linkCode").val(row.Code);
                $("#linkName").val(row.Name);
                $("#LinkType").combobox("select", row.Type);
                $("#reportFormular").text(row.Definition);
            }
        };
        var ModuleManager = {
            Save_AllSetting: function () {
                data = JSON.stringify(cellData.cells);
                var para = { data: data };
                para = CreateParameter(ReportAuditAction.ActionType.Post, ReportAuditAction.Functions.ReportAudit, ReportAuditAction.Methods.ReportAuditDefinitionMethods.SaveAuditDefinition, para);
                DataManager.sendData(urls.AduitUrl, para, resultManager.successSave, resultManager.fail);
                ControlManager.LoadCellDatas();
                cellData.cells = {};
            },
            saveLinkContent: function () {
                var para = ModuleManager.getParam();
                if (!para) return;
                if (control.LinkType == "CustomUrl" && !para.Id) {
                    para.Definition = ControlManager.getUrlContent(para.Definition);
                }
                para = CreateParameter(ReportFormatAction.ActionType.Post, ReportFormatAction.Functions.ReportLinkAction, ReportFormatAction.Methods.ReportLinkMethods.SaveReportLink, para);
                DataManager.sendData(urls.FormatUrl, para, resultManager.successSave, resultManager.fail);

            },
            DelectLinkInf: function () {
                var para = { Ids: "" };
                var Ids = "";
                var rows = control.LinkList.datagrid("getSelections");
                if (rows.length > 0) {
                    $.each(rows, function (index, node) {
                        Ids += node.Id + ',';
                    });
                    para.Ids = Ids.substring(0, Ids.length - 1);
                    para = CreateParameter(ReportFormatAction.ActionType.Post, ReportFormatAction.Functions.ReportLinkAction, ReportFormatAction.Methods.ReportLinkMethods.DeleteReportLink, para);
                    DataManager.sendData(urls.FormatUrl, para, resultManager.successDel, resultManager.fail);
                } else {
                    alert("请先选择要删除的记录");
                }


            },
            getParam: function () {
                var para = {};
                if (control.InEditRowIndex || control.InEditRowIndex == 0) {
                    para = cellData.LinkInfData[control.InEditRowIndex];
                } else if (cellData.settingCells.length > 0) {
                    para.ReportId = cellData.report.Id;
                    para.IndexCode = cellData.settingCells[0];
                } else {
                    MessageManager.InfoMessage("请选择要附加联查的单元格");
                    return;
                }
                para.Type = control.LinkType
                para.Code = $("#linkCode").val();
                if (!para.Code) {
                    alert("联查编号不能为空");
                    return;
                }
                para.Name = $("#linkName").val();
                if (!para.Name) {
                    alert("联查名称不能为空");
                    return;
                }
                para.Definition = $("#reportFormular").text();
                if (!para.Definition) {
                    alert("联查内容不能为空");
                    return;
                }
                return para;
            },
            getChange: function (Module, item) {
                var result;
                switch (Module) {
                    case "ReportJoin":
                        if (item == "Reports") { result = LinkListList; }
                        break;
                    case "CustomerJoin":
                        if (item == "Content") {
                            result = control.LinkContent;
                        } else if (item == "LinkType") {
                            result = control.LinkType;
                        } else if (item == "DbType") {
                            result = control.DbType;
                        }
                        break;
                }
                return result;
            }
        }
        var resultManager = {
            successSave: function (data) {
                if (data.success) {
                    if (!control.InEditRowIndex && control.InEditRowIndex != 0) {
                        cellData.LinkInfData.splice(0, 0, data.obj);
                    } else {
                        cellData.LinkInfData[control.InEditRowIndex] = data.obj;
                    }
                    control.LinkList.datagrid("loadData", cellData.LinkInfData);
                    control.LinkList.datagrid("unselectAll");
                    ControlManager.clearLinkInf();
                    MessageManager.InfoMessage(data.sMeg);
                } else {
                    alert(data.sMeg);
                }
            },
            successDel: function (data) {
                if (data.success) {
                    var rows = control.LinkList.datagrid("getSelections");
                    $.each(rows, function (index, node) {
                        var listIndex = control.LinkList.datagrid("getRowIndex", node);
                        if (listIndex || listIndex == 0) {
                            cellData.LinkInfData.splice(listIndex, 1);
                            control.LinkList.datagrid("loadData", cellData.LinkInfData);
                        } else {
                            alert("未找到记录：" + JSON2.stringify(node));
                        }
                    });
                    control.LinkList.datagrid("unselectAll");
                    ControlManager.clearLinkInf();
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
                        Grid1.attachEvent("RowColChange", cellManager.RowColChange_Event);
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
            success_LoadLinkInf: function (data) {
                if (data.success) {
                    cellData.LinkInfData = data.obj;
                    control.LinkList.datagrid("loadData", data.obj);
                } else {
                    alert(data.sMeg);
                }
            }
        };
        
        function saveChange(item) {
            var type = $("#LinkType").combobox("getValue");
            var Module = LinkTypeObj[type];
            DesignData[Module][item] = ModuleManager.getChange(Module, item);
            cellManager.GeneralLoadCellDataValue();
            $.each(cellData.settingCells, function (code, node) {
                cellData.cells[node] = { Data: JSON.stringify(DesignData), ReportId: cellData.report.Id, IndexCode: node };
            });
        }
    </script>
    <style type="text/css">
        .linkBtn
        {
            width:110px;
            height:25px;
            background:#E0ECFF
            }
    </style>
</head>
<body style=" overflow:hidden" class="easyui-layout">
    <div data-options="region:'center',title:'表格部分',split:false,tools:[{
                iconCls: 'icon-save',
                handler: ModuleManager.Save_AllSetting
            }]">
	    <OBJECT CLASSID = "clsid:5220cb21-c88d-11cf-b347-00aa00a28331" VIEWASTEXT>
            <PARAM NAME="LPKPath" VALUE="../../lpk/flexCell.LPK">
        </OBJECT> 
        <OBJECT TYPE="application/x-itst-activex"  ID="Grid1" Width=100% Height=96%    CLASSID="clsid:4331220A-1077-4630-BEE3-0D7142D6ABD0" >
            <PARAM NAME="_ExtentX" VALUE="0">
            <PARAM NAME="_ExtentY" VALUE="0">       
        </OBJECT>
	</div>
     <div data-options="region:'east',split:true,collapsible:false"  style="width:450px; overflow-x:hidden">
         <div class="easyui-layout" fit="true">
            <div data-options="region:'north',border:false" style="height:370px">
                <div id="tt">
                    <table style=" font-size:12px;width:350px;margin:10px auto; text-align:right" cellspacing="8px">
                        <tr><td>联查编号</td><td><input id="linkCode" class="easyui-validatebox textbox" style="width:230px"/></td></tr>
                        <tr><td>联查名称</td><td><input id="linkName"class="easyui-validatebox textbox" style="width:230px"/></td></tr>
                        <tr><td>联查方式</td>
                            <td><input id="LinkType" class="easyui-combobox" value="ReportJoin" style="width:236px" data-options="panelHeight:'auto'"/></td></tr>
                        <tr id="linkTextTr"><td><span id="linkSpan">报表联查</span></td><td>
                                <a class="easyui-linkbutton linkBtn" style="width:233px;" onclick="ControlManager.ShowFormularParamDialog()"><span id="btnSpan">编辑联查报表</span></a>
                        </td></tr>
                        <tr><td>联查内容</td>
                            <td>
                            <textarea id="reportFormular" cols="" rows="" style="border:1px solid  #99aaff;width:232px;height:130px" ></textarea>
                            </td>
                        </tr>
                        <tr><td></td><td>
                            <a class="easyui-linkbutton linkBtn" onclick="ModuleManager.saveLinkContent()" iconcls="icon-save" style="margin-left:10px;">保存联查内容</a></td>
                        </tr>
                    </table>
                </div>
            </div>
            <div data-options = "region:'center'" style="border-bottom:0px;border-left:0px;border-right:0px;">
                <div id="toolbar" style="display:none">
                    <div style="width:110px;">
                        <a class="easyui-linkbutton" style="width:100px;margin:1px" onclick="ModuleManager.DelectLinkInf()" plain="true" iconcls="icon-cut">删除选中</a>
                        <div class="datagrid-btn-separator" style="float:right"></div>
                    </div>
                </div>
                <table id="gridTable" border="false"></table>
            </div>
        </div>
    </div>
    <div id="Dialog"></div>  
</body>
</html>
