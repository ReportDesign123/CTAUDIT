<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReportVarifyInfo.aspx.cs" Inherits="Audit.ct.ReportData.ReportVarifyInfo" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
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
        var LinkTypeObj = { ReportJoin: "报表联查", CustomFormular: "取数公式", CustomUrl: "地址链接" };
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
                        { field: 'Code', title: '编号', width: 80 },
                        { field: 'Name', title: '名称', width: 100 },
                        { field: 'Type', title: '联查类型', width: 100, formatter: function (value) {
                            if (value) {
                                return LinkTypeObj[value]
                            } else { return value }
                        } 
                        }
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
                        if (!CheckGrid) {
                            // GridManager.loadLinkGrid([]);

                        }
                    }
                    if (index == 0) {
                        RefreshAttatch();
                    }
                }
            });
            $('#tt').tabs('disableTab', 0);
            $('#tt').tabs('disableTab', 1);
            RefreshAttatch();
         

        });

        function RefreshAttatch() {
            if (State) {
                var cellCode = parent.toolsManager.GetGdqCellCode();
                if (cellCode != "") {
                    var iframe = document.getElementById("uploadFile");
                    var para = parent.toolsManager.GetReportParameter();

                    iframe.src = "UploadMiddle.aspx?TaskId=" + para.TaskId + "&PaperId=" + para.PaperId + "&ReportId=" + para.ReportId + "&CompanyId=" + para.CompanyId + "&Nd=" + para.Year + "&Zq=" + para.Cycle + "&DataItem=" + cellCode;
                }
            }
           
           
        }
        function LoadLinkInf(data) {
            $('#tt').tabs("select", 0);
           // GridManager.loadLinkGrid(data);
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
                <div title="附件信息">
                <%--<table id="LinkGrid"></table>--%>
                <iframe  id="uploadFile"  frameborder="0" width="100%" scrolling="no"></iframe>
                </div>
                <div title="校验信息"><table id="CheckGrid"></table></div>
                <div title="快速查找"><table id="FindGrid"></table></div>
                <div title="数据冻结"><table id="FreezeGrid">
                   <tr class="myTr">
								<td><span>是否锁定</span></td>
                                <td>
                                <select name="select" id="select_k1" style="width:100px" >    <option value="1">是</option><option value="0">否</option></select>
                                </td>
								
							</tr>
                </table></div>
            </div>
        </div>
    </div>
    <div id="tab-tools" style="border-left:0px;border-top:0px;width:25px;padding-right:5px;display:none">
	    <a href="#" id="imgDown" onclick="Collapse()" style="display:none" class="easyui-linkbutton" plain="true" iconCls="icon-panel_up"></a>
	    <a href="#" id="imgUp" onclick="Collapse()" class="easyui-linkbutton" plain="true" iconCls="icon-panel_down"></a>
    </div>
</body>
</html>