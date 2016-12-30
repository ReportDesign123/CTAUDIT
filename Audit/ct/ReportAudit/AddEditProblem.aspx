<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddEditProblem.aspx.cs" Inherits="Audit.ct.ReportAudit.AddEditProblem" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <script src="../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <link href="../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="../../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script src="../../Scripts/AjaxTrigger.js" type="text/javascript"></script>

   <script src="../../lib/Editor/kindeditor-min.js" type="text/javascript"></script>
    <link href="../../lib/Editor/themes/default/default.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/Editor/lang/zh_CN.js" type="text/javascript"></script>

</head>
<body>
 <script type="text/javascript">
     var problemType = "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Get + "&MethodName=GetDictionaryListByClassType&FunctionName=" + BasicAction.Functions.DictionaryManager + "&ClassType=WTLB";
     var problemLevel = "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Get + "&MethodName=GetDictionaryListByClassType&FunctionName=" + BasicAction.Functions.DictionaryManager + "&ClassType=WTJB";

     //获取参数
     function getParameters(actionType, methodName) {
         var params = {};

         params["Title"] = $("#Title").val();
         params["DependOn"] = $("#DependOn").val();
         params["Type"] = $('#Type').combobox('getValue');
         params["Rank"] = $("#Rank").combobox('getValue');

         params["ActionType"] = actionType;
         params["FunctionName"] = ReportProblemAvtion.Functions.ReportProblem;
         params["MethodName"] = methodName;

         var contentIf = getGridIframe();
         if (contentIf && contentIf != "") {
             params["Content"] = contentIf.getHtml();
         } else {
             MessageManager.InfoMessage("问题内容获取失败！");
             return;
         }
         if (params.DependOn == "") {
             MessageManager.InfoMessage("请输入创建依据！");
             return;
         }
         if (params.Type == "") {
             MessageManager.InfoMessage("请选择问题类型");
             return;
         }
         if (params.Content == "") {
             MessageManager.InfoMessage("请添加问题内容！");
             return;
         }
         var id = $("#Id").val();
         if (id != null && id != undefined && id != "") {
             params["Id"] = id;
         }
         return params;
     }
     ///调用参数：<iframe id="Frame"...></iframe>
     ///用途：获取Frame对象
     ///张双义
     function getGridIframe() {
         gridFrame = window.frames["editFrame"];
         return gridFrame;
     }
     function setFrameHtml() {
         var frame = getGridIframe();
         frame.setHtml($("#ProblemContent").html());
     }
   </script>
     <input id="Id" value="<%=rpe.Id %>"type="hidden"/>  
     <div style=" display:none" id="ProblemContent" ><%=rpe.Content %></div>
        <table style="margin:auto; margin-top:15px;  padding:0px;">
           <tr style=" height:33px"><td>疑点标题：</td><td><input id="Title" type="text" value="<%=rpe.Title %>" class="easyui-validatebox textbox" style=" width:240px; height:25px;" /></td></tr>
           <tr style=" height:33px"><td>创建依据：</td><td><input id="DependOn" type="text"value="<%=rpe.DependOn %>" class="easyui-validatebox textbox" style=" width:240px; height:25px;"/></td></tr>   
           <tr style=" height:33px"><td>疑点类型：</td><td><input id="Type" type="text"value="<%=rpe.Type %>" class="easyui-combobox" data-options=" valueField:'Code', textField:'Name',url:problemType"  style="height:29px;width:244px"/></td></tr>
           <tr style=" height:33px"><td>疑点级别：</td><td><input id="Rank" type="text" value="<%=rpe.Rank %>"class="easyui-combobox" data-options=" valueField:'Code', textField:'Name',url:problemLevel" style="height:29px;width:244px" /></td></tr>
           <tr><td style="height:25px;">疑点内容：</td></tr>  
        </table>
        <table style="margin-left:12px;padding:0px; overflow:hidden">
           <tr>
               <td style=" padding:0px">
               <iframe id="editFrame" src="Editor.aspx" frameborder="0" style=" width:380px; height:200px;padding:0px;overflow:hidden;margin:0px"onload="setFrameHtml();"></iframe>
               </td>
           </tr>

        </table>
        
</body>
</html>

