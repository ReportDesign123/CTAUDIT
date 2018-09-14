<%@ Page Language="C#" validateRequest="false"  AutoEventWireup="true" CodeBehind="JumpDrpLogin.aspx.cs" Inherits="Audit.JumpDrpLogin" %>

<!DOCTYPE html>
<html>
<head id="Head1" runat="server">
    <title>DRP接口</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
     <script src="lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
   
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

<script type="text/javascript">
    $("#divWait").text("");
</script>