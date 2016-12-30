<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TemplateDesign.aspx.cs" Inherits="Audit.ct.ExportReport.TemplateDesign" %> 

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 

<html xmlns="http://www.w3.org/1999/xhtml"> 
<head > 
<title>设计报告</title> 
    <script src="../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script> 
    <link href="../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" /> 
    <link href="../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" /> 
    <script src="../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script> 
    <script src="../../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script> 
    <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script> 
    <script src="../../Scripts/AjaxTrigger.js" type="text/javascript"></script> 
    <script src="../../lib/json2.js" type="text/javascript"></script>
<style type="text/css"> 
.content 
{ 
width:100%;
clear:both; 
margin:7px; 
height:500px; 
} 
.left 
{ 
margin:0px; 
height:100%; 
float:left; 
border: 1px solid #95B8E7; 
} 
.right 
{ 
margin:0px; 
height:100%; 
float:left;
border: 1px solid #95B8E7; 
margin-left:10px;

} 
.center 
{ 
border: 1px solid #95B8E7; 
height:100%; 
float:left; 
margin-left:10px;
}

a:hover 
{
text-decoration: none;
} 
</style> 

<script type="text/javascript">
    var urls={
        gridUrl: "../../handler/ExportReport.ashx?ActionType="+ ExportAction.ActionType.Grid +"&MethodName="+ ExportAction.Methods.DesignMethod.GetWordTemplateStruct+"&FunctionName=" +ExportAction.Functions.ReportTemplate,
        MarkTypeUrl: "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Get + "&MethodName=GetDictionaryListByClassType&FunctionName=" + BasicAction.Functions.DictionaryManager + "&ClassType=BQLX",
        DataSourceUrl: "../../handler/FormatHandler.ashx?ActionType=" + ReportFormatAction.ActionType.Grid + "&MethodName=" + ReportFormatAction.Methods.FormularMenuMethods.GetDataSourceList + "&FunctionName=" + ReportFormatAction.Functions.FormularMenu,
        FormularUrl: "../Format/NewFormular.aspx",
        functionUrl: "../../handler/ExportReport.ashx"
    }
    //Bookmark:{Id:"",Code:"",Name:"",Type:"",Content:"",TemplateId:"",DataSource:"",MacroOrFormular:"",Creater:"",CreateTime:"" ,Thousand:"" }
    var currentState = { Bookmarks: [], wordContent: "", reportTemplate: {}, EditMarkIndex: null, TemplateId: "", Initializing: false }; //Initializing:正在初始标签内容
    var InEditingMark = { Code: "", Name: "", Type: "", Content: "", TemplateId: "", DataSource: "", MacroOrFormular: "",Thousand:"" };
    var tempControl = {NewMark:{},MarkIndex:0};
    var tools = [{
           text: '保存书签设置',
           iconCls: 'icon-save',
           iconAlign:'right',
           handler: function () {
               ControlManager.SaveWordTemplateStruct();
           }
       }];
       $(function () {
           InitializeControls();
           $("#helpBtn").bind("click", function () { });
           currentState.BookmarkList = $("#BookmarkList").datagrid({
               fit: true,
               title: "标签列表",
               sortOrder: 'desc',
               //tools: tools,
               sortName: 'CreateTime',
               nowrap: true,
               border: false,
               pagination: false,
               rownumbers: false,
               fitColumns: true,
               frozenColumns: true,
               singleSelect: true,
               columns: [[
               //{ field: 'Id', checkbox: true },
			   {field: 'Code', title: '编号', width: 120, sortable: true },
               { field: 'Name', title: '名称', width: 160, sortable: true }
            ]],
               onSelect: function (rowIndex, rowData) {
                   ControlManager.MarkManager.EditMark(rowIndex, rowData);
               }
           });
           currentState.TemplateId = $("#Id").val();
           currentState.reportTemplate.Id = currentState.TemplateId;
           var parameters = CreateParameter(ExportAction.ActionType.Grid, ExportAction.Functions.ReportTemplate, ExportAction.Methods.DesignMethod.GetWordTemplateStruct, currentState.reportTemplate);
           var url = DataManager.sendData(urls.functionUrl, parameters, resultManager.successLoadTemplateData, resultManager.fail);
       });
    //方法调度
       var ControlManager = {
           MarkManager: {
               EditMark: function (index, mark) {
                   currentState.Initializing = true;
                   if (currentState.EditMarkIndex || currentState.EditMarkIndex == 0) {
                       ControlManager.ViewManager.clertALabelColor(currentState.EditMarkIndex); //   清除颜色锁定
                       var markContent = $("#MarkContent").text();
                       if (InEditingMark.IsUpdate || markContent != currentState.Bookmarks[currentState.EditMarkIndex].Content) {
                           $.extend(true, tempControl.NewMark, InEditingMark);
                           tempControl.NewMark.Content = markContent;
                           tempControl.MarkIndex = currentState.EditMarkIndex;
                           $.messager.confirm("系统提示", "是否保存更改？", function (r) {
                               if (r) {
                                   ControlManager.MarkManager.SaveMark(tempControl.NewMark);
                               }
                           });
                       }
                   }
                   currentState.EditMarkIndex = index;
                   InEditingMark = {};
                   $.extend(true, InEditingMark, mark);
                   $("#MarkType").combobox("select", InEditingMark.Type);
                   $("#Thousand").combobox("setValue", InEditingMark.Thousand);
                   $("#MarkContent").text(InEditingMark.Content);
                   $("#DataSourceName").combobox("setValue", InEditingMark.DataSource);
                   ControlManager.ViewManager.ClickJump(index);
                   currentState.Initializing = false;
               },
               SelectType: function (node) {
                   var row = currentState.BookmarkList.datagrid("getSelected");
                   if (!node) {
                       $("#MarkContent").text("");
                       $("#DataSourceName").combobox("setValue", "");
                       return;
                   }
                   if (row) {
                       if (!currentState.Initializing) {
                           InEditingMark.Type = node.Code;
                           InEditingMark.IsUpdate = true;
                       }
                   }
                   if (node.Code == "01") {
                       $("#BtnTable").css("display", 'block');
                       $("#MacroFunctionBtn").css("display", "block");
                   } else if (node.Code == "02") {
                       $("#BtnTable").css("display", 'block');
                       $("#MacroFunctionBtn").css("display", "none");
                   } else if (node.Code == "03") {
                       $("#BtnTable").css("display", 'none');
                   }
               },
               IsOrNotThousand: function (node) {
                   var row = currentState.BookmarkList.datagrid("getSelected");
                   if (!node) {
                       $("#Thousand").combobox("setValue", "");
                       return;
                   }
                   if (row && !currentState.Initializing) {
                       InEditingMark.Thousand = node.Code;
                       InEditingMark.IsUpdate = true;
                   }
               },
               //新建公式
               AddFormula: function () {
                   var content = $("#MarkContent").val();
                   var DataSource = $("#DataSourceName").combobox("getValue");
                   if (currentState.EditMarkIndex || currentState.EditMarkIndex == 0) {
                   } else {
                       alert("应先选择要编辑的标签");
                       return;
                   }
                   var paras = {};
                   var result = window.showModalDialog(urls.FormularUrl, { content: content, DataSource: DataSource }, "DialogHeight:600px;DialogWidth:800px;scroll:no");
                   if (result) {
                       if (currentState.EditMarkIndex || currentState.EditMarkIndex == 0) {
                           InEditingMark.DataSource = result.DataSource;
                           InEditingMark.Content = result.content;
                           InEditingMark.MacroOrFormular = "F";
                           InEditingMark.IsUpdate = true;
                       }
                       $("#MarkContent").text(result.content);
                       $("#DataSourceName").combobox("setValue", result.DataSource);
                   }
               },
               //新建 宏函数
               AddMacroFunction: function () {
                   var paras = { url: "", columns: [], sortName: "", sortOrder: "", NameField: "Name", CodeField: "Code" };
                   paras.url = "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Grid + "&MethodName=" + BasicAction.Methods.DicManagerMethods.GetDictionaryListByClass + "&FunctionName=" + BasicAction.Functions.DictionaryManager + "&classId=HHS";
                   paras.columns = [[{ field: "Code", title: "编号", width: 110 },
{ field: "Name", title: "名称", width: 120 }
]];
                   paras.sortName = "Code";
                   paras.sortOrder = "ASC";
                   var result = window.showModalDialog("../pub/HelpDialog.aspx", paras, "dialogHeight:400px;dialogWidth:325px");
                   if (result && result.Code) {
                       if (currentState.EditMarkIndex || currentState.EditMarkIndex == 0) {
                           InEditingMark.Content = "<!" + result.Code + "!>";
                           InEditingMark.MacroOrFormular = "M";
                           InEditingMark.IsUpdate = true;
                       }
                       $("#MarkContent").text("<!" + result.Code + "!>");
                   }
               },
               //引入模板
               UseHistoryMark: function () {
                   var paras = { url: "", columns: [], sortName: "", sortOrder: "", NameField: "Name", CodeField: "Code" };
                   paras.url = "../../handler/ExportReport.ashx?ActionType=" + ExportAction.ActionType.Grid + "&MethodName=" + ExportAction.Methods.reportMarkMethod.GetBookmarkTemplateDataGrid + "&FunctionName=" + ExportAction.Functions.ReportTemplate;
                   paras.columns = [[{ field: "Code", title: "编号", width: 110 },
{ field: "Name", title: "名称", width: 120 }
                   ]];
                   paras.sortName = "Code";
                   paras.sortOrder = "ASC";
                   var result = window.showModalDialog("../pub/HelpDialog.aspx", paras, "dialogHeight:400px;dialogWidth:325px");
                   if (result && result.Code) {
                       if (currentState.EditMarkIndex || currentState.EditMarkIndex == 0) {
                           InEditingMark.DataSource = result.DataSource;
                           InEditingMark.Content = result.Content;
                           InEditingMark.Thousand = result.Thousand;
                           InEditingMark.MacroOrFormular = result.MacroOrFormular;
                           InEditingMark.Type = result.Type;
                           InEditingMark.IsUpdate = true;
                       }
                       $("#MarkContent").text(result.Content);
                       $("#MarkType").combobox("select", result.Type);
                       $("#Thousand").combobox("setValue", result.Thousand);
                       $("#DataSourceName").combobox("setValue", result.DataSource);
                   }
               },
               //保存标签 为 模板  
               SaveTemplateMark: function () {
                   if (currentState.EditMarkIndex || currentState.EditMarkIndex == 0) {
                       var mark = InEditingMark;
                       var Content = $("#MarkContent").text();
                       $("#Dialog").dialog({
                           title: "标签模板",
                           width: 300,
                           height: 220,
                           closed: false,
                           cache: false,
                           modal: true,
                           buttons: [{
                               text: '保存',
                               iconCls: "icon-ok",
                               handler: function () {
                                   var param = { Content: Content, Code: "", Name: "", TemplateId: mark.TemplateId, Type: mark.Type, MacroOrFormular: mark.MacroOrFormular, DataSource: mark.DataSource,Thousand:InEditingMark.Thousand };
                                   param.Code = $("#TMarkCode").val();
                                   param.Name = $("#TMarkName").val();
                                   param = CreateParameter(ExportAction.ActionType.Post, ExportAction.Functions.ReportTemplate, ExportAction.Methods.reportMarkMethod.SaveBookmarkTemplate, param);
                                   DataManager.sendData(urls.functionUrl, param, resultManager.seccessSaveTMark, resultManager.fail);
                               }
                           },
                        {
                            text: '取消',
                            iconCls: "icon-cancel",
                            handler: function () {
                                $("#Dialog").dialog("close");
                            }
                        }
                        ]
                       });
                       $("#TMarkName").val("");
                       $("#TMarkCode").val("");
                   } else {
                       alert("请选择要保存的书签");
                   }
               },
               //保存标签修改
               SaveMark: function (Smark) {
                   if (!Smark) {
                       if (currentState.EditMarkIndex || currentState.EditMarkIndex == 0) {
                           Content = $("#MarkContent").text();
                           InEditingMark.Content = Content;
                           Smark = InEditingMark;
                           tempControl.MarkIndex = currentState.EditMarkIndex;
                       } else {
                           alert("未选择要编辑的书签");
                           return;
                       }
                   }
                   var WordTemplate = { Bookmarks: [], wordContent: currentState.wordContent, reportTemplate: { Id: currentState.TemplateId} };
                   tempControl.NewMark = Smark;
                   if (!tempControl.NewMark.Type) {
                       alert("请选择书签类型");
                       return;
                   }
                   WordTemplate.Bookmarks.push(tempControl.NewMark);
                   var param = { para: "" };
                   param.para = JSON2.stringify(WordTemplate);
                   param = CreateParameter(ExportAction.ActionType.Post, ExportAction.Functions.ReportTemplate, ExportAction.Methods.DesignMethod.SaveWordTemplateStruct, param);
                   DataManager.sendData(urls.functionUrl, param, resultManager.successSave, resultManager.fail);
               }
           },
           ViewManager: {
               ChangeView: function (type) {
                   var list = $(window.frames["wordIframe"].document).find("input");
                   $(window.frames["wordIframe"].document.body).css("line-height", "150%");
                   for (var i = 0; i < list.length; i++) {
                       var id = i.toString();
                       if (currentState.Bookmarks[i]) {
                           $(list[i]).replaceWith("【<a href='#" + id + "' id='" + id + "' onclick='parent.ControlManager.ViewManager.ViewClickMark(this.id)' ><span id='Span" + id + "'>" + currentState.Bookmarks[i].Name + "</span></a>】");
                       }
                   }
               },
               ViewClickMark: function (index) {
                   currentState.BookmarkList.datagrid("selectRow", index);
               },
               //html内 书签跳转
               ClickJump: function (id) {
                   var HeigthIframe = window.frames["wordIframe"];
                   var a = HeigthIframe.document.getElementById(id); //指示
                   $(a).css("color", "#F75000");
                   $(a).html('<span style=" background-color:Yellow">' + a.innerText + '</span>');
                   HeigthIframe.document.frames.window.location.hash = "#" + id;
               },
               clertALabelColor: function (id) {
                   var HeigthIframe = window.frames["wordIframe"];
                   if (HeigthIframe.document.getElementById(currentState.EditMarkIndex)) {
                       var a = HeigthIframe.document.getElementById(currentState.EditMarkIndex); //指示
                       $(a).css("color", "#750075");
                       $(a).html(a.innerText);

                   }
               }
           },
           //根据下标 生成<a>标签Id [未使用]
           creatId: function (x) {
               var N = x.toString();
               for (var m = N.length; m < 4; ++m) {
                   N = "0" + N;
               }
               return N;
           }
       }
        //处理 获取数据
       var resultManager = {
           successLoadTemplateData: function (data) {
               if (data.success) {
                   currentState.Bookmarks = data.obj.Bookmarks;
                   currentState.wordContent = data.obj.wordContent;
                   currentState.BookmarkList.datagrid("loadData", currentState.Bookmarks);
                   if (data.obj.wordContent.length > 0) {
                       $("#wordIframe").attr("src", data.obj.wordContent + "?param=random(100)");
                   }
               } else {
                   MessageManager.ErrorMessage(data.sMeg);
               }
           },
           //成功保存 书签模板 rank='1'表明 书签名重复 
           seccessSaveTMark: function (data) {
               if (data.success) {
                   MessageManager.InfoMessage(data.sMeg);
                   $("#Dialog").dialog("close");
                   $("#TMarkName").val("");
                   $("#TMarkCode").val("");
               } else {
                   if (data.rank && data.rank == "1") {
                       $.messager.confirm("系统提示", data.sMeg, function (r) {
                           if (r) {
                               var param = data.obj;
                               param.IsOrNotContinue = "1";
                               param = CreateParameter(ExportAction.ActionType.Post, ExportAction.Functions.ReportTemplate, ExportAction.Methods.reportMarkMethod.SaveBookmarkTemplate, param);
                               DataManager.sendData(urls.functionUrl, param, resultManager.seccessSaveTMark, resultManager.fail);
                           }
                       });
                   } else {
                       MessageManager.ErrorMessage(data.sMeg);
                   }
               }
           },
           //成功保存书签
           successSave: function (data) {
               if (data.success) {
                   var mark = data.obj[0];
                   MessageManager.InfoMessage(data.sMeg);
                   //tempControl.NewMark.IsUpdate = false;
                   $.extend(true, currentState.Bookmarks[tempControl.MarkIndex], mark);
                   tempControl.NewMark = {};
                   if (mark.Code == InEditingMark.Code && mark.Name == InEditingMark.Name) {
                       $.extend(true, InEditingMark, mark);
                       InEditingMark.IsUpdate = false;
                   }
               } else {
                   MessageManager.ErrorMessage(data.sMeg);
               }
           },
           fail: function (data) {
               MessageManager.ErrorMessage(data.toString);
           }
       }
    //初始化界面框架
    function InitializeControls() {
        var widthSide = 200;
        $("#left").css("width", widthSide);
        $("#right").css("width", widthSide*1.65);
        var width = document.body.clientWidth;
        $("#center").css("width", width - widthSide * 2.65 - 42);

        var height = $(window).height(); //document.body.clientHeight;
        $("#content").css("height", height - 30);
    }    
    window.onresize = function () {
        if (document.body && document.body.clientHeight > 0) {
            InitializeControls();
        }
    }
</script> 
</head> 
<body style=" text-align:center; vertical-align:middle; overflow:hidden "> 
<input id="Id" value="<%=rte.Id %>" type="hidden"/>
<div id="content" class="content"> 
<div id="left" class="left">
    <table id="BookmarkList"></table>
</div> 
<div id="center" class="center" style=" overflow-y:hidden;background-color:#ede8d5">
<div style="width:610px;height:100%; margin:auto;background-color:#F9F6EC ">
<iframe id="wordIframe" frameborder="0"  height="100%" onload="ControlManager.ViewManager.ChangeView('input');" width="100%"></iframe> 
</div>
</div> 
<div id="right" class="right" style="overflow:auto">
    <table id="EditTable" style="font-size:12px;text-align :left " cellspacing="12px">
    <tr><td>内容类型</td><td><input class="easyui-combobox" id="MarkType" style="width:210px;height:29px" data-options="url:urls.MarkTypeUrl,valueField:'Code',textField:'Name',panelHeight:'auto',onSelect:ControlManager.MarkManager.SelectType"/></td></tr>
    <tr><td style="float:left;padding-top:5px">内容</td><td><textarea id="MarkContent" cols="25" rows="12"  style=" overflow:auto; padding:5px; font-size:12px ;border: 1px solid #95B8E7;"></textarea></td></tr>
    <tr><td colspan="2">
        <table id="BtnTable"  style=" display:none">
            <tr><td></td><td style=" padding-top:0px">
                <a class="easyui-linkbutton" onclick="ControlManager.MarkManager.AddFormula()" style=" float:left; width:95px;margin-left:22px;" data-options="iconCls:'icon-sum'"  plain="false"> 公 &nbsp;&nbsp;&nbsp; 式 &nbsp;</a>
                <a class="easyui-linkbutton" onclick="ControlManager.MarkManager.AddMacroFunction()" id="MacroFunctionBtn" style="display:none; float:left;margin-left:10px; width:95px;" data-options="iconCls:'icon-ok'"  plain="false">宏&nbsp;函&nbsp;数 &nbsp;</a>
            </td></tr>
            <tr style="height:40px;"><td><span id="Span1" >数据源</span></td><td style="padding-left:22px"><input class="easyui-combobox" id="DataSourceName" style="width:208px;height:29px;" data-options="url:urls.DataSourceUrl,valueField:'Id',textField:'Name',panelHeight:'auto'" readonly="readonly"/></td></tr>
        </table>
    </td></tr>
    <tr ><td>千分位</td><td ><input class="easyui-combobox" id="Thousand" style="width:210px;height:29px;" value="1" data-options="data:[{Code:'1',Name:'是'},{Code:'0',Name:'否'}],valueField:'Code',textField:'Name',panelHeight:'auto',onSelect:ControlManager.MarkManager.IsOrNotThousand"/></td></tr>
    <tr><td><span id="Span2" >标签模板</span></td><td>
        <a class="easyui-linkbutton" onclick="ControlManager.MarkManager.UseHistoryMark()"   style="width:95px;float:left" data-options="iconCls:'icon-template16'">引用模板</a>
        <a class="easyui-linkbutton" onclick="ControlManager.MarkManager.SaveTemplateMark()" style="width:95px;float:left; margin-left:10px;" data-options="iconCls:'icon-History'" >存为模板</a>
    </td></tr>
    <tr><td></td><td><a class="easyui-linkbutton" onclick="ControlManager.MarkManager.SaveMark()" style="float:left; width:210px;height:29px; padding-top:4px" data-options="iconCls:'icon-save'"><span style=" font-size:14px">&nbsp; &nbsp;保 &nbsp; &nbsp; 存</span></a></td></tr>
    </table>
</div> 
</div> 
<div id="Dialog" class="easyui-dialog" data-options="closed:true" >
<table style=" margin:auto; width:100%; padding:10px" cellspacing="15px">
    <tr><td>模板编号</td><td><input id="TMarkCode" type="text" class="easyui-validatebox textbox"  style=" height:25px"  /></td></tr>
    <tr><td>模板名称</td><td><input id="TMarkName" type="text" class="easyui-validatebox textbox"  style=" height:25px"/></td></tr>
</table>
</div>
</body> 
</html> 