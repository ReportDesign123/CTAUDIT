<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="IframeInner.aspx.cs" Inherits="Audit.ct.ReportData.IframeInner" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>校验</title>
    <link href="../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <script src="../../lib/easyUI/easyloader.js" type="text/javascript"></script>
    <script src="../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="../../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script type="text/javascript">
        var CheckGrid; //校验信息列表
        var LinkGrid; //联查信息列表
        var State = false;
        var urls = {
            CheckGridUrl: "../../handler/FormatHandler.ashx?ActionType=" + ReportFormatAction.ActionType.Grid + "&MethodName=" + ReportFormatAction.Methods.ReportFormatMenuMethods.ReportDataGrid + "&FunctionName=" + ReportFormatAction.Functions.ReportFormatMenu,
            functionsUrl: "../../handler/FormatHandler.ashx"
        };
        var GridManager = {
            loadCheckGrid: function (data) {
                if (!CheckGrid) {
                    CheckGrid = $("#CheckGrid").datagrid(
                    {
                        fit: true,
                        data: data,
                        sortOrder: "ASC",
                        sortName: "CreateTime",
                        border: false,
                        singleSelect: true,
                        fitColumns: true,
                        pagination: false,
                        columns: [[
                        { field: "FormularContent", title: "公式", width: 320 },
                        { field: "Problem", title: "错误信息", width: 350 }
                        ]]
                    });
                } else {
                    CheckGrid.datagrid("loadData", data);
                }
            },
            loadLinkGrid: function (data) {
                if (!LinkGrid) {
                    LinkGrid = $("#LinkGrid").datagrid(
                    {
                        fit: true,
                        data: data,
                        sortOrder: "ASC",
                        sortName: "CreateTime",
                        border: false,
                        singleSelect: true,
                        fitColumns: true,
                        pagination: false,
                        columns: [[
                        { field: 'ReportCode', title: '编号', width: 80 },
                        { field: 'ReportName', title: '名称', width: 100 },
                        { field: 'CompanyName', title: '单位', width: 100 }
                        ]]
                    });
                } else {
                    LinkGrid.datagrid("loadData", data);
                }
            }
        };
        //开始加载数据
        $(function () {
            $('#tt').tabs({
                fit: true,
                selected: null,
                border: false,
                tools: "#tab-tools",
                onSelect: function (title, index) {
                    if (index) {
                    } else {
                        GridManager.loadLinkGrid([]);
                    }
                }
            });
            $('#tt').tabs('disableTab', 0);
            $('#tt').tabs('disableTab', 1);
        });
        function showCheckInf(data) {
            $('#tt').tabs("select", 1);
            CheckGrid.datagrid("loadData", data);
        }
        function showLinkInf(data) {
            $('#tt').tabs("select", 0);
            LinkGrid.datagrid("loadData", data);
        }
        function LoadDataGrid(data) {
            $('#tt').tabs("select", 1);
            GridManager.loadCheckGrid(data);
        }
        function Collapse() {
            if (State) {
                $('#tt').tabs('disableTab', 0);
                $('#tt').tabs('disableTab', 1);
                $("#imgDown").css("display", "none");
                $("#imgUp").css("display", "block");
            } else {
                $('#tt').tabs('enableTab', 0);
                $('#tt').tabs('enableTab', 1);
                $("#imgUp").css("display", "none");
                $("#imgDown").css("display", "block");
            }
            parent.tabManager.CheckOutInfManager.CollapseState(State);
            State = !State;
        }
      </script>
</head>
<body style = "border-top:1px solid #8E8E8E">
    <div class="easyui-layout" style="border-top:1px solid #B9B9FF" data-options="fit:true">
        <div data-options="region:'center',border:false">
            <div id="tt" >
                <div title="联查信息"><table id="LinkGrid"></table></div>
                <div title="校验信息"><table id="CheckGrid"></table></div>
            </div>
        </div>
    </div>
    <div id="tab-tools" style="border-left:0px;border-top:0px;width:25px;padding-right:5px;display:none">
	    <a href="#" id="imgDown" onclick="Collapse()" style="display:none" class="easyui-linkbutton" plain="true" iconCls="icon-panel_up"></a>
	    <a href="#" id="imgUp" onclick="Collapse()" class="easyui-linkbutton" plain="true" iconCls="icon-panel_down"></a>
    </div>
</body>
</html>