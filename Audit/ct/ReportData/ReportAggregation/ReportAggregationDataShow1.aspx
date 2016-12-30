<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReportAggregationDataShow1.aspx.cs" Inherits="Audit.ct.ReportData.ReportAggregation.ReportAggregationDataShow" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head >
    <title>报表汇总资料查看</title>
      <meta http-equiv="X-UA-Compatible" content="IE=10" />
     <meta http-equiv="X-UA-Compatible" content="IE=9" />
     <meta http-equiv="X-UA-Compatible" content="IE=8" />
     <meta http-equiv="X-UA-Compatible" content="IE=7" />
    <script src="../../../lib/jquery/jquery-1.3.2.min.js" type="text/javascript"></script>
      <script src="../../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script src="../../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <script src="../../../Scripts/ct/ReportData/ReportAggregation/ReportDataCell.js"type="text/javascript"></script>
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
            var currentState = { currentWidth: 0, controlWidth: 0, paras: {}, bbFormat: {}, bbData: {}, reportAudit: {}, currentProblemId: "", currentCellInfo: "" };
            var controls = { IndexCell: {} ,InViewingCell:{}};
            var urls = {
                reportAuditUrl: "../../../handler/ReportDataHandler.ashx",
                cellDataUrl:"../../ReportAudit/IndexTrend.aspx",
                IndexTrendUrl:"../../ReportAudit/IndexTrend.aspx"
            };
            $(function () {
                var height = $(window).height() - 360;
                $("#layout1").ligerLayout({ allowRightCollapse: true, topHeight: 25, space: 2, rightWidth: 450 });
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
                var paras = $("#parameter").val();
                if (paras) {
                    paras = Base64.decode(paras);
                    controls.parameter = JSON2.parse(paras);
                    var parameter = { TaskId: controls.parameter.TaskId, PaperId: controls.parameter.PaperId, CompanyId: controls.parameter.CompanyId, ReportId: controls.parameter.ReportId, Year: controls.parameter.Year, Cycle: controls.parameter.Cycle };
                    parameter = CreateParameter(ReportDataAction.ActionType.Post, ReportDataAction.Functions.ReportAggregation, ReportDataAction.Methods.ReportAggregationMethods.GetReportData, parameter);
                    gridManager.LoadData(parameter, urls.reportAuditUrl);
                }

            });
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
                    var selection = Grid1.Selection;
                    for (var i = selection.FirstRow; i <= selection.LastRow; i++) {
                        for (var j = selection.FirstCol; j <= selection.LastCol; j++) {
                            if (Grid1.Cell(i, j).Tag && Grid1.Cell(i, j).Tag != "") {
                                var cell = { Code: "", Name: "", DataType: "" };
                                var codeData = Grid1.Cell(i, j).Tag.split("|");
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
                                var PrimariesCell = Grid1.Cell(rowIndex, node.CellCol);
                                var CellData = { CellCode: node.CellCode, Value: PrimariesCell.Text };
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
                var height = $(window).height() - 360;
                controls.IndexGrid.set("height", height);
            }
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
    <OBJECT CLASSID = "clsid:5220cb21-c88d-11cf-b347-00aa00a28331" VIEWASTEXT>
        <PARAM NAME="LPKPath" VALUE="../../lpk/flexCell.LPK">
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

