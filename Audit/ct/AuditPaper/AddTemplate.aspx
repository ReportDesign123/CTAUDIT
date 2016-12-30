<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddTemplate.aspx.cs" Inherits="Audit.ct.AuditPaper.AddTemplate" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" >
    <title></title>
</head>
<body>

    <form id="TemplateForm"   action=""   method="post"  enctype="multipart/form-data">
       <input id="Hidden1" name="ActionType" type="hidden" value="grid"/>
   <input id="Hidden2" name="MethodName" type="hidden"  value="Save"/>
   <input id="Hidden3" name="FunctionName" type="hidden"  value="AuditPaperMenu"/>
     <input id="Id" value="<%=rte.Id %>" name="Id"  type="hidden"/>
   <table style="margin:auto; padding:20px;">

   <tr style="height:30px;"><td>编号</td><td><input id="Code" name="Code" value="<%=rte.Code %>" type="text"   style="height:20px;width:170px;line-height: 25px;"/></td></tr>
   <tr><td>名称</td><td><input id="Name" type="text" value="<%=rte.Name %>" name="Name" style="height:20px;width:170px"/></td></tr>
     <tr><td>模板报告描述</td><td><textarea id="Description" name="Description"    style=" width:170px; border:1px solid #95B8E7; height:60px;"><%=rte.Description %></textarea></td></tr>
      <tr><td>报告模板选择</td><td>
     
      <div  style=" width:350px; height:100px; overflow:auto;background-color:#D4EDF9;  border: 1px solid #95B8E7; ">
      <table id="upTable" style=" width:350px" >
      <tr  ><td><input type="file" name="file1"   class="file"  style=" width:170px; "/>
       <%--&nbsp;<input type="button"  onclick="upLoadFileManager.AddUploadFile()" value="添加"/>--%>
       <br />
       <span><%=rte.AttatchName%></span>
       </td></tr>
       </table>
       </div>
        </td>
        </tr>
      </table> 
      </form>
          <script src="../../Scripts/Ct_Upload.js" type="text/javascript"></script>
</body>
</html>

