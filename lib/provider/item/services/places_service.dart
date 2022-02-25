import 'package:businesslistingapi/constant/ps_constants.dart';
import 'package:businesslistingapi/provider/item/models/place.dart';
import 'package:businesslistingapi/provider/item/models/place_search.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:http/http.dart' as http;
// import 'package:places_autocomplete/src/models/place.dart';
import 'dart:convert' as convert;

// import 'package:places_autocomplete/src/models/place_search.dart';

class PlacesService {
  String key = PsConst.googleMapsAPi;

  Future<List<PlaceSearch>> getAutocomplete(String search) async {
    var url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$search&key=$key';
    var response = await http.get(Uri.parse(url));
    // print('Request: $url');
    // print('Response: ${response.body}');
    dynamic json = convert.jsonDecode(response.body);
    var jsonResults = json['predictions'] as List;
    return jsonResults.map((dynamic place) => PlaceSearch.fromJson(place)).toList();
  }

  Future<Place> getPlace(String placeId) async {
    var url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key';
    var response = await http.get(Uri.parse(url));
    dynamic json = convert.jsonDecode(response.body);
    var jsonResult = json['result'] as Map<String,dynamic>;
    return Place.fromJson(jsonResult);
  }

  Future<List<Place>> getPlaces(double lat, double lng,String placeType) async {
    var url = 'https://maps.googleapis.com/maps/api/place/textsearch/json?location=$lat,$lng&type=$placeType&rankby=distance&key=$key';
    var response = await http.get(Uri.parse(url));
    dynamic json = convert.jsonDecode(response.body);
    var jsonResults = json['results'] as List;
    return jsonResults.map((dynamic place) => Place.fromJson(place)).toList();
  }
}