using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditSPI;
using AuditSPI.AuditPaper;
using AuditEntity;
using AuditEntity.AuditPaper;
using DbManager;
using CtTool;
using System.IO;

namespace AuditService.AuditPaper
{
    public  class AuditAttatchService:IAuditAttatch
    {
        LinqDataManager linqDbManager;
        public AuditAttatchService()
        {
            linqDbManager = new LinqDataManager();
        }
        public void Save(PaperAttatchEntity pae)
        {
            try
            {
                if (StringUtil.IsNullOrEmpty(pae.Id))
                {
                    pae.Id = Guid.NewGuid().ToString();
                }
                linqDbManager.InsertEntity<PaperAttatchEntity>(pae);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void Edit(PaperAttatchEntity pae)
        {
            try
            {
                PaperAttatchEntity temp = linqDbManager.GetEntity<PaperAttatchEntity>(r => r.Id == pae.Id);
                BeanUtil.CopyBeanToBean(pae, temp);
                linqDbManager.UpdateEntity<PaperAttatchEntity>(pae);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void Delete(string attatchId)
        {
            try
            {
                PaperAttatchEntity temp = linqDbManager.GetEntity<PaperAttatchEntity>(r => r.Id ==attatchId);
                if (File.Exists(temp.Route))
                {
                    File.Delete(temp.Route);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
