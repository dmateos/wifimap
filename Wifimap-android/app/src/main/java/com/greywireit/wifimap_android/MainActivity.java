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
import android.widget.Button;
import android.widget.TextView;

import com.littlefluffytoys.littlefluffylocationlibrary.LocationInfo;
import com.littlefluffytoys.littlefluffylocationlibrary.LocationLibrary;

import org.json.JSONObject;


public class MainActivity extends ActionBarActivity
        implements APUpdateReceiver.Receiver, View.OnClickListener {
    private AlarmManager alarmManager;
    private PendingIntent alarmIntent;
    private APUpdateReceiver apUpdateReceiver;
    private TextView textView;
    private Button startButton;
    private boolean isStart;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        if (savedInstanceState == null) {
            getSupportFragmentManager().beginTransaction()
                    .add(R.id.container, new PlaceholderFragment())
                    .commit();
        }

        LocationLibrary.initialiseLibrary(getBaseContext(), "com.greywireit.wifimap_android");

        textView = (TextView) findViewById(R.id.textView);
        textView.setText("Wifimap 0.1\n---------\n");

        startButton = (Button)findViewById(R.id.button);
        startButton.setOnClickListener(this);
        startButton.setText("start");
        isStart = true;

        apUpdateReceiver = new APUpdateReceiver(new Handler());
        apUpdateReceiver.setReceiver(this);

        Intent intent = new Intent(this, APUpdateService.class);
        intent.putExtra("receiver", apUpdateReceiver);
        alarmManager = (AlarmManager) getSystemService(Context.ALARM_SERVICE);
        alarmIntent = PendingIntent.getService(this, 0, intent, PendingIntent.FLAG_CANCEL_CURRENT);
    }

    public void onClick(View v) {
        if(isStart) {
            alarmManager.setRepeating(AlarmManager.RTC_WAKEUP, System.currentTimeMillis(), 1000 * 10, alarmIntent);
            textView.append("started scanner\n");
            isStart = false;
            startButton.setText("stop");
        } else {
            alarmManager.cancel(alarmIntent);
            textView.append("stopped scanner\n");
            isStart = true;
            startButton.setText("start");

        }
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

    public int addCount = 0;
    public int alReadySeen = 0;

    public void onReceiveResult(int resultCode, Bundle resultData) {
        try {
            textView.setText("Wifimap 0.1\n---------\n");
            textView.append("Total adds: " + addCount + "\n");
            textView.append("Total seen: " + alReadySeen + "\n");
            textView.append("---------\n");

            JSONObject jsonData = new JSONObject(resultData.getString("result"));
            switch (jsonData.getInt("respcode")) {
                case 0:
                    addCount++;
                    break;
                case 1:
                    alReadySeen++;
                    break;
                default:
                    break;
            }

        } catch (Exception e) {
            //Log.v("debug2", e.getMessage());
            //Log.v("debug2", resultData.getString(("result")));
        }
    }
}
