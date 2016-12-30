<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddProcedureFormular.aspx.cs" Inherits="Audit.ct.basic.AddProcedureFormular" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>增加存储过程公式</title>
</head>
<body>
    <div id="top" style=" width:568px; margin:auto; margin-top:8px;height:80px; border: 1px solid #95B8E7;">
        <input id="Id" type="hidden" value="<%=pfe.Id %>" />
        <input id="proInput" type="hidden" value="<%=pfe.Name %>" />
        <span id="parameters"  style="display:none"><%=pfe.Parameters %></span>
        <table style=" width:100%; height:100%">
            <tr><td>数据源</td><td colspan="3"><input class="easyui-combobox" name="language" value="<%=pfe.DataSource %>"  id="DataSource" data-options=" 
            url:urls.DataSourceUrl, 
            method: 'post', 
            valueField: 'Id', 
            textField: 'Name', 
            panelHeight: 'auto' 
            " /></td></tr>
            <tr><td>存储过程</td><td><div id="formulars"></div></td><td>存储过程名称</td><td><input id="name" value="<%=pfe.NameValue %>"  type="text" /></td></tr>
        </table>
    </div>
    <div id="bottom" style="width:570px; margin:auto;">
        <div id="left" style=" margin-top:8px; height:260px; width:45%; border: 1px solid #95B8E7; float:left;">
            <table class="easyui-datagrid"  id="parameterGrid"
                    data-options="singleSelect:true,method:'post',fit:true,border:false,pagination:false,onSelect:SelectEvent">
                <thead>
                    <tr>
                        <th data-options="field:'Name',align:'center',query:true,width:120">参数名</th>
                        <th data-options="field:'Type',align:'center',width:80">参数类型</th>
                    </tr>
                </thead>
            </table> 
        </div>
        <div id="right" style=" margin-top:8px; height:260px; width:52%; float:right; border: 1px solid #95B8E7;">
            <table style=" width:100%; height:100%">
                <tr><td>参数名</td><td style=" padding-left:10px"><input id="parameterName"  type="text" /></td></tr>
            </table>
        </div>
    </div>
    <script type="text/javascript">
        var procedure = "";       
        var parameters = {};
        var currentParameter = "";
        var parameterNameControl = {};
        $(
        function () {
            $("#name").CTTextBox({ height: 22 });
            $("#parameterName").CTTextBox({ height: 22 });
            $("#parameterName").bind("change", function () { SaveParameter(); });
            procedure = $("#formulars").PopEdit();
            procedure.btn.bind("click", function () {
                var paras = { url: "", columns: [], sortName: "", sortOrder: "", DataSourceId: "", NameField: "Name",CodeField:"Id" };
                paras.DataSourceId = $("#DataSource").combobox('getValue');
                if (paras.DataSourceId == "") { alert("数据源不能为空"); return; };
                paras.url = "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Grid + "&MethodName=" + BasicAction.Methods.ProcedureMethods.GetProcedureDataGrid + "&FunctionName=" + BasicAction.Functions.Procedure + "&DataSourceId=" + paras.DataSourceId;
                paras.columns = [[{ field: "Id", title: "存储过程ID", width: 120 },
{ field: "Name", title: "存储过程名称", width: 200 }

]];
                paras.sortName = "Id";
                paras.sortOrder = "DESC";

                pubHelp.setParameters(paras);
                pubHelp.OpenDialogWithHref("HelpDialog", "系统帮助", "../pub/HelpDialogEasyUi.htm", ProcedurePopEditSave, 600, 450, true);
                //var result = window.showModalDialog("../pub/HelpDialog.aspx", paras, "dialogHeight:350px;dialogWidth:330px");
            });
            if ($("#Id").val() != "") {
                parameters = JSON2.parse($("#parameters").text());
                var data = [];
                $.each(parameters, function (name, parameter) { data.push(parameter) });
                $("#parameterGrid").datagrid({ data: data });
                procedure.name.val($("#proInput").val());
            }
        }
        );
        function ProcedurePopEditSave() {
            var result = pubHelp.getResultObj();
            if (result && result.Id) {
                var para = { procedureId: "", DataSourceId: "" };
                para.DataSourceId = $("#DataSource").combobox('getValue');
                para.procedureId = result.Id;
                procedure.name.val(result.Name);
                para = CreateParameter(BasicAction.ActionType.Post, BasicAction.Functions.Procedure, BasicAction.Methods.ProcedureMethods.DataGridParameters, para);
                $("#name").val(result.Name);
                DataManager.sendData("../../handler/BasicHandler.ashx", para, Success, Fail, false);
            }
        }
        function Success(data) {
            try {
                if (data.success) {
                    $("#parameterGrid").datagrid("loadData", data.obj);
                } else {
                    MessageManager.ErrorMessage(data.sMeg);
                }
            } catch (err) {
            MessageManager.ErrorMessage(err.Message);
            }
       }
       function Fail(data) {
           MessageManager.ErrorMessage(data.sMeg);
       }
       function SelectEvent(rowIndex, rowData) {
           try {
               SaveParameter();
               currentParameter = rowData.Name;
               if (!parameters[rowData.Name]) {
                   parameters[rowData.Name] = {Name:rowData.Name,Type:rowData.Type,Value:rowData.Name,Id:rowData.Id};
               } 
               $("#parameterName").val(parameters[rowData.Name].Name);
               
              
           } catch (err) {
           MessageManager.ErrorMessage(err.Message);
           }
   }
   function SaveParameter() {
       if (currentParameter != "") {
           parameters[currentParameter].Name = $("#parameterName").val();
       }

   }

   function GetParameter() {
       SaveParameter();
       var para = { Name: "", NameValue: "", Parameters: "",Id:"" ,DataSource:""};
       para.Name = procedure.name.val();
       para.NameValue = $("#name").val();
       para.Parameters = JSON2.stringify(parameters);
       para.DataSource = $("#DataSource").combobox("getValue");
       if ($("#Id").val() != "") {
           para.Id = $("#Id").val();
       }
       return para;
   }
    </script>
</body>
</html>
