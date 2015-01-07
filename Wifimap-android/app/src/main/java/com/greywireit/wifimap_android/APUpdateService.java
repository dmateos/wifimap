package com.greywireit.wifimap_android;

import android.app.IntentService;
import android.content.Context;
import android.content.Intent;
import android.location.LocationListener;
import android.net.wifi.ScanResult;
import android.net.wifi.WifiManager;
import android.os.Bundle;
import android.os.ResultReceiver;
import android.util.Log;

import com.littlefluffytoys.littlefluffylocationlibrary.LocationInfo;
import com.littlefluffytoys.littlefluffylocationlibrary.LocationLibrary;

import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.List;

public class APUpdateService extends IntentService {
    private List<ScanResult> wifiList;

    public APUpdateService() {
        super("APUpdateService");
    }

    @Override
    protected void onHandleIntent(Intent intent) {
        WifiManager wifiManager = (WifiManager)getSystemService(WIFI_SERVICE);
        wifiManager.startScan();
        wifiList = wifiManager.getScanResults();

        LocationInfo latestInfo = new LocationInfo(getBaseContext());

        Log.v("debug", String.valueOf(latestInfo.getTimestampAgeInSeconds()));
        if(latestInfo.getTimestampAgeInSeconds() > 30) {
            LocationLibrary.forceLocationUpdate(getBaseContext());
        }

        ResultReceiver receiver = intent.getParcelableExtra("receiver");

        String path = "http://wifimap.dev.mateos.cc/api/v1/add";
        path = "http://10.10.0.204:3000/api/v1/add";

        for (ScanResult scan : wifiList) {
            try {
                JSONObject request = new JSONObject();
                JSONObject access_point = new JSONObject();
                JSONObject signal_sample = new JSONObject();


                access_point.put("ssid", scan.SSID);
                access_point.put("mac", scan.BSSID);
                access_point.put("capabilities", scan.capabilities);
                access_point.put("freq", scan.frequency);

                signal_sample.put("signal", scan.level);
                signal_sample.put("lng", latestInfo.lastLong);
                signal_sample.put("lat", latestInfo.lastLat);

                request.put("access_point", access_point);
                request.put("signal_sample", signal_sample);

                DefaultHttpClient httpClient = new DefaultHttpClient();
                HttpPost httpPost = new HttpPost(path);
                StringEntity se = new StringEntity(request.toString());
                httpPost.setEntity(se);
                httpPost.setHeader("Accept", "application/json");
                httpPost.setHeader("Content-type", "application/json");
                HttpResponse response = httpClient.execute(httpPost);
                Bundle b = new Bundle();
                b.putString("result", EntityUtils.toString(response.getEntity()));
                receiver.send(0, b);
            } catch(Exception e) {
                Log.v("debug", e.getMessage());
            }
        }
    }
}
