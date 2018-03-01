<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="NewReport.aspx.cs" Inherits="Audit.ct.Format.NewReport" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>新建报表</title>
    <script src="../../lib/jquery/jquery-1.5.2.min.js" type="text/javascript"></script>
    <link href="../../lib/ligerUI/skins/ligerui-icons.css" rel="stylesheet" type="text/css" />  
    <link href="../../lib/ligerUI/skins/Aqua/css/ligerui-all.css" rel="stylesheet"
        type="text/css" />
     <script src="../../lib/ligerUI/js/core/base.js" type="text/javascript"></script>
    <script src="../../lib/ligerUI/js/ligerui.min.js" type="text/javascript"></script>
    <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script src="../../Scripts/AjaxTrigger.js" type="text/javascript"></script>

    <link href="../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="../../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../../Scripts/ct/pub/PubHelp.js" type="text/javascript"></script>
    <style type="text/css">    
        body{ font-size:12px;}
        .l-table-edit {} 
        .l-table-edit-td{ padding:12px; width:220px;}
        .l-button-submit,.l-button-reset{width:80px; float:left; margin-left:10px; padding-bottom:2px;}
        .l-verify-tip{ left:230px; top:120px;}

      
    </style>
    <script type="text/javascript">
        var controls = { code: {}, name: {}, col: {}, row: {}, zq: {}, classify: {} };
        var zqUrl = "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Get + "&MethodName=GetDictionaryListByClassType&FunctionName=" + BasicAction.Functions.DictionaryManager + "&ClassType=BBZQ";
        $(function () {
            controls.code = $("#code").ligerTextBox({ nullText: '不能为空' });
            controls.name = $("#name").ligerTextBox({ nullText: '不能为空' });
            controls.row = $("#row").ligerTextBox({ nullText: '不能为空', digits: true });
            controls.col = $("#col").ligerTextBox({ nullText: '不能为空', digits: true });
            controls.zq = $("#zq").ligerComboBox({
                url: zqUrl, valueFieldID: 'test3', valueField: "Code", textField: "Name"
            });

            ///帮助窗口声明
            controls.classify=$("#classify").ligerPopupEdit({
                onbuttonclick: classify_ClickEvent,
                width: 129
            });
            $("#sure").bind("click", function () {
                var para = {};
                if (!controls.code.getValue()) { alert("编号不能为空"); return; }
                if (!controls.name.getValue()) { alert("名称不能为空"); return; }
                if (!controls.col.getValue()) { alert("列数不能为空"); return; }
                if (!controls.row.getValue()) { alert("行数不能为空"); return; }
                if (!controls.zq.getValue()) { alert("报表周期不能为空"); return; }
                if (!controls.classify.getValue()) { alert("报表类别不能为空"); return; }
                para["code"] = controls.code.getValue();
                para["name"] = controls.name.getValue();
                para["col"] = controls.col.getValue();
                para["row"] = controls.row.getValue();
                para["zq"] = controls.zq.getValue() + ":" + controls.zq.getText();
                para["classifyId"] = controls.classify.getValue();
               
                var modalid = $(window.frameElement).attr("modalid");
                dialog.setVal(para);
                dialog.close(modalid);
            });


            $("#cancel").bind("click", function () {
                var modalid = $(window.frameElement).attr("modalid");
              
                dialog.close(modalid);
            });

        }
    );
        function classify_ClickEvent() {
            var paras = { sortOrder: "ASC", sortName: "Code", Field: "Code,Name" }
            paras.parameter = CreateParameter(ReporClassifyAction.ActionType.Post, ReporClassifyAction.Functions.ReportClassify, ReporClassifyAction.Methods.ReportClassifyMethods.GetClassifiesList, {});
            paras.functionsUrl = "../../handler/FormatHandler.ashx";
            paras.columns = [[
                { field: "Id", title: "id", hidden: true, width: 120 },
                { field: "Code", title: "分类编号", width: 80 },
                    { field: "Name", title: "分类名称", width: 100 }
                    ]];

            paras.width = 300;
            paras.height = 370;
            pubHelp.setParameters(paras);
            pubHelp.OpenDialogWithHref("Dialog", "报表分类选择", "../pub/HelpList.aspx", getClassifyChoice, paras.width, paras.height, true);
        }
        function getClassifyChoice() {
            var result = pubHelp.getResultObj();
            if (result && result.Id != undefined) {
                controls.classify.setValue(result.Id);
                controls.classify.setText(result.Name);
            }
        }
    </script>

</head>
<body>
  <table cellpadding="0" cellspacing="0px" class="l-table-edit"  style="width:100%;height:95%; margin-top:25px">
  <tr>
  <td align="right" >报表编号</td><td class="l-table-edit-td"><input name="code" type="text" id="code"/></td>
  </tr>
  <tr>
  <td align="right" >报表名称</td><td class="l-table-edit-td"><input name="name" type="text" id="name" /></td>
  </tr>
   <tr>
  <td align="right">报表行数</td><td class="l-table-edit-td"><input name="row" type="text" id="row" /></td>
  </tr>
  <tr>
  <td align="right" >报表列数</td><td class="l-table-edit-td"><input name="col" type="text" id="col"  /></td>
  </tr>

    <tr>
  <td align="right">报表周期</td><td class="l-table-edit-td">
  <input name="zq" type="text" id="zq" />
  </td>
  </tr>
  <tr>
  <td align="right" >报表类别</td><td class="l-table-edit-td"><input type="text" id="classify"/>
  </td>
  </tr>
  
  </table>
  <div style="text-align:right; vertical-align:bottom; width:100% ;bottom:25px; position:absolute">
      <input id="sure" class="l-button" type="button" value="确 &nbsp 定" style=" margin-right:10px" onmouseover="this.style.background='lightblue'"onmouseout="this.style.backgroundColor='';"/> 
      <input id="cancel" type="button" class="l-button" value="取 &nbsp 消" style=" margin-right:10px" onmouseover="this.style.background='lightblue'"onmouseout="this.style.backgroundColor='';" /></td>
  </div>
  <div id="Dialog"></div>
</body>
</html>
