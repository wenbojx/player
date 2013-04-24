package com.yiluhao.panotools;

import android.os.Bundle;

import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.animation.Animation;
import android.view.animation.RotateAnimation;
import android.widget.Button;
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
    
    private  Button serviceStart = null;
    private  Button serviceEnd = null;
    
    private TextView longitudeValue= null;
    private TextView latitudeValue= null;
    private TextView degreeValue= null;
    private TextView altitudeValue= null;
    private TextView timeValue = null;
    
    private ImageView imageView;
	private float currentDegree = 0f;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		
		serviceStart = (Button)findViewById(R.id.serviceStart);
		serviceStart.setOnClickListener(new StartOnClickListener());
		serviceEnd = (Button)findViewById(R.id.serviceEnd);
		serviceEnd.setOnClickListener(new EndOnClickListener());
		
		imageView = (ImageView) findViewById(R.id.imageview);
		
		longitudeValue = (TextView)findViewById(R.id.longitude);
		latitudeValue = (TextView)findViewById(R.id.latitude);
		altitudeValue = (TextView)findViewById(R.id.altitude);
		degreeValue = (TextView)findViewById(R.id.degree);
		timeValue = (TextView)findViewById(R.id.time);
		
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
	public class MyReceiver extends BroadcastReceiver {

        @Override
        public void onReceive(Context context, Intent intent) {
            
            Bundle bundle = intent.getExtras();
            id = bundle.getInt("id");
            String degreeStr = bundle.getString("degree");
            longitude = bundle.getDouble("longitude");
            latitude = bundle.getDouble("latitude");
            altitude = bundle.getString("altitude");
            time = bundle.getString("time");
            Log.v("degree", degree+"-"+longitude+"-"+latitude);
            longitudeValue.setText(longitude+"");
            latitudeValue.setText(latitude+"");
            altitudeValue.setText(altitude+"");
            degreeValue.setText(degreeStr);
            timeValue.setText(time+"");
           // rotateAnimation(degree);
        }       
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
		imageView.startAnimation(ra); 
		
		currentDegree = -degree;
		//Log.v("current2", currentDegree+"");
	}
	
	private class StartOnClickListener implements OnClickListener
    {
		@Override
		public void onClick(View v) {
			// TODO Auto-generated method stub
			Intent intent = new Intent();
            //跳转到service用startService，以前跳转到activity用的是startactivity
            intent.setClass(MainActivity.this, GpsInfoService.class);
            //启动service
            startService(intent);
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

}