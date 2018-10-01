<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReportAggregationDataShow.aspx.cs" Inherits="Audit.ct.ReportData.ReportAggregation.ReportAggregationDataShow" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head >
    <title>报表汇总资料查看</title>
      <meta http-equiv="X-UA-Compatible" content="IE=10" />
     <meta http-equiv="X-UA-Compatible" content="IE=9" />
     <meta http-equiv="X-UA-Compatible" content="IE=8" />
     <meta http-equiv="X-UA-Compatible" content="IE=7" />


      <link rel="stylesheet" href="../../../lib/SpreadCSS/gcspread.sheets.excel2013white.9.40.20153.0.css" title="spread-theme" />
      <script type="text/javascript" src="../../../lib/jquery/jquery-1.11.1.min.js"></script>
    <script src="../../../lib/jquery/jquery-ui-1.10.3.custom.min.js" type="text/javascript"></script>
     <script type="text/javascript" src="../../../lib/SpreadJS/gcspread.sheets.all.9.40.20153.0.min.js"></script>
     <script type="text/javascript" src="../../../lib/SpreadJS/gcspread.sheets.print.9.40.20153.0.min.js"></script>
      <script type="text/javascript" src="../../../lib/SpreadJS/FileSaver.min.js"></script>
    <script type="text/javascript" src="../../../lib/SpreadJS/resources.js"></script>
     <script type="text/javascript" src="../../../lib/SpreadJS/bootstrap.min.js"></script>


    <script src="../../../lib/jquery/jquery-1.3.2.min.js" type="text/javascript"></script>
      <script src="../../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script src="../../../Scripts/AjaxTrigger.js" type="text/javascript"></script>

    <script src="../../../lib/ligerUI/js/core/base.js" type="text/javascript"></script>
    <script src="../../../lib/ligerUI/js/core/inject.js" type="text/javascript"></script>
    <script src="../../../lib/ligerUI/js/plugins/CT_ligerGrid.js" type="text/javascript"></script>
    <script src="../../../lib/ligerUI/js/plugins/ligerLayout.js" type="text/javascript"></script>
    <script src="../../../lib/ligerUI/js/plugins/ligerToolBar.js" type="text/javascript"></script>
    <link href="../../../lib/ligerUI/skins/Aqua/css/ligerui-all.css" rel="stylesheet"type="text/css" />
    <link href="../../../lib/ligerUI/skins/ligerui-icons.css" rel="stylesheet" type="text/css" />
    <script src="../../../Scripts/Ct_Tool.js" type="text/javascript"></script>
    <script src="../../../lib/Base64.js" type="text/javascript"></script>
    <script src="../../../lib/json2.js" type="text/javascript"></script>
    
    <link href="../../../Styles/Ct_Controls.css" rel="stylesheet" type="text/css" />
    <script src="../../../Scripts/Ct_Controls.js" type="text/javascript"></script>

        <script type="text/javascript">

            var spreadNS;
            var spread;
            var Grid1;

            var currentState = { currentWidth: 0, controlWidth: 0, paras: {}, bbFormat: {}, bbData: {}, reportAudit: {}, currentProblemId: "", currentCellInfo: "" };
            var controls = { IndexCell: {} ,InViewingCell:{}};
            var urls = {
                reportAuditUrl: "../../../handler/ReportDataHandler.ashx",
                cellDataUrl:"../../ReportAudit/IndexTrend.aspx",
                IndexTrendUrl:"../../ReportAudit/IndexTrend.aspx"
            };
            $(function () {
                var height = $(window).height() - 360;
                $("#layout1").ligerLayout({ allowRightCollapse: true, topHeight: 25, space: 2, rightWidth: 450, onEndResize: function () { if (Grid1) { spread.refresh(); } } });
               // $("#layout1").ligerLayout({ allowRightCollapse: true, allowRightResize: true, isRightCollapse: false, rightWidth: 370, onEndResize: formularManager.BalanceIfManager.LoadFormularGrid });
                $("#toolBar").ligerToolBar({ items: [
                    {
                        text: '打印', click: function (item) {
                            Grid1.DirectPrint();
                        }, icon: 'print'
                    },
                    { line: true },
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
                $("#DownLoadIndex").Btn({ text: "导出相关信息", click: IndexActionManager.IndexDownLoad, icon: "Excel" })
                controls.IndexGrid = $("#IndexGrid").ligerGrid({
                    columns: [
                    { display: '主键', name: 'Id', align: 'left', width: 15, hide: true },
                { display: '单位', name: 'name', width: 200, align: 'left' },
                { display: '指标值', name: 'value', width: 100 }
                    ], sortName: 'CreateTime',
                    width: '99%', height: height,
                    rownumbers: true,
                    data: { Rows: []
                    },
                    toolbarShowInLeft: false,
                    resizable: true
                });

               

                spreadNS = GcSpread.Sheets;
                spread = new spreadNS.Spread($("#ss")[0]);
                spread.setTabStripRatio(0.88);
                Grid1 = new spreadNS.Sheet("Cell");
                // Grid1.setIsProtected(true); //是否锁定
                spread.removeSheet(0);
                spread.addSheet(spread.getSheetCount(), Grid1);

                Grid1.isPaintSuspended(true);
                Grid1.setColumnCount(8);
                Grid1.setRowCount(9);
                Grid1.isPaintSuspended(false);
              

                var paras = $("#parameter").val();
                if (paras) {
                   // gridManager.InitializeGrid();
                    paras = Base64.decode(paras);
                    controls.parameter = JSON2.parse(paras);
                    var parameter = { TaskId: controls.parameter.TaskId, PaperId: controls.parameter.PaperId, CompanyId: controls.parameter.CompanyId, ReportId: controls.parameter.ReportId, Year: controls.parameter.Year, Cycle: controls.parameter.Cycle };
                    parameter = CreateParameter(ReportDataAction.ActionType.Post, ReportDataAction.Functions.ReportAggregation, ReportDataAction.Methods.ReportAggregationMethods.GetReportData, parameter);
                    gridManager.LoadData(parameter, urls.reportAuditUrl);
                }



            });
            function InitializeFlexCell(row, col) {

                if (Grid1) {
                    Grid1.isPaintSuspended(true);
                    Grid1.setColumnCount(col);
                    Grid1.setRowCount(row);
                    Grid1.isPaintSuspended(false);
                    spread.refresh();
                }

            }
            var CommunicationManager = {
                SetIndexTrend: function (TrendData) {
                    var data = { series: { XSeries: [], series: [{ seriesData: [null]}] }, Name: "指标名", Code: "单元格编号" };
                    var IndexTrendIframe = window.frames["IndexTrend"];
                    if (TrendData) {
                        for (var i = 0; i < TrendData.series.length; ++i) {
                            TrendData.series[i].Name = controls.IndexCell[i].Name;
                            TrendData.series[i].Code = controls.IndexCell[i].Code;
                        }
                        IndexTrendIframe.addSeries(TrendData);
                    } else {
                        IndexTrendIframe.loadData(data);
                    }
                },
                ClickCell: function () {
                    var cells = [];
                    var cellType = {}; //记录单元格种类：gdh,bdh 

                    var sels = Grid1.getSelections();
                    var endRow;
                    var endCol;

                    endRow = Grid1.getActiveRowIndex() + sels[0].rowCount - 1; // Grid1.Selection.LastRow;
                    endCol = Grid1.getActiveColumnIndex() + sels[0].colCount - 1; //Grid1.Selection.LastCol;

                    for (var i = Grid1.getActiveRowIndex(); i <= endRow; i++) {
                        for (var j = Grid1.getActiveColumnIndex(); j <= endCol; j++) {
                            if (Grid1.getTag(i, j) && Grid1.getTag(i, j) != "") {
                                var cell = { Code: "", Name: "", DataType: "" };
                                var codeData = Grid1.getTag(i, j).split("|");
                                var cellData;
                                if (codeData[2]) {
                                    cellData = JSON2.parse(codeData[2]);
                                }
                                var TagData = codeData[0].split(";");
                                if (TagData[0] == "0") {
                                    cellType["bdq"] = true;
                                    cell.Code = cellData.CellCode;
                                    cell.Name = cellData.CellName;
                                    cell.DataType = cellData.CellDataType;
                                    cell.BdPrimary = CommunicationManager.CreateBdPrimary(TagData[2], i, j);
                                } else if (TagData[0] == "1") {
                                    cellType["gdq"] = true;
                                    cell.Code = cellData.CellCode;
                                    cell.Name = cellData.CellName;
                                    cell.DataType = cellData.CellDataType;
                                }
                                if (cell.Code) {
                                    cells.push(cell);
                                }
                            }
                        }
                    }
                    if (cellType.bdq) {
                        if (cellType.gdq) {
                            alert("不支持跨区域指标查看");
                            return;
                        } else {
                            //计算变动区的数量
                            var Bdq = {};
                            $.each(cells, function (index, cell) {
                                var offset = cell.Code.substring(0, 4);
                                if (index == 0) {
                                    Bdq[offset] = offset;
                                    Bdq.length = 1;
                                } else if (Bdq[offset] != offset) {
                                    Bdq.length = 2;
                                    return false;
                                }
                            });
                            if (Bdq.length == 2) {
                                alert("不支持跨区域指标查看");
                                return;
                            }
                        }
                    }
                    if (cells.length > 5) {
                        alert("同时查看的指标数应不大于5个");
                        return;
                    }
                    var zq = currentState.bbFormat.zq.split(":");
                    CommunicationManager.ClickedCell(cells, zq[0]);
                    
                },
                ClickedCell: function (cells, ReportType) {
                    if (cells.length > 0) {
                        controls.IndexCell = [];
                        var cellData = [];
                        var cellParam = { TaskId: controls.parameter.TaskId, PaperId: controls.parameter.PaperId, CompanyId: controls.parameter.CompanyId, ReportId: controls.parameter.ReportId, Year: controls.parameter.Year, Cycle: controls.parameter.Cycle, ReportType: ReportType, CellCode: "", BdPrimary: "" };
                        $.each(cells, function (index, cell) {
                            if (cell.DataType == "02") {
                                cellParam.CellCode += cell.Code + ",";
                                if (cell.BdPrimary) {
                                    cellParam.BdPrimary += cell.BdPrimary + ";";
                                    controls.IndexCell.push({ Name: cell.Name, Code: cell.Code, BdPrimary: cell.BdPrimary });
                                } else {
                                    cellParam.BdPrimary += ";";
                                    controls.IndexCell.push({ Name: cell.Name, Code: cell.Code, BdPrimary: "" });
                                }
                            }
                        });
                        if (cellParam.CellCode.length > 0) {
                            cellParam.CellCode = cellParam.CellCode.substring(0, cellParam.CellCode.length - 1);
                            cellParam.BdPrimary = cellParam.BdPrimary.substring(0, cellParam.BdPrimary.length - 1);

                            IndexActionManager.LoadTrend(cellParam);

                            cellParam.TemplateId = controls.parameter.TemplateId;
                            IndexActionManager.LoadValue(cellParam);
                            controls.InViewingCell = cellParam;
                        } else {
                            CommunicationManager.nullCell();
                        }
                    } else {
                        CommunicationManager.nullCell();
                    }
                },
                ///组织 BdPrimary
                CreateBdPrimary: function (bdqCode, rowIndex, colIndex) {
                    var OffsetRowCol;
                    var Primaries = [];
                    var BdPrimary = "";
                    var bdFormat = currentState.bbFormat.bdq.Bdqs[currentState.bbFormat.bdq.BdqMaps[bdqCode]];
                    if (bdFormat.BdType == "1") {
                        OffsetRowCol = currentState.bbFormat.bbData[bdFormat.Offset];
                        $.each(OffsetRowCol, function (index, node) {
                            if (node.CellPrimary == "1") {
                                var PrimariesCell = Grid1.getCell(rowIndex, node.CellCol);
                                var CellData = { CellCode: node.CellCode, Value: PrimariesCell.value() };
                                Primaries.push(CellData);
                            }
                        });
                    } else if (bdFormat.BdType == "2") {
                        $.each(currentState.bbFormat.bbData, function (index, RowData) {
                            if (RowData[bdFormat.Offset]) {
                                if (RowData[bdFormat.Offset].CellPrimary == "1") {
                                    var PrimariesCell = Grid1.Cell(RowData[bdFormat.Offset].CellRow, colIndex);
                                    var CellData = { CellCode: RowData[bdFormat.Offset].CellCode, Value: PrimariesCell.Text };
                                    Primaries.push(CellData);
                                }
                            }
                        });
                    }
                    $.each(Primaries, function (index, node) {
                        BdPrimary += node.CellCode + ":" + node.Value + ",";
                    });
                    BdPrimary = BdPrimary.substring(0, BdPrimary.length - 1);
                    return BdPrimary;
                },
                nullCell: function () {
                    CommunicationManager.SetIndexTrend();
                    var columns = [{ display: '主键', name: 'Id', align: 'left', width: 15, hide: true },
                                       { display: '单位', name: 'Name', width: 200, align: 'left' },
                                        { display: '指标值', name: 'value', width: 100 }
                                       ];
                    controls.IndexGrid.set("columns", columns);
                    controls.IndexGrid.loadData({ Rows: [] });
                    controls.InViewingCell = {};
                }
        
            };
            var resultManager = {
                successLoadTrendData: function (data) {
                    if (data.success) {
                        CommunicationManager.SetIndexTrend(data.obj);
                    } else {
                        alert(data.sMeg);
                    }
                },
                successLoadCellConstitute: function (data) {
                    if (data.success) {
                        var gridData = [];
                        var columns = [{ display: '主键', name: 'Id', align: 'left', width: 10, hide: true },
                                       { display: '单位', name: 'Name', width: 200, align: 'left', type: 'string' }
                                       ];
                        //整理 数据
                        $.each(data.obj, function (index, node) {
                            var indexNode = { Id: node.id, Name: node.name };
                            for (var i = 0; i < controls.IndexCell.length; ++i) {
                                if (node.values[controls.IndexCell[i].Code + controls.IndexCell[i].BdPrimary] != undefined && node.values[controls.IndexCell[i].Code + controls.IndexCell[i].BdPrimary] != "") {
                                    indexNode[i.toString()] = (node.values[controls.IndexCell[i].Code + controls.IndexCell[i].BdPrimary]).toString();
                                } else {//[controls.IndexCell[i].Code + controls.IndexCell[i].BdPrimary]
                                    indexNode[i.toString()] = "0";
                                }
                            }
                            gridData.push(indexNode);
                        });
                        //设置列
                        for (var i = 0; i < controls.IndexCell.length; ++i) {
                            var filed = i.toString()//controls.IndexCell[i].Code + controls.IndexCell[i].BdPrimary;
                            var title = controls.IndexCell[i].Name + "(" + controls.IndexCell[i].Code + controls.IndexCell[i].BdPrimary + ")";
                            var column = { name: filed, display: title, width: 170, align: 'left', type: 'int' };
                            columns.push(column);
                        }
                        controls.IndexGrid.set("columns", columns);
                        controls.IndexGrid.loadData({ Rows: gridData });
                        controls.IndexGrid.reRender();
                    } else {
                        alert(data.sMeg);
                    }
                },
                fail: function (data) {
                    alert(data.toString);
                }
            };
            var IndexActionManager = {
                LoadTrend: function (cellParam) {
                    var parameter = CreateParameter(ReportDataAction.ActionType.Post, ReportDataAction.Functions.ReportAggregation, ReportDataAction.Methods.ReportAggregationMethods.GetReportCellDataTrend, cellParam);
                    DataManager.sendData(urls.reportAuditUrl, parameter, resultManager.successLoadTrendData, resultManager.fail);
                },
                LoadValue: function (cellParam) {
                    var parameter = CreateParameter(ReportDataAction.ActionType.Post, ReportDataAction.Functions.ReportAggregation, ReportDataAction.Methods.ReportAggregationMethods.GetAggregationReportCellConstitute, cellParam);
                    DataManager.sendData(urls.reportAuditUrl, parameter, resultManager.successLoadCellConstitute, resultManager.fail);
                },
                IndexDownLoad: function () {
                    var cellParam = controls.InViewingCell;
                    if (cellParam.CellCode) {
                        cellParam.ActionType = ReportDataAction.ActionType.Get;
                        cellParam.MethodName = ReportDataAction.Methods.ReportAggregationMethods.ExportAggregationCellConstitute;
                        cellParam.FunctionName = ReportDataAction.Functions.ReportAggregation;
                        var paraStr = "";
                        for (var key in cellParam) {
                            if (paraStr == "") {
                                paraStr = paraStr + "?" + key + "=" + cellParam[key];
                            } else {
                                if (cellParam[key] != "") {
                                    paraStr = paraStr + "&" + key + "=" + cellParam[key];
                                }
                            }
                        }
                        if (!cellParam.BdPrimary) {
                            paraStr = paraStr + "&BdPrimary=";
                        }
                        window.location = urls.reportAuditUrl + paraStr;
                    } else {
                        alert("所选指标无可导出数据！");
                    }
                }
            };
            window.onresize = function () {

                if (document.documentElement.clientWidth > 800) {
                    document.body.style.width = document.documentElement.clientWidth + "px";
                } else {
                    document.body.style.width = "800px";
                }

                var height = $(window).height() - 360;
                controls.IndexGrid.set("height", height);


            }

            var ReportData = {};
            var gridManager = {
                InitializeGrid: function () {
                    //表格初始

                },
                LoadData: function (para, url) {

                    DataManager.sendData(url, para, gridManager.Success, gridManager.Success, true);
                },
                Success: function (data) {
                    if (data.success) {
                        try {
                            if (data.obj.reportFormat == "") return;
                            var bbFormat = data.obj.reportFormat.formatStr;
                            Grid1.fromJSON(JSON.parse(bbFormat));
                            InitializeFlexCell(Grid1.getRowCount(), Grid1.getColumnCount());
                            Grid1.isPaintSuspended(true);
                            for (var i = 0; i < Grid1.getRowCount(); i++) {
                                for (var j = 0; j < Grid1.getColumnCount(); j++) {
                                    Grid1.setTag(i, j, "");
                                    Grid1.getCell(i, j).backColor(undefined);

                                }
                            }
                            currentState.bbFormat = JSON2.parse(data.obj.reportFormat.itemStr);
                            $.each(currentState.bbFormat.bbData, function (rowIndex, row) {
                                $.each(row, function (colIndex, cell) {
                                    if (cell && cell.CellLogicalType && cell.CellLogicalType == "02" && cell.CellDataType && cell.CellDataType != "") {
                                        Grid1.setValue(rowIndex, colIndex, "");
                                        //Grid1.Cell(rowIndex, colIndex).Text = "";
                                        var flag = toolsManager.IsOrNotBdq(rowIndex, colIndex);
                                        if (flag == "-1") {
                                            CellTag = "1;" + cell.CellCode + "|" + cell.CellDataType + "|" + JSON2.stringify(cell);
                                        } else {
                                            CellTag = "0;" + cell.CellCode + ";" + flag + "|" + cell.CellDataType + "|" + JSON2.stringify(cell);
                                        }
                                        Grid1.setTag(rowIndex, colIndex, CellTag);

                                        if (cell.CellLock == "1") {
                                            Grid1.getCell(rowIndex, colIndex).locked(true);

                                        }
                                    } else {
                                        Grid1.getCell(rowIndex, colIndex).locked(false);

                                    }
                                });
                            });

                            //点击事件绑定
                            if (Grid1.bind) {
                                Grid1.bind(spreadNS.Events.SelectionChanged, gridManager.RowColChange_Event);

                            }

                            //加载报表数据
                            currentState.bbData = data.obj.reportData;
                            //固定表数据
                            $.each(currentState.bbData.Gdq, function (cellCode, CellItem) {
                                gridManager.SetRowColText(CellItem);
                            });
                            //变动表数据
                            var rowChangeFlag = {};
                            var colChangeFlag = {};
                            $.each(currentState.bbData.BdqData, function (bdqIndex, bdqData) {
                                var bdqCode = currentState.bbData.bdIndexMaps[bdqIndex.toString()];
                                var bdFormat = currentState.bbFormat.bdq.Bdqs[currentState.bbFormat.bdq.BdqMaps[bdqCode]];


                                if (bdFormat.BdType == "1") {
                                    var rowNum = bdqData.length;
                                    //变动行
                                    var addRowData = 0;
                                    $.each(rowChangeFlag, function (index, item) {
                                        if (index < bdFormat.Offset) {
                                            addRowData += item;
                                        }

                                    });
                                    if (rowNum > 1) {
                                        
                                        Grid1.addRows(bdFormat.Offset + 1 + addRowData, rowNum - 1);
                                        //设置变动行中的数据格式信息
                                        $.each(currentState.bbFormat.bbData[bdFormat.Offset], function (columnIndex, cell) {
                                            for (var i = bdFormat.Offset  + addRowData; i <= bdFormat.Offset + rowNum - 1 + addRowData; i++) {
                                                var cellCode = cell.CellCode;
                                                CellTag = "0;" + cellCode + ";" + bdqCode + "|" + cell.CellDataType + "|" + JSON2.stringify(cell);

                                                Grid1.setTag(i, columnIndex, CellTag);
                                                //设置单元格对齐方式
                                                var align;
                                                if (cell.CellDataType == "01") {
                                                    align = spreadNS.HorizontalAlign["left"];
                                                    Grid1.getCell(i, columnIndex)["hAlign"](align);

                                                } else if (cell.CellDataType == "02") {
                                                    align = spreadNS.HorizontalAlign["right"];
                                                    Grid1.getCell(i, columnIndex)["hAlign"](align);

                                                }
                                            }
                                        });
                                        //设置增量记录
                                        rowChangeFlag[bdFormat.Offset] = rowNum - 1;

                                    }

                                    //设置变动行数据
                                    if (bdqData && bdqData.length > 0) {
                                        $.each(bdqData, function (bdRowIndex, bdRow) {
                                            $.each(currentState.bbFormat.bbData[bdFormat.Offset], function (columnIndex, cell) {
                                                var row = bdFormat.Offset + bdRowIndex + addRowData;
                                                if (bdRow && bdRow[cell.CellCode]) {
                                                    gridManager.SetRowColTextByRowCol(row, columnIndex, bdRow[cell.CellCode], cell);
                                                } else {
                                                    var cellItem = { value: "", cellDataType: cell.CellDataType, isOrNotUpdate: "0" };
                                                    gridManager.SetRowColTextByRowCol(row, columnIndex, cellItem, cell);
                                                }
                                            });

                                        });
                                    } else {

                                        $.each(currentState.bbFormat.bbData[bdFormat.Offset], function (columnIndex, cell) {
                                            var row = bdFormat.Offset + addRowData;
                                            var cellItem = { value: "", cellDataType: cell.CellDataType, isOrNotUpdate: "0" };
                                            gridManager.SetRowColTextByRowCol(row, columnIndex, cellItem, cell);

                                        });
                                    }
                                } else if (bdFormat.BdType == "2") {
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
                                        
                                        Grid1.InsertCol(bdFormat.Offset + 1 + addColIndex, colNum - 1);
                                        Grid1.Range(1, bdFormat.Offset + 1 + addColIndex, Grid1.Rows - 1, bdFormat.Offset + colNum - 1 + addColIndex).BackColor = toolsManager.CovertColorStr("#FF99CC");
                                        //设置变动列中的数据格式信息
                                        $.each(currentState.bbFormat.bbData, function (rowIndex, RowData) {
                                            if (RowData[bdFormat.Offset]) {
                                                var cell = RowData[bdFormat.Offset];
                                                for (var i = bdFormat.Offset + 1 + addColIndex; i <= bdFormat.Offset + colNum - 1 + addColIndex; i++) {
                                                    var cellCode = cell.CellCode;
                                                    CellTag = "0;" + cellCode + ";" + bdqCode + "|" + cell.CellDataType + "|" + JSON2.stringify(cell);
                                                    Grid1.Cell(rowIndex, i).Tag = CellTag;

                                                    //设置单元格对齐方式
                                                    if (RowData.CellDataType == "01") {
                                                        Grid1.Cell(rowIndex, i).Alignment = 4;
                                                    } else if (RowData.CellDataType == "02") {
                                                        Grid1.Cell(rowIndex, i).Alignment = 12;
                                                    }
                                                }
                                            }
                                        });
                                        //设置增量记录
                                        colChangeFlag[bdFormat.Offset] = colNum - 1;
                                    }

                                    //设置变动列数据
                                    if (bdqData && bdqData.length > 0) {
                                        $.each(bdqData, function (bdColIndex, bdCol) {
                                            $.each(currentState.bbFormat.bbData, function (rowIndex, rowData) {
                                                if (rowData[bdFormat.Offset]) {
                                                    var cell = rowData[bdFormat.Offset];
                                                    var col = bdFormat.Offset + bdColIndex + addColIndex;
                                                    if (bdCol && bdCol[cell.CellCode]) {
                                                        gridManager.SetRowColTextByRowCol(rowIndex, col, bdRow[cell.CellCode], cell);
                                                    } else {
                                                        var cellItem = { value: "", cellDataType: cell.CellDataType, isOrNotUpdate: "0" };
                                                        gridManager.SetRowColTextByRowCol(rowIndex, col, cellItem, cell);
                                                    }
                                                }

                                            });

                                        });
                                    } else {

                                        $.each(currentState.bbData.bbData, function (rowIndex, rowData) {
                                            if (rowData[bdFormat.Offset]) {
                                                var cell = rowData[bdFormat.Offset];
                                                var col = bdFormat.Offset + addColIndex;
                                                var cellItem = { value: "", cellDataType: cell.CellDataType, isOrNotUpdate: "0" };
                                                gridManager.SetRowColTextByRowCol(rowIndex, col, cellItem, cell);
                                            }

                                        });
                                    }
                                }


                            });

                            //报表单元格数据
                            for (var i = 0; i < Grid1.getRowCount(); i++) {
                                for (var j = 0; j < Grid1.getColumnCount(); j++) {
                                    Grid1.getCell(i, j).locked(true);
                                }
                            }
                            Grid1.isPaintSuspended(false);
                            Grid1.width = '100%';
                            Grid1.height = '100%';
                            //保存报表数据
                            /*
                            ReportData = data.obj;
                            if (typeof (ExportManager) != "undefined" && ExportManager.ExportExcel) {
                                ExportManager.ExportExcel();
                            }*/
                        } catch (err) {
                            //检查是否有错误处理机制
                            if (typeof (ExportManager) != "undefined" && ExportManager.ExportFail) {
                                ExportManager.ExportFail(err.Message);
                            } else {
                                alert(err.Message);
                            }
                        }

                    } else {
                        //检查是否有错误处理机制
                        if (typeof (ExportManager) != "undefined" && ExportManager.ExportFail) {
                            ExportManager.ExportFail(data.sMeg);
                        } else {
                            alert(data.sMeg);
                        }
                    }
                },
                Fail: function (data) {
                    //检查是否有错误处理机制
                    if (typeof (ExportManager) != "undefined" && ExportManager.ExportFail) {
                        ExportManager.ExportFail(data.sMeg);
                    } else {
                        alert(data);
                    }
                },
                SetRowColTextByRowCol: function (row, col, CellItem, offsetCell) {
                    var newText;

                    //设置单元格对齐方式
                    var align;
                    if (CellItem.CellDataType == "01") {
                        align = spreadNS.HorizontalAlign["left"];
                        Grid1.getCell(row, col)["hAlign"](align);

                    } else if (CellItem.CellDataType == "02") {
                        align = spreadNS.HorizontalAlign["right"];
                        Grid1.getCell(row, col)["hAlign"](align);

                    }


                    if (CellItem.value != undefined)
                        newText = CellItem.value.toString();
                    else {
                        newText = "";
                    }
                    if (CellItem.cellDataType == "01" || !offsetCell) {
                        Grid1.setValue(row, col, newText);
                        return;
                    }
                    newText = gridManager.GetSmboText(newText);
                    if (Ct_Tool) {
                        newText = Ct_Tool.RemoveDecimalPoint(newText);
                        if (offsetCell["DigitNumber"] && offsetCell["CellDataType"] == "02") {
                            newText = Ct_Tool.FixNumber(newText, offsetCell["DigitNumber"]);
                            if (newText == "NaN") return;
                        }
                        if (offsetCell["CellThousand"] == "1") {
                            newText = Ct_Tool.AddDecimalPoint(newText);
                            if (newText == "NaN") return;
                        }
                        if (offsetCell["CellSmbol"] == "01") {
                            var charFirst = newText.substring(0, 1);
                            if (charFirst == "￥") return;
                            newText = "￥" + newText;
                        } else if (offsetCell["CellSmbol"] == "02") {
                            var charFirst = newText.substring(0, 1);
                            if (charFirst == "$") return;
                            newText = "$" + newText;
                        }
                        Grid1.setValue(row, col, newText);

                    }
                },
                SetRowColText: function (CellItem) {
                    var tag = Grid1.getTag(CellItem.row, CellItem.col);
                    if (tag != "" && tag.length > 0) {
                        var cellArr = tag.split("|");
                        var bdArr = cellArr[0].split(";");
                        var cellFormat;
                        if (bdArr[0] == "1") {
                            cellFormat = JSON2.parse(cellArr[2]);
                        }
                    }
                    gridManager.SetRowColTextByRowCol(CellItem.row, CellItem.col, CellItem, cellFormat);
                },
                RowColChange_Event: function () {
                    //若要使用此事件则要声明对应方法
                   
                     CommunicationManager.ClickCell();
                    
                },
                CreateCode: function (row, col) {
                    if (currentState.bbFormat.bbData[row] && currentState.bbFormat.bbData[row][col]) {
                        return currentState.bbFormat.bbData[row][col].CellCode;
                    } else { return null; }
                },
                CreateCellData: function (row, col) {
                    if (currentState.bbFormat.bbData[row] && currentState.bbFormat.bbData[row][col]) {
                        return currentState.bbFormat.bbData[row][col];
                    } else { return null; }
                },
                SetRowColTextByCellType: function (row, col, CellType) {
                    var text = Grid1.getCell(row, col).text(); 
                    if (text == undefined || text.length == 0) return;
                    text = gridManager.GetSmboText(text);
                    text = Ct_Tool.RemoveDecimalPoint(text);
                    if (CellType["DigitNumber"] && CellType["CellDataType"] == "02") {
                        text = Ct_Tool.FixNumber(text, CellType["DigitNumber"]);
                        if (text == "NaN") return;
                    }
                    if (CellType["CellThousand"] == "1") {
                        text = Ct_Tool.AddDecimalPoint(text);
                        if (text == "NaN") return;
                    }
                    if (CellType["CellSmbol"] == "01") {
                        var charFirst = text.substring(0, 1);
                        if (charFirst == "￥") return;
                        text = "￥" + text;
                    } else if (CellType["CellSmbol"] == "02") {
                        var charFirst = text.substring(0, 1);
                        if (charFirst == "$") return;
                        text = "$" + text;
                    }
                    Grid1.setValue(row, col, text);
                },
                GetSmboText: function (text) {
                    var sym = text.substr(0, 1);
                    if (sym == "$" || sym == "￥") {
                        return text.substr(1);
                    }
                    return text;
                }
            };

            var toolsManager = {
                IsOrNotBdq: function (Row, Col) {
                    var code = "-1";
                    $.each(currentState.bbData.bdq.Bdqs, function (index, item) {
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
                CreateNmCode: function (num) {
                    var temp = num.toString();
                    for (var i = temp.length; i < 4; i++) {
                        temp = "0" + temp;
                    }
                    return temp;
                },
                IsOrNotBdq: function (Row, Col) {
                    var code = "-1";
                    $.each(currentState.bbFormat.bdq.Bdqs, function (index, item) {
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
                }, CovertColorStr: function (colorStr) {
                    var temp = colorStr.substring(1);
                    var newColor = temp.substring(4, 6) + temp.substring(2, 4) + temp.substring(0, 2);
                    return parseInt(newColor, 16);
                },
                GetCellTagBdqInfo: function (row, col) {
                    var upCellTag = Grid1.getTag(row, col); 
                    var bdInfo = JSON2.parse(upCellTag.split("|")[0].split(";")[1]);
                    return bdInfo;
                }
            };
        </script>

</head>
 
<body style="margin:0; padding:0;overflow:hidden">
<div id="layout1">
   
     <div position="right" title="">
          <div class="l-layout-header" id="IndexTrend_header" >指标趋势</div>
        <iframe id="IndexTrend"  frameborder="0" src="../../ReportAudit/IndexTrend.aspx" style="overflow:hidden;height:250px; width:100%; border-bottom: 1px solid #95B8E7;" onload="CommunicationManager.SetIndexTrend()"></iframe>

        <div class="l-layout-header" id="IndexIndexList_header" >相关信息<div id="DownLoadIndex" style=" float:right; margin:1px 10px" ></div></div>
        <div id="IndexGrid"></div>
    </div>
     <div position="top">
     <div id="toolBar"></div>
    </div>
     <div position="center">
    <div id="ss"  style="height:95%; width:100%"  ></div>
    </div>
    <input id="parameter" value="<%=parame %>" type="hidden"/>
</div>

</body>
</html>

