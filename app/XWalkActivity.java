package org.golang.app;

import android.app.Activity;
import android.os.Bundle;
import android.content.Intent;
import android.util.Log;
import android.net.Uri;
import android.os.Handler;
import android.os.SystemClock;
import java.util.concurrent.TimeUnit;
import org.xwalk.core.XWalkView;
import android.widget.LinearLayout;
import android.util.Log;
import android.view.Window;
import android.view.WindowManager;
import android.content.pm.ActivityInfo;

public class WViewActivity extends Activity {

	static {
		try {
			System.loadLibrary("xwalkcore");
		} catch (UnsatisfiedLinkError e) {
			System.err.println("xwalkcore code library failed to load 02.\n" + e);
			System.exit(1);
		}
		Log.d("Go", "xwalkcore loaded");

		try {
			System.loadLibrary("xwalkdummy");
		} catch (UnsatisfiedLinkError e) {
			System.err.println("xwalkdummy code library failed to load 03.\n" + e);
			System.exit(1);
		}
		Log.d("Go", "xwalkdummy loaded");
	}

	private LinearLayout commentsLayout;
	private XWalkView mXWalkView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		//Fixed Portrait orientation
		setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);

		this.requestWindowFeature(Window.FEATURE_NO_TITLE);
		this.getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
				WindowManager.LayoutParams.FLAG_FULLSCREEN);

		Log.d("Go", "WViewActivity onCreate");
		setContentView(R.layout.activity_xwalk_embed_lib);
		commentsLayout=(LinearLayout)findViewById(R.id.principal);
		mXWalkView = new XWalkView(this, this);
		//final String html = "<html><body bgcolor=\"#090998\"><h1>Hello world!</h1></body></html>";
		mXWalkView.load("http://localhost:8089", null);
		commentsLayout.addView(mXWalkView);

		Log.d("Go", "mXWalkView ok");
    }

    protected void onStart(Bundle savedInstanceState) {

		Log.d("Go", "MainActivity onStart");
	  
    }

}
