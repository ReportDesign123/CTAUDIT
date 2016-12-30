<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddFormular.aspx.cs" Inherits="Audit.ct.Format.AddFormular" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
     <meta http-equiv="X-UA-Compatible" content="IE=10" />
     <meta http-equiv="X-UA-Compatible" content="IE=9" />
     <meta http-equiv="X-UA-Compatible" content="IE=8" />
     <meta http-equiv="X-UA-Compatible" content="IE=7" />
     <link href="../../lib/ligerUI/skins/Aqua/css/ligerui-all.css" rel="stylesheet" type="text/css" />
         <link href="../../Styles/default.css" rel="stylesheet" type="text/css" />
             <link href="../../Styles/FormatManager.css" rel="stylesheet" type="text/css" />
   
    
    <link rel="stylesheet" href="../../lib/SpreadCSS/gcspread.sheets.excel2013white.9.40.20153.0.css" title="spread-theme" />
      <script type="text/javascript" src="../../lib/jquery/jquery-1.11.1.min.js"></script>
    <script src="../../lib/jquery/jquery-ui-1.10.3.custom.min.js" type="text/javascript"></script>
     <script type="text/javascript" src="../../lib/SpreadJS/gcspread.sheets.all.9.40.20153.0.min.js"></script>
     <script type="text/javascript" src="../../lib/SpreadJS/gcspread.sheets.print.9.40.20153.0.min.js"></script>
      <script type="text/javascript" src="../../lib/SpreadJS/FileSaver.min.js"></script>
    <script type="text/javascript" src="../../lib/SpreadJS/resources.js"></script>
     <script type="text/javascript" src="../../lib/SpreadJS/bootstrap.min.js"></script>




    <script src="../../lib/jquery/jquery-1.3.2.min.js" type="text/javascript"></script>
     <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script src="../../lib/ligerUI/js/core/base.js" type="text/javascript"></script>
    <script src="../../lib/ligerUI/js/ligerui.min.js" type="text/javascript"></script>
    <script src="../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <script src="../../lib/json2.js" type="text/javascript"></script>
   
    <script src="../../lib/Base64.js" type="text/javascript"></script>
    <script src="../../lib/ligerUI/js/plugins/ligerGrid.js" type="text/javascript"></script>
    <script src="../../Scripts/Format/FormularGuid.js" type="text/javascript"></script>
    <script src="../../lib/ligerUI/js/plugins/ligerComboBox.js" type="text/javascript"></script>
    <script src="../../lib/ligerUI/js/plugins/ligerCheckBox.js" type="text/javascript"></script>

    <script src="../../Scripts/Format/AddFormular.js" type="text/javascript"></script>

     <link href="../../lib/ligerUI/skins/ligerui-icons.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript">
        var spreadNS;
        var spread;
        var Grid1;
        var fbx, isShiftKey = false;

        var urls = {
            functionsUrl: "../../handler/FormatHandler.ashx",
            newFormularUrl: "NewFormular.aspx",
            InfoContent: "../pub/ContentInfo.aspx"
        };

        var bdq = { Code: "", BdType: "", Offset: -1, SortRow: 2, DataCode: 2, DataName: 3, isOrNotMerge: false };
        var BBData = { bbCode: "", bbName: "", bbData: {}, bdq: { bdNum: 0, BdRowNum: 0, BdColNum: 0, BdqMaps: {}, Bdqs: []} };
        var FormularData = { formularMaps: {}, currentFormular: {}, currentIndex: "", curentSequence: "", reportCode: "", oldFormularType: "1" };      //公式信息以数据和maps两大对形象;oldFormularType是指上一公式类型1为取数；2为计算；3为平衡公式;
        var rowColFormular = {};//单元格与公式相互结合结构
        var formular = { firstRow: "", firstCol: "", lastRow: "", lastCol: "", content: "", isOrNotTake: "", isOrNotBatch: "", isOrNotCaculate: "", option: "", sequence: "",FormularDb:"",FixOrChangeRegion:"",RegionTableName:"",Error:"",FormularLevel:0 };
        var cellData = { FontName: "", FontSize: "" };
        var cellNameValue = { FontName: "FontName", FontSize: "FontSize", FontBold: "FontBold", FontItalic: "FontItalic", FontUnderline: "FontUnderline ",
            Alignment: "Alignment ", ForeColor: "ForeColor", BackColor: "BackColor", Border: "Border", CellCode: "CellCode", CellName: "CellName",
            CellRow: "CellRow", CellCol: "CellCol", CellLogicalType: "CellLogicalType", CellType: "CellType", CellDataType: "CellDataType", CellMacro: "CellMacro", CellHelp: "CellHelp", CellLength: "CellLength",
            CellThousand: "CellThousand", CellCurrence: "CellCurrence", CellSmbol: "CellSmbol", CellLock: "CellLock", CellZero: "CellZero"
        };
        var cellControls = { FontName: {}, FontSize: {}, CellLogicalType: {}, CellType: {}, CellDataType: {}, CellMacro: {}, CellHelp: {}, CellThousand: {},
            CellCurrence: {}, CellSmbol: {}, CellLock: {}, CellZero: {}
        };
        var cellFlag = { cellSetFlag: true };
        var rightControls = { FormulaGrid: {}, FormularData: {}, cellLength:0, InputBox: "formularContent" };
        var ContrastSginData = [{ id: '>', text: '>' },
            { id: '==', text: '==' },
            { id: '<', text: '<' },
            { id: '>=', text: '>=' },
            { id: '=<', text: '=<' },
            { id: '!=', text: '!='}];
        var CountSginData = [{ id: '+', text: '+' },
            { id: '-', text: '-' },
            { id: '*', text: '*' },
            { id: '/', text: '/' }];
            $(function () {
                //右侧窗口内容
                $("#formularGridToobar").ligerToolBar({ items: [
                { text: '新建', click: itemclick, icon: 'add' },
                { line: true },
                { text: '编辑', click: itemclick, icon: 'modify' },
                { line: true },
                { text: '删除', click: itemclick, icon: 'delete' }
            ]
                });
                $("#formularEditToobar").ligerToolBar({ items: [
                { text: '保存', click: itemclick, icon: 'add' },
                { line: true },
                { text: '返回', click: itemclick, icon: 'prev' }
            ]
                });

                $("#CountSgin").ligerComboBox(
            {
                data: CountSginData,
                valueField: 'id',
                textField: 'text',
                resize: false,
                width: 40,
                emptyText: null,
                autocomplete: true,
                onBeforeSelect: function (value) {
                    var Content = $("#" + rightControls.InputBox).text();
                    Content += value;
                    $("#" + rightControls.InputBox).text(Content);
                }
            });
                $("#ContrastSgin").ligerComboBox(
            {
                data: ContrastSginData,
                valueField: 'id',
                textField: 'text',
                resize: false,
                width: 40,
                emptyText: null,
                autocomplete: true,
                onBeforeSelect: function (value) {
                    var Content = $("#" + rightControls.InputBox).text();
                    Content += value;
                    $("#" + rightControls.InputBox).text(Content);
                }
            });
                rightControls.FormulaGrid = $("#formulaGrid").ligerGrid({
                    width: '99%',
                    height: '100%',
                    rownumbers: true,
                    isScroll: true,
                    resizable: false,
                    columns: [
                 { display: '公式列表', name: 'content', align: 'left', width: 280 }
                 ]
                });
                //开始加载窗口内容
                //                var node = window.dialogArguments;
                //             node = { Id: "65849fd5-c047-4393-b4f1-e2c5e8f7f4fc" };




                $("#FileToolBar").ligerToolBar({ items: [
                { text: '取数公式向导', click: itemclick, icon: 'add' },
                { text: '取数公式编辑', click: itemclick, icon: 'modify' },
                { text: '删除公式', click: itemclick, icon: 'delete' },
                { text: '保存公式', click: itemclick, icon: 'ok' },
                { line: true }

            ]
                });
                function itemclick(item) {
                    if (item.text == "保存公式") {
                        formularManager.SaveFormular();
                    } else if (item.text == "删除公式") {
                        formularManager.RemoveFormular();
                    } else if (item.text == "取数公式向导") {
                        formularManager.NewFormular();
                    } else if (item.text == "取数公式编辑") {
                        formularManager.EditFormular();
                    } else if (item.text == "新建") {
                        $("#formularContent").text("");
                        $("#formularCondition").text("");
                        $("#ErrorInfo").text("");
                        $("#formularGridToobar").css("display", "none");
                        $("#formularEditWindow").css("display", "block");
                        $("#formulaGrid").ligerGrid({ width: '100%' });
                    } else if (item.text == "编辑") {
                        formularManager.BalanceIfManager.EditFormular();
                    } else if (item.text == "删除") {
                        formularManager.BalanceIfManager.DeletFormular();
                    } else if (item.text == "保存") {
                        formularManager.BalanceIfManager.SaveBalanceFormular();
                    } else if (item.text == "返回") {
                        $("#formularGridToobar").css("display", "block");
                        $("#formularEditWindow").css("display", "none");
                        $("#formulaGrid").ligerGrid({ width: '99%' });
                        rightControls.FormularData = {};
                        rightControls.cellLength = 0;
                    }

                }
                $("#layout1").ligerLayout({ allowRightCollapse: true, allowRightResize: true, isRightCollapse: false, rightWidth: 370, onEndResize: formularManager.BalanceIfManager.LoadFormularGrid });
                $("#fokBtn").bind("click", formularManager.createFormular);
                $("#fnoBtn").bind("click", formularManager.RemoveFormular);

                $("#takeCheck").bind("click", formularManager.CheckBoxManager.TakeCheckSelected);
                $("#cacuCheck").bind("click", formularManager.CheckBoxManager.CacuCheckSelected);
                $("#balaCheck").bind("click", formularManager.CheckBoxManager.BalanceCheckSelected);

                spreadNS = GcSpread.Sheets;
                spread = new spreadNS.Spread($("#ss")[0]);
                spread.setTabStripRatio(0.88);
                Grid1 = new spreadNS.Sheet("Cell");
                spread.removeSheet(0);
                spread.addSheet(spread.getSheetCount(), Grid1);
                Grid1.setIsProtected(true); //是否锁定
                InitializeFlexCell(8, 5);

                

             
                var node = GetParameters();
                if (node != undefined && node.Id != undefined) {
                    document.title = node.bbCode + "--" + node.bbName + "　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　";
                    var para = { Id: "" };
                    para.Id = node.Id;
                    para = CreateParameter(ReportFormatAction.ActionType.Post, ReportFormatAction.Functions.ReportFormatMenu, ReportFormatAction.Methods.ReportFormatMenuMethods.LoadReportFormat, para);

                    DataManager.sendData(urls.functionsUrl, para, resultManagers.LoadSuccess, resultManagers.fail, false);
                }


            });

            function getPosion(sender, args) {
                if (Grid1) {
                    var Frow = args.row;
                    var Lrow = Frow;
                    var FCol = args.col;
                    var LCol = FCol;

                    $("#cellIndentity").val(Frow + "," + Lrow + ":" + FCol + "," + LCol);
                }
            }

            function InitializeFlexCell(row, col) {

            if (Grid1) {
         
                Grid1.isPaintSuspended(true);
                Grid1.setColumnCount(col);
                Grid1.setRowCount(row);
                Grid1.isPaintSuspended(false);

                BBData = { bbCode: "", bbName: "", bbData: {}, bdq: { bdNum: 0, BdRowNum: 0, BdColNum: 0, BdqMaps: {}, Bdqs: []} };
            }

        }

        var controlsManager = {
            InitializeControls: function () {
                $("#fxContent").val("");
                if (FormularData.oldFormularType == "1") {
                    $("#takeCheck").attr("checked", "checked");
                    $("#balaCheck").attr("checked", "");
                    $("#cacuCheck").attr("checked", "");
                } else if (FormularData.oldFormularType == "2") {
                    $("#takeCheck").attr("checked", "");
                    $("#balaCheck").attr("checked", "");
                    $("#cacuCheck").attr("checked", "checked");
                } else if (FormularData.oldFormularType == "3") {
                    $("#takeCheck").attr("checked", "");
                    $("#balaCheck").attr("checked", "checked");
                    $("#cacuCheck").attr("checked", "");
                }
               
                
            }
        };

        var cellManager = {
            GeneralCell: function (func, value) {

               
                var sels = Grid1.getSelections();
                var endRow;
                var endCol;

                endRow = row + sels[0].rowCount - 1; // Grid1.Selection.LastRow;
                endCol = col + sels[0].colCount - 1; //Grid1.Selection.LastCol;

                for (var i = Grid1.getActiveRowIndex(); i <= endRow; i++) {
                    for (var j = Grid1.getActiveColumnIndex(); j <= endCol; j++) {
                        func(i, j, value);
                    }
                }

            },
            GeneralCellCopy: function (func, value) {

                var sels = Grid1.getSelections();
                var endRow;
                var endCol;

                endRow = row + sels[0].rowCount - 1; // Grid1.Selection.LastRow;
                endCol = col + sels[0].colCount - 1; //Grid1.Selection.LastCol;
                for (var i = Grid1.getActiveRowIndex(); i <= endRow; i++) {
                    for (var j = Grid1.getActiveColumnIndex(); j <= endCol; j++) {
                        func(i, j, i, j, value);
                    }
                }
            },
            GeneralLoadCellDataValue: function (row, col) {
                row = Grid1.getActiveRowIndex(); // Grid1.Selection.FirstRow;
                col = Grid1.getActiveColumnIndex(); //Grid1.Selection.FirstCol;
                var sels = Grid1.getSelections();
                var endRow;
                var endCol;
               
                endRow = row + sels[0].rowCount-1; // Grid1.Selection.LastRow;
                endCol = col + sels[0].colCount-1; //Grid1.Selection.LastCol;
                
                cellFlag.cellSetFlag = false;
                var cellData = toolManager.GetCellData(row, col);

                var position = toolManager.Formular.GetFormularPosition(row, col, endRow, endCol);
                $("#cellIndentity").val(position);
                //为右侧公式内容添加单元格
                //张双义
                formularManager.BalanceIfManager.AddContent(row, col, endRow, endCol);
                if (FormularData.formularMaps[position] != undefined) {
                    var formularCell = FormularData.formularMaps[position][0];
                    FormularData.currentIndex = position;
                    FormularData.curentSequence = 0;
                    FormularData.currentFormular = formularCell;
                    $("#fxContent").val(formularCell.content);

                    $("#optionSelect").val(formularCell.option);
                    if (formularCell.isOrNotTake && formularCell.isOrNotTake == "1") {
                        $("#takeCheck").attr("checked", "checked");
                        FormularData.oldFormularType = "1";
                    } else if (formularCell.isOrNotTake && formularCell.isOrNotTake == "0") {
                        $("#takeCheck").attr("checked", "");
                    }
                    if (formularCell.isOrNotBatch && formularCell.isOrNotBatch == "1") {
                        $("#balaCheck").attr("checked", "checked");
                        FormularData.oldFormularType = "3";
                    } else if (formularCell.isOrNotBatch && formularCell.isOrNotBatch == "0") {
                        $("#balaCheck").attr("checked", "");
                    }
                    if (formularCell.isOrNotCaculate && formularCell.isOrNotCaculate == "1") {
                        $("#cacuCheck").attr("checked", "checked");
                        FormularData.oldFormularType = "2";
                    } else if (formularCell.isOrNotCaculate && formularCell.isOrNotCaculate == "0") {
                        $("#cacuCheck").attr("checked", "");
                    }

                } else {

                    FormularData.currentIndex = undefined;
                    FormularData.curentSequence = undefined;
                    FormularData.currentFormular = undefined;
                    controlsManager.InitializeControls();

                }

                if (cellData == null) {

                } else {

                }

            },
            FontFunc_Select: function (value, text) {
                if (value && cellFlag.cellSetFlag) {
                    Grid1.Selection.FontName = value;
                    cellManager.GeneralCell(GridManager.SetFontName, value);
                }
            },
            FontSizeFuncSelect: function (value, text) {
                if (value && cellFlag.cellSetFlag) {
                    Grid1.Selection.FontSize = value;
                    cellManager.GeneralCell(GridManager.SetFontSize, value);
                }
            },
            FontBold_Click: function (flag) {
                Grid1.Selection.FontBold = flag;
                cellManager.GeneralCell(GridManager.SetFontBold, flag);
            },
            FontItalic_Click: function (flag) {
                Grid1.Selection.FontItalic = flag;
                cellManager.GeneralCell(GridManager.SetFontItalic, flag);
            },
            FontUnderLine_Click: function (flag) {
                Grid1.Selection.FontUnderline = flag;
                cellManager.GeneralCell(GridManager.SetFontUnderline, flag);
            },
            Alignment_Click: function (flag, alignment) {
                if (flag) {
                    Grid1.Selection.Alignment = alignment;
                    cellManager.GeneralCell(GridManager.SetCellAlignment, alignment);
                } else {
                    Grid1.Selection.Alignment = "0";
                    cellManager.GeneralCell(GridManager.SetCellAlignment, "0");
                }
            },
            ForeColor_Click: function (foreColor) {

                Grid1.Selection.ForeColor = foreColor;
            },
            BackColor_Click: function (backColor) {
                Grid1.Selection.BackColor = backColor;
            },
            Border_Click: function (edge, value) {
                var edges = [];
                var values = [];
                if (edge.toString().indexOf("|") == -1) {
                    Grid1.Selection.Borders(edge) = value;
                } else {

                    edges = edge.split("|");
                    values = value.split("|");
                    for (var i = 0; i < edges.length; i++) {

                        Grid1.Selection.Borders(edges[i]) = values[i];
                    }
                }
            },
            CellLogicalType_Selected: function (value, text) {
                if (toolManager.StrIsNullOrEmpty(value) && cellFlag.cellSetFlag) {
                    if (value == "01") {
                        cellManager.GeneralCell(GridManager.SetItemNameText, value);
                    } else if (value == "02") {
                        cellManager.GeneralCell(GridManager.SetItemDataText, value);
                    } else {
                        cellManager.GeneralCell(GridManager.SetBlankItemType);
                        cellManager.GeneralCell(toolManager.DeleteRowColData);
                    }

                }

            },
            CellDataType_Select: function (value, text) {
                if (toolManager.StrIsNullOrEmpty(value) && cellFlag.cellSetFlag && value != "") {
                    cellManager.GeneralCell(GridManager.SetCellData, value);
                }
            },
            CellSmbol_Select: function (value, text) {
                if (toolManager.StrIsNullOrEmpty(value) && cellFlag.cellSetFlag && value != "") {
                    cellManager.GeneralCell(GridManager.SetCellSymbol, value);
                }
            },
            CellCurrence_Select: function (value, text) {
                if (toolManager.StrIsNullOrEmpty(value) && cellFlag.cellSetFlag && value != "") {
                    cellManager.GeneralCell(GridManager.SetCellCurrence, value);
                }
            },
            CellThousand_Select: function (value, text) {
                if (toolManager.StrIsNullOrEmpty(value) && cellFlag.cellSetFlag && value != "") {
                    cellManager.GeneralCell(GridManager.SetCellThousand, value);
                }
            },
            CellLock_Select: function (value, text) {
                if (toolManager.StrIsNullOrEmpty(value) && cellFlag.cellSetFlag && value != "") {
                    cellManager.GeneralCell(GridManager.SetCellLock, value);
                }
            },
            CellZero_Select: function (value, text) {
                if (toolManager.StrIsNullOrEmpty(value) && cellFlag.cellSetFlag && value != "") {
                    cellManager.GeneralCell(GridManager.SetCellZero, value);
                }
            },
            CellType_Select: function (value, text) {
                if (toolManager.StrIsNullOrEmpty(value) && cellFlag.cellSetFlag && value != "") {
                    cellManager.GeneralCell(GridManager.SetCellType, value);
                }
            },
            CellMaro_Click: function () {
                alert("ss");
            },
            CellHelp_Click: function () {
                alert("ss");
            }
        };

        var GridManager = {
            printView: function () {
                Grid1.PrintPreview();
            },
            Print: function () {
                Grid1.PrintDialog();
            },
            MergeCell: function () {
                Grid1.Selection.Merge();
            },
            CancelMerge: function () {
                Grid1.Selection.MergeCells = false;
            },
            InsertRow: function () {
                Grid1.Selection.InsertRows();

            },
            InsertCol: function () {
                Grid1.Selection.InsertCols()

            },
            DeleteRow: function () {
                Grid1.Selection.DeleteByRow();

            },
            DeleteCol: function () {
                Grid1.Selection.DeleteByCol();

            },
            SetFontName: function (row, col, fontName) {
                toolManager.SetCellData(row, col, cellNameValue.FontName, fontName);
            },
            SetFontSize: function (row, col, fontSize) {
                toolManager.SetCellData(row, col, cellNameValue.FontSize, fontSize);
            },
            SetFontBold: function (row, col, fontBold) {
                toolManager.SetCellData(row, col, cellNameValue.FontBold, fontBold);
            },
            SetFontItalic: function (row, col, fontItalic) {
                toolManager.SetCellData(row, col, cellNameValue.FontItalic, fontItalic);
            },
            SetFontUnderline: function (row, col, fontUnderline) {
                toolManager.SetCellData(row, col, cellNameValue.FontUnderline, fontUnderline);
            },
            RowColChange_Event: function (row, col) {
                cellManager.GeneralLoadCellDataValue(row, col);
            },
            SetCellAlignment: function (row, col, alignment) {

                toolManager.SetCellData(row, col, cellNameValue.Alignment, alignment);
            }
            ,
            SetForeColor: function (row, col, foreColor) {

                toolManager.SetCellData(row, col, cellNameValue.ForeColor, foreColor);
            },
            SetBackColor: function (row, col, backColor) {

                toolManager.SetCellData(row, col, cellNameValue.BackColor, backColor);
            },
            SetBorder: function (row, col, edge, value) {
                toolManager.SetCellData(row, col, cellNameValue.Border, edge + ":" + value);

            },
            SetChangeRow: function (para) {
                var temp = Grid1.Selection;
                var rowNum = temp.FirstRow;
                var cols = Grid1.Cols - 1;
                Grid1.Range(rowNum, 1, rowNum, cols).BackColor = toolManager.CovertColorStr("#FF99CC");
                para.Offset = rowNum;
                //变动行逻辑数据
                bdManager.CreateBdq("1", para);
            },
            CancelChangeRow: function () {
            },
            SetChangeCol: function (para) {
                var temp = Grid1.Selection;
                var colNum = temp.FirstCol;
                var rows = Grid1.Rows - 1;
                Grid1.Range(1, colNum, rows, colNum).BackColor = toolManager.CovertColorStr("#FF99CC");
                para.Offset = colNum;
                bdManager.CreateBdq("2", para);
            },
            CancelChangeCol: function () {
            },
            SetItemDataText: function (row, col, logicalType) {
                var cellData = toolManager.GetCellData(row, col);
                if (toolManager.IsNullOrEmpty(cellData, cellNameValue.CellLogicalType)) {
                    if (logicalType == cellData[cellNameValue.CellLogicalType]) return;
                }
                toolManager.SetCellData(row, col, cellNameValue.CellCol, col);
                toolManager.SetCellData(row, col, cellNameValue.CellRow, row);
                Grid1.setValue(row, col, toolManager.CreateRowColCode(row, col));

                // Grid1.Cell(row, col).Text = toolManager.CreateRowColCode(row, col);
                toolManager.SetCellData(row, col, cellNameValue.CellCode, toolManager.CreateCellCode(row, col));
                GridManager.InitializeItemData(row, col);

            },
            SetItemNameText: function (row, col, logicalType) {
                toolManager.SetCellData(row, col, cellNameValue.CellLogicalType, logicalType);
            },
            InitializeItemData: function (row, col) {
                toolManager.SetCellData(row, col, cellNameValue.CellLogicalType, "02");
                var cellType = cellControls.CellType.getValue();
                toolManager.SetCellData(row, col, cellNameValue.CellType, cellType);
                var cellDataType = cellControls.CellDataType.getValue();
                toolManager.SetCellData(row, col, cellNameValue.CellDataType, cellDataType);
                var cellLength = $("input[name='CellLength']").val();
                toolManager.SetCellData(row, col, cellNameValue.CellLength, cellLength);
                var currence = cellControls.CellCurrence.getValue();
                toolManager.SetCellData(row, col, cellNameValue.CellCurrence, currence);
                var symbol = cellControls.CellSmbol.getValue();
                toolManager.SetCellData(row, col, cellNameValue.CellSmbol, symbol);
                var lock = cellControls.CellLock.getValue();
                toolManager.SetCellData(row, col, cellNameValue.CellLock, lock);
                var thousand = cellControls.CellThousand.getValue();
                toolManager.SetCellData(row, col, cellNameValue.CellThousand, thousand);
            },
            SetCellText: function (row, col, value) {
                Grid1.setValue(row, col, value);
              
                //Grid1.Cell(row, col).Text = value;
            },
            SetBlankItemType: function (row, col) {
                var cell = toolManager.GetCellData(row, col);
                if (toolManager.IsNullOrEmpty(cell, cellNameValue.CellLogicalType)) {
                    if (cell.CellLogicalType == "02") {
                        GridManager.SetCellText(row, col, "");
                    }
                }
            },
            SetCellData: function (row, col, value) {
                var cellData = toolManager.GetCellData(row, col);
                if (toolManager.IsNullOrEmpty(cellData, cellNameValue.CellDataType)) {
                    if (value == cellData[cellNameValue.CellDataType]) return;
                }

            },
            SetCellSymbol: function (row, col, value) {
                var cellData = toolManager.GetCellData(row, col);
                if (toolManager.IsNullOrEmpty(cellData, cellNameValue.CellSmbol)) {
                    if (value == cellData[cellNameValue.CellSmbol]) return;
                }
                toolManager.SetCellData(row, col, cellNameValue.CellSmbol, value);
            },
            SetCellCurrence: function (row, col, value) {
                var cellData = toolManager.GetCellData(row, col);
                if (toolManager.IsNullOrEmpty(cellData, cellNameValue.CellCurrence)) {
                    if (value == cellData[cellNameValue.CellCurrence]) return;
                }
                toolManager.SetCellData(row, col, cellNameValue.CellCurrence, value);
            },
            SetCellThousand: function (row, col, value) {
                var cellData = toolManager.GetCellData(row, col);
                if (toolManager.IsNullOrEmpty(cellData, cellNameValue.CellThousand)) {
                    if (value == cellData[cellNameValue.CellThousand]) return;
                }
                toolManager.SetCellData(row, col, cellNameValue.CellThousand, value);
            },
            SetCellLock: function (row, col, value) {
                var cellData = toolManager.GetCellData(row, col);
                if (toolManager.IsNullOrEmpty(cellData, cellNameValue.CellLock)) {
                    if (value == cellData[cellNameValue.CellLock]) return;
                }
                toolManager.SetCellData(row, col, cellNameValue.CellLock, value);
            },
            SetCellZero: function (row, col, value) {
                var cellData = toolManager.GetCellData(row, col);
                if (toolManager.IsNullOrEmpty(cellData, cellNameValue.CellZero)) {
                    if (value == cellData[cellNameValue.CellZero]) return;
                }
                toolManager.SetCellData(row, col, cellNameValue.CellZero, value);
            },
            SetCellType: function (row, col, value) {
                var cellData = toolManager.GetCellData(row, col);
                if (toolManager.IsNullOrEmpty(cellData, cellNameValue.CellType)) {
                    if (value == cellData[cellNameValue.CellType]) return;
                }
                toolManager.SetCellData(row, col, cellNameValue.CellType, value);
            },
            SetCellMacro: function (row, col, value) {
                var cellData = toolManager.GetCellData(row, col);
                if (toolManager.IsNullOrEmpty(cellData, cellNameValue.CellMacro)) {
                    if (value == cellData[cellNameValue.CellMacro]) return;
                }
                toolManager.SetCellData(row, col, cellNameValue.CellMacro, value);
            },
            SetCellHelp: function (row, col, value) {
                var cellData = toolManager.GetCellData(row, col);
                if (toolManager.IsNullOrEmpty(cellData, cellNameValue.CellHelp)) {
                    if (value == cellData[cellNameValue.CellHelp]) return;
                }
                toolManager.SetCellData(row, col, cellNameValue.CellHelp, value);
            }
        };
        var bdManager = {
            CreateBdq: function (type, bdPara) {
                BBData.bdq.bdNum = BBData.bdq.bdNum + 1;

                if (type == "1") {
                    BBData.bdq.BdRowNum++;
                } else {
                    BBData.bdq.BdColNum++;
                }
                //增加变动区描述
                var bdq = { Code: "", BdType: "", Offset: -1, SortField: 2, DataCode: 2, DataName: 3, isOrNotMerge: false };
                bdq.Code = toolManager.CreateBdqCode(BBData.bdq.bdNum);
                bdq.BdType = type;
                bdq.Offset = bdPara.Offset;
                bdq.SortField = bdPara.SortField;
                bdq.DataCode = bdPara.DataCode;
                bdq.DataName = bdPara.DataName;
                bdq.isOrNotMerge = bdPara.Merge;
                BBData.bdq.Bdqs.push(bdq);
                BBData.bdq.BdqMaps[bdq.Code] = BBData.bdq.Bdqs.length - 1;
            }
        };

        var toolManager = {
            CreateCellData: function (row, col) {
                if (BBData.bbData[row] == undefined || BBData.bbData[row] == null) {
                    BBData.bbData[row] = {};
                }
                if (BBData.bbData[row][col] == undefined || BBData.bbData[row][col] == null) {
                    BBData.bbData[row][col] = {};
                }
                return BBData.bbData[row][col];
            },
            CreateFormularData: function (row, col) {
                if (FormularData[row] == undefined || FormularData[row] == null) {
                    FormularData[row] = {};
                }
                if (FormularData[row][col] == undefined || FormularData[row][col] == null) {
                    FormularData[row][col] = { firstRow: "", firstCol: "", lastRow: "", lastCol: "", content: "", isOrNotTake: "", isOrNotBatch: "", isOrNotCaculate: "", option: "", sequence: "" }; ;
                }
                return FormularData[row][col];
            },
            SetCellData: function (row, col, name, value) {
                var cell = toolManager.GetCellData(row, col);
                if (cell) {
                    if (cell[name] != value) {
                        cell[name] = value;
                    }
                } else {
                    cell = toolManager.CreateCellData(row, col);
                    cell[name] = value;
                }
            },
            GetCellData: function (row, col) {
                if (BBData.bbData[row] && BBData.bbData[row][col]) {
                    return BBData.bbData[row][col];
                } else {
                    return null;
                }
            },
            GetFormularData: function (row, col) {
                if (FormularData[row] != undefined && FormularData[row][col] != undefined) {
                    return FormularData[row][col];
                } else {
                    return null;
                }
            },
            RowColChange_Event: function (row, col) {
                var cellData = toolManager.GetCellData(row, col);
                if (cellData == null) {
                    InitializeControlValue();
                } else {

                }
            },
            SelectMoreOneCells: function () {
                var obj = Grid1.Selection;
                if ((obj.LastRow - obj.FirstRow) > 0 || (obj.LastCol - obj.FirstCol) > 0) {
                    return true;
                } else {
                    return false;
                }
            },
            IsNullOrEmpty: function (obj, name) {
                if (obj != undefined && name != undefined && obj[name] != undefined && obj[name] != null && obj[name] != "") {
                    return true;
                } else {
                    return false;
                }
            },
            StrIsNullOrEmpty: function (str) {
                if (str != undefined && str != null && str != "") {
                    return true;
                } else {
                    return false;
                }
            },
            CovertColorStr: function (colorStr) {
                var temp = colorStr.substring(1);
                var newColor = temp.substring(4, 6) + temp.substring(2, 4) + temp.substring(0, 2);
                return parseInt(newColor, 16);
            },
            CreateBdqCode: function (num, type) {
                var temp = num.toString();
                for (var i = temp.length; i < 4; i++) {
                    temp = "0" + temp;
                }
                if (type == "1") {
                    temp = "R" + temp;
                } else if (type == "2") {
                    temp = "C" + temp;
                }
                return temp;
            },
            CreateRowColCode: function (row, col) {
                var type = cellControls.CellDataType.getValue();
                var code = "[" + toolManager.CreateBdqCode(row) + toolManager.CreateBdqCode(col) + "," + type + "]";
                return code;
            },
            DeleteRowColData: function (row, col) {
                delete BBData.bbData[row][col];
            },
            CreateCellCode: function (row, col) {
                var code = toolManager.CreateBdqCode(row) + toolManager.CreateBdqCode(col);
                return code;
            },
            CreateCellPosition: function (firstRow, firstCol, lastRow, lastCol) {
                return firstRow + "," + firstCol + ":" + lastRow + "," + lastCol;
            },
            DeserializePositoin: function (position) {
                var data = { firstRow: "", firstCol: "", lastRow: "", lastCol: "" };
                if (position.indexOf(":") != -1) {
                    var tArr = position.split(":");
                    var fArr = tArr[0].split(",");
                    var lArr = tArr[1].split(",");
                    data.firstRow = fArr[0];
                    data.firstCol = fArr[1];
                    data.lastRow = lArr[0];
                    data.lastCol = lArr[1];
                } else {
                    data.firstRow = -1;
                    data.firstCol = -1;
                    data.lastRow = -1;
                    data.lastCol = -1;
                }

                return data;
            },
            Formular: {
                CreateFormularObj: function () {
                    return { Id: "", firstRow: "", firstCol: "", lastRow: "", lastCol: "", content: "", isOrNotTake: "", isOrNotBatch: "", isOrNotCaculate: "", option: "", sequence: "", ErrorInfo: "" };
                },
                AddEditCaculateFormular: function (firstRow, firstCol, lastRow, lastCol, methodType) {
                    var formular = {};
                    var position = toolManager.CreateCellPosition(firstRow, firstCol, lastRow, lastCol);
                    if (methodType == "add") {
                        formular = toolManager.Formular.CreateFormularObj();
                        FormularData.curentSequence = 0;
                        FormularData.currentIndex = position;
                        FormularData.formularMaps[position] = [];
                        FormularData.formularMaps[position].push(formular);
                        formular.firstRow = firstRow;
                        formular.firstCol = firstCol;
                        formular.lastRow = lastRow;
                        formular.lastCol = lastCol;
                        formular.Id = guid();
                        formular.sequence = 0;
                        var cellText = Grid1.getCell(formular.firstRow, formular.firstCol).text(); //Grid1.Cell(formular.firstRow, formular.firstCol).Text;
                        Grid1.setValue(formular.firstRow, formular.firstCol, "公式");

                        // Grid1.Cell(formular.firstRow, formular.firstCol).Text = "公式";
                        if (rowColFormular[formular.firstRow] == undefined) {
                            rowColFormular[formular.firstRow] = {};
                        }
                        if (rowColFormular[formular.firstRow][formular.firstCol] == undefined) {
                            rowColFormular[formular.firstRow][formular.firstCol] = {};
                        }
                        rowColFormular[formular.firstRow][formular.firstCol] = position;

                    } else if (methodType == "edit") {
                        formular = FormularData.formularMaps[position][0];
                    }


                    formular.option = $("#optionSelect").val();

                    formular.content = $("#fxContent").val();
                    if (formular.content == "" && cellText != "") {
                        formular.content = cellText;
                    }
                    if ($("#takeCheck").attr("checked")) {
                        formular.isOrNotTake = "1";
                        FormularData.oldFormularType = "1";
                        formular.isOrNotCaculate = "0";
                        formular.isOrNotBatch = "0";
                    } else {
                        formular.isOrNotTake = "0";

                    }
                    if ($("#cacuCheck").attr("checked")) {
                        formular.isOrNotCaculate = "1";
                        FormularData.oldFormularType = "2";
                        formular.isOrNotTake = "0";
                        formular.isOrNotBatch = "0";
                    } else {
                        formular.isOrNotCaculate = "0";
                    }

                    if ($("#balaCheck").attr("checked")) {
                        formular.isOrNotBatch = "1";
                        FormularData.oldFormularType = "3";
                        formular.isOrNotCaculate = "0";
                        formular.isOrNotTake = "0";
                    } else {
                        formular.isOrNotBatch = "0";
                    }

                    FormularData.currentFormular = formular;
                    FormularData.currentIndex = position;
                    //设置公式类型，是固定区还是变动区
                    toolManager.SetBdq();
                },
                AddEditFormular: function (methodType) {
                    var formular = {};
                    var position = $("#cellIndentity").val();
                    var data = toolManager.DeserializePositoin(position);

                    if (methodType == "add") {
                        formular = toolManager.Formular.CreateFormularObj();
                        FormularData.curentSequence = 0;
                        FormularData.currentIndex = position;
                        FormularData.formularMaps[position] = [];
                        FormularData.formularMaps[position].push(formular);
                        formular.firstRow = data.firstRow;
                        formular.firstCol = data.firstCol;
                        formular.lastRow = data.lastRow;
                        formular.lastCol = data.lastCol;
                        formular.Id = guid();
                        formular.sequence = 0;
                        Grid1.setValue(formular.firstRow, formular.firstCol, "公式");

                        // Grid1.Cell(formular.firstRow, formular.firstCol).Text = "公式";
                        if (rowColFormular[formular.firstRow] == undefined) {
                            rowColFormular[formular.firstRow] = {};
                        }
                        if (rowColFormular[formular.firstRow][formular.firstCol] == undefined) {
                            rowColFormular[formular.firstRow][formular.firstCol] = {};
                        }
                        rowColFormular[formular.firstRow][formular.firstCol] = position;

                    } else if (methodType == "edit") {
                        if (!FormularData.formularMaps[position]) return;
                        formular = FormularData.formularMaps[position][0];
                    }


                    formular.option = $("#optionSelect").val();
                    formular.content = $("#fxContent").val();
                    if ($("#takeCheck").attr("checked")) {
                        formular.isOrNotTake = "1";
                        FormularData.oldFormularType = "1";
                    } else {
                        formular.isOrNotTake = "0";
                    }
                    if ($("#cacuCheck").attr("checked")) {
                        formular.isOrNotCaculate = "1";
                        FormularData.oldFormularType = "2";
                    } else {
                        formular.isOrNotCaculate = "0";
                    }

                    if ($("#balaCheck").attr("checked")) {
                        formular.isOrNotBatch = "1";
                        FormularData.oldFormularType = "3";
                    } else {
                        formular.isOrNotBatch = "0";
                    }

                    FormularData.currentFormular = formular;
                    //设置公式类型，是固定区还是变动区
                    toolManager.SetBdq();
                },
                GetFormular: function () {

                },
                GetFormularPosition: function (row, col, lastRow, lastCol) {
                    var p = "";
                    $.each(FormularData.formularMaps, function (position) {
                        var data = toolManager.DeserializePositoin(position);
                        if ((row >= data.firstRow && lastRow <= data.lastRow) && (col >= data.firstCol && lastCol <= data.lastCol)) {
                            p = position;
                        }
                    });
                    if (p == "") {
                        p = toolManager.CreateCellPosition(row, col, lastRow, lastCol);
                    }
                    return p;
                },
                RemoveFormular: function () {



                    var selection = Grid1.getSelections(); // Grid1.Selection;
                    var row = Grid1.getActiveRowIndex(); // selection.FirstRow;
                    var col = Grid1.getActiveColumnIndex(); // selection.FirstCol;
                    if (rowColFormular[row] != undefined && rowColFormular[row][col] != undefined) {
                        var position = rowColFormular[row][col];
                        var data = toolManager.DeserializePositoin(position);
                        //Grid1.Cell(row, col).Text = "";
                        Grid1.setValue(row, col, "");
                       
                        delete FormularData.formularMaps[FormularData.currentIndex];
                        FormularData.curentSequence = undefined;
                        FormularData.currentIndex = undefined;
                        delete rowColFormular[row][col];
                        controlsManager.InitializeControls();
                    } else {
                        if (FormularData.formularMaps[FormularData.currentIndex]) {
                            delete FormularData.formularMaps[FormularData.currentIndex];
                        }
                    }
                }
            },
            //设置公式类型，是固定区还是变动区
            SetBdq: function () {
                var flag = false;
                $.each(BBData.bdq.Bdqs, function (index, item) {
                    if (item == null) return;
                    if (item.BdType == "1") {
                        if (FormularData.currentFormular.firstRow == FormularData.currentFormular.lastRow && FormularData.currentFormular.lastRow == item.Offset) {
                            FormularData.formularMaps[FormularData.currentIndex][0]["FixOrChangeRegion"] = "R";
                            FormularData.currentFormular["FixOrChangeRegion"] = "R";
                            FormularData.formularMaps[FormularData.currentIndex][0]["RegionTableName"] = BBData.bbCode + "," + item.Code;
                            FormularData.currentFormular["RegionTableName"] = BBData.bbCode + "," + item.Code;
                            flag = true;
                            return;
                        }
                    } else if (item.BdType == "2") {
                        if (FormularData.currentFormular.firstCol == FormularData.currentFormular.lastCol && FormularData.currentFormular.lastCol == item.Offset) {
                            FormularData.formularMaps[FormularData.currentIndex][0]["FixOrChangeRegion"] = "C";
                            FormularData.currentFormular["FixOrChangeRegion"] = "C";
                            FormularData.formularMaps[FormularData.currentIndex][0]["RegionTableName"] = BBData.bbCode + "," + item.Code;
                            FormularData.currentFormular["RegionTableName"] = BBData.bbCode + "," + item.Code;
                            flag = true;
                            return;
                        }
                    }
                });
                if (flag) return;
                FormularData.formularMaps[FormularData.currentIndex][0]["FixOrChangeRegion"] = "F";
                FormularData.currentFormular["FixOrChangeRegion"] = "F";
                FormularData.formularMaps[FormularData.currentIndex][0]["RegionTableName"] = BBData.bbCode;
                FormularData.currentFormular["RegionTableName"] = BBData.bbCode;
            }

        };


        var resultManagers = {

            success: function (data) {
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
                    //Grid1.LoadFromXMLString(Base64.fromBase64(data.obj.formatStr));

                    Grid1.fromJSON(JSON.parse(data.obj.formatStr));
                    if (Grid1.bind) {
                        Grid1.bind(spreadNS.Events.SelectionChanging, GridManager.RowColChange_Event);


                    }

                    BBData = JSON2.parse(data.obj.itemStr);
                    FormularData.reportCode = BBData.bbCode;
                    Grid1.isPaintSuspended(true);
                    var rowCount = Grid1.getRowCount(),
                     columnCount = Grid1.getColumnCount();
                    for (var i = 0; i < rowCount; i++) {
                        for (var j = 0; j < columnCount; j++) {
                            Grid1.getCell(i, j).locked(false);
                            var cell = toolManager.GetCellData(i, j);
                            if (cell && cell.CellLogicalType && cell.CellLogicalType == "02") {
                                //Grid1.Cell(i, j).Text = "";
                                Grid1.setValue(i, j, "");

                            } else {
                                Grid1.getCell(i, j).locked(true);
                                // Grid1.Cell(i, j).Locked = true;
                            }

                        }
                    }
                    /*  for (var i = 0; i < Grid1.Rows; i++) {
                    for (var j = 0; j < Grid1.Cols; j++) {
                    var cell = toolManager.GetCellData(i, j);
                    if (cell && cell.CellLogicalType && cell.CellLogicalType == "02") {
                    Grid1.Cell(i, j).Text = "";
                    } else {
                    Grid1.Cell(i, j).Locked = true;
                    }
                    }
                    }*/

                    var formularArr = data.obj.formularStr.split("|");
                    if (formularArr.length == 2) {
                        FormularData = JSON2.parse(formularArr[0]);
                        rowColFormular = JSON2.parse(formularArr[1]);
                        $.each(rowColFormular, function (row) {
                            $.each(rowColFormular[row], function (col) {
                                if (Grid1.getCell(row, col)) {
                                    Grid1.setValue(row, col, "公式");
                                   
                                } else {
                                    var position = rowColFormular[row][col];
                                    var data = toolManager.DeserializePositoin(position);
                                    delete FormularData.formularMaps[FormularData.currentIndex];
                                    FormularData.curentSequence = undefined;
                                    FormularData.currentIndex = undefined;
                                    delete rowColFormular[row][col];
                                }
                            });
                        }
                    );
                    }
                    Grid1.isPaintSuspended(false);
                    formularManager.BalanceIfManager.LoadFormularGrid();

                } else {
                    alert(data.sMeg);
                }
            }
        };
        var formularManager = {
            createFormular: function () {
                if (!$("#cacuCheck").attr("checked")) {
                    if (FormularData.currentIndex != undefined) {
                        toolManager.Formular.AddEditFormular("edit");
                    } else {
                        toolManager.Formular.AddEditFormular("add");
                    }
                } else {
                    if ($("#fxContent").val() != "") {
                        formularManager.DeserializeBlockFormular($("#fxContent").val());
                    }
                    if (FormularData.currentIndex != undefined) {
                        cellManager.GeneralCellCopy(toolManager.Formular.AddEditCaculateFormular, "edit");
                    } else {
                        cellManager.GeneralCellCopy(toolManager.Formular.AddEditCaculateFormular, "add");
                    }
                }



            },
            RemoveFormular: function () {

                toolManager.Formular.RemoveFormular();
            },
            SaveFormular: function () {
                var para = { ReportCode: "", FormularData: "", RowColInfo: "" };
                para.ReportCode = BBData.bbCode;
                para.FormularData = JSON.stringify(FormularData);
                para.RowColInfo = JSON.stringify(rowColFormular);
                para = CreateParameter(ReportFormatAction.ActionType.Post, ReportFormatAction.Functions.FormularMenu, ReportFormatAction.Methods.FormularMenuMethods.Save, para);

                DataManager.sendData(urls.functionsUrl, para, resultManagers.success, resultManagers.fail, false);
            },
            NewFormular: function () {
                if ($("#cellIndentity").val() == "") {
                    alert("请选择定义公式的范围！");
                    return;
                }
                var result = window.showModalDialog(urls.newFormularUrl, null, "dialogHeight:600px;dialogWidth:800px;scroll:no;location=no;menubar=no");
                if (result) {
                    $("#fxContent").val(result.content);
                    toolManager.Formular.AddEditFormular("add");
                    FormularData.formularMaps[FormularData.currentIndex][0]["FormularDb"] = result.DataSource;
                    FormularData.currentFormular["FormularDb"] = result.DataSource;
                    FormularData.currentFormular["FormularLevel"] = result.FormularLevel;
                    toolManager.SetBdq();
                }
            },
            EditFormular: function () {
                if (FormularData.currentFormular == undefined) return;
                var paras = { content: "", formularData: "", FormularLevel: 0 };
                paras.content = $("#fxContent").val();
                paras.DataSource = FormularData.currentFormular.FormularDb;
                paras.FormularLevel = FormularData.currentFormular["FormularLevel"];
                var result = window.showModalDialog(urls.newFormularUrl, paras, "dialogHeight:600px;dialogWidth:800px;scroll:no");
                if (result) {
                    $("#fxContent").val(result.content);
                    toolManager.Formular.AddEditFormular("edit");
                    FormularData.formularMaps[FormularData.currentIndex][0]["FormularDb"] = result.DataSource;
                    FormularData.currentFormular["FormularDb"] = result.DataSource;
                    FormularData.currentFormular["FormularLevel"] = result.FormularLevel;
                    toolManager.SetBdq();
                }

            },
            CheckBoxManager: {
                TakeCheckSelected: function () {

                    if ($("#takeCheck").attr("checked")) {
                        if (FormularData.currentIndex != undefined && FormularData.currentIndex != "") {
                            FormularData.formularMaps[FormularData.currentIndex][0].isOrNotTake = "1";
                            FormularData.formularMaps[FormularData.currentIndex][0].isOrNotBatch = "0";
                            FormularData.formularMaps[FormularData.currentIndex][0].isOrNotCaculate = "0";
                        }
                        $("#balaCheck").attr("checked", "");
                        $("#cacuCheck").attr("checked", "");
                    } else {
                        if (FormularData.currentIndex != undefined && FormularData.currentIndex != "") {
                            FormularData.formularMaps[FormularData.currentIndex][0].isOrNotTake = "0";
                        }
                    }
                    if (FormularData.currentIndex != undefined && FormularData.currentIndex != "") {
                        FormularData.currentFormular = FormularData.formularMaps[FormularData.currentIndex][0];
                    }

                },
                BalanceCheckSelected: function () {

                    if ($("#balaCheck").attr("checked")) {
                        if (FormularData.currentIndex != undefined && FormularData.currentIndex != "") {
                            FormularData.formularMaps[FormularData.currentIndex][0].isOrNotBatch = "1";
                            FormularData.formularMaps[FormularData.currentIndex][0].isOrNotTake = "0";
                            FormularData.formularMaps[FormularData.currentIndex][0].isOrNotCaculate = "0";
                        }
                        $("#takeCheck").attr("checked", "");
                        $("#cacuCheck").attr("checked", "");
                    } else {
                        if (FormularData.currentIndex != undefined && FormularData.currentIndex != "")
                            FormularData.formularMaps[FormularData.currentIndex][0].isOrNotBatch = "0";
                    }
                    if (FormularData.currentIndex != undefined && FormularData.currentIndex != "")
                        FormularData.currentFormular = FormularData.formularMaps[FormularData.currentIndex][0];

                },
                CacuCheckSelected: function () {

                    if ($("#cacuCheck").attr("checked")) {
                        if (FormularData.currentIndex != undefined && FormularData.currentIndex != "") {
                            FormularData.formularMaps[FormularData.currentIndex][0].isOrNotCaculate = "1";
                            FormularData.formularMaps[FormularData.currentIndex][0].isOrNotTake = "0";
                            FormularData.formularMaps[FormularData.currentIndex][0].isOrNotBatch = "0";
                        }
                        $("#takeCheck").attr("checked", "");
                        $("#balaCheck").attr("checked", "");
                    } else {
                        if (FormularData.currentIndex != undefined && FormularData.currentIndex != "")
                            FormularData.formularMaps[FormularData.currentIndex][0].isOrNotCaculate = "0";
                    }
                    if (FormularData.currentIndex != undefined && FormularData.currentIndex != "")
                        FormularData.currentFormular = FormularData.formularMaps[FormularData.currentIndex][0];
                }


            },
            DeserializeBlockFormular: function (content) {
                try {
                    var objects = [];
                    if (content.indexOf("SUM(") == -1 && content.indexOf("AVG(") == -1 && content.indexOf("SUMIF(") == -1 && content.indexOf("COUNTIF(") == -1 && content.indexOf("COUNT(") == -1) {
                        if (content.indexOf(":") != -1) {
                            var temp = "";
                            var flag = false;
                            for (var i = 0; i < content.length; i++) {
                                var char = content.charAt(i);
                                if (char == ']') {
                                    flag = false;
                                    objects.push(temp);
                                    temp = "";
                                }
                                if (flag) temp += char;
                                if (char == '[') {
                                    flag = true;
                                }
                            }
                        }
                    }
                    if (objects.length > 0) {
                        var selection = Grid1.Selection;
                        for (var i = selection.FirstRow; i <= selection.LastRow; i++) {
                            for (var j = selection.FirstCol; j <= selection.LastCol; j++) {
                                var formular = content;
                                $.each(objects, function (index, item) {
                                    var temp = "";
                                    var rowCols = item.split(":");
                                    var firstRow = parseInt(rowCols[0].split(",")[0]);
                                    var firstCol = parseInt(rowCols[0].split(",")[1]);
                                    temp = (firstRow + i - selection.FirstRow) + "," + (firstCol + j - selection.FirstCol);
                                    var reg = new RegExp(item, "g");
                                    formular = formular.replace(reg, temp);

                                });
                                Grid1.setValue(i, j, formular);
                              
                                //Grid1.Cell(i, j).Text = formular;
                            }
                        }
                        $("#fxContent").val("");
                    } else {
                        return content;
                    }
                } catch (err) {
                    alert(err.Message);
                }
            },
            BalanceIfManager: {
                AddContent: function (row, col, endRow, endCol) {
                    var state = document.getElementById("formularEditWindow").style.display;
                    if (state == "none") { return; }
                    var Content = $("#" + rightControls.InputBox).text();
                    if (row != endRow || col != endCol) {
                        alert("请每次只选取一个单元格")
                    }
                    var cell = row + "," + col;
                    newCell = "[" + cell + "]";
                    var last = Content.substr(Content.length - 1, 1);
                    if (last == "]") {
                        Content = Content.substr(0, Content.length - rightControls.cellLength);
                    }
                    Content = Content + newCell;
                    rightControls.cellLength = newCell.length;
                    $("#" + rightControls.InputBox).text(Content);
                },
                EditFormular: function () {
                    var formular = rightControls.FormulaGrid.getSelectedRow();
                    if (!formular || formular == undefined) {
                        alert("请选定要编辑的对象");
                        return;
                    }
                    $("#formularGridToobar").css("display", "none");
                    $("#formularEditWindow").css("display", "block");
                    $("#formulaGrid").ligerGrid({ width: '99%' });
                    $("#formularContent").text(formular.content);
                    $("#ErrorInfo").text("");
                    if (formular.ErrorInfo) {
                        $("#ErrorInfo").text(formular.ErrorInfo);
                    }
                    if (formular.Condition) {
                        $("#formularCondition").text(formular.Condition);
                    }
                    rightControls.FormularData = formular;
                },
                DeletFormular: function () {
                    var formular = rightControls.FormulaGrid.getSelectedRow();
                    if (!formular || formular == undefined) {
                        alert("请选定要删除的对象");
                        return;
                    }
                    BalanceManager.DeleteBalanceManager(formular.Id);
                    formularManager.BalanceIfManager.LoadFormularGrid();
                },
                LoadFormularGrid: function () {
                    var data = BalanceManager.CreateBalanceData();
                    rightControls.FormulaGrid.loadData(data);
                },
                SaveBalanceFormular: function () {
                    var TempFormular = { Id: "", formularContent: "", Type: "add", errorInfo: "" };
                    if (rightControls.FormularData.Id) {
                        TempFormular.Id = rightControls.FormularData.Id;
                        TempFormular.Type = "edit";
                    } else {
                        TempFormular.Id = guid();
                    }
                    TempFormular.formularContent = $("#formularContent").text();
                    TempFormular.errorInfo = $("#ErrorInfo").text();
                    TempFormular.Condition = $("#formularCondition").text();
                    if (!TempFormular.formularContent || TempFormular.formularContent == "") { alert("请输入公式内容,若想取消编辑可点击：[返回] 图标"); return; }
                    //if (!TempFormular.Condition || TempFormular.Condition == "") { alert("请输入公式条件"); return; }
                    BalanceManager.AddBalanceManager(TempFormular.Id, TempFormular.formularContent, TempFormular.Type, TempFormular.errorInfo);
                    $("#formularGridToobar").css("display", "block");
                    $("#formularEditWindow").css("display", "none");
                    $("#formulaGrid").ligerGrid({ width: '99%' });
                    formularManager.BalanceIfManager.LoadFormularGrid();
                    rightControls.FormularData = {};
                    rightControls.cellLength = 0;
                },
                ChangeInputBox: function (id) {
                    rightControls.InputBox = id;
                    rightControls.cellLength = 0;
                }
            }
        };
        function ContentHelpClick() {
            var content = $("#fxContent").val();
                content = EditManager.getNoEncryptCells(content);
            var result = window.showModalDialog(urls.InfoContent, content, "dialogHeight:300px;dialogWidth:400px;scroll:no");
            if (result) {
                result = EditManager.getEncryptCells(result);
                $("#fxContent").val(result);
                toolManager.Formular.AddEditFormular("edit");
             }
        }
        var EditManager = {
            getFormularType: function (content) {
                var cutTo = content.indexOf("(");
                var Type = content.substr(0, cutTo);
                return Type;
            },
            //反解 公式内容
            getNoEncryptCells: function (Content) {
                //依靠 公式内容的生成顺序 计算 单元格内容 ,生成顺序有 改变时需要调整方法
                var fType = EditManager.getFormularType(Content);
                if (fType == "BBHLQS" || fType == "BBQKQS") {
                    if (Content.split("cells").length > 0) {
                        var rightStr = Content.split("cells")[1];
                        var cellsStr = rightStr.split("nd")[0];
                        var cells = cellsStr.substring(1, cellsStr.length - 1);
                        Content = Content.replace(cells, Base64.decode(cells));
                        return Content;
                    }
                } else {
                    return Content;
                }
            },
            //加密 公式内容
            getEncryptCells: function (Content) {
                //依靠 公式内容的生成顺序 计算 单元格内容 ,生成顺序有 改变时需要调整方法 
                var fType = EditManager.getFormularType(Content);
                if (fType == "BBHLQS" || fType == "BBQKQS") {
                    if (Content.split("cells").length > 0) {
                        var rightStr = Content.split("cells")[1];
                        var cellsStr = rightStr.split("nd")[0];
                        var cells = cellsStr.substring(1, cellsStr.length - 1);
                        Content = Content.replace(cells, Base64.encode(cells));
                        return Content;
                    }
                } else {
                    return Content;
                }
            }
        }
        window.onresize = (function () {
            if (document.documentElement.clientWidth > 800) {
                document.body.style.width = document.documentElement.clientWidth + "px";
            } else {
                document.body.style.width = "800px";
            }
        });
        function ss(id) {alert(id);}
    </script>
</head>
<body style=" overflow:hidden">
<div id="FileToolBar"   ></div>
<div id="FormularDisplay" class="l-layout-header">
<table cellpadding="3" cellspacing="3"   >
<tr>
<td>  <input id="cellIndentity" type="text" value=""  style="width:100px;"/></td>
<td>  <select id="optionSelect" style="width:40px">
      <option value="=">=</option>
       <option value=">">></option>
        <option value="<">&lt;</option>
         <option value="==">==</option>
          <option value=">=">>=</option>
            <option value="<=">&lt;=</option>
  </select></td>

  <td>
      <img alt="" src="../../images/Format/fx.png" style=" width:22px"/>
  </td>
    <td>
   <%--  <img alt=""  src="../../images/Format/ok.png" style=" width:16px"   />--%>
      <input type="button" id="fokBtn" style=" background-image:url(../../images/Format/ok.png); width:16px;height:18px"  />
  </td>
    <td>
   <%--   <img alt="" src="../../images/Format/no.png" style=" width:16px"/>--%>
       <input type="button" id="fnoBtn" style=" background-image:url(../../images/Format/no.png); width:16px; height:18px " />
  </td>
  <td>
  <input id="fxContent" type="text"  style=" width:300px; margin:0;" /> <input type="button" id="InfoHelp" value="..." title="公式查看" style=" background: linear-gradient(to bottom,#EFF5FF 0,#E0ECFF 100%); margin:0;" onclick="ContentHelpClick()"/>
  </td>

  <td><input id="takeCheck" type="checkbox"  checked="checked" />取数公式</td>
    <td><input id="cacuCheck" type="checkbox"   />计算公式</td>
      <td><input id="balaCheck" type="checkbox"  />平衡公式</td>
</tr>
</table>



</div>
    
	<div id="layout1">
	<div id="ss" position="center">
		</div>
		<div position="right"title="平衡公式：" id="layout-right"  >
            <div id="main" style="margin: 0px; height: 100%; width:100%">
                <div id="formularGridToobar"></div>
                <div id ="formularEditWindow"  style=" display:none;">
                    <div id="formularEditToobar"></div>
                    <table style=" width:350px;margin:5px 5px  5px 8px">
                        <tr style=" width:100%;">
                            <td style="font-size:13px;" >公式内容：</td>
                            <td style="text-align:right">算数运算</td><td style=" padding-left:5px"><input id="CountSgin"/></td>
                            <td style ="text-align:right">比较运算</td><td style=" padding-left:5px"><input id="ContrastSgin"/></td>
                        </tr>                            
                    </table>
                    <div style=" width:100%; height:210px; padding-left:8px ">
                            <textarea id="formularContent" cols="56" rows="5" style="border:1px solid  #99aaff;overflow:auto" onfocus="formularManager.BalanceIfManager.ChangeInputBox(this.id)"></textarea>
                             <%--<div style=" padding:5px 0px 5px 0px; font-size:13px;"> 公式条件：</div>
                             <textarea id="formularCondition" cols="56" rows="2" style="border:1px solid  #99aaff;  overflow:auto"onfocus="formularManager.BalanceIfManager.ChangeInputBox(this.id)"></textarea>--%>
                             <div style=" padding:5px 0px 5px 0px; font-size:13px;"> 错误信息：</div>
                             <textarea id="ErrorInfo" cols="56" rows="5" style="border:1px solid  #99aaff;  overflow:auto"onfocus="formularManager.BalanceIfManager.ChangeInputBox(this.id)"></textarea>
                 </div>
                </div>
                <div id ="formulaGrid"></div>
                
            </div>
        </div>
	</div>
</body>
</html>