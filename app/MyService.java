package org.golang.app;

import android.app.Notification;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Intent;
import android.os.IBinder;
import android.util.Log;

public class MyService extends Service {

    @Override
    public IBinder onBind(Intent intent) {
        Log.d("Go", "MyService onBind");
        return null;
    }

    public int onStartCommand(Intent intent, int flags, int startId) {
        Log.d("Go", "MyService onStartCommand");
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

        GoNativeActivity.load();

        Intent dialogIntent = new Intent(this, GoNativeActivity.class);
        dialogIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        startActivity(dialogIntent);
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
}