package com.dozip.utils;

public class UploadPath {

//#hochul home PC
//# uploadPath=D:\\workspace\\dozip\\src\\main\\resources\\static\\upload\\
//# hochul laptop PC
// ploadPath=C:\\workspace\\dozip\\src\\main\\resources\\static\\upload\\
//#Yangjihye upload Path
//#uploadPath =C:\\DEV\\IntelliJ_work\\dozip\\src\\main\\resources\\static\\upload\\
//#minwoo photo path
//#uploadPath = C:\\bootcamp\\project\\dozip\\src\\main\\resources\\static\\upload\\
//#uploadPath=C:\\DoZip\\src\\main\\resources\\static\\upload\\
    private String uploadpath="C:\\workspace\\dozip\\src\\main\\resources\\static\\upload\\";
    public String getPath(){
         this.uploadpath = uploadpath;
        return uploadpath;
    }
}
