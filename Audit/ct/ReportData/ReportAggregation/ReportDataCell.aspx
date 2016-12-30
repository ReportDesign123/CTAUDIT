<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReportDataCell.aspx.cs" Inherits="Audit.ct.ReportData.ReportAggregation.ReportDataCell" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head >
    <title>报表数据查看</title>

     <link rel="stylesheet" href="../../../lib/SpreadCSS/gcspread.sheets.excel2013white.9.40.20153.0.css" title="spread-theme" />
      <script type="text/javascript" src="../../../lib/jquery/jquery-1.11.1.min.js"></script>
    <script src="../../../lib/jquery/jquery-ui-1.10.3.custom.min.js" type="text/javascript"></script>
     <script type="text/javascript" src="../../../lib/SpreadJS/gcspread.sheets.all.9.40.20153.0.min.js"></script>
     <script type="text/javascript" src="../../../lib/SpreadJS/gcspread.sheets.print.9.40.20153.0.min.js"></script>
      <script type="text/javascript" src="../../../lib/SpreadJS/FileSaver.min.js"></script>
    <script type="text/javascript" src="../../../lib/SpreadJS/resources.js"></script>
     <script type="text/javascript" src="../../../lib/SpreadJS/bootstrap.min.js"></script>



    <script src="../../../lib/jquery/jquery-1.5.2.min.js" type="text/javascript"></script>
         <link href="../../../Styles/default.css" rel="stylesheet" type="text/css" />
             <link href="../../../Styles/FormatManager.css" rel="stylesheet" type="text/css" />
      <script src="../../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script src="../../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
    
    <script src="../../../lib/ligerUI/js/core/base.js" type="text/javascript"></script>
    <script src="../../../lib/ligerUI/js/core/inject.js" type="text/javascript"></script>
    <script src="../../../lib/ligerUI/js/ligerui.min.js" type="text/javascript"></script>
    <link href="../../../lib/ligerUI/skins/ligerui-icons.css" rel="stylesheet" type="text/css" />
    <link href="../../../lib/ligerUI/skins/Aqua/css/ligerui-all.css" rel="stylesheet"
        type="text/css" />
    <script src="../../../Scripts/Ct_Tool.js" type="text/javascript"></script>
    <script src="../../../lib/json2.js" type="text/javascript"></script>
    <script src="../../../lib/Base64.js" type="text/javascript"></script>
        <script type="text/javascript">
            var ReportData = {};
            var spreadNS;
            var spread;
            var Grid1;

            var currentState = { currentWidth: 0, controlWidth: 0, paras: {}, bbFormat: {}, bbData: {}, reportAudit: {}, currentProblemId: "", currentCellInfo: "" };
            var urls = {
              reportAuditUrl:"../../../handler/ReportDataHandler.ashx"
          };
          $(function () {
              $("#layout1").ligerLayout({});
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
                    }
                ]
            });


            spreadNS = GcSpread.Sheets;
            spread = new spreadNS.Spread($("#ss")[0]);
            spread.setTabStripRatio(0.88);
            Grid1 = new spreadNS.Sheet("Cell");
            // Grid1.setIsProtected(true); //是否锁定
            spread.removeSheet(0);
            spread.addSheet(spread.getSheetCount(), Grid1);

            Grid1.isPaintSuspended(true);
            Grid1.setColumnCount(1);
            Grid1.setRowCount(1);
            Grid1.isPaintSuspended(false);


              var para = $("#parmeter").val();
              para = Base64.decode(para);
              if (para && para != "") {
                  var parameter = JSON2.parse(para);
                  parameter = CreateParameter(ReportDataAction.ActionType.Post, ReportDataAction.Functions.ReportAggregation, ReportDataAction.Methods.ReportAggregationMethods.GetReportData, parameter);
                  gridManager.LoadData(parameter, urls.reportAuditUrl);
              }

          });
            var CommunicationManager = {
                LoadCellData: function (parameter) {
                    parameter = CreateParameter(ReportDataAction.ActionType.Post, ReportDataAction.Functions.ReportAggregation, ReportDataAction.Methods.ReportAggregationMethods.GetReportData, parameter);
                    gridManager.LoadData(parameter, urls.reportAuditUrl);
                }
            };
            var gridManager = {
                InitializeGrid: function (width, height) {
                    //表格初始
                    if (!height) height = 600;
                    if (!width) width = document.body.clientWidth;
                    Grid1.AutoRedraw = false;
                    Grid1.DisplayRowIndex = true;
                    Grid1.FixedRowColStyle = 0;
                    Grid1.Appearance = 0;
                    Grid1.width = width;
                    Grid1.height = height;
                    Grid1.AutoRedraw = true;

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
                                            for (var i = bdFormat.Offset + addRowData; i <= bdFormat.Offset + rowNum - 1 + addRowData; i++) {
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
                            ReportData = data.obj;
                            if (typeof (ExportManager) != "undefined" && ExportManager.ExportExcel) {
                                ExportManager.ExportExcel();
                            }
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
                    var tag = Grid1.Cell(CellItem.row, CellItem.col).Tag;
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
                    if (this.CommunicationManager && this.CommunicationManager.ClickCell) {
                        CommunicationManager.ClickCell();
                    }
                    if (this.auditGridManager && this.auditGridManager.RowColChange_Event) {
                        auditGridManager.RowColChange_Event();
                    }
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
                    var upCellTag = Grid1.Cell(row, col).Tag;
                    var bdInfo = JSON2.parse(upCellTag.split("|")[0].split(";")[1]);
                    return bdInfo;
                }
            };
        </script>

</head>
<body style="overflow:hidden" >
    <div id="toolBar"></div>
    <input type="hidden" id="parmeter" value = "<%=param%>"/>
    <div id="layout1">
    <div position="center">
        <div id="ss"  style="height:95%; width:100%"  ></div>
    </div>
    </div>
</body>
</html>
