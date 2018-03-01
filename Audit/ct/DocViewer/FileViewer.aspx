<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FileViewer.aspx.cs" Inherits="Audit.ct.DocViewer.FileViewer" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title><%=fileName%></title>
    <style type="text/css" media="screen">
		html, body{ height:100%; margin:0; }
		body { padding:0; overflow:hidden; text-align:center;}
		#flashContent { display:none; }
    </style>

     <script src="../../lib/js/jquery-1.7.2.min.js" type="text/javascript"></script>
	<script type="text/javascript" src="../../lib/js/swfobject.js"></script>
</head>
<body>
    <form id="form1" runat="server">
    	<div id="pdiv" style="margin-left:auto;margin-right:auto;">
	        <div id="flashContent">
                <h3 style="color:Red;margin-top:40px;">本文档不支持在线预览，请下载查看！</h3>
	        </div>
        </div>
    </form>
</body>
</html>
<script type="text/javascript">
    $("#pdiv").height($(window).height());
    if ("<%=viewFlag %>" == "1") {
        $("#flashContent").show();
    }
</script>
<script type="text/javascript">
    var swfVersionStr = "10.0.0";
    var xiSwfUrlStr = "expressInstall.swf";
    var flashvars = {
        SwfFile: escape('FileToSWF.aspx?fileId=<%=FileId%>'),
        Scale: 0.6,
        ZoomTransition: "easeOut",
        ZoomTime: 0.5,
        ZoomInterval: 0.1,
        FitPageOnLoad: false,
        FitWidthOnLoad: true,
        PrintEnabled: true,
        FullScreenAsMaxWindow: false,
        ProgressiveLoading: true,
        PrintToolsVisible: true,
        ViewModeToolsVisible: true,
        ZoomToolsVisible: true,
        FullScreenVisible: true,
        NavToolsVisible: true,
        CursorToolsVisible: true,
        SearchToolsVisible: true,
        localeChain: "zh_CN"
    };

    var params = {};
    params.quality = "high";
    params.bgcolor = "#ffffff";
    params.allowscriptaccess = "sameDomain";
    params.allowfullscreen = "true";
    var attributes = {};
    attributes.id = "FlexPaperViewer";
    attributes.name = "FlexPaperViewer";
    if ("<%=viewFlag %>" == "1") {
        swfobject.embedSWF(
        "FlexPaperViewer.swf", "flashContent",
        "100%", "100%",
        swfVersionStr, xiSwfUrlStr,
        flashvars, params, attributes);
        swfobject.createCSS("#flashContent", "display:block;");
    }
</script>
