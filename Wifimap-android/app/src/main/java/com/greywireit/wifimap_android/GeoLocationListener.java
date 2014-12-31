package com.greywireit.wifimap_android;

import android.content.Context;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;

class GeoLocationListener implements LocationListener {
    private double lng, lat;
    private LocationManager locationManager;

    public GeoLocationListener(Context context) {
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