package org.golang.app;

import android.app.Activity;
import android.os.Bundle;
import android.content.Intent;
import android.util.Log;
import android.net.Uri;
import android.os.Handler;
import android.os.SystemClock;
import java.util.concurrent.TimeUnit;

public class MainActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		Log.d("Go", "MainActivity onCreate");

	  Intent intent=new Intent("org.golang.app.MyService");
	  this.startService(intent);

		/*Thread t = new Thread(){
			public void run(){
				Intent intent=new Intent("org.golang.app.MyService");
				this.startService(intent);
			}
		};
		t.start();*/


		Runnable r = new Runnable() {
			public void run() {
				if (MyService.DcoinStarted(8089)) {
					try {
						Intent intent1 = new Intent(Intent.ACTION_VIEW);
						Uri data = Uri.parse("http://localhost:8089");
						intent1.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
						intent1.setData(data);
						startActivity(intent1);
					} catch (Exception e) {
						Log.e("Go", "http://localhost:8089 failed", e);
					}
				}
			}
		};
		Thread t = new Thread(r);
		t.start();

	  //TimeUnit.SECONDS.sleep(5);



    }
    
    
    protected void onStart(Bundle savedInstanceState) {

		Log.d("Go", "MainActivity onStart");

		Runnable r = new Runnable() {
			public void run() {
				if (MyService.DcoinStarted(8089)) {
					try {
						Intent intent1 = new Intent(Intent.ACTION_VIEW);
						Uri data = Uri.parse("http://localhost:8089");
						intent1.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
						intent1.setData(data);
						startActivity(intent1);
					} catch (Exception e) {
						Log.e("Go", "http://localhost:8089 failed", e);
					}
				}
			}
		};
		Thread t = new Thread(r);
		t.start();
	  
    }

}
