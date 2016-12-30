using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditSPI.Analysis;
using AuditEntity;
using AuditSPI.ReportData;
using AuditService.ReportData;
using DbManager;
using System.Data;
using GlobalConst;
using CtTool;

namespace AuditService.Analysis.Formular
{

    /// <summary>
    /// 科目余额函数解析
    /// kmtx:1;dwbh:0000;kjnd:<!BBND!>;kjqj:<!BBZQ!>;kmbh:1001,1002;dataType:ZWKMYE_NCYE,ZWKMYE_JFLJ,ZWKMYE_DFLJ
    /// </summary>
    class KmyeFormularAnalysis:IFormularDeserialize
    {
        ReportDataParameterStruct rdps = new ReportDataParameterStruct();
        CTDbManager dbManager;
        MacroHelp mh;
        public KmyeFormularAnalysis()
        {
            if (mh == null)
            {
                mh =new  MacroHelp();
            }
            if (dbManager == null)
            {
                dbManager = new CTDbManager();
            }
        }
        public System.Data.DataTable DeserializeToSql(AuditEntity.FormularEntity fe)
        {
            try
            {
                fe.content = mh.ReplaceMacroVariable(fe.content);
                DataTable dt = new DataTable();
                string[] parametersArr = fe.content.Split(';');
                StringBuilder sql = new StringBuilder();
                StringBuilder whereSql = new StringBuilder();
                sql.Append("SELECT ");
                whereSql.Append(" WHERE 1=1  ");
                if (ThirdPartConst.AccountType == "Inspur")
                {
                    foreach (string nameValue in parametersArr)
                    {
                        string[] nvs = nameValue.Split(':');
                        if (nvs[0] == "kmtx")
                        {
                            whereSql.Append(" AND ");
                            whereSql.Append(" ZWKMYE_WBBH='");
                            whereSql.Append(nvs[1]);
                            whereSql.Append("'");
                        } else if (nvs[0] == "dwbh")
                        {
                            whereSql.Append(" AND ");
                            whereSql.Append(" ZWKMYE_DWBH='");
                            whereSql.Append(nvs[1]);
                            whereSql.Append("'");
                        }
                        else if (nvs[0] == "kjnd")
                        {
                            whereSql.Append(" AND ");
                            whereSql.Append(" ZWKMYE_KJND='");
                            whereSql.Append(nvs[1]);
                            whereSql.Append("'");
                        }
                        else if (nvs[0] == "kjqj")
                        {
                            whereSql.Append(" AND ");
                            whereSql.Append(" ZWKMYE_KJQJ='");
                            whereSql.Append(nvs[1]);
                            whereSql.Append("'");
                        }
                        else if (nvs[0] == "kmbh")
                        {
                            whereSql.Append(" AND ");
                            whereSql.Append(" ZWKMYE_KMBH IN (");
                            whereSql.Append(StringUtil.ConvertStringToInSql( nvs[1]));
                            whereSql.Append(")");
                        }
                        else if (nvs[0] == "dataType")
                        {                  
                            sql.Append(nvs[1]);
                        }
                    }
                    sql.Append(" FROM ");
                    sql.Append(" ZWKMYE" + rdps.Year);
                    string allSql = sql.ToString() + whereSql.ToString();
                    DbDataSourceInstance dsi = DBTool.GetDataSource(fe.FormularDb, dbManager);
                    dt = dsi.ExecuteSqlReturnDataTable(allSql);
                  
                }
                return dt;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void SetReportParameters(AuditSPI.ReportData.ReportDataParameterStruct rdps)
        {
            try
            {
                this.rdps = rdps;
                mh.ReportParameter = rdps;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
