<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddCpara.aspx.cs" Inherits="Audit.ct.basic.AddCpara" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
      <script src="../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <link href="../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="../../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <link href="../../Styles/Common.css" rel="stylesheet" type="text/css" />
    <link href="../../Styles/Ct_Controls.css" rel="stylesheet" type="text/css" />
    <script src="../../Scripts/Ct_Controls.js" type="text/javascript"></script>
    <script src="../../lib/json2.js" type="text/javascript"></script>
</head>
<body>
    <script src="../../Scripts/ct/pub/PubHelp.js" type="text/javascript"></script>
   <script type="text/javascript">

       var CparaUrl = "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Post + "&MethodName=" + BasicAction.Methods.CparasManagerMethods.GetParaList + "&FunctionName=" + BasicAction.Functions.CparasManager;
       var cparaGrid = "../../handler/BasicHandler.ashx?ActionType=grid&MethodName=GetParasList&FunctionName=DictionaryManager";
//       var CparaUrl = "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Post + "&MethodName=" + BasicAction.Methods.UserManagerMethods.RoleCombox + "&FunctionName=" + BasicAction.Functions.UserManager;
//       var cparaGrid = "../../handler/BasicHandler.ashx?ActionType=grid&MethodName=DataGrid&FunctionName=Role";
     
       //获取参数
       function getParameters(actionType, methodName) {
    /*       var entity = {};
           var params = {};
           params["Code"] = $("#Code").val();
           params["Name"] = $("#Name").val();
           params["CONTENT"] = $("#CONTENT").val();
           params["SPARA"] = ""; // controls.Sparas;
        
           var id = $("#Id").val();
           if (id != null && id != undefined && id != "") {
               params["Id"] = id;
           }
           if (!params["Code"]) {
               alert("请输入账号");
               return;
           }
           if (!params["Name"]) {
               alert("请输入名称");
               return;
           }
           if (!params["CONTENT"]) {
               alert("请输入内容");
               return;
           }
         
           params["entity"] = JSON2.stringify(entity);
           params["ActionType"] = actionType;
           params["FunctionName"] = BasicAction.Functions.CparasManager;
           params["MethodName"] = methodName;
           return params;*/

           var params = {};
           params["Code"] = $("#Code").val();
           params["Name"] = $("#Name").val();

           params["CONTENT"] = $("#CONTENT").val();
           params["SPARA"] = $("#SPARA").val();

           params["ActionType"] = actionType;
           params["FunctionName"] = BasicAction.Functions.CparasManager;
           params["MethodName"] = methodName;
           var id = $("#Id").val();
           if (id != null && id != undefined && id != "") {
               params["Id"] = id;
           }
           return params;
       }
      
    </script>
     <input id="Id" value="<%=cparaEntity.Id %>"  type="hidden"/>

    <table style="margin:auto; padding:20px 0px 0px 30px;" cellspacing="10px">
        <tr style="height:30px;"><td>编号</td><td><input id="Code" value="<%=cparaEntity.Code %>" type="text" class="easyui-validatebox textbox" /></td></tr>
        <tr><td>名称</td><td><input id="Name" type="text" value="<%=cparaEntity.Name %>"  class="easyui-validatebox textbox" /></td></tr>
        <tr><td>内容</td><td><input id="CONTENT" type="text" value="<%=cparaEntity.CONTENT %>"  class="easyui-validatebox textbox" /></td></tr>
        <tr><td>系统变量</td><td><input id="SPARA" type="text" value="<%=cparaEntity.SPARA %>"  class="easyui-validatebox textbox" /></td></tr>
       
    </table>
</body>
</html>
