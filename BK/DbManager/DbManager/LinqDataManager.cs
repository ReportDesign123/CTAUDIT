namespace DbManager
{
    using AuditSPI;
    using System;
    using System.Collections.Generic;
    using System.Data.Linq;
    using System.Linq;
    using System.Linq.Expressions;

    public class LinqDataManager : ILinqDataManager
    {
        private DataContext dContext;

        public LinqDataManager()
        {
            if (this.dContext == null)
            {
                this.dContext = new DataContext(ConnectionManager.getConnection());
            }
        }

        public void Delete<T>(T entity) where T: class
        {
            this.dContext.GetTable<T>().DeleteOnSubmit(entity);
            this.dContext.SubmitChanges();
        }

        public T GetEntity<T>(Expression<Func<T, bool>> predicate) where T: class
        {
            return this.dContext.GetTable<T>().FirstOrDefault<T>(predicate);
        }

        public List<T> getList<T>() where T: class
        {
            return this.dContext.GetTable<T>().ToList<T>();
        }

        public List<T> getList<T>(Expression<Func<T, bool>> predicate) where T: class
        {
            return this.dContext.GetTable<T>().Where<T>(predicate).ToList<T>();
        }

        public List<T> getList<T, TKEY>(Expression<Func<T, bool>> predicate, Expression<Func<T, TKEY>> orderPredicate) where T: class
        {
            return this.dContext.GetTable<T>().Where<T>(predicate).OrderBy<T, TKEY>(orderPredicate).ToList<T>();
        }

        public List<T> getList<T>(Expression<Func<T, bool>> predicate, int pageIndex, int page) where T: class
        {
            return this.dContext.GetTable<T>().Where<T>(predicate).Skip<T>(((pageIndex - 1) * page)).Take<T>(page).ToList<T>();
        }

        public void InsertEntity<T>(T entity) where T: class
        {
            this.dContext.GetTable<T>().InsertOnSubmit(entity);
            this.dContext.SubmitChanges();
        }

        public void UpdateEntity<T>(T entity) where T: class
        {
            this.dContext.SubmitChanges();
        }
    }
}

