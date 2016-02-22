package org.golang.app;

import android.app.Notification;
import android.app.PendingIntent;
import android.app.Service ;
import android.content.Intent;
import android.os.IBinder;
import android.util.Log;
import java.net.Socket;
import android.os.SystemClock;


public class MyService extends Service  {

    @Override
    public IBinder onBind(Intent intent) {
        Log.d("Go", "MyService onBind");
        return null;
    }

    public int onStartCommand(Intent intent, int flags, int startId) {
        Log.d("Go", "MyService onStartCommand");
        SystemClock.sleep(500);
        Intent i = new Intent(this, WViewActivity.class);
        i.addFlags(i.FLAG_ACTIVITY_NEW_TASK);
        startActivity(i);

        return super.onStartCommand(intent, flags, startId);
    }

    public void onStart() {
        Log.d("Go", "MyService onStart");
    }

    public void onDestroy() {
        Log.d("Go", "MyService onDestroy");
        super.onDestroy();
    }

    @Override
    public void onCreate() {
        Log.d("Go", "MyService onCreate");
        super.onCreate();

        ShortcutIcon();

        sendNotif();


        //Runnable r = new Runnable() {
        //    public void run() {
                GoNativeActivity.load();
        //    }
        //};
        //Thread t = new Thread(r);
        //t.start();

        Intent dialogIntent = new Intent(this, GoNativeActivity.class);
        dialogIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        startActivity(dialogIntent);


/*
        try {
            Intent intent1 = new Intent(Intent.ACTION_VIEW);
            Uri data = Uri.parse("http://localhost:8089");
            intent1.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            intent1.setData(data);
            startActivity(intent1);
        } catch (Exception e) {
            Log.e("Go", "http://localhost:8089 failed", e);
        }*/
    }


    void sendNotif() {

        Log.d("Go", "MyService sendNotif");
        Notification notif = new Notification(R.drawable.icon, "Dcoin", System.currentTimeMillis());

        Intent intent = new Intent(this, MainActivity.class);
        PendingIntent pIntent = PendingIntent.getActivity(this, 0, intent, 0);

        notif.setLatestEventInfo(this, "Dcoin", "Running", pIntent);

        startForeground(1, notif);

    }
    private void ShortcutIcon(){

        Log.d("Go", "MyService ShortcutIcon");
        Intent shortcutIntent = new Intent(getApplicationContext(), MainActivity.class);
        shortcutIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        shortcutIntent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);

        Intent addIntent = new Intent();
        addIntent.putExtra(Intent.EXTRA_SHORTCUT_INTENT, shortcutIntent);
        addIntent.putExtra(Intent.EXTRA_SHORTCUT_NAME, "Dcoin");
        addIntent.putExtra(Intent.EXTRA_SHORTCUT_ICON_RESOURCE, Intent.ShortcutIconResource.fromContext(getApplicationContext(), R.drawable.icon));
        addIntent.setAction("com.android.launcher.action.INSTALL_SHORTCUT");
        getApplicationContext().sendBroadcast(addIntent);
    }

    public static boolean DcoinStarted(int port) {
        for (int i=0;i<60;i++) {
            try (Socket ignored = new Socket("localhost", port)) {
                return true;
            } catch (Exception ignored) {
                SystemClock.sleep(500);
            }
        }
        return true;
    }

}
