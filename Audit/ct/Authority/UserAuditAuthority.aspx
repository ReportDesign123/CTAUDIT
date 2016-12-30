<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UserAuditAuthority.aspx.cs" Inherits="Audit.ct.Authority.UserAuditAuthority" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
     <title>审计权限设置</title>
      <script src="../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <link href="../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="../../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script src="../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <link href="../../Styles/Common.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/json2.js" type="text/javascript"></script>
    <script type="text/javascript">
        var urls = {
            userGridUrl: "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Grid + "&MethodName=" + BasicAction.Methods.UserManagerMethods.DataGrid + "&FunctionName=" + BasicAction.Functions.UserManager,
            functionsUrl: "../../handler/BasicHandler.ashx",
            AuthoriyUrl: "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Grid + "&MethodName=" + BasicAction.Methods.AuthorityMethods.GetAuditAuthorityCompaniesByUser + "&FunctionName=" + BasicAction.Functions.Authority
        };
        $(function () {
            $("#panel").panel({
                title: "<div class='title'>组织机构</div>",
                fit: true, 
                tools: [{
                    iconCls: 'icon-save',
                    handler: saveAll
                }]
            });
            
        });
        function saveAll() {
            var users = $("#userGrid").datagrid("getSelections");
            var companies = $("#tree").tree('getChecked', ['checked']);
            var unDoNotes = $("#tree").tree('getChecked', ['indeterminate']);
            if (!users.length > 0) { alert("请选择要设置的用户"); return; }
            var userData = [];
            var companyData = [];
            $.each(users, function (index, user) {
                userData.push({ Id: user.Id });
            });
            $.each(companies, function (index, company) {
                companyData.push({ Id: company.id });
            });
            var obj = { users: "", companies: "" };
            obj.users = JSON2.stringify(userData);
            obj.companies = JSON2.stringify(companyData);
            var para = CreateParameter(BasicAction.ActionType.Post, BasicAction.Functions.Authority, BasicAction.Methods.AuthorityMethods.SaveAndEditAuditAuthority, obj);
            DataManager.sendData(urls.functionsUrl, para, resultManagers.success, resultManagers.fail);
        }
        var resultManagers = {
            success: function (data) {
                if (data.success) {
                    MessageManager.InfoMessage(data.sMeg);
                } else {
                    MessageManager.ErrorMessage(data.sMeg);
                }
            },
            successLoadAuthority: function (data) {
                if (data.success) {
                    $("#ckSpan").css("display","block");
                    $("#checkChild").prop({ checked: false });
                    $('#tree').tree({ cascadeCheck: $(this).is(':checked') });
                    $("#tree").tree("loadData", data.obj);
                } else {
                    MessageManager.ErrorMessage(data.sMeg);
                }
            },
            fail: function (data) {
                MessageManager.ErrorMessage(data.toString);
            }
        }
        var eventManager = {
            selectEvent: function (rowIndex, rowData) {
                var para = { id: rowData.Id };
                para = CreateParameter(BasicAction.ActionType.Post, BasicAction.Functions.Authority, BasicAction.Methods.AuthorityMethods.GetAuditAuthorityCompaniesByUser, para);
                DataManager.sendData(urls.functionsUrl, para, resultManagers.successLoadAuthority, resultManagers.fail);
            },
            doSearch: function () {
                var para = { Name: "", RooleName: "", Code: "" };
                para.Code = $("#userCode").val();
                para.Name = $("#userName").val();
                $("#userGrid").datagrid('reload', para);
            },
            freeSearch: function () {
                $("#userCode").val("");
                $("#userName").val("");
                $("#userGrid").datagrid('reload', {});
            }
        };

    </script>
    <style type="text/css">
        .title {
	        font-family: helvetica, tahoma, verdana, sans-serif;
	        font-size: 12px;
	        margin: 0;
        }
    </style>
</head>
<body  class="easyui-layout" data-options="fit:true">
    <div data-options="region:'center'" title="<div class='title'>用户</div>" >
        <div id="toolBar" style="min-width:580px;display:none">
            <table  style="width:100%">
            <tr>
                <td style="width:60px">用户账号</td><td  style="width:170px"><input id="userCode" type="text" class="easyui-validatebox textbox" /></td>
                <td style="width:60px">用户名称</td><td style="width:170px"><input id="userName" type="text" class="easyui-validatebox textbox" /></td>
                <td style=" float:right"><a class="easyui-linkbutton" onclick="eventManager.freeSearch()" iconcls="icon-undo" style=" margin-left:10px">重置</a></td>
                <td style=" float:right"><a class="easyui-linkbutton" onclick="eventManager.doSearch()" iconcls="icon-search" >查询</a></td>
            </tr>
            </table>
        </div>
        <table class="easyui-datagrid"  id="userGrid"
                data-options="singleSelect:false,method:'post',border:false,fit:true,fitColumns:true,url:urls.userGridUrl,sortName:'CreateTime',pagination: true,toolbar:'#toolBar',sortOrder:'DESC',onSelect:eventManager.selectEvent">
            <thead>
                <tr>
                    <th data-options="field:'Id',checkbox:true">Id</th> 
                    <th data-options="field:'Code',width:100">用户账号</th>
                    <th data-options="field:'Name',width:150">用户名称</th>
                    <th data-options="field:'RoleName',width:150">用户角色</th>
                        <th data-options="field:'PositionName',width:200">用户职务</th>
                </tr>
            </thead>
        </table>
    </div>
    <div data-options="region:'east',split:true,collapsible:false,border:false" style="width:300px;height:100%;border-top:0px">
        <div id="panel" style=" height:100%" >
            <span id="ckSpan" style="display:none;"><input type="checkbox" id="checkChild" style=" margin-left:16px" onchange="$('#tree').tree({cascadeCheck:$(this).is(':checked')})" />级联选择</span>
            <ul id="tree" class="easyui-tree" data-options="method:'post',animate:false,checkbox:true,cascadeCheck:false" ></ul>
        </div>
    </div>
</body>
</html>


