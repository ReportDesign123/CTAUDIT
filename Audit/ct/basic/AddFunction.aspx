<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddFunction.aspx.cs" Inherits="Audit.ct.basic.AddFunction" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
        <script src="../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <link href="../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="../../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
   
</head>
<body>
  <script type="text/javascript">
      var urlsAdd = {
          parentCombUrl: "../../handler/BasicHandler.ashx?ActionType=get&MethodName=comboParent&FunctionName=FunctionsMenu"
      };
      var iconData = [{
          value: '',
          text: '默认'
      },

      { value: 'icon-base16', text: 'icon-base16' },
		{ value: 'icon-plan16', text: 'icon-plan16' },
		{ value: 'icon-report_data16', text: 'icon-report_data16' },
		{ value: 'icon-report_file16', text: 'icon-report_file16' },
		{ value: 'icon-report_Formart16', text: 'icon-report_Formart16' },
		{ value: 'icon-flow16', text: 'icon-flow16' },
		{ value: 'icon-template16', text: 'icon-template16' },
		{ value: 'icon-authority16', text: 'icon-authority16' },
		{ value: 'icon-examine16', text: 'icon-examine16' },
		{ value: 'icon-system16', text: 'icon-system16' },
		{ value: 'icon-trace16', text: 'icon-trace16' },
		{ value: 'icon-right16', text: 'icon-right16' },


		{ value: 'icon-annex', text: 'icon-annex' },
		{ value: 'icon-bars', text: 'icon-bars' },
		{ value: 'icon-bing', text: 'icon-bing' },
		{ value: 'icon-blue', text: 'icon-blue' },
		{ value: 'icon-casa', text: 'icon-casa' },
		{ value: 'icon-calc', text: 'icon-calc' },
		{ value: 'icon-cale', text: 'icon-cale' },
		{ value: 'icon-conf', text: 'icon-conf' },
		{ value: 'icon-danr', text: 'icon-danr' },
		{ value: 'icon-ding', text: 'icon-ding' },
		{ value: 'icon-ding', text: 'icon-ding' },
		{ value: 'icon-doll', text: 'icon-doll' },
		{ value: 'icon-duot', text: 'icon-duot' },
		{ value: 'icon-eart', text: 'icon-eart' },
		{ value: 'icon-face', text: 'icon-face' },
		{ value: 'icon-find', text: 'icon-find' },
		{ value: 'icon-gold', text: 'icon-gold' },
		{ value: 'icon-gole', text: 'icon-gole' },
		{ value: 'icon-gree', text: 'icon-gree' },
		{ value: 'icon-grou', text: 'icon-grou' },
		{ value: 'icon-hard', text: 'icon-hard' },
		{ value: 'icon-hihi', text: 'icon-hihi' },
		{ value: 'icon-hibo', text: 'icon-hibo' },
		{ value: 'icon-hoho', text: 'icon-hoho' },
		{ value: 'icon-home', text: 'icon-home' },
		{ value: 'icon-hote', text: 'icon-hote' },
		{ value: 'icon-inpu', text: 'icon-inpu' },
		{ value: 'icon-keys', text: 'icon-keys' },
		{ value: 'icon-limi', text: 'icon-limi' },
		{ value: 'icon-lock', text: 'icon-lock' },
		{ value: 'icon-love', text: 'icon-love' },
		{ value: 'icon-mans', text: 'icon-mans' },
		{ value: 'icon-mous', text: 'icon-mous' },
		{ value: 'icon-newd', text: 'icon-newd' },
		{ value: 'icon-offe', text: 'icon-offe' },
		{ value: 'icon-orde', text: 'icon-orde' },
		{ value: 'icon-pass', text: 'icon-pass' },
		{ value: 'icon-pens', text: 'icon-pens' },
		{ value: 'icon-penc', text: 'icon-penc' },
		{ value: 'icon-prin', text: 'icon-prin' },
		{ value: 'icon-quxi', text: 'icon-quxi' },
		{ value: 'icon-relo', text: 'icon-relo' },
		{ value: 'icon-rmbs', text: 'icon-rmbs' },
		{ value: 'icon-road', text: 'icon-road' },
		{ value: 'icon-sand', text: 'icon-sand' },
		{ value: 'icon-seal', text: 'icon-seal' },
		{ value: 'icon-seal', text: 'icon-seal' },
		{ value: 'icon-shee', text: 'icon-shee' },
		{ value: 'icon-spec', text: 'icon-spec' },
		{ value: 'icon-star', text: 'icon-star' },
		{ value: 'icon-stgo', text: 'icon-stgo' },
		{ value: 'icon-talk', text: 'icon-talk' },
		{ value: 'icon-task', text: 'icon-task' },
		{ value: 'icon-user', text: 'icon-user' },
		{ value: 'icon-yiyi', text: 'icon-yiyi' },
		{ value: 'icon-yuan', text: 'icon-yuan' },
		{ value: 'icon-zhen', text: 'icon-zhen' },
		{ value: 'icon-zhus', text: 'icon-zhus' },

		{
		    value: 'icon-add',
		    text: 'icon-add'
		}, {
		    value: 'icon-edit',
		    text: 'icon-edit'
		}, {
		    value: 'icon-remove',
		    text: 'icon-remove'
		}, {
		    value: 'icon-save',
		    text: 'icon-save'
		}, {
		    value: 'icon-cut',
		    text: 'icon-cut'
		}, {
		    value: 'icon-ok',
		    text: 'icon-ok'
		}, {
		    value: 'icon-no',
		    text: 'icon-no'
		}, {
		    value: 'icon-cancel',
		    text: 'icon-cancel'
		}, {
		    value: 'icon-reload',
		    text: 'icon-reload'
		}, {
		    value: 'icon-search',
		    text: 'icon-search'
		}, {
		    value: 'icon-print',
		    text: 'icon-print'
		}, {
		    value: 'icon-help',
		    text: 'icon-help'
		}, {
		    value: 'icon-undo',
		    text: 'icon-undo'
		}, {
		    value: 'icon-redo',
		    text: 'icon-redo'
		}, {
		    value: 'icon-back',
		    text: 'icon-back'
		}, {
		    value: 'icon-sum',
		    text: 'icon-sum'
		}, {
		    value: 'icon-tip',
		    text: 'icon-tip'
		}];
		$(
        function () {
            $("#Icon").combobox({
                data: iconData,
                valueField: 'value',
                textField: 'text'
            });
        }
        );
		
        //获取参数
      function getParameters(actionType,methodName) {
          var params = {};
          params["Code"] = $("#Code").val();
          params["Name"] = $("#Name").val();
          params["Icon"] = $('#Icon').combobox('getValue');
          params["Url"] = $("#Url").val();
          params["Sequence"] = $("#Sequence").val();
          params["Parent"] = $("#Parent").combotree('getValue');
          params["ActionType"] = actionType;
          params["FunctionName"] = "FunctionsMenu";
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
 <input id="Id" value="<%=function.Id %>"  type="hidden"/>
   <table style="margin:auto; padding:20px;">

   <tr style="height:30px;"><td>编号</td><td><input id="Code" value="<%=function.Code %>" type="text" class="easyui-validatebox textbox"  style="height:20px;width:170px;line-height: 25px;"/></td></tr>
   <tr><td>名称</td><td><input id="Name" type="text" value="<%= function.Name %>" class="easyui-validatebox textbox right"  style="height:20px;width:170px"/></td></tr>
   <tr><td>图标</td><td><input  id="Icon"  value="<%=function.Icon %>" style="height:30px;width:170px" /></td></tr>
   <tr><td>链接</td><td><input id="Url" type="text" value="<%=function.Url %>" class="easyui-validatebox textbox right" style="height:20px;width:170px" /></td></tr>
   <tr><td>顺序号</td><td><input id="Sequence" type="text" value="<%=function.Sequence %>" class="easyui-numberbox" data-options="precision:1"  style="height:20px;width:170px"/></td></tr>
   <tr><td>父级</td><td><input id="Parent" type="text" value="<%=function.Parent %>" class="easyui-combotree" data-options="valueField:'id',textField:'text',url:urlsAdd.parentCombUrl" style="height:20px;width:170px" /></td></tr>
   </table>

</body>
</html>
