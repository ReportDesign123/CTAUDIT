<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReportWorkFlowPublish.aspx.cs" Inherits="Audit.ct.ReportData.ReportExamine.ReportWorkFlowPublish" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">

<head id="Head1" runat="server" >
    <title>报表数据审批流程</title>
     <script src="../../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>    
    <script src="../../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <link href="../../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../../../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script src="../../../Scripts/AjaxTrigger.js" type="text/javascript"></script>


    <script src="../../../Scripts/Ct_Controls.js" type="text/javascript"></script>
    <link href="../../../Styles/Ct_Controls.css" rel="stylesheet" type="text/css" />
    <script src="../../../Scripts/ct/pub/PubHelp.js" type="text/javascript"></script>


</head>
<body style=" overflow:hidden">
<div id="Dialog"></div>
    <table style="margin:auto;margin-top:auto;"><tr><td>
        <div  style=" width:380px;height:260px;background:#fafafa;margin-top:40%;" class="easyui-panel">
            <div class="panel-header" style="width: 97%;">
            <div class="panel-title panel-with-icon">报表数据审批流程</div>
            <div class="panel-icon icon-print"></div></div>
            <table style="margin:auto;margin-top:40px;">
            <tr style="height:30px;"><td>系统预置业务名称：</td><td> <input id="workFlowBusiness" class="easyui-combobox" value="" data-options="valueField:'Name',textField:'Remark',onSelect:setOrder"  name="Name" />
            </td></tr>
            <tr><td>报表审批流程：</td><td><div id="workFlowOrder"></div></td></tr>
            <tr style="height:80px;"><td>
            </td><td><a href="#" class="easyui-linkbutton" onclick="publishReport()" iconcls="icon-edit" style="float:right">报表资料审批部署</a></td></tr>
            </table>
        </div>
    </td></tr></table>
    
    <script type="text/javascript">
        var functionUrls = {
            ComboboxUrl: "../../../handler/BasicHandler.ashx",
            ReportUrl: "../../../handler/ReportDataHandler.ashx"
        };
        var workFlowBusinessData;
        var Business = new Object;

        ///获取提交参数信息
        ///张双义
        function getParameters(actionType, methodName) {
            var params = {};
            params["ValueDis"] = workFlowOrder.name.val();
            params["Value"] = workFlowOrder.value.val();
            params["ActionType"] = actionType;
            params["FunctionName"] = ReportDataAction.Functions.FillReport;
            params["MethodName"] = methodName;
            
            if (Business.Id) {
                params["Id"] = Business.Id;
                params["Name"] = Business.Name;
            } else {
                MessageManager.ErrorMessage("请选择 系统预置业务流程！");
                return null
            }
            if (params["Name"] == "") {
                MessageManager.ErrorMessage("请选择审批流程！");
                return null;
            }
            return params
        }
        ///参数;输入框参数 
        ///报表部署
        ///张双义
        function publishReport() {
            var parameters = {};
            parameters = getParameters(ReportDataAction.ActionType.Post, ReportDataAction.Methods.FillReportMethods.ReportExamineWorkFlowPublish);
            if (parameters == null) { return; }
            DataManager.sendData(functionUrls.ReportUrl, parameters, resultManagers.success, resultManagers.fail);
        }
        ///调用参数：node
        ///用途：为combobox加载数据
        ///张双义
        function setOrder(node) {
            Business = node;
            if (Business.Value || Business.ValueDis) {
                workFlowOrder.value.val(Business.Value);
                workFlowOrder.name.val(Business.ValueDis);
            }
        }
        var resultManagers = {
            success: function (data) {
                if (data.success) {
                    MessageManager.InfoMessage(data.sMeg);
                } else {
                    MessageManager.ErrorMessage(data.sMeg);
                }
            },
            ///初始化BusinessCombobox
            ///保存 ComboboxData
            ///张双义
            successCombobox: function (data) {
                $('#workFlowBusiness').combobox('loadData', data.obj);
                workFlowBusinessData = data.obj;
            },
            fail: function (data) {
                MessageManager.ErrorMessage(data.toString);
            }
        }
        ///ReportExamineWorkFlowPublish
        ///帮助窗口触发事件
        ///输出参数：{name：WorkFlowOrder.name, value: WorkFlowOrder.Id}
        ///张双义
        var workFlowOrder = {};
        function workFlowOrder_ClickEvent() {
            var paras = { url: "", columns: [], sortName: "", sortOrder: "", NameField: "Name", CodeField: "Code" };
            paras.url = "../../../handler/WorkFlowHandler.ashx?ActionType=" + WorkFlowAction.ActionType.Grid + "&MethodName=" + WorkFlowAction.Methods.WorkFlowMethods.DataGridWorkFlow + "&FunctionName=" + WorkFlowAction.Functions.WorkFlow + "&ClassType=RWLX";
            ///窗口table显示字段
            paras.columns = [[
                { field: "Code", title: "编号", width: 80 },
                    { field: "Name", title: "名称", width: 80 },
                ]];
            paras.sortName = "Code";
            paras.sortOrder = "DESC";
            paras.width = 450;
            paras.height = 450;
            pubHelp.setParameters(paras);
            pubHelp.OpenDialogWithHref("Dialog", "选择审批流程", "../../pub/HelpDialogEasyUi.htm", saveWorkFlowOrder, paras.width, paras.height, true);
        }
        function saveWorkFlowOrder() {
            var result = pubHelp.getResultObj();
            if (result && result.Code) {
                workFlowOrder.name.val(result.Name);
                workFlowOrder.value.val(result.Code);
            }
        }
        $(
        function () {
            ///WorkFlowOrder
            ///帮助窗口加载
            workFlowOrder = $("#workFlowOrder").PopEdit();
            workFlowOrder.btn.bind("click", function () {
                workFlowOrder_ClickEvent();
            });
            ///Business
            ///流程combobox数据加载
            var para = {};
            var paramet = CreateParameter(BasicAction.ActionType.Post, BasicAction.Functions.System, BasicAction.Methods.SystemMethods.GetWorkFlows, para);
            DataManager.sendData(functionUrls.ComboboxUrl, paramet, resultManagers.successCombobox, resultManagers.fail);
        }
        );
    </script>
</body>
</html>
