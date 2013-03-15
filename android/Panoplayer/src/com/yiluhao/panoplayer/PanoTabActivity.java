package com.yiluhao.panoplayer;


import org.json.JSONException;
import org.json.JSONObject;

import com.loopj.android.http.AsyncHttpClient;
import com.loopj.android.http.AsyncHttpResponseHandler;
import com.yiluhao.utils.IoUtil;

import android.app.TabActivity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.TabHost;
import android.widget.Toast;
import android.widget.RadioGroup.OnCheckedChangeListener;
public class PanoTabActivity extends TabActivity implements OnCheckedChangeListener{
	private RadioGroup mainTab;
	private TabHost tabhost;
	private Intent iHome;
	private Intent iInfor;
	private Intent iMap;
	private Intent iSet;
	private String domain = "http://mb.yiluhao.com/";
	private IoUtil ioUtil=null;
	private AsyncHttpClient client=null;
	private String projectInfoUrl  = "";
	private String project_id = "1001";
	private String level = "0";
	
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        //requestWindowFeature(Window.FEATURE_NO_TITLE);
        Intent intent = getIntent();
		Bundle extras = intent.getExtras();
		SharedPreferences userInfo = getSharedPreferences("projectInfo", 0);  
        project_id = userInfo.getString("project_id", "");  
        
		if (extras != null) {
			project_id = extras.getString("id");
		}
		//Log.v("PROJECT panotab", project_id+"tab");
		
		ioUtil = new IoUtil();
		client = new AsyncHttpClient();
		
        setContentView(R.layout.pano_tab);
        getPanosData();
    }
    
    /**
	 * 获取项目文件数据
	 * 
	 * @return
	 */
	private void getPanosData() {
		SharedPreferences userInfo = getSharedPreferences("projectInfo", 0);  
        level = userInfo.getString("level", "");  
        if(level != "2"){
			String response = null;
			projectInfoUrl = domain+"ajax/m/pl/id/"+project_id;
	
			client.get(projectInfoUrl, new AsyncHttpResponseHandler() {
			    @Override
			    public void onSuccess(String response) {
			    	if(response =="" || response == null){
			    		return ;
			    	}
			    	ioUtil.SaveStringToSD(project_id, projectInfoUrl, response);
			        ExtractProjectDatas(response);
			       // Log.v("level", "!2");
			        
			        display();
			        return ;
			    }
			    public void onFailure(Throwable error, String content){
			    	//getWrong("没有网络连接");
			    	display();
			    }
			});
        }
        else{
        	setLevel("2");
        	display();
        }
		return ;
		
	}
	private void display(){
		this.mainTab=(RadioGroup)findViewById(R.id.pano_tab);
		this.mainTab.setOnCheckedChangeListener(this);
		this.tabhost = getTabHost();
        
		this.iHome = new Intent(this, PanoListActivity.class);
        Bundle bundle_home = new Bundle();  
        bundle_home.putString("id", project_id);  
        this.iHome.putExtras(bundle_home);
        this.tabhost.addTab(tabhost.newTabSpec("iHome")
        		.setIndicator(getResources().getString(R.string.pano_home), getResources().getDrawable(R.drawable.icon_pano_home))
        		.setContent(iHome));
        
        this.iInfor = new Intent(this, PanoInfoActivity.class);
		Bundle bundle_infor = new Bundle();  
		bundle_infor.putString("id", project_id);  
		this.iInfor.putExtras(bundle_infor);
		this.tabhost.addTab(tabhost.newTabSpec("iInfor")
	        	.setIndicator(getResources().getString(R.string.pano_info), getResources().getDrawable(R.drawable.icon_pano_about))
	        	.setContent(iInfor));

		this.iMap = new Intent(this, ProjectMapActivity.class);
		Bundle bundle_map = new Bundle();  
		bundle_map.putString("id", project_id);  
		this.iMap.putExtras(bundle_map);
		this.tabhost.addTab(tabhost.newTabSpec("iMap")
	        	.setIndicator(getResources().getString(R.string.pano_map), getResources().getDrawable(R.drawable.icon_pano_map))
	        	.setContent(iMap));
		//Log.v("level", level+"aaaa");
		if(level.equals("0") || level.equals("")){
			
			this.iSet = new Intent(this, SettingActivity.class);
			Bundle bundle_iset = new Bundle();  
			//bundle_infor.putString("id", project_id);  
			this.iSet.putExtras(bundle_iset);
			this.tabhost.addTab(tabhost.newTabSpec("iSet")
		        	.setIndicator(getResources().getString(R.string.pano_info), getResources().getDrawable(R.drawable.icon_pano_set))
		        	.setContent(iSet));
		}
		else{
			Log.v("level", level);
			if(level.equals("1")){
				getWrong("您使用的是测试账号，付费后该提示不显示");
			}
			RadioButton set_bt = (RadioButton)this.findViewById(R.id.pano_set_tab);
			set_bt.setVisibility(View.GONE);
		}
	}
	private void ExtractProjectDatas(String response){
		if (response == "" || response == null) {
			getWrong("获取项目信息失败，请检查您的网络设置");
			return ;
		}
		try {
			JSONObject jsonObject = new JSONObject(response);
			this.level = jsonObject.getString("level");
			setLevel(this.level);
			//Log.v("levelsss", level);
			
		} catch (JSONException e) {
			throw new RuntimeException(e);
		}
		return ;
	}
	/**
	 * 错误提示
	 */
	private void getWrong(String msg){
		Toast.makeText(this, msg, Toast.LENGTH_LONG)
		.show();
	}
	@Override
	public void onCheckedChanged(RadioGroup group, int checkedId) {
		switch(checkedId){
		case R.id.pano_home_tab:
			this.tabhost.setCurrentTabByTag("iHome");
			break;
		case R.id.pano_info_tab:
			this.tabhost.setCurrentTabByTag("iInfor");
			break;
		case R.id.pano_map_tab:
			this.tabhost.setCurrentTabByTag("iMap");
			break;
		case R.id.pano_set_tab:
			this.tabhost.setCurrentTabByTag("iSet");
			break;
		
		}
		
	}
	private void setLevel(String num){
		//Log.v("num", num);
    	SharedPreferences preferences  = getSharedPreferences("projectInfo", Context.MODE_PRIVATE);
		Editor edit = preferences.edit();
		edit.putString("level", num);
		edit.commit();
    }
}