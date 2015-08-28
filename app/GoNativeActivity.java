package org.golang.app;

import android.app.Notification;
import android.app.NotificationManager;
import android.content.pm.ActivityInfo;
import android.app.NativeActivity;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.util.Log;
import android.content.Intent;
import android.net.Uri;
import android.app.PendingIntent;
import android.content.Context;
import android.widget.Toast;
import android.app.TaskStackBuilder;
import android.support.v4.app.NotificationCompat;


public class GoNativeActivity extends NativeActivity {

    private static GoNativeActivity goNativeActivity;

    public GoNativeActivity() {
        super();
        goNativeActivity = this;
    }  
        
    public void openBrowser(String url) {
    	  Intent intent = new Intent(Intent.ACTION_VIEW);
	Uri data = Uri.parse("http://localhost:8089");
			  intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
			  intent.setData(data);
			  startActivity(intent);
    }
    
    public void notif(String title, String text) {
 
  	  Intent intent = new Intent("org.golang.app.MainActivity");	    

	  NotificationCompat.Builder mBuilder = new NotificationCompat.Builder(this);
	  mBuilder.setSmallIcon(R.drawable.icon);
	  mBuilder.setContentTitle(title);
	  mBuilder.setContentText(text);
	          
	  Intent resultIntent = new Intent(this, MainActivity.class);
	  TaskStackBuilder stackBuilder = TaskStackBuilder.create(this);
	  stackBuilder.addParentStack(MainActivity.class);

	  // Adds the Intent that starts the Activity to the top of the stack
	  stackBuilder.addNextIntent(resultIntent);
	  PendingIntent resultPendingIntent = stackBuilder.getPendingIntent(0,PendingIntent.FLAG_UPDATE_CURRENT);
	  mBuilder.setContentIntent(resultPendingIntent);

	  NotificationManager mNotificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
    
	  // notificationID allows you to update the notification later on.
	  mNotificationManager.notify(2, mBuilder.build());

    }    

    String getTmpdir() {
        return getCacheDir().getAbsolutePath();
    }

    String getFilesdir() {
        return getExternalFilesDir(null).getAbsolutePath();
    }

    public static void load() {

        // Interestingly, NativeActivity uses a different method
        // to find native code to execute, avoiding
        // System.loadLibrary. The result is Java methods
        // implemented in C with JNIEXPORT (and JNI_OnLoad) are not
        // available unless an explicit call to System.loadLibrary
        // is done. So we do it here, borrowing the name of the
        // library from the same AndroidManifest.xml metadata used
        // by NativeActivity.
	try {
	    System.loadLibrary("dcoin");
		
	} catch (Exception e) {
		Log.e("Go", "loadLibrary failed", e);
	}
    }

    public void onStart(Bundle savedInstanceState) {
    
    		  try {
			  Intent intent = new Intent(Intent.ACTION_VIEW);
			  Uri data = Uri.parse("http://localhost:8089");
			  intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
			  intent.setData(data);
			  startActivity(intent);
		  } catch (Exception e) {
			  Log.e("Go", "http://localhost:8089 failed", e);
		  }
    }
    @Override
    public void onCreate(Bundle savedInstanceState) {
            
        moveTaskToBack(true);
        
        super.onCreate(savedInstanceState);        
    }
}
