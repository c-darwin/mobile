package org.golang.app;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import org.xwalk.core.XWalkView;
import android.widget.LinearLayout;
import org.chromium.base.library_loader.LibraryLoader;
import android.util.Log;
import android.app.Service ;

public class MainActivity extends Activity {

	private WebView webView;
	private LinearLayout commentsLayout;
	private XWalkView mXWalkView;

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

	public void onCreate(Bundle savedInstanceState) {

		super.onCreate(savedInstanceState);

		Log.d("Go", "MainActivity onCreate");




		/*setContentView(R.layout.webview);
		webView = (WebView) findViewById(R.id.webView1);
		webView.getSettings().setJavaScriptEnabled(true);
		webView.setWebViewClient(new WebViewClient());
		webView.loadUrl("http://www.google.com");
*/
		/*setContentView(R.layout.activity_xwalk_embed_lib);
		commentsLayout=(LinearLayout)findViewById(R.id.principal);
		xWalkWebView = new XWalkView(this, this);
		//xWalkWebView.load("file:///android_asset/www/index.html", null);
		final String html = "<html><body bgcolor=\"#090998\"><h1>Hello world!</h1></body></html>";
		xWalkWebView.load(null, html);
		commentsLayout.addView(xWalkWebView);*/
/*
		setContentView(R.layout.activity_xwalk_embed_lib);
		commentsLayout=(LinearLayout)findViewById(R.id.principal);
		mXWalkView = new XWalkView(this.getApplicationContext(), this);
		/*mXWalkView = (XWalkView) findViewById(R.id.activity_main);
		mXWalkView.load("http://crosswalk-project.org/", null);*/


		setContentView(R.layout.activity_xwalk_embed_lib);
		commentsLayout=(LinearLayout)findViewById(R.id.principal);
		mXWalkView =  new XWalkView(this, this);
		//final String html = "<html><body bgcolor=\"#090998\"><h1>Hello world!</h1></body></html>";
		mXWalkView.load("http://google.com", null);
		commentsLayout.addView(mXWalkView);


		  Runnable r = new Runnable() {
		      public void run() {
			GoNativeActivity.load();
		      }
		  };
		  Thread t = new Thread(r);
		  t.start();


	}

}