using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditSPI.Analysis;
using MultiParse;
using MultiParse.Default;

namespace AuditService.Analysis.Formular
{
    public  class FormularExpressParser:IFormularExpressDeserialize
    {
        public object ExpressParse(string formular)
        {
            try
            {
                Expression exp = new Expression();
                exp.ParseExpression = formular;              
                return exp.Evaluate();
            }
            catch (Exception ex)
            {
                string message = ex.Message;
                if (message.Substring(0, 23) == "Invalid token found for")
                {
                    //message = message.Substring(0, message.Length - 1);
                    //int start = message.LastIndexOf("'");
                    //string token = message.Substring(start + 1, message.Length - start - 1);
                    //return token;
                    return formular;
                }            

                throw ex;
            }
        }
    }
}
