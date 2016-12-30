<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReportAggregationconstituteGrid.aspx.cs" Inherits="Audit.ct.ReportData.ReportAggregation.ReportAggregationconstituteGrid" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<title>相关单位指标</title>
     <script src="../../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <link href="../../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="../../../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script src="../../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(function () {
            $("#IndexGrid").datagrid({
                columns: [[
                    { field: 'name', title: '单位', width: 280 },
                    { field: 'value', title: '指标值', width: 100 }
                ]],
                singleSelect: true,
                fit: true,
                //fitColumns: true,
                sortName: 'CompanyName',
                sortOrder: 'ASC',
                pagination: true
            });
        });
        function loadData(data, columns) {
            $("#IndexGrid").datagrid({ data: data, columns: columns });
            //$("#IndexGrid").datagrid("loadData", data);
        }
    </script>
</head>
<body >
        <table id="IndexGrid"></table>
</body>
</html>
