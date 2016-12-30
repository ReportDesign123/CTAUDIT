<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddUser.aspx.cs" Inherits="Audit.ct.basic.AddUser" %>

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
       var roleComb = "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Post + "&MethodName=" + BasicAction.Methods.UserManagerMethods.RoleCombox + "&FunctionName=" + BasicAction.Functions.UserManager;
       var rolGrid = "../../handler/BasicHandler.ashx?ActionType=grid&MethodName=DataGrid&FunctionName=Role";
       var orgComb = "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Post + "&MethodName=" + BasicAction.Methods.CompanyManagerMethods.ParentCombo + "&FunctionName=" + BasicAction.Functions.CompanyManager;
       var positionUrl = "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Grid + "&MethodName=" + BasicAction.Methods.PositionManagerMethods.GetPositionList + "&FunctionName=" + BasicAction.Functions.PositionManager;
       var PositionGrid = "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Grid + "&MethodName=" + BasicAction.Methods.PositionManagerMethods.GetPositionDataGrid + "&FunctionName=" + BasicAction.Functions.PositionManager;
       var controls = { Rols:[] , Positions: [] };
       var RoleName = "<%=userEntity.RoleName %>";
       var PositionName = "<%=userEntity.PositionName %>";
       var rolesStr = "<%=roles %>";
       var positionsStr = "<%=positions %>";
       $(function () {
           controls.RolesHelp = $("#Roles").PopEdit();
           controls.RolesHelp.btn.bind("click", function () {
               addRole();
           });
           controls.PositionsHelp = $("#Responsibilityies").PopEdit();
           controls.PositionsHelp.btn.bind("click", function () {
               addResponsibility();
           });
           controls.RolesHelp.name.val(RoleName);
           controls.PositionsHelp.name.val(PositionName);
           rolesStr = rolesStr.substring(0, rolesStr.length - 1);
           positionsStr = positionsStr.substring(0, positionsStr.length - 1);
           var Rols = rolesStr.split(",");
           var Positions = positionsStr.split(",");
           $.each(Rols, function (index, Id) {
               controls.Rols.push({ Id: Id });
           });
           $.each(Positions, function (index, Id) {
               controls.Positions.push({ Id: Id });
           });
       });
       var saveManager = {
           Role_save: function () {
               var result = pubHelp.getResultObj();
               if (result) {
                   var Names = "";
                   controls.Rols = [];
                   $.each(result, function (index, node) {
                       Names += node.Name + ",";
                       controls.Rols.push({ Id: node.Id });
                   });
                   Names = Names.substring(0, Names.length - 1);
                   controls.RolesHelp.name.val(Names);
               }
           },
           Responsibility_Save: function () {
               var result = pubHelp.getResultObj();
               if (result) {
                   var Names = "";
                   controls.Positions = [];
                   $.each(result, function (index, node) {
                       Names += node.Name + ",";
                       controls.Positions.push({ Id: node.Id });
                   });
                   Names = Names.substring(0, Names.length - 1);
                   controls.PositionsHelp.name.val(Names);
               }
           }
       };
       function addRole() {
           var treeParas = { idField: "", treeField: "", columns: [], url: "" };
           treeParas.url = roleComb;
           treeParas.idField = "Id";
           treeParas.treeField = "Code";
           treeParas.columns = [[
           { title: 'id', field: 'Id', width: 180, checkbox: true },
           { title: '编号', field: 'Code', width: 180 },
           { title: '角色', field: 'Name', width: 180 }
           ]];
           treeParas.sortName = 'Code';
           treeParas.sortOrder = 'ASC';
           treeParas.singleSelect=false;
           treeParas.dataUrl = rolGrid;
           treeParas.width = 450;
           treeParas.height = 450;
           pubHelp.setParameters(treeParas);
           pubHelp.OpenDialogWithHref("HelpDialog", "系统帮助", "../pub/HelpTreeDialog.aspx", saveManager.Role_save, treeParas.width, treeParas.height, true);
       }
       function addResponsibility() {
           var treeParas = { idField: "", treeField: "", columns: [], url: "" };
           treeParas.url = positionUrl;
           treeParas.idField = "Id";
           treeParas.treeField = "Code";
           treeParas.columns = [[
           { title: 'id', field: 'Id', width: 180, checkbox: true },
           { title: '编号', field: 'Code', width: 180 },
           { title: '职务', field: 'Name', width: 180 }
           ]];
           treeParas.sortName = 'Code';
           treeParas.sortOrder = 'ASC';
           treeParas.singleSelect = false;
           treeParas.dataUrl = PositionGrid 
           treeParas.width = 450;
           treeParas.height = 450;
           pubHelp.setParameters(treeParas);
           pubHelp.OpenDialogWithHref("HelpDialog", "系统帮助", "../pub/HelpTreeDialog.aspx", saveManager.Responsibility_Save, treeParas.width, treeParas.height, true);
       }
       //获取参数
       function getParameters(actionType, methodName) {
           var entity = {};
           var params = {};
           entity["Code"] = $("#Code").val();
           entity["Name"] = $("#Name").val();
           entity["Rols"] = controls.Rols;
           entity["Positions"] = controls.Positions;
           entity["OrgnizationId"] = $("#OrgnizationId").combotree("getValue");
           entity["Password"] = $("#Password").val();
           var id = $("#Id").val();
           if (id != null && id != undefined && id != "") {
               entity["Id"] = id;
           }
           if (!entity["Code"]) {
               alert("请输入账号");
               return;
           }
           if (!controls.PositionsHelp.name.val() || entity["Positions"].length == 0) {
               alert("请正确选择职务");
               return;
           }
           if (!controls.RolesHelp.name.val() || entity["Rols"].length == 0) {
               alert("请正确选择角色");
               return;
           }
           if (entity["Password"].length > 16 || entity["Password"].length < 6) {
               alert("密码长度应为6—16位");
               return;
           }
         
           params["ActionType"] = actionType;
           params["FunctionName"] = BasicAction.Functions.CparasManager;
           params["MethodName"] = methodName;
           return params;
       }
      
    </script>
     <input id="Id" value="<%=userEntity.Id %>"  type="hidden"/>
    <table style="margin:auto; padding:20px 0px 0px 30px;" cellspacing="10px">
        <tr style="height:30px;"><td>账号</td><td><input id="Code" value="<%=userEntity.Code %>" type="text" class="easyui-validatebox textbox" /></td></tr>
        <tr><td>名称</td><td><input id="Name" type="text" value="<%=userEntity.Name %>"  class="easyui-validatebox textbox" /></td></tr>
        <tr><td>职务</td><td><div id="Responsibilityies"></div></td></tr>
        <tr><td>功能角色</td><td><div id="Roles"  ></div></td></tr>
        <tr><td>组织机构</td><td><input id="OrgnizationId" type="text" value="<%=userEntity.OrgnizationId %>" data-options="valueField:'Id',textField:'Name',url:orgComb"   class="easyui-combotree"   style="height:20px;width:153px"/></td></tr>
        <tr><td>用户密码</td><td><input id="Password" type="password" value="<%=userEntity.Password %>" class="easyui-validatebox textbox"   /><font > 密码为4-10位</font></td></tr>
    </table>
</body>
</html>
