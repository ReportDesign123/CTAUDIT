namespace DbManager
{
    using CtTool;
    using SQLDMO;
    using System;

    public class SqlServerDatabaseBackupAndRestore : DataBaseBackupAndRestore
    {
        private BackUpConfigManager backUpConfig;
        private ServerDataSource serverDataSource;

        public SqlServerDatabaseBackupAndRestore()
        {
            if (this.serverDataSource == null)
            {
                this.serverDataSource = new ServerDataSource();
            }
            if (this.backUpConfig == null)
            {
                this.backUpConfig = new BackUpConfigManager();
            }
            string[] strArray = ConnectionManager.getConnectionStr().Replace(" ", "").Split(new char[] { ';' });
            foreach (string str2 in strArray)
            {
                string[] strArray2 = str2.Split(new char[] { '=' });
                if (strArray2[0].ToUpper() == "DataSource".ToUpper())
                {
                    this.serverDataSource.ServerIp = strArray2[1];
                }
                else if (strArray2[0].ToUpper() == "InitialCatalog".ToUpper())
                {
                    this.serverDataSource.DataBase = strArray2[1];
                }
                else if (strArray2[0].ToUpper() == "UserID".ToUpper())
                {
                    this.serverDataSource.UserId = strArray2[1];
                }
                else if (strArray2[0].ToUpper() == "Password".ToUpper())
                {
                    this.serverDataSource.Password = strArray2[1];
                }
            }
        }

        public override BackUpStruct BackUp()
        {
            BackUpStruct struct3;
            try
            {
                Backup backup = new BackupClass();
                SQLServer serverObject = new SQLServerClass {
                    LoginSecure = false
                };
                serverObject.Connect(this.serverDataSource.ServerIp, this.serverDataSource.UserId, this.serverDataSource.Password);
                backup.Action = SQLDMO_BACKUP_TYPE.SQLDMOBackup_Database;
                backup.Database = this.serverDataSource.DataBase;
                BackUpStruct backUpConfig = this.backUpConfig.GetBackUpConfig();
                string dateShortString = DateUtil.GetDateShortString(DateTime.Now);
                backUpConfig.fileName = dateShortString + ".BAK";
                string str2 = backUpConfig.backUpPath + @"\" + dateShortString + ".BAK";
                backUpConfig.backUpPath = str2;
                backup.Files = str2;
                backup.BackupSetName = this.serverDataSource.DataBase;
                backup.BackupSetDescription = "数据库备份";
                backup.Initialize = true;
                backup.SQLBackup(serverObject);
                struct3 = backUpConfig;
            }
            catch (Exception exception)
            {
                throw exception;
            }
            return struct3;
        }

        public override void Restore(string fileName)
        {
            try
            {
                SQLDMO.Restore restore = new RestoreClass();
                SQLServer serverObject = new SQLServerClass {
                    LoginSecure = false
                };
                serverObject.Connect(this.serverDataSource.ServerIp, this.serverDataSource.UserId, this.serverDataSource.Password);
                restore.Action = SQLDMO_RESTORE_TYPE.SQLDMORestore_Database;
                restore.Database = this.serverDataSource.DataBase;
                BackUpStruct backUpConfig = this.backUpConfig.GetBackUpConfig();
                restore.Files = fileName;
                restore.ReplaceDatabase = true;
                restore.FileNumber = 1;
                restore.SQLRestore(serverObject);
            }
            catch (Exception exception)
            {
                throw exception;
            }
        }
    }
}

