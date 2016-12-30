<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm1.aspx.cs" Inherits="Audit.ct.Format.WebForm1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="../../lib/SpreadCSS/gcspread.sheets.excel2016colorful.9.40.20153.0.css"
        rel="stylesheet" type="text/css" />
  <script type="text/javascript" src="../../lib/jquery/jquery-1.11.1.min.js"></script>
     <script type="text/javascript" src="../../lib/SpreadJS/gcspread.sheets.all.9.40.20153.0.min.js"></script>
     <script type="text/javascript">
         $(function () {
             var spread = new GcSpread.Sheets.Spread(document.getElementById('ss'), { sheetCount: 1 });
         
         });
     
     
     </script>
</head>
<body>
    <form id="form1" runat="server">
    <div id="ss">
    
    </div>
    </form>
</body>
</html>
