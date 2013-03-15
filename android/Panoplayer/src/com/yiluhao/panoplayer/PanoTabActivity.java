package com.yiluhao.panoplayer;


import android.app.TabActivity;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.util.Log;
import android.widget.RadioGroup;
import android.widget.TabHost;
import android.widget.RadioGroup.OnCheckedChangeListener;
public class PanoTabActivity extends TabActivity implements OnCheckedChangeListener{
	private RadioGroup mainTab;
	private TabHost tabhost;
	private Intent iHome;
	private Intent iInfor;
	private Intent iMap;
	private Intent iSet;
	
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        //requestWindowFeature(Window.FEATURE_NO_TITLE);
        Intent intent = getIntent();
		Bundle extras = intent.getExtras();
		SharedPreferences userInfo = getSharedPreferences("projectInfo", 0);  
        String project_id = userInfo.getString("project_id", "");  
        
		if (extras != null) {
			project_id = extras.getString("id");
		}
		Log.v("PROJECT panotab", project_id+"tab");
		
        setContentView(R.layout.pano_tab);
        mainTab=(RadioGroup)findViewById(R.id.pano_tab);
        mainTab.setOnCheckedChangeListener(this);
        tabhost = getTabHost();
        
        iHome = new Intent(this, PanoListActivity.class);
        Bundle bundle_home = new Bundle();  
        bundle_home.putString("id", project_id);  
		iHome.putExtras(bundle_home);
        tabhost.addTab(tabhost.newTabSpec("iHome")
        		.setIndicator(getResources().getString(R.string.pano_home), getResources().getDrawable(R.drawable.icon_pano_home))
        		.setContent(iHome));
        
		iInfor = new Intent(this, PanoInfoActivity.class);
		Bundle bundle_infor = new Bundle();  
		bundle_infor.putString("id", project_id);  
		iInfor.putExtras(bundle_infor);
		tabhost.addTab(tabhost.newTabSpec("iInfor")
	        	.setIndicator(getResources().getString(R.string.pano_info), getResources().getDrawable(R.drawable.icon_pano_about))
	        	.setContent(iInfor));

		iMap = new Intent(this, ProjectMapActivity.class);
		Bundle bundle_map = new Bundle();  
		bundle_map.putString("id", project_id);  
		iMap.putExtras(bundle_map);
		tabhost.addTab(tabhost.newTabSpec("iMap")
	        	.setIndicator(getResources().getString(R.string.pano_map), getResources().getDrawable(R.drawable.icon_pano_map))
	        	.setContent(iMap));
		
		iSet = new Intent(this, SettingActivity.class);
		Bundle bundle_iset = new Bundle();  
		//bundle_infor.putString("id", project_id);  
		iInfor.putExtras(bundle_iset);
		tabhost.addTab(tabhost.newTabSpec("iSet")
	        	.setIndicator(getResources().getString(R.string.pano_info), getResources().getDrawable(R.drawable.icon_pano_set))
	        	.setContent(iSet));
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
}