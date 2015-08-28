package org.golang.app;

import android.app.Notification;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Intent;
import android.os.IBinder;


public class MyService extends Service {


    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }


    public int onStartCommand(Intent intent, int flags, int startId) {
        return super.onStartCommand(intent, flags, startId);
    }

    public void onStart() {
    }

    public void onDestroy() {
        super.onDestroy();
    }


    @Override
    public void onCreate() {
        super.onCreate();

        sendNotif();

        GoNativeActivity.load();

        Intent dialogIntent = new Intent(this, GoNativeActivity.class);
        dialogIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        startActivity(dialogIntent);
    }


    void sendNotif() {

        Notification notif = new Notification(R.drawable.icon, "Dcoin", System.currentTimeMillis());

        Intent intent = new Intent(this, MainActivity.class);
        PendingIntent pIntent = PendingIntent.getActivity(this, 0, intent, 0);

        notif.setLatestEventInfo(this, "Dcoin", "Running", pIntent);

        startForeground(1, notif);

    }

}