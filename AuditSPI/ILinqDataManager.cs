using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq;
using System.Linq.Expressions;

namespace AuditSPI
{
   public interface ILinqDataManager
    {
     List<T> getList<T>() where T:class;
     void InsertEntity<T>(T entity) where T : class;
      List<T> getList<T>(Expression<Func<T, bool>> predicate) where T : class;
     void UpdateEntity<T>(T entity) where T : class;
     T GetEntity<T>(Expression<Func<T, bool>> predicate) where T : class;
     void Delete<T>(T entity) where T : class;
     List<T> getList<T,TKEY>(Expression<Func<T, bool>> predicate, Expression<Func<T,TKEY>> orderPredicate) where T : class;
     List<T> getList<T>(Expression<Func<T, bool>> predicate, int pageIndex, int page) where T : class;
    }
}
