<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReportAudit.aspx.cs" Inherits="Audit.ct.ReportAudit.ReportAudit" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>报表格式定义</title>
        <meta http-equiv="X-UA-Compatible" content="IE=10" />
     <meta http-equiv="X-UA-Compatible" content="IE=9" />
     <meta http-equiv="X-UA-Compatible" content="IE=8" />
     <meta http-equiv="X-UA-Compatible" content="IE=7" />
    <script src="../../lib/jquery/jquery-1.3.2.min.js" type="text/javascript"></script>
       <script src="../../Scripts/Ct_TextInput.js" type="text/javascript"></script>
    <script src="../../lib/Editor/kindeditor-min.js" type="text/javascript"></script>
    <link href="../../lib/Editor/themes/default/default.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/Editor/lang/zh_CN.js" type="text/javascript"></script>
    <script src="../../Scripts/FunctionMethodManager.js" type="text/javascript"></script>
    <script src="../../Scripts/AjaxTrigger.js" type="text/javascript"></script>

    <link href="../../Styles/Ct_TextInput.css" rel="stylesheet" type="text/css" />
    <script src="../../lib/ligerUI/js/core/base.js" type="text/javascript"></script>
    <script src="../../lib/ligerUI/js/core/inject.js" type="text/javascript"></script> 
    <script src="../../lib/ligerUI/js/plugins/ligerLayout.js" type="text/javascript"></script>
    <script src="../../lib/ligerUI/js/plugins/ligerComboBox.js" type="text/javascript"></script>
    
    <script src="../../lib/ligerUI/js/plugins/ligerTab.js" type="text/javascript"></script>
    <script src="../../lib/ligerUI/js/plugins/ligerGrid.js" type="text/javascript"></script>
    <script src="../../lib/ligerUI/js/plugins/ligerToolBar.js" type="text/javascript"></script>
    <script src="../../lib/ligerUI/js/plugins/CT_ligerDialog.js" type="text/javascript"></script>
    <script src="../../lib/ligerUI/js/plugins/ligerResizable.js" type="text/javascript"></script>
    <script src="../../lib/ligerUI/js/plugins/ligerDrag.js" type="text/javascript"></script>
    <script src="../../lib/json2.js" type="text/javascript"></script>
    <script src="../../lib/Base64.js" type="text/javascript"></script>
    
    <link href="../../lib/ligerUI/skins/ligerui-icons.css" rel="stylesheet" type="text/css" />
     <link href="../../lib/ligerUI/skins/Aqua/css/ligerui-all.css" rel="stylesheet" type="text/css" />
    <link href="../../lib/easyUI/themes/default/linkbutton.css" rel="stylesheet" type="text/css" />
    <link href="../../lib/easyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <link href="../../Styles/Common.css" rel="stylesheet" type="text/css" />


    <script src="../../../lib/ligerUI/js/plugins/ligerTextBox.js" type="text/javascript"></script>

    <script src="../../Scripts/ct/ReportData/ReportAggregation/ReportDataCell.js" type="text/javascript"></script>
    <script src="../../Scripts/Ct_Tool.js" type="text/javascript"></script>

    
    <script type="text/javascript">
        var currentState = { currentWidth: 0, controlWidth: 0, paras: {}, bbFormat: {}, bbData: {}, reportAudit: {}, currentProblemId: "", currentCellInfo: "" };
        var bdCodeCountMaps = {};
        var controls = { grid: {}, problemCategory: {}, problemRank: {}, problemContent: {}, problemContent: {}, DesignObj: {}, AuditCell: {} };
        //cellDesign:单元格审计定义  IndexData:联查数据  viewProblemList：问题列表与问题设置切换状态  inCreating:记录Tab是否在添加状态  iFrames：记录要显示的iframe有哪些 LoadedTab:记录已经加载过的页面
        var RightControl = { cellDesign: {}, IndexData: { cellIndexData: {}, para: {} }, viewProblemList: true, inCreating: false, TabItem: ["property", "relatedInf", "IndexJoinInf", "JoinInf"], selectedTab: "property", iFrames: {}, LoadedTab: {} };
        var auditCellInfos = {}; //键值对存储，索引为问题ID；值为当前选中单元格（可以是区域）；
        var urls = {
            reportAuditUrl: "../../handler/ReportAuditHandler.ashx",
            problemType: "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Get + "&MethodName=GetDictionaryListByClassType&FunctionName=" + BasicAction.Functions.DictionaryManager + "&ClassType=WTLB",
            problemLevel: "../../handler/BasicHandler.ashx?ActionType=" + BasicAction.ActionType.Get + "&MethodName=GetDictionaryListByClassType&FunctionName=" + BasicAction.Functions.DictionaryManager + "&ClassType=WTJB",
            ProblemHandler: "../../handler/ReportProblemHandler.ashx",
            CustomerJoinUrl: "ct/ReportAudit/CustomerReportLink.aspx",
            ReportJoinUrl: "ct/ReportAudit/ReportLink.aspx"

        };
        var DefaultDesign = {
            ExistsModules: [{ Code: "xgzb", Name: "相关指标" }, { Code: "zbqs", Name: "指标趋势"}], //,{ Code: "zbgc", Name: "指标构成" }
            IndexRelations: { IsOrNotMobile: "0", Indexs: [{ Code: "SQS", Name: "上期数" }, { Code: "TQS", Name: "同期数" }, { Code: "HBS", Name: "环比数" }, { Code: "TBS", Name: "同比数"}] },
            IndexTrend: { IsOrNotMobile: "0", DurationType: "Year" }
        };
        $(function () {
            currentState.paras = GetParameters();
            currentState.currentWidth = document.body.clientWidth;
            currentState.controlWidth = currentState.currentWidth * .25;
            //$("#layout1").ligerLayout({ allowRightCollapse: true, rightWidth: currentState.currentWidth * .45 });
            $("#layout1").ligerLayout({ allowRightCollapse: true, rightWidth: 440 });
            controls.AuditTab = $("#navtab1").ligerTab({ onAfterSelectTabItem: function (tabid) {
                if (RightControl.inCreating) return;
                RightControl.selectedTab = tabid;
                CommunicationManager.Right_Control.selectedTab(tabid);
                if (RightControl.LoadedTab[tabid] && tabid != "property") return;
                RightControl.LoadedTab[tabid] = true;
                var para = CommunicationManager.Right_Control.getAuditPara(controls.AuditCell);
                if (tabid == "property") {
                    $("#problemsList").ligerGrid("reload");
                } else if (tabid == "relatedInf") {
                    if (RightControl.cellDesign["IndexConclusion"]) {
                        para = CreateParameter(ReportAuditAction.ActionType.Post, ReportAuditAction.Functions.ReportAudit, ReportAuditAction.Methods.ReportAuditMethods.GetReportCellConclusionAndDiscription, para);
                        DataManager.sendData(urls.reportAuditUrl, para, resultManager.LoadConclusionAndDiscriptionSuccess, resultManager.Fail, false);
                    }
                    if (RightControl.cellDesign["IndexRelations"]) {
                        para.des = JSON.stringify(RightControl.cellDesign["IndexRelations"]);
                        para = CreateParameter(ReportAuditAction.ActionType.Post, ReportAuditAction.Functions.ReportAudit, ReportAuditAction.Methods.ReportAuditMethods.GetRelationsIndexesData, para);
                        DataManager.sendData(urls.reportAuditUrl, para, resultManager.LoadRelationsSuccess, resultManager.Fail, false);
                    }
                } else if (tabid == "IndexJoinInf") {
                    if (RightControl.cellDesign["IndexTrend"]) {
                        var series = RightControl.IndexData.cellIndexData.IndexTrend;
                        var selection = Grid1.Selection;
                        if (controls.AuditCell.BdPrimary||controls.AuditCell.BdPrimary == "") {
                            var cell = { CellCode: "", CellName: "变动区：" + controls.AuditCell.Name }; // controls.AuditCell.Code
                            cell.CellCode = toolsManager.CreateRowColCode(selection.FirstRow, selection.FirstCol);
                        } else {
                            var cell = currentState.bbFormat.bbData[selection.FirstRow][selection.FirstCol];
                        }
                        var TrendData = { series: series, Code: cell.CellCode, Name: cell.CellName };
                        //var s = currentState.bbFormat.paran
                        if (RightControl.IndexTrendFrame.loadData) {
                            RightControl.IndexTrendFrame.loadData(TrendData);
                        }
                    }
                    if (RightControl.cellDesign["IndexConstitution"]) {
                        para["des"] = JSON.stringify(RightControl.cellDesign["IndexConstitution"]);
                        para = CreateParameter(ReportAuditAction.ActionType.Post, ReportAuditAction.Functions.ReportAudit, ReportAuditAction.Methods.ReportAuditMethods.GetIndexConstitutionCellDefinitionData, para);
                        DataManager.sendData(urls.reportAuditUrl, para, resultManager.LoadIndexConstitutionSuccess, resultManager.Fail, false);
                    }
                } else if (tabid == "JoinInf") {
                    if (!RightControl.ReportJoinFrame) {
                        RightControl.ReportJoinFrame = window.frames["ReportJoin"];
                        window.frames["ReportJoin"].location.href = "JointReports.aspx";
                    }
                }
            }
            });
            $("#problemTitle").CTTextBox({ innerText: "", width: currentState.controlWidth });
            $("#problemDepend").CTTextBox({ innerText: "", width: currentState.controlWidth });
            controls.problemCategory = $("#problemCategory").ligerComboBox({ width: currentState.controlWidth, url: urls.problemType, valueFieldID: 'test3', valueField: "Code", textField: "Name" });
            controls.problemRank = $("#problemRank").ligerComboBox({ width: currentState.controlWidth, url: urls.problemLevel, valueFieldID: 'test3', valueField: "Code", textField: "Name" });
            
            $("#saveBtn").bind("click", CommunicationManager.Right_Control.SaveConclusionAndDiscription);
            $("#JoinBtn").bind("click", CommunicationManager.Right_Control.CustomerJoin);
            $("#problemGridToobar").ligerToolBar({ items: [
                { text: '创建疑点', click: CommunicationManager.ProblemManager.ButtonClick, icon: 'add' },
                { line: true },
                { text: '修改疑点', click: CommunicationManager.ProblemManager.ButtonClick, icon: 'modify' },
                { line: true },
                { text: '删除疑点', click: CommunicationManager.ProblemManager.DeleteProblem, icon: 'delete' }
            ]
            });
            $("#problemEditToobar").ligerToolBar({ items: [
                { text: '保存', click: CommunicationManager.ProblemManager.ButtonClick, icon: 'add' },
                { line: true },
                { text: '返回', click: CommunicationManager.ProblemManager.ButtonClick, icon: 'prev' }
            ]
            });
            $("#isOrNotCell").bind('click', function () {
                if ($("#isOrNotCell").attr("checked")) {
                    auditGridManager.SetComment();
                } else {
                    auditGridManager.ClearComment();
                }
            });

            controls.grid = $("#problemsList").ligerGrid({
                columns: [
                { display: '主键', name: 'Id', align: 'left', width: 15, hide: true },
            { display: '疑点标题', name: 'Title', width: 100, align: 'left' },
            { display: '创建时间', name: 'CreateTime', width: 100, align: 'left' },
            { display: '创建人', name: 'Creater', width: 100, align: 'left' }
               ], pageSize: 5, sortName: 'CreateTime',
                width: '100%', height: '99%',
                rownumbers: true,
                isScroll: true,
                resizable: false,
                onSelectRow: function (rowdata, rowid, rowobj) {

                    CommunicationManager.ProblemManager.SetProblem(rowdata);
                    auditGridManager.SelectedCells();
                    auditGridManager.SetComment();
                    var selectedRow = controls.grid.getSelected();
                    if (!selectedRow) {
                        controls.grid.select(rowid);
                    }
                },
                onUnSelectRow: function (rowdata, rowid, rowobj) {
                    currentState.currentProblemId = rowdata.Id;
                    if (rowdata.CellInfo)
                        currentState.currentCellInfo = JSON.parse(rowdata.CellInfo);
                    auditGridManager.ClearComment();
                    CommunicationManager.ProblemManager.ClearProblem();


                }

            });
            auditGridManager.InitializeGrid();
            CommunicationManager.InitializeAuditData();
        });

        KindEditor.ready(function (K) {
            K.each({
                'plug-align': {
                    name: '对齐方式',
                    method: {
                        'justifyleft': '左对齐',
                        'justifycenter': '居中对齐',
                        'justifyright': '右对齐'
                    }
                },
                'plug-order': {
                    name: '编号',
                    method: {
                        'insertorderedlist': '数字编号',
                        'insertunorderedlist': '项目编号'
                    }
                },
                'plug-indent': {
                    name: '缩进',
                    method: {
                        'indent': '向右缩进',
                        'outdent': '向左缩进'
                    }
                }
            }, function (pluginName, pluginData) {
                var lang = {};
                lang[pluginName] = pluginData.name;
                KindEditor.lang(lang);
                KindEditor.plugin(pluginName, function (K) {
                    var self = this;
                    self.clickToolbar(pluginName, function () {
                        var menu = self.createMenu({
                            name: pluginName,
                            width: pluginData.width || 100
                        });
                        K.each(pluginData.method, function (i, v) {
                            menu.addItem({
                                title: v,
                                checked: false,
                                iconClass: pluginName + '-' + i,
                                click: function () {
                                    self.exec(i).hideMenu();
                                }
                            });
                        })
                    });
                });
            });
            controls.problemContent = K.create('#problemContent', {
                themeType: 'qq',
                items: [
						'bold', 'italic', 'underline', 'fontname', 'fontsize', 'forecolor', 'hilitecolor', 'plug-align', 'plug-order', 'plug-indent'
					],
                width: currentState.controlWidth + 'px',
                minWidth: "100px"
            });
            controls.ConclusionEdit = K.create('#editBox', {
                themeType: 'qq',
                items: [
                			'bold', 'italic', 'underline', 'fontname', 'fontsize', 'forecolor', 'hilitecolor', 'plug-align', 'plug-order', 'plug-indent'
                		],
                width: '390px',
                minWidth: '100px'
            });
        });



        var CommunicationManager = {
            InitializeAuditData: function () {
                var parameter = currentState.paras;
                parameter = CreateParameter(ReportAuditAction.ActionType.Post, ReportAuditAction.Functions.ReportAudit, ReportAuditAction.Methods.ReportAuditMethods.GetReportAuditData, parameter);
                DataManager.sendData(urls.reportAuditUrl, parameter, resultManager.InitializeSuccess, resultManager.Fail, false);
            },
            GridManager: {
                InitializeGrid: function () {
                    var iframe = CommunicationManager.GridManager.GetIframe();
                },
                GetIframe: function () {
                    return window.frames["gridIframe"];
                }
            },
            ProblemManager: {
                ButtonClick: function (item) {
                    if (item.text == "创建疑点") {
                        $("#isOrNotCell").attr("checked", "");
                        currentState.currentProblemId = "";
                        CommunicationManager.ProblemManager.ClearProblem();
                        CommunicationManager.ProblemManager.ShowEditWindow();
                    } else if (item.text == "修改疑点") {
                        $("#isOrNotCell").attr("checked", "");
                        var row = controls.grid.getSelectedRow();
                        if (!row) return;
                        CommunicationManager.ProblemManager.ShowEditWindow();
                    } else if (item.text == "保存") {
                        if (currentState.currentProblemId != "") {
                            CommunicationManager.ProblemManager.EditProblem();
                        } else {
                            CommunicationManager.ProblemManager.SaveProblem();
                        }
                    } else if (item.text == "返回") {
                        CommunicationManager.ProblemManager.ShowEditWindow();
                    }
                },
                ShowEditWindow: function () {
                    if (RightControl.viewProblemList) {
                        document.getElementById("problemIf").style.display = "table";
                        document.getElementById("problemGridToobar").style.display = "none";
                        document.getElementById("problemEditToobar").style.display = "block";
                        RightControl.viewProblemList = false;
                    } else {
                        document.getElementById("problemIf").style.display = "none";
                        document.getElementById("problemGridToobar").style.display = "block";
                        document.getElementById("problemEditToobar").style.display = "none";
                        RightControl.viewProblemList = true;
                    }
                    $("#problemsList").ligerGrid("reload");

                },
                SaveProblem: function () {
                    var para = { Type: "", State: "0", Rank: "", Title: "", Content: "", DependOn: "", ReportAuditId: "", IsOrNotCell: "", CellInfo: "" };
                    $.extend(true, para, currentState.paras);
                    para.Zq = currentState.paras.Cycle;
                    para.Title = $("#problemTitle").val();
                    para.DependOn = $("#problemDepend").val();
                    para.Type = controls.problemCategory.selectedValue;
                    if (!para.Type) { alert("请选择类型"); return; }
                    para.Rank = controls.problemRank.getValue();
                    if (!para.Rank) { alert("请选择级别"); return; }
                    para.Content = controls.problemContent.html();
                    para.ReportAuditId = currentState.reportAudit.Id;
                    para.CellInfo = JSON2.stringify(currentState.currentCellInfo);
                    if ($("#isOrNotCell").attr("checked")) {
                        para.IsOrNotCell = "1";
                    } else {
                        para.IsOrNotCell = "0";
                    }
                    para = CreateParameter(ReportProblemAvtion.ActionType.Post, ReportProblemAvtion.Functions.ReportProblem, ReportProblemAvtion.Methods.ReportProblemMethods.Add, para);
                    DataManager.sendData(urls.ProblemHandler, para, resultManager.saveProblemSuccess, resultManager.Fail, false);
                    CommunicationManager.RefreshProblems();
                    CommunicationManager.ProblemManager.ClearProblem();
                    CommunicationManager.ProblemManager.ShowEditWindow();

                },
                DeleteProblem: function () {
                    var para = { Id: "" };
                    para.Id = currentState.currentProblemId;
                    if (para.Id == "") return;
                    para = CreateParameter(ReportProblemAvtion.ActionType.Post, ReportProblemAvtion.Functions.ReportProblem, ReportProblemAvtion.Methods.ReportProblemMethods.Delete, para);
                    DataManager.sendData(urls.ProblemHandler, para, resultManager.saveProblemSuccess, resultManager.Fail, false);
                    CommunicationManager.RefreshProblems();
                },
                EditProblem: function () {
                    var para = { Type: "", Rank: "", Title: "", Content: "", DependOn: "", Id: "", IsOrNotCell: "", CellInfo: "" };

                    para.Title = $("#problemTitle").val();
                    para.DependOn = $("#problemDepend").val();
                    para.Type = controls.problemCategory.selectedValue;
                    para.Rank = controls.problemRank.getValue();
                    para.Content = controls.problemContent.html();
                    para.Id = currentState.currentProblemId;
                    para.CellInfo = JSON2.stringify(currentState.currentCellInfo);
                    if ($("#isOrNotCell").attr("checked")) {
                        para.IsOrNotCell = "1";
                    } else {
                        para.IsOrNotCell = "0";
                    }

                    para = CreateParameter(ReportProblemAvtion.ActionType.Post, ReportProblemAvtion.Functions.ReportProblem, ReportProblemAvtion.Methods.ReportProblemMethods.Edit, para);
                    DataManager.sendData(urls.ProblemHandler, para, resultManager.saveProblemSuccess, resultManager.Fail, false);

                    CommunicationManager.RefreshProblems();
                    CommunicationManager.ProblemManager.ClearProblem();
                    CommunicationManager.ProblemManager.ShowEditWindow();
                },
                ClearProblem: function () {
                    $("#problemTitle").val("");
                    $("#problemDepend").val("");
                    controls.problemCategory.setValue("");
                    controls.problemRank.setValue("");
                    controls.problemContent.html("");
                    currentState.currentProblemId = "";
                    $("#isOrNotCell").attr("checked", "");
                    currentState.currentCellInfo = "";
                    currentState.currentProblemId = "";
                },
                SetProblem: function (rowObj) {
                    currentState.currentProblemId = rowObj.Id;
                    if (rowObj.CellInfo)
                        currentState.currentCellInfo = JSON.parse(rowObj.CellInfo);
                    $("#problemTitle").val(rowObj.Title);
                    $("#problemDepend").val(rowObj.DependOn);
                    controls.problemCategory.setValue(rowObj.Type);
                    controls.problemRank.setValue(rowObj.Rank);
                    controls.problemContent.html(rowObj.Content);
                    if (rowObj.IsOrNotCell && rowObj.IsOrNotCell != undefined) {
                        $("#isOrNotCell").attr("checked", "checked");
                    } else {
                        $("#isOrNotCell").attr("checked", "");
                    }

                }
            },
            RefreshProblems: function () {
                var para = { Id: currentState.reportAudit.Id };
                para = CreateParameter(ReportAuditAction.ActionType.Post, ReportAuditAction.Functions.ReportAudit, ReportAuditAction.Methods.ReportAuditMethods.GetProblemsList, para);
                DataManager.sendData(urls.reportAuditUrl, para, resultManager.ProblemsRefreshSuccess, resultManager.Fail, false);
            },
            //侧面布局 和初始化
            //张双义
            Right_Layout: {

        },
        Right_Control: {
            //设置frame的显示框架信息 
            setFrameData: function (module) {
                var IFrame = window.frames[module]; //"relatedInfFrame"
                if (IFrame.loadData && RightControl.cellDesign[module]) {
                    var height = $(window).height() - 100;
                    var param = { data: RightControl.cellDesign[module], height: height };
                    IFrame.loadData(param);
                }
            },
            selectedTab: function (tabId) {
                $.each(RightControl.TabItem, function (code, node) {
                    if (tabId == node) {
                        $("#" + node).css("display", "block");
                    } else {
                        $("#" + node).css("display", "none");
                    }
                });
            },
            getAuditPara: function (cell) {
                var para = { TaskId: "", PaperId: "", ReportId: "", CompanyId: "", Year: "", Cycle: "", ReportType: "", CellCode: "", BdPrimary: "" };
                para.TaskId = currentState.paras.TaskId;
                para.PaperId = currentState.paras.PaperId;
                para.ReportId = currentState.paras.ReportId;
                para.CompanyId = currentState.paras.CompanyId;
                para.ReportType = currentState.paras.ReportType;
                para.CellCode = cell.Code;
                if (cell.BdPrimary) {
                    para.BdPrimary = cell.BdPrimary;
                }
                para.Year = currentState.paras.Year;
                para.Cycle = currentState.paras.Cycle;
                return para;
            },
            LoadIndexTrend: function () {
                if (!RightControl.IndexTrendFrame) return;
                var para = CommunicationManager.Right_Control.getAuditPara(controls.AuditCell);
                para.des = JSON.stringify(RightControl.cellDesign["IndexTrend"]);
                para = CreateParameter(ReportAuditAction.ActionType.Post, ReportAuditAction.Functions.ReportAudit, ReportAuditAction.Methods.ReportAuditMethods.GetIndexTrendChartData, para);
                DataManager.sendData(urls.reportAuditUrl, para, resultManager.LoadIndexTrendSuccess, resultManager.Fail, false);
            },
            ReportJoin: function (reportPara) {
                var para = CommunicationManager.Right_Control.getAuditPara(controls.AuditCell);
                var des = JSON.stringify(reportPara);
                para = JSON.stringify(para);
                para = Base64.encode(para);
                des = encodeURI(encodeURI(des)); ;
                var parame = "?data=" + para + "&des=" + des;
                parent.NavigatorNode({ id: "070", text: "报表联查信息", attributes: { url: urls.ReportJoinUrl + parame} });
            },
            CustomerJoin: function () {
                var para = CommunicationManager.Right_Control.getAuditPara(controls.AuditCell);
                var des = RightControl.cellDesign["CustomerJoin"];
                if (des.LinkType = "url") {
                    //window.location = des.Content;
                    parent.NavigatorNode({ id: "061", text: "联查信息", attributes: { url: des.Content} });
                } else {
                    des = JSON.stringify
                    para = JSON.stringify(para);
                    para = Base64.encode(para);
                    des = Base64.encode(des);
                    var param = "?data=" + para + "&des=" + des;
                    parent.NavigatorNode({ id: "061", text: "联查信息", attributes: { url: urls.CustomerJoinUrl + param} });
                }
            },
            SaveConclusionAndDiscription: function () {
                var parame = { TaskId: "", PaperId: "", ReportId: "", CompanyId: "", Year: "", Cycle: "", ReportType: "", CellCode: "", BdPrimary: "" };
                if (RightControl.IndexData.cellIndexData.ConclusionAndDiscription != "") {
                    parame = RightControl.IndexData.cellIndexData.ConclusionAndDiscription;
                } else {
                    parame = CommunicationManager.Right_Control.getAuditPara(controls.AuditCell);
                }
                parame.Conclusion = controls.ConclusionEdit.html();
                parame = CreateParameter(ReportAuditAction.ActionType.Post, ReportAuditAction.Functions.ReportAudit, ReportAuditAction.Methods.ReportAuditMethods.SaveReportCellIndexConclusion, parame);
                DataManager.sendData(urls.reportAuditUrl, parame, resultManager.SaveIndexDataSuccess, resultManager.Fail, false);
            }
        }
    };
    var resultManager = {
        InitializeSuccess: function (data) {
            gridManager.Success(data);
            if (data.success) {
                //审计问题加载
                var datas = { Rows: [] };
                datas.Rows = data.obj.reportProblems;
                controls.grid.set({ data: datas });
                //审计定义加载
                controls.DesignObj = data.obj.reportCellsDefinition;
                //审计状态加载
                currentState.reportAudit = data.obj.reportAudit;
            }
        },
        Fail: function (data) {
            $.ligerDialog.error(data);
        },
        OpenDialog: function (content) {
            $.ligerDialog.open({
                height: 200,
                width: 200,
                title: "系统提示",
                showMax: false,
                showToggle: false,
                showMin: false,
                isResize: false,
                slide: false,
                modal: false,
                content: content
            });
        },
        saveProblemSuccess: function (data) {
            if (data.success) {
                $.ligerDialog.success(data.sMeg);
            } else {
                $.ligerDialog.error(data.sMeg);
            }
        },
        ProblemsRefreshSuccess: function (data) {
            if (data.success) {
                var datas = { Rows: [] };
                datas.Rows = data.obj;
                controls.grid.set({ data: datas });

            } else {
                $.ligerDialog.error(data.sMeg);
            }
        },
        LoadIndexTrendSuccess: function (data) {
            if (data.success) {
                RightControl.IndexData.cellIndexData.IndexTrend = data.obj;
            } else {
                alert(data.sMeg);
            }
        },
        LoadIndexConstitutionSuccess: function (data) {
            if (data.success) {
                RightControl.IndexData.cellIndexData.IndexConstitution = data.obj;
                if (RightControl.IndexConstitutionFrame.loadData) {
                    RightControl.IndexConstitutionFrame.loadData(data.obj);
                } else {
                    $("#IndexConstitution").onload = function () {
                        if (this.readyState && this.readyState != 'complete') return;
                        else {
                            RightControl.IndexConstitutionFrame.loadData(data.obj);
                        }
                    };
                }
            } else {
                alert(data.sMeg);
            }
        },
        LoadRelationsSuccess: function (data) {
            if (data.success) {
                RightControl.IndexData.cellIndexData.Relations = data.obj;
                var IndexRelations = RightControl.cellDesign["IndexRelations"];
                var parame = { Relations: IndexRelations, data: data.obj };
                RightControl.IndexRelations.loadData(parame);
            } else {
                alert(data.sMeg);
            }
        },
        LoadConclusionAndDiscriptionSuccess: function (data) {
            if (data.success) {
                RightControl.IndexData.cellIndexData.ConclusionAndDiscription = data.obj;
                if (data.obj.Conclusion) {
                    controls.ConclusionEdit.html(data.obj.Conclusion);
                } else {
                    controls.ConclusionEdit.html("");
                }
            } else {
                alert(data.sMeg);
            }
        },
        SaveIndexDataSuccess: function (data) {
            if (data.success) {
                $.ligerDialog.success(data.sMeg);
            } else {
                $.ligerDialog.error(data.sMeg);
            }
        }
    };

    var auditGridManager = {
        Grid_KeyDown: function () {
            if (event.ctrlKey && event.keyCode == 67) {
                Grid1.Selection.CopyData();
            }
        },
        RowColChange_Event: function () {
            var cells = [];
            var selection = Grid1.Selection;
            for (var i = selection.FirstRow; i <= selection.LastRow; i++) {
                for (var j = selection.FirstCol; j <= selection.LastCol; j++) {
                    if (Grid1.Cell(i, j).Tag && Grid1.Cell(i, j).Tag != "") {
                        var cell = {};
                        var codeData = Grid1.Cell(i, j).Tag.split("|");
                        var cellData;
                        if (codeData[2]) {
                            cellData = JSON2.parse(codeData[2]);
                        }
                        var TagData = codeData[0].split(";");
                        if (TagData[0] == "0") {
                            cell.Code = cellData.CellCode;
                            cell.Name = cellData.CellName;
                            cell.DataType = cellData.CellDataType;
                            cell.BdPrimary = auditGridManager.CreateBdPrimary(TagData[2], i, j);
                        } else if (TagData[0] == "1") {
                            cell.Code = cellData.CellCode;
                            cell.Name = cellData.CellName;
                            cell.DataType = cellData.CellDataType;
                        }
                        if (cell.Code) {
                            cells.push(cell);
                        }
                    }
                }
            }
            controls.AuditTab.removeTabItem("relatedInf");
            controls.AuditTab.removeTabItem("IndexJoinInf");
            controls.AuditTab.removeTabItem("JoinInf");
            if (cells.length == 1) {// && controls.DesignObj[cells[0].Code]
                //设置审计定义显示
                var DesignData;
                if (controls.DesignObj[cells[0].Code]) {
                    DesignData = controls.DesignObj[cells[0].Code].Data;
                    RightControl.cellDesign = JSON2.parse(DesignData);
                } else {
                    if (cells[0].DataType == "02") {
                        DesignData = DefaultDesign;
                        RightControl.cellDesign = DefaultDesign;
                    }
                }
                if (DesignData) {
                    controls.AuditCell = cells[0];
                    var designedTabs = RightControl.cellDesign.ExistsModules;
                    var Items = {};
                    RightControl.iFrames = {};
                    RightControl.inCreating = true;
                    $.each(designedTabs, function (index, node) {
                        RightControl.iFrames[node.Code] = true;
                    });
                    $.each(designedTabs, function (index, node) {
                        var height = $(window).height() - 80;
                        switch (node.Code) {
                            case "sjjl": //审计结论
                            case "xgzb": //相关指标
                                if (!Items.relatedInf) {
                                    Items.relatedInf = { tabid: "relatedInf", text: "相关指标(结论)", showClose: false };
                                    controls.AuditTab.addTabItem(Items.relatedInf);
                                    if (RightControl.iFrames.sjjl) {
                                        $("#IndexConclusion").css("display", "block")
                                        $("#IndexConclusion_header").css("display", "block")
                                        if (RightControl.iFrames.xgzb) {
                                            $("#IndexRelations").css("display", "block")
                                            $("#IndexRelations_header").css("display", "block");
                                            $("#IndexConclusion").css("height", height - 225);
                                            if (!RightControl.IndexRelations) {
                                                RightControl.IndexRelations = window.frames["IndexRelations"];
                                                RightControl.IndexRelations.location.href = "RelatedInfomation.aspx";
                                            }
                                        } else {
                                            $("#IndexRelations").css("display", "none");
                                            $("#IndexRelations_header").css("display", "none");
                                            $("#IndexConclusion").css("height", height);
                                        }
                                    } else {
                                        $("#IndexConclusion").css("display", "none")
                                        $("#IndexConclusion_header").css("display", "none")
                                        $("#IndexRelations").css("display", "block")
                                        $("#IndexRelations_header").css("display", "block");
                                        if (!RightControl.IndexRelations) {
                                            RightControl.IndexRelations = window.frames["IndexRelations"];
                                            RightControl.IndexRelations.location.href = "RelatedInfomation.aspx";
                                        }
                                    }
                                }
                                break;
                            case "zbgc": //指标构成//指标联查
                            case "zbqs": //指标趋势
                                if (!Items.IndexJoinInf) {
                                    Items.IndexJoinInf = { tabid: "IndexJoinInf", text: "指标趋势(构成)", showClose: false };
                                    controls.AuditTab.addTabItem(Items.IndexJoinInf);
                                    if (RightControl.iFrames.zbgc) {
                                        $("#IndexConstitution").css("display", "block");
                                        $("#IndexConstitution_header").css("display", "block");
                                        if (RightControl.iFrames.zbqs) {
                                            $("#IndexTrend_header").css("display", "block");
                                            $("#IndexTrend").css("display", "block")
                                            $("#IndexConstitution").css("height", height - 275);
                                            if (!RightControl.IndexTrendFrame) {
                                                RightControl.IndexTrendFrame = window.frames["IndexTrend"];
                                                RightControl.IndexTrendFrame.location.href = "IndexTrend.aspx";
                                            } else {
                                                CommunicationManager.Right_Control.LoadIndexTrend();
                                            }
                                        } else {
                                            $("#IndexTrend").css("display", "none");
                                            $("#IndexTrend_header").css("display", "none");
                                            $("#IndexConstitution").css("height", height);
                                        }
                                        if (!RightControl.IndexConstitutionFrame) {
                                            RightControl.IndexConstitutionFrame = window.frames["IndexConstitution"];
                                            RightControl.IndexConstitutionFrame.location.href = "IndexLink.aspx";
                                        }
                                    } else {
                                        $("#IndexConstitution").css("display", "none");
                                        $("#IndexConstitution_header").css("display", "none");
                                        $("#IndexTrend").css("display", "block");
                                        $("#IndexTrend_header").css("display", "block");
                                        if (!RightControl.IndexTrendFrame) {
                                            RightControl.IndexTrendFrame = window.frames["IndexTrend"];
                                            RightControl.IndexTrendFrame.location.href = "IndexTrend.aspx";
                                        } else {
                                            CommunicationManager.Right_Control.LoadIndexTrend();
                                        }
                                    }
                                }
                                break;
                            case "bblc": //报表联查
                            case "zdylc": //自定义联查
                                if (!Items.JoinInf) {
                                    Items.JoinInf = { tabid: "JoinInf", text: "报表联查", showClose: false };
                                    controls.AuditTab.addTabItem(Items.JoinInf);
                                    if (RightControl.iFrames.bblc) {
                                        if (RightControl.iFrames.zdylc) {
                                            $("#CustomerJoin").css("display", "block")
                                            $("#ReportJoin").css("height", height - 70);
                                        } else {
                                            $("#CustomerJoin").css("display", "none");
                                            $("#ReportJoin").css("height", height);
                                        }
                                        CommunicationManager.Right_Control.setFrameData("ReportJoin");
                                    } else {
                                        $("#CustomerJoin").css("display", "block")
                                    }
                                }
                                break;
                        }
                    });
                    RightControl.inCreating = false;
                }
            }
            var tabs = controls.AuditTab.getTabidList();
            var tabId = "property";
            $.each(tabs, function (index, tab) {
                if (tab == RightControl.selectedTab) {
                    tabId = RightControl.selectedTab;
                    return false;
                }
            });
            RightControl.LoadedTab = {};
            controls.AuditTab.selectTabItem(tabId);
        },
        CreateCode: function (row, col) {
            if (currentState.bbFormat.bbData[row] && currentState.bbFormat.bbData[row][col]) {
                return currentState.bbFormat.bbData[row][col].CellCode;
            } else { return null; }
        },
        CreateDataType: function (row, col) {
            if (currentState.bbFormat.bbData[row] && currentState.bbFormat.bbData[row][col]) {
                return currentState.bbFormat.bbData[row][col].CellDataType;
            }
        },
        ///组织 BdPrimary
        CreateBdPrimary: function (bdqCode, rowIndex, colIndex) {
            var OffsetRowCol;
            var Primaries = [];
            var BdPrimary = "";
            var bdFormat = currentState.bbFormat.bdq.Bdqs[currentState.bbFormat.bdq.BdqMaps[bdqCode]];
            if (bdFormat.BdType == "1") {
                OffsetRowCol = currentState.bbFormat.bbData[bdFormat.Offset];
                $.each(OffsetRowCol, function (index, node) {
                    if (node.CellPrimary == "1") {
                        var PrimariesCell = Grid1.Cell(rowIndex, node.CellCol);
                        var CellData = { CellCode: node.CellCode, Value: PrimariesCell.Text };
                        Primaries.push(CellData);
                    }
                });
            } else if (bdFormat.BdType == "2") {
                $.each(currentState.bbFormat.bbData, function (index, RowData) {
                    if (RowData[bdFormat.Offset]) {
                        if (RowData[bdFormat.Offset].CellPrimary == "1") {
                            var PrimariesCell = Grid1.Cell(RowData[bdFormat.Offset].CellRow, colIndex);
                            var CellData = { CellCode: RowData[bdFormat.Offset].CellCode, Value: PrimariesCell.Text };
                            Primaries.push(CellData);
                        }
                    }
                });
            }
            $.each(Primaries, function (index, node) {
                BdPrimary += node.CellCode + ":" + node.Value + ",";
            });
            BdPrimary = BdPrimary.substring(0, BdPrimary.length - 1);

            return BdPrimary;
        },
        InitializeGrid: function () {
            Grid1.AutoRedraw = false;
            Grid1.DisplayRowIndex = true;
            Grid1.FixedRowColStyle = 0;
            Grid1.MultiSelect = true;
            Grid1.Appearance = 0;
            Grid1.AutoRedraw = true;
            Grid1.Refresh();
        },
        SetRowColText: function (CellItem) {
            auditGridManager.SetRowColTextByRowCol(CellItem.row, CellItem.col, CellItem);
        },
        SetRowColTextByRowCol: function (row, col, CellItem) {
            if (CellItem.cellDataType == "01") {
                Grid1.Cell(row, col).Alignment = 4;
            } else if (CellItem.cellDataType == "02") {
                Grid1.Cell(row, col).Alignment = 12;
            }
            if (CellItem.value != undefined)
                Grid1.Cell(row, col).Text = CellItem.value;
            else {
                Grid1.Cell(row, col).Text = "";
            }
        },
        Print: function () {
            Grid1.PrintPreview(100);
        },
        Export: function () {
            Grid1.ExportToExcel(currentState.paras.ReportName + ".xls");
            $.ligerDialog.success(currentState.paras.ReportName + ".xls" + "已经导出到桌面");
        },
        SetComment: function () {
            if (currentState.currentProblemId != "") {
                auditGridManager.ClearComment();
                var selection = Grid1.Selection;
                var title = $("#problemTitle").val();
                for (var i = 1; i < Grid1.Rows; i++) {
                    for (var j = 1; j < Grid1.Cols; j++) {
                        Grid1.Cell(i, j).Comment = "";
                    }
                }
                for (var i = selection.FirstRow; i <= selection.LastRow; i++) {
                    for (var j = selection.FirstCol; j <= selection.LastCol; j++) {
                        Grid1.Cell(i, j).Comment = title;
                    }
                }
                var para = { FirstRow: selection.FirstRow, FirstCol: selection.FirstCol, LastRow: selection.LastRow, LastCol: selection.LastCol };
                currentState.currentCellInfo = para;
            }
        },
        ClearComment: function () {
            if (currentState.currentCellInfo != "") {
                var selection = currentState.currentCellInfo;
                for (var i = selection.FirstRow; i <= selection.LastRow; i++) {
                    for (var j = selection.FirstCol; j <= selection.LastCol; j++) {
                        Grid1.Cell(i, j).Comment = "";
                    }
                }
                currentState.CellInfo = "";
            }
        },
        SelectedCells: function () {
            if (currentState.currentCellInfo) {
                var selection = currentState.currentCellInfo;
                Grid1.Range(selection.FirstRow, selection.FirstCol, selection.LastRow, selection.LastCol).Selected();
            }
        }
    };
        var toolsManager = {            
            IsOrNotBdq: function (Row, Col) {
                var code = "-1";
                $.each(currentState.bbFormat.bdq.Bdqs, function (index, item) {
                    if (item == null) return;
                    if (item.BdType == "1" && item.Offset == Row) {
                        //变动行
                        code = item.Code;
                    } else if (item.BdType == "2" && item.Offset == Col) {
                        code = item.Code;
                    }
                }
                );
                return code;
            },
            CreateRowColCode: function (row, col) {
                return toolsManager.CreateNmCode(row) + toolsManager.CreateNmCode(col);
            },
            CreateNmCode: function (num) {
                var temp = num.toString();
                for (var i = temp.length; i < 4; i++) {
                    temp = "0" + temp;
                }
                return temp;
            }, CovertColorStr: function (colorStr) {
                var temp = colorStr.substring(1);
                var newColor = temp.substring(4, 6) + temp.substring(2, 4) + temp.substring(0, 2);
                return parseInt(newColor, 16);
            }
        };
        ///*****************************
        ///右侧弹框改动
        ///@张双义
        window.onresize = function () {
            var height = $(window).height() - 50;
            $("#JoinInf").css("height", height);
            $("#IndexConclusion").css("height", height - 265);
            if (RightControl.iFrames.zdylc) {
                $("#ReportJoin").css("height", height - 100);
            } else {
                $("#ReportJoin").css("height", height - 30);
            }
            if (RightControl.iFrames.zbqs) {
                $("#IndexConstitution").css("height", height - 300);
            } else {
                $("#IndexConstitution").css("height", height - 30);
            }
        }
    </script>
    <style type="text/css">
    .table
    {
        margin:10px; 
        width:100%;
        font-size:13px;
    }
    .tr
    {
       margin-top:10px;
    }    
 .c4,.c4:hover{
	color: #333;
	border-color: #52d689;
	background: #b8eecf;
	background: -webkit-linear-gradient(top,#b8eecf 0,#a4e9c1 100%);
	background: -moz-linear-gradient(top,#b8eecf 0,#a4e9c1 100%);
	background: -o-linear-gradient(top,#b8eecf 0,#a4e9c1 100%);
	background: linear-gradient(to bottom,#b8eecf 0,#a4e9c1 100%);
	filter: progid:DXImageTransform.Microsoft.gradient(startColorstr=#b8eecf,endColorstr=#a4e9c1,GradientType=0);
}
a.c4:hover{
	background: #a4e9c1;
	filter: none;
}
.c3,.c3:hover{
	color: #333;
	border-color: #ff8080;
	background: #ffb3b3;
	background: -webkit-linear-gradient(top,#ffb3b3 0,#ff9999 100%);
	background: -moz-linear-gradient(top,#ffb3b3 0,#ff9999 100%);
	background: -o-linear-gradient(top,#ffb3b3 0,#ff9999 100%);
	background: linear-gradient(to bottom,#ffb3b3 0,#ff9999 100%);
	filter: progid:DXImageTransform.Microsoft.gradient(startColorstr=#ffb3b3,endColorstr=#ff9999,GradientType=0);
}
a.c3:hover{
	background: #ff9999;
	filter: none;
}
    </style>
</head>
<body style=" overflow:hidden"> 
	<div id="layout1">
       
        <div position="center" >
         <div id="toolBar"></div>
          <OBJECT CLASSID = "clsid:5220cb21-c88d-11cf-b347-00aa00a28331" VIEWASTEXT>
         <PARAM NAME="LPKPath" VALUE="../lpk/flexCell.LPK">
      </OBJECT> 

      <OBJECT  ID="Grid1"    CLASSID="clsid:4331220A-1077-4630-BEE3-0D7142D6ABD0"  onkeydown="auditGridManager.Grid_KeyDown" width="100%" height="96%">
           <PARAM NAME="_ExtentX" VALUE="0">
         <PARAM NAME="_ExtentY" VALUE="0">

      </OBJECT>
		</div>

	    <div position="right" title="表格设置" id="layout2">		    
            <div id="navtab1" >
               <div title="疑点摘要" tabid="property"></div>
            </div>
                <div id="property"   style="height: 100%;width:100%">
                    <div id="problemGridToobar"></div>
                <div id ="problemEditToobar"  style=" display:none;"></div>
                    <table class="table" id="problemIf" style="display:none" >
                        <tr><td>疑点类别</td><td><input id="problemCategory" type="text" /></td></tr>
                        <tr style="height: 40px;"><td>疑点等级</td><td><input id="problemRank" type="text" /></td></tr>
                        <tr style="height: 30px;"><td>其他</td><td>&nbsp;&nbsp;&nbsp;&nbsp;<input id="isOrNotCell" type="checkbox" />&nbsp;标注单元格</td></tr>
                        <tr><td>疑点标题</td><td><input type="text" id="problemTitle" /></td></tr>                      
                        <tr style="height: 60px;"><td>疑点依据</td><td><input type="text" id="problemDepend" /></td></tr>                                            
                        <tr style="height: 140px;"><td>疑点内容</td><td><textarea id="problemContent"></textarea></td></tr>
                        <%--<tr><td colspan="2" style=" height:50px; text-align:center"><div>
			    <a href="#" class="easyui-linkbutton l-btn l-btn-small easyui-fluid c4" iconcls="icon-ok" style=" height: 30px;" group="" id="okBtn"><span class="l-btn-left l-btn-icon-left" style="margin-top: 3px;"><span class="l-btn-text">创建疑点</span><span class="l-btn-icon icon-ok">&nbsp;</span></span></a>
                <a href="#" class="easyui-linkbutton l-btn l-btn-small easyui-fluid c4" iconcls="icon-edit" style=" height: 30px;" group="" id="editBtn"><span class="l-btn-left l-btn-icon-left" style="margin-top: 3px;"><span class="l-btn-text">修改疑点</span><span class="l-btn-icon icon-edit">&nbsp;</span></span></a>
                <a href="#" class="easyui-linkbutton l-btn l-btn-small easyui-fluid c3" iconcls="icon-delete" style=" height: 30px;" group="" id="delBtn"><span class="l-btn-left l-btn-icon-left" style="margin-top: 3px;"><span class="l-btn-text">删除疑点</span><span class="l-btn-icon icon-cut">&nbsp;</span></span></a>
		                </div></td></tr>--%>
                    </table>
                    <div class="l-layout-header" style="border-top: 1px solid #95B8E7;">疑点列表</div>
                    <div id="problemsList" ></div>
                </div> 
                 <div id="relatedInf"   style="height: 100%">
                    <div class="l-layout-header" id="IndexRelations_header">相关指标</div>
                    <iframe id="IndexRelations"  frameborder="0" style="overflow:hidden;height:200px;width:100%"></iframe>
                    <div class="l-layout-header" id="IndexConclusion_header" style="border-top: 1px solid #95B8E7;" onclick="">相关结论</div>
                    <div style=" text-align:center;padding:20px; overflow-y:auto;overflow-x:hidden" id="IndexConclusion">
                    <textarea  id="editBox" style=" width:420px; height:220px"></textarea>
                    </br>
			        <a href="#" class="easyui-linkbutton l-btn l-btn-small easyui-fluid c4" iconcls="icon-save" style=" height: 30px;float:right; margin-right:15px" id="saveBtn"><span class="l-btn-left l-btn-icon-left" style="margin-top: 3px;"><span class="l-btn-text">保存</span><span class="l-btn-icon icon-save">&nbsp;</span></span></a>
                    </div>
		        </div>
                <div id="IndexJoinInf"   style="height: 100%">
                    <div class="l-layout-header" id="IndexTrend_header" >指标趋势</div>
                    <iframe id="IndexTrend"  frameborder="0" style="overflow:hidden;height:250px; width:100%; border-bottom: 1px solid #95B8E7;" onload="CommunicationManager.Right_Control.LoadIndexTrend()"></iframe>
                    <div class="l-layout-header" id="IndexConstitution_header" >指标构成</div>
                    <iframe id="IndexConstitution"  frameborder="0" style="overflow:hidden; width:100%"></iframe>
                </div>
                <div id="JoinInf" style="height:100%">
                    <div class="l-layout-header" >报表联查</div>
                    <iframe id="ReportJoin"  frameborder="0" style=" width:100%;overflow:hidden;"onload="CommunicationManager.Right_Control.setFrameData('ReportJoin')"  ></iframe>
                <div id="CustomerJoin" style="width:100%;">
                        <div class="l-layout-header" id="CustomerJoin_header" onclick="">自定义联查</div>
                        <div style=" text-align:center;  background-color:#fafafa; width:100%;">
                    <a href="#" class="easyui-linkbutton l-btn l-btn-small easyui-fluid " style=" height: 33px; margin:5px 0px 5px 10px; width:60%" group="" id="JoinBtn"><span class="l-btn-left l-btn-icon-left" style="margin-top: 3px;"><span class="l-btn-text" style="font-size:13px">  自 定 义 报 表 联 查 ...</span><span class="l-btn-icon icon-search">&nbsp;</span></span></a>
                        </div>
                    </div>
                </div>               
	    </div>		
	</div>
</body>
</html>
