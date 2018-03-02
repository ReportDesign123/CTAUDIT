<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReportXmShow.aspx.cs" Inherits="Audit.ct.ReportData.ReportXmShow" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head >
    <title id="t_title"></title>
      <meta http-equiv="X-UA-Compatible" content="IE=10" />
     <meta http-equiv="X-UA-Compatible" content="IE=9" />
     <meta http-equiv="X-UA-Compatible" content="IE=8" />
     <meta http-equiv="X-UA-Compatible" content="IE=7" />
    <script src="../../lib/jquery/jquery-1.3.2.min.js" type="text/javascript"></script>
      <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script src="../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <script src="../../Scripts/ct/ReportData/ReportAggregation/ReportDataCell.js"type="text/javascript"></script>
    <script src="../../lib/ligerUI/js/core/base.js" type="text/javascript"></script>
    <script src="../../lib/ligerUI/js/core/inject.js" type="text/javascript"></script>
    <script src="../../lib/ligerUI/js/plugins/CT_ligerGrid.js" type="text/javascript"></script>
    <script src="../../lib/ligerUI/js/plugins/ligerLayout.js" type="text/javascript"></script>
    <script src="../../lib/ligerUI/js/plugins/ligerToolBar.js" type="text/javascript"></script>
    <link href="../../lib/ligerUI/skins/Aqua/css/ligerui-all.css" rel="stylesheet"type="text/css" />
    <link href="../../lib/ligerUI/skins/ligerui-icons.css" rel="stylesheet" type="text/css" />
    <script src="../../Scripts/Ct_Tool.js" type="text/javascript"></script>
    <script src="../../lib/Base64.js" type="text/javascript"></script>
    <script src="../../lib/json2.js" type="text/javascript"></script>
    
    <link href="../../Styles/Ct_Controls.css" rel="stylesheet" type="text/css" />
    <script src="../../Scripts/Ct_Controls.js" type="text/javascript"></script>

        <script type="text/javascript">
            var currentState = { RowColChange: true, ReportFormat: "", currentWidth: 0, controlWidth: 0, paras: {}, bbFormat: {}, bbData: {}, reportAudit: {}, currentProblemId: "", currentCellInfo: "" };
            var controls = { IndexCell: {}, InViewingCell: {} };
            var fparameter = "";
            var ReportIds = "";



            var urls = {
                reportAuditUrl: "../../handler/ReportDataHandler.ashx",
                BBUrl: "../../handler/FormatHandler.ashx"

            };
            $(function () {
                var height = $(window).height() - 360;
                $("#layout1").ligerLayout({ allowRightCollapse: true, topHeight: 25, space: 2, rightWidth: 450 });
                $("#toolBar").ligerToolBar({ items: [
                      { text: "取数", click: ActionManager.DeserializeFatchFormular, icon: 'communication' },
                     { text: "计算", id: "Caculate", click: ActionManager.DeserializeCaculateFormular, icon: 'modify' },
                     { text: "保存", click: ActionManager.SaveGrid, icon: 'save' }, { line: true },
                    {
                        text: '打印', click: function (item) {
                            Grid1.DirectPrint();
                        }, icon: 'print'
                    },
                   
                    { text: '打印预览', icon: 'prev', click: function (item) {
                        Grid1.PrintPreview(100);
                    }
                    },
                    { line: true },
                    { text: '导出Excel', icon: 'excil', click: function (item) {
                        //导出excel
                        Grid1.ExportToExcel("");
                    }
                    }
                ]
                });

                var paras = $("#parameter").val();
                if (paras) {
                    paras = Base64.decode(paras);
                    controls.parameter = JSON2.parse(paras);
                    ReportIds = controls.parameter.ReportId;
                    var parameter = { TaskId: controls.parameter.TaskId, PaperId: controls.parameter.PaperId, CompanyId: controls.parameter.CompanyId, ReportId: controls.parameter.ReportId, Year: controls.parameter.Year, Cycle: controls.parameter.Cycle };
                    parameter = CreateParameter(ReportDataAction.ActionType.Post, ReportDataAction.Functions.ReportAggregation, ReportDataAction.Methods.ReportAggregationMethods.GetReportData, parameter);
                    ActionManager.LoadBBFormat();
                    fparameter = parameter;
                    gridManager.LoadData(fparameter, urls.reportAuditUrl);
                    $(document).attr("title", "报表联查");
                }

            });
            var ActionManager = {
                DeserializeFatchFormular: function () {
                    if (!currentState.bbData.Gdq) { alert("先选择一张需要操作的报表"); return; }
                    // if (currentState.IsOrNotWriteLock == "0") { alert("报表已被锁定，无法执行操作"); return; }
                    LoadingMessage = window.showModelessDialog("../pub/Progress.htm", null, "DialogHeight:120px;DialogWidth:450px;help:no;status:no;scroll:no;");
                    var para = { Gdq: {}, BdqData: [], bdMaps: {}, rdps: {}, GdbId: "", GdbTableName: "", bdIds: {}, bdTableNames: {} };
                    para.GdbId = currentState.bbData.GdbId;
                    para.GdbTableName = currentState.bbData.GdbTableName;
                    para.rdps = ActionManager.GetReportParameter();
                    para.bdMaps = currentState.bbData.bdMaps;
                    para.bdTableNames = currentState.bbData.bdTableNames;
                    para.Gdq = currentState.bbData.Gdq;


                    //将现有的数据进行拷贝
                    $.extend(true, para.BdqData, currentState.bbData.BdqData);

                    $.each(para.Gdq, function (index, item) {
                        item.value = "";
                    });
                    $.each(para.BdqData, function (bdqIndex, bdqData) {
                        $.each(bdqData, function (rowIndex, rowData) {
                            if (rowData) {
                                $.each(rowData, function (cellCode, item) {
                                    if (cellCode != "DATA_ID")
                                        item.value = "";
                                });
                            }
                        });
                    });

                    var obj = { dataStr: "" };
                    obj.dataStr = JSON.stringify(para);
                    obj = CreateParameter(ReportDataAction.ActionType.Post, ReportDataAction.Functions.FillReport, ReportDataAction.Methods.FillReportMethods.DeserializeFatchFormular, obj);
                    DataManager.sendData(urls.reportAuditUrl, obj, ActionManager.DesrializeFatchFormular_Success, ActionManager.FailResult, true); //resultManager.FailResult,


                },
                LoadBBFormat: function () {
                    var para = { Id: "" };
                    para.Id = ReportIds;
                    para = CreateParameter(ReportFormatAction.ActionType.Post, ReportFormatAction.Functions.ReportFormatMenu, ReportFormatAction.Methods.ReportFormatMenuMethods.LoadReportFormat, para);
                    DataManager.sendData(urls.BBUrl, para, ActionManager.LoadBB_Success, ActionManager.FailResult, false);
                },
                DeserializeCaculateFormular: function () {
                    if (!currentState.bbData.Gdq) { alert("先选择一张需要操作的报表"); return; }
                    // if (currentState.IsOrNotWriteLock == "0") { alert("报表已被锁定，无法执行操作"); return; }
                    LoadingMessage = window.showModelessDialog("../pub/Progress.htm", null, "DialogHeight:120px;DialogWidth:450px;help:no;status:no;scroll:no;");
                    var para = { Gdq: {}, BdqData: [], bdMaps: {}, rdps: {}, GdbId: "", GdbTableName: "", bdIds: {}, bdTableNames: {} };
                    para.GdbId = currentState.bbData.GdbId;
                    para.GdbTableName = currentState.bbData.GdbTableName;
                    para.rdps = ActionManager.GetReportParameter();
                    para.bdMaps = currentState.bbData.bdMaps;
                    para.bdTableNames = currentState.bbData.bdTableNames;
                    para.Gdq = currentState.bbData.Gdq;
                    $.extend(true, para.BdqData, currentState.bbData.BdqData);

                    $.each(para.Gdq, function (index, item) {
                        item.value = "";
                    });
                    $.each(para.BdqData, function (bdqIndex, bdqData) {
                        $.each(bdqData, function (rowIndex, rowData) {
                            if (rowData) {
                                $.each(rowData, function (cellCode, item) {
                                    if (cellCode != "DATA_ID")
                                        item.value = "";
                                });
                            }
                        });
                    });

                    var obj = { dataStr: "" };
                    obj.dataStr = JSON.stringify(para);
                    obj = CreateParameter(ReportDataAction.ActionType.Post, ReportDataAction.Functions.FillReport, ReportDataAction.Methods.FillReportMethods.DeserializeCaculateFormular, obj);
                    DataManager.sendData(urls.reportAuditUrl, obj, ActionManager.DeserializeCaculateFormular_Success, ActionManager.FailResult, true);
                },
                SaveGrid: function () {
                    var para = { Gdq: {}, BdqData: [], bdMaps: {}, rdps: {}, GdbId: "", GdbTableName: "", bdIds: {}, bdTableNames: {} };
                    para.GdbId = currentState.bbData.GdbId;
                    para.GdbTableName = currentState.bbData.GdbTableName;
                    para.rdps = ActionManager.GetReportParameter();
                    para.bdMaps = currentState.bbData.bdMaps;
                    para.bdTableNames = currentState.bbData.bdTableNames;

                    //将现有的数据进行拷贝
                    LoadingMessage = window.showModelessDialog("../pub/Progress.htm", null, "DialogHeight:80px;DialogWidth:450px;help:no;status:no;scroll:no;");
                    $.extend(true, para.BdqData, currentState.bbData.BdqData);

                    for (var i = 0; i < Grid1.Rows; i++) {

                        for (var j = 0; j < Grid1.Cols; j++) {

                            var Cell = Grid1.Cell(i, j);

                            var tagStr = Cell.Tag;
                            if (tagStr != "") {
                                var cellConArr = tagStr.split("|");
                                var gdBdArr = cellConArr[0].split(";");
                                if (gdBdArr[0] == "1") {
                                    //固定区
                                    var cellInfo = JSON2.parse(cellConArr[2]);
                                    var row = cellInfo.CellRow;
                                    var col = cellInfo.CellCol;
                                    var cellFormat = BBData.bbData[row][col];
                                    var cellValue = gridManager.GetRowColTextByCellType(Cell.Text, cellFormat);

                                    if (cellValue != currentState.bbData.Gdq[gdBdArr[1]].value || (cellFormat.CellMacro != undefined && cellFormat.CellMacro != "")) {

                                        // currentState.bbData.Gdq[gdBdArr[1]].value = cellValue;
                                        var item = toolsManager.CreateDataItem();
                                        item.value = cellValue;
                                        item.cellDataType = cellConArr[1];
                                        item.isOrNotUpdate = "1";
                                        para.Gdq[gdBdArr[1]] = item;
                                    }
                                } else if (gdBdArr[0] == "0") {
                                    //变动区数据保存
                                    var bdTagInfo = JSON2.parse(gdBdArr[1]);
                                    
                                    var bdDataIndex = currentState.bbData.bdMaps[bdTagInfo.bdCode];
                                    var bdFormat = currentState.bbFormat.bdq.Bdqs[currentState.bbFormat.bdq.BdqMaps[bdTagInfo.bdCode]];
                                   // var bdFormat = BBData.bdq.Bdqs[BBData.bdq.BdqMaps[bdTagInfo.bdCode]];
                                    var index;
                                    var cellCode;
                                    var cellFormat;
                                    if (bdFormat.BdType == "1") {
                                        cellFormat = JSON2.parse(cellConArr[2]);
                                        cellCode = cellFormat.CellCode;

                                    } else if (bdFormat.BdType == "2") {
                                        cellFormat = JSON2.parse(cellConArr[2]);
                                        cellCode = cellFormat.CellCode;
                                    }
                                    var cellValue = gridManager.GetRowColTextByCellType(Cell.Text, cellFormat);
                                    if (currentState.bbData.BdqData[bdDataIndex][bdTagInfo.index][cellCode].value != cellValue) {
                                        //  currentState.bbData.BdqData[bdDataIndex][bdTagInfo.index][cellCode].value = cellValue;
                                        para.BdqData[bdDataIndex][bdTagInfo.index][cellCode].value = cellValue;
                                        para.BdqData[bdDataIndex][bdTagInfo.index][cellCode].isOrNotUpdate = "1";
                                    } else {
                                        delete para.BdqData[bdDataIndex][bdTagInfo.index][cellCode];
                                    }


                                }
                            }
                        }
                    }
                    var obj = { dataStr: "" };

                    obj.dataStr = JSON.stringify(para);

                    if ("1"== "1") {

                        obj = CreateParameter(ReportDataAction.ActionType.Post, ReportDataAction.Functions.FillReport, ReportDataAction.Methods.FillReportMethods.SaveReportAllDatas, obj);
                    }
                    else
                        obj = CreateParameter(ReportDataAction.ActionType.Post, ReportDataAction.Functions.FillReport, ReportDataAction.Methods.FillReportMethods.SaveReportDatas, obj);

                    DataManager.sendData(urls.reportAuditUrl, obj, ActionManager.DeserializeCaculateFormular_Success, ActionManager.FailResult, false); //resultManager.SaveReport_Success

                },

                LoadBB_Success: function (data) {
                    if (data.success) {
                        if (data && data.obj && data.obj.formatStr) {
                            currentState.ReportFormat = Base64.fromBase64(data.obj.formatStr);
                            BBData = JSON2.parse(data.obj.itemStr);
                           
                        }

                    } else {
                        alert(data.sMeg);
                    }
                },
                GetReportParameter: function () {
                    var para = { TaskId: "", PaperId: "", CompanyId: "", ReportId: "", Year: "", Cycle: "", ReportCode: "" };
                    var paras = $("#parameter").val();
                    paras = Base64.decode(paras);
                    controls.parameter = JSON2.parse(paras);
                   
                    para.TaskId = controls.parameter.TaskId;
                    para.CompanyId = controls.parameter.CompanyId;
                    para.Cycle = controls.parameter.Cycle;
                    para.Year = controls.parameter.Year;
                    para.PaperId = controls.parameter.PaperId;
                    para.ReportId = controls.parameter.ReportId;
                    para.ReportCode = currentState.bbFormat.bbCode;
                    return para;
                },
                DesrializeFatchFormular_Success: function (data) {
                    LoadingMessage.close();
                    if (data.success) {
                        gridManager.LoadData(fparameter, urls.reportAuditUrl);
                        alert(data.sMeg);
                    } else {
                        alert(data.sMeg);
                    }
                },
                DeserializeCaculateFormular_Success: function (data) {
                    LoadingMessage.close();
                    if (data.success) {
                        gridManager.LoadData(fparameter, urls.reportAuditUrl);
                        alert(data.sMeg);
                    } else {
                        alert(data.sMeg);
                    }
                },
                FailResult: function (data) {
                    alert(data.sMeg);
                    if (LoadingMessage.close()) {
                        LoadingMessage.close();
                    }
                }
            };


        </script>

</head>
 
<body style="margin:0; padding:0;overflow:hidden">
<div id="layout1">
      
    <div position="top">
     <div id="toolBar"></div>
    </div>
    <div position="center">
    <OBJECT CLASSID = "clsid:5220cb21-c88d-11cf-b347-00aa00a28331" VIEWASTEXT>
        <PARAM NAME="LPKPath" VALUE="../lpk/flexCell.LPK">
    </OBJECT> 
    <OBJECT  ID="Grid1"    CLASSID="clsid:4331220A-1077-4630-BEE3-0D7142D6ABD0" height="100%" width="100%">
        <PARAM NAME="_ExtentX" VALUE="0">
        <PARAM NAME="_ExtentY" VALUE="0">
      </OBJECT>
    </div>
    <input id="parameter" value="<%=parame %>" type="hidden"/>
</div>

</body>
</html>


