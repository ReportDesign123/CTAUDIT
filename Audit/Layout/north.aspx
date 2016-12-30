<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="north.aspx.cs" Inherits="Audit.Layout.north" %>


<script type="text/javascript">
    function LoginOut() {
        var para = {};        
        para = CreateParameter(BasicAction.ActionType.Post, BasicAction.Functions.UserManager, BasicAction.Methods.UserManagerMethods.LoginOut, para);
        DataManager.sendData("../handler/BasicHandler.ashx", para, resultManagers.success, resultManagers.fail, false);
    }

    var resultManagers = {

        success: function (data) {
            if (data.success) {
                window.location.href = "../Login.aspx";
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
 <div style="background-image:url(images/layout/toplogo-main.png);background-repeat:no-repeat;width:100%;height:100%;">
  <div style="position: absolute; right: 20px; bottom: 0px; ">
<a id="btn" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-back',plain:true,onClick:LoginOut">退出</a>
</div>
    </div>

