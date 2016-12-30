<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UserManager.aspx.cs" Inherits="Audit.ct.basic.UserManager" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>用户管理</title>
    <script src="../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <link href="../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="../../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script src="../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <link href="../../Styles/Common.css" rel="stylesheet" type="text/css" />
    
    <link href="../../Styles/Ct_Controls.css" rel="stylesheet" type="text/css" />
    <script src="../../Scripts/Ct_Controls.js" type="text/javascript"></script>
    <script src="../../lib/json2.js" type="text/javascript"></script>
    <script src="../../Scripts/ct/pub/PubHelp.js" type="text/javascript"></script>

    <script type="text/javascript">

        var urls = {
            userGridUrl: "../../handler/BasicHandler.ashx?ActionType="+BasicAction.ActionType.Grid+"&MethodName="+BasicAction.Methods.UserManagerMethods.DataGrid+"&FunctionName="+BasicAction.Functions.UserManager,
            treeGridUrl: "../../handler/ExportReport.ashx?ActionType=" + ExportAction.ActionType.Grid + "&MethodName=" + ExportAction.Methods.CreatReportMethod.GetCompaniesByAuthority + "&FunctionName=" + ExportAction.Functions.CreateReport,
            functionsUrl: "../../handler/BasicHandler.ashx",
            AddRole: "AddUser.aspx"


        };
        var UserControls = {};
        $(document).keydown(
            function (e) {
                if (e.which == 13) {
                    SearchManager.doSearch();
                }
            });
            $(function () {
                UserControls.CompanyHelp = $("#CompanyHelp").PopEdit();
                UserControls.CompanyHelp.btn.bind("click", function () {
                    eventManager.CompanyHelpBtn_Click();
                });
            });
       var menuManager = {
           AddMenu: function () {
               menuManager.OpenDialog(urls.AddRole, "创建用户", "add");
           },
           EditMenu: function () {
               var row = $("#userGrid").datagrid("getSelected");
               var ur = "";
               if (row) {
                   ur = "?Id=" + row.Id;
               } else {
                   MessageManager.WarningMessage("请先选择一行在进行编辑！");
                   return;
               }
               menuManager.OpenDialog(urls.AddRole + ur, "编辑用户", "edit");
           },
           RemoveMenu: function () {
               var node = $("#userGrid").datagrid("getSelected");
               var para = {};
               if (node != null) {
                   para["Id"] = node.Id;
               } else {
                   MessageManager.WarningMessage("请先选择一行在进行删除！");
                   return;
               }
               var parameters = CreateParameter(BasicAction.ActionType.Post, BasicAction.Functions.UserManager, BasicAction.Methods.UserManagerMethods.Delete, para);
               DataManager.sendData(urls.functionsUrl, parameters, resultManagers.Delete_Success, resultManagers.fail);
           },
           OpenDialog: function (url, title, type) {
               $('#Dialog').dialog({
                   title: title,
                   width: 400,
                   height: 350,
                   closed: false,
                   cache: false,
                   href: url,
                   modal: true,
                   buttons: [{
                       text: '保存',
                       iconCls: "icon-ok",
                       handler: function () {
                           var parameters = {};
                           if (type == "add") {
                               parameters = getParameters(BasicAction.ActionType.Post, BasicAction.Methods.UserManagerMethods.Save);
                               if (!parameters) return;
                               DataManager.sendData(urls.functionsUrl, parameters, resultManagers.success, resultManagers.fail);
                           } else if (type == "edit") {
                               parameters = getParameters(BasicAction.ActionType.Post, BasicAction.Methods.UserManagerMethods.Edit);
                               if (!parameters) return;
                               DataManager.sendData(urls.functionsUrl, parameters, resultManagers.success, resultManagers.fail);
                           }

                       }
                   },
                        {
                            text: '取消',
                            iconCls: "icon-cancel",
                            handler: function () {
                                $('#Dialog').dialog("close");
                            }
                        }
                        ]
               });
           }
       };
       var SearchManager = {
           doSearch: function () {
               var para = { Name: "", RooleName: "", CompanyName: "", Code: "" };
               para.Code = $("#userCode").val();
               para.Name = $("#userName").val();
               para.CompanyName = UserControls.CompanyHelp.name.val();
               $("#userGrid").datagrid('reload', para);
           },
           freeSearch: function () {
               $("#userCode").val("");
               $("#userName").val("");
               UserControls.CompanyHelp.name.val("");
               //$("#CompanyName").val("");
               $("#userGrid").datagrid('reload', {});
           }
       }
       var resultManagers = {

           success: function (data) {
               if (data.success) {
                   MessageManager.InfoMessage(data.sMeg);
                   $("#userGrid").datagrid('reload');
                   $('#Dialog').dialog("close");
                   $("#userGrid").datagrid('unselectAll');

               } else {
                   MessageManager.ErrorMessage(data.sMeg);
               }
           },
           fail: function (data) {

               MessageManager.ErrorMessage(data.toString);
           },
           Delete_Success: function (data) {
               if (data.success) {
                   MessageManager.InfoMessage(data.sMeg);
                   $("#userGrid").datagrid('reload');
 

               } else {
                   MessageManager.ErrorMessage(data.sMeg);
               }
           }
       };

       var eventManager = {
           selectEvent: function (rowIndex, rowData) {
               var id = rowData.Id;
               var ur = urls.TreeUrl + "&Id=" + id;
               $("#tree").tree({ url: ur });
           },
           CompanyHelpBtn_Click: function () {
               var treeParas = { idField: "", treeField: "", columns: [], url: "" };
               treeParas.url = urls.treeGridUrl;
               treeParas.idField = "Id";
               treeParas.treeField = "Code";
               treeParas.columns = [[
            { title: 'id', field: 'Id', width: 180, hidden: true },
            { title: '组织机构编号', field: 'Code', width: 180 },
            { title: '组织机构名称', field: 'Name', width: 210 }
                    ]];
               treeParas.UseTo = "search";
               treeParas.width = 420;
               treeParas.height = 450;
               pubHelp.setParameters(treeParas);
               pubHelp.OpenDialogWithHref("Dialog", "单位选择", "../pub/HelpTreeDialog.aspx", eventManager.CompanyHelp_save, treeParas.width, treeParas.height, true);
           },
           CompanyHelp_save: function () {
               var result = pubHelp.getResultObj();
               if (result) {
                   if (result.length > 0) {
                       UserControls.CompanyHelp.name.val(result[0].Name);
                   }
               }
           }
       };
       function timeFormmart(value, row) {
           return value;
       }
    </script>
</head>
<body class="easyui-layout">
 <div data-options="region:'north',collapsible:false" style=" height:32px; padding:2px;background-color:#E0ECFF ;overflow:hidden">
      <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add',iconAlign:'left',line:true" onclick="menuManager.AddMenu()" style="width:70px; float:left "plain="true">增加</a>
    <div class="datagrid-btn-separator"></div>
    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-edit',iconAlign:'left'" onclick="menuManager.EditMenu()" style="width:70px;float:left "plain="true">修改</a>
    <div class="datagrid-btn-separator"></div>
    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-cut',iconAlign:'left'" onclick="menuManager.RemoveMenu()" style="width:70px;float:left "plain="true">删除</a>
</div>
 <div data-options="region:'center'">
 <div id="toolBar" style="min-width:850px;display:none">
     <table  style="width:100%">
        <tr>
            <td style="width:60px">用户账号</td><td  style="width:170px"><input id="userCode" type="text" class="easyui-validatebox textbox" /></td>
            <td style="width:60px">用户名称</td><td style="width:170px"><input id="userName" type="text" class="easyui-validatebox textbox" /></td>
            <td style="width:60px">组织机构</td><td style="width:170px"><div id="CompanyHelp"></div></td>
            <td style=" float:right"><a class="easyui-linkbutton" onclick="SearchManager.freeSearch()" iconcls="icon-undo" style="">重置</a></td>
            <td style=" float:right"><a class="easyui-linkbutton" onclick="SearchManager.doSearch()" iconcls="icon-search" style=" margin-right:10px">查询</a></td>
        </tr>
     </table>
 </div>
<table class="easyui-datagrid"  id="userGrid"
        data-options="singleSelect:true,method:'post',fit:true,fitColumns:true,border:false,toolbar:'#toolBar',url:urls.userGridUrl,sortName:'CreateTime',sortOrder:'DESC',pagination:true">
    <thead>
        <tr>
            <th data-options="field:'Code',width:100,fixed:true,sortable:true">用户账号</th>
            <th data-options="field:'Name',width:120,fixed:true,sortable:true">用户名称</th>
            <th data-options="field:'RoleName',width:140,fixed:true,sortable:true">用户角色</th>
                <th data-options="field:'PositionName',width:180,fixed:true,sortable:true">用户职务</th>
            <th data-options="field:'CompanyName',width:200,sortable:true">组织机构</th>    
                <th data-options="field:'Creator',width:120,sortable:true">创建者</th>   
                <th data-options="field:'CreateTime',width:120,formatter:timeFormmart,sortable:true">创建时间</th>
                <th data-options="field:'Id',align:'left',hidden:true">ID</th>
        </tr>
    </thead>
</table>
</div>
    <div id="HelpDialog" />
    <div id="Dialog" />
</body>
</html>
