using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity;
using AuditSPI;
using DbManager;
using CtTool;
using AuditService;

namespace AuditService
{
    public  class PositionService:IPositionService
    {
        ILinqDataManager ldbManager;
        IDbManager dbManager;
        public PositionService()
        {
            ldbManager = new LinqDataManager();
            dbManager = new CTDbManager();
        }
        public List<PositionEntity> GetPositionList(PositionEntity position)
        {
            try
            {
                List<PositionEntity> positions = new List<PositionEntity>();
                string sql = "";
                if (StringUtil.IsNullOrEmpty(position.Id))
                {
                    sql = "SELECT * FROM CT_BASIC_POSITION WHERE POSITION_PARENTID IS NULL OR POSITION_PARENTID='' ORDER BY POSITION_SEQUENCE";
                    positions = dbManager.ExecuteSqlReturnTType<PositionEntity>(sql);
                }
                else
                {
                    sql = "SELECT * FROM CT_BASIC_POSITION WHERE  POSITION_PARENTID='" + position.Id + "' ORDER BY POSITION_SEQUENCE";
                    positions = dbManager.ExecuteSqlReturnTType<PositionEntity>(sql);
                }
                foreach (PositionEntity ce in positions)
                {
                    SetPositionState(ce);
                }
                return positions;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// 设置状态
        /// </summary>
        /// <param name="position"></param>
        private void SetPositionState(PositionEntity position)
        {
          
            string sql = "SELECT * FROM CT_BASIC_POSITION";
            List<PositionEntity> lists = dbManager.ExecuteSqlReturnTType<PositionEntity>(sql);
            foreach (PositionEntity pe in lists)
            {
                if (!StringUtil.IsNullOrEmpty(position.Id)&& pe.ParentId == position.Id)
                {
                    position.state = "closed";
                    break;
                }
            }
        }
        /// <summary>
        /// 保存职务信息
        /// </summary>
        /// <param name="position"></param>
        public void Save(PositionEntity position)
        {
            try
            {
                if (StringUtil.IsNullOrEmpty(position.Id))
                {
                    position.Id = Guid.NewGuid().ToString();
                }
                PositionEntity test = ldbManager.GetEntity<PositionEntity>(r => r.Code == position.Code);
                if (test != null)
                {
                    throw new Exception("编号重复");
                }
                //内码计算
                int js = 0;
                if (!StringUtil.IsNullOrEmpty(position.ParentId))
                {
                    PositionEntity parentC = ldbManager.GetEntity<PositionEntity>(r => r.Id == position.ParentId);
                    js = parentC.Js + 1;
                    position.Nm = parentC.Nm;
                }
                else
                {
                    js = 1;
                }
                List<PositionEntity> lists = ldbManager.getList<PositionEntity>(r => r.ParentId == position.ParentId);
                position.Nm += GetNm(lists);
                position.Js = js;
                ldbManager.InsertEntity<PositionEntity>(position);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        private string GetNm(List<PositionEntity> lists)
        {
            int nm = -1;
            int maxNm = 0;
            foreach (PositionEntity ce in lists)
            {
                nm = Convert.ToInt32(ce.Nm.Substring(ce.Nm.Length - 4, 4));
                if (maxNm < nm)
                {
                    maxNm = nm;
                }
            }
            return (maxNm + 1).ToString().PadLeft(4, '0');
        }
        /// <summary>
        /// 编辑职务信息
        /// </summary>
        /// <param name="position"></param>
        public void Edit(PositionEntity position)
        {
            try
            {
                if (position.Id == position.ParentId)
                {
                    throw new Exception("不能够循环引用");
                }
                List<PositionEntity> listst = ldbManager.getList<PositionEntity>(r => r.Code == position.Code);
                if (listst.Count > 1)
                {
                    throw new Exception("编号重复");
                }
                PositionEntity ce = ldbManager.GetEntity<PositionEntity>(r => r.Id == position.Id);
                string oldNm = ce.Nm;
                if (position.ParentId == ce.ParentId)
                {
                    BeanUtil.CopyBeanToBean(position, ce);
                    ldbManager.UpdateEntity<PositionEntity>(ce);
                }
                else
                {

                    int js = 0;
                    PositionEntity curParent = ldbManager.GetEntity<PositionEntity>(r => r.Id == position.ParentId);// 当前父节点
                    js = curParent.Js + 1;
                    List<PositionEntity> children = ldbManager.getList<PositionEntity>(r => r.ParentId == position.ParentId);
                    string curNm = curParent.Nm + GetNm(children);

                 

                    List<PositionEntity> oldChildren = ldbManager.getList<PositionEntity>(r => r.ParentId == ce.ParentId);
                   
                    //查找当前节点的所有子集节点包括当前节点;
                    List<PositionEntity> curNodeChildren = dbManager.ExecuteSqlReturnTType<PositionEntity>("SELECT * FROM CT_BASIC_POSITION WHERE POSITION_NM LIKE '" + ce.Nm + "%'");
                    foreach (PositionEntity temp in curNodeChildren)
                    {
                        if (temp.Id == position.Id) continue;
                        temp.Js = temp.Js - ce.Js + js;
                        temp.Nm = curNm + temp.Nm.Substring(ce.Nm.Length);
                        dbManager.ExecuteSql("UPDATE CT_BASIC_POSITION SET POSITION_NM='" + temp.Nm + "',POSITION_JS=" + temp.Js + " WHERE POSITION_ID='" + temp.Id + "'");
                    }
                    position.Nm = curNm;
                    position.Js = js;
                    BeanUtil.CopyBeanToBean(position, ce);
                    ldbManager.UpdateEntity<PositionEntity>(ce);

                }

               
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void Delete(PositionEntity position)
        {
            try
            {
                string sql = "Delete FROM CT_BASIC_POSITION WHERE POSITION_NM LIKE '" + position.Nm + "%'";
                dbManager.ExecuteSql(sql);

               
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public PositionEntity get(PositionEntity position)
        {
            try
            {
                PositionEntity ce = ldbManager.GetEntity<PositionEntity>(r => r.Id == position.Id);
                return ce;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<TreeNode> ParentCombo()
        {
            try
            {
                List<PositionEntity> lists = ldbManager.getList<PositionEntity>();
                List<TreeNode> nodes = new List<TreeNode>();
                BeanUtil.ConvertTTypeToTreeNode<PositionEntity>(lists, nodes, "Id", "Name", "ParentId");
                return nodes;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<TreeNode> WorkFlowCombo()
        {
            try
            {
                List<PositionEntity> lists = ldbManager.getList<PositionEntity>();
                List<TreeNode> nodes = new List<TreeNode>();
                BeanUtil.ConvertTTypeToTreeNode<PositionEntity>(lists, nodes, "Id", "Name", "ParentId","Code");
                return nodes;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public DataGrid<PositionEntity> GetPositionDataGrid(DataGrid<PositionEntity> dataGrid, PositionEntity position)
        {
            try
            {
                DataGrid<PositionEntity> dg = new DataGrid<PositionEntity>();
                string csql = "SELECT * FROM CT_BASIC_POSITION";
                string whereSql = BeanUtil.ConvertObjectToFuzzyQueryWhereSqls<PositionEntity>(position);
                if (!StringUtil.IsNullOrEmpty(whereSql))
                {
                    whereSql = " WHERE 1=1 AND " + whereSql;
                }
                else
                {
                    whereSql = "";
                }
                csql += whereSql;
                Dictionary<string, string> maps = BeanUtil.ConvertObjectToMaps<PositionEntity>();
                string countSql = "SELECT COUNT(*) FROM CT_BASIC_POSITION";
                countSql += whereSql;
                string sortName = maps[dataGrid.sort];
                dg.rows = dbManager.ExecuteSqlReturnTType<PositionEntity>(csql, dataGrid.page, dataGrid.pageNumber, sortName + " " + dataGrid.order, maps);
                dg.total = dbManager.Count(countSql);
                return dg;                 
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
