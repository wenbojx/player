package com.yiluhao.panoplayer;

import java.util.Timer;
import java.util.TimerTask;

import javax.microedition.khronos.opengles.GL10;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
//import org.openpanodroid.PanodroidGLView.MyTask;
//import org.openpanodroid.panoutils.android.CubicPanoNative.TextureFaces;

import com.loopj.android.http.AsyncHttpClient;
import com.loopj.android.http.AsyncHttpResponseHandler;
import com.loopj.android.http.BinaryHttpResponseHandler;
import com.panoramagl.PLCubicPanorama;
import com.panoramagl.PLCamera;
//import com.panoramagl.PLIPanorama;
import com.panoramagl.PLIView;
import com.panoramagl.PLImage;

import com.panoramagl.PLView;
import com.panoramagl.PLViewEventListener;
import com.panoramagl.enumeration.PLCubeFaceOrientation;
import com.panoramagl.hotspots.PLHotspot;
import com.panoramagl.ios.structs.CGPoint;
import com.panoramagl.structs.PLPosition;
import com.panoramagl.utils.PLUtils;

import com.yiluhao.utils.IoUtil;
import com.yiluhao.utils.TouchView;

import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.res.Configuration;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Message;
import android.util.Log;
import android.view.Display;
import android.view.View;
import android.view.WindowManager;
import android.view.ViewGroup.LayoutParams;
import android.widget.Button;
import android.widget.ImageButton;
//import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.Toast;
import android.view.View.OnClickListener;

public class PanoPlayerActivity extends PLView {

	private String pano_id = "";
	private String project_id = "";
	private JSONObject panoInfo = null;
	private JSONArray hotspots = null;
	private Bitmap bfront = null, bback = null, bleft = null, bright = null,
			bup = null, bdown = null;
	String front_url = "", back_url = "", left_url = "", right_url = "", up_url = "", down_url = "";
	
	private IoUtil ioUtil = null;
	private String panoInfoUrl = null;
	private AsyncHttpClient client;
	private String panoTitle = null;
	private boolean imageLayoutIsShow = false;
	//private String domain = "http://192.168.1.104/";
	private Bitmap hotImage = null;
	private String hotImageUrl;
	private ProgressDialog progressDialog;  
	private String domain = "http://mb.yiluhao.com/";
	private boolean cancleHotImage = false;
	private PLCubicPanorama cubicPanorama = null;
	private int loadNumber = 1;
	private GL10 gl;
	private float cameraX = 0;
	private float cameraY = 0;
	private PLCamera currentCamera = null;
	private int animateWaitTime = 3000;
	private int animateRateTime = 10;
	private float lookAtAddX = 0.03f;
	private float lookAtAddY = 0.04f;
	private boolean canAnimate = false;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		Intent intent = getIntent();
		Bundle extras = intent.getExtras();
		project_id = getResources().getString(R.string.project_id);
		if (extras != null) {
			pano_id = extras.getString("pano_id");
			project_id = extras.getString("project_id");
		}
		else{
			return ;
		}
		//panoInfoUrl = "http://beta1.yiluhao.com/ajax/m/pv/id/"+pano_id;
		panoInfoUrl = domain+"ajax/m/pv/id/"+pano_id;
		
		ioUtil = new IoUtil();
		client = new AsyncHttpClient();
		
		getPanoDetail();


	}
	/**
	 * 错误提示
	 */
	private void getWrong(String msg){
		Toast.makeText(this, msg, Toast.LENGTH_LONG).show();
	}
	/**
	 * 获取全景图信息
	 */
	private boolean getPanoDetail() {
		if( ioUtil.FileExists(project_id, panoInfoUrl)){
			String configStr = ioUtil.ReadStringFromSD(project_id, panoInfoUrl);
			ExtractPanoDatas(configStr);
			displayPano();
			return true;
		}
		
		//AsyncHttpClient client = new AsyncHttpClient();
		client.get(panoInfoUrl, new AsyncHttpResponseHandler() {
		    @Override
		    public void onSuccess(String response) {
		    	if(response =="" || response == null){
		    		return ;
		    	}
		    	ExtractPanoDatas(response);
		    	ioUtil.SaveStringToSD(project_id, panoInfoUrl, response);
		    	displayPano();
		    }
		    public void onFailure(Throwable error, String content){
		    	getWrong("获配置信息失败，请检查您的网络设置");
		    }
		});
		return true;
	}
	/**
	 * 解析地图图片信息
	 */
	private boolean ExtractPanoDatas(String content){
		if(content == "" || content ==null){
			return false;
		}
		try {
			panoInfo = new JSONObject(content).getJSONObject("pano");
			panoTitle = panoInfo.getString("title");
			
			hotspots = new JSONObject(content).getJSONArray("hotspots");
		} catch (JSONException e) {
			throw new RuntimeException(e);
		}
		this.setTitle(panoTitle);
		return true;
	}
	
	private void displayPano() {
		if (panoInfo != null) {
			LoadFaceAsyncTask asyncTask = new LoadFaceAsyncTask();
			asyncTask.execute();
		}
		else{
			getWrong("获配置信息失败，请检查您的网络设置");
		}
	}

	private void drawImageView(){	
		if(cancleHotImage){
			return ;
		}
		if(!imageLayoutIsShow){
			View imageView = this.getLayoutInflater().inflate(R.layout.image_view,
					null);
			imageView.setTag("imageViewLayout");
			this.addContentView(imageView, new LayoutParams(
					LayoutParams.FILL_PARENT, LayoutParams.FILL_PARENT));
			TouchView mhotImage = (TouchView) findViewById(R.id.drawImage);
			if(hotImage!=null){
				mhotImage.setImageBitmap(hotImage);
				//mhotImage.setScaleType(ImageView.ScaleType.CENTER);
			}
			
			Button closeImageBt = (Button) findViewById(R.id.close_image_view);
			closeImageBt.setOnClickListener(new OnClickListener(){
				@Override
				public void onClick(View view) {
					RelativeLayout ImageLayout = (RelativeLayout) findViewById(R.id.drawImageLayout);
					//mImageMap.;
					ImageLayout.setVisibility(view.GONE);
				}
			});
			imageLayoutIsShow = true;
		}
		else{
			RelativeLayout ImageLayout = (RelativeLayout) findViewById(R.id.drawImageLayout);
			//mImageMap.;
			TouchView mhotImage = (TouchView) findViewById(R.id.drawImage);
			if(hotImage!=null){
				mhotImage.setImageBitmap(hotImage);
			}
			ImageLayout.setVisibility(View.VISIBLE);
		}
		progressDialog.hide();
	}
	
	/**
	 * 取消下载
	 */
	private void cancel(){
		//cancelRequests
		client.cancelRequests(PanoPlayerActivity.this, true);
		ioUtil.DelFile(project_id, hotImageUrl);
		cancleHotImage = true;
	}
	/**
	 * 获取图片
	 */
	private void getHotImage(){
		if(hotImage!=null){
			hotImage = null;
		}
		//hotImageUrl = "";
		Log.v("aaaaaaa", hotImageUrl);
		
		progressDialog = new ProgressDialog(PanoPlayerActivity.this);
		progressDialog.setMessage(getString(R.string.loading_hotimage));
		progressDialog.setCancelable(true);
		//progressDialog.setProgressStyle(ProgressDialog.STYLE_HORIZONTAL);
		progressDialog.setButton(ProgressDialog.BUTTON_NEGATIVE,
				getString(R.string.cancel),
				new DialogInterface.OnClickListener() {
					public void onClick(DialogInterface dialog, int id) {
						cancel();
					}
				});
		progressDialog.show();
		
		if(ioUtil.FileExists(project_id, hotImageUrl)){
			Log.v("picCached=", "cached");
			hotImage = ioUtil.ReadBitmapFromSD(project_id, hotImageUrl);
			//StartPaintMap(mapPicture);
			Log.v("hotImageUrl", "cached");
			drawImageView();
			return ;
		}
		//AsyncHttpClient client = new AsyncHttpClient();
		String[] allowedContentTypes = new String[] { "image/png", "image/jpeg", "image/gif" };
		client.get(hotImageUrl, new BinaryHttpResponseHandler(allowedContentTypes) {
		    @Override
		    public void onSuccess(byte[] fileData) {
		    	if(fileData.length<1){
		    		return ;
		    	}
		    	hotImage = BitmapFactory.decodeByteArray(fileData, 0, fileData.length, null);  
		    	ioUtil.SavePicToSD(project_id, hotImageUrl, hotImage);
		    	drawImageView();
		    }
		    public void onFailure(Throwable error, String content){
		    	getWrong("获取图片失败");
		    }
		});
	}
	/**
	 * 定义热点点击事件
	 */
	private void setHotspotListener() {
		this.setListener(new PLViewEventListener() {
			@Override
			public void onDidClickHotspot(PLIView pView, PLHotspot hotspot,
					CGPoint screenPoint, PLPosition scene3DPoint) {
				// Toast.makeText(pView.getActivity(),
				// String.format("You select the hotspot with ID %d",
				// hotspot.getIdentifier()), Toast.LENGTH_SHORT).show();

				int id = 0;
				String linkId = "0";
				String pano_id_back = pano_id;
				int type = 2;
				int typePano = 2;
				String hotImage = null;
				
				for (int i = 0; i < hotspots.length(); i++) {
					JSONObject jsonObject2 = (JSONObject) hotspots.opt(i);
					try {
						id = jsonObject2.getInt("id");
						linkId = jsonObject2.getString("link_scene_id");
						type = jsonObject2.getInt("type");
						if(type == 4){
							hotImage = jsonObject2.getString("file_path");
						}
					} catch (JSONException e) {
						throw new RuntimeException(e);
					}
					//Log.v("getIdentifier", id+"-"+hotspot.getIdentifier()+"-"+linkId);
					if (id == hotspot.getIdentifier()) {
						pano_id = linkId;
						typePano = type;
						if(type == 4){
							hotImageUrl = hotImage;
						}
					}
				}
				//Log.v("linkId", linkId);
				if (linkId != "0" || pano_id_back != pano_id) {
					//startPanoViewerActivity(linkId, project_id);
					if(typePano ==  2){
						releasePage();
						if(loadNumber <=5){
							loadNewPano(pano_id);
						}
						else{
							startPanoViewerActivity(pano_id, project_id);
						}
						loadNumber++;
					}
					else if(typePano == 4){
						getHotImage();
					}
				}
				
			}
		});
	}

	private void loadNewPano(String sid){
		pano_id = sid;
		panoInfoUrl = domain+"ajax/m/pv/id/"+pano_id;
		getPanoDetail();
		
	}
	private void startPanoViewerActivity(String sid, String pid) {
		Intent intent = new Intent(this, PanoPlayerActivity.class);

		Bundle bundle = new Bundle();
		bundle.putString("pano_id", sid);
		bundle.putString("project_id", pid);
		intent.putExtras(bundle);

		startActivity(intent);
		this.finish();
	}

	public class LoadFaceAsyncTask extends AsyncTask<Integer, Integer, String> {

		private ProgressDialog waitDialog = null;
		private boolean destroyed = false;

		@Override
		protected void onPreExecute() {
			waitDialog = new ProgressDialog(PanoPlayerActivity.this);
			waitDialog.setMessage(getString(R.string.loading_face));
			waitDialog.setCancelable(false);
			waitDialog.setProgressStyle(ProgressDialog.STYLE_HORIZONTAL);
			waitDialog.setButton(ProgressDialog.BUTTON_NEGATIVE,
					getString(R.string.cancel),
					new DialogInterface.OnClickListener() {
						public void onClick(DialogInterface dialog, int id) {
							cancel(true);
						}
					});
			waitDialog.setMax(6);
			waitDialog.show();
		}
		synchronized void destroy() {
			destroyed = true;
			cancel(true);
		}
		synchronized boolean isDestroyed() {
			return destroyed;
		}
		@Override
		protected void onCancelled () {
			if (isDestroyed()) {
				return;
			}
			waitDialog.dismiss();
			finish();
		}
		/**
		 * 这里的Integer参数对应AsyncTask中的第一个参数 这里的String返回值对应AsyncTask的第三个参数
		 * 该方法并不运行在UI线程当中，主要用于异步操作，所有在该方法中不能对UI当中的空间进行设置和修改
		 * 但是可以调用publishProgress方法触发onProgressUpdate对UI进行操作
		 */
		@Override
		protected String doInBackground(Integer... params) {
			String status = "ok";
			boolean getPicFlag = true;
			
			try {
				front_url = panoInfo.getString("s_f");
				back_url = panoInfo.getString("s_b");
				left_url = panoInfo.getString("s_l");
				right_url = panoInfo.getString("s_r");
				up_url = panoInfo.getString("s_u");
				down_url = panoInfo.getString("s_d");
			} catch (JSONException e) {
				throw new RuntimeException(e);
			}

			if (isCancelled()) {
				return null;
			}
			bfront = ioUtil.GetFacePic(project_id, front_url);
			publishProgress(1);
			if (bfront == null) {
				getPicFlag = false;
			}
			if (isCancelled()) {
				//ioUtil.DelFile(project_id, front_url);
				return null;
			}
			bback = ioUtil.GetFacePic(project_id, back_url);
			publishProgress(2);
			if (bback == null) {
				getPicFlag = false;
			}
			if (isCancelled()) {
				//ioUtil.DelFile(project_id, back_url);
				return null;
			}
			bleft = ioUtil.GetFacePic(project_id, left_url);
			publishProgress(3);
			if (bleft == null) {
				getPicFlag = false;
			}
			if (isCancelled()) {
				//ioUtil.DelFile(project_id, left_url);
				return null;
			}
			bright = ioUtil.GetFacePic(project_id, right_url);
			publishProgress(4);
			if (bright == null) {
				getPicFlag = false;
			}
			if (isCancelled()) {
				//ioUtil.DelFile(project_id, right_url);
				return null;
			}
			bup = ioUtil.GetFacePic(project_id, up_url);
			publishProgress(5);
			if (bup == null) {
				getPicFlag = false;
			}
			if (isCancelled()) {
				//ioUtil.DelFile(project_id, up_url);
				return null;
			}
			bdown = ioUtil.GetFacePic(project_id, down_url);
			publishProgress(6);
			if (bdown == null) {
				getPicFlag = false;
			}
			if (isCancelled()) {
				//ioUtil.DelFile(project_id, down_url);
				return null;
			}
			return status;
		}

		/**
		 * 这里的String参数对应AsyncTask中的第三个参数（也就是接收doInBackground的返回值）
		 * 在doInBackground方法执行结束之后在运行，并且运行在UI线程当中 可以对UI空间进行设置
		 */
		@Override
		protected void onPostExecute(String result) {
			waitDialog.dismiss();
			if(result == null){
				getWrong("获取素材出错，请检查您的网络设置");
			}
			else{
				loadPanorama(2);
			}
			
		}

		/**
		 * 这里的Intege参数对应AsyncTask中的第二个参数
		 * 在doInBackground方法当中，，每次调用publishProgress方法都会触发onProgressUpdate执行
		 * onProgressUpdate是在UI线程中执行，所有可以对UI空间进行操作
		 */
		@Override
		protected void onProgressUpdate(Integer... progress) {
			int p = progress[0];
			waitDialog.setProgress(p);
		}

	}
	
	private void loadPanorama(int index) {
		
		gl = this.getCurrentGL();
		//PLIPanorama panorama = null;
		// Lock panoramic view
		this.setBlocked(true);
		
		
		if(bfront == null){
			ioUtil.DelFile(project_id, front_url);
			getWrong("获取素材出错,请重试");
			finish();
			return ;
		}
		if(bleft == null){
			ioUtil.DelFile(project_id, left_url);
			getWrong("获取素材出错,请重试");
			finish();
			return ;
		}
		if(bright == null){
			ioUtil.DelFile(project_id, right_url);
			getWrong("获取素材出错,请重试");
			finish();
			return ;
		}
		if(bback == null){
			ioUtil.DelFile(project_id, back_url);
			getWrong("获取素材出错,请重试");
			finish();
			return ;
		}
		if(bup == null){
			ioUtil.DelFile(project_id, up_url);
			getWrong("获取素材出错,请重试");
			finish();
			return ;
		}
		if(bdown == null){
			ioUtil.DelFile(project_id, down_url);
			getWrong("获取素材出错,请重试");
			finish();
			return ;
		}
		
		if (index == 2) {
			cubicPanorama = new PLCubicPanorama();
			cubicPanorama.setImage(gl, PLImage.imageWithBitmap(bfront, false),
					PLCubeFaceOrientation.PLCubeFaceOrientationFront);
			cubicPanorama.setImage(gl, PLImage.imageWithBitmap(bback, false),
					PLCubeFaceOrientation.PLCubeFaceOrientationBack);
			cubicPanorama.setImage(gl, PLImage.imageWithBitmap(bleft, false),
					PLCubeFaceOrientation.PLCubeFaceOrientationLeft);
			cubicPanorama.setImage(gl, PLImage.imageWithBitmap(bright, false),
					PLCubeFaceOrientation.PLCubeFaceOrientationRight);
			cubicPanorama.setImage(gl, PLImage.imageWithBitmap(bup, false),
					PLCubeFaceOrientation.PLCubeFaceOrientationUp);
			cubicPanorama.setImage(gl, PLImage.imageWithBitmap(bdown, false),
					PLCubeFaceOrientation.PLCubeFaceOrientationDown);
			
			//cubicPanorama.
			//panorama = cubicPanorama;

		}
		int id = 0;
		float pan = 0f;
		float tilt = 0f;
		int transform = 10;
		int type = 2;
		// 屏幕宽高
		WindowManager windowManager = getWindowManager();
		Display display = windowManager.getDefaultDisplay();
		int screenWidth = display.getWidth();
		int screenHeight = display.getHeight();
		float hotspot = 0.05f;
		int maxWidth = screenWidth > screenHeight ? screenWidth : screenHeight;
		if (maxWidth < 850) {
			hotspot = 0.08f;
		}
		//hotspot = 0.04f;
		// Add a hotspot
		for (int i = 0; i < hotspots.length(); i++) {
			JSONObject jsonObject2 = (JSONObject) hotspots.opt(i);
			try {
				id = jsonObject2.getInt("id");
				pan = jsonObject2.getInt("pan");
				tilt = jsonObject2.getInt("tilt");
				transform = jsonObject2.getInt("transform");
				type = jsonObject2.getInt("type");
				
			} catch (JSONException e) {
				throw new RuntimeException(e);
			}
			int resId = R.raw.hotspots10;
			if(type == 2){
				if(transform == 11){
					resId = R.raw.hotspots11;
				}
				else if(transform == 12){
					resId = R.raw.hotspots12;
				}
				else if(transform == 13){
					resId = R.raw.hotspots13;
				}
				else if(transform == 14){
					resId = R.raw.hotspots14;
				}
				else if(transform == 15){
					resId = R.raw.hotspots15;
				}
				else if(transform == 16){
					resId = R.raw.hotspots16;
				}
				else if(transform == 17){
					resId = R.raw.hotspots17;
				}
			}
			else if(type==4){
				resId = R.raw.imghotspot;
			}
			
			cubicPanorama.addHotspot(new PLHotspot(id, PLImage.imageWithBitmap(
					PLUtils.getBitmap(this, resId), false), tilt, pan,
					hotspot, hotspot));
		}
		// Load panorama
		this.reset();
		this.setPanorama(cubicPanorama);
		currentCamera = cubicPanorama.getCurrentCamera();
		// Unlock panoramic view
		this.setBlocked(false);
		StartAnimates();
		if(hotspots != null){
			setHotspotListener();
		}
	}
	/*
	 * private int animateWaitTime = 5000;
	private int animateRateTime = 10;
	private float lookAtAddX = 0.03f;
	private float lookAtAddY = 0.05f;
	 */
	public void StartAnimates(){
    	Timer timer = new Timer();
        timer.schedule(new MyTask(), animateWaitTime, animateRateTime);
    }
    private class MyTask extends TimerTask {
        public void run() {  

    		cameraX = currentCamera.getPitch();
    		cameraY = currentCamera.getYaw();
    		if(!canAnimate){
    			//StopAnimate();
    			return ;
    		}
    		if(canAnimate){
	    		cameraY += lookAtAddY;
	    		if(cameraX !=0){
	    			if(cameraX >0){
	    				cameraX = (cameraX-lookAtAddX) >= 0 ? (cameraX-lookAtAddX) : 0;
	    			}
	    			else{
	    				cameraX = (cameraX+lookAtAddX) <= 0 ? (cameraX+lookAtAddX) : 0;
	    			}
	    			
	    		}
    		}
    		//Log.v("aaaaa", cameraX+"-"+cameraY);
    		currentCamera.lookAt(cameraX, cameraY);
    		currentCamera.setPitch(cameraX);
    		currentCamera.setYaw(cameraY);
    		//a();
        }     
    }  
    public void StopAnimate(){
    	canAnimate = false;
    	ImageButton exitButton = (ImageButton) findViewById(R.id.animate_bt);
    	exitButton.setImageResource(R.raw.repeat);
    }
    public void ReAnimate(){
    	canAnimate = true;
    	ImageButton exitButton = (ImageButton) findViewById(R.id.animate_bt);
    	exitButton.setImageResource(R.raw.pause);
    }
    
	
	private void releasePage (){
		if(bfront != null){
			bfront.recycle();
			bfront = null;
			bback.recycle();
			bback = null;
			bleft.recycle();
			bleft = null;
			bright.recycle();
			bright = null;
			bup.recycle();
			bup = null;
			bdown.recycle();
			bdown = null;
		}
		System.gc();
		//super.onDestroy();
	}
	@Override
	protected void onDestroy() {
		releasePage();
		if (cubicPanorama != null) {
			cubicPanorama.clearPanorama(gl);
		}
		super.onDestroy();
	}
	@Override
	 public void onConfigurationChanged(Configuration newConfig) {
	  // 当新设置中，屏幕布局模式为横排时
		 if (this.getResources().getConfiguration().orientation == Configuration.ORIENTATION_LANDSCAPE) {//当前为横屏

         }else if(this.getResources().getConfiguration().orientation == Configuration.ORIENTATION_PORTRAIT){//当前为竖屏

         }
         super.onConfigurationChanged(newConfig);
	 }
	
	@Override
	protected void onGLContextCreated(GL10 gl) {
		super.onGLContextCreated(gl);

		// Add layout
		View mainView = this.getLayoutInflater().inflate(R.layout.pano_player,
				null);
		this.addContentView(mainView, new LayoutParams(
				LayoutParams.FILL_PARENT, LayoutParams.FILL_PARENT));

		ImageButton exitButton = (ImageButton) findViewById(R.id.animate_bt);
		exitButton.setOnClickListener(new OnClickListener(){
			@Override
			public void onClick(View view) {
				if(!canAnimate){
					ReAnimate();
				}
				else{
					StopAnimate();
				}
			}
		});
		/*
		// Zoom controls
		ImageButton zoomIn = (ImageButton) mainView
				.findViewById(R.id.zoom_in_btn);
		zoomIn.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View view) {
				getCamera().zoomIn(true);
			}
		});
		ImageButton zoomout = (ImageButton) mainView
				.findViewById(R.id.zoom_out_btn);
		zoomout.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View view) {
				getCamera().zoomOut(true);
			}
		});
		*/
	}
}
