<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Test.aspx.cs" Inherits="Audit.ct.ReportData.Test" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title> 



    <link href="../../lib/ligerUI/skins/Aqua/css/ligerui-dialog.css" rel="stylesheet"
        type="text/css" />
       <link href="../../lib/ligerUI/skins/ligerui-icons.css" rel="stylesheet" type="text/css" />
    <link href="../../lib/ligerUI/skins/Aqua/css/ligerui-all.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/jquery/jquery-1.3.2.min.js" type="text/javascript"></script>

    <script src="../../lib/ligerUI/js/core/base.js" type="text/javascript"></script>
    <script src="../../lib/ligerUI/js/core/inject.js" type="text/javascript"></script>
    <script src="../../lib/ligerUI/js/plugins/CT_ligerDialog.js" type="text/javascript"></script>
    <script src="../../lib/ligerUI/js/plugins/ligerDrag.js" type="text/javascript"></script>
    <script src="../../lib/ligerUI/js/plugins/ligerResizable.js" type="text/javascript"></script>

    <link href="../../Styles/Common.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        .listBox
        {
            border: 1px solid #AECAF0;
            background: white;
            font-size: 12px;
            line-height: 18px;
        }
        .listBoxInner
        {
            width: 100%;
            height: 100%;
            overflow: auto;
            color: #333;
             margin:0;
              padding:0;
        }
        .listBoxTable
        {
            margin: 0px;
            padding: 0px;
            width: 100%;
        }
        .listbox td
        {
          padding:2px; text-align:left;border-top:1px solid #ffffff;border-bottom:1px solid #fff;
        }
        
        .l-checkboxlist td {
	 padding: 2px 4px;
       }
       
       .listBox tr:hover
       {
           background-color:#DFE8F6; cursor:pointer; border-bottom:1px dotted #89A8E3;border-top:1px dotted #89A8E3;  
       }
    
       
      <%-- .listBox tr{ background-color:#C6D7EF;border-bottom:1px dotted #89A8E3;border-top:1px dotted #89A8E3;}--%>
    </style>
    <script type="text/javascript">


        function clickB() {
            $.ligerDialog.open({
                height: 200,
                width: 200,
                title: '打开窗口提示',                
                showMax: false,
                showToggle: true,
                showMin: false,
                isResize: true,
                slide: false,
                modal:false
            });
        }
    </script>
</head>
<body>
<%--<div  style=" display:block">--%>
<%--    <select id="Select1">
<option>test</option>
<option>test</option>
<option>test</option>
        <option>test</option>
    </select>
    </div>--%>
    <iframe src="Test2.aspx" frameborder="0" width="800" height="600"></iframe>
    <input  type="button" value="单机" onclick="clickB()"/>
<%--    <div id="ctList" class="listBox" style=" width:100px; height:200px;">
       <div id="ctInnerList" class="listBoxInner">
        <table cellpadding="0" cellspacing="0" border="0"  class="listBoxTable">
        <tr><td style=" width:18px;"><input type="checkbox" /></td><td align="left">张三</td></tr>
         <tr><td style=" width:18px;"><input type="checkbox" /></td><td align="left">张三</td></tr>
          <tr><td style=" width:18px;"><input type="checkbox" /></td><td align="left">张三</td></tr>
           <tr><td style=" width:18px;"><input type="checkbox" /></td><td align="left">张三</td></tr>
            <tr><td style=" width:18px;"><input type="checkbox" /></td><td align="left">张三</td></tr>
             <tr><td style=" width:18px;"><input type="checkbox" /></td><td align="left">张三</td></tr>
              <tr><td style=" width:18px;"><input type="checkbox" /></td><td align="left">张三</td></tr>
               <tr><td style=" width:18px;"><input type="checkbox" /></td><td align="left">张三</td></tr>
 <tr><td style=" width:18px;"><input type="checkbox" /></td><td align="left">张三</td></tr>
  <tr><td style=" width:18px;"><input type="checkbox" /></td><td align="left">张三</td></tr>
   <tr><td style=" width:18px;"><input type="checkbox" /></td><td align="left">张三</td></tr>
 <tr><td style=" width:18px;"><input type="checkbox" /></td><td align="left">张三</td></tr>
                <tr><td style=" width:18px;"><input type="checkbox" /></td><td align="left">张三</td></tr>
        </table>
       </div>
    </div>--%>
    <div id="dialog" ></div>
</body>
</html>
