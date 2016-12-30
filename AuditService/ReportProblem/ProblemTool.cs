using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GlobalConst;

namespace AuditService.ReportProblem
{
    public  class ProblemTool
    {
        public static string GetProblemStateType(string state)
        {
            try
            {
                string result = "";
                if (state == ReportProblemGlobal.ProblemState_QY)
                {
                    result = "启用";
                }
                else if (state == ReportProblemGlobal.ProblemSate_XD)
                {
                    result = "下达";
                }
                else if (state == ReportProblemGlobal.ProblemSate_FK)
                {
                    result = "反馈";
                }
                else if (state == ReportProblemGlobal.ProblemState_FC)
                {
                    result = "封存";
                }
                else
                {
                    result = "启用";
                }
                return result;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public static string GetProblemType(string type)
        {
            try
            {
                string result = "";
                if (type == ReportProblemGlobal.ProblemType_SJ)
                {
                    result = "符合性测试";
                }
                else
                {
                    result = "其他问题";
                }
                return result;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
