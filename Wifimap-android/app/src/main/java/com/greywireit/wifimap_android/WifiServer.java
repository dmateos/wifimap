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
import java.util.Timer;
import java.util.TimerTask;

/**
 * Created by dm on 29/12/14.
 */
class WifiTimer extends TimerTask {
    public void run() {

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
