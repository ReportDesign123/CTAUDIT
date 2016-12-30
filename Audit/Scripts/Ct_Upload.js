/// <reference path="../lib/jquery/jquery-1.11.1.min.js" />

var upLoadFileManager = {
    FileNumber: 1,
    AddUploadFile: function () {
        upLoadFileManager.FileNumber++;
        $("#upTable").append('<tr id="tr' + upLoadFileManager.FileNumber + '" ><td><input type="file" name="file' + upLoadFileManager.FileNumber + '"  style=" width:170px; "/> &nbsp;<input type="button" onclick="upLoadFileManager.AddUploadFile()" value="添加"/>&nbsp;<input type="button" onclick="upLoadFileManager.DeleteUploadFile(' + upLoadFileManager.FileNumber + ')" value="删除" /></td></tr>');
    },
    DeleteUploadFile: function (index) {
        $("#tr" + index).remove();
    }
};