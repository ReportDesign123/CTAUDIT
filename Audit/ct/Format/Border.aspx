<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Border.aspx.cs" Inherits="Audit.ct.Format.Border" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>边框</title>
    <link href="../../Styles/default.css" rel="stylesheet" type="text/css" />
      <script src="../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
      <script type="text/javascript">
          $(function () {
              $.each($(".ke-colorpicker-cell"), function () {
                  $(this).bind("mouseover", function () {
                      $(this).css("border", "1px solid #5690D2");
                  });
                  $(this).bind(
            "mouseout", function () {
                $(this).css("border", "");
            });
                  $(this).bind("click", function () {

                      var para = { Edge: "", LineStyle: "" };
                      if ($(this).attr("title") == "cellNone") {
                          para.Edge = 9;
                          para.LineStyle = 0;
                      } else if ($(this).attr("title") == "cellTop") {
                          para.Edge = 2;
                          para.LineStyle = 1;
                      } else if ($(this).attr("title") == "cellBottom") {
                          para.Edge = 3;
                          para.LineStyle = 1;
                      } else if ($(this).attr("title") == "cellLeft") {
                          para.Edge = 0;
                          para.LineStyle = 1;
                      } else if ($(this).attr("title") == "cellRight") {
                          para.Edge = 1;
                          para.LineStyle = 1;
                      } else if ($(this).attr("title") == "cellDiagonalUp") {
                          para.Edge = 6;
                          para.LineStyle = 1;
                      } else if ($(this).attr("title") == "cellDiagonalDown") {
                          para.Edge =7;
                          para.LineStyle = 1;
                      } else if ($(this).attr("title") == "cellInsideHInsideV") {
                          para.Edge = 5 + "|" + 4;
                          para.LineStyle = 1 + "|" + 1;
                      } else if ($(this).attr("title") == "cellOutsideThin") {
                          para.Edge = 8;
                          para.LineStyle = 1;
                      } else if ($(this).attr("title") == "cellOutsideThick") {
                          para.Edge = 8;
                          para.LineStyle = 2;
                      } else if ($(this).attr("title") == "cellAllThin") {
                          para.Edge =8+"|"+4+"|"+5;
                          para.LineStyle = 1 + "|" + 1 + "|" + 1;
                      } else if ($(this).attr("title") == "cellOutThickInsideThin") {
                          para.Edge = 8 + "|" + 4 + "|" + 5;
                          para.LineStyle = 2 + "|" + 1 + "|" + 1;
                      }                      
                      window.returnValue = para;
                      window.close();
                  });
              });
          });

           function GetEdgeAndLineStyle(){
                       
          }
      </script>
</head>
<body>
     <table  style="width:100%" >
   <tr>
    <td class="ke-colorpicker-cell" title="cellNone" >
    <div  class="cellNone"></div>
    </td>
     <td class="ke-colorpicker-cell"  title="cellTop"  >
    <div class=" cellTop"  ></div>
    </td>
     <td class="ke-colorpicker-cell"  title="cellBottom" >
    <div class=" cellBottom"  ></div>
    </td>
     <td class="ke-colorpicker-cell"  title="cellLeft"  >
    <div class=" cellLeft" ></div>
    </td>
    
    </tr>
    <tr>
     <td class="ke-colorpicker-cell"  title="cellRight" >
    <div class=" cellRight"  ></div>
    </td>
     <td class="ke-colorpicker-cell"  title="cellDiagonalUp" >
    <div class=" cellDiagonalUp" ></div>
    </td>
     <td class="ke-colorpicker-cell"  title="cellDiagonalDown" >
    <div class=" cellDiagonalDown "  ></div>
    </td>
     <td class="ke-colorpicker-cell"  title="cellInsideHInsideV" >
    <div class=" cellInsideHInsideV" ></div>
    </td>
    </tr>

      <tr>
     <td class="ke-colorpicker-cell"  title="cellOutsideThin" >
    <div class=" cellOutsideThin"  ></div>
    </td>
     <td class="ke-colorpicker-cell" >
    <div class=" cellOutsideThick"  title="cellOutsideThick" ></div>
    </td>
     <td class="ke-colorpicker-cell"  title="cellAllThin" >
    <div class=" cellAllThin"  ></div>
    </td>
     <td class="ke-colorpicker-cell" title="cellOutThickInsideThin"  >
    <div class=" cellOutThickInsideThin" ></div>
    </td>
    </tr>


    </table>
</body>
</html>
