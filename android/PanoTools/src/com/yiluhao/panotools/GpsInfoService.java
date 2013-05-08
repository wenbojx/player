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
import com.yiluhao.panotools.SaveDatas;
import com.yiluhao.panotools.MainActivity.MyReceiver;

//public class GpsInfoService extends Service{
public class GpsInfoService extends Service implements SensorEventListener {

	MyReceiver receiver;
	
    Location location;  
    LocationManager lm;  
    LocationListener locationListener;  
    
    double longitude = 0; //ά��
    double latitude = 0; //����
    double altitude = 0; //����
    float degree = 0; //�Ƕ�
    float speed = 0; //�ٶ�
    String serviceState = "start";
    
    public float currentDegree = 0f;
    
    //Intent intent = new Intent();
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

    }
    @Override
    public void onStart(Intent intent, int startId){
    	
    }
    //onStartCommand��onStart���ƣ�����һ����������
    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        // TODO Auto-generated method stub
    	
    	System.out.println("Service onCreate");
    	
    	receiver=new MyReceiver();
        //����һ��IntentFilter�Ķ��������˵�һЩintent
        IntentFilter filter = new IntentFilter();
        //ֻ���շ��͵�actionΪ"android.intent.action.MAIN"��intent
        //"android.intent.action.MAIN"����MainFest�ж����
        filter.addAction("com.yiluhao.panotools.GpsInfoService");
        //�����㲥������
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
    	new Thread(){//�½��̣߳�ÿ��1�뷢��һ�ι㲥��ͬʱ��i�Ž�intent����
			public void run(){
				int id=1;
				Time time = new Time("GMT+8");
				String content = "";

				while(!isStop){
					if( serviceState.equals("pause")){
						continue;
					}
			        SimpleDateFormat formatter = new SimpleDateFormat ("yyyy/MM/dd/ HH:mm:ss"); 
			        SimpleDateFormat formatterFile = new SimpleDateFormat ("yyyy-MM-dd-HH-mm-ss");
			        long timeInt = System.currentTimeMillis();
			        Date curDate = new Date(timeInt);//��ȡ��ǰʱ��       
			        String timeValue = formatter.format(curDate);   
			        

			        String altitudeStr = String.format("%.2f", altitude);
			        
			        String degreeStr = String.format("%.2f", degree);
			        
			        if( longitude != 0 && latitude!=0){
			        	content += latitude+"|";
				        content += longitude+"|";
				        content += altitudeStr+"|";
				        content += degreeStr+"|";
				        content += timeValue+";";
		            }
			        
			        saveDatasObj = new SaveDatas();
			        if(	id ==1 ){
				        	fileName = formatterFile.format(curDate);
				        	fileName = fileName+".geo";
			        }
			        if(id >= 7){
			        	saveDatasObj.SaveStringToSD(fileName, content);
			        	content = "";
			        	id = 2;
			        }
			        
					Intent intent=new Intent();
					intent.putExtra("state", serviceState);
					intent.putExtra("latitude", latitude);
					intent.putExtra("longitude", longitude);
					intent.putExtra("altitude", altitudeStr);
					intent.putExtra("degree", degreeStr);
					intent.putExtra("speed", speed);
					intent.putExtra("time", timeValue);
					
					id++;
					intent.setAction("android.intent.action.MAIN");//action���������ͬ
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
  
  //��ȡlocation����  
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
    
 // ����λ����Ϣ չʾ��tv��  
    private void updateLocation(Location location) {  
        if (location != null) {  
        	longitude = location.getLongitude();
        	latitude = location.getLatitude();
        	altitude = location.getAltitude();
        	//degree = location.getBearing();
        	speed = location.getSpeed();
        	Log.v("speed", speed+"speed");
            //����Ѿ���ȡ��location��Ϣ ��������ע��location�ļ���  
            //gps����һ��ʱ�����Զ��ر�  
            //this.lm.removeUpdates(locationListener);  
        } else {  
        	Log.v("yao", "���ܶ�λ");
        }  
    }

    


}
