<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddWorkFlowDefinition.aspx.cs" Inherits="Audit.ct.WorkFlow.AddWorkFlowDefinition" %>

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
    <script src="../../Scripts/Ct_WorkFlow.js" type="text/javascript"></script>
</head>
<body id="Body1"  style=" padding:0px; margin:0px; overflow:hidden;width:600px; height:385px;">
<input id="Id" value="<%=wfd.Id %>" type="hidden" />
<input id="WorkFlowOrder" value="<%=wfd.WorkFlowOrder %>" type="hidden" />
<span id="data" style=" display:none"><%=wfd.Data %></span>
<input id="Data" value="" type="hidden" />

<table style="padding:0px; margin:0px; width:100%; height:385px; overflow:hidden;" >
    <tr style="height:100%;">
    <td style="height:100%;"><iframe src="../basic/WorkFlowManager.aspx" id="WorkFlowIframe"  frameborder="0" style=" width:400px; height:380px;"onload="iframeView();"></iframe></td>
    <%-- 右侧表格--%>
    <td style="padding:0px; margin:0px;">
        <div class="panel-header">流程属性</div>
        <table style="padding:0px; margin:0px; overflow:hidden;height:90%;width:100%;">
            <tr style="padding:0px; margin:0px; overflow:hidden;height:100px;">
                <td>
                   <table style="padding:0px; margin-top:0px;height:80px;width:100%;">
					    <tr><td>流程编号：</td><td><input id="Code" value="<%=wfd.Code %>" type="text"class="easyui-validatebox textbox" style="height: 20px;width: 170px;" /></td></tr>
                        <tr><td>流程名称：</td><td><input id="Name" value="<%=wfd.Name %>" type="text"class="easyui-validatebox textbox" style="height: 20px;width: 170px" /></td></tr>
                   </table>
                </td> 
            </tr>
            
            <tr style="height:115px;"><td>
                 <div class="panel-header">节点设置</div>
                    <table style="padding:0px; margin-top:10px;height:80px">
                        <%--<tr><td>节点名称：</td><td><input id="nodeName" value="" type="text"class="easyui-validatebox textbox" style="height: 20px;width: 125px;" onblur="setNode()" /></td></tr>
                        --%>
                        <tr><td>&nbsp&nbsp 职 &nbsp&nbsp 务：&nbsp </td><td><input id="nodePosition" value="" type="text" class="easyui-combotree"  data-options="valueField:'code',textField:'text',onSelect:setNode" style="height: 23px;width: 172px" /></td></tr> 
                        <tr><td>&nbsp</td></tr>
                    </table>
                </td>
            </tr>
           <%--下方空白框，调节整体高度--%>
			<tr  style="height:130px;"><td>&nbsp</td></tr> 
        </table>
    </td>
    </tr>
</table>

    <script type="text/javascript">
         //var PositionUrl = "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Get + "&MethodName=" + BasicAction.Methods.PositionManagerMethods.WorkFlowCombo + "&FunctionName=" + BasicAction.Functions.PositionManager;
        var PositionUrl = "../../handler/BasicHandler.ashx?ActionType=get&MethodName=WorkFlowCombo&FunctionName=" + BasicAction.Functions.PositionManager;
        var functionUrl = "../../handler/BasicHandler.ashx";
        var dataFunctionUL = "../../handler/WorkFlowHandler.ashx"; 
        var treeData;
        var nodeId = "";
        var findCode = false;
        ///获取参数
        function getParameters(actionType, methodName) {
            var params = {};
            params["Code"] = $("#Code").val();
            params["Name"] = $("#Name").val();
            params["Data"] = $("#Data").val();
            params["WorkFlowOrder"] = $("#WorkFlowOrder").val();

            params["ActionType"] = actionType;
            params["FunctionName"] = WorkFlowAction.Functions.WorkFlow;
            params["MethodName"] = methodName;
            var id = $("#Id").val();
            if (id != null && id != undefined && id != "") {
                params["Id"] = id;
            }
            ///判断输入是否完整
            ///张双义
            if (params["Code"] == "" || params["Code"] == null) {
                MessageManager.ErrorMessage('请输入流程编号！')
                return;
            }
            if (params["Name"] == "" || params["Name"] == null) {
                MessageManager.ErrorMessage('请输入业务流名称！')
                return;
            }
            return params;
        }
        ///调用参数：<iframe id="Frame"...></iframe>
        ///用途：获取Frame对象
        ///张双义
        function getGridIframe() {
            gridFrame = window.frames["WorkFlowIframe"];
            return gridFrame;
        }
        ///调用参数：Frame对象
        ///用途：获取 NodesData
        ///张双义
        function getNodesData() {
            var gridFrame = getGridIframe();
            var datas = gridFrame.getData();      
            return datas;
        }
        ///保存Data数据
        function saveDatas() {
            var datas = JSON.stringify(getNodesData());
            $("#Data").val(datas);
        }
        ///调用参数：node id
        ///用途：获取节点信息：nodeName,nodeId
        ///用途2：测试节点是否已经设置
        ///张双义
        function getNodeIf(node, Id) {
            nodeId = Id;
            var position = getPosition(node.name);
            if (!position.text) {
                MessageManager.InfoMessage("节点需要设置职务！");
                $('#nodePosition').combotree("setValue", "");
            } else {
                findCode = false;
                TestCode(treeData[0], position.code, position.text);
            }
        }
        function setPositionNo() {
            $('#nodePosition').combotree("setValue", "");
            nodeId = "";
        }
        ///参数 node.name 
        ///用途：截取出节点的职务信息
        ///返回：position
        ///张双义
        function getPosition(name) {
            var position = {};
            var cutFrom = name.indexOf("(");
            if (cutFrom > 0) {
                position.code = name.substr(cutFrom + 1, name.length - cutFrom - 2);
                position.text = name.substr(0, cutFrom);
            }
            return position;
        }
        ///参数：数据链treeData 待测试code ，待测试 text
        ///用途：测试 节点 的code 和text 是否合法
        ///返回：若findCode为true 则设置combotree选中该项
        ///张双义
        function TestCode(data, code, text) {
            if (data.code == code) {
                if (data.text == text) {
                    $('#nodePosition').combotree("setValue", data.id);
                } else {
                    MessageManager.InfoMessage("节点需要正确设置职务！");
                    $('#nodePosition').combotree("setValue", "");
                }
                findCode = true;
            } else {
                var length = data.children.length;
                if (length > 0) {
                    for (var i = 0; i < length; i++) {
                        if (findCode == true) { break; }
                        TestCode(data.children[i], code, text);
                    }
                }
            }
        }
        ///调用参数：node,nodeId
        ///用途：设置节点信息：node.name
        ///张双义     
        function setNode(node) {
            var gridFrame = getGridIframe();
            if (nodeId != "") {
                gridFrame.setNodeName(nodeId, node.text + "(" + node.code + ")");
            }
            else {
                MessageManager.InfoMessage('请选择一个职务节点！');
            }
        }
        ///保存WorkFlowOrdere
        ///张双义 
        function setWorkFlowOrder() {
            var workFlowOrderIf = new Array;
            var trySaveOrder = false;
            var datas = getNodesData();
            var starts = NodeManager.GetNodeByType("start", datas.nodes);
            var ends = NodeManager.GetNodeByType("end", datas.nodes);
            var start = starts[0];
            var end = ends[0];
            var lines = NodeManager.GetLines(datas.lines);
            var nodes = NodeManager.GetNodeByType("task", datas.nodes);
            
            ///一堆错误操作判断与提示
            ///张双义
            if (starts.length != 1 || ends.length != 1) { MessageManager.ErrorMessage("流程必须只有一个开始和一个结束！"); return trySaveOrder; }
            if (!start || !end || nodes.length<1 || lines.length<2) { MessageManager.ErrorMessage("请正确创建左侧流程过程！"); return trySaveOrder; }
            var lineStart = NodeManager.GetLineByNodeId(start.id, lines);
            if (!lineStart) { MessageManager.ErrorMessage("流程必须从开始节点顺次进行！"); return trySaveOrder; } 
            if (lines.length != nodes.length + 1) { MessageManager.ErrorMessage("请正确创建左侧流程过程！"); return trySaveOrder; }
            
            for (var i = 0; i <= nodes.length; ++i) {
                workFlowOrderIf.push(start); 
                lineStart = NodeManager.GetLineByNodeId(start.id, lines);
                if (!lineStart) {
                    MessageManager.ErrorMessage("流程结束时，部分职务节点没有下一步或未经过！++1");
                    trySaveOrder = false;
                    break;
                }
                start = NodeManager.GetNodeById(lineStart.to, nodes);
                if (!start) {
                    if (i == nodes.length && lineStart.to == end.id) {
                        workFlowOrderIf.push(end);
                        trySaveOrder = true;
                    } else {
                        MessageManager.ErrorMessage("流程结束时，部分节点未经过或没有下一步！");
                        trySaveOrder = false;
                    }
                    break;
                }
            }
            if (!trySaveOrder) {
                if (i>nodes.length) {
                    MessageManager.ErrorMessage("流程未正常结束！");
                }
                return trySaveOrder;}
            var workFlowStr = getWorkFlowOrder(workFlowOrderIf);
            if (!workFlowStr) {
                trySaveOrder = false;
                return trySaveOrder;
            }
            $("#WorkFlowOrder").val(workFlowStr);
            return trySaveOrder;
        }
        ///输入参数:排列好的nodes列表
        ///用途：返回String类型的流程过程
        ///张双义
        function getWorkFlowOrder(OrderIf) {
            var Order = new Object;
            Order.text = OrderIf[0].name;
            Order.code = OrderIf[0].type;
            var length = OrderIf.length - 1;
            var isSuccess=true;
            for (var i = 1; i < length; i++) {
                var position = getPosition(OrderIf[i].name);
                if (!position.text) {
                    MessageManager.ErrorMessage("部分节点需要设置职务！");
                    isSuccess = false;
                    break;
                }
                Order.text = Order.text + "," + position.text;
                Order.code = Order.code + "," + position.code;
            }
            if (isSuccess) {
                Order.text = Order.text + "," + OrderIf[length].name;
                Order.code = Order.code + "," + OrderIf[length].type;
                return Order.code + ";" + Order.text;
            } else { return isSuccess; }
        }
        ///预处理iframe图片区域
        function iframeView() {
            var data = document.getElementById("data").innerHTML;
            if (data) {
                var nodesData = $.parseJSON(data);
                var iframe = getGridIframe();
                iframe.LoadData(nodesData);
            }
        }
        ///调用参数：data
        ///用途：为职务combotree加载数据,记录data
        ///返回：无
        ///张双义
        var resultMassage = {
            success: function (data) {
                $("#nodePosition").combotree({data:data});
                treeData = data;
            },
            fail: function (data) {
                MessageManager.ErrorMessage(data.toString);
            }
        }  
        $(
        function () {
            ///加载 职务combotree数据
            var para = {};
            var paramet = CreateParameter(BasicAction.ActionType.Post, BasicAction.Functions.PositionManager, BasicAction.Methods.PositionManagerMethods.WorkFlowCombo, para);
            DataManager.sendData(functionUrl, paramet, resultMassage.success, resultMassage.fail);
        }
            );
   </script>
</body>
</html>
