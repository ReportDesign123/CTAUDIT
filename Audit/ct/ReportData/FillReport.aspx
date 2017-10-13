<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FillReport.aspx.cs" Inherits="Audit.ct.ReportData.FillReport" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>报表填报</title>
    <meta http-equiv="X-UA-Compatible" content="IE=10" />
    <meta http-equiv="X-UA-Compatible" content="IE=9" />
    <meta http-equiv="X-UA-Compatible" content="IE=8" />
    <meta http-equiv="X-UA-Compatible" content="IE=7" />
    <script src="../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <%--<script src="../../lib/jquery/jquery-1.5.2.min.js" type="text/javascript"></script>--%>
    <script src="../../Scripts/Ct_Controls.js" type="text/javascript"></script>
    <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script src="../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <link href="../../lib/ligerUI/skins/Aqua/css/ligerui-all.css" rel="stylesheet" type="text/css" />
    <link href="../../lib/ligerUI/skins/ligerui-icons.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/Cookie/jquery.cookie.js" type="text/javascript"></script>
    <script src="../../Scripts/Cookie/Cookie.js" type="text/javascript"></script>
    <link href="../../Styles/ReportData/FillReport.css" rel="stylesheet" type="text/css" />
    <link href="../../Styles/FormatManager.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/Base64.js" type="text/javascript"></script>
    <script src="../../lib/json2.js" type="text/javascript"></script>
    <link href="../../Styles/Ct_Controls.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/ligerUI/js/core/base.js" type="text/javascript"></script>
    <script src="../../lib/ligerUI/js/core/inject.js" type="text/javascript"></script>
    <script src="../../lib/ligerUI/js/ligerui.min.js" type="text/javascript"></script>
    <script src="../../Scripts/ct/pub/PubHelp.js" type="text/javascript"></script>


    <style type="text/css">
        #topLoader {
            width: 256px;
            height: 256px;
            margin-bottom: 32px;
        }

        #container {
            width: 940px;
            padding: 10px;
            margin-left: auto;
            margin-right: auto;
        }

        #animateButton {
            width: 256px;
        }
    </style>
    <script type="text/javascript">
        function convertToIndex(n) {
            var str = "abcdefghijklmnopqrstuvwxyz";
            n = n.toLowerCase(); 
            var lastNum = n[n.length - 1];
            var index = str.indexOf(lastNum);
            var num = index;
            if (n.length>1) {
                num = 26 * (n.length - 1) + index;
            } 
            return num;
        }
        function callbackRun(callback,arg)
        { 
           top.loader&& top.loader.open();
            var  wait=function (item) {
                var dtd = $.Deferred();
                setTimeout(function(){
                    callback (arg) ;
                    dtd.resolve();
                },1000,item); 
                return dtd.promise(); // 返回promise对象  
            };
            $.when(wait(callback)).then(function () { 
                top.loader&& top.loader.close(); 
            });
        
        }
        var kb = 0;
        var totalKb = 999;
        //$(function () {
        //    //var $topLoader = $("#topLoader").percentageLoader({ width: 256, height: 256, controllable: true, progress: 0.5, onProgressUpdate: function (val) {
        //    //    $topLoader.setValue(Math.round(val * 100.0));
        //    //}
        //    //});


        //    $("#animateButton").click(function () {
        //        kb += 5;
        //        $topLoader.setProgress(kb / totalKb);
        //        $topLoader.setValue(kb.toString() + 'kb');


        //    });
        //});

        var urls = {
            fillReportUrl: "../../handler/ReportDataHandler.ashx",
            BBUrl: "../../handler/FormatHandler.ashx"
        };
        var vsBDBH;
        var centerHeight;
        var vsPublicFormula;
        var vsClose = false;
        var controls = { AuditPaperTab: {}, AuditReportTab: {}, Tree: "", Nd: "", Zq: "", InsertRow: {}, DeleteRow: {}, ReportAttatch: {}, ReportSearch: {}, clearReportSearch: {} };
        var currentState = {
            ReportState: { AuditType: { name: "", value: "" }, AuditPaper: { name: "", value: "" }, AuditDate: "", AuditTask: { name: "", value: "" }, Nd: "", Zq: "", WeekReport: { ID: "", Name: "", Ksrq: "", Jsrq: "" }, ReportType: "", auditPaperVisible: "1", auditZqVisible: "1" },
            navigatorData: { auditReports: [], currentReportId: "", currentReportName: "" },
            RowColChange: true, BdqBh: "", ReportFormat: "", ReportCalcuFormat: "", CompanyId: "", BdqDataMaps: {}, IsOrNotWriteLock: "", IsOrNotCheckLock: false, TabDatas: []
        };
        var auditPaperTabAutoLoadFlag = false;
        var auditReportTabAutoLoadFlag = false;
        var companyLoadFlag = false;
        var zqLoadFlag = false;

        var cellTextNotChangeSetCellType = false;
        var CellTag = "1;00010002;0001|01|{单元格基本信息}"; //第一位是指是否为固定区（1：固定区；0为变动区；）；第二位为当前单元格编号；第三位是指如果为变动区，则为变动区编号；01代表文本字符;下一位代表单元格基本信息（向前兼容）
        var ItemDataValue = { value: "", cellDataType: "", isOrNotUpdate: "0" };

        var BBData = { bbCode: "", bbName: "", bbData: {}, bdq: { bdNum: 0, BdRowNum: 0, BdColNum: 0, BdqMaps: {}, Bdqs: [] }, bbRows: "", bbCols: "", zq: "", MergeCells: [] };
        var BBDataItems = {}; //报表数据

        var bdCodeCountMaps = {};
        var InfoIframControl = { InfData: [], Collapse: true, Created: false, LinkInfData: [], cellCode: "" };




        var EventManager = {
            imageFlag: "up",
            imgFooter_ToggleEvent: function () {
                if (EventManager.imageFlag == "up") {
                    EventManager.imageFlag = "down";
                    $("#footer").css("height", 120);
                    $("#content").css("height", centerHeight - 240);
                    $("#cframe").css("height", centerHeight - 240);
                    $("#imgFooter").attr("src", "../../Styles/images/icon-down.gif");
                } else if (EventManager.imageFlag == "down") {
                    EventManager.imageFlag = "up";
                    $("#footer").css("height", 20);
                    $("#content").css("height", centerHeight - 40);
                    $("#cframe").css("height", centerHeight - 40);
                    $("#imgFooter").attr("src", "../../Styles/images/icon-up.gif");
                }
            },
            BdqLoadAllData_Click: function () {
                var bdqCode = currentState.BdqBh;
                currentState.BdqDataMaps[bdqCode].isOrNotLoadAll = "1";

                mediatorManager.RefreshReport();
            },
            ReportSearch: function () {

                var filter = gridFrame.Grid1.rowFilter(),
                text = $("#txtSearch").val(),
                 col = gridFrame.Grid1.getActiveColumnIndex();
                if (col < 0) {
                    alert("请选择要过滤的列！");
                    return;
                }
                if (filter && text) {
                    filter.removeFilterItems(col);

                    filter.addTextFilter(col, 6, text);

                    filter.filter(col);
                    gridFrame.Grid1.invalidateLayout();
                    gridFrame.Grid1.repaint();
                }
            },
            clearReportSearch: function () {
                var gridIframe = toolsManager.GetGridIframe();

                gridIframe.ClearFilter();
            },
            InitializeBtn: function () {
                $("#imgFooter").bind("click", EventManager.imgFooter_ToggleEvent);
                $("#taskBtn").bind("click", EventManager.taskBtn_ClickEvent);
                controls.InsertRow = $("#InsertRowBtn").Btn({ text: "插入行(列)", click: EventManager.InsertMultiRows, icon: "InsertRow" });
                controls.DeleteRow = $("#DeleteRowBtn").Btn({ text: "删除行（列）", click: EventManager.DeleteRowCol_Click, icon: "DeleteRow" });
                controls.ReportAttatch = $("#ReportAttatch").Btn({ text: "上传附件", click: EventManager.ReportAttatch_Upload, icon: "Attatch" });


                controls.ReportSearch = $("#ReportSearch").Btn({ text: "过滤", click: EventManager.ReportSearch, icon: "Attatch" });
                controls.clearReportSearch = $("#clearReportSearch").Btn({ text: "取消过滤", click: EventManager.clearReportSearch, icon: "Attatch" });

            },
            InsertMultiRows: function () {
                var result = window.showModalDialog("NewRowCol.aspx", null, "dialogHeight:130px;dialogWidth:260px;scroll:no");
                if (result && result.RowCol) {
                    var gridFrame = toolsManager.GetGridIframe();
                    // gridFrame.Grid1.addRows(row, result.RowCol);
                    for (var i = 0; i < result.RowCol; i++) {
                        EventManager.InsertRowCol_Click();
                    }

                    gridFrame.Grid1.setRowCount(gridFrame.Grid1.getRowCount());
                }
            },
            ///删除报表数据
            ///参数：parametere{ReportId:""}
            ///张双义
            ReportData_delet: function (parameter) {
                var para = toolsManager.GetReportParameter();
                if (parameter && parameter.ReportId) {
                    para.ReportId = parameter.ReportId;
                }
                para = CreateParameter(ReportDataAction.ActionType.Post, ReportDataAction.Functions.FillReport, ReportDataAction.Methods.FillReportMethods.ClearReportData, para);
                DataManager.sendData(urls.fillReportUrl, para, resultManager.DeleteReport_Success, resultManager.FailResult);
                mediatorManager.RefreshHome();
            },
            ReportAttatch_Upload: function (parameter) {
                var para = toolsManager.GetReportParameter();
                if (parameter && parameter.ReportId) {
                    para.ReportId = parameter.ReportId;
                }
                // "UploadAttatch.aspx?TaskId=" + para.TaskId + "&PaperId=" + para.PaperId + "&ReportId=" + para.ReportId + "&CompanyId=" + para.CompanyId + "&Nd=" + para.Year + "&Zq="+para.Cycle
                window.showModalDialog("UploadMiddle.aspx?TaskId=" + para.TaskId + "&PaperId=" + para.PaperId + "&ReportId=" + para.ReportId + "&CompanyId=" + para.CompanyId + "&Nd=" + para.Year + "&Zq=" + para.Cycle, para, "dialogHeight:550px;dialogWidth:600px;");
            },
            InsertRowCol_Click: function () {
                var index = BBData.bdq.BdqMaps[currentState.BdqBh];
                var bdqFormat = BBData.bdq.Bdqs[index];
                var gridFrame = toolsManager.GetGridIframe();
                var bdqCode = bdqFormat.Code;
                var gridFrame = toolsManager.GetGridIframe();
                if (bdqFormat.BdType == "1") {
                    if (gridFrame.GridManager.GetCurrentRow() == gridFrame.Grid1.getRowCount()) { alert("表格行数需要比插入行数多一行！"); return; };
                    var currentRow = gridFrame.GridManager.GetCurrentRow();
                    var currentBdRows = CaculateArrayLengthFilterUndefined(BBDataItems.BdqData[BBDataItems.bdMaps[bdqCode]]);
                    var bdRowInfo = toolsManager.GetRowTagBdqInfo(currentRow);
                    var currentIndex = toolsManager.GetArrayCountBeforeCurrentIndex(BBDataItems.BdqData[BBDataItems.bdMaps[bdqCode]], bdRowInfo.index);
                    var row = currentBdRows - currentIndex + currentRow;

                    //                
                    var columnCount = gridFrame.Grid1.getColumnCount();

                    gridFrame.Grid1.isPaintSuspended(true);
                    //                 
                    //                 gridFrame.Grid1.suspendCalcService(); 

                    gridFrame.Grid1.addRows(row, 1);
                    gridFrame.Grid1._vpCalcSheetModel.dataTable[row] = undefined;

                    //  
                    //              gridFrame.Grid1.setRowCount(gridFrame.Grid1.getRowCount());
                    //                 gridFrame.Grid1.copyTo(row-1, -1, row, -1, 1, columnCount, gridFrame.GcSpread.Sheets.CopyToOption.All);
                    // gridFrame.Grid1.refresh()

                    //                 gridFrame.Grid1.isPaintSuspended(false);
                    //                 gridFrame.Grid1.resumeCalcService();


                    //                 gridFrame.Grid1.isPaintSuspended(true);
                    // var columnCount = gridFrame.Grid1.getColumnCount();

                    gridFrame.Grid1.getCells(row, 0, row, columnCount).backColor("#FF99CC");

                    var option = { all: true };
                    var lineBorder = new gridFrame.spreadNS.LineBorder("#000000", gridFrame.spreadNS.LineStyle.thin);

                    var vsRange = new gridFrame.spreadNS.Range(row, 0, row, columnCount);
                    gridFrame.Grid1.setBorder(vsRange, lineBorder, option);

                    for (var i = 0; i < columnCount; i++) {
                        gridFrame.Grid1.getCell(row, i).locked(false);
                        if (gridFrame.Grid1.getCell(row - 1, i).formula()) {
                            gridFrame.Grid1.setFormula(parseInt(row), i, gridFrame.Grid1.getCell(row - 1, i).formula().replace(/\d+/g, (row + 1).toString()));
                        }

                    }
                    var rowData = { DATA_ID: { value: "", cellDataType: "01", isOrNotUpdate: "0" } };
                    $.each(BBData.bbData[bdqFormat.Offset], function (colIndex, cell) {
                        if (cell["CellCode"]) {
                            var cellCode = cell["CellCode"];
                            var bdCellInfo = toolsManager.GetCellTagBdqInfo(row - 1, colIndex);
                            CellTag = "0;" + JSON2.stringify({ CellCode: cellCode, bdCode: bdqCode, index: toolsManager.GetMaxCountArray(BBDataItems.BdqData[BBDataItems.bdMaps[bdqCode]]) + 1 }) + "|" + cell.CellDataType + "|" + JSON2.stringify(cell);
                            //gridFrame.Grid1.Cell(row, colIndex).Tag = CellTag;
                            gridFrame.Grid1.setTag(row, colIndex, CellTag);

                            var item = toolsManager.CreateDataItem();
                            item.value = "";
                            item.cellDataType = cell.CellDataType;
                            item.isOrNotUpdate = "0";
                            rowData[cell.CellCode] = item;
                        }
                    }
                    );
                    gridFrame.Grid1.isPaintSuspended(false);

                    BBDataItems.BdqData[BBDataItems.bdMaps[bdqCode]].push(rowData);
                } else if (bdqFormat.BdType == "2") {
                    if (gridFrame.GridManager.GetCurrentCol() == gridFrame.Grid1.Cols - 1) { alert("表格列数需要比插入列数多一列！"); return; }
                    var col = gridFrame.GridManager.GetCurrentCol() + 1;
                    gridFrame.Grid1.InsertCol(col, 1);
                    gridFrame.Grid1.Range(1, col, gridIframe.Grid1.Rows - 1, col).BackColor = toolsManager.CovertColorStr("#FF99CC");
                    var colData = { DATA_ID: { value: "", cellDataType: "01", isOrNotUpdate: "0" } };
                    $.each(BBData.bbData, function (rowIndex, rowData) {
                        if (rowData[bdqFormat.Offset]) {
                            var cell = rowData[bdqFormat.Offset];
                            if (cell["CellCode"]) {
                                var cellCode = cell["CellCode"];
                                var bdCellTagInfo = toolsManager.GetCellTagBdqInfo(rowIndex, col - 1);
                                CellTag = "0;" + JSON2.stringify({ CellCode: cellCode, bdCode: bdqCode, index: bdCellTagInfo.index + 1 }) + "|" + cell.CellDataType + "|" + JSON2.stringify(cell);
                                gridFrame.Grid1.Cell(rowIndex, col).Tag = CellTag;

                                var item = toolsManager.CreateDataItem();
                                item.value = "";
                                item.cellDataType = cell.CellDataType;
                                item.isOrNotUpdate = "0";
                                colData[cell.CellCode] = item;
                            }
                        }
                    });
                    BBDataItems.BdqData[BBDataItems.bdMaps[bdqCode]].push(colData);
                }
            },
            DeleteRowCol_Click: function () {
                var index = BBData.bdq.BdqMaps[currentState.BdqBh];
                var bdqFormat = BBData.bdq.Bdqs[index];
                var gridFrame = toolsManager.GetGridIframe();
                var bdqCode = bdqFormat.Code;
                if (bdqFormat.BdType == "1") {
                    var row = gridFrame.GridManager.GetCurrentRow();
                    if (row == bdqFormat.Offset) { alert("此行不能够删除"); return; };
                    var bdFlag = false;
                    for (var i = 0; i < gridFrame.Grid1.getColumnCount() ; i++) {
                        var tag = gridFrame.Grid1.getTag(row, i); // gridFrame.Grid1.Cell(row, i).Tag;
                        if (tag != "") {
                            if (tag.substr(0, 1) == "0") {
                                bdFlag = true; break;
                            }
                        }
                    }
                    if (!bdFlag) { alert("此行不是变动行，不能够删除"); return; };
                    var colNum = gridFrame.Grid1.getColumnCount(); // gridFrame.Grid1.Cols;
                    var col;
                    for (var i = 0; i < colNum; i++) {
                        var cellTag = gridFrame.Grid1.getTag(row, i); // gridFrame.Grid1.Cell(row, i).Tag;
                        if (cellTag != "") { col = i; break; }
                    }
                    var bdInfo = toolsManager.GetCellTagBdqInfo(row, col);
                    //需修改
                    gridFrame.Grid1.deleteRows(row, 1);

                    var dataId = BBDataItems.BdqData[index][bdInfo.index]["DATA_ID"];
                    if (dataId.value == "") {
                        delete BBDataItems.BdqData[index][bdInfo.index];
                    } else {
                        var para = { Id: "", TableName: "" };
                        para.Id = dataId.value;
                        para.TableName = BBDataItems.bdTableNames[bdqCode];


                        para = CreateParameter(ReportDataAction.ActionType.Post, ReportDataAction.Functions.FillReport, ReportDataAction.Methods.FillReportMethods.DeleteBdqData, para);
                        DataManager.sendData(urls.fillReportUrl, para, resultManager.DeleteReport_Success, resultManager.FailResult, false);
                        delete BBDataItems.BdqData[index][bdInfo.index];
                    }

                } else if (bdqFormat.BdType == "2") {
                    var col = gridFrame.GridManager.GetCurrentCol();
                    if (col == bdqFormat.Offset) { alert("此列不能够删除"); return; };
                    var bdFlag = false;
                    for (var i = 0; i < gridFrame.Grid1.getRowCount() ; i++) {
                        var tag = gridFrame.Grid1.getTag(i, col); // gridFrame.Grid1.Cell(i, col).Tag;
                        if (tag != "") {
                            if (tag.substr(0, 1) == "0") {
                                bdFlag = true; break;
                            }
                        }
                    }
                    if (!bdFlag) { alert("此列不是变动列，不能够删除"); return; };
                    var rowNum = gridFrame.Grid1.getRowCount(); // gridFrame.Grid1.Rows;

                    var row;
                    for (var i = 0; i < rowNum; i++) {
                        var cellTag = gridFrame.Grid1.getTag(i, j); // gridFrame.Grid1.Cell(i, col).Tag;
                        if (cellTag != "") { row = i; break; }
                    }
                    var bdInfo = toolsManager.GetCellTagBdqInfo(row, col);
                    //需修改
                    gridFrame.Grid1.Range(1, col, rowNum - 1, col).DeleteByCol();

                    var dataId = BBDataItems.BdqData[index][bdInfo.index]["DATA_ID"];
                    if (dataId.value == "") {
                        delete BBDataItems.BdqData[index][bdInfo.index];
                    } else {
                        var para = { Id: "", TableName: "" };
                        para.Id = dataId.value;
                        para.TableName = BBDataItems.bdTableNames[bdqCode];


                        para = CreateParameter(ReportDataAction.ActionType.Post, ReportDataAction.Functions.FillReport, ReportDataAction.Methods.FillReportMethods.DeleteBdqData, para);
                        DataManager.sendData(urls.fillReportUrl, para, resultManager.DeleteReport_Success, resultManager.FailResult, false);
                        delete BBDataItems.BdqData[index][bdInfo.index];
                    }

                }

            },
            taskBtn_ClickEvent: function () {
                currentState.ReportState["auditPaperVisible"] = "1";
                currentState.ReportState["auditZqVisible"] = "1";
                var result = window.showModalDialog("ChooseAuditTask.aspx", currentState.ReportState, "dialogHeight:500px;dialogWidth:450px;scroll:no");
                if (result && result != undefined) {
                    if (result.auditZqType == "05") {
                        if (result.WeekReport.ID == "") {
                            alert("请定义周报周期");
                            var curTabTitle = "资料填报";
                            var t = parent.centerTabs.tabs('getTab', curTabTitle);
                            if (t.panel('options').closable) {
                                parent.centerTabs.tabs('close', curTabTitle);
                                return;
                            }
                        }
                    }
                    toolsManager.SetAuditTask(result);
                }

            },
            TabEvents: {
                AuditPaperTab_Selected: function (tabId) {
                    if (auditPaperTabAutoLoadFlag) return;
                    tabManager.RemoveReports(currentState.currentPaperTabid);
                    currentState.currentPaperTabid = tabId;

                    tabManager.LoadReports(currentState.currentPaperTabid);

                },
                AuditReportTab_Selected: function (tabId) {
                    currentState.navigatorData.currentReportId = tabId;
                    if (tabId == "home") {
                        $("#InfoIframe").css("display", "none");
                        tabManager.InitializeCatalog();

                    } else {
                        if ($("#catalog").css("display") != "none") {
                            $("#catalog").css("display", "none");
                            $("#report").css("display", "block");
                            $("#InfoIframe").css("display", "block");
                        }
                        if (!InfoIframControl.Collapse) {
                            tabManager.CheckOutInfManager.getDataById();
                            InfoIframControl.LinkInfData = [];
                            InfoIframControl.cellCode = "";
                            tabManager.LinkManager.setLinkInf([]);
                        } else {
                            var height = document.body.clientHeight;
                            $("#content").css("height", height - 80);
                        }
                        currentState.BdqBh = "";
                        currentState.BdqDataMaps = {};
                        callbackRun(function () {
                            mediatorManager.LoadBBFormat();
                            //mediatorManager.LoadBBCompFormat();
                            mediatorManager.LoadBbData();

                        });
                      

                       
                            //mediatorManager.LoadBBFormat();
                            //mediatorManager.LoadBBCompFormat();
                            //mediatorManager.LoadBbData();

                        

                       
                    }

                },
                ///Tab页面关闭事件
                ///用途：切换的上一个页面,删除tabDatas中相应的报表
                ///张双义
                AuditReportTab_Clossed: function (tabId) {
                    $.each(currentState.TabDatas, function (index, reportTab) {
                        if (reportTab.Id == tabId) {
                            currentState.TabDatas.remove(reportTab);
                            return false;
                        }
                    });
                    mediatorManager.RemoveReportReadWriteLock();
                    var tabs = controls.AuditReportTab.getTabidList();
                    var selected = controls.AuditReportTab.getSelectedTabItemID();
                    if (selected != "home" || tabs.length == 1) {
                        EventManager.TabEvents.AuditReportTab_Selected(selected);
                    }
                }
            },
            MenuManager: {
                SaveGrid: function () {
                    var para = { Gdq: {}, BdqData: [], bdMaps: {}, rdps: {}, GdbId: "", GdbTableName: "", bdIds: {}, bdTableNames: {} };
                    para.GdbId = BBDataItems.GdbId;
                    para.GdbTableName = BBDataItems.GdbTableName;
                    para.rdps = toolsManager.GetReportParameter();
                    para.bdMaps = BBDataItems.bdMaps;
                    para.bdTableNames = BBDataItems.bdTableNames;
                    var gridIframe = toolsManager.GetGridIframe();
                    //var dirtyCells = gridFrame.Grid1.getDirtyCells(); //所有改变的单元格
                    var vsFuals = "";
                    //将现有的数据进行拷贝
                    gridFrame.Grid1.endEdit();
                    gridFrame.Grid1.isPaintSuspended(true);
                    gridFrame.Grid1.setActiveCell(-1, -1);
                    $.extend(true, para.BdqData, BBDataItems.BdqData);
                    for (var i = 0; i < gridFrame.Grid1.getRowCount() ; i++) {

                        for (var j = 0; j < gridFrame.Grid1.getColumnCount() ; j++) {

                            var Cell = gridFrame.Grid1.getCell(i, j);
                            var vFormula = gridFrame.Grid1.getFormula(i, j);
                            if (vFormula) {
                                vsFuals += i + "$" + j + "$" + vFormula + ",";
                            }
                            var tagStr = gridFrame.Grid1.getTag(i, j); // Cell.Tag;
                            if (tagStr && tagStr != "") {
                                var cellConArr = tagStr.split("|");
                                var gdBdArr = cellConArr[0].split(";");
                                if (gdBdArr[0] == "1") {
                                    //固定区
                                    var cellInfo = JSON2.parse(cellConArr[2]);
                                    var row = cellInfo.CellRow;
                                    var col = cellInfo.CellCol;
                                    var cellFormat = BBData.bbData[row][col];
                                    var cellValue = gridFrame.GridManager.GetRowColTextByCellType(Cell.value(), cellFormat);

                                    if (cellValue != BBDataItems.Gdq[gdBdArr[1]].value || (cellFormat.CellMacro != undefined && cellFormat.CellMacro != "")) {

                                        // BBDataItems.Gdq[gdBdArr[1]].value = cellValue;
                                        var item = toolsManager.CreateDataItem();
                                        item.value = cellValue;
                                        item.cellDataType = cellConArr[1];
                                        item.isOrNotUpdate = "1";
                                        para.Gdq[gdBdArr[1]] = item;
                                    }
                                } else if (gdBdArr[0] == "0") {
                                    //变动区数据保存
                                    var bdTagInfo = JSON2.parse(gdBdArr[1]);
                                    var bdDataIndex = BBDataItems.bdMaps[bdTagInfo.bdCode];
                                    var bdFormat = BBData.bdq.Bdqs[BBData.bdq.BdqMaps[bdTagInfo.bdCode]];
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
                                    try {
                                        var cellValue = gridFrame.GridManager.GetRowColTextByCellType(Cell.value(), cellFormat);

                                        if (BBDataItems.BdqData[bdDataIndex][bdTagInfo.index][cellCode].value != cellValue) {

                                            para.BdqData[bdDataIndex][bdTagInfo.index][cellCode].value = cellValue;
                                            para.BdqData[bdDataIndex][bdTagInfo.index][cellCode].isOrNotUpdate = "1";
                                        } else {
                                            delete para.BdqData[bdDataIndex][bdTagInfo.index][cellCode];
                                        }
                                    } catch (e) {
                                        alert(bdDataIndex); alert(bdTagInfo.index); alert(cellCode);
                                    }


                                }
                            }
                        }
                    }
                    if (vsFuals.length > 0) {
                        vsFuals = vsFuals.substring(0, vsFuals.length - 1);
                    }
                    gridFrame.Grid1.isPaintSuspended(false);
                    var obj = { dataStr: "", BBID: "", formulaStr: "" };

                    obj.dataStr = JSON.stringify(para);
                    obj.BBID = currentState.navigatorData.currentReportId;

                    obj.formulaStr = vsFuals; // JSON.stringify(gridIframe.Grid1.toJSON({ includeBindingSource: false })); // JSON.stringify(gridIframe.Grid1.toJSON())

                    currentState.ReportCalcuFormat = obj.formulaStr;
                    obj = CreateParameter(ReportDataAction.ActionType.Post, ReportDataAction.Functions.FillReport, ReportDataAction.Methods.FillReportMethods.SaveReportDatas, obj);
                    DataManager.sendData(urls.fillReportUrl, obj, resultManager.SaveReport_Success, resultManager.FailResult, false);

                },
                LockCell: function () {
                    var para = { Gdq: {}, BdqData: [], bdMaps: {}, rdps: {}, GdbId: "", GdbTableName: "", bdIds: {}, bdTableNames: {} };
                    para.GdbId = BBDataItems.GdbId;
                    para.GdbTableName = BBDataItems.GdbTableName;
                    para.rdps = toolsManager.GetReportParameter();
                    para.bdMaps = BBDataItems.bdMaps;
                    para.bdTableNames = BBDataItems.bdTableNames;
                    var gridIframe = toolsManager.GetGridIframe();
                    //锁定单元格
                    gridIframe.Grid1.getCell(gridIframe.Grid1.getActiveRowIndex(), gridIframe.Grid1.getActiveColumnIndex()).locked(true);
                    gridIframe.Grid1.getCell(gridIframe.Grid1.getActiveRowIndex(), gridIframe.Grid1.getActiveColumnIndex()).backColor("#FF99CC");


                },
                UnLockCell: function () {
                    var gridIframe = toolsManager.GetGridIframe();
                    //锁定单元格
                    gridIframe.Grid1.getCell(gridIframe.Grid1.getActiveRowIndex(), gridIframe.Grid1.getActiveColumnIndex()).locked(false);
                    gridIframe.Grid1.getCell(gridIframe.Grid1.getActiveRowIndex(), gridIframe.Grid1.getActiveColumnIndex()).backColor(undefined);

                },

                DeserializeFatchFormular: function () {
                    if (!BBDataItems.Gdq) { alert("先选择一张需要操作的报表"); return; }
                    if (currentState.IsOrNotWriteLock == "0") { alert("报表已被锁定，无法执行操作"); return; }
                    //   top.loader && top.loader.open();
                    callbackRun(function (BBDataItems) {
                        var para = { Gdq: {}, BdqData: [], bdMaps: {}, rdps: {}, GdbId: "", GdbTableName: "", bdIds: {}, bdTableNames: {} };
                        para.GdbId = BBDataItems.GdbId;
                        para.GdbTableName = BBDataItems.GdbTableName;
                        para.rdps = toolsManager.GetReportParameter();
                        para.bdMaps = BBDataItems.bdMaps;
                        para.bdTableNames = BBDataItems.bdTableNames;
                        para.Gdq = BBDataItems.Gdq;

                        var gridIframe = toolsManager.GetGridIframe();
                        //将现有的数据进行拷贝
                        $.extend(true, para.BdqData, BBDataItems.BdqData);

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
                        DataManager.sendData(urls.fillReportUrl, obj, resultManager.DesrializeFatchFormular_Success, resultManager.FailResult, false);

                    },BBDataItems);

                    //var para = { Gdq: {}, BdqData: [], bdMaps: {}, rdps: {}, GdbId: "", GdbTableName: "", bdIds: {}, bdTableNames: {} };
                    //para.GdbId = BBDataItems.GdbId;
                    //para.GdbTableName = BBDataItems.GdbTableName;
                    //para.rdps = toolsManager.GetReportParameter();
                    //para.bdMaps = BBDataItems.bdMaps;
                    //para.bdTableNames = BBDataItems.bdTableNames;
                    //para.Gdq = BBDataItems.Gdq;

                    //var gridIframe = toolsManager.GetGridIframe();
                    ////将现有的数据进行拷贝
                    //$.extend(true, para.BdqData, BBDataItems.BdqData);

                    //$.each(para.Gdq, function (index, item) {
                    //    item.value = "";
                    //});
                    //$.each(para.BdqData, function (bdqIndex, bdqData) {
                    //    $.each(bdqData, function (rowIndex, rowData) {
                    //        if (rowData) {
                    //            $.each(rowData, function (cellCode, item) {
                    //                if (cellCode != "DATA_ID")
                    //                    item.value = "";
                    //            });
                    //        }
                    //    });
                    //});

                    //var obj = { dataStr: "" };
                    //obj.dataStr = JSON.stringify(para);
                    //obj = CreateParameter(ReportDataAction.ActionType.Post, ReportDataAction.Functions.FillReport, ReportDataAction.Methods.FillReportMethods.DeserializeFatchFormular, obj);
                    //DataManager.sendData(urls.fillReportUrl, obj, resultManager.DesrializeFatchFormular_Success, resultManager.FailResult, true);

                },
                DeserializeCaculateFormular: function () {

                    if (!BBDataItems.Gdq) { alert("先选择一张需要操作的报表"); return; }
                    if (currentState.IsOrNotWriteLock == "0") { alert("报表已被锁定，无法执行操作"); return; }

                    if (currentState.ReportCalcuFormat && currentState.ReportCalcuFormat != "") {
                        var vCalcFormatData = JSON.parse(currentState.ReportCalcuFormat);
                        gridFrame.Grid1.isPaintSuspended(true);
                        $.each(vCalcFormatData.data.dataTable, function (rowIndex, row) {
                            $.each(row, function (colIndex, cell) {
                                if (cell.formula) {

                                    gridFrame.Grid1.getCell(rowIndex, colIndex).text(null);
                                    gridFrame.Grid1.setValue(rowIndex, colIndex, null);
                                    gridFrame.Grid1.setFormula(rowIndex, colIndex, null);
                                    // gridFrame.Grid1.setFormula(rowIndex, colIndex, cell.formula);
                                    //  gridFrame.Grid1.getCell(rowIndex, colIndex).formula("=MAX(A3:A6)"); //+cell.formula

                                }
                            });
                        });


                        gridFrame.Grid1.isPaintSuspended(false);
                        //gridFrame.spread.refresh();

                    }
                    /*  var obj = { dataStr: "" };
                    obj.dataStr = JSON.stringify(para);
                    obj = CreateParameter(ReportDataAction.ActionType.Post, ReportDataAction.Functions.FillReport, ReportDataAction.Methods.FillReportMethods.DeserializeCaculateFormular, obj);
                    DataManager.sendData(urls.fillReportUrl, obj, resultManager.DeserializeCaculateFormular_Success, resultManager.FailResult, true);*/
                },
                DeserializeVarifyFormular: function () {
                    if (!BBDataItems.Gdq) { alert("先选择一张需要操作的报表"); return; }
                    //if (currentState.IsOrNotWriteLock == "0") { alert("报表已被锁定，无法执行操作"); return; }
                    //  top.loader && top.loader.open();


                    var para = { Gdq: {}, BdqData: [], bdMaps: {}, rdps: {}, GdbId: "", GdbTableName: "", bdIds: {}, bdTableNames: {} };
                    para.GdbId = BBDataItems.GdbId;
                    para.GdbTableName = BBDataItems.GdbTableName;
                    para.rdps = toolsManager.GetReportParameter();
                    para.bdMaps = BBDataItems.bdMaps;
                    para.bdTableNames = BBDataItems.bdTableNames;
                    para.Gdq = BBDataItems.Gdq;

                    var gridIframe = toolsManager.GetGridIframe();
                    //将现有的数据进行拷贝
                    $.extend(true, para.BdqData, BBDataItems.BdqData);

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
                    obj = CreateParameter(ReportDataAction.ActionType.Post, ReportDataAction.Functions.FillReport, ReportDataAction.Methods.FillReportMethods.DeserializeVarifyFormular, obj);
                    DataManager.sendData(urls.fillReportUrl, obj, resultManager.DeserializeVerifyFormular_Success, resultManager.FailResult, false);
                },
                SelfCheck: function () {
                    var para = { TaskId: "", PaperId: "", CompanyId: "", ReportId: "", Year: "", Cycle: "" };
                    para.TaskId = currentState.ReportState.AuditTask.value;
                    para.CompanyId = currentState.CompanyId;
                    para.Cycle = currentState.ReportState.Zq;
                    para.Year = currentState.ReportState.Nd;
                    para.PaperId = currentState.ReportState.AuditPaper.value;
                    para.ReportId = currentState.navigatorData.currentReportId;
                    para = CreateParameter(ReportDataAction.ActionType.Post, ReportDataAction.Functions.FillReport, ReportDataAction.Methods.FillReportMethods.SelfCheck, para);
                    DataManager.sendData(urls.fillReportUrl, para, resultManager.SelfCheck_Success, resultManager.FailResult, false);
                },
                CancelSelfCheck: function () {
                    var para = { TaskId: "", PaperId: "", CompanyId: "", ReportId: "", Year: "", Cycle: "" };
                    para.TaskId = currentState.ReportState.AuditTask.value;
                    para.CompanyId = currentState.CompanyId;
                    para.Cycle = currentState.ReportState.Zq;
                    para.Year = currentState.ReportState.Nd;
                    para.PaperId = currentState.ReportState.AuditPaper.value;
                    para.ReportId = currentState.navigatorData.currentReportId;
                    para = CreateParameter(ReportDataAction.ActionType.Post, ReportDataAction.Functions.FillReport, ReportDataAction.Methods.FillReportMethods.CancelSelfCheck, para);
                    DataManager.sendData(urls.fillReportUrl, para, resultManager.CancelSelfCheck_Success, resultManager.FailResult, false);
                },
                PrintPreview: function () {

                    var gridFrame = toolsManager.GetGridIframe();
                    gridFrame.Grid1.PrintPreview(100);
                },
                Print: function () {
                    var gridFrame = toolsManager.GetGridIframe();
                    gridFrame.Grid1.DirectPrint();
                },
                ExportExcel: function () {
                    if (!BBDataItems.Gdq) { alert("先选择一张需要操作的报表"); return; }
                    var gridFrame = toolsManager.GetGridIframe();
                    gridFrame.Grid1.ExportToExcel("", false, false);
                }
            },

            ZqComboxEvent: {
                Nd_Select: function (value, text) {
                    if (zqLoadFlag) return;
                    currentState.ReportState.Nd = value;
                    mediatorManager.RefreshReport();
                },
                Zq_Select: function (value, text) {
                    if (zqLoadFlag) return;
                    currentState.ReportState.Zq = value;
                    mediatorManager.RefreshReport();
                }

            },
            ZqImgBtn_Click: function () {

            }
        };
        var menus = [
        {
            text: "文件", icon: 'archives', menu: {
                items: [
                { text: "打印", click: EventManager.MenuManager.Print, icon: 'print' },
                { text: "打印预览", click: EventManager.MenuManager.PrintPreview, icon: 'attibutes' },
                { line: true },
                { text: "导出Excel", click: EventManager.MenuManager.ExportExcel, icon: 'excil' }//  , icon: 'archives'
                ]
            }
        },
           { text: "取数", click: EventManager.MenuManager.DeserializeFatchFormular, icon: 'communication' },
           { text: "计算", click: EventManager.MenuManager.DeserializeCaculateFormular, icon: 'modify' },
           { text: "校验", click: EventManager.MenuManager.DeserializeVarifyFormular, icon: 'config' },
           {
               text: "本级审核", icon: 'ok', menu: {
                   items: [{ text: "本级审核", click: EventManager.MenuManager.SelfCheck, icon: 'msn' },
                { text: "取消本级审核", click: EventManager.MenuManager.CancelSelfCheck, icon: 'prev' }
                   ]
               }
           },
            { text: "保存", click: EventManager.MenuManager.SaveGrid, icon: 'save' },
            { text: "锁定", click: EventManager.MenuManager.LockCell, icon: 'Lock' },
            { text: "取消锁定", click: EventManager.MenuManager.UnLockCell, icon: 'NoLock' }


        ];

        $(function () {
            currentState.CompanyId = curCompany;
            $("#layout").ligerLayout({ leftWidth: 220, bottomHeight: 22, allowLeftCollapse: true });
            $("#menuBar").ligerToolBar({ items: menus });
            controls.AuditReportTab = $("#ReportsTab").ligerTab({ height: 28, contextmenu: false, onAfterRemoveTabItem: EventManager.TabEvents.AuditReportTab_Clossed, onAfterSelectTabItem: EventManager.TabEvents.AuditReportTab_Selected });

            controls.Tree = $("#tree1").ligerTree({
                idFieldName: 'Id',
                textFieldName: 'Name',
                parentIDFieldName: 'ParentId',
                slide: false,
                checkbox: false,
                nodeWidth: 'auto',
                onSelect: function (node, e) {
                    if (companyLoadFlag) return;
                    if (node.data == null) return;
                    currentState.CompanyId = node.data.Id;
                    mediatorManager.RefreshReport();
                }
            });
            centerHeight = $(".l-layout-center").height();
            var reportHeight = centerHeight;
            $("#content").css("height", reportHeight);
            $("#cframe").css("height", reportHeight);

            EventManager.InitializeBtn();
            var tempState;
            if (GetQueryString("result")) {
                tempState = GetQueryString("result");
                tempState = JSON.parse(tempState);
            }
            else {
                tempState = CookieDataManager.GetCookieData(ReportDataAction.Functions.FillReport);
            }
            if (tempState && tempState != null) {
                if (tempState.auditZqType == "05") {
                    if (tempState.WeekReport.ID == "") {
                        alert("请定义周报周期");
                        return;
                    }
                }
                toolsManager.SetAuditTask(tempState);
            } else {
                currentState.ReportState["auditPaperVisible"] = "1";
                currentState.ReportState["auditZqVisible"] = "1";
                var result = window.showModalDialog("ChooseAuditTask.aspx", currentState.ReportState, "dialogHeight:500px;dialogWidth:450px;scroll:no");
                if (result && result != undefined) {
                    if (result.auditZqType == "05") {
                        if (result.WeekReport.ID == "") {
                            alert("请定义周报周期");
                            var curTabTitle = "资料填报";
                            var t = parent.centerTabs.tabs('getTab', curTabTitle);
                            if (t.panel('options').closable) {
                                return;
                                //  parent.centerTabs.tabs('close', curTabTitle);
                            }
                        }

                    }
                    toolsManager.SetAuditTask(result);
                }


            }

            //初始树高度
            LayoutManager.setTreeHeight();
        });

        var toolsManager = {
            SetAuditTask: function (result) {
                CookieDataManager.SetCookieData(ReportDataAction.Functions.FillReport, result);
                currentState.ReportState = result;


                mediatorManager.LoadFirstData();
                //填报底稿、周期信息显示
                $("#auditTaskTypeSpan").text(currentState.ReportState.AuditType.name);
                $("#auditTaskSpan").text(currentState.ReportState.AuditTask.name);
                $("#auditPaperSpan").text(currentState.ReportState.AuditPaper.name);
                var reportZq;
                switch (currentState.ReportState.auditZqType) {
                    case "01":
                        reportZq = currentState.ReportState.Nd + "年"
                        break;
                    case "02":
                        reportZq = currentState.ReportState.Nd + "年" + currentState.ReportState.Zq + "月";
                        break;
                    case "03":
                        reportZq = currentState.ReportState.Nd + "年" + currentState.ReportState.Zq + "季度"
                        break;
                    case "04":
                        reportZq = currentState.ReportState.Zq + "日";
                        break;
                    case "05":
                        reportZq = currentState.ReportState.Zq + "周";
                        break;
                }

                $("#auditDateSpan").text(reportZq);

            },
            GetGridIframe: function () {
                return window.frames["gridFrame"];
            },
            GetReportIframe: function () {
                return window.frames["catalog"];
            },
            GetInfoframe: function () {
                return window.frames["CheckoutInfoIframe"];
            },
            IsOrNotBdq: function (Row, Col) {
                var code = "-1";
                $.each(BBData.bdq.Bdqs, function (index, item) {
                    if (item == null) return;
                    if (item.BdType == "1" && item.Offset == Row) {
                        //变动行
                        code = item.Code;
                    } else if (item.BdType == "2" && item.Offset == Col) {
                        code = item.Code;
                    }
                }
               );
                return code;
            },
            CreateDataItem: function () {
                var item = { value: "", cellDataType: "", isOrNotUpdate: "0" };
                return item;
            },
            GetReportParameter: function () {
                var para = { TaskId: "", PaperId: "", CompanyId: "", ReportId: "", Year: "", Cycle: "", ReportCode: "" };
                para.TaskId = currentState.ReportState.AuditTask.value;
                para.CompanyId = currentState.CompanyId;
                para.Cycle = currentState.ReportState.Zq;
                para.Year = currentState.ReportState.Nd;
                para.PaperId = currentState.ReportState.AuditPaper.value;
                para.ReportId = currentState.navigatorData.currentReportId;
                para.ReportCode = BBData.bbCode;
                return para;
            }
           ,
            CovertColorStr: function (colorStr) {
                var temp = colorStr.substring(1);
                var newColor = temp.substring(4, 6) + temp.substring(2, 4) + temp.substring(0, 2);
                return parseInt(newColor, 16);
            },
            CreateBdRowCode: function (tempCode, row) {
                return toolsManager.CreateNmCode(row) + tempCode.substr(4, 4);
            },
            CreateBdColCode: function (tempCode, col) {
                return tempCode.substr(0, 4) + toolsManager.CreateNmCode(col);
            },
            CreateNmCode: function (num) {
                var temp = num.toString();
                for (var i = temp.length; i < 4; i++) {
                    temp = "0" + temp;
                }
                return temp;
            },
            CreateRowColCode: function (row, col) {
                return toolsManager.CreateNmCode(row) + toolsManager.CreateNmCode(col);
            },
            GetCellItem: function (cellCode) {
                var row = parseInt(cellCode.substr(0, 4));
                var col = parseInt(cellCode.substr(5, 4));
                if (BBData.bbData[row] && BBData.bbData[row][col]) {
                    return BBData.bbData[row][col];
                }
                return null;
            },
            GetCellTagBdqInfo: function (row, col) {
                var upCellTag = gridFrame.Grid1.getTag(row, col); // gridFrame.Grid1.Cell(row, col).Tag;
                var bdInfo = JSON2.parse(upCellTag.split("|")[0].split(";")[1]);
                return bdInfo;
            },
            GetRowTagBdqInfo: function (row) {
                var cols = gridFrame.Grid1.getColumnCount(); // gridFrame.Grid1.Cols;
                var bdInfo;
                for (var i = 0; i < cols; i++) {
                    var tag = gridFrame.Grid1.getTag(row, i); //gridFrame.Grid1.Cell(row, i).Tag;
                    if (tag != "") {
                        bdInfo = JSON2.parse(tag.split("|")[0].split(";")[1]);
                        break;
                    }
                }
                return bdInfo;
            },
            GetArrayCountBeforeCurrentIndex: function (array, index) {
                var count = 0;
                $.each(array, function (bz, item) {
                    if (item != undefined) {
                        if (index > bz) { count++; }
                    }
                });
                return count;
            },
            GetMaxCountArray: function (array) {
                var max = 0;
                $.each(array, function (bz, item) {
                    if (item != undefined) {
                        if (bz > max) { max = bz; }
                    }
                });
                return max;
            },
            GetGdqCellCode: function () {
                var tag = toolsManager.GetGridIframe().GridManager.GetCurrentTag();
                if (tag != "") {
                    var bdLx = tag.split("|")[0].split(";")[0];
                    if (bdLx == "1") {
                        return tag.split("|")[0].split(";")[1];
                    } else {
                        return "-1";
                    }
                }
                return "-1";
            }

        };
        var datestart = new Date();
        var date2 = new Date();
        var s = "";
        var mediatorManager = {
            LoadFirstData: function () {

                var para = { TaskId: "", PaperId: "", CompanyId: "", ReportId: "", Year: "", Cycle: "", AuditDate: "", ReportType: "" };
                para.TaskId = currentState.ReportState.AuditTask.value;
                para.CompanyId = currentState.CompanyId;
                para.Cycle = currentState.ReportState.Zq;
                para.Year = currentState.ReportState.Nd;
                para.PaperId = currentState.ReportState.AuditPaper.value;
                para.ReportId = currentState.navigatorData.currentReportId;
                para.ReportType = currentState.ReportState.auditZqType;
                para = CreateParameter(ReportDataAction.ActionType.Post, ReportDataAction.Functions.FillReport, ReportDataAction.Methods.FillReportMethods.GetReportFirstLoadStruct, para);
                DataManager.sendData(urls.fillReportUrl, para, resultManager.GetFirstReportStruct_Success, resultManager.FailResult);
            },
            LoadAuditPaperAndReport: function () {
                var para = { auditPaperId: currentState.ReportState.AuditPaper.value };
                para = CreateParameter(ReportDataAction.ActionType.Post, ReportDataAction.Functions.FillReport, ReportDataAction.Methods.FillReportMethods.GetReportsByAuditPaper, para);
                DataManager.sendData(urls.fillReportUrl, para, resultManager.LoadAuditPaperAndReport_SuccessResult, resultManager.FailResult);
            },
            LoadBBFormat: function () {
                var para = { Id: "" };
                para.Id = currentState.navigatorData.currentReportId;
                para = CreateParameter(ReportFormatAction.ActionType.Post, ReportFormatAction.Functions.ReportFormatMenu, ReportFormatAction.Methods.ReportFormatMenuMethods.LoadReportFormat, para);

                DataManager.sendData(urls.BBUrl, para, resultManager.LoadBB_Success, resultManager.FailResult, false);
            },
            LoadBBCompFormat: function () {
                var para = { Id: "", CompanyId: "" };
                para.Id = currentState.navigatorData.currentReportId;
                para.CompanyId = currentState.CompanyId;
                para = CreateParameter(ReportFormatAction.ActionType.Post, ReportFormatAction.Functions.ReportFormatMenu, ReportFormatAction.Methods.ReportFormatMenuMethods.LoadComReportFormat, para);

                // DataManager.sendData(urls.BBUrl, para, resultManager.LoadCompBB_Success, resultManager.FailResult, false);
            },
            LoadCompanies: function () {
                if (currentState.ReportState.AuditPaper.value == "") return;
                var para = { AuditPaperId: "" };
                para.AuditPaperId = currentState.ReportState.AuditPaper.value;
                para = CreateParameter(ReportDataAction.ActionType.Post, ReportDataAction.Functions.FillReport, ReportDataAction.Methods.FillReportMethods.GetCompaniesByAuditPaperAndAuthority, para);
                DataManager.sendData(urls.fillReportUrl, para, resultManager.LoadCompanies_Success, resultManager.FailResult, false);
            },
            LoadZq: function () {
                var para = { ReportType: "", CurrentNd: "", CurrentZq: "" };
                para.ReportType = currentState.ReportState.auditZqType;
                para.CurrentNd = currentState.ReportState.Nd;
                para.CurrentZq = currentState.ReportState.Zq;

                para = CreateParameter(ReportDataAction.ActionType.Post, ReportDataAction.Functions.FillReport, ReportDataAction.Methods.FillReportMethods.GetReportCycle, para);
                DataManager.sendData(urls.fillReportUrl, para, resultManager.LoadCycle_Success, resultManager.FailResult, false);
            },
            LoadBbData: function () {
                datestart = new Date();
                s += "开始LoadBbData" + datestart;
                var gridIframe = toolsManager.GetGridIframe();
                var para = { TaskId: "", PaperId: "", CompanyId: "", ReportId: "", Year: "", Cycle: "", AuditDate: "", bdqStr: "", Where: "", WeekReportID: "", WeekReportName: "", WeekReportKsrq: "", WeekReportJsrq: "" };
                para.TaskId = currentState.ReportState.AuditTask.value;
                para.CompanyId = currentState.CompanyId;
                para.Cycle = currentState.ReportState.Zq;
                para.Year = currentState.ReportState.Nd;
                para.PaperId = currentState.ReportState.AuditPaper.value;
                para.ReportId = currentState.navigatorData.currentReportId;
                para.bdqStr = JSON2.stringify(currentState.BdqDataMaps);
                var bdqCode = vsBDBH; // currentState.BdqBh;
                para.Where = "&&";
                para.WeekReportID = currentState.ReportState.WeekReport.ID;
                para.WeekReportName = currentState.ReportState.WeekReport.Name;
                para.WeekReportKsrq = currentState.ReportState.WeekReport.Ksrq;
                para.WeekReportJsrq = currentState.ReportState.WeekReport.Jsrq;
                datestart = new Date();
                s += "开始CreateParameter" + datestart;
                para = CreateParameter(ReportDataAction.ActionType.Post, ReportDataAction.Functions.FillReport, ReportDataAction.Methods.FillReportMethods.LoadReportDatas, para);
                datestart = new Date();
                s += "sendData" + datestart;
                DataManager.sendData(urls.fillReportUrl, para, resultManager.LoadReportData_Success, resultManager.FailResult, false);
                currentState.BdqBh = "";
                datestart = new Date();
                s += "完成" + datestart;
                controls.InsertRow.css("display", "none");
                controls.DeleteRow.css("display", "none");
            },
            SetRowColInput: function (row, col, tag) {
                $("#rowColInput").val(row + "行" + col + "列");
                if (tag != null && tag != "" && tag.length > 0) {
                    var bdArr = tag.split("|")[0].split(";");


                    if (bdArr[0] == "0") {
                        var bdInfo = toolsManager.GetCellTagBdqInfo(row, col);
                        controls.InsertRow.css("display", "block");
                        controls.DeleteRow.css("display", "block");
                        if (currentState.BdqDataMaps[bdInfo.bdCode] && currentState.BdqDataMaps[bdInfo.bdCode].isOrNotLoadAll == "0") {
                            $("#LoadInf").remove();

                        }

                        if (currentState.BdqBh != bdInfo.bdCode) {
                            currentState.BdqBh = bdInfo.bdCode;
                            vsBDBH = currentState.BdqBh;
                        }
                    } else {
                        controls.InsertRow.css("display", "none");
                        controls.DeleteRow.css("display", "none");
                        $("#LoadInf").css("display", "none");
                        $("#LoadAll").css("display", "none");
                        currentState.BdqBh = "";
                        //*******************************
                        InfoIframControl.cellCode = bdArr[1];
                        if (!InfoIframControl.Collapse) {
                            tabManager.LinkManager.loadLinkInf();
                        }
                        //*******************************
                    }
                } else {
                    controls.InsertRow.css("display", "none");
                    controls.DeleteRow.css("display", "none");
                    $("#LoadInf").css("display", "none");
                    currentState.BdqBh = "";
                }

                toolsManager.GetInfoframe().RefreshAttatch();
            },
            TextChange: function (row, col, tag) {
                //根据单元格信息设置单元格数据状态
                if (cellTextNotChangeSetCellType) return;
                if (tag != null && tag != "" && tag.length > 0) {
                    var cellArr = tag.split("|");
                    var bdArr = cellArr[0].split(";");
                    if (bdArr[0] != "1" && bdArr[0] != "0") return;
                    var cellFormat;
                    if (bdArr[0] == "1") {
                        if (!cellArr[2]) return;
                        cellFormat = JSON2.parse(cellArr[2]);
                    } else {
                        var bdInfo = toolsManager.GetCellTagBdqInfo(row, col);
                        var bdFormat = BBData.bdq.Bdqs[BBData.bdq.BdqMaps[bdInfo.bdCode]];
                        var cellFormat;
                        if (bdFormat.BdType == "1") {
                            cellFormat = BBData.bbData[bdFormat.Offset][col];

                        } else if (bdFormat.BdType == "2") {
                            cellFormat = BBData.bbData[row][bdFormat.Offset];
                        }
                    }

                    if (cellFormat != null)
                        gridFrame.GridManager.SetRowColTextByCellType(row, col, cellFormat);
                }
            },
            RefreshHome: function () {
                var para = { TaskId: "", PaperId: "", CompanyId: "", ReportId: "", Year: "", Cycle: "", AuditDate: "", ReportType: "" };
                para.TaskId = currentState.ReportState.AuditTask.value;
                para.CompanyId = currentState.CompanyId;
                para.Cycle = currentState.ReportState.Zq;
                para.ReportId = currentState.navigatorData.currentReportId;
                para.Year = currentState.ReportState.Nd;
                para.PaperId = currentState.ReportState.AuditPaper.value;
                para.ReportType = currentState.ReportState.auditZqType;
                para = CreateParameter(ReportDataAction.ActionType.Post, ReportDataAction.Functions.FillReport, ReportDataAction.Methods.FillReportMethods.GetReportWithStateAndAttatch, para);
                DataManager.sendData(urls.fillReportUrl, para, resultManager.LoadRefreshHomeData_Success, resultManager.FailResult);
            },
            RefreshReport: function () {
                callbackRun(function(){
                currentState.RowColChange = false;
                if (currentState.navigatorData.currentReportId == "home" || currentState.navigatorData.currentReportId == "") { mediatorManager.RefreshHome(); return; }
                if (BBData.bdq.bdNum > 0) {

                    //    top.loader && top.loader.open();

                    gridFrame.RefreshGrid(currentState.ReportFormat);
                    gridFrame.Grid1.isPaintSuspended(true);
                    $.each(BBData.bbData, function (rowIndex, row) {
                        $.each(row, function (colIndex, cell) {

                            if (cell && cell.CellLogicalType && cell.CellLogicalType == "02" && cell.CellDataType && cell.CellDataType != "") {

                                var flag = toolsManager.IsOrNotBdq(rowIndex, colIndex);
                                if (flag == "-1") {
                                    CellTag = "1;" + cell.CellCode + "|" + cell.CellDataType + "|" + JSON2.stringify(cell);
                                } else {
                                    CellTag = "0;" + JSON2.stringify({ CellCode: cell.CellCode, bdCode: flag, index: 0 }) + "|" + cell.CellDataType + "|" + JSON2.stringify(cell);
                                }
                                gridFrame.Grid1.setTag(rowIndex, colIndex, CellTag);
                                //设置单元格对齐方式
                                var align;
                                if (cell.CellDataType == "01") {
                                    align = gridFrame.spreadNS.HorizontalAlign["left"];
                                    gridFrame.Grid1.getCell(rowIndex, colIndex)["hAlign"](align);
                                } else if (cell.CellDataType == "02") {
                                    align = gridFrame.spreadNS.HorizontalAlign["right"];
                                    gridFrame.Grid1.getCell(rowIndex, colIndex)["hAlign"](align);
                                }
                                //设置单元格类型
                                if (cell.CellType == "02") {
                                    gridFrame.Grid1.Cell(rowIndex, colIndex).CellType = 1;
                                } else if (cell.CellType == "03") {
                                    gridFrame.Grid1.Cell(rowIndex, colIndex).CellType = 4;
                                }
                            } else {
                                gridFrame.Grid1.getCell(rowIndex, colIndex).locked(true);
                            }

                        });
                    });
                    for (var i = 0; i < gridFrame.Grid1.getRowCount() ; i++) {
                        for (var j = 0; j < gridFrame.Grid1.getColumnCount() ; j++) {
                            var tag = gridFrame.Grid1.getTag(i, j);
                            if (tag == null || tag == "") {
                                gridFrame.Grid1.getCell(i, j).locked(true);
                            }
                            else {
                                gridFrame.Grid1.getCell(i, j).locked(false);
                            }
                        }
                    }
                } else {
                    $.each(BBData.bbData, function (rowIndex, row) {
                        $.each(row, function (colIndex, cell) {
                            if (cell && cell.CellLogicalType && cell.CellLogicalType == "02" && cell.CellDataType && cell.CellDataType != "") {
                                //                                 gridFrame.Grid1.getCell(rowIndex, colIndex).text("");
                                gridFrame.Grid1.setValue(rowIndex, colIndex, "");
                            }
                        });
                    });
                }
                gridFrame.Grid1.isPaintSuspended(false);
                currentState.RowColChange = true;

                mediatorManager.LoadBbData();
                    });
                // top.loader && top.loader.close();
            },
            InitializeCompanies: function (data) {
                try {
                    companyLoadFlag = true;
                    controls.Tree.setData(data);
                    controls.Tree.selectNode(curCompany);
                    companyLoadFlag = false;
                } catch (err) {
                    alert(err.Message);
                }
            },
            InitializeZq: function (data) {
                try {
                    zqLoadFlag = true;
                    $("#ndTd").empty();
                    $("#zqTd").empty();
                    var zqType = currentState.ReportState.auditZqType;
                    switch (zqType) {
                        case "01":
                            $("#zqDiv").empty();
                            $("#zqDiv").html('<table  style=" width:180px; padding:0; margin:2px;">' +
           '<tr style=" line-height:28px;"><td id="ndLbl" >年度</td><td id="ndTd"><input type="text" id="txtNd"/></td><td></td></tr>' +
           '</table>');

                            controls.Nd = $("#txtNd").ligerComboBox(
                       {
                           valueField: 'value',
                           textField: 'name',
                           data: data.Nds,
                           onSelected: EventManager.ZqComboxEvent.Nd_Select
                       }
                       );
                            controls.Nd.setValue(data.CurrentNd);

                            break;
                        case "02":
                            $("#zqDiv").empty();
                            $("#zqDiv").html('<table  style=" width:180px; padding:0; margin:2px;">' +
           '<tr style=" line-height:28px;"><td id="ndLbl" >年度</td><td id="ndTd"><input type="text" id="txtNd"/></td><td></td></tr>' +
            '<tr style=" line-height:28px;" id="zqTr"><td id="zqLbl" >月份</td><td id="zqTd"><input type="text" id="txtZq"/></td><td></td></tr>' +
           '</table>');

                            controls.Nd = $("#txtNd").ligerComboBox(
                       {
                           valueField: 'value',
                           textField: 'name',
                           data: data.Nds,
                           onSelected: EventManager.ZqComboxEvent.Nd_Select
                       }
                       );



                            controls.Zq = $("#txtZq").ligerComboBox(
                       {
                           valueField: 'value',
                           textField: 'name',
                           data: data.Cycles,
                           onSelected: EventManager.ZqComboxEvent.Zq_Select
                       }
                            );
                            controls.Nd.setValue(data.CurrentNd);
                            controls.Zq.setValue(data.CurrentZq);
                            break;
                        case "03":
                            $("#zqDiv").empty();
                            $("#zqDiv").html('<table  style=" width:180px; padding:0; margin:2px;">' +
           '<tr style=" line-height:28px;"><td id="ndLbl" >年度</td><td id="ndTd"><input type="text" id="txtNd"/></td><td></td></tr>' +
            '<tr style=" line-height:28px;" id="zqTr"><td id="zqLbl" >季度</td><td id="zqTd"><input type="text" id="txtZq"/></td><td></td></tr>' +
           '</table>');

                            controls.Nd = $("#txtNd").ligerComboBox(
                       {
                           valueField: 'value',
                           textField: 'name',
                           data: data.Nds,
                           onSelected: EventManager.ZqComboxEvent.Nd_Select
                       }
                       );



                            controls.Zq = $("#txtZq").ligerComboBox(
                       {
                           valueField: 'value',
                           textField: 'name',
                           data: data.Cycles,
                           onSelected: EventManager.ZqComboxEvent.Zq_Select

                       }
                            );
                            controls.Nd.setValue(data.CurrentNd);
                            controls.Zq.setValue(data.CurrentZq);
                            break;
                        case "04":
                            $("#zqDiv").empty();
                            $("#zqDiv").html('<table  style=" width:180px; padding:0; margin:2px;">' +
           '<tr style=" line-height:28px;"><td id="ndLbl" >日期</td><td id="ndTd"><input type="text" id="txtNd"/></td><td></td></tr>' +
           '</table>');


                            controls.Nd = $("#txtNd").ligerDateEditor(
                       {
                           showTime: false,
                           onChangeDate: function (value) {
                               if (value == "") return;
                               currentState.BbDataParameter.Cycle = value;
                               currentState.BbDataParameter.Year = value.substr(0, 4);
                               mediatorManager.RefreshReport();
                           }
                       }
                            );
                            controls.Nd.setValue(data.CurrentZq);

                            break;
                        case "05":
                            $("#zqDiv").empty();
                            $("#zqDiv").html('<table  style=" width:210px;">' +
                             '<tr  id="zqTr"><td style=" width:100px" id="zqLbl" >周期</td><td style=" width:50px"  id="zqTd"><input type="text" id="txtZq"/></td></tr>' +
            '<tr ><td id="ndLbl" >日期</td><td id="ndTd"><input type="text" id="txtKSRQ"/></td><td></td></tr>' +
             '<tr ><td id="ndLbl1" >至</td><td id="ndTd1"><input type="text" id="txtJSRQ"/></td><td></td></tr>' +
           '</table>');
                            $("#txtZq").val(currentState.ReportState.WeekReport.Name);
                            $("#txtKSRQ").ligerDateEditor(
                       {
                           showTime: false,
                           onChangeDate: function (value) {

                           }
                       }
                            );

                            $("#txtKSRQ").val(currentState.ReportState.WeekReport.Ksrq);
                            $("#txtJSRQ").ligerDateEditor(
                       {
                           showTime: false,
                           onChangeDate: function (value) {

                           }
                       }
                            );
                            $("#txtJSRQ").val(currentState.ReportState.WeekReport.Jsrq);


                            break;
                    }
                    currentState.ReportState.Nd = data.CurrentNd;
                    currentState.ReportState.Zq = data.CurrentZq;
                    zqLoadFlag = false;
                } catch (err) {
                    alert(err.Message);
                }
            },
            SetReportState: function (state) {
                try {
                    if (state == "0") {
                        var gridFrame = window.frames["gridFrame"];
                        gridFrame.Grid1.isPaintSuspended(true);
                        for (var i = 0; i < gridFrame.Grid1.getRowCount() ; i++) {
                            for (var j = 0; j < gridFrame.Grid1.getColumnCount() ; j++) {
                                gridFrame.Grid1.getCell(i, j).locked(true);
                            }
                        }
                        gridFrame.Grid1.isPaintSuspended(false);
                    }
                } catch (err) {
                    alert(err.Message);
                }
            },
            RemoveReportReadWriteLock: function () {
                try {

                    var para = { TaskId: "", PaperId: "", CompanyId: "", ReportId: "", Year: "", Cycle: "", AuditDate: "", ReportType: "" };
                    para.TaskId = currentState.ReportState.AuditTask.value;
                    para.CompanyId = currentState.CompanyId;
                    para.Cycle = currentState.ReportState.Zq;
                    para.ReportId = currentState.navigatorData.currentReportId;
                    para.Year = currentState.ReportState.Nd;
                    para.PaperId = currentState.ReportState.AuditPaper.value;
                    para.ReportType = currentState.ReportState.auditZqType;
                    para = CreateParameter(ReportDataAction.ActionType.Post, ReportDataAction.Functions.FillReport, ReportDataAction.Methods.FillReportMethods.RemoveReportReadWriteState, para);
                    DataManager.sendData(urls.fillReportUrl, para, resultManager.RemoveReadWriteLock_Success, resultManager.FailResult, true);

                } catch (err) {
                    alert(err.Message);
                }
            }
        };

        var resultManager = {
            GetFirstReportStruct_Success: function (data) {
                if (data.success) {
                    mediatorManager.InitializeCompanies(data.obj.companies);
                    mediatorManager.InitializeZq(data.obj.reportCycle);

                    tabManager.FirstLoadTabs(data.obj.reports);
                } else {
                    alert(data.sMeg);
                }
            },
            LoadRefreshHomeData_Success: function (data) {
                if (data.success) {
                    tabManager.LoadCatalogDatas(data.obj.rows);
                } else {
                    alert(data.sMeg);
                }
            },
            LoadAuditPaperAndReport_SuccessResult: function (data) {
                if (data.success) {
                    tabManager.FirstLoadTabs(data.obj);
                } else {
                    alert(data.sMeg);
                }
            },
            FailResult: function (data) {
                alert(data.sMeg);
                 top.loader && top.loader.close();
            },
            LoadCompBB_Success: function (data) {
                alert(data.sMeg);

            },
            LoadBB_Success: function (data) {
                if (data.success) {

                    if (data && data.obj && data.obj.formatStr) {
                        currentState.ReportFormat = data.obj.formatStr;
                        currentState.ReportCalcuFormat = data.obj.formatCalcuStr;
                        var gridFrame = window.frames["gridFrame"];
                        var width = $("#content").css("width");
                        width = parseInt(width.substr(0, width.length - 2), 10);

                        var height = $("#content").css("height");
                        height = parseInt(height.substr(0, height.length - 2), 10);
                        if (gridFrame.RefreshGrid) {
                            gridFrame.RefreshGrid(currentState.ReportFormat, width, height);
                            //                             gridFrame.Grid1.isPaintSuspended(true);
                            //                             for (var i = 0; i < gridFrame.Grid1.getRowCount(); i++) {
                            //                                 for (var j = 0; j < gridFrame.Grid1.getColumnCount(); j++) {

                            //                                     gridFrame.Grid1.setTag(i, j, "");
                            //                                 }
                            //                             }
                            //                             gridFrame.Grid1.isPaintSuspended(false);
                            BBData = JSON2.parse(data.obj.itemStr);
                            currentState.RowColChange = false;
                            cellTextNotChangeSetCellType = true;


                            var vsBdhRow;
                            var vsBdhs = "";
                            gridFrame.Grid1.isPaintSuspended(true);
                            $.each(BBData.bbData, function (rowIndex, row) {
                                var vsFlag = toolsManager.IsOrNotBdq(rowIndex, 0);
                                if (vsFlag != "-1") {
                                    vsBdhs += rowIndex + ",";
                                }
                                $.each(row, function (colIndex, cell) {
                                    if (cell && cell.CellLogicalType && cell.CellLogicalType == "02" && cell.CellDataType && cell.CellDataType != "") {

                                        //gridFrame.Grid1.getCell(rowIndex, colIndex).text("");
                                        gridFrame.Grid1.setValue(rowIndex, colIndex, "");
                                        var flag = toolsManager.IsOrNotBdq(rowIndex, colIndex);
                                        if (flag == "-1") {
                                            CellTag = "1;" + cell.CellCode + "|" + cell.CellDataType + "|" + JSON2.stringify(cell);
                                        } else {
                                            //变动区，需要记录变动区编号、变动区当前数据编号和变动区编号

                                            vsBdhRow = rowIndex;
                                            CellTag = "0;" + JSON2.stringify({ CellCode: cell.CellCode, bdCode: flag, index: 0 }) + "|" + cell.CellDataType + "|" + JSON2.stringify(cell);
                                        }

                                        gridFrame.Grid1.setTag(rowIndex, colIndex, CellTag);
                                        if (cell.CellLock == "1") {
                                            gridFrame.Grid1.getCell(rowIndex, colIndex).locked(true);

                                        }
                                        else {
                                            gridFrame.Grid1.getCell(rowIndex, colIndex).locked(false);
                                        }
                                        //设置单元格对齐方式
                                        var align;
                                        if (cell.CellDataType == "01") {
                                            align = gridFrame.spreadNS.HorizontalAlign["left"];
                                            gridFrame.Grid1.getCell(rowIndex, colIndex)["hAlign"](align);

                                        } else if (cell.CellDataType == "02") {
                                            align = gridFrame.spreadNS.HorizontalAlign["right"];
                                            gridFrame.Grid1.getCell(rowIndex, colIndex)["hAlign"](align);

                                        }
                                        //设置单元格类型
                                        gridFrame.GridManager.SetRowColCellType(cell, rowIndex, colIndex);

                                    } else {
                                        gridFrame.Grid1.getCell(rowIndex, colIndex).locked(true);

                                    }
                                });


                            });

                            gridFrame.Grid1.isPaintSuspended(false);

                            currentState.RowColChange = false;
                            //                             gridFrame.Grid1.isPaintSuspended(true);
                            //                             for (var i = 0; i < gridFrame.Grid1.getRowCount(); i++) {
                            //                                 for (var j = 0; j < gridFrame.Grid1.getColumnCount(); j++) {
                            //                                     var tag = gridFrame.Grid1.getTag(i, j); // gridFrame.Grid1.Cell(i, j).Tag;
                            //                                     if (tag == "") {
                            //                                         gridFrame.Grid1.getCell(i, j).locked(true);

                            //                                     }
                            //                                     else {
                            //                                         gridFrame.Grid1.getCell(i, j).locked(false);
                            //                                     }
                            //                                 }
                            //                             }
                            //                             gridFrame.Grid1.isPaintSuspended(false);

                            currentState.RowColChange = true;
                            cellTextNotChangeSetCellType = false;
                        } else {
                            gridFrame.onload = gridFrame.onreadystatechange = function () {
                                if (this.readyState && this.readyState != 'complete') return;
                                else {
                                    gridFrame.RefreshGrid(currentState.ReportFormat, width, height);

                                    BBData = JSON2.parse(data.obj.itemStr);
                                    currentState.RowColChange = false;
                                    cellTextNotChangeSetCellType = true;
                                    $.each(BBData.bbData, function (rowIndex, row) {
                                        $.each(row, function (colIndex, cell) {
                                            if (cell && cell.CellLogicalType && cell.CellLogicalType == "02" && cell.CellDataType && cell.CellDataType != "") {
                                                gridFrame.Grid1.Cell(rowIndex, colIndex).Text = "";
                                                var flag = toolsManager.IsOrNotBdq(rowIndex, colIndex);
                                                if (flag == "-1") {
                                                    CellTag = "1;" + cell.CellCode + "|" + cell.CellDataType + "|" + JSON2.stringify(cell);
                                                } else {
                                                    CellTag = "0;" + JSON2.stringify({ CellCode: cell.CellCode, bdCode: flag, index: 0 }) + "|" + cell.CellDataType + "|" + JSON2.stringify(cell);
                                                }
                                                gridFrame.Grid1.Cell(rowIndex, colIndex).Tag = CellTag;
                                                if (cell.CellLock == "1") {
                                                    gridFrame.Grid1.getCell(rowIndex, colIndex).locked(true);
                                                    // gridFrame.Grid1.Cell(rowIndex, colIndex).Locked = true;
                                                }

                                                //设置单元格对齐方式
                                                if (cell.CellDataType == "01") {
                                                    //  gridFrame.Grid1.Cell(rowIndex, colIndex).Alignment = 4;
                                                } else if (cell.CellDataType == "02") {
                                                    //  gridFrame.Grid1.Cell(rowIndex, colIndex).Alignment = 12;
                                                }
                                                //设置单元格类型
                                                if (cell.CellType == "02") {
                                                    //  gridFrame.Grid1.Cell(rowIndex, colIndex).CellType = 1;
                                                } else if (cell.CellType == "03") {
                                                    //  gridFrame.Grid1.Cell(rowIndex, colIndex).CellType = 4;
                                                }
                                            } else {

                                                gridFrame.Grid1.getCell(rowIndex, colIndex).locked(true);
                                            }
                                        });
                                    });

                                    currentState.RowColChange = true;
                                    cellTextNotChangeSetCellType = false;
                                }
                            }
                        }

                    }
                } else {
                    alert(data.sMeg);
                }
            },
            LoadCompanies_Success: function (data, flag) {
                if (data.success) {
                    if (data.obj) {
                        mediatorManager.InitializeCompanies(data.obj);
                    }

                } else {
                    alert(data.sMeg);
                }
            },
            LoadCycle_Success: function (data, flag) {

                if (data.success) {
                    if (data.obj) {
                        mediatorManager.InitializeZq(data.obj);
                    }

                } else {
                    alert(data.sMeg);
                }
            },

            LoadReportData_Success: function (data) {
                datestart = new Date();
                s += "开始LoadReportData_Success" + datestart;
                if (data.success) {
                    if (data.obj) {

                        BBDataItems = data.obj;
                        currentState.BdqDataMaps = BBDataItems.rdps.bdqMaps;
                        var gridIframe = toolsManager.GetGridIframe();
                        //  gridIframe.Grid1.setIsProtected(true);
                        gridFrame.Grid1.isPaintSuspended(true);
                        //固定行数据
                        $.each(data.obj.Gdq, function (cellCode, CellItem) {
                            gridFrame.GridManager.SetRowColText(CellItem.row, CellItem.col, CellItem);
                            var tag = gridFrame.Grid1.getTag(CellItem.row, CellItem.col);
                            mediatorManager.TextChange(CellItem.row, CellItem.col, tag);

                        });
                        gridFrame.Grid1.isPaintSuspended(false);
                        var vsKSRow;
                        var vsRowNum;

                        var rowChangeFlag = {};
                        var colChangeFlag = {};

                        //                         gridFrame.Grid1.suspendCalcService(false);

                        //变动表数据
                        $.each(data.obj.BdqData, function (bdqIndex, bdqData) {

                            var bdqCode = BBDataItems.bdIndexMaps[bdqIndex.toString()];
                            var bdFormat = BBData.bdq.Bdqs[BBData.bdq.BdqMaps[bdqCode]];
                            bdCodeCountMaps[bdqCode] = rowNum;
                            if (bdFormat.BdType == "1") {
                                var rowNum = bdqData.length;
                                // bdCodeCountMaps[bdqCode] = rowNum;
                                //变动行
                                var addRowData = 0;
                                $.each(rowChangeFlag, function (index, item) {
                                    if (index < bdFormat.Offset) {
                                        addRowData += item;
                                    }

                                });
                                if (rowNum > 1) {
                                    datestart = new Date();
                                    s += "11111  " + datestart;
                                    vsKSRow = bdFormat.Offset + addRowData;
                                    vsRowNum = bdFormat.Offset + addRowData + rowNum - 1;
                                    
                                    gridFrame.Grid1.isPaintSuspended(true);
                                    gridFrame.Grid1.addRows(bdFormat.Offset + 1 + addRowData, rowNum - 1);

                                    datestart = new Date();
                                    s += "11111  " + datestart;
                                    for (var i = bdFormat.Offset + 1 + addRowData; i <= bdFormat.Offset + addRowData + rowNum; i++) {
                                        gridFrame.Grid1._vpCalcSheetModel.dataTable[i] = undefined;
                                    }

                                    datestart = new Date();
                                    s += "22222 " + datestart;
                                    var columnCount = gridFrame.Grid1.getColumnCount();
                                    var option = { all: true };
                                    var lineBorder = new gridFrame.spreadNS.LineBorder("#000000", gridFrame.spreadNS.LineStyle.thick);
                                    var columnCount = gridFrame.Grid1.getColumnCount();
                                    // var vsRange = new gridFrame.spreadNS.Range(bdFormat.Offset + 1, 0, rowNum - 1, columnCount);
                                    var vsRange = new gridFrame.spreadNS.Range(vsKSRow, 0, rowNum, columnCount);
                                    gridFrame.Grid1.isPaintSuspended(false);
                                    gridFrame.Grid1.isPaintSuspended(true);
                                    gridFrame.Grid1.setBorder(vsRange, lineBorder, option);
                                    gridFrame.Grid1.getCells(bdFormat.Offset + addRowData, 0, bdFormat.Offset + addRowData + rowNum - 1, columnCount - 1).backColor("#FF99CC");
                                    //for (var i = 0; i < columnCount; i++) {
                                    //    gridFrame.Grid1.getCells(bdFormat.Offset + addRowData, 0, bdFormat.Offset + addRowData + rowNum - 1, columnCount - 1).backColor("#FF99CC");
                                    //}
                                    for (var i = bdFormat.Offset + addRowData; i <= bdFormat.Offset + addRowData + rowNum - 1; i++) {

                                        for (var j = 0; j < gridFrame.Grid1.getColumnCount() ; j++) {
                                            gridIframe.Grid1.getCell(i, j).locked(false);
                                        }
                                    }
                                    gridIframe.Grid1.getCells(bdFormat.Offset + addRowData, 0, bdFormat.Offset + addRowData + rowNum - 1, gridFrame.Grid1.getColumnCount() - 1).locked(false);
                                    gridFrame.Grid1.isPaintSuspended(false);
                                    gridFrame.Grid1.isPaintSuspended(true);

                                    
                                    //设置变动行中的数据格式信息
                                    $.each(BBData.bbData[bdFormat.Offset], function (columnIndex, cell) {
                                        for (var i = bdFormat.Offset + 1 + addRowData - 1; i <= bdFormat.Offset + rowNum + addRowData - 1; i++) {
                                            var cellCode = cell["CellCode"];

                                            if (cellCode) {
                                                var index = i - bdFormat.Offset - addRowData;
                                                CellTag = "0;" + JSON2.stringify({ CellCode: cellCode, bdCode: bdqCode, index: index }) + "|" + cell.CellDataType + "|" + JSON2.stringify(cell);
                                                gridFrame.Grid1.setTag(i, columnIndex, CellTag);

                                                //设置单元格类型
                                                gridFrame.GridManager.SetRowColCellType(cell, i, columnIndex);
                                                var align;

                                                //设置单元格对齐方式
                                                if (cell.CellDataType == "01") {
                                                    align = gridFrame.spreadNS.HorizontalAlign["left"];
                                                    gridFrame.Grid1.getCell(i, columnIndex)["hAlign"](align);
                                                } else if (cell.CellDataType == "02") {
                                                    align = gridFrame.spreadNS.HorizontalAlign["right"];
                                                    gridFrame.Grid1.getCell(i, columnIndex)["hAlign"](align);
                                                }
                                            }
                                        }
                                    });
                                    //设置增量记录
                                    rowChangeFlag[bdFormat.Offset] = rowNum - 1;

                                }
                               
                                //gridFrame.Grid1.isPaintSuspended(true);
                                datestart = new Date();
                                s += "开始setBorder " + datestart;
                                //设置变动行数据
                                if (bdqData && bdqData.length > 0) {
                                    $.each(bdqData, function (bdRowIndex, bdRow) {
                                        $.each(BBData.bbData[bdFormat.Offset], function (columnIndex, cell) {
                                            if (cell.CellCode) {
                                                var row = bdFormat.Offset + bdRowIndex + addRowData;
                                                if (bdRow && bdRow[cell.CellCode]) {
                                                    gridFrame.GridManager.SetRowColText(row, columnIndex, bdRow[cell.CellCode]);
                                                } else {
                                                    var cellItem = { value: "", cellDataType: cell.CellDataType, isOrNotUpdate: "0" };
                                                    gridFrame.GridManager.SetRowColTextByRowCol(row, columnIndex, cellItem);
                                                }
                                                var tag = gridFrame.Grid1.getTag(row, columnIndex);
                                                mediatorManager.TextChange(row, columnIndex, tag);
                                            }

                                        });

                                    });
                                } else {

                                    $.each(BBData.bbData[bdFormat.Offset], function (columnIndex, cell) {
                                        var row = bdFormat.Offset + addRowData;
                                        var rowColCode = cell["CellCode"];
                                        if (rowColCode) {
                                            var cellItem = { value: "", cellDataType: cell.CellDataType, isOrNotUpdate: "0" };
                                            gridFrame.GridManager.SetRowColTextByRowCol(row, columnIndex, cellItem);
                                        }

                                    });
                                }
                                datestart = new Date();
                                s += "结束setBorder " + datestart;
                            }
                            else if (bdFormat.BdType == "2") {
                                //变动列
                                var colNum = bdqData.length;
                                //变动行
                                var addColIndex = 0;
                                $(colChangeFlag, function (index, item) {
                                    if (item < bdFormat.Offset) {
                                        addColIndex += item;
                                    }
                                });
                                if (colNum > 1) {

                                    gridIframe.Grid1.InsertCol(bdFormat.Offset + addColIndex + 1, colNum - 1);
                                    gridFrame.Grid1.Range(1, bdFormat.Offset + 1 + addColIndex, gridIframe.Grid1.Rows - 1, bdFormat.Offset + addColIndex + colNum - 1).BackColor = toolsManager.CovertColorStr("#FF99CC");

                                    //设置变动列中的数据格式信息
                                    $.each(BBData.bbData, function (rowIndex, RowData) {
                                        if (RowData[bdFormat.Offset]) {
                                            var cell = RowData[bdFormat.Offset];
                                            for (var i = bdFormat.Offset + addColIndex + 1; i <= bdFormat.Offset + addColIndex + colNum - 1; i++) {
                                                var cellCode = cell["CellCode"];
                                                if (cellCode) {
                                                    var index = i - bdFormat.Offset - addColIndex;
                                                    CellTag = "0;" + JSON2.stringify({ CellCode: cell.CellCode, bdCode: flag, index: index }) + "|" + cell.CellDataType + "|" + JSON2.stringify(cell);;
                                                    gridFrame.Grid1.Cell(rowIndex, i).Tag = CellTag;

                                                    //设置单元格对齐方式
                                                    if (cell.CellDataType == "01") {
                                                        gridFrame.Grid1.Cell(rowIndex, i).Alignment = 4;
                                                    } else if (cell.CellDataType == "02") {
                                                        gridFrame.Grid1.Cell(rowIndex, i).Alignment = 12;
                                                    }
                                                }

                                            }
                                        }
                                    });
                                    //设置增量记录
                                    colChangeFlag[bdFormat.Offset] = colNum - 1;
                                }
                                //                                 gridFrame.Grid1.isPaintSuspended(false);
                                //设置变动列数据
                                if (bdqData && bdqData.length > 0) {
                                    $.each(bdqData, function (bdColIndex, bdCol) {
                                        $.each(BBData.bbData, function (rowIndex, rowData) {
                                            if (rowData[bdFormat.Offset]) {
                                                var cell = rowData[bdFormat.Offset];
                                                var col = bdFormat.Offset + bdColIndex + addColIndex;
                                                if (bdCol && bdCol[cell.CellCode]) {
                                                    gridFrame.GridManager.SetRowColTextByRowCol(rowIndex, col, bdRow[cell.CellCode]);
                                                } else {
                                                    var cellItem = { value: "", cellDataType: cell.CellDataType, isOrNotUpdate: "0" };
                                                    gridFrame.GridManager.SetRowColTextByRowCol(rowIndex, col, cellItem);
                                                }
                                            }

                                        });

                                    });
                                } else {

                                    $.each(BBData.bbData, function (rowIndex, rowData) {
                                        if (rowData[bdFormat.Offset]) {
                                            var cell = rowData[bdFormat.Offset];
                                            var col = bdFormat.Offset + addColIndex;
                                            var rowColCode = cell["CellCode"];
                                            if (rowColCode) {
                                                var cellItem = { value: "", cellDataType: cell.CellDataType, isOrNotUpdate: "0" };
                                                gridFrame.GridManager.SetRowColTextByRowCol(rowIndex, col, cellItem);
                                            }
                                        }
                                    });
                                }
                            }
                        });
                        datestart = new Date();
                        s += "完成赋值" + datestart;
                        if (currentState.ReportCalcuFormat && currentState.ReportCalcuFormat != "") {
                            var vsCalcformula = currentState.ReportCalcuFormat.split(',');
                            for (var i = 0; i < vsCalcformula.length; i++) {
                                gridFrame.Grid1.setFormula(parseInt(vsCalcformula[i].split('$')[0]), parseInt(vsCalcformula[i].split('$')[1]), vsCalcformula[i].split('$')[2]);
                            }
                            /*   var vCalcFormatData = JSON.parse(currentState.ReportCalcuFormat);
                            $.each(vCalcFormatData.data.dataTable, function (rowIndex, row) {
                            $.each(row, function (colIndex, cell) {
                            if (cell.formula) {
                            gridFrame.Grid1.setFormula(parseInt(rowIndex), parseInt(colIndex), cell.formula);
                            }
                            });
                            });*/
                        }
                        else {
                            if (currentState.ReportFormat && currentState.ReportFormat != "") {
                                var vCalcFormatData = JSON.parse(currentState.ReportFormat);
                                $.each(vCalcFormatData.data.dataTable, function (rowIndex, row) {
                                    $.each(row, function (colIndex, cell) {
                                        if (cell.formula) {
                                            for (var i = vsKSRow; i <= vsRowNum; i++) {
                                                var newF = cell.formula;
                                                var reg = new RegExp("/\D+\d+", "g");
                                                var array = cell.formula.match(/[A-Za-z]+\d+/g);
                                                for (var j = 0; j < array.length; j++) {
                                                    var one = array[j];
                                                    var rowReg = /\d+/.exec(one);
                                                    if (rowReg) {
                                                        var rowIndex = parseInt(rowReg[0]) - 1;
                                                        var colIndexStr = /[A-Za-z]+/.exec(one);
                                                        if (colIndexStr) {
                                                            colIndexStr = colIndexStr[0];
                                                            var colIndexInt = convertToIndex(colIndexStr);
                                                            var tag = gridFrame.Grid1.getTag(rowIndex, colIndexInt);
                                                            if (tag && tag.indexOf("0;") == 0) {
                                                                //变动行
                                                                newF = newF.replace(one, colIndexStr +( i+1));
                                                            }
                                                        }
                                                       
                                                    }
                                                    
                                                } 
                                                gridFrame.Grid1.setFormula(parseInt(i), parseInt(colIndex), newF); //cell.formula.replace(/\d+/g, i)
                                            }

                                        }
                                    });
                                });
                            }
                        }

                        gridFrame.Grid1.isPaintSuspended(false);
                        //                         gridFrame.Grid1.isPaintSuspended(true);
                        //                         for (var i = 0; i < gridFrame.Grid1.getRowCount(); i++) {

                        //                             for (var j = 0; j < gridFrame.Grid1.getColumnCount(); j++) {
                        //                                 var tag = gridFrame.Grid1.getTag(i, j);
                        //                                 mediatorManager.TextChange(i, j, tag);
                        //                             }

                        //                         }
                        //                         gridFrame.Grid1.isPaintSuspended(false);
                        //设置报表状态

                        currentState.IsOrNotWriteLock = data.obj.IsOrNotLock;
                        mediatorManager.SetReportState(data.obj.IsOrNotLock);
                        //附加报表状态
                        if (data.obj.rdps.ReportId != "home") {
                            var state = ""
                            if (data.obj.IsOrNotLock == "0") {
                                state = "(只读)";
                            } else if (data.obj.IsOrNotLock == "1") {
                                state = "(可写)";
                            }
                            var tab = liger.get("ReportsTab");
                            var report = {};
                            for (var i = 0; i < currentState.TabDatas.length; i++) {
                                if (currentState.TabDatas[i].Id == data.obj.rdps.ReportId) {
                                    report = currentState.TabDatas[i];
                                    break;
                                }
                            }
                            tab.setHeader(data.obj.rdps.ReportId, report.bbName + state);
                        }



                    }

                    $(".l-tab-content").css("display", "none");
                    $("#LoadInf").css("display", "none");
                    $("#LoadAll").css("display", "none");
                    datestart = new Date();
                    s += "完成" + datestart;
                    // alert(s);
                } else {
                    alert(data.sMeg);
                }
            }, SaveReport_Success: function (data) {
                if (data.success) {
                    if (data.obj) {
                        BBDataItems = data.obj;
                    }

                    alert(data.sMeg);
                } else {
                    alert(data.sMeg);
                }
            },
            DeleteReport_Success: function (data) {
                if (data.success) {

                    alert(data.sMeg);
                } else {
                    alert(data.sMeg);
                }
            },
            DesrializeFatchFormular_Success: function (data) {

                if (data.success) {
                    mediatorManager.LoadBBFormat();
                    mediatorManager.LoadBbData();
                    alert(data.sMeg);
                } else {
                    alert(data.sMeg);
                }
                //  top.loader && top.loader.close();
            },
            DeserializeCaculateFormular_Success: function (data) {


                if (data.success) {
                    mediatorManager.LoadBBFormat();
                    mediatorManager.LoadBbData();
                    alert(data.sMeg);
                } else {
                    alert(data.sMeg);
                }
                //    top.loader && top.loader.close();
            },
            DeserializeVerifyFormular_Success: function (data) {

                if (data.success) {
                    if (data.sMeg == "校验成功") {
                        alert(data.sMeg);
                    } else {
                        tabManager.CheckOutInfManager.getDataByMessage(data.sMeg);
                        tabManager.CheckOutInfManager.LoadInfFrame();
                        alert("校验失败");
                    }
                } else {
                    alert(data.sMeg);
                }
                //   top.loader && top.loader.close();
            },
            SelfCheck_Success: function (data) {
                if (data.success) {
                    alert(data.sMeg);
                } else {
                    alert(data.sMeg);
                }
            },
            CancelSelfCheck_Success: function (data) {
                if (data.success) {
                    alert(data.sMeg);
                } else {
                    alert(data.sMeg);
                }
            },
            RemoveReadWriteLock_Success: function (data) {
                if (data.success) {

                } else {
                    alert(data.sMeg);
                }
            },
            LoadVerifyInf_Success: function (data) {
                if (data.success) {
                    InfoIframControl.Created = true;
                    InfoIframControl.InfData = data.obj;
                    //alert(JSON2.stringify(data.obj))
                    tabManager.CheckOutInfManager.LoadInfFrame();
                }
                else {
                    alert(data.sMeg);
                }
            },
            LoadLinkInf_success: function (data) {
                if (data.success) {
                    //InfoIframControl.LinkInfData = data.obj;
                    var InfoFrame = toolsManager.GetInfoframe();
                    InfoFrame.LoadLinkInf(data.obj);
                } else {
                    alert(data.sMeg);
                }
            }
        };
        var tabManager = {
            FirstLoadTabs: function (data) {
                currentState.navigatorData.auditReports = data;
                tabManager.InitializeCatalog(tabManager.LoadCatalogDatas, data);
            },
            RemoveReports: function (auditPaperId) {
                var reportData = currentState.navigatorData.auditReports[auditPaperId];
                $.each(reportData, function (index, item) {
                    if (item.tabid != "home") {
                        controls.AuditReportTab.removeTabItem(item.tabid);
                    }

                });

            },
            LoadReports: function (auditPaperId) {
                var reportData = currentState.navigatorData.auditReports[auditPaperId];
                if (!reportData) return;
            },
            LoadCatalogDatas: function (data) {
                try {
                    var catalogFrame = toolsManager.GetReportIframe();

                    if (catalogFrame.LoadData) {
                        catalogFrame.LoadData(data);
                    } else {
                        catalogFrame.onload = catalogFrame.onreadystatechange = function () {
                            if (this.readyState && this.readyState != 'complete') return;
                            else {
                                catalogFrame.LoadData(data);
                            }
                        }
                    }

                } catch (err) {
                    alert(err.Message);
                }
            },
            InitializeCatalog: function (func, parameter) {
                try {

                    $("#catalog").css("display", "block");
                    $("#report").css("display", "none");
                    var catalogFrame = toolsManager.GetReportIframe();
                    if (catalogFrame.LoadData && func) {
                        func(parameter);
                    } else {
                        catalogFrame.onload = catalogFrame.onreadystatechange = function () {
                            if (this.readyState && this.readyState != 'complete') return;
                            else if (func) {
                                func(parameter);
                            }
                        }
                    }
                } catch (err) {
                    alert(err.Message);
                }
            },
            AddReport: function (item, report) {

                //top.loader && top.loader.open();

                
                currentState.TabDatas.push(report);
                controls.AuditReportTab.addTabItem(item);


            },
            CheckOutInfManager: {
                LoadInfFrame: function () {
                    var InfoFrame = toolsManager.GetInfoframe();
                    tabManager.CheckOutInfManager.LoadInfData();
                },
                LoadInfData: function () {
                    var InfoFrame = toolsManager.GetInfoframe();
                    if (InfoIframControl.Collapse) {
                        InfoFrame.Collapse();
                    }
                    InfoFrame.LoadDataGrid(InfoIframControl.InfData);
                },
                CollapseState: function (Collapse) {
                    InfoIframControl.Collapse = Collapse;
                    var width = document.body.clientHeight;
                    var height = document.body.clientHeight;
                    var gridIframe = toolsManager.GetGridIframe();
                    if (Collapse) {
                        gridIframe.ChangeHeight(height - 80);
                        $("#checkoutInfo").css("height", "32px");
                    } else {
                        if (!InfoIframControl.Created) {
                            tabManager.CheckOutInfManager.getDataById();
                        }
                        if (InfoIframControl.cellCode) {
                            tabManager.LinkManager.loadLinkInf();
                        }
                        gridIframe.ChangeHeight(height - 193);
                        $("#checkoutInfo").css("height", "145px");
                    }
                },
                getDataByMessage: function (message) {
                    var data = message.split("|");
                    var InfData = [];
                    $.each(data, function (index, node) {
                        var temp = node.split(";");
                        temp[0] = temp[0].substr(1, temp[0].length - 2);
                        var row = { FormularContent: temp[0], Problem: temp[1] };
                        InfData.push(row);
                    });
                    InfoIframControl.Created = true;
                    InfoIframControl.InfData = InfData;
                },
                getDataById: function () {
                    var parameter = toolsManager.GetReportParameter();
                    parameter = CreateParameter(ReportDataAction.ActionType.Post, ReportDataAction.Functions.FillReport, ReportDataAction.Methods.FillReportMethods.GetListVerifyProblemEntities, parameter);
                    DataManager.sendData(urls.fillReportUrl, parameter, resultManager.LoadVerifyInf_Success, resultManager.FailResult);
                }
            },
            LinkManager: {
                loadLinkInf: function () {
                    if (!InfoIframControl.cellCode) return;
                    var para = { ReportId: currentState.navigatorData.currentReportId, IndexCode: InfoIframControl.cellCode }
                    para = CreateParameter(ReportFormatAction.ActionType.Post, ReportFormatAction.Functions.ReportLinkAction, ReportFormatAction.Methods.ReportLinkMethods.GetReportLinkList, para);
                    DataManager.sendData(urls.BBUrl, para, resultManager.LoadLinkInf_success, resultManager.fail, true);
                },
                setLinkInf: function () {
                    var InfoFrame = toolsManager.GetInfoframe();
                    InfoFrame.LoadLinkInf(InfoIframControl.LinkInfData);
                }
            }
        };
        window.onresize = (function () {
            LayoutManager.setTreeHeight();
            LayoutManager.FitHomeHeight();
        });
        var LayoutManager = {
            setTreeHeight: function () {
                var tootl = document.body.clientHeight;
                document.getElementById("treeTable").style.height = tootl - 175;
            },
            FitHomeHeight: function () {
                var gridIframe = toolsManager.GetGridIframe();
                var height = document.body.clientHeight - 50;
                if (InfoIframControl.Collapse) {
                    $("#content").css("height", height - 30);
                    gridIframe.ChangeHeight(height - 30);
                } else {
                    gridIframe.ChangeHeight(height - 143);
                }
            },
            hideMenu: function () {

                var menuBar = liger.get("menuBar");
                var items = menuBar.get("items");
                var fielMenu = items[0].menu;
                fielMenu.hide();
                var sealMenu = items[4].menu;
                sealMenu.hide();
            }
        };

        function setHyperLinkValue(Grid, row, col, value) {
            if (value && value.length > 0) {
                var o = Grid.getCell(row, col);
            }
        }
        function GetQueryString(name) {
            var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
            var r = window.location.search.substr(1).match(reg);
            if (r != null) return (r[2]); return null;
        }
    </script>

</head>
<body style="overflow: hidden">
    <div id="menuTop" class="menuTop">
        <div id="menuBar">
        </div>
    </div>
    <div id="layout" onmouseover="LayoutManager.hideMenu()">
        <div position="left" title="导航">
            <div id="zqDiv" class="LeftZq">
            </div>

            <div id="Div1" class="l-layout-header" style="clear: both;">组织机构</div>

            <div id="treeTable" style="overflow-y: auto; overflow-x: auto">
                <ul id="tree1" style="margin: 0; width: 100%;"></ul>

                <%--  <div id="companies" class="LeftCompanies">
              <ul id="tree1"></ul>

            </div>--%>
            </div>
        </div>
        <div position="center">
            <%--         <div id="AuditPaperTab" class="AuditPaperTab">
                <div title="审计底稿" tabid="tab1"></div>  
            </div>--%>
            <div id="ReportsTab" class="ReportsTab">
                <div title="目录" tabid="home"></div>
            </div>
            <div id="report" style="width: 100%; height: 100%;">
                <div id="Tool" class="l-layout-header">
                    <input id="rowColInput" type="text" class="ctTextInput" style="float: left;" />
                    <span style="color: #A1A1A1; font-size: 16px; float: left; line-height: 16px; margin: 2px; text-align: center; vertical-align: middle;">|</span>
                    <div id="InsertRowBtn" style="display: none">
                    </div>
                    <div id="DeleteRowBtn" style="display: none">
                    </div>
                    <div id="ReportAttatch">
                    </div>
                    <input id="txtSearch" type="text" class="ctTextInput" style="float: left;" />
                    <div id="ReportSearch">
                    </div>
                    <div id="clearReportSearch"></div>
                </div>
                <div id="content" class="Content">
                    <iframe id="gridFrame" src="Cell.aspx" height="100%" width="100%" frameborder="0"></iframe>
                </div>
            </div>
            <iframe id="catalog" src="Catalog.htm" height="100%" width="100%" frameborder="0" style="display: block"></iframe>
            <div id="footer" style="text-align: center; padding: 0;">
                <hr style="width: 100%" />
                <img id="imgFooter" src="../../Styles/images/icon-up.gif" />
            </div>
            <div id="InfoIframe" style="display: none;">
                <div id="checkoutInfo" style="height: 32px; width: 100%; bottom: 0px; position: absolute;">
                    <iframe id="CheckoutInfoIframe" src="ReportVarifyInfo.aspx" height="100%" width="100%" frameborder="0"></iframe>
                </div>
            </div>
        </div>
        <div position="bottom" style="text-align: center;">
            <a href="#" id="taskBtn">审计任务切换</a>&nbsp <span>审计类型:</span><span id="auditTaskTypeSpan"></span>&nbsp <span>审计任务:</span><span id="auditTaskSpan"></span>&nbsp <span>审计底稿:</span><span id="auditPaperSpan"></span>&nbsp <span>审计周期:</span><span id="auditDateSpan"></span>

        </div>
    </div>
    <div id="s">
        <table style="margin: 12px; margin-left: 30px;">
            <tr>
                <td style="width: 50px">
                    <img src='../../images/ReportData/loading.gif' alt="" style="width: 40px; height: 40px" />
                </td>
                <td>
                    <span style="margin-left: 15px; color: #3C3C3C" id="pointSpan">正在加载，请稍等</span>
                </td>
            </tr>
        </table>
        <div id="container">
            <div id="topLoader">
            </div>

            <button id="animateButton">Animate Loader</button>


        </div>
    </div>
</body>
</html>
