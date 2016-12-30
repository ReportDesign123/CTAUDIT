using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace AuditSPI
{
    /// <summary>
    /// 表格数据结构
    /// </summary>
    /// <typeparam name="T"></typeparam>
    public  class DataGrid<T>
    {
        public int page=1;
        public int pageNumber = 10;
        public string sort;
        public string order;
        public int total;
        public string footer;
        public List<T> rows = new List<T>();

    }
}
