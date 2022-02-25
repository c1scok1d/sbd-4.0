package com.intivoto.flutter_geofence

import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.location.Location
import android.os.Looper
import android.renderscript.RenderScript
import android.util.Log
import com.google.android.gms.location.*
import com.google.android.gms.location.Geofence.*
import com.google.android.gms.location.LocationRequest.PRIORITY_HIGH_ACCURACY


enum class GeoEvent {
    entry,
    dwell,
    exit
}

data class GeoRegion(
    val id: String,
    val radius: Float,
    val latitude: Double,
    val longitude: Double,
    val events: List<GeoEvent>

)

fun GeoRegion.serialized(): Map<*, *> {
    return hashMapOf(
        "id" to id,
        "radius" to radius,
        "latitude" to latitude,
        "longitude" to longitude
    )
}

fun GeoRegion.convertRegionToGeofence(): Geofence {
    val transitionType: Int = if (events.contains(GeoEvent.entry)) {
        GEOFENCE_TRANSITION_ENTER
    } else {
        GEOFENCE_TRANSITION_EXIT
    }

    return Geofence.Builder()
        .setRequestId(id)
        .setCircularRegion(
            latitude,
            longitude,
            radius
        )
        .setExpirationDuration(NEVER_EXPIRE)
        .setTransitionTypes(transitionType)
        .build()
}

class GeofenceManager(context: Context,
                      callback: (GeoRegion) -> Unit,
                      val locationUpdate: (Location) -> Unit, val backgroundUpdate: (Location) -> Unit) {
    private val TAG = "GeofenceManager"
    private val geofencingClient: GeofencingClient = LocationServices.getGeofencingClient(context)
    private val fusedLocationClient = LocationServices.getFusedLocationProviderClient(context)

    init {
        GeofenceBroadcastReceiver.callback = callback
    }

    private val geofencePendingIntent: PendingIntent by lazy {
        val intent = Intent(context, GeofenceBroadcastReceiver::class.java)
        PendingIntent.getBroadcast(context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT)
    }


    fun startMonitoring(geoRegion: GeoRegion) {
        android.util.Log.e(TAG, "startMonitoring: "+geoRegion.toString() )
        geofencingClient.addGeofences(getGeofencingRequest(geoRegion.convertRegionToGeofence()), geofencePendingIntent)?.run {
            addOnSuccessListener {
                // Geofences added
                Log.d(TAG, "added them")
            }
            addOnFailureListener {
                // Failed to add geofences
                Log.d(TAG, "something not ok")
            }
        }
    }

    fun stopMonitoring(geoRegion: GeoRegion) {
        val regionsToRemove = listOf(geoRegion.id)
        geofencingClient.removeGeofences(regionsToRemove)
    }

    fun stopMonitoringAllRegions() {
        geofencingClient.removeGeofences(geofencePendingIntent)?.run {
            addOnSuccessListener {
                // Geofences removed
            }
            addOnFailureListener {
                // Failed to remove geofences
            }
        }
    }

    private fun getGeofencingRequest(geofence: Geofence): GeofencingRequest {
        val geofenceList = listOf(geofence)
        return GeofencingRequest.Builder().apply {
            setInitialTrigger(GeofencingRequest.INITIAL_TRIGGER_ENTER)
            addGeofences(geofenceList)
        }.build()
    }

    private fun refreshLocation() {
        val locationCallback = object : LocationCallback() {
            override fun onLocationResult(locationResult: LocationResult?) {
                android.util.Log.e(TAG, "onLocationResult: "+locationResult?.lastLocation.toString() )
                locationResult ?: return
                locationUpdate(locationResult.lastLocation)
            }
        }

        fusedLocationClient.requestLocationUpdates(LocationRequest.create(), locationCallback, Looper.getMainLooper())
    }

    fun getUserLocation() {
        android.util.Log.e(TAG, "getUserLocation: " )
        fusedLocationClient.apply {
            lastLocation.addOnCompleteListener {
                it.result?.let {
                    if (System.currentTimeMillis() - it.time > 60 * 1000) {
                        refreshLocation()
                    } else {
                        locationUpdate(it)
                    }
                }
            }
        }
    }

    private val backgroundLocationCallback = object : LocationCallback() {
        override fun onLocationResult(locationResult: LocationResult?) {
            android.util.Log.e(TAG, "onLocationResult: "+locationResult.toString() )

            locationResult ?: return
            backgroundUpdate(locationResult.lastLocation)
        }
    }

    fun startListeningForLocationChanges() {
        android.util.Log.e(TAG, "startListeningForLocationChanges: " )
        val request = LocationRequest().setInterval(5000L).setFastestInterval(5000L).setPriority(PRIORITY_HIGH_ACCURACY)
        fusedLocationClient.requestLocationUpdates(request, backgroundLocationCallback, Looper.getMainLooper())
    }

    fun stopListeningForLocationChanges() {
        fusedLocationClient.removeLocationUpdates(backgroundLocationCallback)
    }

}