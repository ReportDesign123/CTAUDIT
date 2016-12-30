<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="test.aspx.cs" Inherits="Audit.ct.Format.test" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
     <meta http-equiv="X-UA-Compatible" content="IE=10" />
     <meta http-equiv="X-UA-Compatible" content="IE=9" />
     <meta http-equiv="X-UA-Compatible" content="IE=8" />
     <meta http-equiv="X-UA-Compatible" content="IE=7" />
      <link rel="stylesheet" href="../../lib/SpreadCSS/gcspread.sheets.excel2013white.9.40.20153.0.css" title="spread-theme" />
     <script src="../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
     <script src="../../lib/jquery/jquery-ui-1.10.3.custom.min.js" type="text/javascript"></script>
     <script type="text/javascript" src="../../lib/SpreadJS/gcspread.sheets.all.9.40.20153.0.min.js"></script>
      <script type="text/javascript" src="../../lib/SpreadJS/FileSaver.min.js"></script>
    <script type="text/javascript" src="../../lib/SpreadJS/resources.js"></script>
     <script type="text/javascript" src="../../lib/SpreadJS/bootstrap.min.js"></script>
     <script type="text/javascript">
     document.write("Hello World!");
      var spreadNS = GcSpread.Sheets;
      var spread;
       var tableIndex = 1, pictureIndex = 1;
       var fbx, isShiftKey = false;
       var resourceMap = {},
    conditionalFormatTexts = {};
       $(function () {
           spread = new spreadNS.Spread($("#ss")[0]);
           spread.setTabStripRatio(0.88);
           var sheet = new spreadNS.Sheet("Cell");
           spread.removeSheet(0);
           spread.addSheet(spread.getSheetCount(), sheet);
           

           sheet.isPaintSuspended(true);
           sheet.setColumnCount(10);
           sheet.setRowCount(10);

//           sheet.setColumnWidth(0, 100);
//           sheet.setColumnWidth(1, 20);

//           for (var col = 2; col < 11; col++) {
//               sheet.setColumnWidth(col, 88);
//           }

//           attachSpreadEvents();
           //           attachCellTypeEvents();
           sheet.isPaintSuspended(false);
       });
    
    

  



      </script>
</head>
<body>
    <form id="form1" runat="server">
       <div class="content-container">
        <div id="inner-content-container">
            <table id="formulaBar" style="width: 100%;">
                <tbody>
                    <tr>
                        <td style="vertical-align:top;">
                            <input type="text" id="positionbox" disabled="disabled" style="/*text-align: center;*/ padding: 5px; border-width: 0; background-color: rgb(235, 235, 228); height: 36px;">
                        </td>
                        <td style="width: 100%; border-left: 1px solid #ccc;">
                            <div id="formulabox" contenteditable="true" spellcheck="false" style="overflow: hidden; height: 36px; width: 100%; padding: 9px;"></div>
                            <div class="vertical-splitter ui-draggable" id="verticalSplitter"></div>
                        </td>
                    </tr>
                </tbody>
            </table>
            <div class="spread-container" id="controlPanel" style="height: 600px; bottom: 0;">
                <div id="ss" style="height: 100%; border: 1px solid #ddd;"></div>
            </div>
        </div>
    </form>
</body>
</html>
