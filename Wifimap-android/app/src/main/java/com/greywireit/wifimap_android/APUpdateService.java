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

        String path = "http://wifimap.dev.mateos.cc/api/nodes";
        //path = "http://10.10.0.204:3000/api/nodes";

        for (ScanResult scan : wifiList) {
            try {
                JSONObject params = new JSONObject();
                params.put("ssid", scan.SSID);
                params.put("mac", scan.BSSID);
                params.put("capabilities", scan.capabilities);
                params.put("frequency", scan.frequency);
                params.put("signal", scan.level);
                params.put("lng", latestInfo.lastLong);
                params.put("lat", latestInfo.lastLat);

                DefaultHttpClient httpClient = new DefaultHttpClient();
                HttpPost httpPost = new HttpPost(path);
                StringEntity se = new StringEntity(params.toString());
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
