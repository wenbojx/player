package com.yiluhao.panoplayer;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;


import android.os.Bundle;

public class LoginActivity extends Activity {
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.login);
		this.saveInfo();
	}
	
    private void saveInfo(){
    	SharedPreferences preferences  = getSharedPreferences("projectInfo", Context.MODE_PRIVATE);
		Editor edit = preferences.edit();
		edit.putString("project_id", "1003");
		edit.commit();
    }
}
