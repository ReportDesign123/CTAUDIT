<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReportAggregationFind.aspx.cs" Inherits="Audit.ct.ReportData.ReportAggregation.ReportAggregationFind" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>汇总资料查看</title>
    <script src="../../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <script src="../../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script src="../../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <link href="../../../Styles/Common.css" rel="stylesheet" type="text/css" />
    <script src="../../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <link href="../../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../../../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../../../Scripts/Ct_Controls.js" type="text/javascript"></script>
    <link href="../../../Styles/Ct_Controls.css" rel="stylesheet" type="text/css" />
    <script src="../../../Scripts/ct/pub/PubHelp.js" type="text/javascript"></script>
    <script type="text/javascript">
        var urls = {
            datagrid: "../../../handler/ReportDataHandler.ashx?ActionType=" + ReportDataAction.ActionType.Grid + "&MethodName=" + ReportDataAction.Methods.ReportAggregationMethods.GetAggregationLogEnties+ "&FunctionName=" + ReportDataAction.Functions.ReportAggregation,
            templateUrl: "../../../handler/ReportDataHandler.ashx?ActionType=" + ReportDataAction.ActionType.Grid + "&MethodName=" + ReportDataAction.Methods.ReportAggregationMethods.GetAggregationTemplates + "&FunctionName=" + ReportDataAction.Functions.ReportAggregation,
            zqUrl: "../../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Get + "&MethodName=GetDictionaryListByClassType&FunctionName=" + BasicAction.Functions.DictionaryManager + "&ClassType=BBZQ",
            functionsUrl: "../../../handler/FormatHandler.ashx",
            ReportCycle: "../../../handler/ReportDataHandler.ashx",
            ReportListUrl: "ct/ReportData/ReportAggregation/ReportList.aspx",
            AddFormular: "AddFormular.aspx"
        };
        var currentState = {TemplateType:""};
        $(function () {
            currentState.TemplateHelp = $("#template").PopEdit();
            currentState.TemplateHelp.btn.bind("click", function () {
                menuManager.Search_PopUp();
            });
            $(document).keydown(
            function (e) {
                if (e.which == 13) {
                    SearchAggregationLogs();
                }
            }
            );
        }); 
        var menuManager = {
            Search_PopUp: function () {
                //报表类型切换
                var paras = { url: "", columns: [], sortName: "", sortOrder: "", NameField: "Name", CodeField: "Code", defaultField: { dftBy: "Name", dft: ""} };
                paras.url = urls.templateUrl;
                paras.columns = [[
                { title: 'id', field: 'Id', width: 180, hidden: true },
			    { field: 'Code', title: '编号', width: 150, sortable: true },
                { field: 'Name', title: '名称', width: 150, sortable: true }
                    ]];
                paras.sortName = 'Code';
                paras.sortOrder = 'ASC';
                paras.defaultField.dft = currentState.TemplateHelp.name.val();
                paras.width = 450;
                paras.height = 450;
                pubHelp.setParameters(paras);
                pubHelp.OpenDialogWithHref("Dialog", "系统帮助", "../../pub/HelpDialogEasyUi.htm", menuManager.Save_Template, paras.width, paras.height, true);
            },
            Save_Template: function () {
                var result = pubHelp.getResultObj();
                if (result) {
                    currentState.TemplateHelp.value.val(result.Id);
                    currentState.TemplateHelp.name.val(result.Name);
                }
            }
        };
        var EnventManager = {
            //汇总数据查看
            ViewTemplateReport: function (index, data) {
                var para = "?Id=" + data.Id + "&CompanyId=" + data.CompanyId + "&Cycle=" + data.Cycle + "&Year=" + data.Year + "&TemplateId=" + data.TemplateId + "&Paper=" + data.Paper + "&TaskId=" + data.TaskId;
                parent.NavigatorNode({ id: "055", text: "汇总报表查看", attributes: { url: urls.ReportListUrl + para} });
            },
            SelectTemplateType: function (node) {
                if (!node) {
                    node = { Code: "" };
                }
                currentState.TemplateType = node.Code;
                var para = { ReportType: node.Code };
                para = CreateParameter(ReportDataAction.ActionType.Post, ReportDataAction.Functions.FillReport, ReportDataAction.Methods.FillReportMethods.GetReportCycle, para);
                DataManager.sendData(urls.ReportCycle, para, resultManager.success, resultManager.fail, false);

            },
            //检索汇总记录
            doSearch: function () {
                var para = {
                    Year: $("#nd").combobox("getValue"),
                    Cycle: $("#zq").combobox("getValue"),
                    TemplateId: currentState.TemplateHelp.value.val()
                };
                $("#reportGrid").datagrid("reload", para);
            },
            //查询取消
            CancelSearch: function () {
                $("#CycleType").combobox("setValue", "");
                $("#nd").combobox("setValue", "");
                $("#nd").combobox("loadData", []);
                $("#zq").combobox("setValue", "");
                $("#zq").combobox("loadData", []);
                currentState.TemplateHelp.value.val("");
                currentState.TemplateHelp.name.val("");
                $("#reportGrid").datagrid("reload", {});
            }
        }; 
        var resultManager ={
            success:function(data){
                if(data.success){
                    $("#nd").combobox("loadData", data.obj.Nds);
                    $("#nd").combobox("setValue", data.obj.CurrentNd);
                    $("#zq").combobox("loadData", data.obj.Cycles);
                    $("#zq").combobox("setValue", data.obj.CurrentZq);
                }else{
                    MessageManager.ErrorMessage(data.sMeg);
                }
            },
            fail:function(){
                MessageManager.ErrorMessage(data.toString());
            }
        };
        //格式化汇总周期
        function formatter(value, row, index) {
            if (row.ReportType != "") {
                switch (row.ReportType) {
                    case "01":
                        value = row.Year + "年"
                        break;
                    case "02":
                        value = row.Cycle + "月";
                        break;
                    case "03":
                        value = row.Cycle + "季度"
                        break;
                    case "04":
                        value = row.Cycle + "日";
                        break;
                }
            } else if (row.Cycle.length == 4) {
                value = row.Year + "年";
            } else if (row.Cycle.length >4) {
                value = row.Cycle + "日";
            } else {
                value = row.Cycle + "月";
            }
            return value;
        }
    </script>
</head>
<body>
    <div id="toobar" style=" min-width:950px">
        <table style=" width:100%">
            <tr>    
                <td style=" width:60px">周期类型</td>
                <td style=" width:170px"><input id="CycleType" type="text"  class="easyui-combobox" data-options="url:urls.zqUrl,valueField:'Code',textField:'Name',panelHeight:'auto',onSelect:EnventManager.SelectTemplateType" /></td>
                <td style=" width:60px">汇总年度</td>
                <td style=" width:170px"><input id="nd" type="text"  class="easyui-combobox" data-options="valueField:'value',textField:'name',panelHeight:'auto'" /></td>
                <td style=" width:60px">汇总周期</td>
                <td style=" width:170px"><input id="zq" type="text"  class="easyui-combobox" data-options="valueField:'value',textField:'name',panelHeight:'auto'" /></td>
                <td style=" width:60px">汇总模板</td><td><div id="template"></div></td>
            </tr>
            <tr>
            <td style=" text-align:right" colspan="8">
                <a href="#" class="easyui-linkbutton" id="searcher" data-options="iconCls:'icon-search'" onclick="EnventManager.doSearch()" style=" margin-right:10px">查询</a>
                <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-undo'" onclick="EnventManager.CancelSearch()" style="">重置</a>
                </td>
            </tr>
        </table>
    </div>
    <table class="easyui-datagrid"  id="reportGrid"
            data-options="singleSelect:true,method:'post',fit:true,fitColumns:true,url:urls.datagrid,toolbar:toobar,sortName:'CreateTime',sortOrder:'DESC',pagination:true,onDblClickRow:EnventManager.ViewTemplateReport">
        <thead>
            <tr>
                <th data-options="field:'Id',width:80,align:'center',hidden:true"></th>
                    <th data-options="field:'TemplateCode',width:120,align:'left',sortable:true">模板编号</th>    
                    <th data-options="field:'TemplateName',width:180,align:'left',sortable:true">模板名称</th>    
                <th data-options="field:'Year',width:100,align:'left',sortable:true">汇总年度</th>
                <th data-options="field:'Cycle',width:100,align:'left',sortable:true,formatter:formatter">汇总周期</th>   
                    <th data-options="field:'CompanyName',width:180,align:'left',sortable:true">汇总单位</th>    
                <th data-options="field:'CreateTime',width:200,align:'left',sortable:true">汇总时间</th>   
            </tr>
        </thead>
    </table>
    <div id="Dialog" />
</body>
</html>