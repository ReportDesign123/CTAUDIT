<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReportStateAggregationDetail.aspx.cs" Inherits="Audit.ct.ReportData.ReportStateAggregationDetail" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
 <title>资料状态汇总结果</title>
     <script src="../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <link href="../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="../../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script src="../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <script src="../../lib/json2.js" type="text/javascript"></script>.
    <link href="../../Styles/Common.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
    numbLink:link{text-decoration:none;}
    numbLink:visited{text-decoration:none; }
    numbLink:active{text-decoration:none;}
    .numbLink{
         text-decoration:none;
         font-size:14px;
    }
    .icon-excel{
        background:url('../../images/ReportData/导出Excel-16.png') no-repeat center center;
    }
    </style>
     <script type="text/javascript">
         var urls = {
             ReportListUrl: "ct/ReportData/ReportStateAggregationCompanies.aspx",
             functiontUrl:"../../handler/ReportDataHandler.ashx"
         };
         var currentState = { param: { TaskId: "", PaperId: "", ReportId: "",CompanyId:"", Nd: "", Zq: "", State: ""},ListData:[] };
         var reportList;
         var stateCodeObj = { '00': 'WtbNum', '01': 'TbNum', '02': 'JYTG', '03': 'JYBTG', '04': 'BJSHTG', '08': 'SJSHTG', '09': 'SJSHBTG' }; //记录所有状态的field 做字典
         var stateNameObj = { '00': '未填报', '01': '填报', '02': '校验通过', '03': '校验不通过', '04': '本级审核通过', '08': '上级审核通过', '09': '上级审核不通过' }; //记录所有状态的name 做字典
         
         $(function () {
             //解析url 获取参数 
             var location = window.location.toString();
             var paramStr = location.split("=")[1];
             paramStr = decodeURI(paramStr);
             currentState.param = JSON2.parse(paramStr);
             var columns = ControlManager.CreatColumns();
             reportList = $("#reportList").datagrid({
                 fit: true,
                 toolbar:"#toolbar",
                 border: false,
                 fitColumns: true,
                 singleSelect: true,
                 sortOrder: 'desc',
                 pagination:true,
                 pageSize:10,
                 sortName: 'CreateTime',
                 columns: columns
             });
             ControlManager.LoadData();
             //回车监听,
             $("#CompanyCode").keypress(function (e) {
                 var curKey = e.which;
                 if (curKey == 13) {
                     SearchManager.doSearch();
                 }
             });
             $("#CompanyName").keypress(function (e) {
                 var curKey = e.which;
                 if (curKey == 13) {
                     SearchManager.doSearch();
                 }
             });
         });
         var ControlManager = {
             //加载列表数据
             LoadData: function () {
                 var paramter = CreateParameter(ReportDataAction.ActionType.Grid, ReportDataAction.Functions.ReportStateAggregation, ReportDataAction.Methods.ReportStateAggregationMethods.GetReportStateAggregationByCompany, currentState.param);
                 DataManager.sendData(urls.functiontUrl, paramter, resultManager.successLoad, resultManager.fail);
             },
             //点击查看汇总数据
             onClick: function (Index, State) {
                 var parameter = { TaskId: "", PaperId: "", ReportId: "", CompanyId: "", Nd: "", Zq: "", State: "" };
                 parameter.TaskId = currentState.param.TaskId;
                 parameter.PaperId = currentState.param.PaperId;
                 parameter.ReportId = currentState.param.ReportId;
                 parameter.Nd = currentState.param.Nd;
                 parameter.Zq = currentState.param.Zq;
                 parameter.State = State;
                 var rows = reportList.datagrid("getRows");
                 var selectedRow = rows[Index];
                 parameter.CompanyId = selectedRow.CompanyId;
                 var paramStr = JSON2.stringify(parameter);
                 paramStr = encodeURI(paramStr);
                 parent.NavigatorNode({ id: "097", text: stateNameObj[State] + "报表列表", attributes: { url: urls.ReportListUrl + "?para=" + paramStr} });
             },
             //组织需要显示的列
             CreatColumns: function () {
                 var states = currentState.param.State.split(",");
                 var columns = [[
                 //{ field: 'CompanyId', checkbox: true },
			        {field: 'CompanyCode', title: '单位编号', width: 90 },
			        { field: 'CompanyName', title: '单位名称', width: 200 }
                    ]];
                 $.each(states, function (index, state) {
                     var field = { field: stateCodeObj[state], title: stateNameObj[state], width: 90, align: 'right', formatter: function (value, row, index) {
                         return '<a href="#" class="numbLink" id="' + index + '" onclick="ControlManager.onClick(this.id,this.name)" name="' + state + '">' + value + '</a>'
                     }
                     };
                     columns[0].push(field);
                 });
                 return columns;
             },
             //前台分页过滤 
             pagerFilter: function (data) {
                 if (typeof data.length == 'number' && typeof data.splice == 'function') {    // 判断数据是否是数组
                     data = {
                         total: data.length,
                         rows: data
                     }
                 }
                 var dg = $(this);
                 var opts = dg.datagrid('options');
                 var pager = dg.datagrid('getPager');
                 pager.pagination({
                     onSelectPage: function (pageNum, pageSize) {
                         opts.pageNumber = pageNum;
                         opts.pageSize = pageSize;
                         pager.pagination('refresh', {
                             pageNumber: pageNum,
                             pageSize: pageSize
                         });
                         dg.datagrid('loadData', data);
                     }
                 });
                 if (!data.originalRows) {
                     data.originalRows = (data.rows);
                 }
                 var start = (opts.pageNumber - 1) * parseInt(opts.pageSize);
                 var end = start + parseInt(opts.pageSize);
                 data.rows = (data.originalRows.slice(start, end));
                 return data;
             },
             Excel: function () {
                 var paramter = CreateParameter(ReportDataAction.ActionType.Grid, ReportDataAction.Functions.ReportStateAggregation, ReportDataAction.Methods.ReportStateAggregationMethods.ExportReportStateAggregationByCompanies, currentState.param);
                 var states = currentState.param.State.split(",");
                 var NameStr = "";
                 var CodeStr = "";
                 $.each(states, function (index, state) {
                     CodeStr += stateCodeObj[state] + ',';
                     NameStr += stateNameObj[state] + ',';
                 });
                 if (CodeStr.length > 0) {
                     paramter.CodeStr = CodeStr.substring(0, CodeStr.length - 1);
                     paramter.NameStr = NameStr.substring(0, NameStr.length - 1);
                 }
                 var url = CreateGeneralUrl(urls.functiontUrl, paramter);
                 window.location = url;
                 //DataManager.sendData(urls.functiontUrl, paramter, resultManager.successExcel, resultManager.fail);
             }
         };
         var SearchManager = {
             doSearch: function () {
                 var CompanyCode = $("#CompanyCode").val();
                 var CompanyName = $("#CompanyName").val();
                 var NewData = currentState.ListData;
                 if (CompanyCode != "" || CompanyName != "") {
                     NewData = SearchManager.search(CompanyCode, "CompanyCode", NewData);
                     NewData = SearchManager.search(CompanyName, "CompanyName", NewData);
                 }
                 reportList.datagrid({ loadFilter: ControlManager.pagerFilter }).datagrid('loadData', NewData);
             },
             freeSearch: function () {
                 $("#CompanyCode").val("");
                 $("#CompanyName").val("");
                 reportList.datagrid({ loadFilter: ControlManager.pagerFilter }).datagrid('loadData', currentState.ListData);
             },
             //查询方法
             // [value]查询内容 [key]指定属性 [data] 数据data  
             //支持 对属性的模糊查询
             //张双义
             search: function (value, key, data) {
                 if (value == "") return data;
                 var result;
                 var newData = [];
                 for (var i = 0; i < data.length; i++) {
                     result = SearchManager.find(value, data[i][key]);
                     if (result) { newData.push(data[i]); }
                 }
                 return newData;
             },
             find: function (sFind, sObj) {
                 var nSize = sFind.length;
                 var nLen = sObj.length;
                 var sCompare;
                 if (nSize <= nLen) {
                     for (var i = 0; i <= nLen - nSize + 1; i++) {
                         sCompare = sObj.substring(i, i + nSize);
                         if (sCompare == sFind) {
                             return true;
                         }
                     }
                 }
                 return null;
             }
         };
         var resultManager = {
             successLoad: function (data) {
                 if (data.success) {
                     currentState.ListData = data.obj;
                     reportList.datagrid({ loadFilter: ControlManager.pagerFilter }).datagrid('loadData', data.obj);
                     //reportList.datagrid("loadData", data.obj);
                 } else {
                     MessageManager.ErrorMessage(data.sMeg);
                 }
             },
             successExcel: function () {
                 MessageManager.InfoMessage("数据 已成功导出！");
             },
             fail: function (data) {
                 MessageManager.ErrorMessage(data.toString);
             }
         };
     </script>
</head>
<body class="easyui-layout">
 <div data-options="region:'north'" style="height:32px; padding:2px; overflow:hidden;background-color:#E0ECFF ;">
        <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-excel'" onclick="ControlManager.Excel()" style="width:120px; float:left "plain="true">导出Excel</a>
        <div class="datagrid-btn-separator"></div>
 </div>
 <div data-options="region:'center'">
    
    <table id="reportList"></table>
    <div id="toolbar">
        <table style="width:100%">
        <tr>
            <td style="width:60px">单位编号</td><td style="width:170px"><input id="CompanyCode"  type="text" class="easyui-validatebox textbox"/></td>
            <td style="width:60px">单位名称</td><td><input id="CompanyName"  type="text" class="easyui-validatebox textbox"/></td>
            <td style=" float:right"><a class="easyui-linkbutton" onclick="SearchManager.freeSearch()" iconcls="icon-undo" style="">重置</a></td>
            <td style=" float:right"><a class="easyui-linkbutton" onclick="SearchManager.doSearch()" iconcls="icon-search" style=" margin-right:10px">查询</a></td>
        </tr>
        </table>
    </div>

 </div>
</body>
</html>
