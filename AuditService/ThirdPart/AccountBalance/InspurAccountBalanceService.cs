using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditSPI.ThirdPart.AccountBalance;
using CtTool;
using DbManager;
using AuditSPI;

namespace AuditService.ThirdPart.AccountBalance
{
    
    /// <summary>
    /// 浪潮科目余额接口
    /// </summary>
   public   class InspurAccountBalanceService:IAccountBalance
    {
       CTDbManager dbManager;
       public InspurAccountBalanceService()
       {
           if (dbManager == null)
           {
               dbManager = new CTDbManager();
           }
       }
       /// <summary>
       /// 
       /// </summary>
       /// <param name="dataGrid"></param>
       /// <param name="ass"></param>
       /// <returns></returns>
        public AuditSPI.DataGrid<AccountSubjectStruct> AccountSubjectsDataGrid(AuditSPI.DataGrid<AccountSubjectStruct> dataGrid, AccountSubjectStruct ass)
        {
            try
            {
                DataGrid<AccountSubjectStruct> dg = new DataGrid<AccountSubjectStruct>();
                DbDataSourceInstance dbSource = DBTool.GetDataSource(ass.DataSourceId,dbManager);
                if (ass.Kjnd.IndexOf("<!") != -1)
                {
                    ass.Kjnd = SessoinUtil.GetSystemYear();
                }
                string sql = "SELECT ZWKMZD_KMBH,ZWKMZD_KMMC FROM ZWKMZD"+ass.Kjnd;
                string whereSql = "";
                if(!StringUtil.IsNullOrEmpty(ass.Kmbh)){
                    whereSql += " ZWKMZD_KMBH LIKE '%"+ass.Kmbh+"%' ";
                }
                if (!StringUtil.IsNullOrEmpty(ass.Kmmc))
                {
                    whereSql += " OR ZWKMZD_KMMC LIKE '%"+ass.Kmmc+"%'";
                }
                if (whereSql.Length > 0)
                {
                    whereSql = " WHERE " + whereSql;
                }
                sql = sql + whereSql;

                string countSql = "SELECT COUNT(*) FROM ZWKMZD" + ass.Kjnd;
                countSql = countSql + whereSql;
                Dictionary<string, string> maps = new Dictionary<string, string>();
                maps.Add("Kmbh", "ZWKMZD_KMBH");
                maps.Add("Kmmc", "ZWKMZD_KMMC");
                string sortName = maps[dataGrid.sort];
                dg.rows = dbSource.ExecuteSqlReturnTType<AccountSubjectStruct>(sql, dataGrid.page, dataGrid.pageNumber, sortName + " " + dataGrid.order, maps);
                dg.total = dbSource.Count(countSql);
                return dg;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }



}
