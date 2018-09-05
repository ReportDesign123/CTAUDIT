<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Cell.aspx.cs" Inherits="Audit.ct.ReportData.Cell" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link rel="stylesheet" href="../../lib/SpreadCSS/gc.spread.sheets.excel2013white.10.2.0.css" title="spread-theme" />
    <script type="text/javascript" src="../../lib/jquery/jquery-1.11.1.min.js"></script>
    <script type="text/javascript" src="../../lib/jquery/jquery-ui-1.10.3.custom.min.js" ></script>
     <script type="text/javascript" src="../../lib/SpreadJS/gc.spread.sheets.all.10.2.0.min.js"></script>
     <script type="text/javascript" src="../../lib/SpreadJS/gc.spread.sheets.print.10.2.0.min.js"></script>
     <script type="text/javascript" src="../../lib/SpreadJS/gc.spread.excelio.10.2.0.min.js"></script>
       <script type="text/javascript" src="../../lib/SpreadJS/gc.spread.sheets.resources.zh.10.2.0.min.js"></script>
      <script type="text/javascript" src="../../lib/SpreadJS/FileSaver.min.js"></script>
    <script type="text/javascript" src="../../lib/SpreadJS/resources.js"></script>
     <script type="text/javascript" src="../../lib/SpreadJS/bootstrap.min.js"></script>


    <script src="../../lib/jquery/jquery-1.5.2.min.js" type="text/javascript"></script>
    <script src="../../Scripts/Ct_Tool.js" type="text/javascript"></script>
    <script src="../../lib/json2.js" type="text/javascript"></script>
    <script src="../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script src="../../lib/easyUI14/jquery.easyui.min.js"></script>
       <script src="../../Scripts/ct_dialog.js" type="text/javascript"></script>
</head>
<body  style=" height:100%; width:100%; margin:0; padding:0; overflow:hidden;">
			<div id="ss"  style="height:600px; width:100%">
		</div>
        <script type="text/javascript">

          
            top.loader && top.loader.close();
            var urls = {
                HelpUrl: "../../handler/BasicHandler.ashx",
                ReportDataUrl: "JumpReportMang.aspx",
                BBUrl: "../../handler/FormatHandler.ashx",
                ReportUrl: "../../handler/ReportDataHandler.ashx"
            };
            var currentState = { Row: "", Col: "", Tag: "", CellsHelp: {},currentNum:0 };
            var grid1;

            var spreadNS;
            var spread;
             Grid1=null;
            var excelIO;
            var DOWNLOAD_DIALOG_WIDTH = 300;
            var isSafari = (function () {
                var tem, M = navigator.userAgent.match(/(opera|chrome|safari|firefox|msie|trident(?=\/))\/?\s*(\d+)/i) || [];
                if (!/trident/i.test(M[1]) && M[1] !== 'Chrome') {
                    M = M[2] ? [M[1], M[2]] : [navigator.appName, navigator.appVersion, '-?'];
                    if ((tem = navigator.userAgent.match(/version\/(\d+)/i)) != null) M.splice(1, 1, tem[1]);
                    return M[0].toLowerCase() === "safari";
                }
                return false;
            })();
            function Initialize(width,height) {
           
                currentState.Row = "";
                currentState.Col = "";
                $("#ss").height(height-55 );
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
                excelIO = new GC.Spread.Excel.IO();
            });

            function initializeCell(row, col) {
                if (!spreadNS) {
                    spreadNS = GC.Spread.Sheets;
                }
                if (!spread)
                {
                    spread = new spreadNS.Workbook($("#ss")[0], { tabStripRatio: 0.88 });
                }
                spread.removeSheet(0);
               
                Grid1 =  new spreadNS.Worksheet("Cell");
                spread.addSheet(spread.getSheetCount(), Grid1);
                Grid1.options.isProtected = true;//是否锁定
                var option = Grid1.options.protectionOptions;
                option.allowResizeColumns = "allowResizeColumns";
                Grid1.options.protectionOptions.clipBoardOptions = GC.Spread.Sheets.ClipboardPasteOptions.values;
                Grid1.options.clipBoardOptions = GC.Spread.Sheets.ClipboardPasteOptions.values;
                //spreadNS.ClipboardPasteOptions(GC.Spread.Sheets.ClipboardPasteOptions.values);
                Grid1.suspendPaint();

                var filter = new spreadNS.Filter.HideRowFilter(new spreadNS.Range(-1, 0, -1, 2));
                Grid1.rowFilter(filter);
                filter.filterButtonVisible(false);
                if (Grid1.bind) {
                    Grid1.bind(spreadNS.Events.ColumnChanged, ClearFilter);
                    Grid1.bind(spreadNS.Events.ValueChanged, GridManager.CellChange_Event);
                   // Grid1.bind(spreadNS.Events.SelectionChanged, GridManager.RowColChange_Event);
                    Grid1.bind(spreadNS.Events.ClipboardPasted, GridManager.GridClipboardChanged);
                    Grid1.bind(spreadNS.Events.EnterCell, GridManager.EnterCell);
                    spread.bind(GC.Spread.Sheets.Events.ButtonClicked, GridManager.GridButtonClick);

                    Grid1.bind(spreadNS.Events.EditChange, GridManager.EditValueChage);

                }
                Grid1.resumePaint();
                currentState.currentNum = 0;

            }
            function InitializeFlexCell(row, col) {
             
                if (Grid1) {
                    //initializeCell(0, 0);
                   Grid1.suspendPaint();
                    Grid1.setColumnCount(col);
                    Grid1.setRowCount(row);
                   Grid1.resumePaint();
                }


            }
            function Refresh() {
                if (Grid1)
                {
                    spread.removeSheet(0);
                    Grid1 = new spreadNS.Worksheet("Cell");
                    spread.addSheet(spread.getSheetCount(), Grid1);
                    Grid1.options.isProtected = true;//是否锁定
                    
                    Grid1.suspendPaint();
                    Grid1.setColumnCount(0);
                    Grid1.setRowCount(0);
                    if (Grid1.bind) {
                        Grid1.bind(spreadNS.Events.ColumnChanged, ClearFilter);
                        Grid1.bind(spreadNS.Events.ValueChanged, GridManager.CellChange_Event);
                        //Grid1.bind(spreadNS.Events.SelectionChanged, GridManager.RowColChange_Event);
                        Grid1.bind(spreadNS.Events.ClipboardPasted, GridManager.GridClipboardChanged);
                        Grid1.bind(spreadNS.Events.EnterCell, GridManager.EnterCell);

                        Grid1.bind(spreadNS.Events.EditChange, GridManager.EditValueChage);
                       // spread.bind(GC.Spread.Sheets.Events.ButtonClicked, GridManager.GridButtonClick);
                    }
                    Grid1.resumePaint();
                    ClearFilter();
            
                }
            }
            function RefreshGrid(formatStr, width, height) {
                Refresh();
                Initialize(width,height);
                Grid1.fromJSON(JSON.parse(formatStr));
                Grid1.options.isProtected = true;//是否锁定
                var option = Grid1.options.protectionOptions;
                option.allowResizeColumns = "allowResizeColumns";
                
                Grid1.options.protectionOptions.clipBoardOptions = GC.Spread.Sheets.ClipboardPasteOptions.values;
                Grid1.options.clipBoardOptions = GC.Spread.Sheets.ClipboardPasteOptions.values;
                spread.refresh();
            }
            function InitGrid()
            {
                if (Grid1) {
                 
                }
            }
           var GridManager = {

               SetRowColText: function (row, col, CellItem) {
                   var cellType = null;
                   cellType = Grid1.getCellType(row, col);
                   if (cellType instanceof GC.Spread.Sheets.CellTypes.HyperLink)
                   {
                       var vsBBName;
                     //  CellItem.UrlValue = GetRequest(CellItem.UrlValue, row, col);
                       var vsUrl;
                       if (CellItem.UrlValue.indexOf("BB$") >= 0) {

                           var vsBBArry = CellItem.UrlValue.split("$");
                           vsBBName = GetCellValue(vsBBArry[1], row, col);
                           vsUrl = "../../JumpReportMang.aspx?Report=" + vsBBName;
                           vsUrl += "&UserCode=9999&Stype=1";
                           vsUrl += "&AuditType=" + parent.currentState.ReportState.AuditType.value;
                           vsUrl += "&AuditTask=" + parent.currentState.ReportState.AuditTask.value;
                           vsUrl += "&AuditPaper=" + parent.currentState.ReportState.AuditPaper.value;
                           vsUrl += "&AuditCycle=" + parent.currentState.ReportState.auditZqType;
                           if (parent.currentState.ReportState.auditZqType == "05")
                               vsUrl += "&AuditDate=" + parent.currentState.ReportState.WeekReport.Ksrq;
                           else
                               vsUrl += "&AuditDate=" + parent.currentState.ReportState.AuditDate.value;
                           vsUrl += "&Company=" + parent.currentState.CompanyId;
                       }
                       else
                       {
                           vsUrl = CellItem.UrlValue;
                       }
                       Grid1.getCell(parseInt(row), parseInt(col)).cellType(cellType).value(vsUrl);
                       var tagStr = Grid1.getTag(row, col);
                       if (vsUrl)
                       {
                           tagStr =tagStr+";"+ vsUrl;
                         //  Grid1.setTag(row, col, tagStr);
                       }
                      

                   }
                   else {
                       GridManager.SetRowColTextByRowCol(row, col, CellItem);
                   } 
               },
               CheckCellLinkType: function(row,col)
               {
                   var cellType = null;
                   cellType = Grid1.getCellType(row, col);
                   if (cellType instanceof GC.Spread.Sheets.CellTypes.HyperLink)
                       return true;
                   else
                       return false;
               },
               SetRowColCellType: function (cell, rowIndex, colIndex) {
                   
                   if (cell.CellType == "" || cell.CellType == undefined)
                       return;
                  
                   if (cell.CellType == "02") {
                       var cellType =  new spreadNS.CellTypes.ComboBox();
                       if (cell.CellValue && cell.CellValue != "") {
                           var data = cell.CellValue.split(',');
                           cellType.items(data);
                           //Grid1.getCell(rowIndex, colIndex).cellType(cellType);
                           Grid1.setCellType(rowIndex, colIndex, cellType);
                       }
                       else {
                           //Grid1.getCell(rowIndex, colIndex).cellType(cellType);
                           Grid1.setCellType(rowIndex, colIndex, cellType);
                       }
                   }
                   else if (cell.CellType == "03") {
                       //帮助
                       var ButtonCellType = new spreadNS.CellTypes.Button();
                       ButtonCellType.buttonBackColor("#DCDCDC");
                      // ButtonCellType.text("...");
                       Grid1.setCellType(rowIndex, colIndex, ButtonCellType, GC.Spread.Sheets.SheetArea.viewport);
                       //Grid1.getCell(parseInt(rowIndex), parseInt(colIndex)).cellType(ButtonCellType);
                   }
                   else if (cell.CellType == "04") {

                      
                       if (cell.CellUrl && cell.CellUrl != "") {

                           var cellText = "";
                           var cellType;
                           cellType = Grid1.getCellType(rowIndex, colIndex);
                           //  cellText = Grid1.getCell(rowIndex, colIndex).text();
                           var typeTex;
                           if (cellType instanceof GC.Spread.Sheets.CellTypes.HyperLink) {
                               cellType.text(cell.CellValue);
                           }

                           else {
                               
                               var defaultHyperlink = new spreadNS.CellTypes.HyperLink();
                               defaultHyperlink.linkColor("blue")
                               .visitedLinkColor("#FF8080")
                                .text(cell.CellValue)
                                .linkToolTip(cell.CellValue);
                               Grid1.getCell(parseInt(rowIndex), parseInt(colIndex)).cellType(defaultHyperlink).value(cell.CellUrl);
                               Grid1.getCell(parseInt(rowIndex), parseInt(colIndex)).backColor("#FF99CC");
                           }
                           //  var vsUrlTag = { URL: "" };
                           var tagStr = Grid1.getTag(rowIndex, colIndex); // Cell.Tag;
                           tagStr = tagStr +";"+ cell.CellUrl;
                           //vsUrlTag["URL"] = cell.CellUrl;
                         //  Grid1.setTag(rowIndex, colIndex, tagStr);
                          
                       }
                   }
               },

               SetRowColTextByRowCol: function (row, col, CellItem) {

                   if (CellItem.value != undefined) {
                       Grid1.setValue(row, col, CellItem.value);
                       var cellType = Grid1.getCellType(row, col);
                       if (cellType instanceof GC.Spread.Sheets.CellTypes.Button)
                           cellType.text(CellItem.value);
                   }
                   else {
                       Grid1.setValue(row, col, "");

                   }

               },
               setCellUrlValue: function (row, col,CellValue)
               {
                   if (CellValue != undefined &&CellValue != "")
                   {
                       var cellType = Grid1.getCellType(row, col);
                       cellType.text(CellValue);
                       Grid1.getCell(row, col).text(CellValue);
                   }
               }
               ,
               EnterCell:function (e,data)
               {
                   var row = data.row;
                   var col = data.col;
                   if (col == -1) col = 0;
                   var tag = Grid1.getTag(row, col); // Grid1.Cell(Row, Col).Tag;
                   if (currentState.Row == row && currentState.Col == col && currentState.Tag == tag) { return; }
                   parent.mediatorManager.SetRowColInput(row, col, tag);
                   currentState.Row = row;
                   currentState.Col = col;

                   var cellsType = Grid1.getCellType(row, col);
                   if (cellsType instanceof GC.Spread.Sheets.CellTypes.HyperLink) {

                     
                       var vsValue;
                       if (!tag || tag == "" || tag.split("|").length<3) {
                           vsValue = Grid1.getCell(row, col).cellType(cellsType).value();
                           var vsUrlValue = GetRequest(vsValue, row, col);
                           Grid1.getCell(parseInt(row), parseInt(col)).cellType(cellsType).value(vsUrlValue);

                       } else {

                           var Celltag = JSON2.parse(tag.split("|")[2]);
                           vsValue = Celltag.CellUrl;
                           var para = { CellRow: row, CellCol: col, UrlValue: Celltag.CellUrl };



                           var obj = { TaskId: "", PaperId: "", CompanyId: "", ReportId: "", Year: "", Cycle: "", AuditDate: "", Where: "",  Row: "", Col: "" };
                           obj.TaskId = parent.currentState.ReportState.AuditTask.value;
                           obj.CompanyId = parent.currentState.CompanyId;
                           obj.Cycle = parent.currentState.ReportState.Zq;
                           obj.Year = parent.currentState.ReportState.Nd;
                           obj.PaperId = parent.currentState.ReportState.AuditPaper.value;
                           obj.ReportId = parent.currentState.navigatorData.currentReportId;
                    
                           obj.Row = row;
                           obj.Col = col;
                           obj.Where = Celltag.CellUrl;
                           obj = CreateParameter(ReportDataAction.ActionType.Post, ReportDataAction.Functions.FillReport, ReportDataAction.Methods.FillReportMethods.GetReplaceMarchUrl, obj);
                           DataManager.sendData(urls.ReportUrl, obj, resultManager.GetCellTagURL_Success, resultManager.Fail, false);

                          

                       }
                       //var vsUrlValue = GetRequest(vsValue, row, col);
                       //Grid1.getCell(parseInt(row), parseInt(col)).cellType(cellsType).value(vsUrlValue);
                   }
                  
               },
               SetRowColTextByCellType: function (row, col, CellType) {
                   if (CellType["CellDataType"] == "01") return;
                   var text = Grid1.getCell(row, col).text();
                   if (isNaN(text))
                   {
                       //alert("请输入数字！");
                       //Grid1.setValue(row, col, "");
                       //return;
                   }
                       
                   if (text == undefined || text.length == 0) return;
                   var vsFormatter="0";
                   var newText = text;
                   if (CellType["CellSmbol"] == "01") {
                       vsFormatter = "￥#,##0.00";

                   } else if (CellType["CellSmbol"] == "02") {
                       vsFormatter = "$#,##0.00";
                   }
                   if (CellType["CellThousand"] == "1") {
                       if (vsFormatter.indexOf(",") <= 0)
                           vsFormatter = "#,##0.00";
                   }
                   var vsZero = "";
                   if (CellType["DigitNumber"] && CellType["CellDataType"] == "02") {
                       if (vsFormatter == "NaN") return;
                       if (CellType["DigitNumber"] > 0) {
                           vsZero = "0.";
                           for (var i = 0; i < CellType["DigitNumber"]; i++) {
                               vsZero = vsZero + "0";
                           }
                       }
                   }
                   if (vsFormatter.indexOf(",") > 0 && vsZero.indexOf(".") > 0)
                       vsFormatter = vsFormatter.replace("0.00", vsZero);
                   
                   else {
                       if (vsFormatter.indexOf(",") < 0) {
                           if (vsZero == "")
                               vsFormatter = "0";
                           else
                               vsFormatter = vsZero;
                       }
                       else
                       {
                           if (vsZero == "")
                               vsFormatter = vsFormatter.replace("0.00", "0");
                       }

                   }
                   
                   Grid1.getCell(row, col).formatter(vsFormatter);      
           },
               GetRowColTextByCellType: function (text, cellType) {
                   if (text == null) return "";
                   return text;
               },
               RowColChange_Event: function (e, data) {
               
               },
               CellChange_Event: function (e, data) {

                   var tag = Grid1.getTag(data.row, data.col); // Grid1.Cell(Row, Col).Tag;
                   parent.mediatorManager.TextChange(data.row, data.col, tag);
                   if (data.oldValue != data.newValue)
                   {
                       CellValueChange(data.row);
                   }
               },
               EditValueChage:function(sender, args)
               {
                   //CellValueChange(args.row);
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
               GridButtonClick: function (e, args) {
                  
                   var sheet = args.sheet,
                       row = args.row,
                       col = args.col;
                   var cellsType = sheet.getCellType(row,col);
                   if (cellsType instanceof GC.Spread.Sheets.CellTypes.Button)
                   {
                       var cellType = sheet.getCellType(row, col);
                       try
                       {
                           var tag = sheet.getTag(args.row, args.col);
                           if (tag.split("|")[2]) {
                               var cellFormat = JSON2.parse(tag.split("|")[2]);
                               if (cellFormat["CellHelp"]) {
                                   if (cellFormat["CellType"] == "03") {
                                       var paras = { url: "", columns: [], sortName: "", sortOrder: "", NameField: "Name", CodeField: "Code" };
                                       // var para = { TaskId: "", PaperId: "", CompanyId: "", ReportId: "", Year: "", Cycle: "", AuditDate: "", bdqStr: "", Where: "", WeekReportID: "", WeekReportName: "", WeekReportKsrq: "", WeekReportJsrq: "" };
                                       var vsTaskId =parent.currentState.ReportState.AuditTask.value;
                                       var vsCompanyId = parent.currentState.CompanyId;
                                       //para.Cycle = parent.currentState.ReportState.Zq;
                                       var vsYear = parent.currentState.ReportState.Nd;
                                       var vsPaperId = parent.currentState.ReportState.AuditPaper.value;
                                       var vsReportId = parent.currentState.navigatorData.currentReportId;
                                       var vsWhere;
                                       if (cellFormat.CellValue && cellFormat.CellValue != " ") {
                                           vsWhere = cellFormat.CellValue;
                                           var vsWhereWords = vsWhere.split(",");
                                           for (var i = 0; i < vsWhereWords.length; i++) {
                                               var vsStr = vsWhereWords[i].split("=")[1];
                                               var vsValue = sheet.getCell(row, vsStr.split("@")[1]).value();
                                               if (vsStr.split("@")[0] == "1") {
                                                   vsValue = "'" + vsValue + "'";
                                               }
                                               vsWhere = vsWhere.replace(vsStr, vsValue);
                                           }
                                           vsWhere = vsWhere.replace(",", " and ");
                                       }
                                       else
                                           vsWhere = "1=1";
                                       paras.url = "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Grid + "&MethodName=GetDictionaryDataGridByLsHelp&FunctionName=" + BasicAction.Functions.DictionaryManager + "&ClassType=" + cellFormat["CellHelp"] + "&TaskId=" + vsTaskId
                                      + "&CompanyId=" + vsCompanyId + "&vsYear=" + vsYear + "&PaperId=" + vsPaperId + "&ReportId=" + vsReportId + "&vsWhere=" + vsWhere;
                                       paras.columns = [[
                        { field: "Code", title: "编号", width: 120 },
                         { field: "Name", title: "名称", width: 480 }
                                       ]];
                                       paras.sortName = "Code";
                                       paras.sortOrder = "ASC";
                                       
                                       dialog.Open("ct/pub/HelpDialog.aspx", "帮助", paras, function (result) {
                                           if (result && result.Code) {
                                              sheet.suspendPaint(); 
                                               cellType.text(result.Name);
                                               sheet.getCell(row, col).text(result.Name);
                                               sheet.getCell(row, col).value(result.Name);
                                               sheet.resumePaint();
                                              

                                               for (var i = 0; i < Grid1.getColumnCount() ; i++) {
                                                   var CellTage = Grid1.getTag(row, i);
                                                   var vsSql;
                                                   //获取单元格基本信息
                                                   if (CellTage && CellTage.split("|")[2]) {
                                                       var cellFormat = JSON2.parse(CellTage.split("|")[2]);
                                                       if (cellFormat["CellType"] == "05") {

                                                           vsSql = cellFormat.CellValue;
                                                           if (vsSql.split(",").length > 1) {
                                                               for (var j = 1; j < vsSql.split(",").length; j++) {
                                                                   var vsStr = vsSql.split(",")[j];
                                                                   var vsWhereWord = vsStr.split("=")[1];
                                                                   var vsWordValue = Grid1.getCell(row, vsWhereWord.split("@")[1]).value();
                                                                   if (vsWhereWord.split("@")[1] == "1")
                                                                       vsWordValue = "'" + vsWordValue + "'";
                                                                   vsSql = vsSql.replace(vsWhereWord, vsWordValue);

                                                                   var para = { vsSqls: vsSql,CRow:row,CCol:i };
                                                                   para = CreateParameter(BasicAction.ActionType.Post, BasicAction.Functions.DictionaryManager, BasicAction.Methods.DicManagerMethods.GetSqlCellValue, para);
                                                                   para = DataManager.sendData(urls.HelpUrl, para, resultManager.LoadSql_Success, resultManager.Fail, false);
                                                               }
                                                           }

                                                       }


                                                   }

                                               }
                                               
                                              
                                           }
                                       }, { width: 600, height: 550 });
                                    
                                    
                                   }
                               }
                           }
                           //CellValueChange(args.row);
                       }
                       catch (err) {
                          
                               alert(err.Message);
                           }
                   }
               
               },
               WindwoBoxMeg :function()
               {
                   alert("ddd");
               }
               ,
               CellValueChange: function (row) {

                   for (var i = 0; i < Grid1.getColumnCount() ; i++) {
                       var CellTage = Grid1.getTag(row, i);
                       var vsSql;
                       //获取单元格基本信息
                       if (CellTage && CellTage.split("|")[2]) {
                           var cellFormat = JSON2.parse(CellTage.split("|")[2]);
                           if (cellFormat["CellType"] == "05") {

                               vsSql = cellFormat.CellValue;
                               if (vsSql.split(",").length > 1) {
                                   for (var j = 1; j < vsSql.split(",").length; j++) {
                                       var vsStr = vsSql.split(",")[j];
                                       var vsWhereWord = vsStr.split("=")[1];
                                       var vsWordValue = Grid1.getCell(row, vsWhereWord.split("@")[1]).value();
                                       if (vsWhereWord.split("@")[1] == "1")
                                           vsWordValue = "'" + vsWordValue + "'";
                                       vsSql = vsSql.replace(vsWhereWord, vsWordValue);

                                       var para = { vsSqls: vsSql, CRow: row, CCol: i };
                                       para = CreateParameter(BasicAction.ActionType.Post, BasicAction.Functions.DictionaryManager, BasicAction.Methods.DicManagerMethods.GetSqlCellValue, para);
                                       para = DataManager.sendData(urls.HelpUrl, para, resultManager.LoadSql_Success, resultManager.Fail, false);
                                   }
                               }

                           }


                       }

                   }
               },
               DealCellLock:function ()
               {
                   if (Grid1) {
                      // Grid1.suspendPaint();
                       for (var i = 0; i < Grid1.getRowCount() ; i++) {
                           for (var j = 0; j < Grid1.getColumnCount() ; j++) {
                               var tag = Grid1.getTag(i, j);
                               if (tag == null || tag == "") {
                                   Grid1.getCell(i, j).locked(true);
                               }
                               else {
                                   Grid1.getCell(i, j).locked(false);
                               }
                           }
                       }
                      // Grid1.resumePaint();
                   }
               },
               GridClipboardChanged: function (e, args)
               {
                  // Grid1.setValue(args.cellRange.row, args.cellRange.col, value);
                   args.sheet.getCell(args.cellRange.row, 20).tag(null);
                 
               }
               ,
               AddGridHelp: function (cellHelp) {
                   $.each(cellHelp, function (index, item) {
                       Grid1.ComboBox(0).AddItem(item.Name);
                   });
               }
           };
           window.onresize = function () {
              // Grid1.width = window.document.body.offsetWidth;
               $("#ss").width(window.document.body.offsetWidth);
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
                   var resultArrary = value.split(";");
                   var resultValue = "";
                   for (var i = 0; i < resultArrary.length; i++)
                   {
                       var strValue = resultArrary[i].split("@");
                       if (strValue.length < 2)
                           return result;
                       if (strValue[0] == "1") {
                           resultValue = resultValue+Grid1.getCell(strValue[1].split(',')[0], strValue[1].split(',')[1]).value();
                       }
                       else {
                           resultValue =resultValue+ Grid1.getCell(row, parseInt(strValue[1])).value();
                       }
                   }
                   if (resultValue.length > 0)
                       result = resultValue;
                   //var strValue = value.split('@');
                   //if (strValue.length < 2)
                   //    return result;
                   //if (strValue[0] == "1") {
                   //    result = Grid1.getCell(strValue[1].split(',')[0], strValue[1].split(',')[1]).value();
                   //}
                   //else {
                   //    result = Grid1.getCell(row, parseInt(strValue[1]) ).value();
                   //}

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
               LoadSql_Success: function (data) {
                   try {
                       if (data.obj)
                       {
                           var vsCellValue = data.obj.split(";")[0];
                           var vsRow = parseInt(data.obj.split(";")[1].split(",")[0]);
                           var vsCol = parseInt(data.obj.split(";")[1].split(",")[1]);
                           Grid1.getCell(vsRow, vsCol).text(vsCellValue);
                           Grid1.getCell(vsRow, vsCol).value(vsCellValue);

                       }
                   } catch (err) {
                       alert(err.Message);
                   }
               },
               GetCellTagURL_Success: function (data) {
                   try {
                       if (data.obj)
                       {
                           var row = data.obj.CellRow;
                           var col = data.obj.CellCol;
                           var cellsType = Grid1.getCellType(row, col);
                           
                           var vsUrlValue = GetRequest(data.obj.UrlValue, row, col);
                           Grid1.getCell(parseInt(row), parseInt(col)).cellType(cellsType).value(vsUrlValue);
                       }
                      

                   } catch (err) {
                       alert(err.Message);
                   }
               },
               Fail: function (data) {
                   alert(data);
               }
           };
           function exportToExcel() {
               var fileName = getFileName();
               var json = spread.toJSON({ includeBindingSource: true });
               excelIO.save(json, function (blob) {
                   saveAs(blob, fileName + ".xlsx");
               }, function (e) {
                   alert(e);
               });
           }
               function getFileName() {
                   function to2DigitsString(num) {
                       return ("0" + num).substr(-2);
                   }

                   var date = new Date();
                   return [
                       "Export",
                       date.getFullYear(), to2DigitsString(date.getMonth() + 1), to2DigitsString(date.getDate()),
                       to2DigitsString(date.getHours()), to2DigitsString(date.getMinutes()), to2DigitsString(date.getSeconds())
                   ].join("");
               }
               function CheckCellType(row, col)
               {
                  var  cellType = Grid1.getCellType(row, col);
                  if (cellType instanceof GC.Spread.Sheets.CellTypes.Button || cellType instanceof GC.Spread.Sheets.CellTypes.HyperLink)
                       return false;
                   else
                       return true;
               }
        </script>
</body>
</html>
