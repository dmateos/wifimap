package com.greywireit.wifimap_android;

import android.app.AlertDialog;
import android.content.Context;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.net.wifi.ScanResult;
import android.net.wifi.WifiManager;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;

import org.apache.http.HttpResponse;
import org.apache.http.client.ResponseHandler;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.BasicResponseHandler;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/**
 * Created by dm on 29/12/14.
 */
class SendJsonTask extends AsyncTask<JSONObject, Void, List<JSONObject>> {
    private Context context;

    public SendJsonTask(Context context) {
        this.context = context;
    }

    @Override
    protected List<JSONObject> doInBackground(JSONObject... json) {
        //String path = "http://wifimap.dev.mateos.cc/api/nodes";
        String path = "http://10.10.0.204:3000/api/nodes/";
        List<JSONObject> responses = new ArrayList<JSONObject>();

        for(JSONObject j : json) {
            try {
                DefaultHttpClient httpClient = new DefaultHttpClient();
                HttpPost httpPost = new HttpPost(path);
                StringEntity se = new StringEntity(j.toString());
                httpPost.setEntity(se);
                httpPost.setHeader("Accept", "application/json");
                httpPost.setHeader("Content-type", "application/json");
                HttpResponse response = httpClient.execute(httpPost);
                responses.add(new JSONObject(EntityUtils.toString(response.getEntity())));
            } catch(Exception e) {
                Log.v("error", e.getMessage());
            }
        }
        return responses;
    }

    protected void onPostExecute(List<JSONObject> result) {
        for(JSONObject r : result) {
            new AlertDialog.Builder(context).setTitle("OK").setMessage(r.toString()).show();
        }
    }
}

class WifiLocationListener implements LocationListener {
    private double lng, lat;
    private LocationManager locationManager;

    public WifiLocationListener(Context context) {
        locationManager = (LocationManager) context.getSystemService(Context.LOCATION_SERVICE);
        locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, 50000, 10, this);

        Location cur = locationManager.getLastKnownLocation(LocationManager.GPS_PROVIDER);
        if (cur != null) {
            this.lng = cur.getLongitude();
            this.lat = cur.getLatitude();
        }
    }

    @Override
    public void onLocationChanged(Location loc) {
        this.lng = loc.getLongitude();
        this.lat = loc.getLatitude();
    }

    public double GetLat() { return this.lat; }
    public double GetLng() { return this.lng; }

    public void onProviderDisabled(String provider) {}
    public void onProviderEnabled(String provider) {}
    public void onStatusChanged(String provider, int status, Bundle extras) {}
}

public class WifiServer {
    private Context context;
    private List<ScanResult> apList;
    private WifiLocationListener locationListener;

    public WifiServer(Context context) {
        this.context = context;
        locationListener = new WifiLocationListener(context);
    }

    public List<ScanResult> GetWifiData() {
        WifiManager wifiManager = (WifiManager) context.getSystemService(Context.WIFI_SERVICE);
        wifiManager.startScan();
        this.apList = wifiManager.getScanResults();
        return apList;
    }

    public void SendResults() {
        for (ScanResult res : apList) {
            try {
                JSONObject params = new JSONObject();
                params.put("ssid", res.SSID);
                params.put("mac", res.BSSID);
                params.put("capabilities", res.capabilities);
                params.put("frequency", res.frequency);
                params.put("signal", res.level);
                params.put("lng", locationListener.GetLng());
                params.put("lat", locationListener.GetLat());
                new SendJsonTask(context).execute(params);
            } catch(Exception e) {

            }
        }
    }
}

