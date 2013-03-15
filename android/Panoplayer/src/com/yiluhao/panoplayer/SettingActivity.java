package com.yiluhao.panoplayer;

import com.yiluhao.utils.IoUtil;

import android.app.Activity;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;


import android.os.Bundle;
import android.os.Handler;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

public class SettingActivity extends Activity {
	private Button bt;
	private EditText et;
	private String domain = "http://mb.yiluhao.com/";
	private String projectInfoUrl  = "";
	private String project_id = "";
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.setting);
		bt=(Button)findViewById(R.id.setting_bt);
		et=(EditText)findViewById(R.id.set_project_id);
		et.clearFocus(); 
		SharedPreferences userInfo = getSharedPreferences("projectInfo", 0);  
        project_id = userInfo.getString("project_id", "");  
        if(project_id != null){
        	et.setText(project_id);
        }
        projectInfoUrl = domain+"ajax/m/pl/id/"+project_id;
		bt.setOnClickListener(onclick);
	}
	OnClickListener onclick =new OnClickListener(){
		 
		@Override
		public void onClick(View v) {
			// TODO Auto-generated method stub
			String project_id= et.getText().toString();
			setInfo(project_id);
			
			getWrong("设置成功,3秒后应用将自动刷新");
			rm_file();
			//点Button后,TextView显示输入的字符串
			new Handler().postDelayed(new Runnable(){    
			    public void run() {    
			    	restart();
			    }    
			 }, 3000);
			
		}
 
    };
    private void rm_file(){
    	IoUtil ioUtil = new IoUtil();
    	ioUtil.DelFile(project_id, projectInfoUrl);
    	
    }
    private void restart(){
    	Intent intent = new Intent(this, WelcomeActivity.class);  
        startActivity(intent);
    }
    /**
	 * 错误提示
	 */
	private void getWrong(String msg){
		Toast.makeText(this, msg, Toast.LENGTH_LONG)
		.show();
	}
    private void setInfo(String project_id){
    	SharedPreferences preferences  = getSharedPreferences("projectInfo", Context.MODE_PRIVATE);
		Editor edit = preferences.edit();
		edit.putString("project_id", project_id);
		edit.commit();
		//Log.v("pro", project_id);
    }
}