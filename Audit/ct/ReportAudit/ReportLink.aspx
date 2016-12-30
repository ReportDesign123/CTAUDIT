<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReportLink.aspx.cs" Inherits="Audit.ct.ReportAudit.ReportLink" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>报表联查结果</title>
      <meta http-equiv="X-UA-Compatible" content="IE=10" />
     <meta http-equiv="X-UA-Compatible" content="IE=9" />
     <meta http-equiv="X-UA-Compatible" content="IE=8" />
     <meta http-equiv="X-UA-Compatible" content="IE=7" />
    <script src="../../lib/jquery/jquery-1.3.2.min.js" type="text/javascript"></script>
    <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script src="../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <script src="../../lib/json2.js" type="text/javascript"></script>
    <script src="../../lib/Base64.js" type="text/javascript"></script>
    <link href="../../Styles/Common.css" rel="stylesheet" type="text/css" />
    <script src="../../Scripts/ct/ReportData/ReportAggregation/ReportDataCell.js" type="text/javascript"></script>
    <script src="../../Scripts/Ct_Tool.js" type="text/javascript"></script>
    <script type  ="text/javascript">
        var currentState = {paras: {}, bbFormat: {}, bbData: {}, reportAudit: {} };
        var bdCodeCountMaps = {};
        $(function () {
            var data = {};
            if (!para || para == undefined) return;
            if (para && para.error) {
                alert(decodeURI(para.error));
                return;
            }
            data.obj = para.data;
            data.success = true;
            gridManager.Success(data);
            var width = $(window).width();
            Grid1.width = width - 3;
            var height = $(window).height();
            Grid1.height = height - 3;

        });
        window.onresize = function () {
            var width = $(window).width();
            Grid1.width = width - 3;
            var height = $(window).height();
            Grid1.height = height - 3;
        }
    </script>


</head>
<body style=" padding:0px; margin:0px; overflow:hidden">
	<OBJECT CLASSID = "clsid:5220cb21-c88d-11cf-b347-00aa00a28331" VIEWASTEXT>
         <PARAM NAME="LPKPath" VALUE="../lpk/flexCell.LPK">
      </OBJECT> 
      <OBJECT TYPE="application/x-itst-activex"  id="Grid1"  CLASSID="clsid:4331220A-1077-4630-BEE3-0D7142D6ABD0" >
         <PARAM NAME="_ExtentX" VALUE="0">
         <PARAM NAME="_ExtentY" VALUE="0">       
      </OBJECT>
</body>
</html>
