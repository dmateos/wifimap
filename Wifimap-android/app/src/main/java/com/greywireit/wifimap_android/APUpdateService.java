package com.greywireit.wifimap_android;

import android.app.IntentService;
import android.content.Context;
import android.content.Intent;
import android.net.wifi.ScanResult;
import android.net.wifi.WifiManager;
import android.os.Bundle;
import android.os.ResultReceiver;
import android.util.Log;

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
    private GeoLocationListener geoLocationListener;

    public APUpdateService() {
        super("APIUpdateService");
        geoLocationListener = null;
    }

    @Override
    protected void onHandleIntent(Intent intent) {
        WifiManager wifiManager = (WifiManager)getSystemService(WIFI_SERVICE);
        wifiManager.startScan();
        wifiList = wifiManager.getScanResults();

        if(geoLocationListener == null) {
            geoLocationListener = new GeoLocationListener(this);
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
                params.put("lng", geoLocationListener.GetLng());
                params.put("lat", geoLocationListener.GetLat());

                DefaultHttpClient httpClient = new DefaultHttpClient();
                HttpPost httpPost = new HttpPost(path);
                StringEntity se = new StringEntity(params.toString());
                httpPost.setEntity(se);
                httpPost.setHeader("Accept", "application/json");
                httpPost.setHeader("Content-type", "application/json");
                HttpResponse response = httpClient.execute(httpPost);
                JSONObject responseObj = new JSONObject(EntityUtils.toString(response.getEntity()));

                Bundle b = new Bundle();
                b.putString("result", responseObj.toString());
                receiver.send(0, b);
            } catch(Exception e) {

                Log.v("exception", e.getMessage());
            }
        }
    }
}
