import 'dart:async';

import 'package:businesslistingapi/provider/item/models/geometry.dart';
import 'package:businesslistingapi/provider/item/models/location.dart';
import 'package:businesslistingapi/provider/item/models/place.dart';
import 'package:businesslistingapi/provider/item/models/place_search.dart';
import 'package:businesslistingapi/provider/item/services/geolocator_service.dart';
import 'package:businesslistingapi/provider/item/services/marker_service.dart';
import 'package:businesslistingapi/provider/item/services/places_service.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ApplicationBloc extends ChangeNotifier {
  final geoLocatorService = GeolocatorService();
  final placesService = PlacesService();
  final markerService = MarkerService();

  //Variables
  Position currentLocation;
  List<PlaceSearch> searchResults;
  StreamController<Place> selectedLocation = StreamController<Place>();
  StreamController<LatLngBounds> bounds = StreamController<LatLngBounds>();
  Place selectedLocationStatic;
  Place latlongLocationStatic;
  String placeType;
  List<Place> placeResults;
  List<Marker> markers = List<Marker>();


  ApplicationBloc() {
    setCurrentLocation();
  }


  void setCurrentLocation() async {
    currentLocation = await geoLocatorService.getCurrentLocation();
    String mLoc=await locationFromLatLong(currentLocation);
    selectedLocationStatic = Place(name: mLoc,
      geometry: Geometry(location: Location(
          lat: currentLocation.latitude, lng: currentLocation.longitude),),);
    latlongLocationStatic=selectedLocationStatic;
    notifyListeners();
  }

  void getCurrentLocation() async {
    currentLocation = await geoLocatorService.getCurrentLocation();
    selectedLocationStatic = Place(name: null,
      geometry: Geometry(location: Location(
          lat: currentLocation.latitude, lng: currentLocation.longitude),),);

  }

  Future<String> locationFromLatLong(Position p)  async {
    List<Address> placemarks = await  Geocoder.local.findAddressesFromCoordinates(Coordinates(p.latitude, p.longitude));
    if(placemarks==null||placemarks.length==0)
      return '';
    return placemarks.first.addressLine;
  }

  void searchPlaces(String searchTerm) async {
    print('$searchTerm');
    searchResults = await placesService.getAutocomplete(searchTerm);
    print('${searchResults.toString()}');
    notifyListeners();
  }


  void setSelectedLocation(String placeId) async {
    dynamic sLocation = await placesService.getPlace(placeId);
    selectedLocation.add(sLocation);
    selectedLocationStatic = sLocation;
    searchResults = null;
    notifyListeners();

  }

  void clearSelectedLocation() {
    selectedLocation.add(null);
    selectedLocationStatic = null;
    searchResults = null;
    placeType = null;
    notifyListeners();
  }

  void togglePlaceType(String value, bool selected) async {
    if (selected) {
      placeType = value;
    } else {
      placeType = null;
    }

    if (placeType != null) {
      var places = await placesService.getPlaces(
          selectedLocationStatic.geometry.location.lat,
          selectedLocationStatic.geometry.location.lng, placeType);
      markers= [];
      if (places.length > 0) {
        var newMarker = markerService.createMarkerFromPlace(places[0],false);
        markers.add(newMarker);
      }

      var locationMarker = markerService.createMarkerFromPlace(selectedLocationStatic,true);
      markers.add(locationMarker);

      var _bounds = markerService.bounds(Set<Marker>.of(markers));
      bounds.add(_bounds);

      notifyListeners();
    }
  }



  @override
  void dispose() {
    selectedLocation.close();
    bounds.close();
    super.dispose();
  }}