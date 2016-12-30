using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace AuditSPI
{
    public  class MyException:Exception
    {
        public string Rank;
        public MyException(string msg, string rank):base(msg)
        {
            Rank = rank;
        }
        public MyException(string msg)
            : base(msg)
        {
        }

        
    }
}
