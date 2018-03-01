<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ContentInfo.aspx.cs" Inherits="Audit.ct.pub.ContentInfo" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>信息查看</title>
        <script src="../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
            <script src="../../Scripts/ct_dialog.js"  type="text/javascript"></script>
    <script type="text/javascript">
    //公式内容显示
        window.onload = function () {
            var content = dialog.para();// window.dialogArguments;
            $("#content").text(content);
        }
        function getResult() {
            var result = $("#content").text();
            window.returnValue = result;
        }
    </script>
</head>
<body onUnload="getResult()"  style=" font-size:12px;">
   <textarea id="content" style=" width:390px; height:290px;line-height: 150%;  border:0px; padding:5px; color:#0000ff;"></textarea>
</body>
</html>
