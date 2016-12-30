<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddBookmarkTemplate.aspx.cs" Inherits="Audit.ct.ExportReport.AddBookmarkTemplate" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
      <script src="../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script> 
    <link href="../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" /> 
    <link href="../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" /> 
    <script src="../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script> 
    <script src="../../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script> 
    <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script> 
    <script src="../../Scripts/AjaxTrigger.js" type="text/javascript"></script> 
    <script src="../../lib/json2.js" type="text/javascript"></script>
</head>

<body style=" overflow:hidden">
<script type="text/javascript">
    var Content = "<%=bte.Content %>";
    var Type = "<%=bte.Type %>";
    var AddManager = {
        SelectType: function (node) {
            AddManager.ChangeView(node.Code);
        },
        ChangeView: function (Type) {
            if (Type == "01") {
                $("#BtnTable").css("display", 'block');
                $("#MacroFunctionBtn").css("display", "block");
            } else if (Type == "02") {
                $("#BtnTable").css("display", 'block');
                $("#MacroFunctionBtn").css("display", "none");
            } else if (Type == "03") {
                $("#BtnTable").css("display", 'none');
            }
        },
        //新建公式
        AddFormula: function () {
            var content = $("#Content").text();
            var DataSource = $("#DataSource").combobox("getValue");
            var result = window.showModalDialog(urls.FormularUrl, { content: content, DataSource: DataSource }, "DialogHeight:600px;DialogWidth:800px;scroll:no");
            if (result) {
                $("#MacroOrFormular").val("F");
                $("#Content").text(result.content);
                $("#DataSource").combobox("setValue", result.DataSource);
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
                $("#MacroOrFormular").val("M");
                $("#Content").text("<!" + result.Code + "!>");
            }
        },
        getPatameter: function () {
            var param = {};
            param.Code = $("#Code").val();
            param.Name = $("#Name").val();
            param.Content = $("#Content").text();
            param.Type = $("#Type").combobox("getValue");
            param.Thousand = $("#Thousand").combobox("getValue");
            param.DataSource = $("#DataSource").combobox("getValue");
            param.MacroOrFormular = $("#MacroOrFormular").val();
            
            var Id = $("#Id").val();
            if (Id && Id != "") {
                param.Id = Id;
            }
            if (!param.Code) {
                alert("请输入模板编号");
                return;
            }
            if (!param.Name) {
                alert("请输入模板名称");
                return;
            }
            return param;
        }
    };
    $(function () {
        $("#Content").text(Content);
        AddManager.ChangeView(Type);
    });
</script>
<input id="Id" value="<%=bte.Id %>" type="hidden"/>
<input id="MacroOrFormular" value="<%=bte.MacroOrFormular %>" type="hidden"/>
    <table id="EditTable" style="font-size:12px; margin:10px 0px 0px 30px " cellspacing="12px">
        <tr><td>模板编号</td><td><input id="Code" value="<%=bte.Code %>" type="text" class="easyui-validatebox textbox"  style="width:220px;height:27px;"  /></td></tr>
        <tr><td>模板名称</td><td><input id="Name" value="<%=bte.Name %>" type="text" class="easyui-validatebox textbox" style="width:220px;height:27px;"  /></td></tr>
        <tr><td>标签类型</td><td><input id="Type" value="<%=bte.Type %>" type="text"  class="easyui-combobox" data-options="url:urls.TypeUrl,valueField:'Code',textField:'Name',panelHeight:'auto',onSelect:AddManager.SelectType"style="width:223px;height:29px;" /></td></tr>
        <tr><td style="float:left;padding-top:5px">内容</td><td><textarea id="Content"  cols="27" rows="12"  style=" overflow:auto; padding:5px; font-size:12px ;border: 1px solid #95B8E7;"></textarea></td></tr>
        <tr><td colspan="2">
            <div id="BtnTable" style=" display:none">
                <table >
                    <tr><td></td><td>
                        <a class="easyui-linkbutton" onclick="AddManager.AddFormula()" style=" float:left; width:100px;margin-left:19px;" data-options="iconCls:'icon-sum'" > 公 &nbsp;&nbsp;&nbsp; 式 &nbsp;</a>
                        <a class="easyui-linkbutton" onclick="AddManager.AddMacroFunction()" id="MacroFunctionBtn" style="float:left;margin-left:15px; width:100px;" data-options="iconCls:'icon-ok'"  > 宏 &nbsp;函 &nbsp;数 &nbsp;</a>
                    </td></tr>
                    <tr style="height:35px;"><td >数据源</td><td style="padding-left:19px"><input class="easyui-combobox" id="DataSource" value="<%=bte.DataSource %>" style="width:223px;height:29px;" data-options="url:urls.DataSourceUrl,valueField:'Id',textField:'Name',panelHeight:'auto'" readonly="readonly"/></td></tr>
                </table>
            </div>
        </td></tr>
        <tr ><td>千分位</td><td><input class="easyui-combobox" id="Thousand" style="width:220px;height:29px;" value="<%=bte.Thousand %>" data-options="data:[{Id:'1',Name:'是'},{Id:'0',Name:'否'}],valueField:'Id',textField:'Name',panelHeight:'auto'"/></td></tr>
    </table>
</body>
</html>
