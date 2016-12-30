<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RelatedInfomation.aspx.cs" Inherits="Audit.ct.ReportAudit.RelatedInfomation" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>相关指标</title>
    <script src="../../lib/jquery/jquery-1.3.2.min.js" type="text/javascript"></script>
    <link href="../../Styles/Ct_TextInput.css" rel="stylesheet" type="text/css" />
    <script src="../../Scripts/Ct_TextInput.js" type="text/javascript"></script>
    <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script src="../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
</head>
<body style="margin:0px; padding:0px; overflow:hidden">
    <script type="text/javascript">
        var widthTemp = 420;
        var length = 3;
        var controls={problemContent:{}};
        $(function () {
            $("#SQS").CTTextBox({ innerText: "", width: widthTemp * 0.7 });
            $("#TQS").CTTextBox({ innerText: "", width: widthTemp * 0.7 });
            $("#HBS").CTTextBox({ innerText: "", width: widthTemp * 0.7 });
            $("#TBS").CTTextBox({ innerText: "", width: widthTemp * 0.7 });
        });
        function loadData(param) {
            $("#Tr_SQS").css("display", "none");
            if (param.data.LastPeriodNumber.length > 0) {
                $("#SQS").val(param.data.LastPeriodNumber[0].value);
            } else {
                $("#SQS").val("");
            }
            if (param.data.RelativeRatio.length > 0) {
                var hbs = param.data.RelativeRatio[0].value.toFixed(2)+"%";
                $("#HBS").val(hbs);
            } else {
                $("#HBS").val("");
            }
            if (param.data.SamePeriodNumber.length > 0) {
                $("#TQS").val(param.data.SamePeriodNumber[0].value);
            } else {
                $("#TQS").val("");
            }
            if (param.data.SameRatio.length > 0) {
                var hbs = param.data.SameRatio[0].value.toFixed(2) + "%";
                $("#TBS").val(hbs);
            } else {
                $("#TBS").val("");
            }
            $("#Tr_TQS").css("display", "none");
            $("#Tr_HBS").css("display", "none");
            $("#Tr_TBS").css("display", "none");
            var Relations = param.Relations.Indexs;
            length = Relations.length;
            if (length != 0) {
                $("#IndexRelations").css("display", "table");
                for (var i = 0; i < length; ++i) {
                    $("#Tr_" + Relations[i].Code).css("display", "table");
                }
            } 
        }

    </script>
    <table  id="IndexRelations" style="margin:20px; width:100%; font-size:14px">
            <tr style="height:40px; " id="Tr_SQS"><td>上　期　数</td><td style=" padding-left:20px"><input id="SQS" type="text" readonly="readonly"/></td></tr>
            <tr style="height:40px; " id="Tr_HBS"><td>环比增长率</td><td style=" padding-left:20px"><input id="HBS" type="text" readonly="readonly"/></td></tr>
            <tr style="height:40px; " id="Tr_TQS"><td>同　期　数</td><td style=" padding-left:20px"><input id="TQS" type="text" readonly="readonly"/></td></tr>
            <tr style="height:40px; " id="Tr_TBS"><td>同比增长率</td><td style=" padding-left:20px"><input id="TBS" type="text" readonly="readonly"/></td></tr>
    </table>
</body>
</html>
