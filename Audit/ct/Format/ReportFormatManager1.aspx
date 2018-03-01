<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReportFormatManager1.aspx.cs" Inherits="Audit.ct.Format.ReportFormatManager1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>报表格式定义</title>
     <meta http-equiv="X-UA-Compatible" content="IE=10" />
     <meta http-equiv="X-UA-Compatible" content="IE=9" />
     <meta http-equiv="X-UA-Compatible" content="IE=8" />
     <meta http-equiv="X-UA-Compatible" content="IE=7" />
   <script src="../../lib/jquery/jquery-1.3.2.min.js" type="text/javascript"></script>
       <script src="../../lib/json2.js" type="text/javascript"></script>
     <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script src="../../lib/ligerUI/js/core/base.js" type="text/javascript"></script>
    <script src="../../lib/ligerUI/js/core/inject.js" type="text/javascript"></script> 
    <script src="../../lib/ligerUI/js/ligerui.min.js" type="text/javascript"></script>
     <link href="../../lib/ligerUI/skins/Aqua/css/ligerui-all.css" rel="stylesheet" type="text/css" />
    <link href="../../lib/ligerUI/skins/ligerui-icons.css" rel="stylesheet" type="text/css" />
     <link href="../../Styles/Ct_Controls.css" rel="stylesheet" type="text/css" />
   <script src="../../Scripts/Ct_Controls.js" type="text/javascript"></script>
    <script src="../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
  
    <link href="../../Styles/FormatManager.css" rel="stylesheet" type="text/css" />
    <link href="../../Styles/default.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/Base64.js" type="text/javascript"></script>
    
       <script src="../../Scripts/ct_dialog.js" type="text/javascript"></script>
        <link href="../../lib/easyUI/themes/default/linkbutton.css" rel="stylesheet" type="text/css" />
    <link href="../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <link href="../../Styles/Common.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        var urls = {
            functionsUrl: "../../handler/FormatHandler.ashx"      
        };
        var bdq = { Code: "", BdType: "", Offset: -1, SortRow: 2, DataCode: 2, DataName: 3, isOrNotMerge: false };
        var BBData = { Id: "", bbCode: "", bbName: "", bbClassifyId: "", bbData: {}, bdq: { bdNum: 0, BdRowNum: 0, BdColNum: 0, BdqMaps: {}, Bdqs: [] }, bbRows: "", bbCols: "", zq: "", MergeCells: [], MaxBdNm:0 };
        var ImportReportControl = { ClassifyId: "", Id: "" };
        var cellData = {FontName:"",FontSize:""};
        var cellNameValue = { FontName: "FontName", FontSize: "FontSize", FontBold: "FontBold", FontItalic: "FontItalic", FontUnderline: "FontUnderline ",
            Alignment: "Alignment ", ForeColor: "ForeColor", BackColor: "BackColor", Border: "Border", CellCode: "CellCode", CellName: "CellName",
            CellRow: "CellRow", CellCol: "CellCol", CellLogicalType: "CellLogicalType", CellType: "CellType", CellDataType: "CellDataType", CellMacro: "CellMacro", CellHelp: "CellHelp", CellLength: "CellLength",
            CellThousand: "CellThousand", CellCurrence: "CellCurrence", CellSmbol: "CellSmbol", CellLock: "CellLock", CellZero: "CellZero", CellAggregation: "CellAggregation", CellAggregationType: "CellAggregationType",
            CellPrimary: "CellPrimary", isOrUpdate: "isOrUpdate", DigitNumber: "DigitNumber",WrapText:"False"
        };
        var cellTag = { cellData: "cellData", bdqData: "bdqData" };
        var cellControls = { FontName: {}, FontSize: {}, CellLogicalType: {}, CellType: {}, CellDataType: {}, CellMacro: {}, CellHelp: {}, CellThousand: {},
            CellCurrence: {}, CellSmbol: {}, CellLock: {}, CellZero: {}, DigitNumber: {}, CellAggregation: {}, CellAggregationType: {}, CellPrimary: {},
            CellCodeRefresh: {}, CellHeight: {}, CellWidth: {}
        };   //CellCodeRefresh 重设内码开关
     //oldRow,oldCol点击单元格时的临时行列状态；bdMum记录变动区数据的数量
     var currentState = {oldRow:0,oldCol:0,bdNum:0,bdRowNum:0,bdColNum:0,MaxBdNm:0};
     var cellFlag = {cellSetFlag:true,compatible:true};
     var fontNameData = [
                 { text: '楷体', id: '楷体' },
                  { text: '隶书', id: '隶书' },
                    { text: '宋体', id: '宋体' },
                    { text: '微软雅黑', id: '微软雅黑' },
                    { text: '新宋体', id: '新宋体' },
                    { text: '幼圆', id: '幼圆'}];
                var fontSizeData= [
                    { text: '6', id: '6' },
                    { text: '8', id: '8' },
                    { text: '9', id: '9' },
                    { text: '10', id: '10' },
                    { text: '12', id: '12' },
                    { text: '14', id: '14' },
                   { text: '16', id: '16' },
                    { text: '18', id: '18' },
                    { text: '20', id: '20' },
                   { text: '22', id: '22' },
                   { text: '24', id: '24' },
                    { text: '26', id: '26' },
                    { text: '28', id: '28' },
                    { text: '30', id: '30' },
                   { text: '32', id: '32' },
                    { text: '36', id: '36' },
                    { text: '48', id: '48' },
                   { text: '72', id: '72' }

                ];

                   var smbolData = [
                   { text: "￥", id: "01" },
                   {text:"$",id:"02"}
                   ];
                   var currenceData = [
                   { text: "元", id: "01" },
                   {text:"美元",id:"02"}
                   ];


                   var cellLogicalData = [
                   { text: "项目项", id: "01" },
                   { text: "数据项", id: "02" }
                   ];
                   var cellDataTypeData = [
                    { text: "字符", id: "01" },
                   { text: "数值", id: "02" }
                   ];
                   var cellTypeData = [
                     { text: "文本框", id: "01" },
                   { text: "下拉框", id: "02" },
                    { text: "帮助按钮", id: "03" }
                   ];

                   function _stopIt(e) {
                       if (e.returnValue) {
                           e.returnValue = false;
                       }
                       if (e.preventDefault) {
                           e.preventDefault();
                       }

                       return false;
                   }

                   $(function () {
                       document.getElementsByTagName("body")[0].onkeydown = function () {

                           //获取事件对象
                           var elem = event.relatedTarget || event.srcElement || event.target || event.currentTarget;

                           if (event.keyCode == 8) {//判断按键为backSpace键

                               //获取按键按下时光标做指向的element
                               var elem = event.srcElement || event.currentTarget;

                               //判断是否需要阻止按下键盘的事件默认传递
                               var name = elem.nodeName;

                               if (name != 'INPUT' && name != 'TEXTAREA') {
                                   return _stopIt(event);
                               }
                               var type_e = elem.type.toUpperCase();
                               if (name == 'INPUT' && (type_e != 'TEXT' && type_e != 'TEXTAREA' && type_e != 'PASSWORD' && type_e != 'FILE')) {
                                   return _stopIt(event);
                               }
                               if (name == 'INPUT' && (elem.readOnly == true || elem.disabled == true)) {
                                   return _stopIt(event);
                               }
                           }

                       }
                       $("#alterationRowGrid").ligerGrid({
                           width: '100%',
                           height: '99%',
                           isScroll: false,
                           columns: [
                 { display: '变动行信息', name: 'content', align: 'left', width: 220 }
                 ]
                       });

                       $("#FileToolBar").ligerToolBar({ items: [
                { text: '新建报表', click: itemclick, icon: 'add' },
                { text: '导入报表', click: itemclick, icon: 'archives' },
                { text: '保存报表', click: itemclick, icon: 'save' },
                { line: true },
                { text: '打印预览', click: itemclick, icon: 'attibutes' },
                { text: '打印', click: itemclick, icon: 'print' }
            ]
                       });

                       $("#MiddleToolBar").ligerToolBar({ items: [
              { text: '合并单元格', click: itemclick, icon: 'logout' }, //  , icon: 'communication' 
                 {text: '取消合并', click: itemclick, icon: 'prev' },
                { line: true },
                    { text: '插入行', click: itemclick, icon: 'plus' },
                    { text: '删除行', click: itemclick, icon: 'busy' },
                    { text: '设置变动行', click: itemclick, icon: 'communication' },
                    { text: '取消变动行', click: itemclick, icon: 'delete' },
                    { line: true },
                    { text: '插入列', click: itemclick, icon: 'plus' },
                    { text: '删除列', click: itemclick, icon: 'busy' },
                    { text: '设置变动列', click: itemclick, icon: 'communication' },
                    { text: '取消变动列', click: itemclick, icon: 'delete' }
            ]
                       });
                       $("#FileToolBar").append("<div style='margin-top:2px'><span><input id='CellCodeRefresh' onchange='menuManager.CellCodeRefresh(this.checked)' /></span><span style='color:steelblue'>重置内码</span> </div>");
                       cellControls.CellCodeRefresh = $("#CellCodeRefresh").ligerCheckBox({});
                       $("#layout1").ligerLayout({ allowRightCollapse: true, rightWidth: 270 });
                       $("#navtab1").ligerTab();
                       $("#fontStyle").ligerComboBox({
                           width: 400,
                           cancelable: true
                       });
                       cellControls.FontName = $("#FontFun").ligerComboBox({
                           data: fontNameData,
                           onSelected: cellManager.FontFunc_Select
                       });
                       cellControls.FontSize = $("#FontSizeFun").ligerComboBox({
                           data: fontSizeData,
                           onSelected: cellManager.FontSizeFuncSelect
                       });
                       cellControls.CellLogicalType = $("input[name='CellLogicalType']").ligerComboBox({
                           data: cellLogicalData
                       });
                       cellControls.CellDataType = $("input[name='CellDataType']").ligerComboBox({
                           data: cellDataTypeData,
                           onSelected: cellManager.CellDataType_Click
                       });
                       cellControls.CellThousand = $("input[name='CellThousand']").ligerComboBox({
                           data: [
                   { text: "是", id: "1" },
                   { text: "否", id: "0" }
                   ]
                       });
                       cellControls.CellZero = $("input[name='CellZero']").ligerComboBox({
                           data: [
                   { text: "是", id: "1" },
                   { text: "否", id: "0" }
                   ]
                       });
                       cellControls.DigitNumber = $("input[name='DigitNumber']").ligerComboBox({
                           data: [
                   { text: "取整数", id: "0" },
                   { text: "保留一位", id: "1" },
                   { text: "保留两位", id: "2" },
                   { text: "保留三位", id: "3" },
                   { text: "保留四位", id: "4" }
                   ]
                       });
                       cellControls.CellSmbol = $("input[name='CellSmbol']").ligerComboBox({
                           data: smbolData
                       });
                       cellControls.CellCurrence = $("input[name='CellCurrence']").ligerComboBox({
                           data: currenceData
                       });

                       cellControls.CellType = $("input[name='CellType']").ligerComboBox({
                           width: 170,
                           data: cellTypeData
                       });
                       cellControls.CellLock = $("input[name='CellLock']").ligerComboBox({
                           data: [
                   { text: "是", id: "1" },
                   { text: "否", id: "0" }
                   ]
                       });



                       cellControls.CellAggregation = $("input[name='CellAggregation']").ligerComboBox({
                           data: [
                   { text: "是", id: "1" },
                   { text: "否", id: "0" }
                   ]
                       });

                       cellControls.CellAggregationType = $("input[name='CellAggregationType']").ligerComboBox({
                           data: [
                   { text: "求和", id: "01" },
                   { text: "求平均", id: "02" }
                   ,
                   { text: "最大值", id: "03" }
                   ,
                   { text: "最小值", id: "04" }
                   ]
                       });

                       cellControls.CellPrimary = $("input[name='CellPrimary']").ligerComboBox({
                           data: [
                   { text: "是", id: "1" },
                   { text: "否", id: "0" }
                   ]
                       });
                       cellControls.CellHeight = $("#cellHeight").ligerSpinner({
                           height: 20,width:60, type: 'int', isNegative: false, minValue: 10,
                           step:1
                       });
                       cellControls.CellWidth = $("#cellWidth").ligerSpinner({
                           height: 20, width: 60, type: 'int', isNegative: false, minValue: 10,
                           step: 1
                       });
                       $("#changeWidth").Btn({ text: "确定", click: cellManager.ColWidth_Click });
                       $("#changeHeight").Btn({ text: "确定", click: cellManager.RowHeight_Click });
                       


                       cellControls.CellMacro = $("input[name='CellMacro']").ligerPopupEdit({ width: 170, onButtonClick: cellManager.CellMaro_Click });
                       cellControls.CellHelp = $("input[name='CellHelp']").ligerPopupEdit({ width: 170, onButtonClick: cellManager.CellHelp_Click });
                       BindClick();
                       InitializeFlexCell(1, 1);

                   });
        //初始事件绑定
        function BindClick() {
            $.each($(".ke-outline"), function (index) {
                $(this).bind(
            "mouseover", function () {
                $(this).css("border", "1px solid #5690D2");
            });
                $(this).bind(
            "mouseout", function () {
                $(this).css("border", "");
            });
                $(this).bind(
            "click", function () {

                var flag = false;
                if ($(this).hasClass("ke-selected")) {
                    flag = true;
                } else {
                    flag = false;
                }

                if ($(this).attr("id") != "ForeColor" && $(this).attr("id") != "BackColor" && $(this).attr("id") != "Border") {
                    if (flag) {
                        $(this).removeClass("ke-toolbar ke-selected");
                    } else {
                        $(this).addClass("ke-toolbar ke-selected");
                    }
                }
                flag = !flag;
                if ($(this).attr("id") == cellNameValue.FontBold) {
                    cellManager.FontBold_Click(flag);
                } else if ($(this).attr("id") == cellNameValue.FontItalic) {
                    cellManager.FontItalic_Click(flag);
                } else if ($(this).attr("id") == "FontUnderline") {
                    cellManager.FontUnderLine_Click(flag);
                } else if ($(this).attr("id") == "left") {
                    cellManager.Alignment_Click(flag, "6");
                } else if ($(this).attr("id") == "center") {
                    cellManager.Alignment_Click(flag, "10");
                } else if ($(this).attr("id") == "right") {
                    cellManager.Alignment_Click(flag, "14");
                } else if ($(this).attr("id") == "ForeColor") {
                    var result = window.showModalDialog("ColorPick.aspx", null, "dialogHeight:200px;dialogWidth:200px");
                    if (result) {
                        cellManager.ForeColor_Click(toolManager.CovertColorStr(result));
                    }
                } else if ($(this).attr("id") == "BackColor") {
                    var result = window.showModalDialog("ColorPick.aspx", null, "dialogHeight:200px;dialogWidth:200px");
                    if (result) {
                        cellManager.BackColor_Click(toolManager.CovertColorStr(result));
                    }
                } else if ($(this).attr("id") == "Border") {
                    var result = window.showModalDialog("Border.aspx", null, "dialogWidth:100px;dialogHeight:100px");
                    if (result && !toolManager.IsNullOrEmpty(result.Edge)) {
                        cellManager.Border_Click(result.Edge, result.LineStyle);
                    }
                } else if ($(this).attr("id") == "LeftTor") {
                    cellManager.LeftTor_Click();
                } else if ($(this).attr("id") == "RightTor") {
                    cellManager.RightTor_Click();
                } else if ($(this).attr("id") == "DelS") {
                    cellManager.DeleteS_Click();
                }
            });
            });
    $("#okBtn1").bind("click", cellManager.ApplicationOk_Click);
    $("#okBtn2").bind("click", cellManager.ApplicationOk_Click);

    $("#autoCreateCode").bind("click", function () {
        if ($("#autoCreateCode").attr("checked")) {
            $("#autoNumCode").attr("checked","");
        }
    });
    $("#autoNumCode").bind("click", function () {
        if ($("#autoNumCode").attr("checked")) {
            $("#autoCreateCode").attr("checked", "");
        }
    });
    $("#wrapText").bind("change",cellManager.WrapText_Change);
    }
    //创始控件值
    function InitializeControlValue(flag) {
        if (flag) cellFlag.cellSetFlag = false;
        cellControls.FontName.setValue("");
        cellControls.FontSize.setValue("");
        cellControls.CellDataType.setValue("01");
        cellControls.CellType.setValue("01");
        $("input[name='CellLength']").val(255);
        if (flag) cellFlag.cellSetFlag = true;
        cellControls.CellType.setValue("01");
    }

        //菜单相应事件
        function itemclick(item) {
            if (item.text != "新建报表" && item.text != "导入报表"&&(!BBData.bbCode || BBData.bbCode == "")) { alert("先导入或新建一张报表"); return; }
            if (item.text == "新建报表") {
            //报表状态信息初始
                currentState.bdColNum = 0;
                currentState.bdNum = 0;
                currentState.bdRowNum = 0;
                //新建报表
                menuManager.NewReportFunc();
            } else if (item.text == "打印预览") {
                GridManager.printView();
            } else if (item.text == "打印") {
                GridManager.Print();
            } else if (item.text == "合并单元格") {
                GridManager.MergeCell();
            } else if (item.text == "取消合并") {
                GridManager.CancelMerge();
            } else if (item.text == "插入行") {
                GridManager.InsertRow();               
            } else if (item.text == "插入列") {
                GridManager.InsertCol();
                for (var i = 1; i < Grid1.Cols; i++) {
                    Grid1.Cell(0, i).Text = i;
                }
            } else if (item.text == "删除行") {
                GridManager.DeleteRow();
            } else if (item.text == "删除列") {
                GridManager.DeleteCol();
                for (var i = 1; i < Grid1.Cols; i++) {
                    Grid1.Cell(0, i).Text = i;
                }
            } else if (item.text == "设置变动行") {
                menuManager.NewBdFunc("1", Grid1.Cols);
            } else if (item.text == "取消变动行") {
                GridManager.CancelChangeRow();
            } else if (item.text == "设置变动列") {
                menuManager.NewBdFunc("2", Grid1.Rows);
            } else if (item.text == "取消变动列") {
                GridManager.CancelChangeCol();
            } else if (item.text == "保存报表") {
                menuManager.SaveMenu();
            } else if (item.text == "导入报表") {
                var paras = { columns:[],ReportId: ImportReportControl.Id, ClassifyId: ImportReportControl.ClassifyId };
                var result = window.showModalDialog("../pub/HelpSearchDialog.aspx", paras, "dialogHeight:400px;dialogWidth:600px");
                if (result && result.Id != undefined) {      
                    if (result.ReportClassifyId != "") {
                        ImportReportControl.Id = result.Id;
                        ImportReportControl.ClassifyId = result.ReportClassifyId; 
                    }
                    var para = { Id: "" };
                    para.Id = result.Id;
                    para = CreateParameter(ReportFormatAction.ActionType.Post, ReportFormatAction.Functions.ReportFormatMenu, ReportFormatAction.Methods.ReportFormatMenuMethods.LoadReportFormat, para);

                    DataManager.sendData(urls.functionsUrl, para, resultManagers.LoadSuccess, resultManagers.fail, false);

                }
            }
        }
        function InitializeFlexCell(row,col) {

            if (Grid1) {
                Grid1.NewFile();  
                Grid1.AutoRedraw = false;
                Grid1.Cols = col;
                Grid1.Rows = row;
                Grid1.DisplayRowIndex = true;        
                Grid1.AutoRedraw = true;
                Grid1.Refresh();
                if (Grid1.attachEvent) {
                    Grid1.attachEvent("RowColChange", GridManager.RowColChange_Event);                               
                }
                InitializeControlValue(true);
                BBData = { bbCode: "", bbName: "", bbData: {}, bdq: { bdNum: 0, BdRowNum: 0, BdColNum: 0, BdqMaps: {}, Bdqs: []},MaxNum:"0" };
            }

        }
        function Grid_KeyDown(KeyCode,shift) {
            if (event.ctrlKey && event.keyCode == 67) {
                Grid1.Selection.CopyData();
               
          }
 
        }
        //菜单管理器
        var menuManager = {
            FileMenu: { width: 120, items:
            [
            { text: '新建报表', icon: 'add', click: itemclick },
            { text: '保存报表', click: itemclick },
            { line: true },
            { text: '打印预览', click: itemclick },
            { text: "打印", click: itemclick }
            ]
            },
            EditMenu: { width: 120, items:
            [
            {
                text: '表行', children:
                [
                    { text: '插入行', click: itemclick },
                    { text: '删除行', click: itemclick },
                    { line: true },
                    { text: '设置变动行', click: itemclick },
                     { text: '取消变动行', click: itemclick }
                ]
            }, {
                text: '表列', children:
                [
                   { text: '插入列', click: itemclick },
                    { text: '删除列', click: itemclick },
                    { line: true },
                    { text: '设置变动列', click: itemclick },
                     { text: '取消变动列', click: itemclick }
                ]
            }
            ]
            },
            NewReportFunc: function () {
                var result = window.showModalDialog("NewReport.aspx", null, "dialogHeight:420px;dialogWidth:380px");
                //重置变动区最大编号
                if (result) currentState.MaxBdNm = 0;
                if (result && result["row"] && result["col"]) {

                    InitializeFlexCell(parseInt(result["row"]) + 1, parseInt(result["col"]) + 1);
                    for (var i = 1; i < Grid1.Cols; i++) {
                        Grid1.Cell(0, i).Text = i;
                    }
                }
                if (result && result["code"]) {
                    $('input[name="bbCode"]').val(result["code"]);
                    BBData.bbCode = result["code"];
                }
                if (result && result["name"]) {
                    $('input[name="bbName"]').val(result["name"]);
                    BBData.bbName = result["name"];
                }
                if (result && result["row"]) {
                    BBData.bbRows = result["row"];
                    $('input[name="bbRows"]').val(result["row"]);
                }

                if (result && result["col"]) {
                    BBData.bbCols = result["col"];
                    $('input[name="bbCols"]').val(result["col"]);
                }
                if (result && result["classifyId"]) {
                    BBData.bbClassifyId = result["classifyId"];
                }
                if (result && result["zq"]) {
                    BBData.zq = result["zq"];
                    $('input[name="zq"]').val(toolManager.GetZqName(BBData.zq));
                }
            },
            NewBdFunc: function (type, num) {
                var para = { type: type, num: num, DataCode: "", DataName: "", SortRow: "", isOrNotMerge: "" };
                var selection = Grid1.Selection;
                var offset;
                //获取变动区数据
                if (type == "1") {
                    offset = selection.FirstRow;
                   
                } else if (type == "2") {
                    offset = selection.FirstCol;
                }
                var bdq = bdManager.GetBdq(offset, type);
                if (bdq["Code"] && bdq["Code"] != null) {
                    para.DataCode = bdq.DataCode;
                    para.DataName = bdq.DataName;
                    para.SortRow = bdq.SortRow;
                    para.isOrNotMerge = bdq.isOrNotMerge;
                }
                var result = window.showModalDialog("NewBd.aspx", para, "dialogHeight:180px;dialogWidth:300px");
                if (type == "1") {
                    GridManager.SetChangeRow(result, bdq);
                } else if (type == "2") {
                    GridManager.SetChangeCol(result, bdq);
                }
            },
            SaveMenu: function () {
                var para = { dataStr: "", gridXmlStr: "" };
                para.dataStr = JSON.stringify(menuManager.CreateReportFormatData());
                para.gridXmlStr = Base64.toBase64(Grid1.ExportToXMLString());

                var parameter = CreateParameter(ReportFormatAction.ActionType.Post, ReportFormatAction.Functions.ReportFormatMenu, ReportFormatAction.Methods.ReportFormatMenuMethods.Save, para);
                DataManager.sendData(urls.functionsUrl, parameter, resultManagers.success, resultManagers.fail);
            },
            CreateReportFormatData: function () {
                var bbData = { Id: "", bbCode: "", bbName: "", bbClassifyId: "", bbData: {}, bdq: { bdNum: 0, BdRowNum: 0, BdColNum: 0, BdqMaps: {}, Bdqs: [] }, bbRows: "", bbCols: "", zq: "", MergeCells: [], MaxNum: "0" };
                //生成报表相关的数据
                bbData.Id = BBData.Id;
                bbData.bbCode = BBData.bbCode;
                bbData.bbName = $('input[name="bbName"]').val();
                bbData.bbClassifyId = BBData.bbClassifyId;

                bbData.MergeCells = BBData.MergeCells;
                bbData.bbRows = BBData.bbRows;
                bbData.bbCols = BBData.bbCols;
                bbData.zq = BBData.zq;
                if (cellFlag.compatible) {
                    if (!bbData.zq || bbData.zq == "") {
                        bbData.zq = "02:月报";
                    }
                }
                //设置最大单元格
                bbData.MaxNum = BBData.MaxNum;

                //设置变动区信息
                bbData.MaxBdNm = currentState.MaxBdNm;
                //设置变动列信息
                //{ Code: "", BdType: "", Offset: -1, SortRow: 2, DataCode: 2, DataName: 3, isOrNotMerge: false }
                var index = 0;
                //变动行信息设置
                for (var i = 0; i < Grid1.Rows; i++) {
                    var bdq = toolManager.TagTool.GetTagBdqData(i, 1);
                    if (bdq && bdq["BdType"] && bdq["BdType"] == "1") {
                        bdq["Offset"] = i;
                        bbData.bdq.BdqMaps[bdq["Code"]] = index;
                        bbData.bdq.Bdqs.push(bdq);
                        index++;
                    }
                }
                //保存变动行数量
                bbData.bdq.BdRowNum = bbData.bdq.Bdqs.length;
                //变动列信息设置
                for (var i = 0; i < Grid1.Cols; i++) {
                    var bdq = toolManager.TagTool.GetTagBdqData(1, i);
                    if (bdq && bdq["BdType"] && bdq["BdType"] == "2") {
                        bdq["Offset"] = i;
                        bbData.bdq.BdqMaps[bdq["Code"]] = index;
                        bbData.bdq.Bdqs.push(bdq);
                        index++;
                    }
                }
                //保存变动列数量
                bbData.bdq.BdColNum = bbData.bdq.Bdqs.length - bbData.bdq.BdRowNum;

                bbData.bdq.bdNum = bbData.bdq.Bdqs.length;
                //单元格信息设置
                for (var i = 0; i < Grid1.Rows; i++) {
                    for (var j = 0; j < Grid1.Cols; j++) {
                        var cellData = toolManager.TagTool.GetTagCellData(i, j);
                        if (cellData != null && cellData[cellNameValue.CellLogicalType]) {
                            var cellData = toolManager.GetCellData(i, j);

                            cellData[cellNameValue.CellRow] = i;
                            cellData[cellNameValue.CellCol] = j;
                            if (!cellData[cellNameValue.DigitNumber] || cellData[cellNameValue.DigitNumber] == "") {
                                cellData[cellNameValue.DigitNumber] = 2;
                            }
                            toolManager.SetCellData(bbData, i, j, cellData);
                        }
                    }
                }
                return bbData;
            },
            CellCodeRefresh: function (checked) {
                if (checked) {
                    $("#autoCreateCode").attr("disabled", false);
                    $("#autoNumCode").attr("disabled", false);
                } else {
                    $("#autoCreateCode").attr("disabled", true);
                    $("#autoNumCode").attr("disabled", true);
                }
            }
        };

        var cellManager = {
            GeneralCell: function (func, value) {

                for (var i = Grid1.Selection.FirstRow; i <= Grid1.Selection.LastRow; i++) {
                    for (var j = Grid1.Selection.FirstCol; j <= Grid1.Selection.LastCol; j++) {
                        func(i, j, value);
                    }
                }

            },
            GeneralLoadCellDataValue: function (row, col) {

                //报表单元格选中后的处理方式           
                row = Grid1.Selection.FirstRow;
                col = Grid1.Selection.FirstCol;
                //防止重复定义
                if (currentState.oldCol == col && currentState.oldRow == row) {
                    return;
                } else {
                    currentState.oldRow = row;
                    currentState.oldCol = col;
                }
                cellFlag.cellSetFlag = false;
                //获取单元格信息，并初始数据
                var cellData = toolManager.TagTool.GetTagCellData(row, col);
                //获取 行、列宽 //@张双义
                var width = Grid1.Column(col).Width;
                var height = Grid1.RowHeight(row);
                cellControls.CellHeight.setValue(height);
                cellControls.CellWidth.setValue(width);
                //设置 重置内码为为选中
                cellControls.CellCodeRefresh.setValue(false);
                if (cellData != null && cellData[cellNameValue.CellLogicalType] && cellData[cellNameValue.CellLogicalType] != null) {
                    //如果数据项不为空
                    var fontName = cellData[cellNameValue.FontName];
                    if (toolManager.IsNullOrEmpty(cellData, cellNameValue.FontName)) {
                        cellControls.FontName.setValue(cellData[cellNameValue.FontName]);
                    } else {
                        cellControls.FontName.setValue("");
                    }

                    if (toolManager.IsNullOrEmpty(cellData, cellNameValue.FontSize)) {
                        cellControls.FontSize.setValue(cellData[cellNameValue.FontSize]);
                    } else {
                        cellControls.FontSize.setValue("");
                    }



                    if (toolManager.IsNullOrEmpty(cellData, cellNameValue.FontBold)) {
                        $("#FontBold").addClass("ke-toolbar ke-selected");
                    } else {
                        $("#FontBold").removeClass("ke-toolbar ke-selected");
                    }

                    if (toolManager.IsNullOrEmpty(cellData, cellNameValue.FontItalic)) {
                        $("#FontItalic").addClass("ke-toolbar ke-selected");
                    } else {
                        $("#FontItalic").removeClass("ke-toolbar ke-selected");
                    }
                    if (toolManager.IsNullOrEmpty(cellData, cellNameValue.FontUnderline)) {
                        $("#FontUnderline").addClass("ke-toolbar ke-selected");
                    } else {
                        $("#FontUnderline").removeClass("ke-toolbar ke-selected");
                    }
                    if (toolManager.IsNullOrEmpty(cellData, cellNameValue.Alignment)) {
                        if (cellData[cellNameValue.Alignment] == "6") {
                            $("#left").addClass("ke-toolbar ke-selected");
                        } else if (cellData[cellNameValue.Alignment] == "10") {
                            $("#center").addClass("ke-toolbar ke-selected");
                        } else if (cellData[cellNameValue.Alignment] == "14") {
                            $("#right").addClass("ke-toolbar ke-selected");
                        }

                    } else {
                        $("#left").removeClass("ke-toolbar ke-selected");
                        $("#center").removeClass("ke-toolbar ke-selected");
                        $("#right").removeClass("ke-toolbar ke-selected");
                    }


                    //设置表格的逻辑属性
                    $("#autoCreateCode").attr("disabled", true);
                    $("#autoNumCode").attr("disabled", true);
                    if (toolManager.IsNullOrEmpty(cellData, cellNameValue.CellLogicalType))
                        cellControls.CellLogicalType.setValue(cellData[cellNameValue.CellLogicalType]);
                    else {
                        cellControls.CellLogicalType.setValue("01");
                    }
                    if (toolManager.IsNullOrEmpty(cellData, cellNameValue.CellCode))
                        $("input[name='CellCode']").val(cellData[cellNameValue.CellCode]);
                    else {
                        $("input[name='CellCode']").val("");
                    }
                    var code = $("input[name='CellCode']").val();
                    var front4 = code.substring(0, 4);
                    if (front4 == "0000") {
                        $("#autoCreateCode").attr("checked", false);
                        $("#autoNumCode").attr("checked", true);
                    } else {
                        $("#autoCreateCode").attr("checked", true);
                        $("#autoNumCode").attr("checked", false);
                    }
                    if (toolManager.IsNullOrEmpty(cellData, cellNameValue.CellName))
                        $("input[name='CellName']").val(cellData[cellNameValue.CellName]);
                    else {
                        $("input[name='CellName']").val("");
                    }
                    if (toolManager.IsNullOrEmpty(cellData, cellNameValue.WrapText))
                        $("#wrapText").attr("checked", "checked");

                    else {
                        $("#wrapText").attr("checked", "");
                    }
                    if (toolManager.IsNullOrEmpty(cellData, cellNameValue.CellDataType))
                        cellControls.CellDataType.setValue(cellData[cellNameValue.CellDataType]);

                    else {
                        cellControls.CellDataType.setValue("01");
                    }

                    if (toolManager.IsNullOrEmpty(cellData, cellNameValue.CellSmbol))
                        cellControls.CellSmbol.setValue(cellData[cellNameValue.CellSmbol]);
                    else {
                        cellControls.CellSmbol.setValue("");
                    }

                    if (toolManager.IsNullOrEmpty(cellData, cellNameValue.CellCurrence))
                        cellControls.CellCurrence.setValue(cellData[cellNameValue.CellCurrence]);
                    else {
                        cellControls.CellCurrence.setValue("");
                    }

                    if (toolManager.IsNullOrEmpty(cellData, cellNameValue.CellZero))
                        cellControls.CellZero.setValue(cellData[cellNameValue.CellZero]);
                    else {
                        cellControls.CellZero.setValue("");
                    }
                    if (toolManager.IsNullOrEmpty(cellData, cellNameValue.DigitNumber))
                        cellControls.DigitNumber.setValue(cellData[cellNameValue.DigitNumber]);
                    else {
                        cellControls.DigitNumber.setValue("");
                    }
                    if (toolManager.IsNullOrEmpty(cellData, cellNameValue.CellLock))
                        cellControls.CellLock.setValue(cellData[cellNameValue.CellLock]);
                    else {
                        cellControls.CellLock.setValue("");
                    }

                    if (toolManager.IsNullOrEmpty(cellData, cellNameValue.CellThousand))
                        cellControls.CellThousand.setValue(cellData[cellNameValue.CellThousand]);
                    else {
                        cellControls.CellThousand.setValue("");
                    }

                    if (toolManager.IsNullOrEmpty(cellData, cellNameValue.CellType))
                        cellControls.CellType.setValue(cellData[cellNameValue.CellType]);
                    else {
                        cellControls.CellType.setValue("");
                    }

                    if (toolManager.IsNullOrEmpty(cellData, cellNameValue.CellName)) {
                        $("input[name='CellName']").val(cellData[cellNameValue.CellName]);
                    } else {
                        $("input[name='CellName']").val("");
                    }

                    if (toolManager.IsNullOrEmpty(cellData, cellNameValue.CellMacro)) {
                        cellControls.CellMacro.setText(cellData[cellNameValue.CellMacro]);
                    } else {
                        cellControls.CellMacro.setText("");
                    }

                    if (toolManager.IsNullOrEmpty(cellData, cellNameValue.CellHelp)) {
                        cellControls.CellHelp.setText(cellData[cellNameValue.CellHelp]);
                    } else {
                        cellControls.CellHelp.setText("");
                    }

                    if (toolManager.IsNullOrEmpty(cellData, cellNameValue.CellAggregation))
                        cellControls.CellAggregation.setValue(cellData[cellNameValue.CellAggregation]);
                    else {
                        cellControls.CellAggregation.setValue("");
                    }
                    if (toolManager.IsNullOrEmpty(cellData, cellNameValue.CellAggregationType))
                        cellControls.CellAggregationType.setValue(cellData[cellNameValue.CellAggregationType]);
                    else {
                        cellControls.CellAggregationType.setValue("");
                    }
                    if (toolManager.IsNullOrEmpty(cellData, cellNameValue.CellPrimary))
                        cellControls.CellPrimary.setValue(cellData[cellNameValue.CellPrimary]);
                    else {
                        cellControls.CellPrimary.setValue("");
                    }
                } else {

                    //如果数据项为空
                    $("#autoCreateCode").attr("disabled", false);
                    $("#autoNumCode").attr("disabled", false);
                    InitializeControlValue(false);
                    $.each($(".ke-outline"), function (index) {
                        $(this).removeClass("ke-toolbar ke-selected");
                    });
                    cellControls.CellLogicalType.setValue("");
                    $("input[name='CellCode']").val("");
                    $("input[name='CellName']").val("");
                    cellControls.CellDataType.setValue("01");
                    cellControls.CellCurrence.setValue("");
                    cellControls.CellSmbol.setValue("");
                    cellControls.CellThousand.setValue("");
                    cellControls.CellLock.setValue("");
                    cellControls.CellZero.setValue("");
                    cellControls.DigitNumber.setValue("");
                    cellControls.CellType.setValue("");
                    cellControls.CellMacro.setText("");
                    cellControls.CellAggregation.setValue("");
                    cellControls.CellAggregationType.setValue("");
                    cellControls.CellPrimary.setValue("");
                    cellControls.CellType.setValue("01");
                    $("#wrapText").attr("checked", "");


                }
                //获取变动行信息，并显示
                var bdq = toolManager.TagTool.GetTagBdqData(row, col);
                if (bdq && bdq.Code) {
                    $("#bdqSpan").val(bdq.Code);
                } else {
                    $("#bdqSpan").val("");
                }
                cellFlag.cellSetFlag = true;

            },
            FontFunc_Select: function (value, text) {
                if (value && cellFlag.cellSetFlag) {
                    if (value == "null" || value == "undefined") value = "宋体";
                    Grid1.Selection.FontName = value;
                    cellManager.GeneralCell(GridManager.SetFontName, value);
                }
            },
            FontSizeFuncSelect: function (value, text) {
                if (value && cellFlag.cellSetFlag) {
                    if (value == "null" || value == "undefined") value = "9";
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
            LeftTor_Click: function () {
                cellManager.GeneralCell(GridManager.LeftTorward);
            },
            RightTor_Click: function () {
                cellManager.GeneralCell(GridManager.RightTorward);
            },
            DeleteS_Click: function () {
                cellManager.GeneralCell(GridManager.DeleteQuestionMark);
            },
            RowHeight_Click: function () {
                var height = cellControls.CellHeight.getValue();
                cellManager.GeneralCell(GridManager.SetRowHeight, height)
                //                var row = Grid1.Selection.FirstRow;
                //                if (row) {
                //                    GridManager.SetRowHeight(row, height);
                //                }
            },
            ColWidth_Click: function () {
                var width = cellControls.CellWidth.getValue();
                cellManager.GeneralCell(GridManager.SetColWidth, width)
                //                var col = Grid1.Selection.FirstCol;
                //                if (col)
                //                    GridManager.SetColWidth(col, width);
            },
            CellMaro_Click: function () {
                var paras = { url: "", columns: [], sortName: "", sortOrder: "", NameField: "Name", CodeField: "Code" };
                paras.url = "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Grid + "&MethodName=" + BasicAction.Methods.DicManagerMethods.GetDictionaryListByClass + "&FunctionName=" + BasicAction.Functions.DictionaryManager + "&classId=HHS";
                paras.columns = [[
                { field: "Code", title: "编号", width: 120 },
                    { field: "Name", title: "名称", width: 200 }

                    ]];
                paras.sortName = "Code";
                paras.sortOrder = "ASC";
                var result = window.showModalDialog("../pub/HelpDialog.aspx", paras, "dialogHeight:400px;dialogWidth:350px");
                if (result && result.Code != undefined) {
                    var value = "<!" + result.Code + "!>";
                    cellControls.CellMacro.setText(value);
                    cellManager.GeneralCell(GridManager.SetCellMacro, value);
                }
            },
            CellHelp_Click: function () {
                var paras = { url: "", columns: [], sortName: "", sortOrder: "", NameField: "Name,Code", CodeField: "Code" };
                paras.url = "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Grid + "&MethodName=" + BasicAction.Methods.DicManagerMethods.GetDicClassifyDataGridFilter + "&FunctionName=" + BasicAction.Functions.DictionaryManager;
                paras.columns = [[
                { field: "Code", title: "编号", width: 120 },
                    { field: "Name", title: "名称", width: 200 }

                    ]];
                paras.sortName = "Code";
                paras.sortOrder = "ASC";
                var result = window.showModalDialog("../pub/HelpDialog.aspx", paras, "dialogHeight:400px;dialogWidth:350px");
                if (result && result.Code != undefined) {
                    var value = result.Code;
                    cellControls.CellHelp.setText(value);
                    cellManager.GeneralCell(GridManager.SetCellHelp, value);
                }
            },
            ApplicationOk_Click: function () {
                //设置数据项信息
                var logicalType = cellControls.CellLogicalType.getValue();
                cellManager.GeneralCell(GridManager.ApplicationCellData, logicalType);
            },
            CellDataType_Click: function (Type) {
                //设置不同数据类型 单元格的设置项
                if (Type == "01") {
                    $("#valueTable").css("display", "none");
                    $("#charTable").css("display", "table");
                } else if (Type == "02") {
                    $("#valueTable").css("display", "table");
                    $("#charTable").css("display", "none");
                }
            },
            WrapText_Change: function () {
                if ($("wrapText").attr("checked")) {
                    cellManager.GeneralCell(GridManager.SetWrapText, 0);
                } else {
                    cellManager.GeneralCell(GridManager.SetWrapText, 1);
                }
            }
        };

        var GridManager = {
            SetGridTag: function (row, col, cellData, bdqData) {
                try {
                    var tag = Grid1.Cell(row, col).Tag;
                   
                    if (!tag || tag == "") { tag = {}; } else {
                        tag = JSON2.parse(tag);
                    }
                    if (cellData) {
                        tag["cellData"] = cellData;
                    }
                    if (bdqData) {
                        tag["bdqData"] = bdqData;
                    }
                    Grid1.Cell(row, col).Tag = JSON2.stringify(tag);
                } catch (err) {
                    alert(err.Message);
                }
            },
            GetGridTag: function (row, col) {
                try {
                    var tag = Grid1.Cell(row, col).Tag;
                    if (tag != "") {
                        tag = JSON2.parse(tag);
                    } else {
                        tag = {};
                    }
                    return tag;
                } catch (err) {
                    alert(err.Message);
                }
            },
            SetTagCellDataNameValue: function (row, col, name, value) {
                try {
                    //设置数据项的属性
                    var tag = GridManager.GetGridTag(row, col);
                    if (tag[cellTag.cellData]) {
                        tag[cellTag.cellData][name] = value;
                    } else {
                        tag[cellTag.cellData] = {};
                        tag[cellTag.cellData][name] = value;
                    }
                    GridManager.SetGridTag(row, col, tag[cellTag.cellData]);
                } catch (err) {
                    alert(err.Message);
                }
            },
            printView: function () {
                Grid1.PrintPreview();
            },
            Print: function () {
                Grid1.PrintDialog();
            },
            MergeCell: function () {
                var select = Grid1.Selection;
                var mc = { row1: "", col1: "", row2: "", col2: "" };
                mc.row1 = select.FirstRow;
                mc.col1 = select.FirstCol;
                mc.row2 = select.LastRow;
                mc.col2 = select.LastCol;
                if (BBData.MergeCells == undefined) {
                    BBData.MergeCells = [];
                }
                BBData.MergeCells.push(mc);
                Grid1.Selection.Merge();
            },
            CancelMerge: function () {
                Grid1.Selection.MergeCells = false;
            },
            InsertRow: function () {
                Grid1.Selection.InsertRows();
                //判断是否存在变动列信息，如果存在，则进行设置
                for (var i = 0; i < Grid1.Cols; i++) {
                    var bdq = bdManager.IsOrNotBdq(1, i);
                    if (bdq != null) {
                        GridManager.SetGridTag(Grid1.Selection.FirstRow, i, null, bdq);
                        //设置当前单元格的颜色
                        Grid1.Cell(Grid1.Selection.FirstRow, i).BackColor = toolManager.CovertColorStr("#FF99CC");

                        //改变报表当前行
                        BBData.bbRows = parseInt(BBData.bbRows) + 1;
                        $("input[name='bbRows']").val(BBData.bbRows);
                    }
                }
            },
            InsertCol: function () {
                Grid1.Selection.InsertCols()
                //判断是否存在变动行信息，如果存在，则进行设置
                for (var i = 0; i < Grid1.Rows; i++) {
                    var bdq = bdManager.IsOrNotBdq(i, 1);
                    if (bdq != null) {
                        GridManager.SetGridTag(i, Grid1.Selection.FirstCol, null, bdq);
                        Grid1.Cell(i, Grid1.Selection.FirstCol).BackColor = toolManager.CovertColorStr("#FF99CC");
                        //报表当前列改变
                        BBData.bbCols = parseInt(BBData.bbCols) + 1;
                        $("input[name='bbCols']").val(BBData.bbCols);
                    }
                }


            },
            DeleteRow: function () {
                Grid1.Selection.DeleteByRow();
                //改变报表当前行
                BBData.bbRows = parseInt(BBData.bbRows) - 1;
                $("input[name='bbRows']").val(BBData.bbRows);
            },
            DeleteCol: function () {
                Grid1.Selection.DeleteByCol();
                //报表当前列改变
                BBData.bbCols = parseInt(BBData.bbCols) - 1;
                $("input[name='bbCols']").val(BBData.bbCols);

            },
            LeftTorward: function (row, col) {
                var text = Grid1.Cell(row, col).Text;
                if (text != "") {
                    for (var i = 0; i < 2; i++) {
                        var ch = text.substr(0, 1);
                        if (ch == " " || ch == "　") {
                            text = text.substring(1);
                        }
                    }
                }
                Grid1.Cell(row, col).Text = text;
            },
            RightTorward: function (row, col) {
                var text = Grid1.Cell(row, col).Text;
                if (text != "") {
                    for (var i = 0; i < 2; i++) {
                        text = " " + text;
                    }
                }
                Grid1.Cell(row, col).Text = text;
            },
            DeleteQuestionMark: function (row, col) {

                Grid1.Cell(row, col).Text = Grid1.Cell(row, col).Text.replace(/\?/g, " ");
            },
            SetFontName: function (row, col, fontName) {
                GridManager.SetTagCellDataNameValue(row, col, cellNameValue.FontName, fontName);

            },
            SetFontSize: function (row, col, fontSize) {
                GridManager.SetTagCellDataNameValue(row, col, cellNameValue.FontSize, fontSize);
            },
            SetFontBold: function (row, col, fontBold) {
                GridManager.SetTagCellDataNameValue(row, col, cellNameValue.FontBold, fontBold);
            },
            SetFontItalic: function (row, col, fontItalic) {
                GridManager.SetTagCellDataNameValue(row, col, cellNameValue.FontItalic, fontItalic);
            },
            SetFontUnderline: function (row, col, fontUnderline) {
                GridManager.SetTagCellDataNameValue(row, col, cellNameValue.FontUnderline, fontUnderline);
            },
            RowColChange_Event: function (row, col) {
                cellManager.GeneralLoadCellDataValue(row, col);
            },
            SetRowHeight: function (row, col, height) {
                Grid1.RowHeight(row) = height;
            },
            SetColWidth: function (row, col, width) {
                Grid1.Column(col).Width = width;
            },
            SetCellAlignment: function (row, col, alignment) {

                GridManager.SetTagCellDataNameValue(row, col, cellNameValue.Alignment, alignment);
            }
            ,
            SetForeColor: function (row, col, foreColor) {

                GridManager.SetTagCellDataNameValue(row, col, cellNameValue.ForeColor, foreColor);
            },
            SetBackColor: function (row, col, backColor) {

                GridManager.SetTagCellDataNameValue(row, col, cellNameValue.BackColor, backColor);
            },
            SetBorder: function (row, col, edge, value) {
                GridManager.SetTagCellDataNameValue(row, col, cellNameValue.Border, edge + ":" + value);

            },
            SetWrapText: function (row, col, value) {
                GridManager.SetTagCellDataNameValue(row, col, cellNameValue.WrapText, value);
                Grid1.Cell(row, col).WrapText = value;
            },
            //设置宏函数
            SetCellMacro: function (row, col, value) {
                GridManager.SetTagCellDataNameValue(row, col, cellNameValue.CellMacro, value);
            },
            SetCellHelp: function (row, col, value) {
                GridManager.SetTagCellDataNameValue(row, col, cellNameValue.CellHelp, value);
            },
            SetChangeRow: function (para, bdq) {
                if (!para) return;
                var temp = Grid1.Selection;
                var rowNum = temp.FirstRow;
                var cols = Grid1.Cols - 1;
                if (!bdq["Code"] || bdq["Code"] == null) {
                    Grid1.Range(rowNum, 1, rowNum, cols).BackColor = toolManager.CovertColorStr("#FF99CC");
                    //变动行逻辑数据
                    bdq = bdManager.CreateBdq("1", para);
                } else {
                    Grid1.Range(rowNum, 1, rowNum, cols).BackColor = toolManager.CovertColorStr("#FF99CC");
                    bdq = bdManager.EditBdq(bdq, para);
                }
                //保存变动区
                for (var i = 1; i < Grid1.Cols; i++) {
                    GridManager.SetGridTag(rowNum, i, null, bdq);
                }
            },
            CancelChangeRow: function () {
                try {
                    var temp = Grid1.Selection;
                    var rowNum = temp.FirstRow;
                    var colNum = temp.FirstCol;
                    var cols = Grid1.Cols - 1;
                    var bdq = bdManager.IsOrNotBdq(rowNum, colNum);
                    if (bdq != null && bdq.BdType == "1") {
                        Grid1.Range(rowNum, 1, rowNum, cols).BackColor = toolManager.CovertColorStr("#FFFFFF");
                        //取消变动区数据
                        for (var i = 1; i < Grid1.Cols; i++) {
                            GridManager.SetGridTag(rowNum, i, null, {});
                        }
                        //状态更新
                        currentState.bdNum--;
                        currentState.bdRowNum--;
                    }

                } catch (err) {
                    alert(err.Message);
                }
            },
            SetChangeCol: function (para, bdq) {
                //设置变动列
                if (!para) return;
                var temp = Grid1.Selection;
                var colNum = temp.FirstCol;
                var rows = Grid1.Rows - 1;
                if (!bdq["Offset"] || bdq["Offset"] == null) {
                    Grid1.Range(1, colNum, rows, colNum).BackColor = toolManager.CovertColorStr("#FF99CC");
                    bdq = bdManager.CreateBdq("2", para);
                } else {
                    Grid1.Range(1, colNum, rows, colNum).BackColor = toolManager.CovertColorStr("#FF99CC");
                    bdq = bdManager.EditBdq(bdq, para);
                }
                //设置单元格状态
                for (var i = 0; i < Grid1.Rows; i++) {
                    GridManager.SetGridTag(i, colNum, null, bdq);
                }
            },
            CancelChangeCol: function () {
                try {
                    var temp = Grid1.Selection;
                    var rowNum = temp.FirstRow;
                    var colNum = temp.FirstCol;
                    var bdq = bdManager.IsOrNotBdq(rowNum, colNum);
                    if (bdq != null && bdq["BdType"] == "2") {
                        var rows = Grid1.Rows - 1;
                        Grid1.Range(1, colNum, rows, colNum).BackColor = toolManager.CovertColorStr("#FFFFFF");
                        //取消变动列数据
                        for (var i = 0; i < Grid1.Rows; i++) {
                            GridManager.SetGridTag(i, colNum, null, {});
                        }
                        //状态设置
                        currentState.bdNum--;
                        currentState.bdColNum--;
                    }
                } catch (err) {
                    alert(err.Message);
                }
            },
            ApplicationCellData: function (row, col, cellLogicalType) {
                var cellData = toolManager.TagTool.GetTagCellData(row, col);
                if (cellData == null) cellData = {};
                if (cellLogicalType == "02") {
                    //设置单元格行列内码
                    var cellCode = cellData[cellNameValue.CellCode];
                    var oldCellCode = "";
                    if (!cellCode || cellControls.CellCodeRefresh.getValue()) {
                        if (($("#autoCreateCode").attr("checked") || $("#autoNumCode").attr("checked"))) {
                            cellCode = toolManager.CreateCellCode(row, col);
                            oldCellCode = toolManager.TagTool.GetDataValue(cellData, cellNameValue.CellCode);
                            toolManager.TagTool.SetDataValue(cellData, cellNameValue.CellCode, cellCode);
                        }
                    }
                    //设置单元格名称         
                    var cellName = $("input[name='CellName']").val();
                    if (cellName != "") {
                        toolManager.TagTool.SetDataValue(cellData, cellNameValue.CellName, cellName);
                    } else {
                        toolManager.TagTool.SetDataValue(cellData, cellNameValue.CellName, toolManager.AutoCreateCellName(row, col));
                    }


                    //设置单元格数据类型  
                    var cellDataType = cellControls.CellDataType.getValue();
                    var oldCellDataType = toolManager.TagTool.GetDataValue(cellData, cellNameValue.CellDataType);
                    toolManager.TagTool.SetDataValue(cellData, cellNameValue.CellDataType, cellDataType);
                    if (!(cellCode == oldCellCode && cellDataType == oldCellDataType)) {
                        Grid1.Cell(row, col).Text = toolManager.TagTool.CreateCellCode(cellCode, cellDataType);
                    }
                    //设置单元格的数据单元格逻辑类型
                    toolManager.TagTool.SetDataValue(cellData, cellNameValue.CellLogicalType, cellLogicalType);
                    //设置单元格类型,下拉框
                    var cellType = cellControls.CellType.getValue();
                    toolManager.TagTool.SetDataValue(cellData, cellNameValue.CellType, cellType);
                    if (cellDataType == "02") {
                        //设置小数位数
                        var digitNumber = cellControls.DigitNumber.getValue();
                        toolManager.TagTool.SetDataValue(cellData, cellNameValue.DigitNumber, digitNumber);
                        //设置货币单位
                        var currence = cellControls.CellCurrence.getValue();
                        toolManager.TagTool.SetDataValue(cellData, cellNameValue.CellCurrence, currence);
                        //设置货币符号
                        var symbol = cellControls.CellSmbol.getValue();
                        toolManager.TagTool.SetDataValue(cellData, cellNameValue.CellSmbol, symbol);
                        //是否千分位
                        var thousand = cellControls.CellThousand.getValue();
                        toolManager.TagTool.SetDataValue(cellData, cellNameValue.CellThousand, thousand);
                        //是否汇总
                        var cellAggregation = cellControls.CellAggregation.getValue();
                        toolManager.TagTool.SetDataValue(cellData, cellNameValue.CellAggregation, cellAggregation);
                        //汇总方式
                        var aggregationType = cellControls.CellAggregationType.getValue();
                        toolManager.TagTool.SetDataValue(cellData, cellNameValue.CellAggregationType, aggregationType);
                    } else {
                        //设置单元格数据类型长度
                        var cellLength = $("input[name='CellLength']").val();
                        toolManager.TagTool.SetDataValue(cellData, cellNameValue.CellLength, cellLength);
                    }
                    //设置单元格锁
                    var lock = cellControls.CellLock.getValue();
                    toolManager.TagTool.SetDataValue(cellData, cellNameValue.CellLock, lock);
                    //是否主键
                    var primary = cellControls.CellPrimary.getValue();
                    toolManager.TagTool.SetDataValue(cellData, cellNameValue.CellPrimary, primary);
                    //宏函数
                    var cellMacro = cellControls.CellMacro.getText();
                    toolManager.TagTool.SetDataValue(cellData, cellNameValue.CellMacro, cellMacro);
                    //帮助
                    var cellHelp = cellControls.CellHelp.getText();
                    toolManager.TagTool.SetDataValue(cellData, cellNameValue.CellHelp, cellHelp);
                    //数值
                   // var cellValue = cellControls.c

                } else if (cellLogicalType == "null" || cellLogicalType == "") {
                    //删除对应数据
                    var cellLogicalType = toolManager.TagTool.GetDataValue(cellData, cellNameValue.CellLogicalType);
                    if (cellLogicalType == "02") {
                        Grid1.Cell(row, col).Text = "";
                    }
                    cellData = {};
                } else if (cellLogicalType == "01") {
                    //设置数据项类型                   
                    cellData = {};
                    toolManager.TagTool.SetDataValue(cellData, cellNameValue.CellLogicalType, cellLogicalType);
                }
                GridManager.SetGridTag(row, col, cellData);
            },
            SetCellText: function (row, col, value) {
                Grid1.Cell(row, col).Text = value;
            },
            SetBlankItemType: function (row, col) {
                var cell = toolManager.GetCellData(row, col);
                if (toolManager.IsNullOrEmpty(cell, cellNameValue.CellLogicalType)) {
                    if (cell.CellLogicalType == "02") {
                        GridManager.SetCellText(row, col, "");
                    }
                }
            }

        };
        var bdManager = {
            EditBdq: function (bdq, bdPara) {
                bdq.SortRow = bdPara.SortField;
                bdq.DataCode = bdPara.DataCode;
                bdq.DataName = bdPara.DataName;
                bdq.isOrNotMerge = bdPara.Merge;
                return bdq;
            },
            CreateBdq: function (type, bdPara) {
                currentState.bdNum = currentState.bdNum + 1.0;
                //最大编号+1
                currentState.MaxBdNm += 1.0;
                //变动区类型
                if (type == "1") {
                    currentState.bdRowNum = currentState.bdRowNum + 1.0;
                } else {
                    currentState.bdColNum = currentState.bdColNum + 1.0;
                }
                //增加变动区描述
                var bdq = { Code: "", BdType: "", Offset: -1, SortRow: 2, DataCode: 2, DataName: 3, isOrNotMerge: false };
                bdq.Code = toolManager.CreateBdqCode(currentState.MaxBdNm);
                bdq.BdType = type;
                bdq.SortRow = bdPara.SortField;
                bdq.DataCode = bdPara.DataCode;
                bdq.DataName = bdPara.DataName;
                bdq.isOrNotMerge = bdPara.Merge;
                return bdq;
            },
            IsOrNotBdq: function (Row, Col) {
                try {
                    var bdq = toolManager.TagTool.GetTagBdqData(Row, Col);
                    if (bdq["Code"]) {
                        return bdq;
                    } else {
                        return null;
                    }
                } catch (err) {
                    alert(err.Message);
                }
            },
            ChangeType: function (row, col) {
                var type = "-1";
                $.each(BBData.bdq.Bdqs, function (index, item) {
                    if (item == null) return;
                    if (item.BdType == "1" && item.Offset == row) {
                        //变动行
                        type = "R";
                    } else if (item.BdType == "2" && item.Offset == col) {
                        type = "C";
                    }
                }
                );
                return type;
            },
            GetBdq: function (Offset, type) {
                var result = null;
                //查找已有的变动行或者变动列
                if (type == "1") {
                    //获取变动行数据信息
                    result = toolManager.TagTool.GetTagBdqData(Offset, 1);
                } else if (type == "2") {
                    //获取变动列数据信息
                    result = toolManager.TagTool.GetTagBdqData(1, Offset);
                }
                return result;
            },
            RemoveRepeatBdq: function () {
                //去掉重复的变动区数据
                var tempBdqs = {};
                var tempBdArr = [];
                $.each(BBData.bdq.Bdqs, function (index, item) {
                    if (item == undefined || item == null) return;
                    var key = item.BdType + item.Offset;
                    if (!tempBdqs[key]) {
                        tempBdqs[key] = item.Code;
                    }
                });
                //去掉重复数据
                $.each(BBData.bdq.BdqMaps, function (key, value) {
                    var flag = false;
                    var type;
                    $.each(tempBdqs, function (k, v) {
                        if (v == key) {
                            flag = true;
                        }
                    });
                    if (!flag) {
                        type = BBData.bdq.Bdqs[value].BdType;
                        delete BBData.bdq.Bdqs[value];
                        delete BBData.bdq.BdqMaps[key];
                        BBData.bdq.bdNum--;
                        if (type == "1") {
                            BBData.bdq.BdRowNum--;
                        } else if (type == "2") {
                            BBData.bdq.BdColNum--;
                        }

                    } else {
                        tempBdArr.push(BBData.bdq.Bdqs[value]);
                    }
                });
                BBData.bdq.Bdqs = tempBdArr;
            }
        };

        var toolManager = {
            CompareObjects: function (obj1, obj2) {
                //判断两个对象是否相等
                if (obj1 == null && obj2 != null) return false;
                if (obj1 != null && obj2 == null) return false;
                $.each(obj1, function (key, item) {
                    if (obj2 && obj2[key] != item) {
                        return false;
                    }
                });
                return true;
            },
            TagTool: {
                GetTagCellData: function (row, col) {

                    //获取报表数据项信息
                    var tag = GridManager.GetGridTag(row, col);
                    if (!tag[cellTag.cellData]) {
                        return null;
                    }
                    return tag[cellTag.cellData];
                },
                GetTagBdqData: function (row, col) {
                    //获取变动区数据
                    var tag = GridManager.GetGridTag(row, col);
                    if (!tag[cellTag.bdqData]) {
                        tag[cellTag.bdqData] = {};
                    }
                    return tag[cellTag.bdqData];
                },
                SetDataValue: function (data, name, value) {
                    //设置数据项信息
                    if (data[name] != value) {
                        data[name] = value;
                        data[cellNameValue.isOrUpdate] = "1";
                    }
                },
                GetDataValue: function (data, name) {
                    //获取数据项信息
                    if (data[name]) {
                        return data[name];
                    } else {
                        return null;
                    }
                },
                GetCellDataValue: function (cellData, name, value) {
                    //获取数据项的具体信息
                    if (cellData[name]) { return cellData[name]; }
                    else {
                        return null;
                    }
                },
                GetBdqDataValue: function (bdqData, name, value) {
                    //获取变动区数据项的具体信息
                    if (bdqData[name]) {
                        return bdqData[name];
                    } else {
                        return null;
                    }
                },
                CreateCellCode: function (cellCode, cellType) {
                    //生成数据项内码信息
                    return "[" + cellCode + "," + cellType + "]";
                }
            },
            VerifyReportCode: function () {
                try {
                    for (var i = 0; i < Grid1.Rows; i++) {
                        for (var j = 0; j < Grid1.Cols; j++) {
                            var cellData = toolManager.TagTool.GetTagCellData(i, j);
                            var text = Grid1.Cell(i, j).Text;
                            if (text.indexOf("[") != -1) {
                                if (!cellData || !cellData[cellNameValue.CellLogicalType]) {
                                    Grid1.Cell(i, j).Text = "";
                                }
                            }

                        }
                    }
                } catch (err) {
                    alert(err.Message);
                }
            },
            SetCellData: function (bbData, row, col, cellData) {
                //设置变动行列数据
                if (bbData.bbData[row] == undefined || bbData.bbData[row] == null) {
                    bbData.bbData[row] = {};
                }
                if (bbData.bbData[row][col] == undefined || bbData.bbData[row][col] == null) {
                    bbData.bbData[row][col] = {};
                }
                bbData.bbData[row][col] = cellData;
            },
            GetCellData: function (row, col) {
                return toolManager.TagTool.GetTagCellData(row, col);
            },
            GetOldCellData: function (row, col) {
                if (BBData.bbData[row] && BBData.bbData[row][col]) {
                    return BBData.bbData[row][col];
                } else {
                    return null;
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
            CreateRowColCode: function (row, col, cellCode) {
                var type = cellControls.CellDataType.getValue();
                var code = "[" + cellCode + "," + type + "]";
                return code;
            },
            DeleteRowColData: function (row, col) {
                if (BBData.bbData && BBData.bbData[row] && BBData.bbData[row][col]) {
                    delete BBData.bbData[row][col];
                }

            },
            CreateCellCode: function (row, col) {
                var code = "";
                if ($("#autoNumCode").attr("checked")) {
                    if (!BBData.MaxNum) BBData["MaxNum"] = "0";
                    BBData.MaxNum = parseInt(BBData.MaxNum) + 1;
                    var temp = (BBData.MaxNum).toString();
                    for (var i = temp.length; i < 8; i++) {
                        temp = "0" + temp;
                    }
                    code = temp;
                } else if ($("#autoCreateCode").attr("checked")) {
                    code = toolManager.CreateBdqCode(row) + toolManager.CreateBdqCode(col);
                }

                return code;
            },
            GetZqName: function (zqStr) {
                var zqarr = zqStr.split(":");
                return zqarr[1];
            },
            AutoCreateCellName: function (row, col) {
                var rowName = "";
                var colFlag = -1;
                var tColMc = {};
                for (var i = col - 1; i > 0; i--) {
                    if (colFlag == 2) break;
                    var cellData = toolManager.GetCellData(row, i);
                    var cell = Grid1.Cell(row, i);
                    if (cellData && cellData.CellLogicalType == "01") {
                        if (cell.MergeCell) {
                            for (var k = 0; k < BBData.MergeCells.length; k++) {
                                var mc = BBData.MergeCells[k];
                                if ((mc.row1 <= row && mc.row2 >= row) && (mc.col1 <= i && mc.col2 >= i)) {
                                    if (mc != tColMc) {
                                        rowName = "_" + Grid1.Cell(mc.row1, mc.col1).Text + rowName;
                                        tColMc = rowName;
                                        break;
                                    }

                                }
                            }
                        } else {
                            if (cell.Text.replace(/(^\s*)|(\s*$)/g, "")) {
                                rowName = "_" + cell.Text.replace(/(^\s*)|(\s*$)/g, "") + rowName;
                            }
                        }
                    }
                    if (cellData && cellData.cellLogicalType == "02" && colFlag == 1) {
                        colFlag = 2;
                    }
                }


                var colName = "";
                var rowFlag = -1;
                var tRowMc = {};
                for (var i = row - 1; i > 0; i--) {
                    if (rowFlag == 2) break;
                    var cellData = toolManager.GetCellData(i, col);
                    var cell = Grid1.Cell(i, col);
                    if (cellData && cellData.CellLogicalType == "01") {
                        rowFlag = 1;
                        if (cell.MergeCell) {
                            for (var k = 0; k < BBData.MergeCells.length; k++) {
                                var mc = BBData.MergeCells[k];
                                if ((mc.row1 <= i && mc.row2 >= i) && (mc.col1 <= col && mc.col2 >= col)) {
                                    if (mc != tRowMc) {
                                        colName = "_" + Grid1.Cell(mc.row1, mc.col1).Text + colName;
                                        tRowMc = mc;
                                        break;
                                    }


                                }
                            }
                        } else {
                            if (cell.Text.replace(/(^\s*)|(\s*$)/g, "")) {
                                colName = "_" + cell.Text.replace(/(^\s*)|(\s*$)/g, "") + colName;
                            }
                        }
                    }

                    if (cellData && cellData.cellLogicalType == "02" && rowFlag == 1) {
                        rowFlag = 2;
                    }

                }

                if (colName == undefined || colName == null) {
                    colName = "";
                }
                if (rowName == undefined || rowName == null) {
                    rowName = "";
                }
                if (rowName == "" && colName.length > 1) {
                    colName = colName.substring(1);
                }
                if (rowName.length > 1 && colName == "") {
                    rowName = rowName.substring(1);
                }
                if (rowName.substr(0, 1) == "_") {
                    rowName = rowName.substring(1);
                }
                return rowName + colName;

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
                    // Grid1.NewFile();
                    Grid1.AutoRedraw = false;
                    Grid1.LoadFromXMLString(Base64.fromBase64(data.obj.formatStr));
                    Grid1.DisplayRowIndex = true;
                    Grid1.FixedRowColStyle = 0;
                    Grid1.AutoRedraw = true;
                    Grid1.Refresh();
                    if (Grid1.attachEvent) {
                        Grid1.attachEvent("RowColChange", GridManager.RowColChange_Event);
                    }


                    BBData = JSON2.parse(data.obj.itemStr);
                    currentState.MaxBdNm = BBData.MaxBdNm;
                    //设置单元格信息
                    if (cellFlag.compatible) {
                        //加载单元格数据信息
                        var maxSNum = 0; //记录最大数值内码
                        $.each(BBData.bbData, function (rowIndex, row) {
                            $.each(row, function (colIndex, cell) {
                                cell[cellNameValue.isOrUpdate] = "0";
                                //小数位数默认
                                if (cell[cellNameValue.DigitNumber] == undefined && cell[cellNameValue.CellDataType] == "02") {
                                    cell[cellNameValue.DigitNumber] = "2";
                                }
                                if (cell[cellNameValue.CellDataType] == "01") {
                                    cell[cellNameValue.DigitNumber] = "";
                                }
                                //调整数值内码
                                if (cell[cellNameValue.CellCode]) {
                                    var front4 = cell[cellNameValue.CellCode].substring(0, 4);
                                    if (front4 == "0000") {
                                        var numb = parseInt(cell[cellNameValue.CellCode]);
                                        if (numb > maxSNum) {
                                            maxSNum = numb;
                                        }
                                    }
                                }
                                GridManager.SetGridTag(rowIndex, colIndex, cell);
                            });
                        });
                        // 记录最大数值编号
                        BBData.MaxNum = maxSNum;
                        //记录最大变动区编号 tempMaxNum
                        currentState.MaxBdNm = 0;
                        //设置变动行或者变动列信息
                        $.each(BBData.bdq.Bdqs, function (index, bdqData) {
                            var tempMaxNum = parseInt(bdqData.Code);
                            if (tempMaxNum > currentState.MaxBdNm) {
                                currentState.MaxBdNm = tempMaxNum;
                            }
                            if (bdqData["BdType"] == "1") {
                                for (var i = 0; i < Grid1.Cols; i++) {
                                    GridManager.SetGridTag(bdqData["Offset"], i, null, bdqData);
                                }
                            } else if (bdqData["BdType"] == "2") {
                                for (var i = 0; i < Grid1.Rows; i++) {
                                    GridManager.SetGridTag(i, bdqData["Offset"], null, bdqData);
                                }
                            }
                        });

                    }

                    BBData.Id = data.obj.Id;

                    $('input[name="bbCode"]').val(BBData.bbCode);
                    $('input[name="bbName"]').val(BBData.bbName);
                    $('input[name="bbRows"]').val(BBData.bbRows);
                    $('input[name="bbCols"]').val(BBData.bbCols);

                    $('input[name="zq"]').val(toolManager.GetZqName(BBData.zq));
                    $('#autoCreateCode').attr("checked", "checked");
                    $('#autoNumCode').attr("checked", "");
                    //bdNum: 0, BdRowNum: 0, BdColNum: 0,
                    currentState.bdNum = BBData.bdq.bdNum;
                    currentState.bdRowNum = BBData.bdq.BdRowNum;
                    currentState.bdColNum = BBData.bdq.BdColNum;
                    //整理变动区重复数据
                    toolManager.VerifyReportCode();

                    //列序号
                    for (var i = 1; i < Grid1.Cols; i++) {
                        Grid1.Cell(0, i).Text = i;
                    }
                } else {
                    alert(data.sMeg);
                }
            }
        }
       
    </script>

    <style type="text/css">
     .c4,.c4:hover{
	color: #333;
	border-color: #52d689;
	background: #b8eecf;
	background: -webkit-linear-gradient(top,#b8eecf 0,#a4e9c1 100%);
	background: -moz-linear-gradient(top,#b8eecf 0,#a4e9c1 100%);
	background: -o-linear-gradient(top,#b8eecf 0,#a4e9c1 100%);
	background: linear-gradient(to bottom,#b8eecf 0,#a4e9c1 100%);
	filter: progid:DXImageTransform.Microsoft.gradient(startColorstr=#b8eecf,endColorstr=#a4e9c1,GradientType=0);
}
a.c4:hover{
	background: #a4e9c1;
	filter: none;
}
.c3,.c3:hover{
	color: #333;
	border-color: #ff8080;
	background: #ffb3b3;
	background: -webkit-linear-gradient(top,#ffb3b3 0,#ff9999 100%);
	background: -moz-linear-gradient(top,#ffb3b3 0,#ff9999 100%);
	background: -o-linear-gradient(top,#ffb3b3 0,#ff9999 100%);
	background: linear-gradient(to bottom,#ffb3b3 0,#ff9999 100%);
	filter: progid:DXImageTransform.Microsoft.gradient(startColorstr=#ffb3b3,endColorstr=#ff9999,GradientType=0);
}
a.c3:hover{
	background: #ff9999;
	filter: none;
}
    </style>
</head>
<body style="overflow:hidden">
<div id="FileToolBar"  ></div>
<div id="MiddleToolBar"  ></div>
 
	<div id="layout1">
		<div position="center" style="z-index:-1">
			   <OBJECT CLASSID = "clsid:5220cb21-c88d-11cf-b347-00aa00a28331" VIEWASTEXT>
         <PARAM NAME="LPKPath" VALUE="../lpk/flexCell.LPK">
      </OBJECT> 

      <OBJECT  ID="Grid1" Width=100% Height=96%    CLASSID="clsid:4331220A-1077-4630-BEE3-0D7142D6ABD0" onkeydown="Grid_KeyDown()">
         <PARAM NAME="_ExtentX" VALUE="0">
         <PARAM NAME="_ExtentY" VALUE="0">       
      </OBJECT>

		</div>
		<div position="right" title="表格设置">
		<div id="navtab1"
			style="width: 100%;  height:100%; overflow: hidden; border: 1px solid #A3C0E8;">
            <div tabid="property" title="表格属性" lselected="true" style="height: 100%">
            	<div id="CellInfo" class="l-layout-header">属性设置</div>
                <table class="myTable" style="margin-left: 5px">
                    <tr class="myTr">
                        <td>
                            <span>字体</span>
                        </td>
                        <td>
                            <input type="text" id="FontFun" />
                        </td>
                    </tr>
                    <tr class="myTr">
                        <td>
                            <span>字号</span>
                        </td>
                        <td>
                            <input type="text" id="FontSizeFun" />
                        </td>
                    </tr>
                    <tr class="myTr">
                        <td>
                            <span>对齐方式</span>
                        </td>
                        <td>
                            <table cellspacing="2" cellpadding="2" style="width: 60px; margin-left: 2px;">
                                <tr>
                                    <td>
                                        <div class="ke-outline" id="left" title="左对齐" style="height: 16px; width: 16px;">
                                            <span class="ke-toolbar-icon ke-toolbar-icon-url ke-icon-justifyleft"></span>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="ke-outline" id="center" title="居中对齐" style="height: 16px; width: 16px;">
                                            <span class="ke-toolbar-icon ke-toolbar-icon-url ke-icon-justifycenter"></span>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="ke-outline" id="right" title="右对齐" style="height: 16px; width: 16px;">
                                            <span class="ke-toolbar-icon ke-toolbar-icon-url ke-icon-justifyright"></span>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </td>
							</tr>
                   <tr class="myTr">
								<td><span>字体样式</span></td>
								<td>
                                 <table cellspacing="2" cellpadding="2" style="width: 60px; margin-left: 2px;">
                                <tr>
                                    <td>
                                        <div class="ke-outline" id="FontBold" title="粗体" style="height: 16px; width: 16px;">
                                            <span class="ke-toolbar-icon ke-toolbar-icon-url ke-icon-bold"></span>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="ke-outline" id="FontItalic" title="斜体" style="height: 16px; width: 16px;">
                                            <span class="ke-toolbar-icon ke-toolbar-icon-url ke-icon-italic"></span>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="ke-outline" id="FontUnderline" title="下划线" style="height: 16px; width: 16px;">
                                            <span class="ke-toolbar-icon ke-toolbar-icon-url ke-icon-underline"></span>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                                </td>
							</tr>
                              <tr class="myTr">
								<td><span>颜色设置</span></td>
								<td>
                                    <table cellspacing="2" cellpadding="2" style="width: 60px; margin-left: 2px;">
                                        <tr>
                                            <td>
                                                <div class="ke-outline" id="ForeColor" title="字体颜色" style="height: 16px; width: 16px;">
                                                    <span class="ke-toolbar-icon ke-toolbar-icon-url ke-icon-forecolor"></span>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="ke-outline" id="BackColor" title="背景颜色" style="height: 16px; width: 16px;">
                                                    <span class="ke-toolbar-icon ke-toolbar-icon-url ke-icon-hilitecolor"></span>
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                
                                </td>
							</tr>
                            <tr class="myTr">
								<td><span>边框设置</span></td>
								<td>
                                  <div class="ke-outline" id="Border" title="边框" style="height: 16px; width: 16px;">
                                      <div class="ct-toolbar-border"></div>    
                                  </div>
                                </td>
							</tr>
                             <tr class="myTr">
								<td><span>缩进设置</span></td>
								<td  >
                                    <table cellspacing="2" cellpadding="2" style="width: 60px; margin-left: 2px;">
                                        <tr>
                                            <td>
                                                <div class="ke-outline" id="LeftTor" title="左缩进" style="height: 16px; width: 16px;">
                                                    <div class="ct-leftTor-Icon">
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="ke-outline" id="RightTor" title="右缩进" style="height: 16px; width: 16px;">
                                                    <div class="ct-rightTor-Icon">
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
							</tr>

                            <tr class="myTr">
								<td><span>?清理</span></td>
								<td>
                                  <div class="ke-outline" id="DelS" title="?清理" style="height: 16px; width: 16px;">
                                      <div class="ct-delS-Icon"></div>    
                                  </div>
                                </td>
							</tr>
                            <tr class="myTr"><td>行高(像素)</td><td>
                                <div style="float:left;width:60px"><input id="cellHeight"  style="display:inline" /></div>
                                <div style="float:left"><a id="changeHeight"  style="float:right"></a></div>
                            </td></tr>
                            <tr class="myTr"><td>列宽(像素)</td><td>
                                <div style="float:left;width:60px"><input id="cellWidth"  style="display:inline" /></div>
                                <div style="float:left"><a id="changeWidth"  style="float:right"></a></div>
                            </td></tr>

                             <tr class="myTr"><td>是否折行&nbsp; &nbsp;</td><td>
                                <input type="checkbox" id="wrapText" />
                            </td></tr>
						</table>
                        <div id="Div2" class="l-layout-header">报表基本信息</div>
						<table class="myTable" style="margin: 5px">
							<tr class="myTr">
								<td><span>报表编号</span></td>
								<td><input type="text" name="bbCode" class="myTxtInput" disabled="disabled"></td>
							</tr>
							<tr class="myTr">
								<td><span>报表名称</span></td>
								<td><input type="text" name="bbName" class="myTxtInput" ></td>
							</tr>

                            	<tr class="myTr">
								<td><span>报表行数</span></td>
								<td><input type="text" name="bbRows" class="myTxtInput" disabled="disabled"></td>
							</tr>

                            	<tr class="myTr">
								<td><span>报表列数</span></td>
								<td><input type="text" name="bbCols" class="myTxtInput" disabled="disabled"></td>
							</tr>
                                <tr class="myTr">
								<td><span>报表周期</span></td>
								<td><input type="text" name="zq" class="myTxtInput" disabled="disabled"></td>
							</tr>
                            <tr class="myTr">
                            <td><span>变动区号</span></td>
                            <td><input type="text" name="bdqSpan" class="myTxtInput"id="bdqSpan" disabled="disabled"></td>
                            </tr>
                            <tr>
                            <td><span id="testSpan"></span></td>
                            </tr>
						</table>
					</div>
           
			<div tabid="home" title="格式信息"  style="height: 100%">
					<div id="Div1" style="margin: 0px; height: 100%;">
					<div id="bbInfoHeader" class="l-layout-header">单元格逻辑属性</div>
						<table class="myTable" style="margin-left: 5px">
							<tr class="myTr">
								<td><span>单元格类型</span></td>
								<td><input type="text" name="CellLogicalType" ></td>
							</tr>
                           </table>
                            
                           	<div id="Div3" class="l-layout-header">单元格逻辑属性</div>
                           <table class="myTable" style="margin-left: 5px">
							<tr class="myTr">
								<td><span>数据项编号</span></td>
								<td><input type="text" name="CellCode" class="myTxtInput"style=" width:130px"></td>
							</tr>
                            <tr class="myTr">
								<td><span>数据项名称</span></td>
								<td><input type="text" name="CellName" class="myTxtInput"style=" width:130px"></td>
							</tr>
                             
                            <tr class="myTr">
								<td><span>数据类型</span></td>
								<td><input type="text" name="CellDataType" ></td>
							</tr>
                            <tr><td colspan="2">
                            <table id="charTable">
                             <tr class="myTr">
								<td><span>数据长度&nbsp   &nbsp</span></td>
								<td><input type="text" name="CellLength" class="myTxtInput" style=" width:130px"></td>
							</tr>
                            </table>
                            <table id="valueTable" >
                            <tr class="myTr">
								<td><span>保留小数</span></td>
								<td><input type="text" name="DigitNumber" ></td>
							</tr>
                            <tr class="myTr">
								<td><span>金额符号</span></td>
								<td><input type="text" name="CellSmbol" ></td>
							</tr>
                            <tr class="myTr">
								<td><span>货币符号</span></td>
								<td><input type="text" name="CellCurrence" ></td>
							</tr>
                            <tr class="myTr">
								<td><span>是否千分位</span></td>
								<td><input type="text" name="CellThousand" ></td>
							</tr>
                             
                              <tr class="myTr" style=" display:none">
								<td><span>是否零值</span></td>
								<td><input type="text" name="CellZero" ></td>
							</tr>                            
                              <tr class="myTr"  >
								<td><span>是否汇总</span></td>
								<td><input type="text" name="CellAggregation" ></td>
							</tr>
                              <tr class="myTr" >
								<td><span>汇总方式</span></td>
								<td><input type="text" name="CellAggregationType" ></td>
							</tr>
                            </table>
                            </td></tr>
                             <tr class="myTr">
								<td><span>是否锁定</span></td>
								<td><input type="text" name="CellLock" ></td>
							</tr>
                             <tr class="myTr" >
								<td><span>是否主键</span></td>
								<td><input type="text" name="CellPrimary" ></td>
							</tr>
                            <tr>
                               <td colspan="2"><table><tr>
                                <td>行列内码&nbsp; &nbsp;</td><td><input type="checkbox"checked="checked" id="autoCreateCode"/></td>
                                <td>&nbsp; &nbsp;数值内码&nbsp; &nbsp;</td><td><input type="checkbox"  id="autoNumCode"/></td></tr>
                            </table></td>
                            </tr> 
                                                   
						</table>
                       <div  style="  margin-top:10px; width:100%; text-align:center;">
                    
                       <a href="#" class="easyui-linkbutton l-btn l-btn-small easyui-fluid c4" iconcls="icon-ok" style=" height: 30px; width:170px;" group="" id="okBtn1" ><span class="l-btn-left l-btn-icon-left" style="margin-top: 3px;" ><span class="l-btn-text">应用</span><span class="l-btn-icon icon-ok">&nbsp;</span></span></a>
                       </div>
                       </div>
					
				
			</div>
			<div title="帮助信息" id="dataItem">
				<div id="maingrid2" style="margin: 0px; height: 100%;">
				
				<div id="bbInfoHeader" class="l-layout-header">帮助信息</div>
						<table class="myTable">
							<tr class="myTr">
								<td><span>单元格样式</span></td>
								<td><input type="text" name="CellType" id="cellDataFormatType" ></td>
							</tr>
							<tr class="myTr">
								<td><span>宏函数</span></td>
								<td><input type="text" name="CellMacro"  id="cellMacro" ></td>
							</tr>
							<tr class="myTr">
								<td><span>帮助</span></td>
								<td><input type="text" name="CellHelp" id="cellHelp"  /></td>
							</tr>
						</table>

                         <div  style="  margin-top:10px; width:100%; text-align:center;">
                       <a href="#" class="easyui-linkbutton l-btn l-btn-small easyui-fluid c4" iconcls="icon-ok" style=" height: 30px; width:180px; margin-left:21px" group="" id="okBtn2" onclick="cellManager.ApplicationOk_Click"><span class="l-btn-left l-btn-icon-left" style="margin-top: 3px;"><span class="l-btn-text" >应用</span><span class="l-btn-icon icon-ok">&nbsp;</span></span></a>
                       </div>
                <%--<div id="InfoHeader" class="l-layout-header" style="border-top: 1px solid #95B8E7; " onclick="" >变动行数据管理</div>
                    <div id="alterationRowGrid" ></div>--%>
				</div>
				</div>
			</div>
		</div>
		
	</div>
</body>
</html>
