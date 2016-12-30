<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ColorPick.aspx.cs" Inherits="Audit.ct.Format.ColorPick" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <link href="../../Styles/default.css" rel="stylesheet" type="text/css" />
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
                    var titleColor = $(this).attr("title");
                    window.returnValue = titleColor;
                    window.close();
                });
            });
        });
    </script>
</head>
<body>
    <table class="ke-colorpicker-table" >
    <tr><td colspan="6" class="ke-colorpicker-cell-top" title="无颜色">拾色器</td></tr>
<%--第一行--%>
    <tr>
    <td class="ke-colorpicker-cell" title="#000000">
    <div class="ke-colorpicker-cell-color"  style="background-color:#000000;"></div>
    </td>
     <td class="ke-colorpicker-cell" title="#993300">
    <div class="ke-colorpicker-cell-color"  style="background-color:#993300;"></div>
    </td>
     <td class="ke-colorpicker-cell" title="#333300">
    <div class="ke-colorpicker-cell-color"  style="background-color: #333300;"></div>
    </td>
     <td class="ke-colorpicker-cell" title="#003300">
    <div class="ke-colorpicker-cell-color"  style="background-color: #003300;"></div>
    </td>
     <td class="ke-colorpicker-cell" title="#003366">
    <div class="ke-colorpicker-cell-color"  style="background-color:#003366;"></div>
    </td>
     <td class="ke-colorpicker-cell" title="#000080">
    <div class="ke-colorpicker-cell-color"  style="background-color:  #000080;"></div>
    </td>
    <td class="ke-colorpicker-cell" title="#333399">
    <div class="ke-colorpicker-cell-color"  style="background-color:#333399;"></div>
    </td>
     <td class="ke-colorpicker-cell" title="#333333">
    <div class="ke-colorpicker-cell-color"  style="background-color:#333333;"></div>
    </td>      
    </tr>
  <%--  第二行--%>
   <tr>
    <td class="ke-colorpicker-cell" title="#800000">
    <div class="ke-colorpicker-cell-color"  style="background-color:#800000;"></div>
    </td>
     <td class="ke-colorpicker-cell" title="#FF6600">
    <div class="ke-colorpicker-cell-color"  style="background-color:#FF6600;"></div>
    </td>
     <td class="ke-colorpicker-cell" title="#808000">
    <div class="ke-colorpicker-cell-color"  style="background-color: #808000;"></div>
    </td>
     <td class="ke-colorpicker-cell" title="#008000">
    <div class="ke-colorpicker-cell-color"  style="background-color: #008000;"></div>
    </td>
     <td class="ke-colorpicker-cell" title="#008080">
    <div class="ke-colorpicker-cell-color"  style="background-color:#008080;"></div>
    </td>
     <td class="ke-colorpicker-cell" title="#0000FF">
    <div class="ke-colorpicker-cell-color"  style="background-color:  #0000FF;"></div>
    </td>
    <td class="ke-colorpicker-cell" title="#666699">
    <div class="ke-colorpicker-cell-color"  style="background-color:#666699;"></div>
    </td>
     <td class="ke-colorpicker-cell" title="#808080 ">
    <div class="ke-colorpicker-cell-color"  style="background-color:#808080;"></div>
    </td>      
    </tr>
     <%--  第三行--%>
   <tr>
    <td class="ke-colorpicker-cell" title="#FF0000">
    <div class="ke-colorpicker-cell-color"  style="background-color:#FF0000;"></div>
    </td>
     <td class="ke-colorpicker-cell" title="#FF9900">
    <div class="ke-colorpicker-cell-color"  style="background-color:#FF9900;"></div>
    </td>
     <td class="ke-colorpicker-cell" title="#99CC00">
    <div class="ke-colorpicker-cell-color"  style="background-color: #99CC00;"></div>
    </td>
     <td class="ke-colorpicker-cell" title="#339966">
    <div class="ke-colorpicker-cell-color"  style="background-color: #339966;"></div>
    </td>
     <td class="ke-colorpicker-cell" title="#33CCCC">
    <div class="ke-colorpicker-cell-color"  style="background-color:#33CCCC;"></div>
    </td>
     <td class="ke-colorpicker-cell" title="#3366FF">
    <div class="ke-colorpicker-cell-color"  style="background-color:  #3366FF;"></div>
    </td>
    <td class="ke-colorpicker-cell" title="#800080">
    <div class="ke-colorpicker-cell-color"  style="background-color:#800080;"></div>
    </td>
     <td class="ke-colorpicker-cell" title="#969696 ">
    <div class="ke-colorpicker-cell-color"  style="background-color:#969696;"></div>
    </td>      
    </tr>

     <%--  第四行--%>
   <tr>
    <td class="ke-colorpicker-cell" title="#FF00FF">
    <div class="ke-colorpicker-cell-color"  style="background-color:#FF00FF;"></div>
    </td>
     <td class="ke-colorpicker-cell" title="#FFCC00">
    <div class="ke-colorpicker-cell-color"  style="background-color:#FFCC00;"></div>
    </td>
     <td class="ke-colorpicker-cell" title="#FFFF00">
    <div class="ke-colorpicker-cell-color"  style="background-color: #FFFF00;"></div>
    </td>
     <td class="ke-colorpicker-cell" title="#00FF00">
    <div class="ke-colorpicker-cell-color"  style="background-color: #00FF00;"></div>
    </td>
     <td class="ke-colorpicker-cell" title="#00FFFF">
    <div class="ke-colorpicker-cell-color"  style="background-color:#00FFFF;"></div>
    </td>
     <td class="ke-colorpicker-cell" title="#00CCFF">
    <div class="ke-colorpicker-cell-color"  style="background-color:  #00CCFF;"></div>
    </td>
    <td class="ke-colorpicker-cell" title="#993366">
    <div class="ke-colorpicker-cell-color"  style="background-color:#993366;"></div>
    </td>
     <td class="ke-colorpicker-cell" title="#C0C0C0">
    <div class="ke-colorpicker-cell-color"  style="background-color:#C0C0C0;"></div>
    </td>      
    </tr>    
     <%--  第五行--%>
   <tr>
    <td class="ke-colorpicker-cell" title="#FF99CC">
    <div class="ke-colorpicker-cell-color"  style="background-color:#FF99CC;"></div>
    </td>
     <td class="ke-colorpicker-cell" title="#FFCC99">
    <div class="ke-colorpicker-cell-color"  style="background-color:#FFCC99;"></div>
    </td>
     <td class="ke-colorpicker-cell" title="#FFFF99">
    <div class="ke-colorpicker-cell-color"  style="background-color: #FFFF99;"></div>
    </td>
     <td class="ke-colorpicker-cell" title="#CCFFCC">
    <div class="ke-colorpicker-cell-color"  style="background-color: #CCFFCC;"></div>
    </td>
     <td class="ke-colorpicker-cell" title="#CCFFFF">
    <div class="ke-colorpicker-cell-color"  style="background-color:#CCFFFF;"></div>
    </td>
     <td class="ke-colorpicker-cell" title="#99CCFF">
    <div class="ke-colorpicker-cell-color"  style="background-color:  #99CCFF;"></div>
    </td>
    <td class="ke-colorpicker-cell" title="#CC99FF">
    <div class="ke-colorpicker-cell-color"  style="background-color:#CC99FF;"></div>
    </td>
     
    <td class="ke-colorpicker-cell" title="#CCCCFF">
    <div class="ke-colorpicker-cell-color"  style="background-color:#CCCCFF;"></div>
    </td>      
    </tr>
      <%--  第六行--%>
   <tr>
    <td class="ke-colorpicker-cell" title="#9999FF">
    <div class="ke-colorpicker-cell-color"  style="background-color:#9999FF;"></div>
    </td>
     <td class="ke-colorpicker-cell" title="#993366">
    <div class="ke-colorpicker-cell-color"  style="background-color:#993366;"></div>
    </td>
     <td class="ke-colorpicker-cell" title="#FFFFCC">
    <div class="ke-colorpicker-cell-color"  style="background-color: #FFFFCC;"></div>
    </td>
     <td class="ke-colorpicker-cell" title="#CCFFFF">
    <div class="ke-colorpicker-cell-color"  style="background-color: #CCFFFF;"></div>
    </td>
     <td class="ke-colorpicker-cell" title="#660066">
    <div class="ke-colorpicker-cell-color"  style="background-color:#660066;"></div>
    </td>
     <td class="ke-colorpicker-cell" title="#FF8080">
    <div class="ke-colorpicker-cell-color"  style="background-color:#FF8080;"></div>
    </td>
    <td class="ke-colorpicker-cell" title="#0066CC">
    <div class="ke-colorpicker-cell-color"  style="background-color:#0066CC;"></div>
    </td>
         <td class="ke-colorpicker-cell" title="#FFFFFF">
    <div class="ke-colorpicker-cell-color"  style="background-color:#FFFFFF;"></div>
    </td>  
    </tr>
   
    </table>
</body>
</html>
