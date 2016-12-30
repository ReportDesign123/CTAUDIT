using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditSPI.Analysis;
using AuditEntity;
using AuditSPI.Format;
using CtTool;
using AuditSPI.ReportData;
using AuditService.Analysis.Formular;

namespace AuditService.Analysis.Formular
{
    public  class CaculateIfFormularDeserialize
    {
        /// <summary>
        /// IF报表公式
        /// </summary>
        /// <param name="formular"></param>
        /// <returns></returns>
        public object DeserializeIfFormular(string  formularContent,FormularAnalysisFactory formularFactory)
        {
            try
            {
                IfFormularStruct formularStruct = new IfFormularStruct();
                //解析公式
                int start = formularContent.IndexOf("(");
                int end = formularContent.LastIndexOf(")");
                string ifFormular = formularContent.Substring(start + 1, end - start - 1);
                string[] fs = ifFormular.Split(';');
                formularStruct.CondisionExpress = fs[0];
                formularStruct.TrueExpress = fs[1];
                formularStruct.FalseExpress = fs[2];
                //解析条件公式
                bool IfResult =Convert.ToBoolean( formularFactory.ExpressParse(formularStruct.CondisionExpress));
                if (IfResult)
                {
                    return formularFactory.ExpressParse(formularStruct.TrueExpress);
                }
                else
                {
                    return formularFactory.ExpressParse(formularStruct.FalseExpress);
                }
              
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


    }
}
