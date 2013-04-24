package com.yiluhao.panotools;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;


import java.util.Date;

import android.os.Bundle;
import android.os.IBinder;
import android.text.format.Time;
import android.util.Log;

import android.app.Service;
import android.content.Context;
import android.content.Intent;

import android.location.Criteria;
import android.location.Location;  
import android.location.LocationListener;  
import android.location.LocationManager;  

import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import com.yiluhao.panotools.SaveDatas;

//public class GpsInfoService extends Service{
public class GpsInfoService extends Service implements SensorEventListener {

    Location location;  
    LocationManager lm;  
    LocationListener locationListener;  
    
    double longitude = 0; //维度
    double latitude = 0; //经度
    double altitude = 0; //海拔
    float degree = 0; //角度
    float speed = 0; //速度
    
    
    public float currentDegree = 0f;
    
    Intent intent = new Intent();
    boolean isStop=false;
    SaveDatas saveDatasObj = null;
    String fileName = "geo.txt";
    
    @Override
    public IBinder onBind(Intent arg0) {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public void onCreate() {
        // TODO Auto-generated method stub
        super.onCreate();
        System.out.println("Service onCreate");
        initGeo(GpsInfoService.this);
        sendDatas();
    }

    //onStartCommand与onStart类似，多了一个参数而已
    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        // TODO Auto-generated method stub
        return super.onStartCommand(intent, flags, startId);
    }
    
    @Override
    public void onDestroy() {
        // TODO Auto-generated method stub
        super.onDestroy();
        System.out.println("Service onDestroy");
        isStop = true;
        removeLocation();
    }
    
    public void sendDatas(){
    	new Thread(){//新建线程，每隔1秒发送一次广播，同时把i放进intent传出
			public void run(){
				int id=1;
				Time time = new Time("GMT+8");
				while(!isStop){
			        
			        SimpleDateFormat formatter = new SimpleDateFormat ("yyyy/MM/dd/ HH:mm:ss");   
			        long timeInt = System.currentTimeMillis();
			        Date curDate = new Date(timeInt);//获取当前时间       
			        String timeValue = formatter.format(curDate);     

			        String altitudeStr = String.format("%.2f", altitude);
			        
			        String degreeStr = String.format("%.2f", degree);
			        
			        Log.v("altitude", altitudeStr+"");
			        
			        String content = id+"|";
			        content += latitude+"|";
			        content += longitude+"|";
			        content += altitudeStr+"|";
			        content += degreeStr+"|";
			        content += timeInt+";";
			        saveDatasObj = new SaveDatas();
			        if(	id ==1 ){
			        	fileName = timeInt+".geo";
			        }
			        saveDatasObj.SaveStringToSD(fileName, content);
			        
					Intent intent=new Intent();
					intent.putExtra("id", id);
					intent.putExtra("latitude", latitude);
					intent.putExtra("longitude", longitude);
					intent.putExtra("altitude", altitudeStr);
					intent.putExtra("degree", degreeStr);
					intent.putExtra("speed", speed);
					intent.putExtra("time", timeValue);
					
					id++;
					intent.setAction("android.intent.action.MAIN");//action与接收器相同
					sendBroadcast(intent);
					//Log.v("degree", degree+"");
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
    
    public void removeLocation(){
    	this.lm.removeUpdates(locationListener);
    }
    
    public void initGeo(Context mContext){
    	initSensor(mContext);
    	initLocation(mContext);
    }
    private void initSensor(Context mContext){
    	SensorManager sm = (SensorManager) mContext.getSystemService(mContext.SENSOR_SERVICE);
		//String noth = sm.getDefaultSensor(Sensor.TYPE_ORIENTATION).
		sm.registerListener(this, sm.getDefaultSensor(Sensor.TYPE_ORIENTATION),
				SensorManager.SENSOR_DELAY_FASTEST);
    }
    @Override
	public void onAccuracyChanged(Sensor sensor, int accuracy) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void onSensorChanged(SensorEvent event) {
		// TODO Auto-generated method stub
		if (event.sensor.getType() == Sensor.TYPE_ORIENTATION)
		{
			degree = event.values[0];
		}
	}
  
  //获取location对象  
    private void initLocation(Context mContext){  
    	//LocationManager locationManager;
        String serviceName = Context.LOCATION_SERVICE;
        lm = (LocationManager)getSystemService(serviceName);
        
        Criteria criteria = new Criteria();
        criteria.setAccuracy(Criteria.ACCURACY_FINE);
        criteria.setAltitudeRequired(true);
        //criteria.setBearingRequired(true);
        criteria.setSpeedRequired(true);
        criteria.setCostAllowed(true);
        criteria.setPowerRequirement(Criteria.POWER_LOW);
        String provider = lm.getBestProvider(criteria, true);
        
        location = lm.getLastKnownLocation(provider);
        locationListener = new LocationListener() {

			@Override
			public void onLocationChanged(Location location) {
				// TODO Auto-generated method stub
				updateLocation(location);
                Log.v("gps=", "LocationChanged");
			}

			@Override
			public void onProviderDisabled(String provider) {
				// TODO Auto-generated method stub
				Log.v("gps=", "Disabled");
			}

			@Override
			public void onProviderEnabled(String provider) {
				// TODO Auto-generated method stub
				Log.v("gps=", "Enabled");
			}

			@Override
			public void onStatusChanged(String provider, int status,
					Bundle extras) {
				// TODO Auto-generated method stub
				Log.v("gps=", "StatusChanged");
			}

        };
        lm.requestLocationUpdates(provider, 500, 0, locationListener);
        
        
    }  
    
 // 更新位置信息 展示到tv中  
    private void updateLocation(Location location) {  
        if (location != null) {  
        	longitude = location.getLongitude();
        	latitude = location.getLatitude();
        	altitude = location.getAltitude();
        	//degree = location.getBearing();
        	speed = location.getSpeed();
        	//Log.v("latitude", latitude+"");
            //如果已经获取到location信息 则在这里注销location的监听  
            //gps会在一定时间内自动关闭  
            //this.lm.removeUpdates(locationListener);  
        } else {  
        	Log.v("yao", "不能定位");
        }  
    }

    


}
