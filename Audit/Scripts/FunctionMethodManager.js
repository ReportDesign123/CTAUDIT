/// <reference path="../lib/jquery/jquery-1.11.1.min.js" />

var BasicAction = {
    Functions: { FunctionsMenu: "FunctionsMenu",
        RoleMenu: "Role",
        UserManager: "UserManager",
        DictionaryManager: "DictionaryManager",
        CycleManager: "CycleManager",
        CparasManager: "CparasManager",
        CompanyManager: "CompanyManager",
        PositionManager: "PositionManager",
        Sima: "SIMA",
        Procedure: "PROCEDURE",
        DataSource: "DataSource",
        System: "System",
        AccountBalance: "AccountBalance",
        Authority: "Authority",
        BackUpAction: "BackUpAction"
    },
    Methods: { FunctionsMenuMethods: { Save: "Save", Update: "Update", Delete: "Delete" },
        CparasManagerMethods1: { DataGrid: "DataGrid", Save: "Save", Edit: "Edit", Delete: "Delete",GetParaList: "GetParaList" },
        RoleMenuMethods: { DataGrid: "DataGrid", Save: "Save", Edit: "Edit", Delete: "Delete", GetRoleFunctions: "GetRoleFunctions", BatchUpdate: "BatchUpdate" },
        UserManagerMethods: { DataGrid: "DataGrid", Save: "Save", Edit: "Edit", Delete: "Delete", RoleCombox: "RoleCombox", Login: "Login", SingleLogin: "SingleLogin",SingleData: "SingleData", LoginOut: "LoginOut", GetCurrentUserInfo: "GetCurrentUserInfo", SaveNewPassWord: "SaveNewPassWord" },
        DicManagerMethods: { GetDicClassifyList: "GetDicClassifyList", SaveDictionaryClassify: "SaveDictionaryClassify", UpdateDictionaryClassify: "UpdateDictionaryClassify", DeleteDictionaryClassify: "DeleteDictionaryClassify",
            GetDictionaryClassify: "GetDictionaryClassify", GetDictionaryList: "GetDictionaryList", SaveDictionary: "SaveDictionary", UpdateDictionary: "UpdateDictionary", DeleteDictionary: "DeleteDictionary", GetDictionary: "GetDictionary",
            GetDicClassifyCombo: "GetDicClassifyCombo", GetDictionaryListByClass: "GetDictionaryListByClass", GetDictionaryListByClassType: "GetDictionaryListByClassType",
            GetDictionaryDataGridByClassType: "GetDictionaryDataGridByClassType", GetDicClassifyDataGridFilter: "GetDicClassifyDataGridFilter", GetParasList: "GetParasList"
        },
        CycManagerMethods: { GetCycleList: "GetCycleList", SaveCycle: "SaveCycle", UpdateCycle: "UpdateCycle", DeleteCycle: "DeleteCycle", GetCycle: "GetCycle", GetCycleInfor: "GetCycleInfor"},
        CparasManagerMethods: { DataGrid: "DataGrid",Save: "Save", Edit: "Edit", Delete: "Delete", GetParaList: "GetParaList" },
        CompanyManagerMethods: { GetCompanyList: "GetCompanyList", Save: "Save", Edit: "Edit", Delete: "Delete", ParentCombo: "ParentCombo", CompanyDataGrid: "CompanyDataGrid", GetCompanisAuthority: "GetCompanisAuthority" },
        PositionManagerMethods: { GetPositionList: "GetPositionList", Save: "Save", Edit: "Edit", Delete: "Delete", ParentCombo: "ParentCombo", WorkFlowCombo: "WorkFlowCombo", GetPositionDataGrid: "GetPositionDataGrid" },
        SimaMethods: { GetDataGrid: "GetDataGrid" },
        ProcedureMethods: { GetProcedureDataGrid: "GetProcedureDataGrid", GetParametersByProcedure: "GetParametersByProcedure",
            DataGridProcedureFormularEntities: "DataGridProcedureFormularEntities", AddProcedureFormularEntity: "AddProcedureFormularEntity", EditProcedureFormularEntity: "EditProcedureFormularEntity",
            DeleteProcedureFormularEntity: "DeleteProcedureFormularEntity", DataGridParameters: "DataGridParameters"
        },
        DataSourceMethods: { Save: "Save", Edit: "Edit", Delete: "Delete", DataSourceInstances: "DataSourceInstances", TestDataSource: "TestDataSource", DataGrid: "DataGrid", SetDefault: "SetDefault" },
        SystemMethods: { Edit: "Edit", DataGrid: "DataGrid", GetWorkFlows: "GetWorkFlows", LogDataGrid: "LogDataGrid", DownLoadPlug: "DownLoadPlug", GetSequenceNumber: "GetSequenceNumber", Register: "Register" },
        AccountBalanceMethods: { AccountSubjectsDataGrid: "AccountSubjectsDataGrid" },
        AuthorityMethods: { SaveAndEditFillReportAuthority: "SaveAndEditFillReportAuthority", GetFillReportAuthoriy: "GetFillReportAuthoriy", GetFillReportAuthorityCompaniesByUser: "GetFillReportAuthorityCompaniesByUser", SaveAndEditAuditAuthority: "SaveAndEditAuditAuthority", GetAuditAuthority: "GetAuditAuthority", GetAuditAuthorityCompaniesByUser: "GetAuditAuthorityCompaniesByUser" },
        BackUpMethods: {GetBackUpDataGrid: "GetBackUpDataGrid", BackUp: "BackUp", RestoreData: "RestoreData" }
    },
    ActionType: { Get: "get", Post: "post", Grid: "grid" }
};

var ReportFormatAction = {
    Functions: { ReportFormatMenu: "ReportFormatMenu", FormularMenu: "FormularMenu", ReportLinkAction: "ReportLinkAction" },
    Methods: { ReportFormatMenuMethods: { Save: "Save1", LoadReportFormat: "LoadReportFormat", LoadComReportFormat: "LoadComReportFormat", DeleteReports: "DeleteReports", ReportDataGrid: "ReportDataGrid" },
        FormularMenuMethods: { DataGrid: "DataGrid", Save: "Save", GetDataSourceList: "GetDataSourceList", GetAuditPapersByTaskId: "GetAuditPapersByTaskId", GetDataGridByTaskCode: "GetDataGridByTaskCode", GetReportsByPaperCode: "GetReportsByPaperCode"},
        ReportLinkMethods: { GetReportLinkList: "GetReportLinkList", SaveReportLink: "SaveReportLink", DeleteReportLink: "DeleteReportLink" }
    },
    ActionType: { Get: "get", Post: "post", Grid: "grid" }
};
var ReporClassifyAction = {
    Functions: { ReportClassify: "ReportClassify" },
    Methods: { ReportClassifyMethods: { AddClassifyEntity: "AddClassifyEntity", EditClassifyEntity: "EditClassifyEntity", DeleteClassifyEntity: "DeleteClassifyEntity", GetClassifyEntity: "GetClassifyEntity", GetReportsByClassify: "GetReportsByClassify", GetUnClassifyReports: "GetUnClassifyReports", GetClassifiesList: "GetClassifiesList", SaveReports: "SaveReports" }
    },
    ActionType: { Get: "get", Post: "post", Grid: "grid" }
};

var AuditPaperAction = {
    Functions: { AuditPaperMenu: "AuditPaperMenu", AuditPaperManagerMenu: "AuditPaperManagerMenu" },
    Methods: { AuditPaperMenuMethods: { Save: "Save", Edit: "Edit", Delete: "Delete", getDataGrid: "getDataGrid" },
        AuditPaperManagerMenu: { Save: "Save", Edit: "Edit", Delete: "Delete", getDataGrid: "getDataGrid", TreeNodesAuditPaperAuthorities: "TreeNodesAuditPaperAuthorities", BatchUpdate: "BatchUpdate", GetAuditPaperLists: "GetAuditPaperLists", GetAuditPaperReportList: "GetAuditPaperReportList", BatchUpdataReports: "BatchUpdataReports" }
    },
    ActionType: { Get: "get", Post: "post", Grid: "grid" }
};

var AuditTaskAction = {
    Functions: { AuditTaskManager: "AuditTaskManager" },
    Methods: { AuditTaskManagerMethods: { GetDataGrid: "GetDataGrid", Save: "Save", Edit: "Edit", Delete: "Delete", TreeNodesAuditTaskAuthorities: "TreeNodesAuditTaskAuthorities", BatchUpdate: "BatchUpdate", GetAuditTaskLists: "GetAuditTaskLists", GetAuditTaskAuditPapers: "GetAuditTaskAuditPapers", BatchUpdataTaskAndPaper: "BatchUpdataTaskAndPaper"} },
    ActionType: { Get: "get", Post: "post", Grid: "grid" }
};
var ReportDataAction = {
    Functions: { FillReport: "FillReport", ReportAggregation: "ReportAggregation", BatchProcessCooike: "BatchProcessCooike", ReportReadWriteLockAction: "ReportReadWriteLockAction", ReportStateAggregation: "ReportStateAggregation"},
    Methods: { FillReportMethods: { GetAuditTasksDataGrid: "GetAuditTasksDataGrid", GetAuditPapersAndReports: "GetAuditPapersAndReports"
        , GetCompaniesByAuditPaperAndAuthority: "GetCompaniesByAuditPaperAndAuthority", GetReportCycle: "GetReportCycle", LoadReportDatas: "LoadReportDatas", SaveReportDatas: "SaveReportDatas", DeleteBdqData: "DeleteBdqData",
        DeserializeFatchFormular: "DeserializeFatchFormular", DeserializeCaculateFormular: "DeserializeCaculateFormular", DeserializeVarifyFormular: "DeserializeVarifyFormular", SelfCheck: "SelfCheck", CancelSelfCheck: "CancelSelfCheck",
        GetReportExamReportStateDataGrid: "GetReportExamReportStateDataGrid", ExamReportState: "ExamReportState", GetExamReportHistoryGrid: "GetExamReportHistoryGrid", CancelExamedReportState: "CancelExamedReportState", GetAllReportsStateDataGrid: "GetAllReportsStateDataGrid",
        ReportExamineWorkFlowPublish: "ReportExamineWorkFlowPublish", GetReportsByAuditPaper: "GetReportsByAuditPaper", GetReportFirstLoadStruct: "GetReportFirstLoadStruct", GetReportWithStateAndAttatch: "GetReportWithStateAndAttatch", ClearReportData: "ClearReportData",
        GetReportBatchProcessStruct: "GetReportBatchProcessStruct", BatchDeserializeFatchFormular: "BatchDeserializeFatchFormular", BatchDeserializeCaculateFormular: "BatchDeserializeCaculateFormular", BatchDeserializeVerifyFormular: "BatchDeserializeVerifyFormular", BatchDownLoadAttatches: "BatchDownLoadAttatches",
        RemoveReportReadWriteState: "RemoveReportReadWriteState", GetListVerifyProblemEntities: "GetListVerifyProblemEntities", GetReportCancelExamReportStateDataGrid: "GetReportCancelExamReportStateDataGrid", GetMyExamReportHistoryGrid: "GetMyExamReportHistoryGrid", GetExamAllHistoryGrid: "GetExamAllHistoryGrid",
        GetHigherExamReportStateDataGrid: "GetHigherExamReportStateDataGrid", GetHigherCancelReportStateDataGrid: "GetHigherCancelReportStateDataGrid", HigherCheck: "HigherCheck", CancelHigherCheck: "CancelHigherCheck"
        },
        ReportAggregationMethods: { ReportAggregation: "ReportAggregation", GetAuthorityCompanies: "GetAuthorityCompanies", GetAuditPaperDataGrid: "GetAuditPaperDataGrid", GetReportFormatStructsByAuditPaper: "GetReportFormatStructsByAuditPaper",SaveAggregationTemplateClassify:"SaveAggregationTemplateClassify",
            UpdateAggregationTemplateClassify: "UpdateAggregationTemplateClassify", DeleteAggregationTemplateClassify: "DeleteAggregationTemplateClassify", GetAggregationClassifys: "GetAggregationClassifys", SaveAggregationTemplate: "SaveAggregationTemplate", UpdateAggregationTemplate: "UpdateAggregationTemplate",
            DeleteAggregationTemplate: "DeleteAggregationTemplate", GetAggregationTemplates: "GetAggregationTemplates", GetAggregationLogEnties: "GetAggregationLogEnties", GetPreAggregationLogEntity: "GetPreAggregationLogEntity", GetAggregationTemplate: "GetAggregationTemplate",GetReportData: "GetReportData",
            GetReportCellDataTrend: "GetReportCellDataTrend", GetAggregationReportCellConstitute: "GetAggregationReportCellConstitute", ExportAggregationCellConstitute: "ExportAggregationCellConstitute", GetReportAllDatas: "GetReportAllDatas"
        },
        ReportReadWriteLockMethods: { GetReportLockEntiesDataGrid: "GetReportLockEntiesDataGrid", RemoveLock: "RemoveLock", RemoveLocks: "RemoveLocks" },
        ReportStateAggregationMethods: { GetReportStateAggregation: "GetReportStateAggregation", GetReportStateAggregationCompanies: "GetReportStateAggregationCompanies", GetReportStateAggregationByCompany: "GetReportStateAggregationByCompany", ExportReportStateAggregationByCompanies: "ExportReportStateAggregationByCompanies",
            GetReportStateAggregationReports: "GetReportStateAggregationReports"
        }
    },
    ActionType: { Get: "get", Post: "post", Grid: "grid" }
};

var WorkFlowAction = {
    Functions: {     WorkFlow: "WorkFlow"},
    Methods: { WorkFlowMethods: { EditBusinessEntity: "EditBusinessEntity", DeleteBusinessEntity: "DeleteBusinessEntity", DataGridBusinessEntity: "DataGridBusinessEntity",AddBusinessEntity:"AddBusinessEntity",EditWorkFlowEntity:"EditWorkFlowEntity", DeleteWorkFlow: "DeleteWorkFlow", DataGridWorkFlow: "DataGridWorkFlow",AddWorkFlow:"AddWorkFlow"},
        GetWorkFlowDefinition: "GetWorkFlowDefinition"
    },
    ActionType: { Get: "get", Post: "post", Grid: "grid" }
};

var ReportAuditAction = {
    ActionType: { Get: "get", Post: "post", Grid: "grid" },
    Functions: { ReportAudit: "ReportAudit", ReportAuditManager: "ReportAuditManager", ReportAuditSequestration: "ReportAuditSequestration", ReportAuditFind: "ReportAuditFind", ReportAuditDefinition: "ReportAuditDefinition" },
    Methods: { ReportAuditMethods: { DataGridReportAuditEntity: "DataGridReportAuditEntity", GetReportAuditData: "GetReportAuditData", GetProblemsList: "GetProblemsList", AuditClose: "AuditClose", CancelAuditClose: "CancelAuditClose", ExportProblems: "ExportProblems", Update: "Update"
        , GetReportCellConclusionAndDiscription: "GetReportCellConclusionAndDiscription", SaveReportCellIndexConclusion: "SaveReportCellIndexConclusion", GetRelationsIndexesData: "GetRelationsIndexesData", GetIndexTrendChartData: "GetIndexTrendChartData", GetIndexConstitutionCellDefinitionData: "GetIndexConstitutionCellDefinitionData"
        , GetReportLikData: "GetReportLikData", GetCustomerReportLinkData: "GetCustomerReportLinkData"
    }, ReportAuditDefinitionMethods: { GetAuditDefinition: "GetAuditDefinition", SaveAuditDefinition: "SaveAuditDefinition" }
    }
};
var ReportProblemAvtion = {
    ActionType: { Get: "get", Post: "post", Grid: "grid" },
    Functions: { ReportProblem: "ReportProblem" },
    Methods: { ReportProblemMethods: { Add: "Add", Edit: "Edit", Delete: "Delete", DataGridReportProblemEntity: "DataGridReportProblemEntity" } }
};
var ExportAction = {
    ActionType: { Get: "get", Post: "post", Grid: "grid" },
    Functions: { ReportTemplate: "ReportTemplate", CreateReport: "CreateReport", ReportTempalteInstanceState: "ReportTempalteInstanceState" },
    Methods: { TemplateMethod: { GetReportTemplateDataGrid: "GetReportTemplateDataGrid", SaveReportTemplate: "SaveReportTemplate", EditReportTemplate: "EditReportTemplate", DeleteReportTemplate: "DeleteReportTemplate",
        UploadTemplate: "UploadTemplate", DownloadTemplate: "DownloadTemplate"
    }, RelevantMethod: { BatchUpdate: "BatchUpdate", TemplateAndCompanies: "TemplateAndCompanies"
    }, DesignMethod: { GetWordTemplateStruct: "GetWordTemplateStruct", SaveWordTemplateStruct: "SaveWordTemplateStruct"
    }, CreatReportMethod: { GetCreateTemplateData: "GetCreateTemplateData", GetReportTemplatesByCompanyId: "GetReportTemplatesByCompanyId", CreateReport: "CreateReport", GetCompaniesByAuthority: "GetCompaniesByAuthority", GetTemplateLogList: "GetTemplateLogList",
        DownloadReport: "DownloadReport", UploadReport: "UploadReport"
    }, ReportStateMethod: { GetExamReportDataGrid: "GetExamReportDataGrid", GetCancelExamReportDataGrid: "GetCancelExamReportDataGrid", ExamReportPass: "ExamReportPass", ExamReportFail: "ExamReportFail", CancelExamReport: "CancelExamReport",
       GetExamReportHistory: "GetExamReportHistory", ExamReportSeal: "ExamReportSeal", ExamReportCancelSeal: "ExamReportCancelSeal", GetSealReportDataGrid: "GetSealReportDataGrid", GetCancelSealReportDataGrid: "GetCancelSealReportDataGrid"
   }, reportMarkMethod: { GetBookmarkTemplateDataGrid: "GetBookmarkTemplateDataGrid", SaveBookmarkTemplate: "SaveBookmarkTemplate", DeleteBookmarkTemplate: "DeleteBookmarkTemplate", UpdateBookmarkTempalte: "UpdateBookmarkTempalte" }

    }
}
var ProblemTraceAction = {
    ActionType: { Get: "get", Post: "post", Grid: "grid" },
    Functions: { ProblemTraceAction: "ProblemTraceAction" },
    Methods: { ProblemManagerMethods: { DataGridReportProblemEntity: "DataGridReportProblemEntity", AddProblem: "AddProblem", EditProblem: "EditProblem", Delete: "Delete", AddReportProblemReturn: "AddReportProblemReturn", GetReportsByPaperId: "GetReportsByPaperId",
        publishProblem: "publishProblem", canclePublishProblem: "canclePublishProblem", AddReportProblemReturn: "AddReportProblemReturn", finishProblem: "finishProblem", cancelFinishProblem: "cancelFinishProblem"
    } }
};
Array.prototype.remove=function(dx) 
{ 
    if(isNaN(dx)||dx>this.length){return false;} 
    for(var i=0,n=0;i<this.length;i++) 
    { 
        if(this[i]!=this[dx]) 
        { 
            this[n++]=this[i] 
        } 
    } 
    this.length-=1
}

function CreateParameter(ActionType, FunctionName, MethodName, Parameters) {
    if (Parameters == null) {
        Parameters = {};
    }
    Parameters["ActionType"] = ActionType;
    Parameters["FunctionName"] = FunctionName;
    Parameters["MethodName"] = MethodName;
    return Parameters;
}
function CreateUrl(url, ActionType, FunctionName, MethodName, Parameters) {
    url += "?";
    url += "ActionType=" + ActionType;
    url += "&MethodName=" + MethodName;
    url += "&FunctionName=" + FunctionName;
    $.each(Parameters, function (name, value) {
        url += "&" + name + "=" + value;
    });
    return url;
}
function CreateGeneralUrl(url, parameters) {
    try {
        if (parameters) {
            url += "?";
            var after = "";
            $.each(parameters, function (name, value) {
                if (after == "") {
                    after = name + "=" + value;
                } else {
                    after += "&" + name + "=" + value;
                }

            });
            url += after;
        }
        return url;
        
    } catch (err) {
    alert(err.Message);
    }
}

function GetParameters() {
    var pos, str, para, parastr;
    para = {};
    var array =[];
    str = location.href;
    if(str.indexOf("?")!=-1){
    parastr = str.split("?")[1];   
        var arr = parastr.split("&");
        for (var i = 0; i < arr.length; i++) {
            para[arr[i].split("=")[0]] = arr[i].split("=")[1];
        }
    }
    
    return para;
}

function CopyArrayToArrayFilterDefined(from, to) {
    $.each(from, function (index, item) {
        if (item != undefined) {
            to[index] = item;
        }
    });
    return to;
}
function CaculateArrayLengthFilterUndefined(arr) {
    
    var length = 0;
    $.each(arr, function (index, item) {
        if (item != undefined) {
            length++;
        }
    });
    return length;
}