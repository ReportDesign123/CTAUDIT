
<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="NewReport.aspx.cs" Inherits="Audit.ct.Format.NewReport" %> 

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 

<html xmlns="http://www.w3.org/1999/xhtml"> 
<head id="Head1" runat="server"> 
<title>新建报表</title> 
<link href="../../lib/ligerUI/skins/Aqua/css/ligerui-all.css" rel="stylesheet" type="text/css" /> 
<link href="../../lib/ligerUI/skins/ligerui-icons.css" rel="stylesheet" type="text/css" /> 
<link href="../../lib/ligerUI/skins/ligerui-icons.css" rel="stylesheet" type="text/css" /> 
<script src="../../lib/jquery/jquery-1.5.2.min.js" type="text/javascript"></script> 
<script src="../../lib/ligerUI/js/core/base.js" type="text/javascript"></script> 
<script src="../../lib/ligerUI/js/ligerui.min.js" type="text/javascript"></script>
     <script src="../../Scripts/ct_dialog.js"></script>
<style type="text/css"> 
body{ font-size:12px;} 
.l-table-edit {} 
.l-table-edit-td{ padding:4px;} 
.l-button-submit,.l-button-reset{width:80px; float:left; margin-left:10px; padding-bottom:2px;} 
.l-verify-tip{ left:230px; top:120px;} 

</style> 
<script type="text/javascript">
    var controls = { codeCol: {}, nameCol: {}, sortCol: {} };

    $(function () {
        //初始化数据
        var obj = dialog.para();//window.dialogArguments;
        controls.codeCol = $("#codeCol").ligerSpinner({ height: 24, type: 'int', isNegative: false, minValue: 0, maxValue: obj.num });
        controls.nameCol = $("#nameCol").ligerSpinner({ height: 24, type: 'int', isNegative: false, minValue: 0, maxValue: obj.num });
        controls.sortCol = $("#sortCol").ligerSpinner({ height: 24, type: 'int', isNegative: false, minValue: 0, maxValue: obj.num });

        $("#sure").bind("click", function () {
                var para = {};

                para["DataCode"] = controls.codeCol.getValue();
                para["DataName"] = controls.nameCol.getValue();
                para["SortField"] = controls.sortCol.getValue();
                para["Merge"] = $("#merge").attr("checked");
                  window.returnValue = para;
                  window.close();
        });
        $("#cancel").bind("click", function () {
            window.close();
        });
      
        InitializeControls(obj);

    });
    function InitializeControls(para) {
        if (para.type == "1") {
            $("#codeColSpan").text("数据编号列");
            $("#nameColSpan").text("数据名称列");
            $("#sortColSpan").text("排序列");
            $("#mergeSpan").text("相同数据项行是否合并");
        } else if (para.type == "2") {
            $("#codeColSpan").text("数据编号行");
            $("#nameColSpan").text("数据名称行");
            $("#sortColSpan").text("排序行");
            $("#mergeSpan").text("相同数据项列是否合并");
        }
        controls.codeCol.setValue(para["DataCode"]);
        controls.nameCol.setValue(para["DataName"]);
        controls.sortCol.setValue(para["SortRow"]);
        if (para["isOrNotMerge"]) {
            $("#merge").ligerCheckBox("setValue", true);
        } else {
            $("#merge").ligerCheckBox("setValue", false);
        }
        
    }
</script> 
</head> 
<body> 
    <table cellpadding="0" cellspacing="0" class="l-table-edit" style="width:100%"> 
    <tr> 
    <td align="right" class="l-table-edit-td"><span id="codeColSpan">数据编号列</span></td><td class="l-table-edit-td"><div id="codeCol"></div></td> 
    </tr> 
    <tr> 
    <td align="right" class="l-table-edit-td"><span id="nameColSpan">数据名称列</span></td><td class="l-table-edit-td"><div id="nameCol"></div></td> 
    </tr> 
    <tr> 
    <td align="right" class="l-table-edit-td"><span id="sortColSpan">排序列</span></td><td class="l-table-edit-td"><div id="sortCol"></div></td> 
    </tr> 
    <tr style=" display:none"> 
    <td align="right" class="l-table-edit-td"><span id="mergeSpan">相同数据项行是否合并</span></td><td class="l-table-edit-td"><input id="merge" type="checkbox" class="liger-checkbox" /> </td> 
    </tr> 

    <tr>
     
    <td colspan="2" class="l-table-edit-td" style="text-align:right"> 
        <input id="sure" class="l-button" type="button" value="确 &nbsp 定" onmouseover="this.style.background='lightblue'"onmouseout="this.style.backgroundColor='';"/> 
        <input id="cancel" type="button" class="l-button" value="取 &nbsp 消" onmouseover="this.style.background='lightblue'"onmouseout="this.style.backgroundColor='';" />
        </td>
    </tr> 
    </table> 
</body> 
</html> 
