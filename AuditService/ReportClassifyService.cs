using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity;
using AuditSPI.Format;
using CtTool;
using DbManager;

namespace AuditService
{
    /// <summary>
    /// 报表分类
    /// </summary>
    public class ReportClassifyService:IReportClassify
    {
        CTDbManager dbManager;
        LinqDataManager linqDbManager;
        public ReportClassifyService()
        {
            if (dbManager == null)
            {
                dbManager = new CTDbManager();
            }
            if (linqDbManager == null)
            {
                linqDbManager = new LinqDataManager();
            }

        }
        /// <summary>
        /// 获取报表分类
        /// </summary>
        /// <param name="rce"></param>
        /// <returns></returns>
        public ReportClassifyEntity GetClassifyEntity(ReportClassifyEntity rce)
        {
            try
            {
                return linqDbManager.GetEntity<ReportClassifyEntity>(r => r.Id == rce.Id);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<ReportClassifyEntity> GetClassifiesList(ReportClassifyEntity rce)
        {
            try
            {
                string whereSql = BeanUtil.ConvertObjectToFuzzyQueryWhereSqls<ReportClassifyEntity>(rce);
                string sql = "SELECT * FROM CT_FORMAT_CLASSIFY  ";
                if (whereSql != "")
                {
                    sql += " WHERE " + whereSql;
                }
                sql += " ORDER BY CLASSIFY_CODE";
                return dbManager.ExecuteSqlReturnTType<ReportClassifyEntity>(sql);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void AddClassifyEntity(ReportClassifyEntity rce)
        {
            try
            {
                if (StringUtil.IsNullOrEmpty(rce.Id))
                {
                    rce.Id = Guid.NewGuid().ToString();
                    rce.CreateTime = SessoinUtil.GetCurrentDateTime();
                    rce.Creater = SessoinUtil.GetCurrentUser().Id;
                }
                linqDbManager.InsertEntity<ReportClassifyEntity>(rce);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 编辑报表分类
        /// </summary>
        /// <param name="rce"></param>
        /// <returns></returns>
        public ReportClassifyEntity EditClassifyEntity(ReportClassifyEntity rce)
        {
            try
            {
                ReportClassifyEntity temp = GetClassifyEntity(rce);
                BeanUtil.CopyBeanToBean(rce, temp);
                linqDbManager.UpdateEntity<ReportClassifyEntity>(temp);
                return temp;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 删除报表分类
        /// </summary>
        /// <param name="rce"></param>
        public void DeleteClassifyEntity(ReportClassifyEntity rce)
        {
            try
            {
                ReportClassifyEntity temp = GetClassifyEntity(rce);
                linqDbManager.Delete<ReportClassifyEntity>(temp);

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        ///获取某个类别下的报表分类
        /// </summary>
        /// <param name="rce"></param>
        /// <returns></returns>
        public List<ReportFormatDicEntity> GetReportsByClassify(ReportClassifyEntity rce)
        {
            try
            {
                string sql = "SELECT REPORTDICTIONARY_ID,REPORTDICTIONARY_CODE,REPORTDICTIONARY_NAME,RELATION_CLASSIFYID  FROM CT_FORMAT_REPORTDICTIONARY P ";
                sql += " LEFT JOIN CT_FORMAT_RELATION R" +
                        " ON P.REPORTDICTIONARY_ID=R.RELATION_REPORTID ";
                if (!StringUtil.IsNullOrEmpty(rce.Id))
                {
                    sql += "   WHERE R.RELATION_CLASSIFYID='" + rce.Id + "'";
                }
                else
                {
                    sql += "  WHERE 1=1 ";
                    if (!StringUtil.IsNullOrEmpty(rce.bbCode))
                    {
                        sql += " AND  REPORTDICTIONARY_CODE LIKE '%" + rce.bbCode + "%' ";
                    }

                    if (!StringUtil.IsNullOrEmpty(rce.bbName))
                    {
                        sql += " OR REPORTDICTIONARY_NAME LIKE '%" + rce.bbName + "%'";
                    }
                }
               
                

                sql += " ORDER BY REPORTDICTIONARY_CODE";
                Dictionary<string, string> maps = BeanUtil.ConvertObjectToMaps<ReportFormatDicEntity>();
                maps.Add("ReportClassifyId", "RELATION_CLASSIFYID");
                return dbManager.ExecuteSqlReturnTType<ReportFormatDicEntity>(sql,maps);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 获取未分类报表列表
        /// </summary>
        /// <returns></returns>
        public List<ReportFormatDicEntity> GetUnClassifyReports()
        {
            try
            {
                string sql = "SELECT REPORTDICTIONARY_ID,REPORTDICTIONARY_CODE,REPORTDICTIONARY_NAME FROM CT_FORMAT_REPORTDICTIONARY "+
" WHERE REPORTDICTIONARY_ID NOT IN (SELECT RELATION_REPORTID FROM CT_FORMAT_RELATION)";
                sql += " ORDER BY REPORTDICTIONARY_CODE";
                return dbManager.ExecuteSqlReturnTType<ReportFormatDicEntity>(sql);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        public void SaveReports(List<ReportRelationEntity> relations,string classifyid)
        {
            try
            {
                string sql = "DELETE FROM CT_FORMAT_RELATION WHERE RELATION_CLASSIFYID='" + classifyid + "'";
                dbManager.ExecuteSql(sql);
                if (relations.Count > 0)
                {                   
                    foreach (ReportRelationEntity rre in relations)
                    {
                        if (StringUtil.IsNullOrEmpty(rre.Id))
                        {
                            rre.Id = Guid.NewGuid().ToString();
                        }
                        linqDbManager.InsertEntity<ReportRelationEntity>(rre);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void SaveReportRelations(ReportRelationEntity relation)
        {
            try
            {
                if (StringUtil.IsNullOrEmpty(relation.Id))
                {
                    relation.Id = Guid.NewGuid().ToString();
                }
                linqDbManager.InsertEntity<ReportRelationEntity>(relation);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
