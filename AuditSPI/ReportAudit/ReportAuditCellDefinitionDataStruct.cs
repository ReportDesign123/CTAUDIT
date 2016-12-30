using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditSPI.ReportData;

namespace AuditSPI.ReportAudit
{
    /// <summary>
    /// 审计单元格联查定义数据结构
    /// </summary>
    public  class ReportAuditCellDefinitionDataStruct
    {

        public static string IndexConclusion_Module = "IndexConclusion";
        public static string IndexTrend_Module = "IndexTrend";
        public static string IndexConstitution_Module = "IndexConstitution";
        public static string ReportJoin_Module = "ReportJoin";
        public static string CustomerJoin_Module = "CustomerJoin";
        public static string IndexDiscription_Module = "IndexDiscription";
        public static string IndexRelations_Module = "IndexRelations";

        IndexConclusionStruct IndexConclusion = new IndexConclusionStruct();
        IndexTrendStruct IndexTrend = new IndexTrendStruct();
        IndexConstitutionStruct IndexConstitution = new IndexConstitutionStruct();
        ReportJoinStruct ReportJoin = new ReportJoinStruct();
        CustomerJoinStruct CustomerJoin = new CustomerJoinStruct();
        IndexDiscriptionStruct IndexDiscription = new IndexDiscriptionStruct();
        IndexRelationsStruct IndexRelations = new IndexRelationsStruct();
        List<ExistModule> ExistsModules = new List<ExistModule>();


        /// <summary>
        /// 是否存在当前模块
        /// </summary>
        /// <param name="moduleName"></param>
        /// <returns></returns>
        public   bool IsOrNotExistModule(string moduleName)
        {
            try
            {
                foreach (ExistModule em in ExistsModules)
                {
                    if (em.Name == moduleName)
                    {
                        return true;
                    }
                }
                return false;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        
    }


    /// <summary>
    /// 审计结论
    /// </summary>
    public class IndexConclusionStruct
    {
        public string IsOrNotMobile;
    }
    /// <summary>
    /// 指标趋势
    /// </summary>
    public class IndexTrendStruct
    {
        public string IsOrNotMobile;
        public string DurationType;
    }
    /// <summary>
    /// 指标构成
    /// </summary>
    public class IndexConstitutionStruct
    {
        public string IsOrNotMobile;
        public List<IndexConstitutionCellDifinition> Indexs = new List<IndexConstitutionCellDifinition>();

    }
    /// <summary>
    /// 指标构成中单个指标的数据结构
    /// </summary>
    public class IndexConstitutionCellDifinition
    {
        public string IndexCode;
        public string IndexName;
        public string ReportCode;
        public string ReportName;
        public string CompanyName;
        public ReportDataParameterStruct Parameters = new ReportDataParameterStruct();
        /// <summary>
        /// 指标数值
        /// </summary>
        public object value = new object();
    }
    /// <summary>
    /// 指标描述
    /// </summary>
    public class IndexDiscriptionStruct
    {
        public string IsOrNotMobile;
        public string Discription;
    }
    /// <summary>
    /// 报表联查定义
    /// </summary>
    public class ReportJoinStruct
    {
        public string IsOrNotMobile;
        public List<ReportJoinReportDefinition> Reports = new List<ReportJoinReportDefinition>();
    }
    /// <summary>
    /// 报表联查中的报表定义
    /// </summary>
    public class ReportJoinReportDefinition
    {
        public string ReportCode;
        public string ReportName;
        public string CompanyName;
        public ReportDataParameterStruct Parameters = new ReportDataParameterStruct(); 
    }

    /// <summary>
    /// 自定义联查
    /// url\formular
    /// </summary>
    public class CustomerJoinStruct
    {
        public string IsOrNotMobile;
        public string LinkType;
        public string Content;
        public string DbType;
    }

    /// <summary>
    /// 相关指标
    /// </summary>
    public class IndexRelationsStruct
    {
        public string IsOrNotMobile;
        public List<IndexRelationsIndexDefinition> Indexs = new List<IndexRelationsIndexDefinition>();
    }

    public class IndexRelationsIndexDefinition
    {
        public string Code;
        public string Name;
    }

    public class ExistModule
    {
        public string Code;
        public string Name;
    }
}
