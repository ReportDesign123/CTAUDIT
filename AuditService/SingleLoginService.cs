using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using AuditSPI;
using CtTool;
using DbManager;
using AuditEntity;
using GlobalConst;


namespace AuditService
{
    public class SingleLoginService
    {
       LinqDataManager linqDbManager;
       CTDbManager dbManager;
       public SingleLoginService()
       {
           if (linqDbManager == null)
           {
               linqDbManager = new LinqDataManager();
           }
           if (dbManager == null)
           {
               dbManager = new CTDbManager();
           }
       }
       public void GetEntity(ref SingleLoginEntity entity, string AuditTypeCode,string AuditTaskCode,string AuditPaperCode,string AuditReport)
       {
           string result = string.Empty;
           string sql = string.Empty;
           try
           {
               result = GetValue("RWLX", AuditTypeCode);
               if(!string.IsNullOrEmpty(result))
               {
                   entity.AuditTypeValue = result.Split(',')[0];
                   entity.AuditTypeName = result.Split(',')[1];
               }
               sql = string.Format("select AUDITTASK_ID,AUDITTASK_Name from CT_TASK_AUDITTASK where (AUDITTASK_Code='{0}'  or AUDITTASK_id='{0}')", AuditTaskCode);

               DataTable table = dbManager.ExecuteSqlReturnDataTable(sql);

               if (table != null && table.Rows.Count > 0)
               {
                   entity.AuditTaskValue = table.Rows[0][0].ToString();
                   entity.AuditTaskName = table.Rows[0][1].ToString();
               }

               sql = string.Format("select AUDITPAPER_ID,AUDITPAPER_Name from CT_PAPER_AUDITPAPER where (AUDITPAPER_Code='{0}' or AUDITPAPER_ID='{0}')", AuditPaperCode);
               table = dbManager.ExecuteSqlReturnDataTable(sql);

               if (table != null && table.Rows.Count > 0)
               {
                   entity.AuditPaperValue = table.Rows[0][0].ToString();
                   entity.AuditPaperName = table.Rows[0][1].ToString();
               }
               if (!string.IsNullOrEmpty(AuditReport))
               {
                   sql = string.Format("select REPORTDICTIONARY_ID from CT_FORMAT_REPORTDICTIONARY where REPORTDICTIONARY_Code='{0}'", AuditReport);
                   table = dbManager.ExecuteSqlReturnDataTable(sql);
                   if (table != null && table.Rows.Count > 0)
                   {
                       entity.AuditReport = table.Rows[0][0].ToString();
                       
                   }

               }
           }
           catch (Exception ex)
           {
               throw ex;
           }
       
       }

       private string GetValue(string LX,string Code)
       {
           string Result = string.Empty;
           string sql = string.Empty;
           try
           {
               sql = string.Format("select D.DICTIONARY_ID,D.DICTIONARY_Name from  CT_BASIC_DICTIONARY D INNER JOIN CT_BASIC_DICTIONARYCLASSIFICATION C ON D.DICTIONARY_CLASSID=C.DICTIONARYCLASSIFICATION_ID  AND C.DICTIONARYCLASSIFICATION_CODE='{0}' where  D.DICTIONARY_CODE='{1}'", LX, Code);
               DataTable table = dbManager.ExecuteSqlReturnDataTable(sql);
               if (table == null || table.Rows.Count == 0)
                   return Result;
               Result = table.Rows[0][0].ToString() + "," + table.Rows[0][1].ToString();

           }
           catch (Exception ex)
           {
               throw ex;
           }
           return Result;
       }
    }
}
