<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReportClassifyManager.aspx.cs" Inherits="Audit.ct.basic.ReportClassifyManager" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>报表分类管理</title>
    <script src="../../lib/jquery/jquery-1.3.2.min.js" type="text/javascript"></script>
    <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script src="../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <link href="../../lib/ligerUI/skins/Aqua/css/ligerui-all.css" rel="stylesheet" type="text/css" />
    <link href="../../lib/ligerUI/skins/ligerui-icons.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/ligerUI/js/core/base.js" type="text/javascript"></script>
    <script src="../../lib/ligerUI/js/core/inject.js" type="text/javascript"></script>
    <script src="../../lib/ligerUI/js/ligerui.min.js" type="text/javascript"></script>
    <script src="../../lib/json2.js" type="text/javascript"></script>
    <link href="../../Styles/Ct_Controls.css" rel="stylesheet" type="text/css" />
    <script src="../../Scripts/Ct_Controls.js" type="text/javascript"></script>
    <script type="text/javascript">
      var urls = {
          functionsUrl: "../../handler/FormatHandler.ashx"
      };
      var grid;
      var dialog;
      var box1Data;
      var deltRow = {};
      var EditControl = {};
      ///增加、修改、删除
      var ButtonManager = {
          add: function (item) {
              var title = {};
              title.text = item.text;
              itemclick(title);
          },
          edit: function (item) {
              var row = grid.getSelected();
              if (row) {
                  item.row = row;
                  itemclick(item);
              } else {
                  alert("请先选择一行要编辑的数据");
              }
          },
          //删除
          delt: function () {
              var row = grid.getSelected();
              var para = {};
              if (row) {
                $.ligerDialog.warning('你确定要删除当前单位?',function (r) {
                      if (!r) { return; }
                      else {
                          deltRow = row;
                          var para = { Id: row.Id };
                          para = CreateParameter(ReporClassifyAction.ActionType.Post, ReporClassifyAction.Functions.ReportClassify, ReporClassifyAction.Methods.ReportClassifyMethods.GetReportsByClassify, para);
                          DataManager.sendData(urls.functionsUrl, para, resultManagers.successTestDel, resultManagers.fail);
                      }
                  });
              } else {
                  alert("请先选择一行要删除的数据");
              }
          }
      };
      var leftWidth;
      var centerWidth;
      $(function () {
          $("#SearchBtn").Btn({ text: "查询", click: searchManager.search, icon: "Search" })
          $("#UnSearchBtn").Btn({ text: "重置", click: searchManager.freeSerch, icon: "Undo" })
          $("#SaveBtn").Btn({ text: "保存", click: SaveClick, icon: "Save" })
          var allWidth = document.body.clientWidth;
          leftWidth = allWidth * 0.4;
          centerWidth = (allWidth - leftWidth - 50) / 2;
          $("#layout1").ligerLayout({ leftWidth: leftWidth, allowLeftCollapse: false });
          var allHeight = document.body.clientHeight - 50;
          $("#FileToolBar").ligerToolBar({ items: [
                    { text: '新建报表类别', click: ButtonManager.add, icon: 'add' },
                    { line: true },
                    { text: '修改类别', click: ButtonManager.edit, icon: 'modify' },
                    { line: true },
                    { text: '删除类别', click: ButtonManager.delt, icon: 'delete' }
                    ]
          });
          grid = $("#auditGrid").ligerGrid({
              columns: [
                { display: '主键', name: 'Id', align: 'left', width: 10, hide: true },
                { display: '类别编号', name: 'Code', align: 'left', minWidth: 154 },
                { display: '报表类别名称', name: 'Name', align: 'left', minWidth: 140 }
                ],
              width: '100%',
              height: '100%',
              heightDiff: -5,
              data: rows,
              toolbar: "#FileToolBar",
              onSelectRow: function (rowdata, rowid, rowobj) {
                  var para = { Id: rowdata.Id };
                  var paraR = { Id: rowdata.Id };
                  para = CreateParameter(ReporClassifyAction.ActionType.Post, ReporClassifyAction.Functions.ReportClassify, ReporClassifyAction.Methods.ReportClassifyMethods.GetUnClassifyReports, para);
                  DataManager.sendData(urls.functionsUrl, para, resultManagers.LoadUnclassReport, resultManagers.fail);
                  paraR = CreateParameter(ReporClassifyAction.ActionType.Post, ReporClassifyAction.Functions.ReportClassify, ReporClassifyAction.Methods.ReportClassifyMethods.GetReportsByClassify, paraR);
                  DataManager.sendData(urls.functionsUrl, paraR, resultManagers.LoadReport, resultManagers.fail);

              }
          });
          EditControl.Code = $("#Code").ligerTextBox();
          EditControl.Name = $("#Name").ligerTextBox();
          $("#sInput").keypress(function (e) {
              var curKey = e.which;
              if (curKey == 13) {
                  searchManager.search();
              }
          });
          var dataGridColumns = [
          { header: '<span style="font-size:13px">编号</span>', name: 'bbCode' },
          { header: '<span style="font-size:13px">报表名称</span>', name: 'bbName' }
          ];
          $("#listbox1,#listbox2").ligerListBox({
              isShowCheckBox: true,
              isMultiSelect: true,
              columns: dataGridColumns,
              width: centerWidth,
              height: allHeight
          });
      });
      ///重新加载数据
      function loadRows() {
          var para = {};
            para = CreateParameter(ReporClassifyAction.ActionType.Post, ReporClassifyAction.Functions.ReportClassify, ReporClassifyAction.Methods.ReportClassifyMethods.GetClassifiesList, para);
            DataManager.sendData(urls.functionsUrl, para, resultManagers.successLoad, resultManagers.fail);
      }
      ///报表类别更改
      ///左右移动
      function moveToLeft() {
          var box1 = liger.get("listbox1"), box2 = liger.get("listbox2");
          var selecteds = box2.getSelectedItems();
          if (!selecteds || !selecteds.length) return;
          box2.removeItems(selecteds);
          box1.addItems(selecteds);
      }
      function moveToRight() {
          var box1 = liger.get("listbox1"), box2 = liger.get("listbox2");
          var selecteds = box1.getSelectedItems(); 
          if (!selecteds || !selecteds.length) return;
          box1.removeItems(selecteds);
          box2.addItems(selecteds);
      }
      function moveAllToLeft() {
          var box1 = liger.get("listbox1"), box2 = liger.get("listbox2");
          var selecteds = box2.data;
          if (!selecteds || !selecteds.length) return;
          box1.addItems(selecteds);
          box2.removeItems(selecteds);
      }
      function moveAllToRight() {
          var box1 = liger.get("listbox1"), box2 = liger.get("listbox2");
          var selecteds = box1.data;
          if (!selecteds || !selecteds.length) return;
          box2.addItems(selecteds);
          box1.removeItems(selecteds);
      }
      ///保存报表的类别更改
      function SaveClick() {
          box2 = liger.get("listbox2");
          if (box2.data) {
              var selecteds = box2.data;
              var rows = [];
              var row = grid.getSelected()
              $.each(selecteds, function (index) {
                  var parameter = { Id: "", ReportId: "", ClassifyId: "" };
                  parameter.ReportId = selecteds[index].id;
                  parameter.ClassifyId = row.Id;
                  rows.push(parameter);
              });
              var obj = {};
              obj.rows = JSON2.stringify(rows);
              obj.classifyid = row.Id;
              var para = CreateParameter(ReporClassifyAction.ActionType.Post, ReporClassifyAction.Functions.ReportClassify, ReporClassifyAction.Methods.ReportClassifyMethods.SaveReports, obj);
              DataManager.sendData(urls.functionsUrl, para, resultManagers.successSave, resultManagers.fail);
          }
      }
      var resultManagers = {
          success: function (data) {
              if (data.success) {
                  $.ligerDialog.success(data.sMeg);
                  loadRows();
              } else {
                  $.ligerDialog.error(data.sMeg);
              }
          },
          successLoad: function (data) {
              grid.loadData(data.obj);
          },
          successTestDel: function (data) {
              if (data.obj.Rows.length == 0) {
                  para = CreateParameter(ReporClassifyAction.ActionType.Post, ReporClassifyAction.Functions.ReportClassify, ReporClassifyAction.Methods.ReportClassifyMethods.DeleteClassifyEntity, deltRow);
                  DataManager.sendData(urls.functionsUrl, para, resultManagers.success, resultManagers.fail);
              } else { $.ligerDialog.error("该分类下已有报表，请移除报表后再进行此操作！") }
          },
          fail: function (data) {
              $.ligerDialog.success(data.sMeg);
          },
          LoadUnclassReport: function (data) {
              if (data.success) {
                  var listData = data.obj;
                  var rows = [];
                  for (var i = 0; i < listData.Rows.length; i++) {
                      listData.Rows[i].id = listData.Rows[i].Id;
                      rows.push(listData.Rows[i]);
                  }
                  var oldData = liger.get("listbox1").data;
                  liger.get("listbox1").removeItems(oldData);
                  liger.get("listbox1").setData(rows);
                  box1Data = liger.get("listbox1").data;
                  if (listData.Rows.length == 0) {
                      liger.get("listbox1").clearContent();
                  }
              } else {
                  $.ligerDialog.success(data.sMeg);
              }
          },
          LoadReport: function (data) {
              if (data.success) {
                  var listData = data.obj;
                  var rows = [];
                  for (var i = 0; i < listData.Rows.length; i++) {
                      listData.Rows[i].id = listData.Rows[i].Id;
                      rows.push(listData.Rows[i]);
                  }
                  liger.get("listbox2").clearContent();
                  var oldData = liger.get("listbox2").data;
                  liger.get("listbox2").removeItems(oldData);
                  liger.get("listbox2").setData(rows);
              } else {
                  $.ligerDialog.success(data.sMeg);
              }
          },
          successSave: function (data) {
              if (data.success) {
                  $.ligerDialog.success(data.sMeg);
              } else {
                  $.ligerDialog.error(data.sMeg);
              }
          }
      };
      var searchManager = {
          //查询方法
          //支持编号和名称的模糊查询
          //张双义
          search: function () {
              var key = $("#sInput").val();
              var box1 = liger.get("listbox1");
              var newData = [];
              if (box1.data) {
                  for (var i = 0; i < box1.data.length; i++) {
                      var tempCode = searchManager.find(key, box1.data[i].bbCode);
                      var tempName = searchManager.find(key, box1.data[i].bbName);
                      if (tempCode || tempName) {
                          newData.push(box1.data[i]);
                      }
                  }
                  if (newData.length > 0) {
                      box1.setData(newData);
                  } else {
                      liger.get("listbox1").clearContent();
                  } 
              }
          },
          //还原查询前的报表列表
          //参数：预存的box1Data
          freeSerch: function () {
              $("#sInput").val("");
              liger.get("listbox1").setData(box1Data);
          },
          find: function (sFind, sObj) {
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
      };
      window.onresize = function () {
          if ($) {
              var winWidth = $(window).width();
              var winHeight = $(window).height();
              centerWidth = (winWidth - leftWidth - 50) / 2;
              var centerHeight = winHeight - 50;
              liger.get("listbox1").resize(centerWidth, centerHeight);
              liger.get("listbox2").resize(centerWidth, centerHeight);
          } 
      }

//<%-- Dialog 内容和方法--%>
    ///张双义
      function itemclick(item) {
          dialog = $.ligerDialog.open({ target: $("#dialog"), title: item.text,
              showToggle: true,
              showMin: false,
              isResize: true,
              height: 200,
              weith: 250,
              buttons: [{
                  text: '保存',
                  onclick: function () {
                      var parameters = {};
                      if (item.text == "新建报表类别") {
                          var parameters = getParameters(ReporClassifyAction.ActionType.Post, ReporClassifyAction.Methods.ReportClassifyMethods.AddClassifyEntity);
                          if (!parameters) { return; }
                          DataManager.sendData(urls.functionsUrl, parameters, resultManagers.success, resultManagers.fail);
                      } else if (item.text == "修改类别") {
                          var parameters = getParameters(ReporClassifyAction.ActionType.Post, ReporClassifyAction.Methods.ReportClassifyMethods.EditClassifyEntity);
                          if (!parameters) { return; }
                          DataManager.sendData(urls.functionsUrl, parameters, resultManagers.success, resultManagers.fail);
                      }
                      dialog.hide();
                  }
              }, {
                  text: '取消',
                  onclick:
                  function () {
                      dialog.hide();
                  }
              }]
          });
          if (item.row) {
              EditControl.Code.setValue(item.row.Code)
              EditControl.Name.setValue(item.row.Name)
              $("#Id").val(item.row.Id);
          } else {
              EditControl.Code.setValue("")
              EditControl.Name.setValue("")
              $("#Id").val("");
          }
      }
       function getParameters(actionType, methodName) {
            var params = {};
            params["Code"] = EditControl.Code.getValue();
            params["Name"] = EditControl.Name.getValue();
            params["ActionType"] = actionType;
            params["FunctionName"] = ReporClassifyAction.Functions.ReportClassify;
            params["MethodName"] = methodName;
            var id = $("#Id").val();
            if (id != null && id != undefined && id != "") {
                params["Id"] = id;
            }
            return params;
        }
     </script> 
    <style type="text/css">
            #layout1{  width:100%;margin:0; padding:0;  }  
              .middle input {
            display: block;width:30px; margin:2px;
        }

    </style>
</head>
<body style=" overflow:hidden">
    <div id="layout1">
        <div position="left" title="报表分类">
            <div id="FileToolBar"  ></div>
            <div id="auditGrid"></div>
        </div>
        <div position="center" style=" vertical-align:middle" title="报表">            
            <div class="l-toolbar" style="width:100%; padding-left:5px" >
                <div style=" float:left;padding-top:2px">报表筛选：<input id="sInput" type="text" style="width:80px; border:1px solid #B9B9FF" prompt="筛选内容"searcher="search"  name="Name" /></div>
                <div id="SearchBtn"></div>
                <div id="UnSearchBtn"></div>
                <div id="SaveBtn" style=" float:right; margin-right:15px;"></div>
            </div>
               <%-- <div class="l-menubar">未分类报表：</div>--%>
            <div style="margin:0px;float:left; font-size:12px;">
                <div id="listbox1">
                </div>  
            </div>
            <div style="margin:2px;float:left; height:100%; " class="middle" >
                 <input type="button" onclick="moveToLeft()"  value="<" style=" margin-top:10px;" />
                  <input type="button" onclick="moveToRight()" value=">" />
                  <input type="button" onclick="moveAllToLeft()" value="<<" />
                 <input type="button" onclick="moveAllToRight()" value=">>" />
            </div>

            <div style="margin:0px;float:left;font-size:12px;">
            <%--    <div class="l-menubar">分类下报表：</div>--%>
                <div id="listbox2"></div> 
        </div>
        </div>  
    </div>
    <div id="dialog" style=" display:none">
        <input id="Id" value ="" type="hidden"/>
        <table style=" margin-top:20px; margin-left:10px; width:90%" >
        <tr style=" height:50px"><td>类型编号:</td><td><input id="Code" value="" type="text" /></td></tr>
        <tr style=" height:40px"><td>类型名称:</td><td><input id="Name" value="" type="text" /></td></tr>
        </table>
    </div> 
</body>
</html>
