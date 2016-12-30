<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReportDataCell11.aspx.cs" Inherits="Audit.ct.ReportData.ReportAggregation.ReportDataCell1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head >
    <title>报表汇总资料查看</title>
    <script src="../../../lib/jquery/jquery-1.5.2.min.js" type="text/javascript"></script>
         <link href="../../../Styles/default.css" rel="stylesheet" type="text/css" />
             <link href="../../../Styles/FormatManager.css" rel="stylesheet" type="text/css" />
      <script src="../../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script src="../../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <script src="../../../Scripts/ct/ReportData/ReportAggregation/ReportDataCell.js"
        type="text/javascript"></script>
    <script src="../../../lib/ligerUI/js/core/base.js" type="text/javascript"></script>
    <script src="../../../lib/ligerUI/js/core/inject.js" type="text/javascript"></script>
    <script src="../../../lib/ligerUI/js/ligerui.min.js" type="text/javascript"></script>
    <link href="../../../lib/ligerUI/skins/ligerui-icons.css" rel="stylesheet" type="text/css" />
    <link href="../../../lib/ligerUI/skins/Aqua/css/ligerui-all.css" rel="stylesheet"
        type="text/css" />
    <script src="../../../Scripts/Ct_Tool.js" type="text/javascript"></script>
    <script src="../../../lib/json2.js" type="text/javascript"></script>
    <script src="../../../lib/Base64.js" type="text/javascript"></script>
        <script type="text/javascript">
            var currentState = { currentWidth: 0, controlWidth: 0, paras: {}, bbFormat: {}, bbData: {}, reportAudit: {}, currentProblemId: "", currentCellInfo: "" };
            var urls = {
              reportAuditUrl:"../../../handler/ReportDataHandler.ashx"
          };
          $(function () {
              $("#layout1").ligerLayout({});
              $("#toolBar").ligerToolBar({ items: [
                    {
                        text: '打印', click: function (item) {
                            Grid1.DirectPrint();
                        }, icon: 'print'
                    },
                    { line: true },
                    { text: '打印预览', icon: 'prev', click: function (item) {
                        Grid1.PrintPreview(100);
                    }
                    }
                ]
              });
              var para = $("#parmeter").val();
              para = Base64.decode(para);
              if (para && para != "") {
                  var parameter = JSON2.parse(para);
                  parameter = CreateParameter(ReportDataAction.ActionType.Post, ReportDataAction.Functions.ReportAggregation, ReportDataAction.Methods.ReportAggregationMethods.GetReportData, parameter);
                  gridManager.LoadData(parameter, urls.reportAuditUrl);
              }

          });
            var CommunicationManager = {
                LoadCellData: function (parameter) {
                    parameter = CreateParameter(ReportDataAction.ActionType.Post, ReportDataAction.Functions.ReportAggregation, ReportDataAction.Methods.ReportAggregationMethods.GetReportData, parameter);
                    gridManager.LoadData(parameter, urls.reportAuditUrl);
                }
            };
        </script>

</head>
<body style="overflow:hidden" >
    <div id="toolBar"></div>
    <input type="hidden" id="parmeter" value = "<%=param %>"/>
    <div id="layout1">
    <div position="center">
        <OBJECT CLASSID = "clsid:5220cb21-c88d-11cf-b347-00aa00a28331" VIEWASTEXT>
            <PARAM NAME="LPKPath" VALUE="../../lpk/flexCell.lpk">
        </OBJECT> 
        <OBJECT  ID="Grid1"  Width=100% Height=100%  CLASSID="clsid:4331220A-1077-4630-BEE3-0D7142D6ABD0" >
            <PARAM NAME="_ExtentX" VALUE="0">
            <PARAM NAME="_ExtentY" VALUE="0">
        </OBJECT>
    </div>
    </div>
</body>
</html>
