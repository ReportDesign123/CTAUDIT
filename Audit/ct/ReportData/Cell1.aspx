<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Cell1.aspx.cs" Inherits="Audit.ct.ReportData.Cell1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <script src="../../lib/jquery/jquery-1.5.2.min.js" type="text/javascript"></script>
    <script src="../../Scripts/Ct_Tool.js" type="text/javascript"></script>
    <script src="../../lib/json2.js" type="text/javascript"></script>
    <script src="../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    
       <script src="../../Scripts/ct_dialog.js" type="text/javascript"></script>
</head>
<body  style=" height:100%; width:100%; margin:0; padding:0; overflow:hidden;">
			   <OBJECT CLASSID = "clsid:5220cb21-c88d-11cf-b347-00aa00a28331" VIEWASTEXT>
         <PARAM NAME="LPKPath" VALUE="../lpk/flexCell.LPK">
      </OBJECT> 

      <OBJECT  ID="Grid1"    CLASSID="clsid:4331220A-1077-4630-BEE3-0D7142D6ABD0"  onkeydown="Grid_KeyDown()">
           <PARAM NAME="_ExtentX" VALUE="0">
         <PARAM NAME="_ExtentY" VALUE="0">

      </OBJECT>
     <%-- <script for="Grid1" event="RowColChange(row, col)">
       GridManager.RowColChange_Event(row);
      </script>--%>
        <script type="text/javascript">
            var urls = { HelpUrl: "../../handler/BasicHandler.ashx" };
            var currentState = { Row: "", Col: "", Tag: "", CellsHelp: {},currentNum:0 };
            var grid1;
            function Initialize(width,height) {
              
                Grid1.AutoRedraw = false;
                Grid1.DisplayFocusRect = 0;
                Grid1.DisplayRowIndex = true;       
              
                currentState.Row = "";
                currentState.Col = "";
               // Grid1.EditorVisible = 1;
                Grid1.width = width-30;
                Grid1.height = height - 60;
                Grid1.AutoRedraw = true;
                Grid1.Refresh();
                if (Grid1.attachEvent) {

                    Grid1.attachEvent("RowColChange", GridManager.RowColChange_Event);
                    Grid1.attachEvent("CellChange", GridManager.CellChange_Event);
                    Grid1.attachEvent("ComboDropDown", GridManager.ComboDropDown);
                    Grid1.attachEvent("ButtonClick", GridManager.GridButtonClick);
                } else {
                    Grid1.addEventListener("RowColChange", GridManager.RowColChange_Event, false);
                    Grid1.addEventListener("CellChange", GridManager.CellChange_Event, false);
                    Grid1.addEventListener("ComboDropDown", GridManager.ComboDropDown, false);
                    Grid1.addEventListener("ButtonClick", GridManager.GridButtonClick, false);

                }
               
            }
            function Grid_KeyDown() {
                if (event.ctrlKey && event.keyCode == 67) {
                    Grid1.Selection.CopyData();
                }
            }

//            Initialize(400, 400);
//            Grid1.Cols = 10;
//             Grid1.Rows = 10;
            $(function () {
                //Grid1.width = document.documentElement.clientWidth-30;                
                // Grid1.height = document.documentElement.offsetHeight;      
                currentState.currentNum = 0;   
            });

            function RefreshGrid(formatStr,width,height) {
                if (!grid1) {
                    Initialize(width,height);
                    grid1 = Grid1;
                }
                        
              // Grid1.NewFile();
                Grid1.AutoRedraw = false;
                
               Grid1.LoadFromXMLString(formatStr);
              
              Grid1.DisplayFocusRect = 0;
               Grid1.DisplayRowIndex = true;
               Grid1.FixedRowColStyle = 0;
               Grid1.AllowUserPaste = 2;    
               Grid1.AutoRedraw = true;          
               Grid1.Refresh();
              
           }
           var GridManager = {

               SetRowColText: function (CellItem) {

                   GridManager.SetRowColTextByRowCol(CellItem.row, CellItem.col, CellItem);
               },
               SetRowColTextByRowCol: function (row, col, CellItem) {

                   if (CellItem.value != undefined)
                       Grid1.Cell(row, col).Text = CellItem.value;
                   else {
                       Grid1.Cell(row, col).Text = "";
                   }

               },
               SetRowColTextByCellType: function (row, col, CellType) {
                   if (CellType["CellDataType"] == "01") return;
                   var text = Grid1.Cell(row, col).Text;
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
                   if (text != newText) Grid1.Cell(row, col).Text = newText;
               },
               GetRowColTextByCellType: function (text, cellType) {
                   if (cellType["CellSmbol"] == "01" || cellType["CellSmbol"] == "02") {
                       text = GridManager.GetSmboText(text);
                   }
                   if (cellType["CellThousand"] == "1") {
                       text = Ct_Tool.RemoveDecimalPoint(text);
                   }
                   return text;
               },
               RowColChange_Event: function (Row, Col) {

                   var tag = Grid1.Cell(Row, Col).Tag;
                   if (currentState.Row == Row && currentState.Col == Col && currentState.Tag == tag) { return; }
                   parent.mediatorManager.SetRowColInput(Row, Col, tag);
                   currentState.Row = Row;
                   currentState.Col = Col;
                   //alert(Grid1.Cell(Row, Col).Tag);

               },
               CellChange_Event: function (Row, Col) {
                   //                                      if (parent.currentState.RowColChange)
                   //                                          alert(Grid1.Cell(Row, Col).Tag);
                   var tag = Grid1.Cell(Row, Col).Tag;
                   // if (currentState.Row == Row && currentState.Col == Col && currentState.Tag == tag) { return; }
                   parent.mediatorManager.TextChange(Row, Col, tag);
               },
               GetCurrentRow: function () {
                   var selection = Grid1.Selection;
                   return selection.FirstRow;

               },
               GetCurrentCol: function () {
                   var selection = Grid1.Selection;
                   return selection.FirstCol;
               },
               GetCurrentTag: function () {
                   var selection = Grid1.Selection;
                   var col = selection.FirstCol;
                   var row = selection.FirstRow;
                   return Grid1.Cell(row, col).Tag;
               },
               GetSmboText: function (text) {
                   var sym = text.substr(0, 1);
                   if (sym == "$" || sym == "￥") {
                       return text.substr(1);
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
