<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddPosition.aspx.cs" Inherits="Audit.ct.basic.AddPosition" %>

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
</head>
<body>
  <script type="text/javascript">
      var urlsAdd = {
          parentCombUrl: "../../handler/BasicHandler.ashx?ActionType=get&MethodName=ParentCombo&FunctionName=" + BasicAction.Functions.PositionManager
      };
      var mxData = [{
          value: 1,
          text: '明细'
      },
		{ value: 0, text: '非明细' },
		];
      $(
        function () {
            $("#Mx").combobox({
                data: mxData,
                valueField: 'value',
                textField: 'text'
            });
        }
        );

      //获取参数
      function getParameters(actionType, methodName) {
          var params = {};
          params["Code"] = $("#Code").val();
          params["Name"] = $("#Name").val();
          params["Sequence"] = $("#Sequence").val();
          params["ParentId"] = $("#ParentId").combotree('getValue');
          params["ActionType"] = actionType;
          params["FunctionName"] = BasicAction.Functions.PositionManager;
          params["MethodName"] = methodName;
          var id = $("#Id").val();
          if (id != null && id != undefined && id != "") {
              params["Id"] = id;
          }
          return params;

      }

      function setParentValue(id) {
          $("Parent").combotree("setValue", id);
      }
    </script>
 <input id="Id" value="<%=position.Id %>"  type="hidden"/>
   <table style="margin:auto; padding:20px;">

   <tr style="height:30px;"><td>编号</td><td><input id="Code" value="<%=position.Code %>" type="text" class="easyui-validatebox textbox"  style="height:20px;width:165px;line-height: 25px;"/></td></tr>
   <tr><td>名称</td><td><input id="Name" type="text" value="<%= position.Name %>" class="easyui-validatebox textbox right"  style="height:20px;width:165px"/></td></tr>
   <tr><td>顺序号</td><td><input id="Sequence" type="text" value="<%=position.Sequence %>" class="easyui-numberbox" data-options="precision:0"  style="height:20px;width:170px"/></td></tr>
   <tr><td>父级</td><td><input id="ParentId" type="text" value="<%=position.ParentId %>" class="easyui-combotree" data-options="valueField:'id',textField:'text',url:urlsAdd.parentCombUrl" style="height:20px;width:170px" /></td></tr>
   </table>

</body>
</html>