<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default3.aspx.cs" Inherits="Audit.Default3" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <script type="text/javascript">
        function CloseWindow() {
            window.returnValue = "foo";
            window.close();
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    <input id="Button1" type="button" value="button" onclick="CloseWindow()" />
    </div>
    
    </form>

</body>
</html>
