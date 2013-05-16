package com.yiluhao.panotools;


import java.text.SimpleDateFormat;




import java.util.Date;

import android.os.Bundle;
import android.os.IBinder;
import android.text.format.Time;
import android.util.Log;

import android.app.Service;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;

import android.location.Criteria;
import android.location.Location;  
import android.location.LocationListener;  
import android.location.LocationManager;  

import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import com.yiluhao.panotools.FileDatas;

//public class GpsInfoService extends Service{
public class GpsInfoService extends Service implements SensorEventListener {

	private static double EARTH_RADIUS = 6378137.0;   
	MyReceiver receiver;
	
    Location location;  
    LocationManager lm;  
    LocationListener locationListener;  
    
    double longitude = 0; //维度
    double latitude = 0; //经度
    double altitude = 0; //海拔
    float degree = 0; //角度
    float GPSdegree = 0; //角度
    float speed = 0; //速度
    String serviceState = "start";
    
    public float currentDegree = 0f;
    
    //Intent intent = new Intent();
    boolean isStop=false;
    FileDatas fileDatasObj = null;
    //FileDatas fileDatasGuiObj = null;
    
    String fileName = "geo.txt";
    int secend = 0; //时间
    double lastlongitude = 0; //前几秒的维度
    double lastlatitude = 0; //前几秒的经度
    String speedStr = "0.0";
    int guijiTime = 1;
    
    @Override
    public IBinder onBind(Intent arg0) {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public void onCreate() {
        // TODO Auto-generated method stub
        super.onCreate();

    }
    @Override
    public void onStart(Intent intent, int startId){
    	
    }
    //onStartCommand与onStart类似，多了一个参数而已
    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        // TODO Auto-generated method stub
    	
    	System.out.println("Service onCreate");
    	
    	receiver=new MyReceiver();
        //定义一个IntentFilter的对象，来过滤掉一些intent
        IntentFilter filter = new IntentFilter();
        //只接收发送到action为"android.intent.action.MAIN"的intent
        //"android.intent.action.MAIN"是在MainFest中定义的
        filter.addAction("com.yiluhao.panotools.GpsInfoService");
        //启动广播接收器
        GpsInfoService.this.registerReceiver(receiver, filter);
        
        initGeo(GpsInfoService.this);
        sendDatas();
    	
        return super.onStartCommand(intent, flags, startId);
    }
    
    public class MyReceiver extends BroadcastReceiver {

        @Override
        public void onReceive(Context context, Intent intent) {
            Bundle bundle = intent.getExtras();
            serviceState = bundle.getString("state");
            //Log.v("serviceState", serviceState);
        }       
    }
    
    @Override
    public void onDestroy() {
        // TODO Auto-generated method stub
        super.onDestroy();
        System.out.println("Service onDestroy");
        isStop = true;
        this.unregisterReceiver(receiver);
        
        removeLocation();
    }
    
    public void sendDatas(){
    	new Thread(){//新建线程，每隔1秒发送一次广播，同时把i放进intent传出
			public void run(){
				int id=1;
				Time time = new Time("GMT+8");
				String content = "";
				
				while(!isStop){
					if( serviceState.equals("pause")){
						continue;
					}
			        SimpleDateFormat formatter = new SimpleDateFormat ("HH:mm:ss"); 
			        SimpleDateFormat formatterFile = new SimpleDateFormat ("yyyy-MM-dd-HH-mm-ss");
			        long timeInt = System.currentTimeMillis();
			        Date curDate = new Date(timeInt);//获取当前时间       
			        String timeValue = formatter.format(curDate);   

			        if(secend == 0){
			        	lastlongitude = longitude; //前几秒的维度
			            lastlatitude = latitude; //前几秒的经度
			        }
			        String recodeSpeedStr = "";
			        double distence = 0;
			        //int isDrawLine = distence>=0.1 ? 1:0;
			        int isDrawLine = 0;
			        //每15秒计算一次速度
			        if(secend >= 10){
			        	
			        	distence = GetDistance(lastlatitude, lastlongitude, latitude, longitude);
			        	isDrawLine = 1;
			        	//Log.v("distence", distence+"---");
			        	if(distence == 0){
			        		speedStr = "";
			        		recodeSpeedStr = "";
			        	}
			        	else{
			        		speed = ((float)distence)/(float)secend;
				        	speedStr = String.format("%.1f", speed);
				        	//Log.v("speed", speedStr);
				        	recodeSpeedStr = speedStr;
			        	}
			        	secend = 0;
			        }
			        else{
			        	secend++;
			        	recodeSpeedStr = "";
			        }
			        String altitudeStr = String.format("%.1f", altitude);
			        String degreeStr = String.format("%.1f", degree);
			        
			        
			        if( longitude != 0 && latitude!=0){
			        	content += timeValue+"|";
			        	content += latitude+"|";
				        content += longitude+"|";
				        content += recodeSpeedStr+"|";
				        content += altitudeStr+"|";
				        content += degreeStr+";";
		            }
			        
			        fileDatasObj = new FileDatas();
			        if(	id ==1 ){
				        	fileName = formatterFile.format(curDate);
				        	fileName = fileName+".geo";
			        }
			        if(id >= 7){
			        	fileDatasObj.SaveStringToSD(fileName, content);
			        	content = "";
			        	id = 2;
			        }
			        
			        /*
			        Log.v("distence", distence+"");
			        if(isDrawLine == 1){
			        	Log.v("distence", distence+"");
			        }
			        */
			        
			        if(speedStr == ""){
			        	speedStr = "0.0";
			        }
					Intent intent=new Intent();
					intent.putExtra("state", serviceState);
					intent.putExtra("latitude", latitude);
					intent.putExtra("longitude", longitude);
					intent.putExtra("altitude", altitudeStr);
					intent.putExtra("degree", degreeStr);
					intent.putExtra("speed", speedStr);
					intent.putExtra("time", timeValue);
					intent.putExtra("file", fileName);
					
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
    /*
    //每隔n秒记录一次轨迹信息
    private void recodeGuiJi(String fileName, double lat, double lng){
    	if(lat==0 || lng==0){
    		return ;
    	}
    	String guijiFile = "guiji-"+fileName+"g";
    	//十秒记录一次轨迹
    	if(guijiTime>=10){
    		String content = lat+"|"+lng
    		FileDatasObj.SaveStringToSD(fileName, content);
    	}
    	guijiTime++;
    }
    */
    
    private static double rad(double d)
    {
       return d * Math.PI / 180.0;
    }
    //计算两点距离
    public static double GetDistance(double lat1, double lng1, double lat2, double lng2)
    {
    	if(lat1 ==0 || lat2==0){
    		return 0;
    	}
       double radLat1 = rad(lat1);
       double radLat2 = rad(lat2);
       double a = radLat1 - radLat2;
       double b = rad(lng1) - rad(lng2);

       double s = 2 * Math.asin(Math.sqrt(Math.pow(Math.sin(a/2),2) +
        Math.cos(radLat1)*Math.cos(radLat2)*Math.pow(Math.sin(b/2),2)));
       s = s * EARTH_RADIUS;
       s = (double)Math.round(s * 10000) / 10000;
      // Log.v("ssss", s+"-----");
       return s;
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
  
	private boolean isGpsEnabled(){
		return lm.isProviderEnabled(android.location.LocationManager.GPS_PROVIDER );
	}
  //获取location对象  
    private void initLocation(Context mContext){  
    	//LocationManager locationManager;
        String serviceName = Context.LOCATION_SERVICE;
        lm = (LocationManager)getSystemService(serviceName);
        
        if( !isGpsEnabled() ){
        	serviceState = "Disabled";
        	return ;
        }
        serviceState = "Enabled";
        Criteria criteria = new Criteria();
        criteria.setAccuracy(Criteria.ACCURACY_FINE);
        criteria.setAltitudeRequired(true);
        //criteria.setBearingRequired(true);
        criteria.setSpeedRequired(true);
        //criteria.setBearingRequired(true);//方向信息
        criteria.setCostAllowed(true);
        criteria.setPowerRequirement(Criteria.POWER_LOW);
        String provider = lm.getBestProvider(criteria, true);
        
        location = lm.getLastKnownLocation(provider);
        locationListener = new LocationListener() {

			@Override
			public void onLocationChanged(Location location) {
				// TODO Auto-generated method stub
				updateLocation(location);
                //Log.v("gps=", "LocationChanged");
			}

			@Override
			public void onProviderDisabled(String provider) {
				// TODO Auto-generated method stub
				//Log.v("gps=", "Disabled");
				serviceState = "Disabled";
			}

			@Override
			public void onProviderEnabled(String provider) {
				// TODO Auto-generated method stub
				//Log.v("gps=", "Enabled");
				serviceState = "Enabled";
			}

			@Override
			public void onStatusChanged(String provider, int status,
					Bundle extras) {
				// TODO Auto-generated method stub
				//Log.v("gps=", "StatusChanged");
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
        	//GPSdegree = location.getBearing();
        	speed = location.getSpeed();
        	//Log.v("speed", speed+"speed");
            //如果已经获取到location信息 则在这里注销location的监听  
            //gps会在一定时间内自动关闭  
            //this.lm.removeUpdates(locationListener);  
        } else {  
        	//Log.v("yao", "不能定位");
        }  
    }

    


}