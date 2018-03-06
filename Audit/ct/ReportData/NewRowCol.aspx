<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="NewRowCol.aspx.cs" Inherits="Audit.ct.ReportData.NewRowCol" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>选择插入行(列)数  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</title>
    <script src="../../lib/jquery/jquery-1.5.2.min.js" type="text/javascript"></script>
    <link href="../../lib/ligerUI/skins/ligerui-icons.css" rel="stylesheet" type="text/css" />  
    <link href="../../lib/ligerUI/skins/Aqua/css/ligerui-all.css" rel="stylesheet"
        type="text/css" />
     <script src="../../lib/ligerUI/js/core/base.js" type="text/javascript"></script>
    <script src="../../lib/ligerUI/js/ligerui.min.js" type="text/javascript"></script>
    <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>

    <link href="../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="../../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
     <script src="../../Scripts/ct_dialog.js"></script>
     <script src="../../Scripts/Ct_Controls.js" type="text/javascript"></script>
    <link href="../../Styles/Ct_Controls.css" rel="stylesheet" type="text/css" /> 
 
    <style type="text/css">    
        body{ font-size:12px;}
        .l-table-edit {} 
        .l-table-edit-td{ padding:4px; width:190px;}
        .l-button-submit,.l-button-reset{width:80px; float:left; margin-left:10px; padding-bottom:2px;}
        .l-verify-tip{ left:230px; top:120px;}

      
    </style>
    <script type="text/javascript">
        var controls = {RowCol:{} };
        var zqUrl = "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Get + "&MethodName=GetDictionaryListByClassType&FunctionName=" + BasicAction.Functions.DictionaryManager + "&ClassType=BBZQ";
        $(function () {
            controls.RowCol = $("#RowCol").ligerTextBox({ nullText: '不能为空' });          
            $("#sure").bind("click", function () {
                var para = {};
                if (!controls.RowCol.getValue()) { alert("输入不能为空"); return; }
                para["RowCol"] = controls.RowCol.getValue();
                var modalid = $(window.frameElement).attr("modalid");
                dialog.setVal(para);
                dialog.close(modalid);
            });
            $("#cancel").bind("click", function () {
                var modalid = $(window.frameElement).attr("modalid");
                controls.RowCol = null;
                dialog.close(modalid);
            });
        });
    </script>

</head>
<body>
  <table cellpadding="0" cellspacing="0" class="l-table-edit"  style="width:100%;height:95%; margin-top:40px">
  <tr>
  <td align="right" >行(列)数</td><td class="l-table-edit-td"><input name="RowCol" type="text" id="RowCol"/></td>
  </tr>
  <tr>
  <td colspan="2" class="l-table-edit-td" style="text-align:right; vertical-align:bottom; padding-top:30px;">
      <input id="sure" class="l-button" type="button" value="确 &nbsp 定" onmouseover="this.style.background='lightblue'"onmouseout="this.style.backgroundColor='';"/> 
      <input id="cancel" type="button" class="l-button" value="取 &nbsp 消" onmouseover="this.style.background='lightblue'"onmouseout="this.style.backgroundColor='';" /></td>
  </tr>
  </table>
</body>
</html>

