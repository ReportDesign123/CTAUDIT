<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReportAggregationTemplateManager.aspx.cs" Inherits="Audit.ct.ReportData.ReportAggregation.ReportAggregationTemplateManager" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>模板管理</title>
    <link href="../../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <script src="../../../lib/easyUI/easyloader.js" type="text/javascript"></script>
    <script src="../../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="../../../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <script src="../../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    
      <link href="../../../lib/ligerUI/skins/Aqua/css/ligerui-all.css" rel="stylesheet" type="text/css" />
    <link href="../../../lib/ligerUI/skins/ligerui-icons.css" rel="stylesheet" type="text/css" />
 
    <script src="../../../lib/ligerUI/js/core/base.js" type="text/javascript"></script>
    <script src="../../../lib/ligerUI/js/core/inject.js" type="text/javascript"></script>
    <script src="../../../lib/ligerUI/js/ligerui.min.js" type="text/javascript"></script>
    <script src="../../../lib/json2.js" type="text/javascript"></script>
        <script src="../../../Scripts/ct_dialog.js" type="text/javascript"></script>
    <script type="text/javascript">
        var controls = {ClassifyGrid:{},TemplatGrid:{}};
        var urls = {
            ClassifyUrl: "../../../handler/ReportDataHandler.ashx?ActionType=" + ReportDataAction.ActionType.Grid + "&MethodName=" + ReportDataAction.Methods.ReportAggregationMethods.GetAggregationClassifys + "&FunctionName=" + ReportDataAction.Functions.ReportAggregation,
            TemplateUrl: "../../../handler/ReportDataHandler.ashx?ActionType=" + ReportDataAction.ActionType.Grid + "&MethodName=" + ReportDataAction.Methods.ReportAggregationMethods.GetAggregationTemplates + "&FunctionName=" + ReportDataAction.Functions.ReportAggregation,
            functionsUrl:"../../../handler/ReportDataHandler.ashx"
        };
        var  param;
        var dialogControls = { dialog: {} };
        $(function () {
            param = dialog.para();// window.dialogArguments;
            var allWidth = param.dialogWidth;
            var allHeight = param.dialogHeight - 40;
            var leftWidth = allWidth * 0.353;
            var centerWidth = allWidth * 0.646;
            document.getElementById("Classifies").style.height = allHeight;
            document.getElementById("Templates").style.height = allHeight;
            document.getElementById("Classifies").style.width = leftWidth;
            document.getElementById("Templates").style.width = centerWidth;
            controls.ClassifyGrid = $("#ClassifyGrid").datagrid({
                fit: true,
                title: "",
                data: rows.Rows,
                sortOrder: "ASC",
                sortName: "CreateTime",
                singleSelect: true,
                pagination: false,
                columns: [[
                    { field: "Id", title: "id", hidden: true, width: 120 },
                    { field: "Code", title: "编号", width: 80 },
                    { field: "Name", title: "名称", width: 125 }
                    ]],
                onSelect: function (index, rowdata) {
                    var url = urls.TemplateUrl + "&ClassifyId=" + rowdata.Id;
                    ShowTemplateTable(url);
                },
                onDblClickRow: function (index, rowdata) {
                    if (param && param.Type == "Classify") {
                        var modalid = $(window.frameElement).attr("modalid");
                        dialog.setVal(rowdata);
                        dialog.close(modalid);
                    }
                }
            });
            $("#FileToolBar").ligerToolBar({ items: [
                { text: '增加', click: ButtonManager.add, icon: 'add' },
                { line: true },
                { text: '修改', click: ButtonManager.edit, icon: 'modify' },
                { line: true },
                { text: '删除', click: ButtonManager.delt, icon: 'delete' }
                ]
            });
            $("#TemplateToolBar").ligerToolBar({ items: [
                { text: '删除模板', click: ButtonManager.deltTemplate, icon: 'delete' }
                ]
            });
            controls.ClassifyGrid.datagrid('selectRow', 0);
        });
       var ButtonManager = {
           add: function (item) {
               itemclick(item);
           },
           edit: function (item) {
               var row = controls.ClassifyGrid.datagrid("getSelected");
               if (row) {
                   item.row = row;
                   itemclick(item);
               } else {
                   MessageManager.InfoMessage("请先选择一行要删除的数据");
               }
           },
           //删除
           delt: function () {
               var row = controls.ClassifyGrid.datagrid('getSelected');
               var para = {};
               if (row) {
                   $.messager.confirm('系统提示', '你确定要删除当前单位?', function (r) {
                       if (!r) { return; }
                       else {
                           var para = {};
                           para = CreateParameter(ReportDataAction.ActionType.Post, ReportDataAction.Functions.ReportAggregation, ReportDataAction.Methods.ReportAggregationMethods.DeleteAggregationTemplateClassify, row);
                           DataManager.sendData(urls.functionsUrl, para, resultManager.success, resultManager.fail);
                       }
                   });
               } else {
                   MessageManager.InfoMessage("请先选择一行要删除的数据");
               }
           },
           deltTemplate: function () {
               var row = controls.TemplatGrid.datagrid('getSelected');
               var para = {};
               if (row) {
                   $.messager.confirm('系统提示', '你确定要删除当前单位?', function (r) {
                       if (!r) { return; }
                       else {
                           var para = {};
                           para = CreateParameter(ReportDataAction.ActionType.Post, ReportDataAction.Functions.ReportAggregation, ReportDataAction.Methods.ReportAggregationMethods.DeleteAggregationTemplate, row);
                           DataManager.sendData(urls.functionsUrl, para, resultManager.success, resultManager.fail);
                           controls.TemplatGrid.datagrid("reload");
                       }
                   });
               } else {
                   MessageManager.InfoMessage("请先选择一行要删除的数据");
               }
           }
       };
       function ShowTemplateTable(url) {
           controls.TemplatGrid = $("#TemplateGrid").datagrid(
                {
                    fit: true,
                    title: "",
                    url: url,
                    sortOrder: "ASC",
                    sortName: "CreateTime",
                    singleSelect: true,
                    pagination: false,
                    columns: [[
                    { field: "Id", title: "id", hidden: true, width: 120 },
                    { field: "Code", title: "编号", width: 140 },
                    { field: "Name", title: "名称", width: 210 }
                    ]],
                    onDblClickRow: function (index, rowdata) {
                        if (param && param.Type == "Template") {
                            rowdata.ClassifyName = controls.ClassifyGrid.datagrid("getSelected").Name;
                            var modalid = $(window.frameElement).attr("modalid");
                            dialog.setVal(rowdata);
                            dialog.close(modalid);
                        }
                    }
                });
       }
        var resultManager = {
            success: function (data) {
                if (data.success) {
                    RefreshClassifis();
                    MessageManager.InfoMessage(data.sMeg);
                } else { MessageManager.ErrorMessage(data.sMeg); }
            },
            successRefresh: function (data) {
                controls.ClassifyGrid.datagrid("loadData", data);
            },
            fail: function (data) {
                MessageManager.ErrorMessage(data.toString);
            }
        }
        function RefreshClassifis() {
            var para = CreateParameter(ReportDataAction.ActionType.Post, ReportDataAction.Functions.ReportAggregation, ReportDataAction.Methods.ReportAggregationMethods.GetAggregationClassifys, {});
            DataManager.sendData(urls.functionsUrl, para, resultManager.successRefresh, resultManager.fail);
        }
        function itemclick(item) {
            dialogControls.dialog = $.ligerDialog.open({
                target: $("#classifyDalog"), title: item.text,
                showToggle: true,
                showMin: false,
                isResize: true,
                height: 200,
                weith: 250,
                buttons: [{
                    text: '确定',
                    onclick: function () {
                        var parameters = {};
                        if (item.text == "增加") {
                            parameters = getParameter(ReportDataAction.Methods.ReportAggregationMethods.SaveAggregationTemplateClassify);
                            if (!parameters) return; 
                            DataManager.sendData(urls.functionsUrl, parameters, resultManager.success, resultManager.fail);
                        } else if (item.text == "修改") {
                            parameters = getParameter(ReportDataAction.Methods.ReportAggregationMethods.UpdateAggregationTemplateClassify);
                            if (!parameters) return; 
                            DataManager.sendData(urls.functionsUrl, parameters, resultManager.success, resultManager.fail);
                        }
                        dialogControls.dialog.hide();
                    }
                }, {
                    text: '取消',
                    onclick: function () {
                        dialogControls.dialog.hide();
                    }
                }]
            });
            if (item.row) {
                $("#Code").val(item.row.Code);
                $("#Name").val(item.row.Name);
                $("#Id").val(item.row.Id);
            } else {
                $("#Code").val("");
                $("#Name").val("");
                $("#Id").val("");
            }
        }
        function getParameter(methodName) {
            var params = {};
            params["Code"] = $("#Code").val();
            params["Name"] = $("#Name").val();
            params["MethodName"] = methodName;
            params["ActionType"] = ReportDataAction.ActionType.Post;
            params["FunctionName"] = ReportDataAction.Functions.ReportAggregation;

            var id = $("#Id").val();
            if (id != "") {
                params["Id"] = id;
            }
            if (params.Code == "") { MessageManager.InfoMessage("请输入编号"); return null; }
            if (params.Name == "") { MessageManager.InfoMessage("请输入名称"); return null; }
            return params;
        }
    </script>
    
</head>
<body style=" overflow:hidden">
    <div style=" width:100%; height:100%">
        <div style = "width:100%">
            <div id="FileToolBar"  style=" width:35%; float:left"></div>
            <div id="TemplateToolBar" style=" width:64.3%;float:right"></div>
        </div>

        <div id ="Classifies" style=" float:left;margin-top:0px; overflow:auto">
            <table id ="ClassifyGrid"></table>
            
        </div>
        <div id="Templates" style="float:right;margin-top:0px;overflow:auto">
            <table id="TemplateGrid"></table>
        </div>
        <div id="classifyDalog" style=" display:none">
            <input id="Id" value ="" type="hidden"/>
            <table style=" margin-top:20px; margin-left:10px; width:90%" >
            <tr style=" height:50px"><td>类型编号:</td><td><input id="Code" value="" type="text" class="easyui-validatebox textbox"  style="height:25px;width:170px;" /></td></tr>
            <tr style=" height:40px"><td>类型名称:</td><td><input id="Name" value="" type="text" class="easyui-validatebox textbox"  style="height:25px;width:170px;" /></td></tr>
            </table>
        </div>
    </div>
</body>
</html>
