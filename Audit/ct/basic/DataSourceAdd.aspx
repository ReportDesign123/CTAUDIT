<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DataSourceAdd.aspx.cs"   Inherits="Audit.ct.basic.DataSourceAdd" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html id="Head1"xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <link href="../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="../../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script src="../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
   
</head>
<body id="Body1" runat="server">
   <input id="Id" value="<%=dse.Id %>"type="hidden"/>
   <input id="DbName" type="hidden" value="<%=dse.Db %>" />
   <p> &nbsp&nbsp&nbsp 指定下列设置创建新的数据源:</p>
   <table style="float:inherit">
        <tr><td>&nbsp&nbsp&nbsp&nbsp&nbsp 1.创建一个新的数据源：</td></tr>
   </table>
   <table style="margin:auto;padding:5px; ">
        <tr style="height:20px;"><td>&nbsp&nbsp&nbsp&nbsp 数据源名称：</td><td><input id="Name"  value="<%=dse.Name %>" type="text" class="easyui-validatebox textbox"  style="height:20px;width:170px;"/>&nbsp&nbsp&nbsp&nbsp&nbsp</td></tr>
        <tr><td>&nbsp&nbsp&nbsp&nbsp 服务器地址：</td><td><input id="Server" type="text"  value="<%=dse.Server %>"  class="easyui-validatebox textbox" style="height:20px;width:170px"/></td></tr>
        </table>
   <table style="float:inherit">
        <tr><td>&nbsp&nbsp&nbsp&nbsp&nbsp 2.输入服务器登陆信息：</td></tr>
   </table>
   <table style="margin:auto;padding:5px; ">
        <tr><td> 数据库类型：</td><td><input id="DbType"name="DbType" type="text" value="<%=dse.DbType %>" class="easyui-combobox" style="height:23px;width:172px"/></td></tr>  
        <tr><td> 用户名：</td><td><input id="UserName" type="text" value="<%=dse.UserName %>"  class="easyui-validatebox textbox"  style="height:20px;width:170px;"/></td></tr>
        <tr><td> 密码：</td><td><input id="UserPassword" type="text" value="<%=dse.UserPassword %>"  class="easyui-validatebox textbox"  style="height:20px;width:170px;"/></td></tr>
   </table>
   <table style="float:inherit">
        <tr><td>&nbsp&nbsp&nbsp&nbsp&nbsp 3.获取服务器信息,选择数据库名：</td></tr>
   </table>
   <table style="margin:auto; ">
        <tr ><td>数据库名：&nbsp&nbsp</td><td><input id="Db"name="Db" type="text" value="<%=dse.Db %>"  data-options="valueField:'value',textField:'name'" class="easyui-combobox" style="height:23px;width:135px"/>
        <a class="easyui-linkbutton" onclick="viewDbs();">获取</a></td></tr>
   </table>
   <table style="float:inherit">
   <tr><td>&nbsp&nbsp&nbsp&nbsp&nbsp 4.设置数据源状态：</td></tr>
   </table>
   <table style="margin:auto; ">
        <tr><td> 是否启用：&nbsp&nbsp</td><td><input id="State"name="State" type="text" value="<%=dse.State %>" style="height:23px;width:173px"/></td></tr>    
        <tr style="height:40px;"><td></td>
            <td><a class="easyui-linkbutton" onclick="testLink();"style="float:right">测试数据链接</a></td></tr>
   </table>
      <script type="text/javascript">
          var dasUrl = "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Get + "&MethodName=" + BasicAction.Methods.DataSourceMethods.DataSourceInstances + "&FunctionName=" + BasicAction.Functions.DataSource;
          var functionUrl = "../../handler/BasicHandler.ashx";
          var TestResult;
          var massageToSave = false;
          ///操作对象：TestResult
          ///获得测试链接的返回结果：true/false
          ///张双义
          function getTestResult() {
              return TestResult;
          }
          ///操作对象：massageToSave
          ///用途：为true时，消息提示
          ///返回：massageToSave
          ///张双义
          function sesectMassage(ms) {
              massageToSave = ms;
          }
          ///消息处理菜单 
          var resultMassage = {
              ///参数 data
              ///用途：为数据库名combobox 加载数据 
              ///输出：combobox下拉列表选项、message
              ///张双义
              combobox: function (data) {
                  if (data.success) {
                      MessageManager.InfoMessage("数据库名，读取成功！");
                      $('#Db').combobox('loadData', data.obj);
                  } else {
                      MessageManager.ErrorMessage(data.sMeg);
                  }
              },
              success: function (data) {
                  if (data.success) {
                      MessageManager.InfoMessage(data.sMeg);
                      TestResult = true;
                  } else {
                      if (massageToSave) {
                          MessageManager.ErrorMessage('请首先确保数据链接成功！');
                          massageToSave = false;
                      } else {
                          MessageManager.ErrorMessage(data.sMeg);
                      }
                  }
              },
              fail: function (data) {
                  MessageManager.ErrorMessage(data.toString);
              }
          }
          ///调用参数：table输入框id
          ///用途：获取DataSource各项参数
          ///返回： DataSource参数和链接
          ///张双义
          function getParameters(actionType, methodName) {
              var params = {};
              params["Server"] = $("#Server").val();
              params["Name"] = $("#Name").val();
              params["UserName"] = $("#UserName").val();
              params["DbType"] = $("#DbType").combobox("getValue");
              params["Db"] = $("#Db").combobox("getValue");
              params["State"] = $("#State").combobox("getValue");
              params["UserPassword"] = $("#UserPassword").val();
              params["ActionType"] = actionType;
              params["FunctionName"] = BasicAction.Functions.DataSource;
              params["MethodName"] = methodName;
              var id = $("#Id").val();
              if (id != null && id != undefined && id != "") {
                  params["Id"] = id;
              }
              ///判断各项输入是否完整
              ///张双义
              if (params["Name"] == "" || params["Name"] == null) {
                  MessageManager.ErrorMessage('请输入数据源名称！')
                  return;
              }
              if (params["Server"] == "" || params["Server"] == null) {
                  MessageManager.ErrorMessage('请输入服务器地址！')
                  return;
              }
              if (params["UserName"] == "" || params["UserName"] == null) {
                  MessageManager.ErrorMessage('请输入用户登录账号！')
                  return;
              }
              if (params["UserPassword"] == "" || params["UserPassword"] == null) {
                  MessageManager.ErrorMessage('请输入登录密码！')
                  return;
              }
              if (params["DbType"] == "" || params["DbType"] == null) {
                  MessageManager.ErrorMessage('请选择数据库类型！')
                  return;
              }
              return params;
          }
          ///参数：无
          ///用途：获取数据库实例列表
          ///返回：数据库名列表刷新
          ///张双义
          function viewDbs() {
              var parameter = getParameters(BasicAction.ActionType.Post, BasicAction.Methods.DataSourceMethods.DataSourceInstances);
              if (parameter == null || parameter == "") { return; }
              DataManager.sendData(functionUrl, parameter, resultMassage.combobox, resultMassage.fail);
          }
          ///参数：无
          ///用途：测试数据库链接
          ///返回：massage
          ///张双义
          function testLink() {
              TestResult = false;
              var parameter = getParameters(BasicAction.ActionType.Post, BasicAction.Methods.DataSourceMethods.TestDataSource);
              if (parameter == null || parameter == "") { return; }
              if (parameter["Db"] == "" || parameter["Db"] == null) {
                  MessageManager.ErrorMessage('请点击【获取】选择一个数据库！')
                  return;
              }
              DataManager.sendData(functionUrl, parameter, resultMassage.success, resultMassage.fail);
          }
          ///类型 combobox选项列表          
          var DbTypeData = [{
              value: 'sql',
              text: 'sql'
          },
		];
          ///名称 combobox选项列表
          var DbData = [{
              value: $("#DbName").val(),
              name: $("#DbName").val()
          }
         ];
          ///状态 combobox选项列表
          var StateData = [{
              value: "1",
              text: '启用'
          }, { value: "0", text: '不启用' 
          },
		];
        var id = $("#Id").val();
        ///预置各个combobox下拉框的选项   
        ///张双义
        $(
        function () {
            $("#DbType").combobox({
                data: DbTypeData,
                valueField: 'value',
                textField: 'text'
            });  
            $("#Db").combobox({
                data: DbData,
                valueField: 'value',
                textField: 'name'
            });      
            $("#State").combobox({
                data: StateData,
                valueField: 'value',
                textField: 'text'
            });
            if (id == null || id == undefined || id == "") {
                $('#State').combobox('setValue', "1");
            } 
        }); 
   </script>
</body>
</html>
