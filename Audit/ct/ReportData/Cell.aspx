<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Cell.aspx.cs" Inherits="Audit.ct.ReportData.Cell" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link rel="stylesheet" href="../../lib/SpreadCSS/gcspread.sheets.excel2013white.9.40.20153.0.css" title="spread-theme" />
      <script type="text/javascript" src="../../lib/jquery/jquery-1.11.1.min.js"></script>
    <script src="../../lib/jquery/jquery-ui-1.10.3.custom.min.js" type="text/javascript"></script>
     <script type="text/javascript" src="../../lib/SpreadJS/gcspread.sheets.all.9.40.20153.0.min.js"></script>
     <script type="text/javascript" src="../../lib/SpreadJS/gcspread.sheets.print.9.40.20153.0.min.js"></script>
      <script type="text/javascript" src="../../lib/SpreadJS/FileSaver.min.js"></script>
    <script type="text/javascript" src="../../lib/SpreadJS/resources.js"></script>
     <script type="text/javascript" src="../../lib/SpreadJS/bootstrap.min.js"></script>


    <script src="../../lib/jquery/jquery-1.5.2.min.js" type="text/javascript"></script>
    <script src="../../Scripts/Ct_Tool.js" type="text/javascript"></script>
    <script src="../../lib/json2.js" type="text/javascript"></script>
    <script src="../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>

</head>
<body  style=" height:100%; width:100%; margin:0; padding:0; overflow:hidden;">
			<div id="ss"  style="height:600px; width:100%">
		</div>
 
        <script type="text/javascript">
            top.loader && top.loader.close();
            var urls = {
                HelpUrl: "../../handler/BasicHandler.ashx",
                ReportDataUrl: "JumpReportMang.aspx"
            };
            var currentState = { Row: "", Col: "", Tag: "", CellsHelp: {},currentNum:0 };
            var grid1;

            var spreadNS;
            var spread;
            var Grid1;
            function Initialize(width,height) {
           
                currentState.Row = "";
                currentState.Col = "";
                $("#ss").height(height - 55);
                $("#ss").width(width - 10) ;
                
               
            }
            function Grid_KeyDown() {
                if (event.ctrlKey && event.keyCode == 67) {
                    Grid1.Selection.CopyData();
                }
            }
            function ClearFilter() {
                if (Grid1) {
                    var filter = Grid1.rowFilter();
                    if (filter) {
                        for (var i = 0; i < Grid1.getColumnCount(); i++) {
                            filter.removeFilterItems(i);
                        }
                    }
                }
            }
            $(function () {
                initializeCell(0, 0);
            });

            function initializeCell(row, col) {
                if (!spreadNS) {
                    spreadNS = GcSpread.Sheets;
                }
                if (!spread)
                {
                    spread = new spreadNS.Spread($("#ss")[0]);
                }
               // spread.setTabStripRatio(0.88);
               
                spread.removeSheet(0);
               
                Grid1 = new spreadNS.Sheet("Cell");
                Grid1.setIsProtected(true); //是否锁定

                spread.addSheet(spread.getSheetCount(), Grid1);

                Grid1.isPaintSuspended(true);

                var filter = new GcSpread.Sheets.HideRowFilter(new GcSpread.Sheets.Range(-1, 0, -1, 2));
                Grid1.rowFilter(filter);
                filter.setShowFilterButton(false);
                Grid1.isPaintSuspended(true);
                if (Grid1.bind) {
                    Grid1.bind(spreadNS.Events.ColumnChanged, ClearFilter);
                    Grid1.bind(spreadNS.Events.ValueChanged, GridManager.CellChange_Event);
                    Grid1.bind(spreadNS.Events.SelectionChanged, GridManager.RowColChange_Event);


                }
                Grid1.isPaintSuspended(false);
                currentState.currentNum = 0;

            }
            function InitializeFlexCell(row,col) {
                if (Grid1) {
                    //initializeCell(0, 0);
                    Grid1.isPaintSuspended(true);
                    Grid1.setColumnCount(col);
                    Grid1.setRowCount(row);
                    Grid1.isPaintSuspended(false);
                }


            }
            function Refresh() {
                if (Grid1)
                {
                    spread.removeSheet(0);
                    Grid1 = new spreadNS.Sheet("Cell");
                    Grid1.setIsProtected(true); //是否锁定
                    spread.addSheet(spread.getSheetCount(), Grid1);

                    Grid1.isPaintSuspended(true);
                    Grid1.setColumnCount(0);
                    Grid1.setRowCount(0);
                    if (Grid1.bind) {
                        Grid1.bind(spreadNS.Events.ColumnChanged, ClearFilter);
                        Grid1.bind(spreadNS.Events.ValueChanged, GridManager.CellChange_Event);
                        Grid1.bind(spreadNS.Events.SelectionChanged, GridManager.RowColChange_Event);
                    }
                    Grid1.isPaintSuspended(false);
                    ClearFilter();
                }
            }
            function RefreshGrid(formatStr, width, height) {
                Refresh();
                Initialize(width,height);
                Grid1.fromJSON(JSON.parse(formatStr));
                spread.refresh();

           }
           var GridManager = {

               SetRowColText: function (row, col, CellItem) {

                   if (Grid1.getCellType(row, col)._link == undefined) {
                       GridManager.SetRowColTextByRowCol(row, col, CellItem);
                   }
                   else {

                       CellItem.ParaValue = GetRequest(CellItem.ParaValue, row, col);
                       if (CellItem.ParaValue.indexOf("umpReportMang.aspx") > 0) {

                           CellItem.ParaValue += "&UserCode=9999&Stype=1";
                           CellItem.ParaValue += "&AuditType=" + parent.currentState.ReportState.AuditType.value;
                           CellItem.ParaValue += "&AuditTask=" + parent.currentState.ReportState.AuditTask.value;
                           CellItem.ParaValue += "&AuditPaper=" + parent.currentState.ReportState.AuditPaper.value;
                           CellItem.ParaValue += "&AuditCycle=" + parent.currentState.ReportState.Zq;
                           CellItem.ParaValue += "&AuditDate=" + parent.currentState.ReportState.AuditDate;
                           CellItem.ParaValue += "&Company=" + parent.currentState.CompanyId;
                       }
                       Grid1.getCellType(row, col)._text = CellItem.ParaValue;
                       Grid1.setValue(row, col, CellItem.ParaValue);

                   }
               },
               SetRowColCellType: function (cell, rowIndex, colIndex) {

                   if (cell.CellType == "02") {
                       var cellType = new GcSpread.Sheets.ComboBoxCellType();
                       if (cell.CellValue && cell.CellValue != "") {
                           var data = cell.CellValue.split(',');
                           cellType.items(data);
                           Grid1.getCell(rowIndex, colIndex).cellType(cellType);
                       }
                       else {
                           Grid1.setCellType(rowIndex, colIndex, cellType);
                       }
                   }
                   else if (cell.CellType == "03") {
                       //帮助
                   }
                   else if (cell.CellType == "04") {

                       var defaultHyperlink = new GcSpread.Sheets.HyperLinkCellType();
                       if (cell.CellValue && cell.CellValue != "") {

                           defaultHyperlink.text(cell.CellValue);
                           Grid1.getCell(rowIndex, colIndex).cellType(defaultHyperlink).value(cell.CellValue);



                       }
                       else {

                           Grid1.setCellType(rowIndex, colIndex, defaultHyperlink);
                       }
                   }


               },

               SetRowColTextByRowCol: function (row, col, CellItem) {

                   if (CellItem.value != undefined) {
                       Grid1.setValue(row, col, CellItem.value);
                   }
                   else {
                       Grid1.setValue(row, col, "");

                   }

               },
               SetRowColTextByCellType: function (row, col, CellType) {
                   if (CellType["CellDataType"] == "01") return;
                   var text = Grid1.getCell(row, col).text();
                   if (text == undefined || text.length == 0) return;
                   text = GridManager.GetSmboText(text);
                   text = Ct_Tool.RemoveDecimalPoint(text);
                   var newText = text;
                   if (CellType["DigitNumber"] && CellType["CellDataType"] == "02") {
                       newText = Ct_Tool.FixNumber(text, CellType["DigitNumber"]);
                       if (newText == "NaN") return;
                   }
                   if (CellType["CellThousand"] == "1") {
                       newText = Ct_Tool.AddDecimalPoint(newText);
                   }
                   if (CellType["CellSmbol"] == "01") {
                       var charFirst = newText.substring(0, 1);
                       if (charFirst == "￥") return;
                       newText = "￥" + newText;
                   } else if (CellType["CellSmbol"] == "02") {
                       var charFirst = text.substring(0, 1);
                       if (charFirst == "$") return;
                       newText = "$" + newText;
                   }
                   if (text != newText) Grid1.getCell(row, col).text(newText); //Grid1.setValue(row, col, newText);
               },
               GetRowColTextByCellType: function (text, cellType) {
                   if (text == null) return "";
                   if (cellType["CellSmbol"] == "01" || cellType["CellSmbol"] == "02") {
                       text = GridManager.GetSmboText(text);
                   }
                   if (cellType["CellThousand"] == "1") {
                       text = Ct_Tool.RemoveDecimalPoint(text);
                   }
                   return text;
               },
               RowColChange_Event: function (e, data) {
                   var row = data.sheet._activeRowIndex;
                   var col = data.sheet._activeColIndex;
                   var tag = Grid1.getTag(row, col); // Grid1.Cell(Row, Col).Tag;
                   if (currentState.Row == row && currentState.Col == col && currentState.Tag == tag) { return; }
                   parent.mediatorManager.SetRowColInput(row, col, tag);
                   currentState.Row = row;
                   currentState.Col = col;

               },
               CellChange_Event: function (e, data) {

                   var tag = Grid1.getTag(data.row, data.col); // Grid1.Cell(Row, Col).Tag;
                   parent.mediatorManager.TextChange(data.row, data.col, tag);
               },



               GetCurrentRow: function () {
                   return Grid1.getActiveRowIndex(); // selection.FirstRow;

               },
               GetCurrentCol: function () {
                   return Grid1.getActiveColumnIndex(); // selection.FirstCol;
               },
               GetCurrentTag: function () {
                   var col = Grid1.getActiveColumnIndex(); // selection.FirstCol;
                   var row = Grid1.getActiveRowIndex(); // selection.FirstRow;
                   return Grid1.getTag(row, col); // Grid1.Cell(row, col).Tag;
               },
               GetSmboText: function (text) {
                   if (text) {
                       var sym = text.toString().substr(0, 1);
                       if (sym == "$" || sym == "￥") {
                           return text.substr(1);
                       }
                   }
                   return text;
               }, ComboDropDown: function (row, col) {

                   try {

                       Grid1.ComboBox(0).Clear();
                       //获取单元格基本信息
                       var tag = Grid1.Cell(row, col).Tag;
                       if (tag.split("|")[2]) {
                           var cellFormat = JSON2.parse(tag.split("|")[2]);
                           if (cellFormat["CellHelp"]) {
                               if (cellFormat["CellType"] == "02") {
                                   var cellHelp = currentState.CellsHelp[cellFormat[cellFormat["CellCode"]]];
                                   if (cellHelp) {
                                       GridManager.AddGridHelp(cellHelp);
                                   } else {
                                       var para = { ClassType: cellFormat["CellHelp"] };
                                       para = CreateParameter(BasicAction.ActionType.Post, BasicAction.Functions.DictionaryManager, BasicAction.Methods.DicManagerMethods.GetDictionaryListByClassType, para);
                                       para = DataManager.sendData(urls.HelpUrl, para, resultManager.LoadHelp_Success, resultManager.Fail, false);
                                   }
                               }
                           }
                       }

                   } catch (err) {
                       alert(err.Message);
                   }
               },
               GridButtonClick: function (row, col) {
                   try {

                       var tag = Grid1.Cell(row, col).Tag;
                       if (tag.split("|")[2]) {
                           var cellFormat = JSON2.parse(tag.split("|")[2]);
                           if (cellFormat["CellHelp"]) {
                               if (cellFormat["CellType"] == "03") {
                                   var paras = { url: "", columns: [], sortName: "", sortOrder: "" };
                                   paras.url = "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Grid + "&MethodName=GetDictionaryDataGridByClassType&FunctionName=" + BasicAction.Functions.DictionaryManager + "&ClassType=" + cellFormat["CellHelp"];
                                   paras.columns = [[
                    { field: "Code", title: "编号", width: 80 },
                     { field: "Name", title: "名称", width: 80 }
                    ]];
                                   paras.sortName = "Code";
                                   paras.sortOrder = "ASC";
                                   var result = window.showModalDialog("../pub/HelpDialog.aspx", paras, "dialogHeight:350px;dialogWidth:300px");
                                   if (result && result.Code) {
                                       Grid1.Cell(row, col).Text = result.Name;

                                   }
                               }
                           }
                       }
                   } catch (err) {
                       alert(err.Message);
                   }
               },
               AddGridHelp: function (cellHelp) {
                   $.each(cellHelp, function (index, item) {
                       Grid1.ComboBox(0).AddItem(item.Name);
                   });
               }
           };
           window.onresize = function () {
               Grid1.width=window.document.body.offsetWidth;
           }
           function ChangeHeight(height) {
               Grid1.height = height - 60;
           }
           function GetQueryString(name) {

               var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");

               var r = window.location.search.substr(1).match(reg);

               if (r != null) return unescape(r[2]); return null;

           }
           function GetRequest(vsUrl,row ,col) {
               var url = vsUrl; //获取url中"?"符后的字串   
               var theRequest = new Object();
               if (url.indexOf("?") != -1) {
                   var str = url.substr(1 + url.indexOf("?"));
                   strs = str.split("&");
                   for (var i = 0; i < strs.length; i++) {
                       var ReplaceValue = GetCellValue(strs[i].split("=")[1], row, col);
                       url = url.replace(strs[i].split("=")[1], ReplaceValue);    
                       //alert(strs[i].split("=")[1]);
                       //theRequest[strs[i].split("=")[0]] = unescape(strs[i].split("=")[1]);
                   }
               }
               return url;
           }
           function GetCellValue(value,row,col ) {
               var result = value;
               if (value) {
                   var strValue = value.split('@');
                   if (strValue.length < 2)
                       return result;
                   if (strValue[0] == "1") {
                       result = Grid1.getCell(strValue[1].split(',')[0], strValue[1].split(',')[1]).value();
                   }
                   else {
                       result = Grid1.getCell(row, parseInt(strValue[1]) ).value();
                   }

               }
               if (!result)
                   result = "";
               return result;
           }

           var resultManager = {
               LoadHelp_Success: function (data) {
                   try {
                     
                           GridManager.AddGridHelp(data);
                      
                   } catch (err) {
                       alert(err.Message);
                   }
               },
               Fail: function (data) {
                   alert(data);
               }
           };
           
    </script>
</body>
</html>
