package com.yiluhao.panotools;

import android.os.Bundle;

import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.animation.Animation;
import android.view.animation.RotateAnimation;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.TextView;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;

public class MainActivity extends Activity implements SensorEventListener {
	MyReceiver receiver;
	
	double longitude = 0;
    double latitude = 0;
    String altitude = "";
    float degree = 0f;
    String time = "";
    int id = 0;
    boolean startItemOn = false;
    boolean pauseItemOn = false;
    boolean stopItemOn = false;
    boolean mapItemOn = false;
    String serviceState = "";
    //private String savePath = "";
    
    private  ImageButton serviceStart = null;
    private  ImageButton serviceStop = null;
    private ImageButton servicePause = null;
    private ImageButton serviceMap = null;
    private ImageButton recordingBt = null;
    
    private TextView longitudeValue= null;
    private TextView latitudeValue= null;
    private TextView degreeValue= null;
    private TextView altitudeValue= null;
    private TextView timeValue = null;
    
    private TextView tipMsg = null;
    
    private ImageView imageCompass;
	private float currentDegree = 0f;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		
		serviceStart = (ImageButton)findViewById(R.id.bannerStart);
		serviceStart.setOnClickListener(new StartOnClickListener());
		
		serviceStop = (ImageButton)findViewById(R.id.bannerStop);
		serviceStop.setOnClickListener(new EndOnClickListener());
		
		servicePause = (ImageButton)findViewById(R.id.bannerPause);
		servicePause.setOnClickListener(new PauseOnClickListener());
		
		serviceMap = (ImageButton)findViewById(R.id.bannerMap);
		serviceMap.setOnClickListener(new MapOnClickListener());
		
		recordingBt = (ImageButton)findViewById(R.id.recording);

		imageCompass = (ImageView) findViewById(R.id.imageCompass);
		
		longitudeValue = (TextView)findViewById(R.id.longitude);
		latitudeValue = (TextView)findViewById(R.id.latitude);
		altitudeValue = (TextView)findViewById(R.id.altitude);
		degreeValue = (TextView)findViewById(R.id.degree);
		timeValue = (TextView)findViewById(R.id.time);
		tipMsg = (TextView)findViewById(R.id.tipMsg);
		
		receiver=new MyReceiver();
        //定义一个IntentFilter的对象，来过滤掉一些intent
        IntentFilter filter = new IntentFilter();
        //只接收发送到action为"android.intent.action.MAIN"的intent
        //"android.intent.action.MAIN"是在MainFest中定义的
        filter.addAction("android.intent.action.MAIN");
        //启动广播接收器
        MainActivity.this.registerReceiver(receiver, filter);
        
        initSensor(MainActivity.this);
        
	}
	
	
	public void changeItemIcon(String item){
		if(item.equals("start")){
			serviceStart.setImageResource(R.drawable.start_on);
			servicePause.setImageResource(R.drawable.pause);
			serviceStop.setImageResource(R.drawable.stop);
			pauseItemOn = false;
			startItemOn = true;
			stopItemOn = false;
			recordingBt.setVisibility(View.VISIBLE);
		}
		else if(item.equals("pause")){
			serviceStart.setImageResource(R.drawable.start);
			servicePause.setImageResource(R.drawable.pause_on);
			serviceStop.setImageResource(R.drawable.stop);
			pauseItemOn = true;
			startItemOn = false;
			stopItemOn = false;
			recordingBt.setImageResource(R.drawable.icon_yerrow);
		}
		else if(item.equals("stop")){
			serviceStart.setImageResource(R.drawable.start);
			servicePause.setImageResource(R.drawable.pause);
			serviceStop.setImageResource(R.drawable.stop_on);
			pauseItemOn = false;
			startItemOn = false;
			stopItemOn = true;
			recordingBt.setVisibility(View.GONE);
		}
		else if(item.equals("map")){
			if(mapItemOn){
				serviceMap.setImageResource(R.drawable.map);
				mapItemOn = false;
			}
			else{
				serviceMap.setImageResource(R.drawable.map_on);
				mapItemOn = true;
			}
		}
		
	}
	
	private class StartOnClickListener implements OnClickListener
    {
		@Override
		public void onClick(View v) {
			if(!pauseItemOn){
				// TODO Auto-generated method stub
				Intent intent = new Intent();
	            //跳转到service用startService，以前跳转到activity用的是startactivity
	            intent.setClass(MainActivity.this, GpsInfoService.class);
	            //启动service
	            startService(intent);
			}
			else{
				Intent intent=new Intent();
				intent.putExtra("state", "start");
				intent.setAction("com.yiluhao.panotools.GpsInfoService");//action与接收器相同
				sendBroadcast(intent);
			}
            changeItemIcon("start");
		}       
    }
	private class PauseOnClickListener implements OnClickListener
    {
		@Override
		public void onClick(View v) {
			if(stopItemOn){
				return ;
			}
			/*
            //跳转到service用startService，以前跳转到activity用的是startactivity
            intent.setClass(MainActivity.this, GpsInfoService.class);
            //启动service
            stopService(intent);
            */
			Intent intent=new Intent();
			intent.putExtra("state", "pause");
			intent.setAction("com.yiluhao.panotools.GpsInfoService");//action与接收器相同
			sendBroadcast(intent);
			
            changeItemIcon("pause");
		}       
    }
	private class MapOnClickListener implements OnClickListener
    {
		@Override
		public void onClick(View v) {
			// TODO Auto-generated method stub
			Intent intent = new Intent();
            //跳转到service用startService，以前跳转到activity用的是startactivity
            intent.setClass(MainActivity.this, GpsInfoService.class);
            //启动service
            //startService(intent);
            changeItemIcon("map");
		}       
    }
    private class EndOnClickListener implements OnClickListener
    {
        public void onClick(View v) {
            // TODO Auto-generated method stub
            Intent intent = new Intent();
            intent.setClass(MainActivity.this, GpsInfoService.class);
            //结束service
            stopService(intent);
            //savePath = "";
            changeItemIcon("stop");
        }       
    }

	@Override
	public void onAccuracyChanged(Sensor sensor, int accuracy) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void onSensorChanged(SensorEvent event) {
		if (event.sensor.getType() == Sensor.TYPE_ORIENTATION)
		{
			degree = event.values[0];
		}
		rotateAnimation(degree);
		
	}

	public class MyReceiver extends BroadcastReceiver {

        @Override
        public void onReceive(Context context, Intent intent) {
            Bundle bundle = intent.getExtras();
            String degreeStr = bundle.getString("degree");
            longitude = bundle.getDouble("longitude");
            latitude = bundle.getDouble("latitude");
            altitude = bundle.getString("altitude");
            time = bundle.getString("time");
            serviceState = bundle.getString("state");
            
            if(serviceState.equals("start") && !startItemOn){
            	changeItemIcon("start");
            	
            }
            if( longitude == 0 ){
            	tipMsg.setText("正在定位...");
            }
            else{
            	tipMsg.setText("敬请关注 http://www.yiluhao.com");
            }
            
            longitudeValue.setText(longitude+"");
            latitudeValue.setText(latitude+"");
            altitudeValue.setText(altitude+"");
            degreeValue.setText(degreeStr);
            timeValue.setText(time+"");
            id++;
            if( id%2==0 ){
            	recordingBt.setImageResource(R.drawable.icon_gray);
            }
            else{
            	recordingBt.setImageResource(R.drawable.icon_green);
            }
            if(pauseItemOn){
            	recordingBt.setImageResource(R.drawable.icon_yerrow);
            }
            
           // rotateAnimation(degree);
        }       
    }
	@Override
	protected void onDestroy() {
		this.unregisterReceiver(receiver);
		super.onDestroy();
	}
	private void initSensor(Context mContext){
    	SensorManager sm = (SensorManager) mContext.getSystemService(mContext.SENSOR_SERVICE);
		//String noth = sm.getDefaultSensor(Sensor.TYPE_ORIENTATION).
		sm.registerListener(this, sm.getDefaultSensor(Sensor.TYPE_ORIENTATION),
				SensorManager.SENSOR_DELAY_FASTEST);
    }

	public void rotateAnimation(float degree){
		//Log.v("current1", currentDegree+"-"+(-degree));
		RotateAnimation ra = new RotateAnimation(currentDegree, -degree,
				Animation.RELATIVE_TO_SELF, 0.5f,
				Animation.RELATIVE_TO_SELF, 0.5f);
		ra.setDuration(200);
		imageCompass.startAnimation(ra); 
		currentDegree = -degree;
		//Log.v("current2", currentDegree+"");
	}

}