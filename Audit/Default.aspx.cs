using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Linq.Expressions;
using System.Data.Common;
using System.Data;



using DbManager;
using AuditService;
using AuditEntity;
using AuditSPI;
using CtTool;
using Audit.Actions;
using AuditService.Procedure;
using AuditEntity.Procedure;

namespace Audit
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            //UserService us = new  UserService();
            //List<UserEntity> users= us.getUserList();
            
            //UserEntity user = us.getUser(u => u.Id == "0");
            //user.Name = "234";       
            //us.UpdateUser(user);
          // CTDbManager manager = new CTDbManager();
           // string sql = "INSERT INTO CT_BASIC_USER VALUES('1','LISI','LISI')";
            //manager.ExecuteSql(sql);


            //string sql = "insert into ct_basic_user values({0},{1},{2})";
            //list<dbparameter> ps = new list<dbparameter>();
            //dbparameter p0 = manager.getdbparameter();
            //p0.dbtype = dbtype.string;
            //p0.value = "2";
            //p0.parametername = "userid";
            //ps.add(p0);

            //dbparameter p1 = manager.getdbparameter();
            //p1.dbtype = dbtype.string;
            //p1.value = "2";
            //p1.parametername = "usercode";
            //ps.add(p1);


            //dbparameter p2 = manager.getdbparameter();
            //p2.dbtype = dbtype.string;
            //p2.value = "2";
            //p2.parametername = "username";
            //ps.add(p2);
            //manager.executesql(sql, ps);


            //string sql = "select * from CT_BASIC_USER";
            //DbDataReader reader = manager.ExecuteSqlReturnDataReader(sql);
            //while (reader.Read())
            //{
            //    Console.WriteLine("{0}", reader[0]);
            //}
            //reader.Close();
            //manager.Close();

            //string sql = "select * from CT_BASIC_USER where USER_ID={0}";
            //DataTable dt = manager.ExecuteSqlReturnDataTable(sql);


            //List<UserEntity> lists = manager.ExecuteSqlReturnTType<UserEntity>(sql);

            //string sql = "INSERT INTO CT_BASIC_USER (USER_ID)VALUES({0})";
            //List<DbParameter> ps = new List<DbParameter>();
            //DbParameter p0 = manager.GetDbParameter();
            //p0.DbType = DbType.String;
            //p0.ParameterName = "userid";
            //p0.SourceColumn = "USER_ID";
            //p0.SourceVersion = DataRowVersion.Original;
            //ps.Add(p0);
            ////List<UserEntity> lists = manager.ExecuteSqlReturnTType<UserEntity>(sql, ps);

            //Dictionary<string, string> maps = new Dictionary<string, string>();
            //maps.Add("Id", "USER_ID");
            ////List<UserEntity> lists = manager.ExecuteSqlReturnTType<UserEntity>(sql, ps,maps);
            //DataTable dt = new DataTable();
            //DataColumn dc = new DataColumn();
            //dc.ColumnName = "USER_ID";
            //dt.Columns.Add(dc);
            //DataRow row = dt.NewRow();
            //row["USER_ID"] = "16";
            
            //dt.Rows.Add(row);

            //DataRow dr = dt.NewRow();
            //dr["USER_ID"] = "17";
            //dt.Rows.Add(dr);

            //manager.BatchUpdateData(dt, sql, UpdateType.INSERTCOMMAND, ps);
            //string text = JSON.ToJSON(dt);

            //string sql = "SELECT * FROM CT_BASIC_FUNCTIONS";
            //Dictionary<string, string> maps = new Dictionary<string, string>();
            //maps.Add("Id", "FUNCTIONS_ID");
            //List<FunctionEntity>lists= manager.ExecuteSqlReturnTType<FunctionEntity>(sql, 1, 10, " FUNCTIONS_CODE ", maps);

            //RoleAction ra = new RoleAction();
            //RoleEntity re = new RoleEntity();
            //re.Id = "1";
            //ra.GetRoleFunctions(re);

          //  Response.Redirect("Login.aspx");
          //  FormularService fs = new AuditService.FormularService();
           // fs.DeserializeFatchFormular("SQL");
            ProcedureService ps = new ProcedureService();
            //DataGrid<ProcedureEntity> dg=new DataGrid<ProcedureEntity>();
            //dg.sort = "Id";
            //dg.order = "Desc";
            //ProcedureEntity pe=new ProcedureEntity();
            //ps.GetProcedureDataGrid(dg, pe);
           // ps.GetParametersByProcedure(1083150904);
        }

    }
}