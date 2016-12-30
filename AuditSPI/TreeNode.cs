using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace AuditSPI
{
   public   class TreeNode
    {
       public string id;
       public string text;
       public string code;
       public List<TreeNode> children = new List<TreeNode>();
       public string state = "";
       public bool isOrNotChecked = false;

    }
}
