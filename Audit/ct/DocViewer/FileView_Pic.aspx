<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FileView_Pic.aspx.cs" Inherits="Audit.ct.DocViewer.FileView_Pic" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>查看图片</title>
    <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=no"/>
    <script type="text/javascript" src="../../lib/js/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="../../lib/js/jQuery.autoIMG.js"></script>
    <script type="text/javascript" src="../../lib/js/jQuery.rotate.js"></script>
    <style type="text/css">
        body{text-align:center;background-color:#fffaf0;padding:2px;margin:0px;}
        .mainPanel{margin-left:auto;margin-right:auto;}
        .toolbar{padding:5px 10px;position:fixed;left:0px;bottom:0px;border-top:solid 1px #100000;background-color:#aaa;width:100%;}
        .toolbar a{color:blue;text-decoration:none;font-size:12px;}
        .toolbar a:hover{color:red;}
    </style>
    <script type="text/javascript">
       
        jQuery(function () {
            $('.mainPanel').autoIMG();
            $('.turnLeft').click(function () { $('#mainPic').rotateLeft(); });
            $('.turnRight').click(function () { $('#mainPic').rotateRight(); });
        });
    </script>
</head>
<body>
    <div class="toolbar">
        <a class="zoomIn" href="javascript:">放大[+10%]</a>&nbsp;&nbsp;
        <a class="zoomIn" href="javascript:">正常大小</a>&nbsp;&nbsp;
        <a class="zoomOut" href="javascript:">缩小[-10%]</a>&nbsp;&nbsp;&nbsp;
        <a class="turnLeft" href="javascript:">左转[90度]</a>&nbsp;&nbsp;
        <a class="turnRight" href="javascript:">右转[90度]</a>
    </div>
    <div class="mainPanel">
        <img id="mainPic" src="fileDown.aspx?fileId=<%=FileId%>" alt="查看图片" />
    </div>
</body>
</html>