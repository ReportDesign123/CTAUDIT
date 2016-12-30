using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;

namespace AuditEntity
{
     [Table(Name = "LSBZDW")]
     public class CompanyEntity
    {
         [Column(Name = "LSBZDW_ID", IsPrimaryKey = true)]
         public string Id
         {
             get;
             set;
         }
         [Column(Name = "LSBZDW_DWBH")]
         public string Code
         {
             get;
             set;
         }
         [Column(Name = "LSBZDW_DWMC")]
         public string Name
         {
             get;
             set;
         }
         [Column(Name = "LSBZDW_DWNM")]
         public string Nm
         {
             get;
             set;
         }
         [Column(Name = "LSBZDW_MX")]
         public int Mx
         {
             get;
             set;
         }
         [Column(Name = "LSBZDW_SEQUENCE")]
         public int Sequence
         {
             get;
             set;
         }
          [Column(Name = "lsbzdw_parentid")]
         public string ParentId
         {
             get;
             set;
         }
         [Column(Name = "lsbzdw_js")]
          public int Js
          {
              get;
              set;
          }
         public string state = "";
         public bool isOrNotChecked = false;
         public string Path
         {
             get;
             set;
         }
         //LingerUi单位树状态
         public bool isexpand = false;
         public bool ischecked = false;
    }
}
