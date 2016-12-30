<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CustomerReportLink.aspx.cs" Inherits="Audit.ct.ReportAudit.CustomerReportLink" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
  <title>功能菜单</title>  
    <script src="../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <script src="../../lib/easyUI/easyloader.js" type="text/javascript"></script>
    <link href="../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="../../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script src="../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <script type="text/javascript">
        //参数
        var menuGrid;
        var urls = {
            menuGridUrl: "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Grid + "&MethodName=" + BasicAction.Methods.CompanyManagerMethods.GetCompanyList + "&FunctionName=" + BasicAction.Functions.CompanyManager,
            addMenuUrl: "AddCompany.aspx",
            functionsUrl: "../../handler/BasicHandler.ashx"
        };
        $(function () {
            var Columns = [[]];
            if (para && para.error) {
                alert(decodeURI(para.error));
                return;
            }
            for (var i = 0; i < para.data.Columns.length; i++) {
                var field = { field: para.data.Columns[i], title: para.data.Columns[i], width: 100 };
                Columns[0].push(field);
            }
            menuGrid = $("#menuGrid").datagrid({
                title: "",
                fit: true,
                fitColumns: true,
                singleSelect: true,
                sortName: 'ZQ',
                sortOrder: 'ASC',
                pagination: true,
                columns: Columns,
                data: para.data.Rows
            });
        });
        var resultManagers = {

            success: function (data) {
                if (data.success) {
                    MessageManager.InfoMessage(data.sMeg);
                    menuGrid.treegrid('reload');
                    $('#Dialog').dialog("close");

                } else {
                    MessageManager.ErrorMessage(data.sMeg);
                }
            },
            fail: function (data) {

                MessageManager.ErrorMessage(data.toString);
            },
            delete_Success: function (data) {
                if (data.success) {
                    MessageManager.InfoMessage(data.sMeg);
                    menuGrid.treegrid('reload');
                    menuGrid.treegrid('unselectAll');

                } else {
                    MessageManager.ErrorMessage(data.sMeg);
                }
            }

        }
        
    </script>
</head>
<body >
        <table id="menuGrid"></table>
</body>
</html>