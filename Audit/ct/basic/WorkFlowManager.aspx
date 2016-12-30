<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WorkFlowManager.aspx.cs" Inherits="Audit.ct.basic.WorkFlowManager" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <link href="../../lib/workFlow/CtWorkDefault.css" rel="stylesheet" type="text/css" />
    <link href="../../lib/workFlow/CtWorkFlow.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/workFlow/CtWorkFlow.js" type="text/javascript"></script>
    <script src="../../lib/workFlow/CtWorkFlowFunc.js" type="text/javascript"></script>
    <script type="text/javascript">
        var property = {
            width: 400,
            height: 380,
            toolBtns: ["task"],
            haveHead: false,
            headBtns: ["new", "open", "save", "undo", "redo", "reload"], //如果haveHead=true，则定义HEAD区的按钮
            haveTool: true,
            useOperStack: true
        };
        var remark = {
            cursor: "选择指针",
            direct: "转换连线",
            start: "开始结点",
            end: "结束结点",
            task: "任务结点"

        };
        var demo;
        $(document).ready(function () {
            demo = $.createGooFlow($("#demo"), property);
            demo.setNodeRemarks(remark);
            demo.onItemDel = function (id, type) {

            }
            demo.onItemFocus = function (id, type) {
                var node = demo.getItemInfo(id, type);
                var Id = id;
                if (parent && parent.getNodeIf && node.type != "sl") {
                    if (node.type == "task") {
                        parent.getNodeIf(node, Id);
                    } else {
                        parent.setPositionNo();
                    }
                }
            }
            demo.onItemDbClick = function (id) {

            }

        });
        var tempdate = {};
        function clickBtn() {
            tempdate = $.extend(true, {}, demo.exportData());
            demo.clearData();
        }
        function LoadData(nodesData) {
            demo.loadData(nodesData);
        }
        ///操作对象：Frame
        ///用途：返回 NodesData
        ///张双义
        function getData() {
           return demo.exportData();
       }
       function setNodeName(id, name) {
           demo.setName(id, name, "node");
       }
    </script>
</head>
<body>
<div id="demo"></div>
</body>
</html>
