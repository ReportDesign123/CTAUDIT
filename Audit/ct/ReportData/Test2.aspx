<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Test2.aspx.cs" Inherits="Audit.ct.ReportData.Test2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
  
</head>
<body>
			   <OBJECT CLASSID = "clsid:5220cb21-c88d-11cf-b347-00aa00a28331" VIEWASTEXT>
         <PARAM NAME="LPKPath" VALUE="../lpk/flexCell.LPK">
      </OBJECT> 

      <OBJECT  ID="Grid1" Width="800" Height="600"    CLASSID="clsid:4331220A-1077-4630-BEE3-0D7142D6ABD0" >
     <PARAM NAME="_ExtentX" VALUE="0">
        <PARAM NAME="_ExtentX" VALUE="0">
         <PARAM NAME="_ExtentY" VALUE="0">

      </OBJECT>
        <script type="text/javascript">
            function Initialize() {
                Grid1.Cols = 10;
                Grid1.Rows = 10;
                Grid1.DisplayRowIndex = true;
                Grid1.FixedRowColStyle = 0;
                Grid1.Appearance = 0;
              //  Grid1.CellBorderColorFixed = Grid1.BackColorBKG;

                Grid1.Refresh();
            }

            Initialize();
    </script>
</body>
</html>
