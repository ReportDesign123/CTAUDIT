<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="HelpSearchDialog.aspx.cs" Inherits="Audit.ct.pub.HelpSearchDialog" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
   <title>系统帮助</title>
    <link href="../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
    <script src="../../lib/easyUI/easyloader.js" type="text/javascript"></script>
    <script src="../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="../../lib/easyUI/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
         <script src="../../Scripts/ct_dialog.js" type="text/javascript"></script>
    <script type="text/javascript">
    //功能：用于报表分类、报表查询
        var para;
        var ClassifyGrid;
        var reportsData = [];
        var urls = {
            ClassifyUrl:"../../handler/FormatHandler.ashx?ActionType="+ReporClassifyAction.ActionType.Post+"&MethodName="+ReporClassifyAction.Methods.ReportClassifyMethods.GetClassifiesList+"&FunctionName="+ReporClassifyAction.Functions.ReportClassify,
            functionsUrl: "../../handler/FormatHandler.ashx"
        };
        //开始加载数据
        $(function () {

            para = dialog.para();// window.dialogArguments;
            var data = [];
            if (para.ReportData && para.ReportData != "") {
                data = para.ReportData;
            }
            if (para.addMore) $("#addMore").css("display", "block");
            helpManager.HelpReportGrid(data);
            var paras = {};
            paras = CreateParameter(ReporClassifyAction.ActionType.Post, ReporClassifyAction.Functions.ReportClassify, ReporClassifyAction.Methods.ReportClassifyMethods.GetClassifiesList, paras);
            DataManager.sendData(urls.functionsUrl, paras, resultManagers.successLoad, resultManagers.fail);

        });

        var helpManager = {
            HelpReportGrid: function (data) {
                $("#ReportGrid").datagrid(
                {
                    fit: true,
                    title: "",
                    data: data,
                    toolbar: "#tb",
                    sortOrder: "ASC",
                    sortName: "bbCode",
                    singleSelect: false,
                    pagination: false,
                    columns: [[
                    { field: "Id", title: "id", hidden: true, width: 120 },
                    { field: "bbCode", title: "报表编号", width: 140 },
                    { field: "bbName", title: "报表名称", width: 210 }
                    ]],
                    onDblClickRow: function (rowIndex, rowData) {
                        window.returnValue = rowData;
                        window.close();
                    }, onLoadSuccess: function (data) {
                        var Id = para.ReportId;
                        if (Id && Id != ""&&data.rows.length>0) {
                            for (var i = 0; i < data.rows.length; i++) {
                                if (Id == data.rows[i].Id) {
                                    $(this).datagrid('selectRow', i);
                                    break;
                                }
                            }
                        }
                    }
                });
            },
            HelpClassifyGrid: function (data) {
                ClassifyGrid = $("#ClassifyGrid").datagrid(
                {
                    fit: true,
                    data: data,
                    sortName: 'Name',
                    singleSelect: true,
                    sortOrder: 'ASC',
                    allowPage: false,
                    pagination: false,
                    title: "",
                    columns: [[
                { field: "Id", title: "id", hidden: true, width: 120 },
                { field: "Code", title: "分类编号", width: 80 },
                    { field: "Name", title: "分类名称", width: 100 }
                    ]],
                    onSelect: function (rowIndex, rowData) {
                        var param = { Id: rowData.Id };
                        param = CreateParameter(ReporClassifyAction.ActionType.Post, ReporClassifyAction.Functions.ReportClassify, ReporClassifyAction.Methods.ReportClassifyMethods.GetReportsByClassify, param);
                        DataManager.sendData(urls.functionsUrl, param, resultManagers.LoadReport, resultManagers.fail);

                    }, onLoadSuccess: function (data) {
                        var Id = para.ClassifyId;
                        if (Id && Id != "") {
                            for (var i = 0; i < data.rows.length; i++) {
                                if (Id == data.rows[i].Id) {
                                    $(this).datagrid('selectRow', i);
                                    break;
                                }
                            }
                        }
                    }
                });
            }
        };
        var resultManagers = {
            successLoad: function (data) {
                if (data.obj) {
                    helpManager.HelpClassifyGrid(data.obj.Rows);
                }
            },
            LoadReport: function (data) {
                if (data.success) {
                    helpManager.HelpReportGrid(data.obj.Rows);
                }
            },
            LoadAllReport: function (data) {
                if (data.obj) {
                    reportsData = data.obj.Rows;
                    helpManager.HelpReportGrid(reportsData);
                    ClassifyGrid.datagrid("unselectAll");
                }
            },
            fail: function (data) {
                MessageManager.ErrorMessage(data.sMeg);
            }
        }
        //查询接口
        function doSearch(value) {
            var param = {bbCode:value,bbName:value}
            param = CreateParameter(ReporClassifyAction.ActionType.Post, ReporClassifyAction.Functions.ReportClassify, ReporClassifyAction.Methods.ReportClassifyMethods.GetReportsByClassify, param);
            DataManager.sendData(urls.functionsUrl, param, resultManagers.LoadAllReport, resultManagers.fail);
        }
      //还原查询前的报表列表
      //参数：预存的box1Data
      function restoreSerch() {
          $("#bbCode").searchbox("setValue", "");
          doSearch("");
      }
      function returnReports() {
          var reports = $("#ReportGrid").datagrid("getSelections");
          window.returnValue = reports;
          window.close();
      }
      </script>
</head>
<body class="easyui-layout">
    <div data-options="region:'west',collapsible:false"id ="Classifies" style="width:200px;overflow:auto">
    <table id ="ClassifyGrid"></table>
    </div>
    <div data-options="region:'center'"id ="Reports"class="" style="border:0px">
        <div id="tb"style="padding:5px;height:auto; font-size:12px; background-color:#EAEAEE">
         报表查询: <input class="easyui-searchbox" id="bbCode"data-options="prompt:'编号或名称',searcher:doSearch" style="width:110px"></input>
        <a href="#" class="easyui-linkbutton" style=" margin-left:20px" onclick="restoreSerch()" iconcls="icon-undo" plain="false">重置</a>
        <a href="#" class="easyui-linkbutton" style=" margin-left:20px;display:none" id="addMore" onclick="restoreSerch()" iconcls="icon-save" plain="false">确定</a>
         </div>
       <table id="ReportGrid"></table>
   </div>
</body>
</html>
