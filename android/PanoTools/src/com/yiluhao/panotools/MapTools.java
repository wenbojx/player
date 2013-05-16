package com.yiluhao.panotools;

import android.util.Log;

public class MapTools {
	FileDatas fileDatasObj = null;
	
	public String[] getGPSinfo(String fileName){
		if(fileName == null || fileName == ""){
			return null;
		}
		//获取文件内容
		fileDatasObj = new FileDatas();
		String content = fileDatasObj.GetStringFromSD(fileName);
		if(content==null || content ==""){
			return null;
		}
		String[] locationList = SplitContent(content);
		if(locationList == null || locationList.length<1){
			return null;
		}
		int secend = 10; //相隔秒数
		int num = (locationList.length%secend==0)?locationList.length/secend:(locationList.length/secend+1);
		String[] locations = new String[num];
		int j=0;
		for(int i=0; i<(locationList.length-1); i++){
			if(i%secend == 0){
				String locationStr = locationList[i];
				String[] splitStr = locationStr.split("\\|");
				if(j<num){
					locations[j] = splitStr[1]+","+splitStr[2];
				}
				j++;
			}
		}
		return locations;
	}
	//分割数据
	public String[] SplitContent(String content){
		if(content == null){
			return null;
		}
		String[] locationList = content.split(";");
		return locationList;
	}
}
