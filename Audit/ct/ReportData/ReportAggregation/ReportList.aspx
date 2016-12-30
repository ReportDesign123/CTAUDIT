<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReportList.aspx.cs" Inherits="Audit.ct.ReportData.ReportAggregation.ReportList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title> 汇总报表查看</title>
       
    <script src="../../../lib/jquery/jquery-1.5.2.min.js" type="text/javascript"></script>
    <link href="../../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="../../../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script src="../../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <link href="../../../Styles/Common.css" rel="stylesheet" type="text/css" />
    <link href="../../../Styles/Ct_Controls.css" rel="stylesheet" type="text/css" />
    <script src="../../../Scripts/Ct_Tool.js" type="text/javascript"></script>
    <script src="../../../Scripts/Ct_Controls.js" type="text/javascript"></script>
    <script src="../../../lib/json2.js" type="text/javascript"></script>
    <script type="text/javascript">
        var urls = {
            datagrid: "../../../handler/ReportDataHandler.ashx?ActionType=" + ReportDataAction.ActionType.Grid + "&MethodName=" + ReportDataAction.Methods.ReportAggregationMethods.GetAggregationTemplate + "&FunctionName=" + ReportDataAction.Functions.ReportAggregation,
            functionsUrl: "../../../handler/ReportDataHandler.ashx",
            ReportDataUrl: "ct/ReportData/ReportAggregation/ReportAggregationDataShow.aspx",
            AddFormular: "AddFormular.aspx"

        };
        var reportsData;
        var companiesData;
        var ReportGrid;
        var paramater;
        var companyColumns = [{header:'汇总单位',name:'name'}]
        $(function () {
            $(document).keydown(
            function (e) {
                if (e.which == 13) {
                    SearchManager.SearchReports();
                }
            });
            $("#Companies").datagrid({
                fit: true,
                agination: false,
                singleSelect: true,
                sortName: 'id',
                sortOrder: 'DESC',
                columns: [[
                    {field:'id',width:80,align:'center',hidden:true},
                    { field: 'name', title: '汇总单位', width: 220, align: 'left'}
                   ]]
            });
            LoadGrid();
        });
        var ReportManager = {
            helpDataGrid: function (data) {
                ReportGrid = $("#reportGrid").datagrid({
                    fit: true,
                    data: data,
                    toolbar: '#toobar',
                    sortName: 'CreateTime',
                    sortOrder: 'DESC',
                    pagination: false,
                    singleSelect: true,
                    columns: [[
                    { field: 'bbCode', title: '报表编号', width: 100, align: 'left', sortable: false },
                    { field: 'bbName', title: '报表名称', width: 190, align: 'left', sortable: false },
                    { field: 'Id', title: '操作', width: 120, align: 'left', formatter: function (value, rowData, index) {
                        return '<a href="#" onclick="ViewReportData(this.id)" id="' + value + ',' + rowData.bbCode + ',' + rowData.bbName + '">查看汇总数据</a>';
                        } 
                    }     
                   ]]
                })
            }
        };
        function LoadGrid() {
            var template = JSON2.parse(para.template.Content);
            reportsData = template.ReportItems;
            ReportManager.helpDataGrid(reportsData);
            $("#Companies").datagrid("loadData", template.Companies);
            companiesData = template.Companies;
            paramater = para.logEntity;            
        }
        var successManager = {
            success: function (data) {
                if (data.success) {
                    var template = JSON2.parse(data.obj.Content);
                    reportsData = template.ReportItems;
                    ReportManager.helpDataGrid(reportsData);
                    var Cmp = liger.get("Companies");
                    Cmp.addItems(template.Companies);
                } else { MessageManager.ErrorMessage(data.sMeg); }
            },
            fail: function (data) {
                MessageManager.ErrorMessage(data.toString);
            }
        }
        //报表数据查看
        function ViewReportData(reportId) {
            var reportData = reportId.split(",");
            //paramater.CompanyId
            var para = { ReportId: reportData[0], CompanyId: paramater.CompanyId, Cycle: paramater.Cycle, Year: paramater.Year, PaperId: paramater.Paper, TaskId: paramater.TaskId, TemplateId: paramater.TemplateId };
            para = JSON2.stringify(para);
            para = encodeURI(para);
            parent.NavigatorNode({ id: "066", text:reportData[2]+"("+reportData[1] + ")" , attributes: { url: urls.ReportDataUrl + "?para=" + para} });
        }
        //检索报表
        var SearchManager={
        SearchReports:function () {
            var para = { bbCode: $("#bbCode").val(), bbName: $("#bbName").val() };
            if (!para.bbCode&&!para.bbName) {
               SearchManager.CancelSearchReports();
            } else {
                var newData = [];
                $.each(reportsData, function (index, report) {
                    if (SearchManager.find(para.bbCode, report.bbCode) || SearchManager.find(para.bbName, report.bbName))
                        newData.push(report);
                });
                $("#reportGrid").datagrid("loadData", newData);
            }
        },
        //执行检索
        find:function (sFind, sObj) {
            var nSize = sFind.length;
            var nLen = sObj.length;
            var sCompare;
            if (nSize>0&&nSize <= nLen) {
                for (var i = 0; i <= nLen - nSize + 1; i++) {
                    sCompare = sObj.substring(i, i + nSize);
                    if (sCompare == sFind) {
                        return true;
                    }
                }
            }
            return null;
        },
        //报表询取消
        CancelSearchReports:function () {
            $("#bbCode").val("");
            $("#bbName").val("");
            var para = { bbCode: "", bbName: "" };
            $("#reportGrid").datagrid("loadData", reportsData);
        }
        }
    </script>
</head>
<body>
    <div id="layout"class="easyui-layout" fit="true"  style=" margin:1px;" >
        <div data-options="region:'center',iconCls:'icon-save'">
           <div id="toobar"class="datagrid-toolbar">
            <table ><tr>    
           <td style=" font-size:13px">报表编号</td> <td> <input id = "bbCode"class="easyui-validatebox textbox" style="width:120px;height:20px;" /></td>
            <td style=" font-size:13px">报表名称</td> <td> <input id = "bbName"class="easyui-validatebox textbox" style="width:120px;height:20px;"/></td>
              <td> <a href="#" class="easyui-linkbutton" id="searcher" data-options="iconCls:'icon-search'" onclick="SearchManager.SearchReports()" style="width:60px">查询</a></td>
              <td> <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-undo'" onclick="SearchManager.CancelSearchReports()" style="width:60px">还原</a></td>
            </tr>
            </table>
          </div>
        <div id="reportGrid"style=" overflow:auto" /></div>
    </div>
    <div data-options="region:'east',split:true,collapsible:false" style="width:230px;overflow:hidden;" class="ctFont">
             <div id="Companies" ></div>
    </div>
</body>
</html>
