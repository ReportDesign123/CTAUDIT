
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity;
using AuditEntity.ReportState;
using AuditSPI.ReportAnalysis;
using AuditSPI;
using DbManager;
using CtTool;
using GlobalConst;

namespace AuditService.ReportAnalysis
{
    public class ReportStateAggregationService : IReportStateAggregation
    {
        CompanyService companyService;
        CTDbManager dbManager;
        public ReportStateAggregationService()
        {
            if (companyService == null)
            {
                companyService = new CompanyService();
            }
            if (dbManager == null)
            {
                dbManager = new CTDbManager();
            }
        }
        /// <summary> 
        /// 根据报表状态获取报表状态汇总列表 
        /// </summary> 
        /// <param name="reportState"></param> 
        /// <param name="state"></param> 
        /// <returns></returns> 
        public List<ReportStateAggregationStruct> GetReportStateAggregation(ReportStateEntity state)
        {
            try
            {
                List<ReportStateAggregationStruct> reportStateList = new List<ReportStateAggregationStruct>();

                StringBuilder sql = new StringBuilder();
                sql.Append("SELECT REPORTSTATE_REPORTID AS ReportId,COUNT(*) AS Num,REPORTSTATE_STATE AS State FROM CT_STATE_REPORTSTATE ");
                sql.Append(CreateWhereSqlByReportState(state));
                sql.Append(" GROUP BY REPORTSTATE_REPORTID,REPORTSTATE_STATE ");
                List<ReportStateByClass> rsbcList = new List<ReportStateByClass>();
                Dictionary<string, string> maps = new Dictionary<string, string>();
                maps.Add("ReportId", "ReportId");
                maps.Add("Num", "Num");
                maps.Add("State", "State");
                rsbcList = dbManager.ExecuteSqlReturnTType<ReportStateByClass>(sql.ToString(),maps);

                sql.Length = 0;
                sql.Append("SELECT REPORTDICTIONARY_ID,REPORTDICTIONARY_CODE,REPORTDICTIONARY_NAME FROM CT_FORMAT_REPORTDICTIONARY WHERE REPORTDICTIONARY_ID IN (" + StringUtil.ConvertStringToInSql(state.ReportId) + ")");
                maps = BeanUtil.ConvertObjectToMaps<ReportFormatDicEntity>();
                List<ReportFormatDicEntity> reportDics = dbManager.ExecuteSqlReturnTType<ReportFormatDicEntity>(sql.ToString(),maps);

                Dictionary<string, ReportStateAggregationStruct> aggregations = new Dictionary<string, ReportStateAggregationStruct>();
                foreach (ReportStateByClass rsbc in rsbcList)
                {
                    if (aggregations.ContainsKey(rsbc.ReportId))
                    {
                        ReportStateAggregationStruct rsas = aggregations[rsbc.ReportId];
                        SetReportStateAggregation(rsbc, rsas);
                    }
                    else
                    {
                        ReportStateAggregationStruct rsas = new ReportStateAggregationStruct();
                        rsas.BbId = rsbc.ReportId;
                        ReportFormatDicEntity temp = GetReportFormatDic(reportDics, rsbc.ReportId);
                        if (temp != null)
                        {
                            rsas.BbCode = temp.bbCode;
                            rsas.BbName = temp.bbName;
                        }
                        SetReportStateAggregation(rsbc, rsas);
                        aggregations.Add(rsbc.ReportId, rsas);
                    }
                }

                string[] reportIds = state.ReportId.Split(',');
                foreach (string id in reportIds)
                {
                    if (!aggregations.ContainsKey(id))
                    {
                        ReportStateAggregationStruct rsas = new ReportStateAggregationStruct();
                        rsas.BbId = id;
                        ReportFormatDicEntity temp = GetReportFormatDic(reportDics, id);
                        if (temp != null)
                        {
                            rsas.BbCode = temp.bbCode;
                            rsas.BbName = temp.bbName;
                        }
                       
                        aggregations.Add(id, rsas);
                    }
                }
                //获取权限的单位数 
                sql.Length = 0;
                sql.Append("SELECT COUNT(*) FROM LSBZDW WHERE LSBZDW_ID ");
                sql.Append(companyService.GetFillReportAuthorityCompaniesIdSql());
                int total = dbManager.Count(sql.ToString());

                foreach (ReportStateAggregationStruct rsas in aggregations.Values)
                {
                    rsas.WtbNum = total - rsas.TbNum - rsas.JYTG - rsas.JYBTG - rsas.BJSHTG - rsas.SJSHTG - rsas.SJSHBTG;
                    reportStateList.Add(rsas);
                }
                return reportStateList;

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        private CompanyEntity GetCompanyEntityDic(List<CompanyEntity> companies, string companyId)
        {
            try
            {

                foreach (CompanyEntity ce in companies)
                {
                    if (ce.Id == companyId)
                    {
                        return ce;
                    }
                }
                return null;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        private ReportFormatDicEntity GetReportFormatDic(List<ReportFormatDicEntity> reports, string reportId)
        {
            try
            {

                foreach (ReportFormatDicEntity rfde in reports)
                {
                    if (rfde.Id == reportId)
                    {
                        return rfde;
                    }
                }
                return null;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        private void SetReportStateAggregation(ReportStateByClass rsbc, ReportStateAggregationStruct rsas)
        {
            try
            {
                if (rsbc.State == ReportGlobalConst.REPORTSTATE_TB)
                {
                    rsas.TbNum = rsbc.Num;
                }
                else if (rsbc.State == ReportGlobalConst.REPORTSTATE_JYTG)
                {
                    rsas.JYTG = rsbc.Num;
                }
                else if (rsbc.State == ReportGlobalConst.REPORTSTATE_JYBTG)
                {
                    rsas.JYBTG = rsbc.Num;
                }
                else if (rsbc.State == ReportGlobalConst.REPORTSTATE_SELFCHECK)
                {
                    rsas.BJSHTG = rsbc.Num;
                }
                else if (rsbc.State == ReportGlobalConst.REPORTSTATE_HigherExam)
                {
                    rsas.SJSHTG = rsbc.Num;
                }
                else if (rsbc.State == ReportGlobalConst.REPORTSTATE_HigherFail)
                {
                    rsas.SJSHBTG = rsbc.Num;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary> 
        /// 根据状态创建Where条件 
        /// </summary> 
        /// <param name="state"></param> 
        /// <returns></returns> 
        private string CreateWhereSqlByReportState(ReportStateEntity state)
        {
            try
            {
                StringBuilder sqlBuilder = new StringBuilder();
                sqlBuilder.Append(" WHERE REPORTSTATE_TASKID='" + state.TaskId + "' ");
                sqlBuilder.Append(" AND REPORTSTATE_PAPERID='" + state.PaperId + "'");
                sqlBuilder.Append(" AND REPORTSTATE_REPORTID IN (" + StringUtil.ConvertStringToInSql(state.ReportId) + ")");
                sqlBuilder.Append(" AND REPORTSTATE_ND='" + state.Nd + "'");
                sqlBuilder.Append(" AND REPORTSTATE_ZQ='" + state.Zq + "'");
                if (!StringUtil.IsNullOrEmpty(state.State))
                {
                    sqlBuilder.Append(" AND  REPORTSTATE_STATE IN (" + StringUtil.ConvertStringToInSql(state.State) + ")");
                }
                sqlBuilder.Append(" AND REPORTSTATE_COMPANYID  " + companyService.GetFillReportAuthorityCompaniesIdSql());
                return sqlBuilder.ToString();

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        /// <summary> 
        /// 根据状态创建Where条件 
        /// </summary> 
        /// <param name="state"></param> 
        /// <returns></returns> 
        private string CreateWhereSqlByReportStateDetail(ReportStateEntity state,bool flag)
        {
            try
            {
                StringBuilder sqlBuilder = new StringBuilder();
                sqlBuilder.Append(" WHERE REPORTSTATE_TASKID='" + state.TaskId + "' ");
                sqlBuilder.Append(" AND REPORTSTATE_PAPERID='" + state.PaperId + "'");
                sqlBuilder.Append(" AND REPORTSTATE_REPORTID IN (" + StringUtil.ConvertStringToInSql(state.ReportId) + ")");
                sqlBuilder.Append(" AND REPORTSTATE_ND='" + state.Nd + "'");
                sqlBuilder.Append(" AND REPORTSTATE_ZQ='" + state.Zq + "'");
                if (!StringUtil.IsNullOrEmpty(state.State)&&flag)
                {
                    sqlBuilder.Append(" AND  REPORTSTATE_STATE ='" + state.State+"'");
                }
                sqlBuilder.Append(" AND REPORTSTATE_COMPANYID = '" + state.CompanyId+"'");
                return sqlBuilder.ToString();

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        /// <summary>
        /// 根据报表状态获取相关的单位信息
        /// </summary>
        /// <param name="state"></param>
        /// <returns></returns>
        public List<CompanyEntity> GetReportStateAggregationCompanies(ReportStateEntity state)
        {
            try
            {
                List<CompanyEntity> companies = new List<CompanyEntity>();

                StringBuilder sql = new StringBuilder();
                if (state.State == ReportGlobalConst.REPORTSTATE_WTB)
                {
                    sql.Append("SELECT LSBZDW_DWBH,LSBZDW_DWMC FROM LSBZDW ");
                    sql.Append(" WHERE lsbzdw_id ");
                    sql.Append("='"+state.CompanyId+"'");                     
                    List<CompanyEntity> all = new List<CompanyEntity>();
                    all = dbManager.ExecuteSqlReturnTType<CompanyEntity>(sql.ToString());

                    List<CompanyEntity> exists = new List<CompanyEntity>();
                    sql.Length = 0;
                    sql.Append("SELECT LSBZDW_DWBH,LSBZDW_DWMC FROM LSBZDW ");
                    sql.Append(CreateWhereSqlByReportState(state));
                    exists = dbManager.ExecuteSqlReturnTType<CompanyEntity>(sql.ToString());
                    foreach (CompanyEntity entity in all)
                    {
                        bool flag = false;
                        foreach (CompanyEntity e in exists)
                        {
                            if (entity.Id == e.Id)
                            {
                                flag = true;
                                break;
                            }
                        }
                        if (!flag)
                        {
                            companies.Add(entity);
                        }
                    }


                }
                else
                {
                    sql.Append("SELECT LSBZDW_DWBH,LSBZDW_DWMC FROM LSBZDW ");
                    sql.Append(CreateWhereSqlByReportState(state));
                    sql.Append(" AND REPORTSTATE_STATE='"+state.State+"'");              
                    companies = dbManager.ExecuteSqlReturnTType<CompanyEntity>(sql.ToString());


                }
                return companies;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// 根据报表状态获取相关的单位信息
        /// </summary>
        /// <param name="state"></param>
        /// <returns></returns>
        public List<ReportFormatDicEntity> GetReportStateAggregationReports(ReportStateEntity state)
        {
            try
            {
                List<ReportFormatDicEntity> reports = new List<ReportFormatDicEntity>();
                Dictionary<string, string> maps = new Dictionary<string, string>();
                StringBuilder sql = new StringBuilder();
                if (state.State == ReportGlobalConst.REPORTSTATE_WTB)
                {
                    sql.Length = 0;
                    sql.Append("SELECT REPORTDICTIONARY_ID,REPORTDICTIONARY_CODE,REPORTDICTIONARY_NAME FROM CT_FORMAT_REPORTDICTIONARY WHERE REPORTDICTIONARY_ID IN (" + StringUtil.ConvertStringToInSql(state.ReportId) + ")");
                    maps = BeanUtil.ConvertObjectToMaps<ReportFormatDicEntity>();
                    List<ReportFormatDicEntity> all = dbManager.ExecuteSqlReturnTType<ReportFormatDicEntity>(sql.ToString(), maps);

                    List<ReportStateEntity> exists = new List<ReportStateEntity>();
                    sql.Length = 0;
                    sql.Append("SELECT REPORTSTATE_REPORTID FROM CT_STATE_REPORTSTATE ");
                    sql.Append(CreateWhereSqlByReportStateDetail(state,false));
                    exists = dbManager.ExecuteSqlReturnTType<ReportStateEntity>(sql.ToString());

                    foreach (ReportFormatDicEntity entity in all)
                    {
                        bool flag = false;
                        foreach (ReportStateEntity e in exists)
                        {
                            if (entity.Id == e.ReportId)
                            {
                                flag = true;
                                break;
                            }
                        }
                        if (!flag)
                        {
                            reports.Add(entity);
                        }
                    }


                }
                else
                {
                    sql.Append("SELECT REPORTDICTIONARY_ID,REPORTDICTIONARY_CODE,REPORTDICTIONARY_NAME FROM CT_FORMAT_REPORTDICTIONARY WHERE REPORTDICTIONARY_ID IN ");
                    sql.Append("(SELECT REPORTSTATE_REPORTID FROM CT_STATE_REPORTSTATE  ");
                    sql.Append(CreateWhereSqlByReportStateDetail(state,true));
                    sql.Append(" AND REPORTSTATE_STATE='" + state.State + "')");
                    reports = dbManager.ExecuteSqlReturnTType<ReportFormatDicEntity>(sql.ToString());


                }
                return reports;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// 根据单位汇总报表的状态
        /// </summary>
        /// <param name="state"></param>
        /// <returns></returns>
        public List<ReportStateAggregationStruct> GetReportStateAggregationByCompany(ReportStateEntity state)
        {
            try
            {
                List<ReportStateAggregationStruct> reportStateList = new List<ReportStateAggregationStruct>();

                StringBuilder sql = new StringBuilder();
                sql.Append("SELECT REPORTSTATE_COMPANYID AS CompanyId,COUNT(*) AS Num,REPORTSTATE_STATE AS State FROM CT_STATE_REPORTSTATE ");
                sql.Append(CreateWhereSqlByReportState(state));
                sql.Append(" GROUP BY REPORTSTATE_COMPANYID,REPORTSTATE_STATE ");
                List<ReportStateByClass> rsbcList = new List<ReportStateByClass>();
                Dictionary<string, string> maps = new Dictionary<string, string>();
                maps.Add("CompanyId", "CompanyId");
                maps.Add("Num", "Num");
                maps.Add("State", "State");
                rsbcList = dbManager.ExecuteSqlReturnTType<ReportStateByClass>(sql.ToString(), maps);

                sql.Length = 0;
                sql.Append("SELECT LSBZDW_DWBH,LSBZDW_DWMC,LSBZDW_ID FROM LSBZDW ");
                sql.Append("WHERE LSBZDW_ID ");
                sql.Append(companyService.GetFillReportAuthorityCompaniesIdSql());
                maps = BeanUtil.ConvertObjectToMaps<CompanyEntity>();
                List<CompanyEntity> comapnyEntities = dbManager.ExecuteSqlReturnTType<CompanyEntity>(sql.ToString(), maps);

                Dictionary<string, ReportStateAggregationStruct> aggregations = new Dictionary<string, ReportStateAggregationStruct>();
                foreach (ReportStateByClass rsbc in rsbcList)
                {
                    if (aggregations.ContainsKey(rsbc.CompanyId))
                    {
                        ReportStateAggregationStruct rsas = aggregations[rsbc.CompanyId];
                        SetReportStateAggregation(rsbc, rsas);
                    }
                    else
                    {
                        ReportStateAggregationStruct rsas = new ReportStateAggregationStruct();
                        rsas.CompanyId = rsbc.CompanyId;
                        CompanyEntity temp = GetCompanyEntityDic(comapnyEntities, rsbc.CompanyId);
                        if (temp != null)
                        {
                            rsas.CompanyCode = temp.Code;
                            rsas.CompanyName = temp.Name;
                        }
                        SetReportStateAggregation(rsbc, rsas);
                        aggregations.Add(rsbc.CompanyId, rsas);
                    }
                }

               
                foreach (CompanyEntity ce in comapnyEntities)
                {
                    if (!aggregations.ContainsKey(ce.Id))
                    {
                        ReportStateAggregationStruct rsas = new ReportStateAggregationStruct();
                        rsas.CompanyId = ce.Id;

                       CompanyEntity temp = GetCompanyEntityDic(comapnyEntities, ce.Id);
                        if (temp != null)
                        {
                            rsas.CompanyCode = temp.Code;
                            rsas.CompanyName = temp.Name;
                        }

                        aggregations.Add(ce.Id, rsas);
                    }
                }
                //获取权限的单位数 
                string[] reportIds = state.ReportId.Split(',');
                int total = reportIds.Length;

                foreach (ReportStateAggregationStruct rsas in aggregations.Values)
                {
                    rsas.WtbNum = total - rsas.TbNum - rsas.JYTG - rsas.JYBTG - rsas.BJSHTG - rsas.SJSHTG - rsas.SJSHBTG;
                    reportStateList.Add(rsas);
                }
                return reportStateList;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}