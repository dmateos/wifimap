package com.greywireit.wifimap_android;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.os.Handler;
import android.support.v7.app.ActionBarActivity;
import android.support.v4.app.Fragment;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;


public class MainActivity extends ActionBarActivity implements APUpdateReceiver.Receiver {
    private AlarmManager alarmManager;
    private PendingIntent alarmIntent;
    public APUpdateReceiver apUpdateReceiver;

    private TextView textView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        if (savedInstanceState == null) {
            getSupportFragmentManager().beginTransaction()
                    .add(R.id.container, new PlaceholderFragment())
                    .commit();
        }

        textView = new TextView(this);
        textView = (TextView)findViewById(R.id.textView);
        textView.setText("Wifimap 0.1\n---------\n");

        apUpdateReceiver = new APUpdateReceiver(new Handler());
        apUpdateReceiver.setReceiver(this);

        Intent intent = new Intent(this, APUpdateService.class);
        intent.putExtra("receiver", apUpdateReceiver);

        alarmManager = (AlarmManager) getSystemService(Context.ALARM_SERVICE);
        alarmIntent = PendingIntent.getService(this, 0, intent, PendingIntent.FLAG_CANCEL_CURRENT);
        alarmManager.setRepeating(AlarmManager.RTC_WAKEUP, System.currentTimeMillis(), 1000 * 10, alarmIntent);
    }


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    /**
     * A placeholder fragment containing a simple view.
     */
    public static class PlaceholderFragment extends Fragment {

        public PlaceholderFragment() {
        }

        @Override
        public View onCreateView(LayoutInflater inflater, ViewGroup container,
                                 Bundle savedInstanceState) {
            View rootView = inflater.inflate(R.layout.fragment_main, container, false);
            return rootView;
        }
    }

    public void onReceiveResult(int resultCode, Bundle resultData) {
        String data = resultData.getString("result");
        if(!data.contains("has already been taken")) {
            if (textView.getLineCount() < 12) {
                textView.append(resultData.getString("result") + "\n");
            } else {
                //textView.setText("Wifimap 0.1\n---------\n");
                //textView.append(resultData.getString("result") + "\n");
            }
        }
    }
}
