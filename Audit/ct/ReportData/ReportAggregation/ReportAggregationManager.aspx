<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReportAggregationManager.aspx.cs" Inherits="Audit.ct.ReportData.ReportAggregation.ReportAggregationManager" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>报表汇总</title> 
       <script src="../../../lib/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
        <script src="../../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script src="../../../Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <link href="../../../lib/easyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <script src="../../../lib/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
<script src="../../../lib/json2.js" type="text/javascript"></script>
    <script src="../../../lib/ligerUI/js/core/base.js" type="text/javascript"></script>
    <script src="../../../lib/ligerUI/js/core/inject.js" type="text/javascript"></script>
    <link href="../../../lib/ligerUI/skins/Aqua/css/ligerui-all.css" rel="stylesheet"
        type="text/css" />
    <script src="../../../lib/ligerUI/js/ligerui.min.js" type="text/javascript"></script>
    <link href="../../../lib/ligerUI/skins/ligerui-icons.css" rel="stylesheet" type="text/css" />
    <script src="../../../lib/ligerUI/js/plugins/ligerListBox.js" type="text/javascript"></script>
    <script src="../../../lib/ligerUI/js/plugins/ligerTree.js" type="text/javascript"></script>
    <script src="../../../lib/ligerUI/js/plugins/ligerToolBar.js" type="text/javascript"></script>
    <script src="../../../lib/ligerUI/js/plugins/ligerLayout.js" type="text/javascript"></script>
    <script src="../../../lib/ligerUI/js/plugins/ligerComboBox.js" type="text/javascript"></script>
    <script src="../../../lib/ligerUI/js/plugins/ligerDateEditor.js" type="text/javascript"></script>
    <script src="../../../lib/ligerUI/js/plugins/ligerDialog.js" type="text/javascript"></script>
    <script src="../../../Scripts/Cookie/Cookie.js" type="text/javascript"></script>
    <script src="../../../lib/Cookie/jquery.cookie.js" type="text/javascript"></script>

    
       <script src="../../../Scripts/ct_dialog.js" type="text/javascript"></script>
    <script type="text/javascript">
        var controls = { companies: {}, selectCompanies: {}, ReportSearch: { ReportCode: "", ReportName: "" } };
        var dialogControls = { Name: "", Code: "", Wd: "", TemplateName: "", TemplateCode: "", TemplateClassify: {}, SearchDialog: {}, TemplateDialog: {}, ImportTemplate: {} };
        var selectedTreeNodes = [];
        var currentState = { ReportPara: { auditPaperVisible: "1", auditZqVisible: "1", WeekReport: { ID: "", Name: "", Ksrq: "", Jsrq: ""} }, DateFormats: {}, CurrentReportFormatIndex: 0, AggZq: { Cycle: "", Year: "" }, TemplateId: "" };
        var urls = {
            CompanyUrls: "../../../handler/ReportDataHandler.ashx?ActionType=" + ReportDataAction.ActionType.Grid + "&MethodName=" + ReportDataAction.Methods.ReportAggregationMethods.GetAuthorityCompanies + "&FunctionName=" + ReportDataAction.Functions.ReportAggregation,
            ReportUrls: "../../../handler/ReportDataHandler.ashx"
        };
        var ReportGridColumns = [
          { header: '编号', name: 'bbCode' },
          { header: '报表名称', name: 'bbName' }
        ];
          $(function () {
              var allWidth = document.body.clientWidth;
              var leftWidth = allWidth * 0.6
              var centerWidth = (allWidth - leftWidth - 100) / 2;
              $("#layout1").ligerLayout({ leftWidth: leftWidth, bottomHeight: 20, allowLeftCollapse: false, height: '95%' });
              var height = document.body.clientHeight - 80;
              $("#contentLeft").css("height", height - 50);
              $("#contentRight").css("height", height);

              $("#tooBar").ligerToolBar({ items: [
               { text: '汇总', icon: 'process', click: MediatorManager.AggregationReports },
                { line: true },
                { text: '选择汇总模板', icon: 'database', click: MediatorManager.ChooseTemplate },
                { text: '保存模板', icon: 'save', click: MediatorManager.AddTemplate }
            ]
              });
              $("#SelectTypeChechbox").change(function () {
                  EventManager.ChangeSelectEvent()
              });
              controls.companies = $("#AllCompanies").ligerTree({
                  checkbox: true,
                  slide: false,
                  autoCheckboxEven: true,
                  url: urls.CompanyUrls,
                  nodeWidth: 'auto',
                  onAfterAppend: function () {
                  },
                  onBeforeAppend: function () {
                  }
              });
              $("#selectCompanies").ligerListBox({
                  isShowCheckBox: true,
                  isMultiSelect: true,
                  width: '99%',
                  height: '99%'

              });
              $("#Reports").ligerListBox({
                  isShowCheckBox: true,
                  isMultiSelect: true,
                  columns: ReportGridColumns,
                  width: '99%',
                  height: '99%'
              });

              ///弹窗内容声明@张双义
              dialogControls.TemplateCode = $("#TemplateCode").ligerTextBox({ nullText: '不能为空' });
              dialogControls.TemplateName = $("#TemplateName").ligerTextBox({ nullText: '不能为空' });
              dialogControls.Code = $("#Code").ligerTextBox({});
              dialogControls.Name = $("#Name").ligerTextBox({});
              dialogControls.Wd = $("#Wd").ligerPopupEdit({
                  onbuttonclick: DialogManager.ShowWdDialog,
                  width: 130

              });
              dialogControls.TemplateClassify = $("#TemplateClassify").ligerPopupEdit({
                  onbuttonclick: DialogManager.ChooseClassifyDialog,
                  width: 130

              });
              var cookieResult;

              //加载cookie
              cookieResult = CookieDataManager.GetCookieData(ReportDataAction.Functions.ReportAggregation);
              if (cookieResult) {
                  EventManager.taskBtn_Click(cookieResult);
              } else {
                  EventManager.taskBtn_Click();
              }
              //加载默认汇总模板
              ListManager.LoadTemplateFirst();
          });
          var ListManager = {
              MoveToRight: function () {
                  var sc = liger.get("selectCompanies");
                  var sItems = controls.companies.getChecked();
                  sc.addItems(ListManager.ConvertNodeToItems(sItems));

              },
              MoveToLeft: function () {
                  var sc = liger.get("selectCompanies");
                  var selecteds = sc.getSelectedItems();
                  if (!selecteds || !selecteds.length) return;
                  sc.removeItems(selecteds);
                  ListManager.RemoveNodeFromTreeData(selecteds);

              },
              MoveToRightAll: function () {
                  var sc = liger.get("selectCompanies");
                  var data = controls.companies.getData();
                  selectedTreeNodes = [];
                  ListManager.GetTreeNodeDataRecursive(data);
                  sc.removeItems(sc.data);
                  sc.addItems(selectedTreeNodes);

              },
              MoveToLeftAll: function () {
                  var sc = liger.get("selectCompanies");
                  var selecteds = sc.data;
                  if (!selecteds || !selecteds.length) return;

                  ListManager.RemoveNodeFromTreeData(selecteds);
                  selectedTreeNodes = [];
                  sc.removeItems(selecteds);
              },
              MoveToRightBySearch: function (listData) {
                  var sc = liger.get("selectCompanies");
                  var data = controls.companies.getData();
                  selectedTreeNodes = listData;
                  ListManager.GetTreeNodeDataRecursive(data);
                  sc.removeItems(sc.data);
                  sc.addItems(selectedTreeNodes);

              },
              ConvertNodeToItems: function (data) {
                  if (data && data.length > 0) {

                      var items = [];
                      $.each(data, function (index, item) {
                          var flag = false;
                          $.each(selectedTreeNodes, function (ti, tnode) {
                              if (tnode.id == item.data.id) {
                                  flag = true; return;

                              }
                          });
                          if (!flag) {
                              var obj = { id: "", text: "" };
                              obj.id = item.data.id;
                              obj.text = item.data.text;
                              items.push(obj);
                              selectedTreeNodes.push(item.data);
                          }

                      });
                      return items;
                  }
              },
              RemoveNodeFromTreeData: function (selecteds) {
                  $.each(selecteds, function (index, item) {
                      $.each(selectedTreeNodes, function (codei, node) {
                          if (node && node.id == item.id) {
                              controls.companies.cancelSelect(node);
                              //delete 方法不刷新列表元素的序号 改用 remove
                              //张双义
                              //delete selectedTreeNodes[codei];
                              selectedTreeNodes.remove(codei);
                          }
                      });
                  });

              },
              GetTreeNodeDataRecursive: function (data) {

                  $.each(data, function (index, item) {
                      selectedTreeNodes.push(item);
                      if (item.children && item.children.length > 0) {
                          ListManager.GetTreeNodeDataRecursive(item.children);

                      }
                  });

              },
              LoadReports: function (data) {
                  var r = liger.get("Reports");
                  r.removeItems(r.data);
                  var rdata = [];
                  $.each(data, function (index, item) {
                      rdata.push(item.ReportFormat);
                  });
                  for (var i = 0; i < rdata.length; i++) {
                      rdata[i].id = rdata[i].Id;
                  }
                  r.addItems(rdata);
              },
              ///加载默认模板
              LoadTemplateFirst: function () {
                  var parameters = {};
                  parameters = CreateParameter(ReportDataAction.ActionType.Post, ReportDataAction.Functions.ReportAggregation, ReportDataAction.Methods.ReportAggregationMethods.GetPreAggregationLogEntity, parameters);
                  DataManager.sendData(urls.ReportUrls, parameters, ResultManager.LoadTemplate_Success, ResultManager.Fail);
              }
          };

          var EventManager = {
              taskBtn_Click: function (cookie) {
                  var result;
                  if (cookie && cookie != undefined) {
                      result = cookie;
                      if (result && result != undefined) {
                          $.each(result, function (key, value) {
                              currentState.ReportPara[key] = value;
                          });
                          if (result.auditZqType == "05") {
                              if (result.WeekReport.ID == "") {
                                  alert("请定义周报周期");
                                  var curTabTitle = "资料汇总";
                                  var t = parent.centerTabs.tabs('getTab', curTabTitle);
                                  if (t.panel('options').closable) {
                                      parent.centerTabs.tabs('close', curTabTitle);
                                      return;
                                  }
                              }

                          }

                          currentState.AggZq.Year = result.Nd;
                          currentState.AggZq.Cycle = result.Zq;
                          MediatorManager.LoadReports(currentState.ReportPara.AuditDate, currentState.ReportPara.AuditPaper.value);
                          EventManager.LoadDateFormats(result);
                          ///保存cookie
                          CookieDataManager.SetCookieData(ReportDataAction.Functions.ReportAggregation, result);
                      }
                  } else {
                      currentState.ReportPara.auditZqVisible = "1";
                      currentState.ReportPara.auditPaperVisible = "1";
                      dialog.Open("ct/reportdata/ChooseAuditTask.aspx", "切换任务", currentState.ReportPara, function (result) {
                          if (result && result != undefined) {
                              $.each(result, function (key, value) {
                                  currentState.ReportPara[key] = value;
                              });
                              if (result.auditZqType == "05") {
                                  if (result.WeekReport.ID == "") {
                                      alert("请定义周报周期");
                                      var curTabTitle = "资料汇总";
                                      var t = parent.centerTabs.tabs('getTab', curTabTitle);
                                      if (t.panel('options').closable) {
                                          parent.centerTabs.tabs('close', curTabTitle);
                                          return;
                                      }
                                  }

                              }

                              currentState.AggZq.Year = result.Nd;
                              currentState.AggZq.Cycle = result.Zq;
                              MediatorManager.LoadReports(currentState.ReportPara.AuditDate, currentState.ReportPara.AuditPaper.value);
                              EventManager.LoadDateFormats(result);
                              ///保存cookie
                              CookieDataManager.SetCookieData(ReportDataAction.Functions.ReportAggregation, result);
                          }
                      }, { width: 450, height: 500 });

                      
                  }
                 
              },
              ///初始化周期栏
              ///参数：底稿ReportPaper
              ///张双义
              LoadDateFormats: function (ReportPaper) {
                  $("#bottomTable").empty();
                  var para = { ReportType: ReportPaper.auditZqType };
                  para = CreateParameter(ReportDataAction.ActionType.Post, ReportDataAction.Functions.FillReport, ReportDataAction.Methods.FillReportMethods.GetReportCycle, para);
                  DataManager.sendData(urls.ReportUrls, para, ResultManager.LoadDates, ResultManager.Fail, false);
                  switch (ReportPaper.auditZqType) {
                      case "01":
                          $("#bottomTable").html('<table  style=" width:180px; padding:0; margin:2px;">' +
        '<tr style=" line-height:28px;"><td id="ndLbl" >年度</td><td id="ndTd"><input type="text" id="txtNd"/></td><td></td></tr>' +
        '</table>');
                          controls.Nd = $("#txtNd").ligerComboBox(
                    {
                        data: currentState.DateFormats.Nds,
                        valueField: 'value',
                        textField: 'name',
                        onSelected: EventManager.ZqComboxEvent.Nd_Select
                    });
                          controls.Nd.setValue(ReportPaper.Nd);
                          break;
                      case "02":
                          $("#bottomTable").html('<table  style=" width:180px; padding:0; margin:5px;">' +
        '<tr style=" line-height:28px;"><td id="ndLbl" >年度</td><td id="ndTd"><input type="text" id="txtNd"/></td><td></td></tr>' +
            '<tr style=" line-height:28px;" id="zqTr"><td id="zqLbl" >月份</td><td id="zqTd"><input type="text" id="txtZq"/></td><td></td></tr>' +
        '</table>');

                          controls.Nd = $("#txtNd").ligerComboBox({
                              data: currentState.DateFormats.Nds,
                              valueField: 'value',
                              textField: 'name',
                              onSelected: EventManager.ZqComboxEvent.Nd_Select
                          });
                          controls.Zq = $("#txtZq").ligerComboBox({
                              data: currentState.DateFormats.Cycles,
                              valueField: 'value',
                              textField: 'name',
                              onSelected: EventManager.ZqComboxEvent.Zq_Select
                          });
                          controls.Nd.setValue(ReportPaper.Nd);
                          controls.Zq.setValue(ReportPaper.Zq);
                          break;
                      case "03":
                          $("#bottomTable").html('<table  style=" width:180px; padding:0; margin:2px;">' +
        '<tr style=" line-height:28px;"><td id="ndLbl" >年度</td><td id="ndTd"><input type="text" id="txtNd"/></td><td></td></tr>' +
            '<tr style=" line-height:28px;" id="zqTr"><td id="zqLbl" >季度</td><td id="zqTd"><input type="text" id="txtZq"/></td><td></td></tr>' +
        '</table>');
                          controls.Nd = $("#txtNd").ligerComboBox({
                              data: currentState.DateFormats.Nds,
                              valueField: 'value',
                              textField: 'name',
                              onSelected: EventManager.ZqComboxEvent.Nd_Select
                          });
                          controls.Zq = $("#txtZq").ligerComboBox({
                              data: currentState.DateFormats.Cycles,
                              valueField: 'value',
                              textField: 'name',
                              onSelected: EventManager.ZqComboxEvent.Zq_Select
                          });
                          controls.Nd.setValue(ReportPaper.Nd);
                          controls.Zq.setValue(ReportPaper.Zq);
                          break;
                      case "04":
                          $("#bottomTable").html('<table  style=" width:180px; padding:0; margin:2px;">' +
        '<tr style=" line-height:28px;"><td id="ndLbl" >日期</td><td id="ndTd"><input type="text" id="txtNd"/></td><td></td></tr>' +
        '</table>');
                          controls.Nd = $("#txtNd").ligerDateEditor({
                              showTime: false,
                              onChangeDate: function (value) {
                                  if (value == "") return;
                                  currentState.AggZq.Cycle = value;
                                  currentState.AggZq.Year = value.substr(0, 4);
                              }
                          });
                          controls.Nd.setValue(ReportPaper.Zq);
                          controls.Zq = null;
                          break;
                  }
              },
              ZqComboxEvent: {
                  Nd_Select: function (value, text) {
                      currentState.AggZq.Year = value;
                  },
                  Zq_Select: function (value, text) {
                      currentState.AggZq.Cycle = value;
                  }
              },
              ChangeSelectEvent: function () {
                  var state = controls.companies.get("autoCheckboxEven");
                  controls.companies.set("autoCheckboxEven", !state);
              }
          };
          var MediatorManager = {
              LoadReports: function (auditReportDate, auditPaperId) {
                  var para = { auditReportDate: auditReportDate, Id: auditPaperId };
                  para = CreateParameter(ReportDataAction.ActionType.Post, ReportDataAction.Functions.ReportAggregation, ReportDataAction.Methods.ReportAggregationMethods.GetReportFormatStructsByAuditPaper, para);
                  DataManager.sendData(urls.ReportUrls, para, ResultManager.LoadReports_Success, ResultManager.Fail, false);
                  $("#bottomTable").empty();
                  currentState.CurrentReportFormatIndex = 0;
              },
              ///汇总
              AggregationReports: function () {
                  var para = { TaskId: "", PaperId: "", Year: "", Cycle: "", templateId: "", ReportItems: [], Companies: [] };
                  if (para.TaskId = currentState.ReportPara.AuditTask == undefined || para.TaskId == currentState.ReportPara.AuditTask.value == undefined) {
                      $.ligerDialog.error("请选择汇总的审计底稿"); return;
                  }
                  para.TemplateId = currentState.TemplateId;
                  para.TaskId = currentState.ReportPara.AuditTask.value;
                  para.PaperId = currentState.ReportPara.AuditPaper.value;
                  para.ReportType = currentState.ReportPara.auditZqType;
                  if (currentState.ReportPara.auditZqType == "01") {
                      para.Year = currentState.AggZq.Year;
                      para.Cycle = currentState.AggZq.Year;
                  } else {
                      para.Year = currentState.AggZq.Year;
                      para.Cycle = currentState.AggZq.Cycle;
                  }
                  var sc = liger.get("selectCompanies");
                  var selecteds = sc.data;
                  if (selecteds == null) { MessageManager.InfoMessage("请选择汇总的单位"); return; }
                  $.each(selecteds, function (index, item) {
                      para.Companies.push(item.id);
                  });
                  var r = liger.get("Reports");
                  var selectR = r.getSelectedItems();
                  if (selectR == null) { MessageManager.InfoMessage("请选择汇总的报表"); return; }
                  $.each(selectR, function (index, item) {
                      para.ReportItems.push(item.Id);
                  });
                  var parameter = { dataStr: "" }
                  parameter.dataStr = JSON2.stringify(para);

                  parameter = CreateParameter(ReportDataAction.ActionType.Post, ReportDataAction.Functions.ReportAggregation, ReportDataAction.Methods.ReportAggregationMethods.ReportAggregation, parameter);
                  DataManager.sendData(urls.ReportUrls, parameter, ResultManager.AggregationReports_Success, ResultManager.Fail, false);
              },
              ///新建模板
              ///张双义
              AddTemplate: function () {
                  var sc = liger.get("selectCompanies");
                  var selecteds = sc.data;
                  if (!selecteds || !selecteds.length) return;
                  var r = liger.get("Reports");
                  var selectR = r.getSelectedItems();
                  DialogManager.ShowTemplateDialog(selectR);
              },
              ///选择模板
              ///张双义
              ChooseTemplate: function () {
                  var para = { Type: "Template" };
                  para.dialogHeight = 400;
                  para.dialogWidth = 600;
                  dialog.Open("ct/ReportData/ReportAggregation/ReportAggregationTemplateManager.aspx", "选择模板", para, function (result) {
                      if (result && result.Content) {
                          dialogControls.ImportTemplate = { ClassifyName: result.ClassifyName, ClassifyId: result.ClassifyId, Id: result.Id, Code: result.Code, Name: result.Name };
                          currentState.TemplateId = result.Id;
                          var Template = JSON.parse(result.Content);
                          var data = controls.companies.getData();
                          selectedTreeNodes = [];
                          ListManager.GetTreeNodeDataRecursive(data);
                          MediatorManager.ImportCompanys(Template.Companies);
                          MediatorManager.ImportReports(Template.ReportItems);
                      }
                  }, { width: 600, height: 400 });

                 
              },
              ///导入模板：组织机构
              ///参数：组织机构Companies[]
              ///张双义
              ImportCompanys: function (Companies) {
                  var sc = liger.get("selectCompanies");
                  var ImportNodes = [];
                  if (Companies[0].id) {
                      var Items = [];
                      for (var i = 0; i < Companies.length; i++) {
                          var temp = {};
                          temp.id = Companies[i].id;
                          temp.text = Companies[i].name;
                          ImportNodes.push(temp);
                      }
                  } else if (Companies[0]) {
                      for (var i = 0; i < selectedTreeNodes.length; ++i) {
                          $.each(Companies, function (index, node) {
                              if (node == selectedTreeNodes[i].id) {
                                  ImportNodes.push(selectedTreeNodes[i]);
                                  Companies.remove(index);
                                  return false;
                              }
                          });
                      }
                  }
                  selectedTreeNodes = ImportNodes;
                  sc.removeItems(sc.data);
                  sc.addItems(selectedTreeNodes);
              },
              ///导入模板：导入报表
              ///参数：Reports[]
              ///张双义
              ImportReports: function (Reports) {
                  var r = liger.get("Reports");
                  r.removeItems(r.data);
                  var rdata = Reports.sort(function (a, b) {
                      if (a.bbCode > b.bbCode) {
                          return 1;
                      } else { return -1; }
                  });
                  for (var i = 0; i < rdata.length; i++) {
                      rdata[i].id = rdata[i].Id;
                  }
                  r.addItems(rdata);
                  r.selectAll();

              }
          };
        var DialogManager = {
            ///筛选弹窗
            ///张双义
            ShowSearchDialog: function (item) {
                dialogControls.SearchDialog = $.ligerDialog.open({
                    target: $("#SearchDialog"), title: "筛选条件",
                    height: 230,
                    weith: 250,
                    buttons: [{
                        text: '确定',
                        onclick: function () {
                            var parameters = {};
                            parameters.Code = dialogControls.Code.getValue();
                            parameters.Name = dialogControls.Name.getValue();
                            //parameters.Wd = dialogControls.Wd.getValue();
                            parameters = CreateParameter(BasicAction.ActionType.Grid, BasicAction.Functions.CompanyManager, BasicAction.Methods.CompanyManagerMethods.GetCompanisAuthority, parameters);
                            DataManager.sendData("../../../handler/BasicHandler.ashx", parameters, ResultManager.LoadCompany_Success, ResultManager.Fail);
                            dialogControls.SearchDialog.hide();
                        }
                    }, {
                        text: '取消',
                        onclick: function () {
                            dialogControls.SearchDialog.hide();
                        }
                    }]
                });
            },
            ///维度选择弹窗
            ShowWdDialog: function () {
                dialogControls.Wd.setValue("1");
                dialogControls.Wd.setText("北方大区");
            },
            ///保存模板的类别选择弹窗
            ///张双义
            ChooseClassifyDialog: function () {
                var para = { Type: "Classify" };
                para.dialogHeight=400;
                para.dialogWidth = 600;
                dialog.Open("ct/ReportData/ReportAggregation/ReportAggregationTemplateManager.aspx", "选择模板", para, function (result) {
                    if (result && result.Id) {
                        dialogControls.TemplateClassify.setText(result.Name);
                        dialogControls.TemplateClassify.setValue(result.Id);
                    }
                }, { width: 600, height: 400 });
                
            },
            ///保存、编辑模板弹窗
            ///输入参数：Reports[Id:"",bbName:"",bbCode:""]
            ///张双义
            ShowTemplateDialog: function (Reports) {
                $("#IsOldOrNew").prop("checked", true);
                dialogControls.TemplateDialog = $.ligerDialog.open({
                    target: $("#TemplateDialog"), title: "保存模板",
                    height: 200,
                    width: 300,
                    buttons: [{
                        text: '确定',
                        onclick: function () {
                            var parameters = {};
                            if (!dialogControls.TemplateCode.getValue()) { alert("编号不能为空！"); return; }
                            if (!dialogControls.TemplateName.getValue()) { alert("名称不能为空！"); return; }
                            if (!dialogControls.TemplateClassify.getValue()) { alert("分类不能为空！"); return; }
                            parameters["Code"] = dialogControls.TemplateCode.getValue();
                            parameters["Name"] = dialogControls.TemplateName.getValue();
                            parameters["ClassifyId"] = dialogControls.TemplateClassify.getValue();
                            var Content = { ReportItems: [], Companies: [] };
                            for (var i = 0; i < selectedTreeNodes.length; ++i) {
                                var CampanyItem = { id: selectedTreeNodes[i].id, code: selectedTreeNodes[i].code, name: selectedTreeNodes[i].text };
                                Content.Companies.push(CampanyItem)
                            }
                            if (!Reports || Reports.length == 0) { alert("未选择汇总报表！"); return; }
                            for (var i = 0; i < Reports.length; ++i) {
                                var ReportItem = { Id: Reports[i].Id, bbCode: Reports[i].bbCode, bbName: Reports[i].bbName };
                                Content.ReportItems.push(ReportItem);
                            }
                            parameters["Content"] = JSON2.stringify(Content);
                            if ($('#IsOldOrNew').is(":checked")) {
                                parameters = CreateParameter(ReportDataAction.ActionType.Post, ReportDataAction.Functions.ReportAggregation, ReportDataAction.Methods.ReportAggregationMethods.SaveAggregationTemplate, parameters);
                                DataManager.sendData(urls.ReportUrls, parameters, ResultManager.SaveTemplate_Success, ResultManager.Fail);
                            } else {
                                parameters["Id"] = $("#TemplateId").val();
                                if (parameters.Id == "") { alert("未曾导入或默认模板！"); return; }
                                parameters = CreateParameter(ReportDataAction.ActionType.Post, ReportDataAction.Functions.ReportAggregation, ReportDataAction.Methods.ReportAggregationMethods.UpdateAggregationTemplate, parameters);
                                DataManager.sendData(urls.ReportUrls, parameters, ResultManager.SaveTemplate_Success, ResultManager.Fail);
                            }
                            dialogControls.ImportTemplate.ClassifyName = dialogControls.TemplateClassify.getText();
                            dialogControls.ImportTemplate.ClassifyId = parameters.ClassifyId;
                            dialogControls.ImportTemplate.Code = parameters.Code;
                            dialogControls.ImportTemplate.Name = parameters.Name;
                        }
                    }, {
                        text: '取消',
                        onclick: function () {
                            dialogControls.TemplateDialog.hide();
                        }
                    }]
                });
                if (dialogControls.ImportTemplate.Id) {
                    dialogControls.TemplateClassify.setValue(dialogControls.ImportTemplate.ClassifyId);
                    dialogControls.TemplateClassify.setText(dialogControls.ImportTemplate.ClassifyName);
                    dialogControls.TemplateCode.setValue(dialogControls.ImportTemplate.Code);
                    dialogControls.TemplateName.setValue(dialogControls.ImportTemplate.Name);
                    $("#TemplateId").val(dialogControls.ImportTemplate.Id);
                    if ($('#IsOldOrNew').is(":checked")) {
                        $("#IsOldOrNew").attr("checked", false);
                    }
                }
            }
        };
        var ResultManager = {
            LoadReports_Success: function (data) {
                if (data.success) {
                    ListManager.LoadReports(data.obj);
                } else {
                    $.ligerDialog.error(data.sMeg);
                }
            },
            LoadCompany_Success: function (data) {
                if (data.success) {
                    var list = (data.obj);
                    var Items = [];
                    var sc = liger.get("selectCompanies");
                    for (var i = 0; i < list.length; i++) {
                        var temp = {};
                        temp.id = list[i].Id;
                        temp.text = list[i].Name;
                        Items.push(temp);
                    }
                    sc.removeItems(sc.data);
                    sc.addItems(Items);
                    selectedTreeNodes = Items;
                } else {
                    $.ligerDialog.error(data.sMeg);
                }
            },
            LoadTemplate_Success: function (data) {
                if (data.success && data.obj && data.obj.Id) {
                    var result = data.obj;
                    dialogControls.ImportTemplate = { ClassifyName: result.TemplateName, ClassifyId: result.ClassifyId, Id: result.Id, Code: result.Code, Name: result.Name };
                    currentState.TemplateId = result.Id;
                    var Template = JSON.parse(result.Content);
                    if (Template.Companies[0].id && Template.Companies[0].id!="") {
                        var data = controls.companies.getData();
                        MediatorManager.ImportReports(Template.ReportItems);
                        MediatorManager.ImportCompanys(Template.Companies);
                    }
                }
            },
            Fail: function (data) {
                $.ligerDialog.error(data.sMeg);
            },
            SaveTemplate_Success: function (data) {
                dialogControls.TemplateDialog.hide();
                currentState.TemplateId = data.obj.Id;
                dialogControls.ImportTemplate.Id = data.obj.Id;
                MessageManager.InfoMessage(data.sMeg);

            },
            LoadDates: function (data) {
                if (data.success) {
                    currentState.DateFormats = data.obj;
                } else {
                    MessageManager.ErrorMessage(data.sMeg);
                }
            },
            AggregationReports_Success: function (data) {
                $.ligerDialog.success(data.sMeg);
            }
        };
    
    </script>
    <style type="text/css">
    .btn
    {
        width:30px;
        height:20px;
        margin:5px;
    }
    .btnn
    {
        width:30px;
        height:30px;
        margin:5px;
        font-size:13px;
    }
    .td
    {
        width:120px;
        padding:5px;
    }
    .searchBt
    {
        width:50px;
    }
    </style>
 
</head>
<body  style=" overflow:hidden">
<div id="tooBar"  style=" width:100%"></div>
    <div id="layout1" >
        <div position="left" title="单位选择">
        <div id="contentLeft" style=" width:100%;  margin:20px; padding:0px; vertical-align:middle;">
            <div id="lTable" style=" width:43%; height:100%; border: 1px solid #AECAF0; float:left; overflow:auto;">
                <div  style=" margin-left:7px" ><input type="checkbox" id="SelectTypeChechbox" checked="checked" class="liger-checkbox" />级联选择</div>
            <ul id="AllCompanies"></ul>
            </div>
            <div id="middle" style=" width:40px; height:200px;  float:left; margin-top:100px; text-align:center; ">
            <input type="button" value=">"  class="btn" onclick="ListManager.MoveToRight()"/>
                <input type="button" value="<"  class="btn" onclick="ListManager.MoveToLeft()"/>
                <input type="button" value=">>"  class="btn" onclick="ListManager.MoveToRightAll()"/>
                <input type="button" value="<<"  class="btn" onclick="ListManager.MoveToLeftAll()"/>
                <input type="button" value="筛选" class=" btnn"  onclick="DialogManager.ShowSearchDialog()"/>
            </div>
            <div id="rTable" style=" width:43%; height:100%;  float:left; overflow:hidden;">
            <div id="selectCompanies"  style="width:100%; height:100%;"></div>
            </div>
        </div>
        </div>
        <div position="center" style=" vertical-align:middle" title="报表选择" >
            <div id="contentRight" style=" width:100%;  padding:0px; margin:20px;  vertical-align:middle; text-align:center;">
            <div id="topTable" style=" width:80%; height:70%; float:left; overflow:hidden;">
            <div id="Reports"  style="width:100%; height:100%;"></div>
            </div>
            <div id="bottomTable" style=" width:80%; height:20%; border: 1px solid #AECAF0; float:left; overflow:auto; margin-top:5px;">
             
            </div>
            </div>
        </div>  
        <div position="bottom" style="text-align:center;">
            <a href="#" id="taskBtn"onclick="EventManager.taskBtn_Click();return false;">审计任务切换</a>
        </div>
    </div> 
    <div id="SearchDialog"  style=" display:none">
        <table style=" margin-top:15px">
        <tr><td align="right" style="width:75px">编号：</td><td class="td"><input type="text" id="Code" name="Name" /></td></tr>
        <tr><td align="right">名称：</td><td class="td"><input type="text" id ="Name" name="Name"  /></td></tr>
        <%--<tr><td align="right">维度：</td><td class="td"><input type="text" id ="Wd" /> </td></tr>--%>
        </table>
    </div>
    <div id="TemplateDialog" style=" display:none">
        <input  id="TemplateId" type="hidden"/>
        <div style=" margin-left:50px; margin-top:10px; text-align:inherit">保存为新模板：<input id ="IsOldOrNew" type ="checkbox"checked="checked" style=" padding:5px" /></div>
        <table>
        <tr><td align="right" style="width:85px; height:40px">编号：</td><td class="td"><input type="text" id ="TemplateCode" /></td></tr>
        <tr><td align="right">名称：</td><td class="td"><input type="text" id="TemplateName" /></td></tr>
        <tr><td align="right">分类：</td><td class="td"><input id ="TemplateClassify" /> </td></tr>
        </table>
    </div>
</body>
</html>
