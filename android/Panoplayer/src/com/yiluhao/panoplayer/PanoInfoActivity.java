package com.yiluhao.panoplayer;

import java.net.URLEncoder;
import org.json.JSONException;
import org.json.JSONObject;

import com.loopj.android.http.AsyncHttpClient;
import com.loopj.android.http.AsyncHttpResponseHandler;
import com.yiluhao.utils.IoUtil;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.webkit.WebView;
import android.widget.Toast;


public class PanoInfoActivity extends Activity {

	private String project_id = "";
	final String mimeType = "text/html";  
	 
	final String encoding = "UTF-8"; 
	private String domain = "http://mb.yiluhao.com/";
	private IoUtil ioUtil=null;
	private AsyncHttpClient client=null;
	private String projectInfoUrl  = "";
	private String content = "";
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.pano_info);
		Intent intent = getIntent();
		Bundle extras = intent.getExtras();
		if (extras != null) {
			project_id = extras.getString("id");
		}
		ioUtil = new IoUtil();
		client = new AsyncHttpClient();
		getPanosData();
	}
	/**
	 * 获取项目文件数据
	 * 
	 * @return
	 */
	private void getPanosData() {
		
		String response = null;
		projectInfoUrl = domain+"ajax/m/pl/id/"+project_id;
    	if( ioUtil.FileExists(project_id, projectInfoUrl)){
			Log.v("infoCached=", "cached");
			response = ioUtil.ReadStringFromSD(project_id, projectInfoUrl);
	        ExtractProjectDatas(response);
	        display();
	        return ;
		}
		client.get(projectInfoUrl, new AsyncHttpResponseHandler() {
		    @Override
		    public void onSuccess(String response) {
		    	if(response =="" || response == null){
		    		return ;
		    	}
		    	ioUtil.SaveStringToSD(project_id, projectInfoUrl, response);
		        ExtractProjectDatas(response);
		        
		        display();
		        return ;
		    }
		    public void onFailure(Throwable error, String content){
		    	getWrong("没有网络连接");
		    }
		});
		return ;
		
	}
	public void display(){
		Log.v("content", content);
		//content += "<br><p>技术支持</p>";
		//content = "中文死定了福建省打开";
		WebView webView= (WebView) this.findViewById(R.id.pano_info_detail);
		webView.getSettings().setDefaultTextEncodingName(encoding);
		
		try {  
		webView.loadData(content, mimeType, encoding); 
		} catch (Exception ex) {
			 
			ex.printStackTrace();  
			 
			}  
	}
	/**
	 * 错误提示
	 */
	private void getWrong(String msg){
		Toast.makeText(this, msg, Toast.LENGTH_LONG)
		.show();
	}
	private void ExtractProjectDatas(String response){
		Log.v("aaaaaa", content);
		if (response == "" || response == null) {
			getWrong("获取项目信息失败，请检查您的网络设置");
			return ;
		}
		try {
			JSONObject jsonObject = new JSONObject(response);
			this.content = jsonObject.getString("info");
			
		} catch (JSONException e) {
			throw new RuntimeException(e);
		}
		return ;
	}
}