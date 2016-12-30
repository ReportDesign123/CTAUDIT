<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddAuditPaper.aspx.cs" Inherits="Audit.ct.AuditPaper.AddAuditPaper" %>
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


</head>
<body>
    <script src="../../Scripts/Ct_Controls.js" type="text/javascript"></script>
    <link href="../../Styles/Ct_Controls.css" rel="stylesheet" type="text/css" />
  
 <input id="Id" value="<%=ape.Id %>"  type="hidden"/>
  <input id="Hidden1" value="<%=ape.TemplateId %>"  type="hidden"/>
   <input id="Hidden2" value="<%=ape.TemplateName %>"  type="hidden"/>

   <table style="margin:auto; padding:20px;">

   <tr style="height:30px;"><td>编号</td><td><input id="Code" value="<%=ape.Code %>" type="text" class="easyui-validatebox textbox"  style="height:20px;width:150px;line-height: 25px;"/></td></tr>
   <tr><td>名称</td><td><input id="Name" type="text"value="<%=ape.Name %>"  class="easyui-validatebox textbox right"  style="height:20px;width:150px"/></td></tr>
   <tr style=" display:none"><td>底稿报告模板</td><td><div id="Template"></div></td></tr>
   <tr><td>默认报表周期</td><td><input id="DefaultZq" type="text"value="<%=ape.DefaultZq %>"  class="easyui-combobox right" style="height:20px;width:157px"/></td></tr>
      </table>
    <script type="text/javascript">
        //获取参数
        var template;
        function getParameters(actionType, methodName) {
            var params = {};
            params["Code"] = $("#Code").val();
            params["Name"] = $("#Name").val();
            params["TemplateId"] = template.value.val();

            params["DefaultZq"] = $("#DefaultZq").combobox("getValue");

            params["ActionType"] = actionType;
            params["FunctionName"] = AuditPaperAction.Functions.AuditPaperManagerMenu;
            params["MethodName"] = methodName;
            var id = $("#Id").val();
            if (id != null && id != undefined && id != "") {
                params["Id"] = id;
            }
            if (params.Code == "") { MessageManager.InfoMessage("请输入编号"); return; }
            if (params.Name == "") { MessageManager.InfoMessage("请输入名称"); return; }
            //if (params.TemplateId == "") { MessageManager.InfoMessage("请选择底稿模板"); return; }
            //if (params.DefaultZq == "") { MessageManager.InfoMessage("请选择报表周期类型"); return; }

            return params;

        }
        var ZqTypeComboData = [{
            value: "01",
            text: '年报'
        }, { value: "02", text: '月报'
        }, { value: "03", text: '季报 '
        }, { value: "04", text: '日报'
        }, { value: "05", text: '周报'
        }];
        $(function () {
            template = $("#Template").PopEdit();
            template.btn.bind("click", function () {
                var paras = { url: "", columns: [], sortName: "", sortOrder: "",NameField:"Name",CodeField:"Code" };
                paras.url = "../../handler/AuditPaperHandler.ashx?ActionType=" + AuditPaperAction.ActionType.Grid + "&MethodName=" + AuditPaperAction.Methods.AuditPaperMenuMethods.getDataGrid + "&FunctionName=" + AuditPaperAction.Functions.AuditPaperMenu;
                paras.columns = [[{ field: "Id", title: "Id", width: 80, hidden: true },
                        { field: "Code", title: "编号", width: 80 },
                            { field: "Name", title: "名称", width: 150 }
                        ]];
                paras.sortName = "CreateTime";
                paras.sortOrder = "DESC";
                var result = window.showModalDialog("../pub/HelpDialog.aspx", paras, "dialogHeight:390px;dialogWidth:320px");
                if (result && result.Id) {
                    template.name.val(result.Name);
                    template.value.val(result.Id);
                }

            });
            $("#DefaultZq").combobox({
                data: ZqTypeComboData,
                valueField: 'value',
                textField: 'text'
            });
            template.name.val($("#Hidden2").val());
            template.value.val(($("#Hidden1").val()));
        });

        
        </script>
</body>
</html>