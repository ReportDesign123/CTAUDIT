<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CreateTemplate.aspx.cs" Inherits="Audit.ct.ExportReport.CreateTemplate" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">    
<title></title>
    <script src="../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <link href="../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="../../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>

    <link href="../../Styles/Ct_Controls.css" rel="stylesheet" type="text/css" />
    <script src="../../Scripts/Ct_Controls.js" type="text/javascript"></script>
    

</head>
<body  runat="server">
  <script type="text/javascript">
      var aboutReportUrl = "ExportRelationReports.aspx";
      var zqUrl = "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Get + "&MethodName=GetDictionaryListByClassType&FunctionName=" + BasicAction.Functions.DictionaryManager + "&ClassType=BBZQ";
      var ExportTypeUrl = "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Get + "&MethodName=GetDictionaryListByClassType&FunctionName=" + BasicAction.Functions.DictionaryManager + "&ClassType=DCLX";

      var controls = {};
      $(function () {
          controls.aboutReport = $("#aboutReport").PopEdit();
          controls.aboutReport.name.css("height", "25px");
          controls.aboutReport.btn.css("height", "29px");
          controls.aboutReport.btn.css("width", "20px");
          controls.aboutReport.btn.bind("click", function () {
              aboutReportBt_click();
          });
           
      });
      function initialiseParam() {
          $("#Id").val(currentState.inEditTemplate.Id);
          $("#Code").val(currentState.inEditTemplate.Code);
          $("#Name").val(currentState.inEditTemplate.Name);
          $("#Cycle").combobox("setValue", currentState.inEditTemplate.Cycle);
          $("#ExportType").combobox("setValue", currentState.inEditTemplate.ExportType);      
      }
      function aboutReportBt_click() {
          var para = { CycleType: "" };
          para.CycleType = $("#Cycle").combobox("getValue");
          var result = window.showModalDialog(aboutReportUrl, para, "dialogHeight:600px;dialogWidth:900px");
          if (result && result.length > 0) {

          }
  }
  //获取参数
  function getParameters(actionType, methodName) {
      var params = {};
      params["Code"] = $("#Code").val();
      params["Name"] = $("#Name").val();
      params["Cycle"] = $('#Cycle').combobox('getValue');
      params["ExportType"] = $('#ExportType').combobox('getValue');
      params["ActionType"] = actionType;
      params["FunctionName"] = ExportAction.Functions.ReportTemplate;
      params["MethodName"] = methodName;

      var id = $("#Id").val();
      if (id != null && id != undefined && id != "") {
          params["Id"] = id;
      }
      if (params["Code"] == "") {
          alert("请输入编号");
          return;
      }
      if (params["Name"] == "") {
          alert("请输入名称");
          return;
      }
      if (params["Cycle"] == "") {
          alert("请选择周期");
          return;
      } 

      return params;

  }
       </script>
 <input id="Id" value="<%=rte.Id %>"  type="hidden"/>
   <table style="margin:auto; padding:20px; width:90%" cellspacing="18px">
   <tr><td>编号</td><td><input id="Code"  value="<%=rte.Code %>" type="text" class="easyui-validatebox textbox"  style="height:25px;width:170px"/></td></tr>
   <tr><td>名称</td><td><input id="Name" type="text"  value="<%=rte.Name %>" class="easyui-validatebox textbox"  style="height:25px;width:170px"/></td></tr>
   <tr><td>周期</td><td><input id="Cycle" type="text" value="<%=rte.Cycle %>"  class="easyui-combobox" data-options="url:zqUrl,valueField:'Code',textField:'Name',panelHeight:'auto'" style="height:28px;width:175px"/></td></tr>
   <tr><td>导出类型</td><td><input id="ExportType"  value="<%=rte.ExportType %>" class="easyui-combobox"data-options="url:ExportTypeUrl,valueField:'Code',textField:'Name',panelHeight:'auto'" style="height:28px;width:175px"/></td></tr>
    <%--<tr><td colspan="2"><div style="float:left; padding-top:10px"><input type="checkbox" style="float:left; margin-bottom:5px; margin-right:5px"/>导出是否关联报表</div><div id="aboutReport" style="float:right;margin-top:0px"></div></td></tr>--%>
   </table>

</body>
</html>
