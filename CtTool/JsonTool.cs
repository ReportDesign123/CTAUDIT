using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using AuditEntity;
using AuditSPI;
using AuditSPI.Format;
using System.Reflection;
using Newtonsoft.Json;


namespace CtTool
{
    public  class JsonTool
    {
        /// <summary>
        /// 书写Json数据
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="obj"></param>
        public static void WriteJson<T>(T obj,HttpContext context)
        {
            JSONParameters j = new JSONParameters();
            j.UseEscapedUnicode = false;
            j.UseExtensions = false;
            j.UsingGlobalTypes = false;
            string json = JSON.ToJSON(obj, j);
            context.Response.Write(json);
        }

        public static string WriteJsonStr<T>(T obj)
        {
            JSONParameters j = new JSONParameters();
            j.UseEscapedUnicode = false;
            j.UseExtensions = false;
            j.UsingGlobalTypes = false;
            string json = JSON.ToJSON(obj, j);
            return json;
            
        }

    
        public static BBData ConvertObjectToBBData(object obj){
            try
            {
                BBData bbdata = new BBData();
                Type t=bbdata.GetType();
               
                Dictionary<string, object> objDic = (Dictionary<string, object>)obj;
                foreach (string key in objDic.Keys)
                {
                    FieldInfo fi = t.GetField(key);
                    if (fi != null)
                    {
                        if (fi.FieldType ==typeof( Dictionary<int,Dictionary<int,Cell>>))
                        {
                            Dictionary<string, object> bd = (Dictionary<string, object>)objDic[key];
                            foreach (string k in bd.Keys)
                            {
                                Dictionary<int, Cell> row = new Dictionary<int, Cell>();
                                Dictionary<string, object> oRow = (Dictionary<string,object>)bd[k];
                                foreach (string r in oRow.Keys)
                                {
                                    Cell ce=new Cell();
                                    Dictionary<string, object> cell = (Dictionary<string, object>)oRow[r];
                                    Type cT = typeof(Cell);
                                    FieldInfo[] cfis = cT.GetFields();
                                    foreach (FieldInfo cfi in cfis)
                                    {
                                        if(cell.ContainsKey(cfi.Name)){
                                            cfi.SetValue(ce, ChangeType(cell[cfi.Name], cfi.FieldType));
                                        }
                                        
                                    }
                                   row.Add(Convert.ToInt32(r),ce);
                                }
                                bbdata.bbData.Add(Convert.ToInt32(k),row);
                            }
                        }
                        else if (fi.FieldType == typeof(string))
                        {
                            fi.SetValue(bbdata, objDic[key]);
                        }
                        else if (fi.FieldType == typeof(int))
                        {
                            fi.SetValue(bbdata,Convert.ToInt32(objDic[key]));
                        }
                        else if (fi.FieldType == typeof(BdqsData))
                        {
                            Type bdType = typeof(BdqsData);
                            Dictionary<string, object> bdDic = (Dictionary<string, object>)objDic[key];
                            foreach (string bdKey in bdDic.Keys)
                            {
                                FieldInfo bdf = bdType.GetField(bdKey);
                                if (bdf != null)
                                {
                                    if (bdf.FieldType == typeof(int))
                                    {
                                        bdf.SetValue(bbdata.bdq, Convert.ToInt32(bdDic[bdKey]));
                                    }
                                    else if (bdf.FieldType == typeof(Dictionary<string, int>))
                                    {
                                        Dictionary<string, object> bdmap = (Dictionary<string, object>)bdDic[bdKey];
                                        foreach (string bdmk in bdmap.Keys)
                                        {
                                            bbdata.bdq.BdqMaps.Add(bdmk, Convert.ToInt32(bdmap[bdmk]));
                                        }
                                    }
                                    else if (bdf.FieldType == typeof(List<Bdq>))
                                    {
                                        List<object> lists = (List<object>)bdDic[bdKey];
                                        foreach (object bd in lists)
                                        {
                                            Dictionary<string, object> bdq = (Dictionary<string, object>)bd;
                                            Type bdqType = typeof(Bdq);
                                            Bdq bdD = new Bdq();
                                            foreach (string bdqKey in bdq.Keys)
                                            {
                                                FieldInfo bdqfi = bdqType.GetField(bdqKey);
                                                if (bdqfi != null)
                                                {
                                                    if (bdqfi.FieldType == typeof(int))
                                                    {
                                                        bdqfi.SetValue(bdD, Convert.ToInt32(bdq[bdqKey]));
                                                    }
                                                    else if (bdqfi.FieldType == typeof(string))
                                                    {
                                                        bdqfi.SetValue(bdD, Convert.ToString(bdq[bdqKey]));
                                                    }
                                                    else if (bdqfi.FieldType == typeof(bool))
                                                    {
                                                        bdqfi.SetValue(bdD, Convert.ToBoolean(bdq[bdqKey]));
                                                    }
                                                }

                                            }
                                            bbdata.bdq.Bdqs.Add(bdD);

                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                return bbdata;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        private static object ChangeType(object value, Type conversionType)
        {
            if (conversionType == typeof(int))
                return Convert.ToInt32(value);
          
            else if (conversionType == typeof(string))
                return Convert.ToString(value);
            else if (conversionType == typeof(bool))
            {
                return Convert.ToBoolean(value);
            }
            else
                return value;

        }


        public static List<FormularEntity> ConvertBeanToListFormulars(object bean)
        {
            try
            {
                List<FormularEntity> lists = new List<FormularEntity>();
                Dictionary<string, object> fobj = (Dictionary<string, object>)bean;
                Dictionary<string, object> maps = (Dictionary<string,object>)fobj["formularMaps"];
                foreach(object objs in maps.Values){
                  
                    List<object> fs = (List<object>)objs;
                    foreach (object obj in fs)
                    {
                        FormularEntity fe = new FormularEntity();
                        Type t = typeof(FormularEntity);
                        Dictionary<string, object> fo = (Dictionary<string, object>)obj;
                        foreach (string key in fo.Keys)
                        {
                            PropertyInfo pi = t.GetProperty(key);
                            if (pi != null)
                            {
                                if(pi.PropertyType==typeof(int)){
                                    pi.SetValue(fe, Convert.ToInt32( fo[key]), null);
                                }
                                else if (pi.PropertyType == typeof(string))
                                {
                                    pi.SetValue(fe, Convert.ToString(fo[key]), null);
                                }
                               
                            }
                        }
                        lists.Add(fe);

                    }
                }
                return lists;
            }
            catch (Exception ex)
            {
                throw ex;

            }
        }


        public static T DeserializeObject<T>(string jsonStr)
        {
            try
            {
              return   JsonConvert.DeserializeObject<T>(jsonStr);
               
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
