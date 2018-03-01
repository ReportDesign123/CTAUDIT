<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FileViewerGroup.aspx.cs" Inherits="AduitXm.ct.DocViewer.FileViewerGroup" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title><%=fileTitle %></title>
    <meta http-equiv="Expires" content="0"/>
    <meta http-equiv="Cache-Control" content="no-cache"/>
    <meta http-equiv="Pragma" content="no-cache"/>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link rel="stylesheet" type="text/css" href="../../Styles/layout-default-latest.css" />
	
	<style type="text/css">
		*{margin:0px;padding:0px;}
		.ui-layout-north,
		.ui-layout-center ,	/* has content-div */
		.ui-layout-west ,	/* has Accordion */
		.ui-layout-east ,	/* has content-div ... */
		.ui-layout-east .ui-layout-content { /* content-div has Accordion */
			padding: 0px;
			margin:0px;
			overflow: hidden;
			background-color:#f5f5f5;
		}
		.ui-layout-mask {
			opacity: 0.2 !important;
			filter:	 alpha(opacity=20) !important;
			background-color: #666 !important;
		}
		ul{}
		li{
            padding-left:10px;height:30px;line-height:30px;
            background:#eee url(../DocViewer/topbar.gif) repeat-x;
            border-bottom:1px solid #99BBE8;
            word-break:keep-all;
		    white-space:nowrap;
		    overflow:hidden;
		    text-overflow:ellipsis;
            padding-right:10px;
            font-size:12px;
            }
		li a{text-decoration:none;color:blue;background:transparent url(../DocViewer/bullet.gif) no-repeat left center;padding-left:14px;display:block;}
		li a:hover{text-decoration:none;color:red;}
        li.sellink a{color:red;}
	</style>
	<!-- REQUIRED scripts for layout widget -->
	<script type="text/javascript" src="../../lib/js/jquery.js"></script>
	<script type="text/javascript" src="../../lib/js/jquery.layout.js"></script>
    <script type="text/javascript" src="../../lib/js/Fader.js"></script> 
    <script type="text/javascript" src="../../lib/js/jquery.cookie.js"></script>
	<script type="text/javascript">  

	    var myLayout; // init global vars
	    var tabpanel;

	    function closeAllPanel() {
	        $.each('north,south,west,east'.split(','), function () { myLayout.close(this); });
	    }
	    function openAllPanel() {
	        $.each('north,south,west,east'.split(','), function () { myLayout.open(this); });
	    }
	    function toggleAllPanel() {
	        $.each('north,south,west,east'.split(','), function () { myLayout.toggle(this); });
	    }
	    function toggleLeftPanel() {
	        myLayout.toggle("west");
	    }
	    $(function () {
	        myLayout = $('body').layout({
	            spacing_open: 6
            , spacing_closed: 15
            , togglerTip_open: "关闭"
            , togglerTip_closed: "打开"
			, east__size: 280
            , maskIframesOnResize: true
		    , east__onresize: function () { $("#accordion1").accordion("resize"); }
		    , center__onresize: function () { tabpanel.resize(); }
		    , north__resizable: false
		    , north__toggler: false
		    , east__toggler: false
	        });
	        $("li>a").click(function () {
	            $(this).parent().siblings().removeClass("sellink");
	            $(this).parent().addClass("sellink");
	            document.title = $(this).text();
	        });
	    });
	    function menuClick(item) {
	        var d = new Date();
	        if (item.value)
	            tabpanel.addTab({ id: item.id, title: item.text, html: '<iframe src="' + item.value + '" width="100%" height="100%" frameborder="0"></iframe>' });
	    }
	    function addTab(tabId, tabTitle, tabUrl) {
	        tabpanel.addTab({ id: tabId, title: tabTitle, html: '<iframe src="' + tabUrl + '" width="100%" height="100%" frameborder="0"></iframe>' });
	    }
	    document.execCommand("BackgroundImageCache", false, true);

	</script>
</head>
<body>
  <iframe id="view" name="view" class="ui-layout-center" width="100%" height="100%" frameborder="0" scrolling="auto" src="<%=firstLink %>"></iframe>
  <div class="ui-layout-east" style="display: none;overflow:auto;">
	<ul style="">
        <%=sbList %>
	</ul>
</div>
</body>
</html> 
