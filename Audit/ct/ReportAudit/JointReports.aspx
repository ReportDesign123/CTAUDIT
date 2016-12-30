<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="JointReports.aspx.cs" Inherits="Audit.ct.ReportAudit.JointReports" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>报表联查</title>
     <script src="../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <link href="../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="../../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script src="../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <script type="text/javascript">
     
        $(function () {
            $("#reportGrid").datagrid({
                columns: [[
                    { field: 'ReportCode', title: '编号', width: 80 },
                    { field: 'ReportName', title: '名称', width: 130, formatter: function (value, row,index) {
                        return "<a href='#' onclick='reportJoin(this.id)' id=" + index + ">" + row.ReportName + "</a>";
                    } },
                    { field: 'CompanyName', title: '单位', width: 170 },
                    { field: '年度', title: '年度', width: 80, formatter: function (value, row, index) {
                        return row.Parameters.Year;
                    }
                    },
                    { field: '周期', title: '周期', width: 80, formatter: function (value, row, index) {
                        return row.Parameters.Cycle;
                    }
                    }
                ]],
                singleSelect: true,
                fit: true,
                //fitColumns:true,
                sortName: 'ReportCode',
                sortOrder: 'ASC',
                pagination: true
            });
        });

        function loadData(param) {
            $("#reportGrid").datagrid("loadData", param.data.Reports);
        }
        function reportJoin(index) {
            var rows = $("#reportGrid").datagrid("getRows");
            var selectRow = rows[index];
            parent.CommunicationManager.Right_Control.ReportJoin(selectRow);
        }
    </script>
    <style type="text/css">
    a:link {color: #4E0066; text-decoration:none;} 
    a:active:{color: red; }
    a:visited {color:purple;text-decoration:none;} 
    a:hover {color: #FF6633; text-decoration:underline;} 
    </style>
</head>
<body>   
        <table id="reportGrid" style="border:0px" ></table>    
</body>
</html>
