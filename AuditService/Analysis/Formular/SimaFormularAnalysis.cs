using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using AuditSPI.Analysis;
using DbManager;
using CtTool;
using AuditEntity;
using AuditSPI;
using AuditSPI.ReportData;


namespace AuditService.Analysis.Formular
{
   public  class SimaFormularAnalysis:IFormularDeserialize
    {
       CTDbManager dbManager;
       MacroHelp mh;
       ReportDataParameterStruct rdps = new ReportDataParameterStruct();
       public SimaFormularAnalysis()
       {
           if (dbManager == null)
           {
               dbManager = new CTDbManager();
           }
           if (mh == null)
           {
               mh =new  MacroHelp();
           }
       }
        //SIMA(@GS2000@.ZCFZ)
       public DataTable DeserializeToSql(FormularEntity fe)
        {
            try
            {
                DataTable dt = new DataTable();
                string SimaId = fe.content;
                string tableName="";
                string condition = " WHERE 1=1 ";
                string orderSql = "";
                string groupSql = "";
                string selectSql = "";

                string sql = "SELECT * FROM RPSIMA WHERE SIMA_OBJID='"+SimaId+"'";               
               dt = dbManager.ExecuteSqlReturnDataTable(sql);
                if (dt != null && dt.Rows.Count > 0)
                {
                    DataRow dr=dt.Rows[0];
                    tableName =Convert.ToString(dr["SIMA_TABN"]);
                   

                    if(!StringUtil.IsNullOrEmpty(dr["SIMA_CONDI1"])){
                        condition += " AND " + mh.ReplaceMacroVariable( Convert.ToString(dr["SIMA_CONDI1"]));
                    }

                    if (!StringUtil.IsNullOrEmpty(dr["SIMA_SORT"]))
                    {
                        orderSql =" "+ Convert.ToString(dr["SIMA_SORT"]);
                    }

                    if (!StringUtil.IsNullOrEmpty(dr["SIMA_GROUP"]))
                    {
                        groupSql =" "+ Convert.ToString(dr["SIMA_GROUP"]);
                    }

                }

                sql = "SELECT * FROM RPSOBJ WHERE SOBJ_OBJID='"+SimaId+"'";
                dt = dbManager.ExecuteSqlReturnDataTable(sql);
                foreach (DataRow row in dt.Rows)
                { 

                    if (!StringUtil.IsNullOrEmpty(row["SOBJ_HELPCONDI"]))
                    {
                        selectSql += Convert.ToString(row["SOBJ_FIELD1"])+",";
                    }
                }

                if (selectSql == "") return dt;
                selectSql = selectSql.Substring(0, selectSql.Length - 1);
                StringBuilder sb = new StringBuilder();
                sb.Append("SELECT ");
                sb.Append(selectSql);
                sb.Append(" FROM ");
                sb.Append(tableName);
                sb.Append(condition);
                if (groupSql.Trim() != "")
                {
                    sb.Append(" GROUP BY ");
                    sb.Append(groupSql);
                }
                if (orderSql.Trim() != "")
                {
                    sb.Append(" ORDER BY ");
                    sb.Append(orderSql);
                }
                DbDataSourceInstance ddsi = DBTool.GetDataSource(fe.FormularDb, dbManager);
                string rsql = sb.ToString();
                rsql = mh.ReplaceYYYYMM(rsql);
                dt = ddsi.ExecuteSqlReturnDataTable(rsql);
                return dt;

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


       public void SetReportParameters(ReportDataParameterStruct rdps)
       {
           this.rdps = rdps;
           mh.ReportParameter = rdps;
       }
    }
}
