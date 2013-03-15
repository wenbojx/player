package com.yiluhao.panoplayer;

//import java.io.IOException;


//import com.yiluhao.utils.IoUtil;

import android.app.Activity;

import android.content.Intent;
import android.content.SharedPreferences;

import android.os.Bundle;
import android.util.Log;
//import android.os.Handler;
//import android.util.Log;
import android.view.KeyEvent;
import android.view.Window;
import android.view.WindowManager;
import android.view.animation.Animation;
import android.view.animation.Animation.AnimationListener;
import android.view.animation.AnimationUtils;
import android.widget.ImageView;

public class WelcomeActivity extends Activity implements AnimationListener {  
	
    private ImageView  imageView = null;  
    private Animation alphaAnimation = null;  
    //private String configStr = "";
    //private final Handler mHandler = new Handler();  
      
    @Override  
    protected void onCreate(Bundle savedInstanceState) {  
        super.onCreate(savedInstanceState);  
		
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
                WindowManager.LayoutParams.FLAG_FULLSCREEN);

        setContentView(R.layout.welcome);  
        imageView = (ImageView)findViewById(R.id.welcome_image_view);  
        alphaAnimation = AnimationUtils.loadAnimation(this, R.layout.welcome_alpha);
        alphaAnimation.setFillEnabled(true); //启动Fill保持  
        alphaAnimation.setFillAfter(true);  //设置动画的最后一帧是保持在View上面  
        imageView.setAnimation(alphaAnimation);  
        alphaAnimation.setAnimationListener(this);  //为动画设置监听  
    }  
    @Override  
    public void onAnimationStart(Animation animation) {  
    	/*
    	mHandler.postDelayed(new Runnable() {  
            @Override  
            public void run() {  
            	
            	String fileName = "/projects.cfg";
        		Integer type = 1;
        		String id = "0";
        		IoUtil ioutil = new IoUtil();
        		try{
        			configStr = ioutil.ReadStringFromWeb(fileName, type, id);
        		}catch (IOException e){
        			e.printStackTrace();
        		}
            }  
        }, 1000);  
        */
    }  
      
    @Override  
    public void onAnimationEnd(Animation animation) { 
    	SharedPreferences userInfo = getSharedPreferences("projectInfo", 0);  
        String project_id = userInfo.getString("project_id", "");  
        Log.v("project_id", project_id);
        //Log.v("asdfsdf", "sdfsdfsdfsdfsdf");
        //project_id = "1003";
    	if(project_id == null || project_id.equals("")){
    		Intent intent = new Intent(this, SettingActivity.class);
	        startActivity(intent);
	        this.finish();
    	}
    	else{
	        //动画结束时结束欢迎界面并转到软件的主界面  
	        Intent intent = new Intent(this, PanoTabActivity.class);  
	        startActivity(intent);
	        this.finish();
    	}
    }  
      
    @Override  
    public void onAnimationRepeat(Animation animation) {  
    	
    }  
      
    @Override  
    public boolean onKeyDown(int keyCode, KeyEvent event) {  
        //在欢迎界面屏蔽BACK键  
        if(keyCode==KeyEvent.KEYCODE_BACK) {  
            return false;  
        }  
        return false;  
    }  
      
}  
