<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="HelpList.aspx.cs" Inherits="Audit.ct.pub.HelpList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>系统帮助</title>
  <!--  新建报表  -->
  <!--  批量处理   -->
  <!--  报表删除   -->
  <!--  填报-->
</head>
<body>
<script type="text/javascript">
    helpControl = { ClassifyGrid: {}, gridData: [], height: "", weidth: "" };
    var para;
    var resultManagers = {
        successLoad: function (data) {
            if (data.obj) {
                helpControl.gridData = data.obj.Rows;
                helpManager.HelpClassifyGrid(helpControl.gridData, para.sortName, para.sortOrder, para.columns);
            }
        },
        fail: function (data) {
            MessageManager.ErrorMessage(data.sMeg);
        }
    }
    var helpManager = {
        HelpClassifyGrid: function (data, sortName, sortOrder, columns) {
            helpControl.ClassifyGrid = $("#ClassifyGrid").datagrid(
                {
                    fit:true,
                    data: data,
                    title: "",
                    toolbar: "#tb",
                    allowPage: false,
                    fitColumns: true,
                    pagination: false,
                    singleSelect: true,
                    sortName: sortName,
                    border:false,
                    sortOrder: sortOrder,
                    columns: columns,
                    onDblClickRow: function (rowIndex, rowData) {
                        pubHelp.setResultObj(rowData);
                        pubHelp.CloseDialog();
                    }
                });
        }
    };
    $(function () {
        Initialize();
    });
    function Initialize() {
        para = pubHelp.getParameters();
        if (para) {
            helpControl.height = para.width;
            helpControl.width = para.height;
            if (para.functionsUrl && para.parameter) {
                DataManager.sendData(para.functionsUrl, para.parameter, resultManagers.successLoad, resultManagers.fail);
            }
        }
        pubHelp.setResultObjFunc(FuncGetObj);
    }
    function FuncGetObj() {
        return helpControl.ClassifyGrid.datagrid("getSelected");
    }
    //查询接口
    function doSearch(value) {
        if (helpControl.gridData.length > 0) {
            if (value != "") {
                var newData = [];
                if (para.Field && para.Field.length > 0) {
                    var namesArr = para.Field.split(",");
                    for (var i = 0; i < helpControl.gridData.length; i++) {
                        for (var n = 0; n < namesArr.length; n++) {
                            var tempN = find(value, helpControl.gridData[i][namesArr[n]]);
                            if (tempN) {
                                newData.push(helpControl.gridData[i]);
                                break;
                            }
                        }
                    }
                    helpControl.ClassifyGrid.datagrid('loadData', newData);
                }
            } else {
                helpControl.ClassifyGrid.datagrid('loadData', helpControl.gridData);
            }
        }
    }
    function find(sFind, sObj) {
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
    //还原查询前的报表列表
    //参数：预存的box1Data
    function restoreSerch() {
        $("#search").searchbox("setValue", "");
        if (helpControl.gridData.length > 0) {
            helpControl.ClassifyGrid.datagrid('loadData', helpControl.gridData);
        }
    }
    </script>
<div id="tb"style="padding:5px;height:auto; font-size:12px;">
         查询: <input class="easyui-searchbox" id="search"data-options="prompt:'编号或名称'" style="width:110px"></input>
        <a href="#" class="easyui-linkbutton" style=" margin-left:20px" onclick="restoreSerch()" iconcls="icon-undo" plain="false">重置</a>
         </div>
   <table id ="ClassifyGrid"></table>
</body>
</html>
