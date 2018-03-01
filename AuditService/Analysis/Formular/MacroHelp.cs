using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Data;
using AuditService;
using AuditEntity;
using DbManager;
using GlobalConst;
using CtTool;
using AuditSPI.ReportData;

namespace AuditService.Analysis.Formular
{
    public  class MacroHelp
    {
        DictionaryService dicService;
        public MacroHelp()
        {
            if (dicService == null)
            {
                dicService = new DictionaryService();
            }
           
        }
        public ReportDataParameterStruct ReportParameter
        {
            get;
            set;
        }
        public string ReplaceMacroVariable(string source)
        {
            try
            {               
                List<DictionaryEntity> dics = dicService.GetDictionaryListByClassType(BasicGlobalConst.MacroType);
                Dictionary<string, string> nameValues = new Dictionary<string, string>();
                foreach (DictionaryEntity de in dics)
                {
                    nameValues.Add(de.Code, de.Name);
                }
                //正则表达式替换
                string temp=source;
                while (temp.IndexOf("<!") != -1)
                {
                    int startIndex = temp.IndexOf("<!");
                    int endIndex = temp.IndexOf("!>", startIndex);
                    string startStr = temp.Substring(0, startIndex);
                    string endStr = temp.Substring(endIndex + 2);
                    string middleStr = "";
                    string macroVariable = temp.Substring(startIndex + 2, endIndex - startIndex - 2);
                    middleStr= GetSystemMacro(macroVariable);
                    if (middleStr == "")
                        middleStr = GetCusMacro(macroVariable);
                    temp = startStr + middleStr + endStr;
                }

                return temp;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public string GetSystemMacro(string macroVariable)
        {
            string middleStr = "";
            switch (macroVariable)
            {
                case "CURUSER":
                    middleStr = SessoinUtil.GetCurrentUser().Id;
                    break;
                case "CURDW":
                    middleStr = SessoinUtil.GetCurrentCompanyId();
                    break;
                case "CURDWMC":
                    middleStr = SessoinUtil.GetCurrentCompanyName();
                    break;
                case "CURRQ":
                    middleStr = SessoinUtil.GetCurrentDateTime();
                    break;
                case "CURUNAME":
                    middleStr = SessoinUtil.GetCurrentUser().Name;
                    break;

                case "SYSYEAR":
                    middleStr = SessoinUtil.GetSystemYear();
                    break;
                case "SYSMONTH":
                    middleStr = SessoinUtil.GetSystemMonth();
                    break;
                case "SYSDAY":
                    middleStr = SessoinUtil.GetSystemDay();
                    break;
                case "SYSDATE":
                    middleStr = SessoinUtil.GetSystemDate();
                    break;
            }
            if (ReportParameter != null)
            {
                switch (macroVariable)
                {
                    case "BBDWMC":
                        CompanyEntity ce = new CompanyEntity();
                        CompanyService cs = new CompanyService();
                        ce.Id = ReportParameter.CompanyId;
                        ce = cs.get(ce);
                        middleStr = "单位名称：" + ce.Name;
                        break;
                    case "BBDWMCNO":
                        CompanyEntity ce3 = new CompanyEntity();
                        CompanyService cs3 = new CompanyService();
                        ce3.Id = ReportParameter.CompanyId;
                        ce3 = cs3.get(ce3);
                        middleStr = ce3.Name;
                        break;
                    case "BBDWID":
                        middleStr = ReportParameter.CompanyId;
                        break;
                    case "BBND":
                        middleStr = ReportParameter.Year;
                        break;
                    case "TASKID":
                        middleStr = ReportParameter.TaskId;//add by luch
                        break;
                    case "PAPERID":
                        middleStr = ReportParameter.PaperId;//add by luch
                        break;
                    case "REPORTID":
                        middleStr = ReportParameter.ReportId;//add by luch
                        break;
                    case "ZBID":
                        middleStr = ReportParameter.WeekReportID;
                        break;
                    case "ZBZQMC":
                        middleStr = ReportParameter.WeekReportName;
                        break;
                    case "ZBKSRQ":
                        middleStr = ReportParameter.WeekReportKsrq;
                        break;
                    case "ZBJSRQ":
                        middleStr = ReportParameter.WeekReportJsrq;
                        break;
                    case "BBZQ":
                        middleStr = ReportParameter.Cycle;
                        break;
                    case "BBDWBH":
                        CompanyEntity ce2 = new CompanyEntity();
                        CompanyService cs2 = new CompanyService();
                        ce2.Id = ReportParameter.CompanyId;
                        ce2 = cs2.get(ce2);
                        if(ce2!=null)
                         middleStr = ce2.Code;
                        break;

                    case "CWYYYY":
                        middleStr = ReportParameter.Year;
                        break;
                    case "CWMM":
                        middleStr = ReportParameter.Cycle;
                        break;
                    case "CWJD":
                        middleStr = ReportParameter.Cycle;
                        break;
                    case "CWLASTDD":
                        middleStr = SessoinUtil.GetCwMmLastDay(ReportParameter.Year, ReportParameter.Cycle);
                        break;
                    case "CWLAMMDATE":
                        middleStr = SessoinUtil.GetCwLastMMDate(ReportParameter.Year, ReportParameter.Cycle);
                        break;

                }
            }
            return middleStr;
        }
        /// <summary>
        /// 得到自定义参数
        /// </summary>
        /// <param name="macroVariable"></param>
        /// <returns></returns>
        public string GetCusMacro(string macroVariable)
        {
            string middleStr = "";
            string sql = string.Empty;
            CTDbManager dbManager = new CTDbManager();
            sql = "select  CPARA_CONTENT,CPARA_SPARA from CT_BASIC_CPARA where CPARA_CODE='" + macroVariable+"'";
            DataTable temp = dbManager.ExecuteSqlReturnDataTable(sql);
            if (temp != null && temp.Rows.Count > 0)
            {
                string strCon = temp.Rows[0][0].ToString();
                string strSpar = temp.Rows[0][1].ToString();
                string strReSpar = string.Empty;
                foreach (string item in strSpar.Split(','))
                {
                    strReSpar += GetSystemMacro(item) + ",";
                }
                strReSpar = strReSpar.Substring(0, strReSpar.Length - 1);
                sql = string.Format(strCon, strReSpar);

                DataTable table = dbManager.ExecuteSqlReturnDataTable(sql);
                if (table != null && table.Rows.Count > 0)
                    middleStr = table.Rows[0][0].ToString();
            }
            return middleStr;
        }

        public string ReplaceMacroVariable(string source, string userId, string companyId)
        {
            try
            {
                List<DictionaryEntity> dics = dicService.GetDictionaryListByClassType(BasicGlobalConst.MacroType);
                Dictionary<string, string> nameValues = new Dictionary<string, string>();
                UserEntity ue = new UserEntity();
                CompanyEntity ce = new CompanyEntity();
                
                if (!StringUtil.IsNullOrEmpty(userId))
                {
                    UserService us = new UserService();
                    ue.Id = userId;
                    ue = us.Get(ue);
                }else{
                    ue=SessoinUtil.GetCurrentUser();
                    if (StringUtil.IsNullOrEmpty(companyId))
                    {
                        companyId=ue.OrgnizationId;
                    }
                    
                }
                if (!StringUtil.IsNullOrEmpty(companyId))
                {
                    CompanyService cs = new CompanyService();
                    ce.Id = companyId;
                    ce = cs.get(ce);
                }
                foreach (DictionaryEntity de in dics)
                {
                    nameValues.Add(de.Code, de.Name);
                }
                //正则表达式替换
                string temp = source;
                while (temp.IndexOf("<!") != -1)
                {
                    int startIndex = temp.IndexOf("<!");
                    int endIndex = temp.IndexOf("!>", startIndex);
                    string startStr = temp.Substring(0, startIndex);
                    string endStr = temp.Substring(endIndex + 2);
                    string middleStr = "";
                    string macroVariable = temp.Substring(startIndex + 2, endIndex - startIndex - 2);
                    switch (macroVariable)
                    {
                        case "CURUSER":
                            middleStr =ue.Id;
                            break;
                        case "CURDW":
                            middleStr = ce.Id;
                            break;
                        case "CURDWMC":
                            middleStr = ce.Name;
                            break;
                        case "CURRQ":
                            middleStr = SessoinUtil.GetCurrentDateTime();
                            break;
                        case "CURUNAME":
                            middleStr = ue.Name;
                            break;
                    }
                    temp = startStr + middleStr + endStr;
                }

                return temp;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        public string ReplaceYYYYMM(string source)
        {
            try
            {
                string result = source;
                result = result.Replace("@YYYY", SessoinUtil.GetSystemYear());
                result = result.Replace("@MM", SessoinUtil.GetSystemMonth());
                return result;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }

}
