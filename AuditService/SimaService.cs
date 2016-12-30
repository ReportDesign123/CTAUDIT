using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditSPI;
using DbManager;
using AuditEntity;
using CtTool;

namespace AuditService
{
    public  class SimaService:ISima
    {
        IDbManager dbManager;
        public SimaService()
        {
            dbManager = new CTDbManager();
        }
        public DataGrid<AuditEntity.SimaEntity> GetSimaList(DataGrid<AuditEntity.SimaEntity> dataGrid,SimaEntity se)
        {
            try
            {
                string whereSql = " WHERE  1=1 ";
                if (!StringUtil.IsNullOrEmpty(se.Desc))
                {
                    whereSql += " AND SIMA_DISP LIKE '%"+se.Desc+"%'";
                }
                if (!StringUtil.IsNullOrEmpty(se.Obid))
                {
                    whereSql += " AND SIMA_OBJID LIKE '%" + se.Obid + "%'";
                }
                DataGrid<SimaEntity> dg=new DataGrid<SimaEntity>();
                string sql = "SELECT SIMA_DISP,SIMA_OBJID FROM RPSIMA"+whereSql;
                List<SimaEntity> lists= dbManager.ExecuteSqlReturnTType<SimaEntity>(sql);
                Dictionary<string, string> maps = new Dictionary<string, string>();
                maps.Add("Obid", "SIMA_OBJID");
                maps.Add("Desc", "SIMA_DISP");
                string countSql = "SELECT COUNT(*) FROM RPSIMA"+whereSql;
                string sortName = maps[dataGrid.sort];
                dg.rows = dbManager.ExecuteSqlReturnTType<SimaEntity>(sql, dataGrid.page, dataGrid.pageNumber, sortName + " " + dataGrid.order , maps);
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
