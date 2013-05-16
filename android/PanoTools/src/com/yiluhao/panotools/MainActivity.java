package com.yiluhao.panotools;

import java.text.SimpleDateFormat;

import java.util.Date;

import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.SupportMapFragment;
import com.google.android.gms.maps.model.BitmapDescriptor;
import com.google.android.gms.maps.model.BitmapDescriptorFactory;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.Marker;
import com.google.android.gms.maps.model.MarkerOptions;
import com.google.android.gms.maps.model.Polyline;
import com.google.android.gms.maps.model.PolylineOptions;

import android.os.Bundle;
import android.os.Handler;
import android.os.Message;


import android.support.v4.app.FragmentActivity;
import android.text.format.Time;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.animation.Animation;
import android.view.animation.RotateAnimation;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Color;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;

import com.yiluhao.panotools.MapActivity;

@SuppressLint("SetJavaScriptEnabled")
public class MainActivity extends Activity implements SensorEventListener {
	MyReceiver receiver;
	
	double longitude = 0;
    double latitude = 0;
    String altitude = "";
    String speed = "0.0";
    float degree = 0f;
    String time = "";
    int id = 0;
    boolean startItemOn = false; //开始按钮点击情况
    boolean pauseItemOn = false;
    boolean stopItemOn = false;
    boolean mapItemOn = false;
    boolean isWaitPosition = true;//等待定位
    String serviceState = "";
    //private String savePath = "";
    
    private RelativeLayout infoView = null;
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
    private TextView speedValue = null;
    
    private TextView tipMsg = null;
    
    private ImageView imageCompass;
	private float currentDegree = 0f;
	private boolean getWrongOnce = false;
	private String[] locations = new String[1000];
	private int lastPolyKey = 0; //最后一个线条点的位置
	private double currentLongitude = 0; //当前维度
	private double currentLatitude = 0; //当前经度
	private double startLat = 0;
	private double startLng = 0;
	private int maxcount = 0;
	private boolean firstClickMap = true;
	private boolean isStartPosition = true;
	private Marker lastmMarker; //地图标点
	private boolean isStartMarker = true;
	private String fileName = "";
	//private double startLat = 0;
	//private double startLng = 0;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		//requestWindowFeature(Window.FEATURE_NO_TITLE);
		setContentView(R.layout.main);
		
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
		speedValue = (TextView)findViewById(R.id.speed);
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
        infoView = (RelativeLayout) findViewById(R.id.infoView);
        
        updateDate();

	}
	
	
	public void changeItemIcon(String item){
		if(item.equals("start")){
			serviceStart.setImageResource(R.drawable.start_on);
			servicePause.setImageResource(R.drawable.pause);
			serviceStop.setImageResource(R.drawable.stop);
			pauseItemOn = false;
			startItemOn = true;
			stopItemOn = false;
			getWrongOnce = false;
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
			
			longitudeValue.setText(R.string.longitudeValNull);
			latitudeValue.setText(R.string.latitudeValNull);
			altitudeValue.setText(R.string.altitudeValNull);
			degreeValue.setText(R.string.degreeValNull);
			speedValue.setText(R.string.degreeValNull);
			tipMsg.setText(R.string.tipMsgNotStart);
		}
		else if(item.equals("map")){
			if(mapItemOn){
				serviceMap.setImageResource(R.drawable.map);
				mapItemOn = false;
				//mapLayoutView.setVisibility(View.GONE);
				//infoView.setVisibility(View.VISIBLE);
			}
			else{
				serviceMap.setImageResource(R.drawable.map_on);
				mapItemOn = true;
				//mapLayoutView.setVisibility(View.VISIBLE);
				//infoView.setVisibility(View.GONE);
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

			Intent intent=new Intent();
			intent.putExtra("state", "pause");
			intent.setAction("com.yiluhao.panotools.GpsInfoService");//action与接收器相同
			sendBroadcast(intent);
			
            changeItemIcon("pause");
		}       
    }
	private void startMapActivity() {
		Intent intent = new Intent(this, MapActivity.class);

		Bundle bundle = new Bundle();
		bundle.putString("currentLat", currentLatitude+"");
		bundle.putString("currentLng", currentLongitude+"");
		bundle.putString("fileName", fileName+"");
		intent.putExtras(bundle);

		startActivity(intent);
	}
	private class MapOnClickListener implements OnClickListener
    {
		@Override
		public void onClick(View v) {
			startMapActivity();
			/*
			if(firstClickMap){
				setupWebView();
				firstClickMap = false;
				markMap(startLat, startLng, 1);
			}
			else{
				drawMapLine();
				markMap(currentLatitude, currentLongitude, 3);
			}
			*/
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

	/**
	 * 错误提示
	 */
	private void getWrong(String msg){
		Toast.makeText(this, msg, Toast.LENGTH_LONG)
		.show();
	}
	private void addPloy(double lat, double lng){
		Log.v("lat-lng=", lat+"-"+lng);
		if(maxcount>1000){
			maxcount = 0;
		}
		String latlng = lat+","+lng;
		locations[maxcount] = latlng;
		maxcount++;
		
	}
	private String[] getPloys(){
		int num = maxcount-1;
		if(num<1){
			return new String[1];
		}
		String[] currentLocations = new String[num];
			for(int i=lastPolyKey; i<(maxcount-1); i++){
				Log.v("i=", i+"="+locations[i]);
				currentLocations[i] = locations[i];
				lastPolyKey = i;
			}

		return currentLocations;
	}
	
	public class MyReceiver extends BroadcastReceiver {

        @Override
        public void onReceive(Context context, Intent intent) {
            Bundle bundle = intent.getExtras();
            String degreeStr = bundle.getString("degree");
            longitude = bundle.getDouble("longitude");
            latitude = bundle.getDouble("latitude");
            altitude = bundle.getString("altitude");
            speed = bundle.getString("speed");
            time = bundle.getString("time");
            serviceState = bundle.getString("state");
            fileName = bundle.getString("file");
            
            int isDrawLine = bundle.getInt("isDrawLine");
            
            if(isDrawLine == 1 && latitude!=0){
            	addPloy(latitude, longitude);
            }
            //gps关闭时显示
            if(serviceState.equals("Disabled")){
            	tipMsg.setText(R.string.gpsDisabled);
            	if(!getWrongOnce){
            		getWrong(getResources().getString(R.string.gpsDisabled));
            		getWrongOnce = true;
            	}
            	changeItemIcon("stop");
            	return ;
            }
            if(serviceState.equals("start") && !startItemOn){
            	changeItemIcon("start");
            }
            if( longitude == 0 ){
            	tipMsg.setText(R.string.tipMsgWait);
            	recordingBt.setImageResource(R.drawable.icon_yerrow);
            }
            else{
            	tipMsg.setText(R.string.tipMsgAbout);
            	isWaitPosition = false;
            }
            
            currentLongitude = longitude; //当前维度
        	currentLatitude = latitude; //当前经度
        	
            speedValue.setText(speed+getResources().getString(R.string.speedValAdd));
            longitudeValue.setText(longitude+"");
            latitudeValue.setText(latitude+"");
            altitudeValue.setText(altitude+getResources().getString(R.string.altitudeValAdd));
            degreeValue.setText(degreeStr);
            timeValue.setText(time+"");
            if(!isWaitPosition){
	            id++;
	            if( id%2==0 ){
	            	recordingBt.setImageResource(R.drawable.icon_gray);
	            }
	            else{
	            	recordingBt.setImageResource(R.drawable.icon_green);
	            }
            }
            if(pauseItemOn){
            	recordingBt.setImageResource(R.drawable.icon_yerrow);
            }
           // rotateAnimation(degree);
        }       
    }
	
	public void updateDate(){
		final Handler handler = new Handler() {
			@Override
			public void handleMessage(Message msg) {
				timeValue.setText((String) msg.obj);
			}
		};
    	new Thread(){//新建线程，每隔1秒发送一次广播，同时把i放进intent传出
			@SuppressLint("SimpleDateFormat")
			public void run(){
				Time time = new Time("GMT+8");
				while(!startItemOn){
			        SimpleDateFormat formatter = new SimpleDateFormat ("HH:mm:ss"); 
			        long timeInt = System.currentTimeMillis();
			        Date curDate = new Date(timeInt);//获取当前时间       
			        String currentTime = formatter.format(curDate);  
			        
			        Message msg = handler.obtainMessage(0, currentTime);
					handler.sendMessage(msg);
					
					try {
						sleep(1000);
					} catch (InterruptedException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
				
			}
		}.start();
		
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