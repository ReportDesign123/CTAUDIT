<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="west.aspx.cs" Inherits="Audit.Layout.west" %>

<style type="text/css">
   .easyui-tree li{
	margin-top: 6px;
}
body {
	font-family: helvetica, tahoma, verdana, sans-serif;
	padding: 10px;
	font-size: 13px;
	margin: 0;
}
.easyui-tree {
list-style-type: none;
margin: 0px;
padding: 0px;
}
</style>

<script type="text/javascript">

        
        function clickHandler(node) {
            var nodeurl = node.attributes['url'].replace(' ', '');
            if (nodeurl != '' && nodeurl != '#')
                addTab(node);
            }
            function LoginOut() {
                var para = {};
                para = CreateParameter(BasicAction.ActionType.Post, BasicAction.Functions.UserManager, BasicAction.Methods.UserManagerMethods.LoginOut, para);
                DataManager.sendData("handler/BasicHandler.ashx", para, resultManagers.success, resultManagers.fail, false);
               
            }

            var resultManagers = {

                success: function (data) {
                    if (data.success) {
                        window.location.href = "Login.aspx";
                    } else {
                        MessageManager.InfoMessage(data.sMeg);
                    }
                },
                fail: function (data) {
                    if (data) {
                        MessageManager.InfoMessage(data.sMeg);
                    }
                }
            };
</script>

        <div class="easyui-accordion" style="border:left" data-options="fit:true,border:false">
        <%
            int i = 0;
            foreach (AuditSPI.FunctionStruct fs in functions)
            {
                string temp = i.ToString();
                Response.Write("<script type='text/javascript'>var mdata"+i.ToString()+"=" + fs.childrenJson + "</script>");
                 %>               
                 <div title="<%=fs.text %>" data-options="iconCls:'<%=fs.iconCls %>'"  >
                        <ul class="easyui-tree tree" data-options="data:mdata<%=temp%>,onClick : clickHandler"></ul>                 
                 </div>

                <%
                    i++;
            }
        %>
         <div title="退出系统" >
          <ul class="easyui-tree tree" data-options="data:[{id:'out',text:'退出系统'}],onClick : LoginOut"></ul>    
         </div>
        </div>
        