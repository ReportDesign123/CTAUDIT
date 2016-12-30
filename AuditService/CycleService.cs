using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditSPI;
using DbManager;
using CtTool;
using AuditEntity;

namespace AuditService
{
    public class CycleService : ICycleService
    {
       private ILinqDataManager ldManager;
       private IDbManager dbManager;
       public CycleService()
       {
           ldManager = new LinqDataManager();
           dbManager = new CTDbManager();
       }


        public void SaveCycle(AuditEntity.CycleEntity de)
        {
            try
            {
                ldManager.InsertEntity<CycleEntity>(de);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }



        public void UpdateCycle(AuditEntity.CycleEntity de)
        {
            try
            {
                CycleEntity temp = GetCycle(de);
                BeanUtil.CopyBeanToBean(de, temp);
                ldManager.UpdateEntity<CycleEntity>(temp);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

   

        public void DeleteCycle(AuditEntity.CycleEntity de)
        {
            try
            {
                CycleEntity temp = GetCycle(de);
                ldManager.Delete<CycleEntity>(temp);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }



        public CycleEntity GetCycle(CycleEntity de)
        {
            try
            {
                CycleEntity temp = ldManager.GetEntity<CycleEntity>(r => r.Id == de.Id);
                return temp;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public CycleEntity GetCycleInfor(string YWRQ)
        {
            try
            {
                string sql = string.Format("select  top 1 * from CT_BASIC_CYCLE where CYCLE_KSRQ<='{0}'  and CYCLE_JSRQ>='{0}'",YWRQ);
                List<CycleEntity> rfde = dbManager.ExecuteSqlReturnTType<CycleEntity>(sql);
                if (rfde != null && rfde.Count > 0)
                {
                    return rfde[0];
                }
                else
                {
                    return null;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DataGrid<CycleEntity> GetCycleList(DataGrid<CycleEntity> dataGrid, CycleEntity de)
        {
            try
            {
                DataGrid<CycleEntity> dg = new DataGrid<CycleEntity>();
                List<string> names = new List<string>();
                names.Add("Code");
                names.Add("Name");
                string whereSql = BeanUtil.ConvertObjectToFuzzyQueryWhereSqls<CycleEntity>(de, names);
                string csql = "SELECT * FROM CT_BASIC_CYCLE where 1=1   ";
                if(!StringUtil.IsNullOrEmpty(whereSql))
                csql +="AND "+ whereSql;
             
                Dictionary<string, string> maps = BeanUtil.ConvertObjectToMaps<CycleEntity>();

                string countSql = "SELECT COUNT(*) FROM CT_BASIC_CYCLE  where 1=1  ";
                if (!StringUtil.IsNullOrEmpty(whereSql))
                    countSql += "AND " + whereSql;

             
                string sortName = maps[dataGrid.sort] ;
                dg.rows = dbManager.ExecuteSqlReturnTType<CycleEntity>(csql, dataGrid.page, dataGrid.pageNumber, sortName + " " + dataGrid.order + ",CYCLE_CODE ASC", maps);
                dg.total = dbManager.Count(countSql);
                return dg;
                
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
