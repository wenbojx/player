package com.yiluhao.panotools;

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

import android.annotation.SuppressLint;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Color;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.v4.app.FragmentActivity;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageButton;

import com.yiluhao.panotools.MapTools;

public class MapActivity extends FragmentActivity {
	MyReceiver receiver;
	private GoogleMap mMap;  
	private double currentLng = 0; //当前维度
	private double currentLat = 0; //当前经度
	private String fileName = "";
	public String[] locations = null;
	private Marker lastmMarker = null;
	private Marker startmMarker = null;
	private boolean isLastmMarker = false;
	private int secend = 0; //时间秒
	private boolean isFristStart = true;
	private ImageButton dingwei = null;
	private ImageButton ditu = null;
	private int mapType = 2;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.map);
		
		Intent intent = getIntent();
		Bundle extras = intent.getExtras();

		if (extras != null) {
			currentLat = Double.parseDouble(extras.getString("currentLat")) ;
			currentLng = Double.parseDouble(extras.getString("currentLng")) ;
			fileName = extras.getString("fileName");
			//fileName = "2013-05-13-12-15-35.geo";
			Log.v("lat-lng-file", currentLat+"-"+currentLng+"-"+fileName);
		}
		if(currentLat == 0){
			currentLat = 31.19948054;
			currentLng = 121.51887075;
		}
		
		dingwei = (ImageButton)findViewById(R.id.dingwei);
		dingwei.setOnClickListener(new dingweiOnClickListener());
		ditu = (ImageButton)findViewById(R.id.ditu);
		ditu.setOnClickListener(new dituOnClickListener());
		
		setupWebView();
		initBroadcast();
	}
	
	
	private void setupWebView(){ 
		mMap = ((SupportMapFragment) getSupportFragmentManager().findFragmentById(R.id.mapView)).getMap(); 
		//mMap.setMapType(GoogleMap.MAP_TYPE_SATELLITE);
		setMapType();
		mapToCurrent();
		/*
		if(firstClickMap){
			drawMapLine();
		}
		*/
		getPloyDatas();
	}
	private void setMapType(){
		if(mMap == null){
			return ;
		}
		if(mapType == 1){
			mMap.setMapType(GoogleMap.MAP_TYPE_SATELLITE);
			mapType = 2;
			ditu.setImageResource(R.drawable.ditu);
		}
		else{
			mMap.setMapType(GoogleMap.MAP_TYPE_NORMAL);
			mapType = 1;
			ditu.setImageResource(R.drawable.weixing);
		}
	}
	private void mapToCurrent(){
		
		if(mMap != null){
			//
			LatLng HAMBURG = new LatLng(currentLat, currentLng);
			if(isFristStart){
				mMap.moveCamera(CameraUpdateFactory.newLatLngZoom(HAMBURG, 16));
				isFristStart = false;
			}
			else{
				mMap.moveCamera(CameraUpdateFactory.newLatLng(HAMBURG));
			}
		}
		markMap(currentLat, currentLng, 3);
	}
	
	@SuppressLint("HandlerLeak")
	public void getPloyDatas(){
		final Handler handler = new Handler() {
			@Override
			public void handleMessage(Message msg) {
				drawMapLine();
			}
		};
    	new Thread(){//新建线程，每隔1秒发送一次广播，同时把i放进intent传出
			@SuppressLint("SimpleDateFormat")
			public void run(){
				MapTools mapTool = new MapTools();
				locations = mapTool.getGPSinfo(fileName);
				Message msg = handler.obtainMessage(0, "");
				handler.sendMessage(msg);
			}
		}.start();
		
    }
	private void drawMapLine(){
		if (mMap==null){
			return ;
        }
	    PolylineOptions rectOptions = new PolylineOptions(); // Closes the polyline. 
	    
	    if(locations == null || locations.length<1){
	    	return ;
	    }
	    //Log.v("locations=", locations.length+"");
		for(int i=0; i<(locations.length); i++){
			if(locations[i] == "" || locations[i] == null){
				continue;
			}
			String[] split = locations[i].split(",");
			if(split.length<2){
				continue;
			}
			double lat = Double.parseDouble(split[0]);
			double lng = Double.parseDouble(split[1]);
			Log.v("lat-lng", lat+"-"+lng);
			rectOptions.add(new LatLng(lat, lng));
			//int position = 2;
			if(i==0){
				//第一个点
				markMap(lat, lng, 1);
			}
			if(i==(locations.length-1)){
				markMap(lat, lng, 3);
			}
			
		}
	    rectOptions.color(Color.RED);
	    rectOptions.width(5);
	    mMap.addPolyline(rectOptions);  
	    
	}
	private void drawMapLineNow(double lat, double lng){
		if (mMap==null){
			return ;
        }
		if(lat == 0 || lng ==0){
			return ;
		}
		Log.v("now-lat-lng", lat+"-"+lng);
		PolylineOptions rectOptions = new PolylineOptions();
		rectOptions.add(new LatLng(lat, lng));
		rectOptions.color(Color.RED);
	    rectOptions.width(5);
	    mMap.addPolyline(rectOptions);  
	    markMap(lat, lng, 3);
	}
	//position= 1=start | 3=end |2=other
	private void markMap(double lat, double lng, int position){
		if (mMap==null){
			return ;
        }
		
		LatLng MELBOURNE = new LatLng(lat, lng);  
		BitmapDescriptor iconSet = BitmapDescriptorFactory.fromResource(R.drawable.start_position);
		Log.v("position", position+"");
		
		if(lastmMarker!=null){
			lastmMarker.remove();
			Log.v("remove=", position+"");
		}
		if(position==1){
			iconSet = BitmapDescriptorFactory.fromResource(R.drawable.start_position);
			startmMarker = mMap.addMarker(new MarkerOptions()  
            .position(MELBOURNE)  
            .title("Melbourne")  
            .snippet("Population: 4,137,400")  
            .icon(iconSet)); 
		}
		else if(position==3){
			iconSet = BitmapDescriptorFactory.fromResource(R.drawable.curren_tposition);
			isLastmMarker = true;
			lastmMarker = mMap.addMarker(new MarkerOptions()  
            .position(MELBOURNE)  
            .title("Melbourne")  
            .snippet("Population: 4,137,400")  
            .icon(iconSet)); 
		}
		
		
		
		//lastmMarker = mMarker;
	}

	private void initBroadcast(){
		receiver=new MyReceiver();
        //定义一个IntentFilter的对象，来过滤掉一些intent
        IntentFilter filter = new IntentFilter();
        //只接收发送到action为"android.intent.action.MAIN"的intent
        //"android.intent.action.MAIN"是在MainFest中定义的
        filter.addAction("android.intent.action.MAIN");
        //启动广播接收器
        MapActivity.this.registerReceiver(receiver, filter);
	}
	
	public class MyReceiver extends BroadcastReceiver {

        @Override
        public void onReceive(Context context, Intent intent) {
            Bundle bundle = intent.getExtras();
            String degreeStr = bundle.getString("degree");
            double lng = bundle.getDouble("longitude");
            double lat = bundle.getDouble("latitude");
            currentLng = lng; //当前维度
        	currentLat = lat; //当前经度
            //Log.v("degreeStr", degreeStr+"-"+lat+"-"+lng);
        	if(lat == 0 || lng==0){
        		return ;
        	}
        	if(secend%2 == 0){
        		drawMapLineNow(lat, lng);
        		//mapToCurrent();
        	}
            
            secend++;
        }       
    }
	
	private class dingweiOnClickListener implements OnClickListener
    {
		@Override
		public void onClick(View v) {
			dingwei.setImageResource(R.drawable.dingweioff);
			mapToCurrent();
			dingwei.setImageResource(R.drawable.dingwei);
		}       
    }
	private class dituOnClickListener implements OnClickListener
    {
		@Override
		public void onClick(View v) {
            setMapType();
		}       
    }
	
	@Override
	protected void onDestroy() {
		this.unregisterReceiver(receiver);
		super.onDestroy();
	}
}
