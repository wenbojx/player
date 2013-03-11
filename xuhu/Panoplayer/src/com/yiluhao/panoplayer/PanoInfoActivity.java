package com.yiluhao.panoplayer;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.webkit.WebView;

public class PanoInfoActivity extends Activity {

	private String project_id = "";
	private String projectInfo = "";
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.pano_info);
		Intent intent = getIntent();
		Bundle extras = intent.getExtras();
		if (extras != null) {
			project_id = extras.getString("id");
		}
		
		WebView webView= (WebView) this.findViewById(R.id.pano_info_detail);
		//WebSettings wSet = webView.getSettings();     
        //wSet.setJavaScriptEnabled(true);     
                     
        webView.loadUrl("file:///android_asset/info.html");
		
	}
	
}