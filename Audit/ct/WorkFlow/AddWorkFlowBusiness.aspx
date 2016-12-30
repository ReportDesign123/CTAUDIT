<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddWorkFlowBusiness.aspx.cs"
    Inherits="Audit.ct.WorkFlow.AddWorkFlowBusiness" %>

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

    <script src="../../Scripts/Ct_Controls.js" type="text/javascript"></script>
    <link href="../../Styles/Ct_Controls.css" rel="stylesheet" type="text/css" />

</head>
<body id="Body1" runat="server">
    <input id="Id" value="<%=wfbe.Id %>" type="hidden" />
    <%--<input id="WorkFlowId" value="<%=wfbe.WorkFlowId %>" type="hidden" />
    <input id="WorkFlowName" value="<%=wfbe.WorkFlowName %>" type="hidden" />--%>
    <table style="margin: auto; padding: 20px;">
        <tr style="height: 20px;">
            <td>流程编号：</td><td><input id="BusinessCode" value="<%=wfbe.BusinessCode %>" type="text" class="easyui-validatebox textbox" style="height: 20px;width: 155px;" /></td></tr>
        <tr><td>流程名称：</td><td><input id="Name" type="text" value="<%=wfbe.Name %>" class="easyui-validatebox textbox" style="height: 20px;width: 155px" /></td></tr>
        <tr><td>工作流：</td><td><div id="workFlowOrder"></div></td></tr>
    </table>
    <script type="text/javascript">
        ///获取参数
        function getParameters(actionType, methodName) {
            var params = {};
            params["BusinessCode"] = $("#BusinessCode").val();
            params["Name"] = $("#Name").val();

            params["WorkFlowId"] = workFlowOrder.value.val();
            params["WorkFlowName"] = workFlowOrder.name.val();
            params["ActionType"] = actionType;
            params["FunctionName"] = WorkFlowAction.Functions.WorkFlow;
            params["MethodName"] = methodName;
            var id = $("#Id").val();
            if (id != null && id != undefined && id != "") {
                params["Id"] = id;
            }
            ///判断输入是否完整
            if (params["BusinessCode"] == "" || params["BusinessCode"] == null) {
                MessageManager.ErrorMessage('请输入流程编号！')
                return;
            }
            if (params["Name"] == "" || params["Name"] == null) {
                MessageManager.ErrorMessage('请输入业务流名称！')
                return;
            }
            if (params["WorkFlowId"] == "" || params["WorkFlowId"] == null) {
                MessageManager.ErrorMessage('请选择工作流！')
                return;
            }
            return params;
        }
        ///帮助窗口触发事件
        ///输出参数：{name：WorkFlowOrder.name, value: WorkFlowOrder.Id}
        ///张双义
        var workFlowOrder = {};
        function workFlowOrder_ClickEvent() {
            var paras = { url: "", columns: [], sortName: "", sortOrder: "" };
            paras.url = "../../handler/WorkFlowHandler.ashx?ActionType=" + WorkFlowAction.ActionType.Grid + "&MethodName=" + WorkFlowAction.Methods.WorkFlowMethods.DataGridWorkFlow + "&FunctionName=" + WorkFlowAction.Functions.WorkFlow + "&ClassType=RWLX";
            ///窗口table显示字段
            paras.columns = [[
                { field: "Code", title: "编号", width: 80 },
                    { field: "Name", title: "名称", width: 80 },
                ]];
            paras.sortName = "Code";
            paras.sortOrder = "DESC";
            var result = window.showModalDialog("../pub/HelpDialog.aspx", paras, "dialogHeight:350px;dialogWidth:300px");
            if (result && result.Code) {
                workFlowOrder.name.val(result.Name);
                workFlowOrder.value.val(result.Id);
            }
        }
        ///帮助窗口加载
        $(
        function () {
            workFlowOrder = $("#workFlowOrder").PopEdit();
            workFlowOrder.btn.bind("click", function () {
                workFlowOrder_ClickEvent();
            });
            ///编辑时对 工作流 赋name
            //workFlowOrder.name.val($("#WorkFlowName").val());
        }
        );
   </script>
</body>
</html>