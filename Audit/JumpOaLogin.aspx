<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="JumpOaLogin.aspx.cs" Inherits="Audit.JumpOaLogin" %>

<!DOCTYPE html>
<html>
<head id="Head1" runat="server">
    <title>GStoOa接口</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <script src="lib/jquery/jquery-1.5.2.min.js" type="text/javascript"></script>
    <script src="Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <script src="Scripts/FunctionMethodManager.js" type="text/javascript"></script> 
    <script src="lib/Cookie/jquery.cookie.js" type="text/javascript"></script>
    <script src="Scripts/Cookie/Cookie.js" type="text/javascript"></script>
    <script type="text/javascript">
        var Url="";
        var Jump = "";
        window.onload = function () {
            window.setTimeout("OpenFuns()", 100, "JavaScript");
        }
        function OpenFuns() {
            if (Jump = "") {

                form1.action = Url;
                form1.submit();

            }
            else
            {
                $("#spanM").text(Jump);
            }
        }
    </script>
</head>
<body>
    <form id="form1" runat="server" target="_self">
        <div id="divWait" >正在打开该功能，请稍候……
		</div>
        <div>
     <span id="spanM" style="color: Red"></span>
    </div>
    </form>
</body>
</html>