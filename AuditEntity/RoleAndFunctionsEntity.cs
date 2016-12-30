using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;


namespace AuditEntity
{
     [Table(Name = "CT_BASIC_ROLEANDFUNCTIONS")]
    public  class RoleAndFunctionsEntity
    {
         [Column(Name = "ROLEANDFUNCTIONS_ID", IsPrimaryKey = true)]
         public string Id
         {
             get;
             set;
         }
         [Column(Name = "ROLEANDFUNCTIONS_ROLEID")]
         public string RoleId
         {
             get;
             set;

         }
         [Column(Name = "ROLEANDFUNCTIONS_FUNCTIOINID")]
         public string FunctionId
         {
             get;
             set;
         }
         /// <summary>
         /// 全选中01 办选中02
         /// </summary>
         [Column(Name="ROLEANDFUNCTIONS_STATE")]
         public string State
         {
             get;
             set;
         }
    }
}
