<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CellHelp.aspx.cs" Inherits="Audit.ct.pub.CellHelp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
        <meta http-equiv="X-UA-Compatible" content="IE=10" />
     <meta http-equiv="X-UA-Compatible" content="IE=9" />
     <meta http-equiv="X-UA-Compatible" content="IE=8" />
     <meta http-equiv="X-UA-Compatible" content="IE=7" />
    <title>报表格式定义</title>
     <link href="../../lib/ligerUI/skins/Aqua/css/ligerui-all.css" rel="stylesheet" type="text/css" />
         <link href="../../Styles/default.css" rel="stylesheet" type="text/css" />
             <link href="../../Styles/FormatManager.css" rel="stylesheet" type="text/css" />
    <link href="../../lib/ligerUI/skins/ligerui-icons.css" rel="stylesheet" type="text/css" />
    <link href="../../lib/ligerUI/skins/ligerui-icons.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/jquery/jquery-1.5.2.min.js" type="text/javascript"></script>
    <script src="../../lib/ligerUI/js/core/base.js" type="text/javascript"></script>
    <script src="../../lib/ligerUI/js/ligerui.min.js" type="text/javascript"></script>
    <script src="../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <script src="../../lib/json2.js" type="text/javascript"></script>
    <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script src="../../lib/Base64.js" type="text/javascript"></script>
    <script type="text/javascript">

        var urls = {
            functionsUrl: "../../handler/FormatHandler.ashx",
            newFormularUrl: "NewFormular.aspx"
        };
        var bdq = { Code: "", BdType: "", Offset: -1, SortRow: 2, DataCode: 2, DataName: 3, isOrNotMerge: false };
        var BBData = { bbCode: "", bbName: "", bbData: {}, bdq: { bdNum: 0, BdRowNum: 0, BdColNum: 0, BdqMaps: {}, Bdqs: []} };
        var FormularData = { formularMaps: {}, currentFormular: {}, currentIndex: "", curentSequence: "", reportId: "" };      //公式信息以数据和maps两大对形象
        var rowColFormular = {}; //单元格与公式相互结合结构
        var formular = { firstRow: "", firstCol: "", lastRow: "", lastCol: "", content: "", isOrNotTake: "", isOrNotBatch: "", isOrNotCaculate: "", option: "", sequence: "" };
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
        var parentParam = {};
        function guid() {
            function S4() {
                return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1);
            } return (S4() + S4() + "-" + S4() + "-" + S4() + "-" + S4() + "-" + S4() + S4() + S4());
        }
        function loadReport(para) {
            para = CreateParameter(ReportFormatAction.ActionType.Post, ReportFormatAction.Functions.ReportFormatMenu, ReportFormatAction.Methods.ReportFormatMenuMethods.LoadReportFormat, para);
            DataManager.sendData(urls.functionsUrl, para, resultManagers.LoadSuccess, resultManagers.fail, false);
        }
        $(function () {
            //var para = { Id: "" };
            //FormularData.reportId = "ZCFZ";
            //   para.Id = "ZCFZ"
            // loadReport(para)
            $("#FileToolBar").ligerToolBar({ items: [
                { text: '确定', click: itemclick, icon: 'add' },
                { line: true }

            ]
            });

            function itemclick(item) {
                if (item.text == "确定") {
                    var cells = [];
                    var selection = Grid1.Selection;
                    if (parentParam.type == "total") {
                        for (var i = selection.FirstRow; i <= selection.LastRow; i++) {
                            for (var j = selection.FirstCol; j <= selection.LastCol; j++) {
                                var cell = toolManager.getCell(i, j);
                                if (cell) {
                                    cells.push(cell);
                                } 
                            }
                        }
                    } else if (parentParam.type == "BBQS") {
                        for (var i = selection.FirstRow; i <= selection.LastRow; i++) {
                            for (var j = selection.FirstCol; j <= selection.LastCol; j++) {
                                var cell = toolManager.CreateCode(i, j);
                                cells.push(cell);
                            }
                        }
                    } else if (parentParam.type == "BBHLQS") {
                        var area;
                        //单个单元格
                        if (selection.FirstRow == selection.LastRow && selection.FirstCol == selection.LastCol) {
                            area = "[" + selection.FirstRow + "," + selection.FirstCol + "]";
                        } else {
                            //多个单元格
                            var begin = "[" + selection.FirstRow + "," + selection.FirstCol;
                            var end = selection.LastRow + "," + selection.LastCol + "]";
                            area = begin + ":" + end;
                        }
                        cells.push(area);
                    }
                    if (parent.EventManager && parent.EventManager && parent.EventManager.HelpResultManager) {
                        parent.EventManager.HelpResultManager.CellHelpBtnClick(cells);
                    }
                    //window.returnValue = cells;
                    //window.close();
                }
            }

            $("#layout1").ligerLayout({ allowRightCollapse: false });
        });



        function InitializeFlexCell(row, col) {

            if (Grid1) {
                Grid1.NewFile();
                Grid1.AutoRedraw = false;
                //  Grid1.LoadFromXmlString('<FlexCell xml:space="preserve"><DocumentProperties><LastSaved>2014-07-04 12:00:44</LastSaved><Version>6.2.7</Version></DocumentProperties><GridProperties><BackColorBkg>&amp;H8000000C</BackColorBkg><CellBorderColorFixed>&amp;H8000000C</CellBorderColorFixed><FixedRowColStyle>Flat</FixedRowColStyle><DisplayRowIndex>True</DisplayRowIndex><ReadOnlyFocusRect>Dot</ReadOnlyFocusRect><ScreenTwipsPerPixelX>15</ScreenTwipsPerPixelX><ScreenTwipsPerPixelY>15</ScreenTwipsPerPixelY><DefaultRowHeight>18</DefaultRowHeight><Rows>10</Rows><Cols>2</Cols><FixedRows>1</FixedRows><FixedCols>1</FixedCols><ActiveCell Row1="4" Col1="1" Row2="4" Col2="1"/><Selection Row1="4" Col1="1" Row2="4" Col2="1"/></GridProperties><PageSetup><HeaderAlignment>Left</HeaderAlignment><FooterAlignment>Center</FooterAlignment><HeaderFont FontName="宋体" Size="9"/><FooterFont FontName="宋体" Size="9"/><PaperSize>0</PaperSize><Orientation>Portrait</Orientation><PaperWidth>21</PaperWidth><PaperHeight>29.7</PaperHeight><LeftMargin>2.5</LeftMargin><RightMargin>2.5</RightMargin><TopMargin>3</TopMargin><BottomMargin>3</BottomMargin><HeaderMargin>2</HeaderMargin><FooterMargin>2</FooterMargin><Zoom>100</Zoom></PageSetup><Columns><Column Col="0"><Type>TextBox</Type><Width>40</Width><Alignment>GeneralGeneral</Alignment></Column><Column Col="1"><Type>TextBox</Type><Width>80</Width><Alignment>GeneralGeneral</Alignment></Column><Column Col="2"><Type>TextBox</Type><Width>80</Width><Alignment>GeneralGeneral</Alignment></Column></Columns><Fonts><Font ID="f0" FontName="宋体" Size="9"/></Fonts><Styles><Style ID="s0"><Border/><Alignment>GeneralGeneral</Alignment></Style><Style ID="s1"><Border/><Alignment>GeneralGeneral</Alignment><Fill>True</Fill><BackColor>#60d978</BackColor></Style></Styles><Cells><Cell Row="1" Col="1">姓名</Cell><Cell Row="1" Col="2">编号</Cell><Cell Row="2" Col="1" Style="1">[00020001,01]</Cell><Cell Row="2" Col="2" Style="1">[00020002,01]</Cell><Cell Row="3" Col="1" Style="1">[00030001,01]</Cell><Cell Row="3" Col="2" Style="1">[00030002,01]</Cell><Cell Row="4" Col="1" Style="1">[00040001,01]</Cell><Cell Row="4" Col="2" Style="1">[00040002,01]</Cell><Cell Row="5" Col="1" Style="1">[00050001,01]</Cell><Cell Row="5" Col="2" Style="1">[00050002,01]</Cell><Cell Row="6" Col="1" Style="1">[00060001,01]</Cell><Cell Row="6" Col="2" Style="1">[00060002,01]</Cell><Cell Row="7" Col="1" Style="1">[00070001,01]</Cell><Cell Row="7" Col="2" Style="1">[00070002,01]</Cell><Cell Row="8" Col="1" Style="1">[00080001,01]</Cell><Cell Row="8" Col="2" Style="1">[00080002,01]</Cell><Cell Row="9" Col="1" Style="1">[00090001,01]</Cell><Cell Row="9" Col="2" Style="1">[00090002,01]</Cell><Cell Row="10" Col="1" Style="1">[00100001,01]</Cell><Cell Row="10" Col="2" Style="1">[00100002,01]</Cell></Cells></FlexCell>');
                //               Grid1.LoadFromXmlString('<FlexCell xml:space="preserve"><DocumentProperties><LastSaved>2014-07-04 20:08:34</LastSaved><Version>6.2.7</Version></DocumentProperties><GridProperties><BackColorBkg>&amp;H8000000C</BackColorBkg><CellBorderColorFixed>&amp;H8000000C</CellBorderColorFixed><FixedRowColStyle>Flat</FixedRowColStyle><DisplayRowIndex>True</DisplayRowIndex><ReadOnlyFocusRect>Dot</ReadOnlyFocusRect><ScreenTwipsPerPixelX>15</ScreenTwipsPerPixelX><ScreenTwipsPerPixelY>15</ScreenTwipsPerPixelY><DefaultRowHeight>18</DefaultRowHeight><Rows>10</Rows><Cols>2</Cols><FixedRows>1</FixedRows><FixedCols>1</FixedCols><ActiveCell Row1="8" Col1="2" Row2="8" Col2="2"/><Selection Row1="8" Col1="2" Row2="8" Col2="2"/></GridProperties><PageSetup><HeaderAlignment>Left</HeaderAlignment><FooterAlignment>Center</FooterAlignment><HeaderFont FontName="宋体" Size="9"/><FooterFont FontName="宋体" Size="9"/><PaperSize>0</PaperSize><Orientation>Portrait</Orientation><PaperWidth>21</PaperWidth><PaperHeight>29.7</PaperHeight><LeftMargin>2.5</LeftMargin><RightMargin>2.5</RightMargin><TopMargin>3</TopMargin><BottomMargin>3</BottomMargin><HeaderMargin>2</HeaderMargin><FooterMargin>2</FooterMargin><Zoom>100</Zoom></PageSetup><Columns><Column Col="0"><Type>TextBox</Type><Width>40</Width><Alignment>GeneralGeneral</Alignment></Column><Column Col="1"><Type>TextBox</Type><Width>80</Width><Alignment>GeneralGeneral</Alignment></Column><Column Col="2"><Type>TextBox</Type><Width>80</Width><Alignment>GeneralGeneral</Alignment></Column></Columns><Fonts><Font ID="f0" FontName="宋体" Size="9"/></Fonts><Styles><Style ID="s0"><Border/><Alignment>GeneralGeneral</Alignment></Style><Style ID="s1"><Border/><Alignment>GeneralGeneral</Alignment><Fill>True</Fill><BackColor>#60d978</BackColor></Style></Styles><Cells><Cell Row="2" Col="1" Style="1">[00020001,01]</Cell><Cell Row="2" Col="2" Style="1">[00020002,01]</Cell><Cell Row="3" Col="1" Style="1">[00030001,01]</Cell><Cell Row="3" Col="2" Style="1">[00030002,01]</Cell><Cell Row="4" Col="1" Style="1">[00040001,01]</Cell><Cell Row="4" Col="2" Style="1">[00040002,01]</Cell><Cell Row="5" Col="1" Style="1">[00050001,01]</Cell><Cell Row="5" Col="2" Style="1">[00050002,01]</Cell><Cell Row="6" Col="1" Style="1">[00060001,01]</Cell><Cell Row="6" Col="2" Style="1">[00060002,01]</Cell><Cell Row="7" Col="1" Style="1">[00070001,01]</Cell><Cell Row="7" Col="2" Style="1">[00070002,01]</Cell><Cell Row="8" Col="1" Style="1">[00080001,01]</Cell><Cell Row="8" Col="2" Style="1">[00080002,01]</Cell><Cell Row="9" Col="1" Style="1">[00090001,01]</Cell><Cell Row="9" Col="2" Style="1">[00090002,01]</Cell><Cell Row="10" Col="1" Style="1">[00100001,01]</Cell><Cell Row="10" Col="2" Style="1">[00100002,01]</Cell></Cells></FlexCell>');
                //                Grid1.Cols = row;
                //                Grid1.Rows = col;
                //                Grid1.DisplayRowIndex = true;
                //                Grid1.FixedRowColStyle = 0;
                //                Grid1.CellBorderColorFixed = Grid1.BackColorBKG;
                Grid1.AutoRedraw = true;
                Grid1.Refresh();
                if (Grid1.attachEvent) {
                    Grid1.attachEvent("RowColChange", GridManager.RowColChange_Event);
                }
                
                //  InitializeControlValue(true);
                BBData = { bbCode: "", bbName: "", bbData: {}, bdq: { bdNum: 0, BdRowNum: 0, BdColNum: 0, BdqMaps: {}, Bdqs: []} };
            }

        }



        var cellManager = {
            GeneralCell: function (func, value) {

                for (var i = Grid1.Selection.FirstRow; i <= Grid1.Selection.LastRow; i++) {
                    for (var j = Grid1.Selection.FirstCol; j <= Grid1.Selection.LastCol; j++) {
                        func(i, j, value);
                    }
                }

            },
            GeneralLoadCellDataValue: function (row, col) {
               
            }

        };

        var GridManager = {
            RowColChange_Event: function (row, col) {
                cellManager.GeneralLoadCellDataValue(row, col);
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
            CreateCode: function (row, col) {
                return BBData.bbData[row][col].CellCode;
            },
            GetCellData: function (row, col) {
                if (BBData.bbData[row] && BBData.bbData[row][col]) {
                    return BBData.bbData[row][col];
                }
            },
            //获取cell内容，属性可添加
            //张双义
            getCell: function (row, col) {
                if (BBData.bbData[row] && BBData.bbData[row][col]) {
                    var tempCell = { cellCode: BBData.bbData[row][col].CellCode, cellName: BBData.bbData[row][col].CellName };
                    return tempCell;
                } 
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
                    // InitializeFlexCell(1, 1);
                    Grid1.NewFile();
                    Grid1.AutoRedraw = false;
                    Grid1.LoadFromXMLString(Base64.fromBase64(data.obj.formatStr));
                    if (Grid1.attachEvent) {
                        Grid1.attachEvent("RowColChange", GridManager.RowColChange_Event);
                        Grid1.AutoRedraw = true;

                    }
                    Grid1.Refresh();

                    BBData = JSON2.parse(data.obj.itemStr);

                    for (var i = 0; i < Grid1.Rows; i++) {
                        for (var j = 0; j < Grid1.Cols; j++) {
                            Grid1.Cell(i, j).Locked = true;
                        }
                    }
                    //初始化列
                    for (var i = 1; i < Grid1.Cols; i++) {
                        Grid1.Cell(0, i).Text = i;
                    }
                } else {
                    alert(data.sMeg);
                }
            }
        };
       
    </script>
</head>
<body style=" overflow:hidden">
<div id="FileToolBar"   ></div>

    
	<div id="layout1">
		<div position="center" style="z-index:-1">
			   <OBJECT CLASSID = "clsid:5220cb21-c88d-11cf-b347-00aa00a28331" VIEWASTEXT>
         <PARAM NAME="LPKPath" VALUE="../lpk/flexCell.LPK">
      </OBJECT> 
          
            
      <OBJECT TYPE="application/x-itst-activex"  ID="Grid1" Width=100% Height=100%    CLASSID="clsid:4331220A-1077-4630-BEE3-0D7142D6ABD0" >
         <PARAM NAME="_ExtentX" VALUE="0">
         <PARAM NAME="_ExtentY" VALUE="0">       
      </OBJECT>

		</div>

	</div>
</body>
</html>