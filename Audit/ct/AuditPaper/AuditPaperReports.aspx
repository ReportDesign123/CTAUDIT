<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AuditPaperReports.aspx.cs" Inherits="Audit.ct.AuditPaper.AuditPaperReports" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
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
      AuditPaperUrl: "../../handler/AuditPaperHandler.ashx"
  };
  var grid;
  var box1Data;
  var leftWidth;
  var centerWidth;
  $(function () {
      $("#SearchBtn").Btn({ text: "查询", click: searchManager.search, icon: "Search" })
      $("#UnSearchBtn").Btn({ text: "重置", click: searchManager.freeSerch, icon: "Undo" })
      $("#SaveBtn").Btn({ text: "保存", click: SaveClick, icon: "Save" })

      var allWidth = document.body.clientWidth;
      leftWidth = allWidth * 0.4
      centerWidth = (allWidth - leftWidth - 50) / 2;
      $("#layout1").ligerLayout({ leftWidth: leftWidth, allowLeftCollapse: false });
      var allHeight = document.body.clientHeight - 50;

      grid = $("#auditGrid").ligerGrid({
          columns: [
                { display: '主键', name: 'Id', align: 'left', width: 10, hide: true },
                { display: '审计底稿编号', align: 'left', name: 'Code', minWidth: 154 },
                { display: '审计底稿名称', align: 'left', name: 'Name', minWidth: 140 }
                ],
          width: '100%',
          height: '100%',
          heightDiff: -5,
          data: rows,
          onSelectRow: function (rowdata, rowid, rowobj) {
              var para = { AuditPaperId: rowdata.Id };
              para = CreateParameter(AuditPaperAction.ActionType.Post, AuditPaperAction.Functions.AuditPaperManagerMenu, AuditPaperAction.Methods.AuditPaperManagerMenu.GetAuditPaperReportList, para);
              DataManager.sendData(urls.AuditPaperUrl, para, resultManagers.loadSuccess, resultManagers.fail, false);
          }

      });
      $("#sInput").keypress(function (e) {
          var curKey = e.which;
          if (curKey == 13) {
              searchManager.search();
          }
      });
      var dataGridColumns = [
          { header: '<span style="font-size:13px">编号</span>', name: 'code' },
          { header: '<span style="font-size:13px">报表名称</span>', name: 'text' }
          ];
      $("#listbox1,#listbox2").ligerListBox({
          isShowCheckBox: true,
          isMultiSelect: true,
          columns: dataGridColumns,
          width: centerWidth,
          height: allHeight
      });
  });
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
      var resultManagers = {
          success: function (data) {
              if (data.success) {

                  $.ligerDialog.success(data.sMeg);
              } else {
                  $.ligerDialog.success(data.sMeg);
              }
          },
          fail: function (data) {
              $.ligerDialog.success(data.sMeg);
          },
          loadSuccess: function (data) {
              if (data.success) {
                  var listData = data.obj;
                  liger.get("listbox1").setData(listData.UnSelect);
                  box1Data = liger.get("listbox1").data;
                  liger.get("listbox2").setData(listData.Select);

                  if (listData.UnSelect.length == 0) {
                      liger.get("listbox1").clearContent();
                  }
                  if (listData.Select.length == 0) {
                      liger.get("listbox2").clearContent();
                  }
              } else {
                  $.ligerDialog.success(data.sMeg);
              }
          }
      };
      function SaveClick() {
          box2 = liger.get("listbox2");
          var selecteds = box2.data;
          var rows = [];
          var row = grid.getSelected()
          $.each(selecteds, function (index) {
              var parameter = { Id: "", AuditPaperId: "", ReportId: "" };
              parameter.ReportId = selecteds[index].id;
              parameter.AuditPaperId = row.Id;
              rows.push(parameter);
          });
          var obj = {};
          obj.rows = JSON2.stringify(rows);
          obj.AuditPaperId = row.Id;

          var para = CreateParameter(AuditPaperAction.ActionType.Post, AuditPaperAction.Functions.AuditPaperManagerMenu, AuditPaperAction.Methods.AuditPaperManagerMenu.BatchUpdataReports, obj);
          DataManager.sendData(urls.AuditPaperUrl, para, resultManagers.success, resultManagers.fail);
      }
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
                      var tempCode = searchManager.find(key, box1.data[i].code);
                      var tempName = searchManager.find(key, box1.data[i].text);
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
    <div position="left" title="审计底稿">
        <div id="auditGrid"></div>
    </div>
    <div position="center" style=" vertical-align:middle" title="报表">
    <div class="l-toolbar" style="padding-left:5px; width:100%;" >
        <div style=" float:left; padding-top:2px">报表筛选：<input id="sInput" type="text" style="width:80px; border:1px solid #B9B9FF" prompt="筛选内容"searcher="search"  name="Name" /></div>
        <div id="SearchBtn"></div>
        <div id="UnSearchBtn"></div>
        <div id="SaveBtn" style=" float:right; margin-right:15px;"></div>                   
    </div>              
        <div style="margin:0px;float:left;">
            <div id="listbox1"></div>
        </div>
        <div style="margin:2px;float:left; height:100%; " class="middle" >
            <input type="button" onclick="moveToLeft()"  value="<" style=" margin-top:10px;" />
            <input type="button" onclick="moveToRight()" value=">" />
            <input type="button" onclick="moveAllToLeft()" value="<<" />
            <input type="button" onclick="moveAllToRight()" value=">>" />
        </div>
        <div style="margin:0px;float:left;">
            <div id="listbox2"></div>
        </div>              
    </div>
</div>
</body>
</html>
