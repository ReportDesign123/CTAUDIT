<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="JumpReportMang.aspx.cs" Inherits="Audit.JumpReportMang" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>

    <script src="lib/jquery/jquery-1.5.2.min.js" type="text/javascript"></script>
    <script src="Scripts/AjaxTrigger.js" type="text/javascript"></script>
    <script src="Scripts/FunctionMethodManager.js" type="text/javascript"></script> 
    <script src="lib/Cookie/jquery.cookie.js" type="text/javascript"></script>
    <script src="Scripts/Cookie/Cookie.js" type="text/javascript"></script>
     <script src="lib/json2.js" type="text/javascript"></script>
    <script type="text/javascript">
        var currentState = { AuditType: { name: "", value: "" }, AuditDate: "", AuditTask: { name: "", value: "" }, AuditPaper: { name: "", value: "" }, auditZqVisible: "0", auditPaperVisible: "0", auditZqType: "01", Nd: "", Zq: "", WeekReport: { ID: "", Name: "", Ksrq: "", Jsrq: ""} };
        var paraUrl = { ReportId: "", CompanyId:"", Cycle: "", Year: "", PaperId: "", TaskId: "" };
        var vsType = "0"; //默认打开填报管理界面
        var para = {};
        $(function () {

            if (GetQueryString("UserCode")) {
                var paraUser = {};
                paraUser["Code"] = GetQueryString("UserCode");
                para["AuditType"] = GetQueryString("AuditType");
                para["AuditTask"] = GetQueryString("AuditTask");
                para["AuditPaper"] = GetQueryString("AuditPaper");
                para["AuditCycle"] = GetQueryString("AuditCycle");
                para["AuditDate"] = GetQueryString("AuditDate");
                vsType = GetQueryString("Stype");
                para["Company"] = GetQueryString("Company");
                para["AuditReport"] = GetQueryString("Report");
                if (!vsType) {
                    vsType = "0";
                }
                
                paraUser = CreateParameter(BasicAction.ActionType.Post, BasicAction.Functions.UserManager, BasicAction.Methods.UserManagerMethods.SingleLogin, paraUser);
                DataManager.sendData("handler/BasicHandler.ashx", paraUser, resultManagers.success, resultManagers.fail, false);
            }
           
        });
        var resultManagers = {
            success: function (data) {
                if (data.success) {
                    if (para["AuditType"] && para["AuditType"] != "") {
                        para = CreateParameter(BasicAction.ActionType.Post, BasicAction.Functions.UserManager, BasicAction.Methods.UserManagerMethods.SingleData, para);
                        DataManager.sendData("handler/BasicHandler.ashx", para, resultDataManagers.success, resultDataManagers.fail, false);
                    }
                    else {
                        window.location.href = "/ct/ReportData/FillReport.aspx";
                    }
                } else {
                    
                }
            },
            fail: function (data) {
                if (data) {
                    //                    $("#spanM").text(data.sMeg);
                }
            }

        };
        var resultDataManagers = {
            success: function (data) {
                if (data.success) {
                    if (vsType == "0") {

                        currentState.AuditType.name = data.obj.AuditTypeName;
                        currentState.AuditType.value = data.obj.AuditTypeValue;

                        currentState.AuditTask.name = data.obj.AuditTaskName;
                        currentState.AuditTask.value = data.obj.AuditTaskValue;

                        currentState.AuditPaper.name = data.obj.AuditPaperName;
                        currentState.AuditPaper.value = data.obj.AuditPaperValue;

                        currentState.AuditDate = data.obj.AuditDate;
                        currentState.Nd = data.obj.AuditYear;
                        currentState.WeekReport.ID = data.obj.WeekRpId;
                        currentState.WeekReport.Name = data.obj.WeekRpName;
                        currentState.WeekReport.Ksrq = data.obj.WeekRpKsrq;
                        currentState.WeekReport.Jsrq = data.obj.WeekRpJsrq;
                        currentState.auditZqType = para["AuditCycle"];
                        currentState.Zq = data.obj.AuditZq;
                        currentState = JSON2.stringify(currentState);
                        // currentState = (encodeURI(currentState));
                        //   CookieDataManager.SetCookieData(ReportDataAction.Functions.FillReport, currentState);
                        window.location.href = "/ct/ReportData/FillReport.aspx?result=" + currentState;
                    }
                    else {
                        paraUrl.Cycle = data.obj.AuditZq;// para["AuditCycle"];
                        paraUrl.PaperId = data.obj.AuditPaperValue;
                        paraUrl.TaskId = data.obj.AuditTaskValue;
                        paraUrl.Year = data.obj.AuditYear;
                        paraUrl.CompanyId = para["Company"];
                        paraUrl.ReportId = data.obj.AuditReport;

                        paraUrl = JSON2.stringify(paraUrl);
                        paraUrl = encodeURI(paraUrl);

                        window.location.href = "/ct/ReportData/ReportAggregation/ReportDataCell.aspx?para=" + paraUrl;

                    }

                }
            },
            fail: function (data) {
                if (data) {
                    //                    $("#spanM").text(data.sMeg);
                }
            }

        };
        function GetQueryString(name) {
            var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
            var r = window.location.search.substr(1).match(reg);
            if (r != null) return (r[2]); return null;
        }
      </script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
    </div>
    </form>
</body>
</html>
