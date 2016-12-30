using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AuditEntity;


namespace AuditSPI
{
    public  interface IUser
    {
        void Save(UserEntity userEntity);
        void Edit(UserEntity userEntity);
        void Delete(UserEntity userEntity);
        UserEntity Get(UserEntity userEntity);
        DataGrid<UserEntity> getDataGrid(DataGrid<UserEntity> dg,UserEntity user);
     
        UserEntity SingleLogin(UserEntity userEntity);
        UserEntity Login(UserEntity userEntity);
        void LoginOut(UserEntity userEntity);
        void SaveUserPassword(UserEntity userEntity);
    }
}
