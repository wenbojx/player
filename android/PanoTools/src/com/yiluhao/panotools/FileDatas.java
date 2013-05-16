package com.yiluhao.panotools;


import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;

import org.apache.http.util.EncodingUtils;

import android.os.Environment;
import android.util.Log;

public class FileDatas {
	private String prefix = "geo";
	private final static String ALBUM_PATH = Environment
			.getExternalStorageDirectory() + "/yiluhao"; // Sd卡目录
	/**
	 * 获取文件地址
	 */
	private String GetFilePath(String fileName) {
		return ALBUM_PATH + "/" + prefix + "/" + fileName;
	}
	/**
	 * 自动创建不存在的目录
	 */
	private void AutoMakeDir() throws IOException {
		
		File dirFile = new File(ALBUM_PATH);
		if (!dirFile.exists()) {
			//Log.v("aaaa", ALBUM_PATH);
			dirFile.mkdir();
		}
		String path = ALBUM_PATH;
		path += "/" + prefix;
		dirFile = new File(path);
		
		if (!dirFile.exists()) {
			//Log.v("bbb", path);
			dirFile.mkdir();
		}
	}

	// 写文本数据
	public boolean SaveStringToSD(String fileName,
			String string) {
		if (string == "" || string == null) {
			return false;
		}
		
		BufferedWriter out = null;  
        try {  
        	AutoMakeDir();
    		String file = GetFilePath(fileName);
    		//Log.v("file=", file);
    		
    		File dirFile = new File(file);
            out = new BufferedWriter(new OutputStreamWriter(  
                    new FileOutputStream(file, true)));  
            //Log.v("saveDatas", string);
            out.write(string);  
        } catch (Exception e) {  
            e.printStackTrace();  
        } finally {  
            try {  
                out.close();  
            } catch (IOException e) {  
                e.printStackTrace();  
            }  
        }   
		return true;
	}
	//读文本数据
	public String GetStringFromSD(String fileName){
		String content = "";
		try {
			String file = GetFilePath(fileName);
			FileInputStream fin = new FileInputStream(file);
			int length = fin.available();
			byte[] buffer = new byte[length];
			fin.read(buffer);
			content = EncodingUtils.getString(buffer, "UTF-8");
			fin.close();
		} catch (IOException e) {
			Log.v("CONFIGURL", "read String faild");
			e.printStackTrace();
		}
		return content;
	}
}