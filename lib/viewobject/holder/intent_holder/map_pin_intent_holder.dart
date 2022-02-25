import 'package:flutter/cupertino.dart';

import '../../city.dart';
import '../../item.dart';

class MapPinIntentHolder {
  const MapPinIntentHolder({
    @required this.flag,
    @required this.mapLat,
    @required this.mapLng,
     this.city,
     this.item,
  });
  final String flag;
  final String mapLat;
  final String mapLng;
  final City city;
  final Item item;
}
