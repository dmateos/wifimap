package com.greywireit.wifimap_android;

import android.app.AlertDialog;
import android.content.Context;
import android.net.wifi.ScanResult;
import android.net.wifi.WifiManager;

import org.apache.http.client.ResponseHandler;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.BasicResponseHandler;
import org.apache.http.impl.client.DefaultHttpClient;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

/**
 * Created by dm on 29/12/14.
 */
public class WifiServer {
    private Context context;
    private List<ScanResult> apList;

    public WifiServer(Context context) {
        this.context = context;
    }

    public List<ScanResult> GetWifiData() {
        WifiManager wifiManager = (WifiManager)context.getSystemService(Context.WIFI_SERVICE);
        wifiManager.startScan();
        this.apList = wifiManager.getScanResults();
        return apList;
    }

    public void SendResults()  {
        String path = "http://wifimap.dev.mateos.cc/api/nodes";

        for(ScanResult res : apList) {
            try {
                HashMap<String, String> params = new HashMap<String, String>();

                params.put("ssid", res.SSID);
                params.put("mac", res.BSSID);
                params.put("capabilities", res.capabilities);
                params.put("frequency", String.valueOf(res.frequency));
                params.put("signal", String.valueOf(res.level));
                params.put("lng", "0");
                params.put("lat", "0");

                DefaultHttpClient httpClient = new DefaultHttpClient();
                HttpPost httpPost = new HttpPost(path);

                JSONObject json = new JSONObject(params);
                StringEntity se = new StringEntity(json.toString());

                httpPost.setEntity(se);
                httpPost.setHeader("Accept", "application/json");
                httpPost.setHeader("Content-type", "application/json");

                ResponseHandler responseHandler = new BasicResponseHandler();
                httpClient.execute(httpPost, responseHandler);
            }
            catch(Exception e) {
                AlertDialog.Builder dlgAlert  = new AlertDialog.Builder(context);
                dlgAlert.setMessage(e.toString());
                dlgAlert.setTitle("App Title");
                dlgAlert.setPositiveButton("OK", null);
                dlgAlert.setCancelable(true);
                dlgAlert.create().show();
            }
        }
    }
}
