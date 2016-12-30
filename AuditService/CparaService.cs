using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Linq.Expressions;
using System.Web;
using System.Web.SessionState;
using DbManager;
using AuditEntity;
using AuditSPI;
using AuditSPI.Session;
using CtTool;
using GlobalConst;


namespace AuditService
{
    public class CparaService : ICpara
    {
        private IDbManager dbManager;
        private ILinqDataManager linqManager;
        public CparaService()
        {
            dbManager = new CTDbManager();
            linqManager = new LinqDataManager(); 
        }
        

      
        /// <summary>
        /// 
        /// </summary>
        /// <param name="userEntity"></param>
        public void Save(CparaEntity cparaEntity)
        {
            try
            {
                if (StringUtil.IsNullOrEmpty(cparaEntity.Id))
                {
                    cparaEntity.Id = Guid.NewGuid().ToString();
                }
                linqManager.InsertEntity<CparaEntity>(cparaEntity);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        
        /// <summary>
        ///
        /// </summary>
        /// <param name="userEntity"></param>
        public void Edit(CparaEntity cparaEntity)
        {
            try
            {
                CparaEntity re = linqManager.GetEntity<CparaEntity>(r => r.Id == cparaEntity.Id);
                BeanUtil.CopyBeanToBean(cparaEntity, re);
                linqManager.UpdateEntity<CparaEntity>(cparaEntity);
            }
            catch (Exception ex)
            {
                throw ex;
            }


        }
      
        /// <summary>
        /// 删除用户信息
        /// </summary>
        /// <param name="userEntity"></param>
        public void Delete(CparaEntity cparaEntity)
        {
            try
            {
                string sql = "DELETE FROM CT_BASIC_CPARA WHERE CPARA_ID='" + cparaEntity.Id + "'";
                dbManager.ExecuteSql(sql);
              
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="userEntity"></param>
        /// <returns></returns>
        public CparaEntity Get(string id)
        {
            try
            {
                CparaEntity re = linqManager.GetEntity<CparaEntity>(r => r.Id == id);
               // GetSParas(re);
                return re;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public void GetSParas(CparaEntity Cpara)
        {
            try
            {
                string strParas = string.Empty;
                Cpara.SparaName = "";
                
                foreach(string para in Cpara.SPARA.Split(','))
                {
                    strParas = strParas + "'" + para + "',";
                }
                if (strParas.Length == 0)
                    return;

                string sql =string.Format( "select * from CT_BASIC_DICTIONARY where DICTIONARY_CLASSID='b9b5eeef-c5ff-43fe-a1af-0e3339a96144'  and DICTIONARY_CODE in ({0})",strParas);
                Cpara.Sparas = dbManager.ExecuteSqlReturnTType<DictionaryEntity>(sql);

                foreach (DictionaryEntity re in Cpara.Sparas)
                {
                     Cpara.SparaName += re.Name + ",";
                }
               
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        

        /// <summary>
        /// 
        /// </summary>
        /// <param name="dataGrid"></param>
        /// <returns></returns>
        public DataGrid<CparaEntity> GetDataGrid(DataGrid<AuditEntity.CparaEntity> dataGrid, CparaEntity cparaEntity)
        {
            DataGrid<CparaEntity> dg = new DataGrid<CparaEntity>();
            string sql = "SELECT * FROM CT_BASIC_CPARA WHERE 1=1";
            string whereSql = BeanUtil.ConvertObjectToFuzzyQueryWhereSqls<CparaEntity>(cparaEntity);
            Dictionary<string, string> maps = BeanUtil.ConvertObjectToMaps<CparaEntity>();
            string countSql = "SELECT COUNT(*) FROM CT_BASIC_CPARA WHERE 1=1 ";
            string sortName = maps[dataGrid.sort];
            sql = AddWhereSql(sql, whereSql);
            countSql = AddWhereSql(countSql, whereSql);
            dg.rows = dbManager.ExecuteSqlReturnTType<CparaEntity>(sql, dataGrid.page, dataGrid.pageNumber, sortName + " " + dataGrid.order, maps);
            dg.total = dbManager.Count(countSql);
            return dg;
        }
        private string AddWhereSql(string sql, string whereSql)
        {
            try
            {
                if (!StringUtil.IsNullOrEmpty(whereSql))
                {
                    sql += " AND " + whereSql;
                }
                return sql;

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<CparaEntity> GetList()
        {
            try
            {
                string sql = "SELECT * FROM CT_BASIC_CPARA";
                List<CparaEntity> lists = dbManager.ExecuteSqlReturnTType<CparaEntity>(sql);
                return lists;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


    }
}
