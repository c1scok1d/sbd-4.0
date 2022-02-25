import 'package:businesslistingapi/viewobject/common/ps_holder.dart'
    show PsHolder;
import 'package:flutter/cupertino.dart';

class FavouriteParameterHolder extends PsHolder<FavouriteParameterHolder> {
  FavouriteParameterHolder(
      {@required this.userId, @required this.itemId, @required this.cityId});

  final String userId;
  final String itemId;
  final String cityId;
  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['user_id'] = userId;
    map['item_id'] = itemId;
    map['city_id'] = cityId;
    return map;
  }

  @override
  FavouriteParameterHolder fromMap(dynamic dynamicData) {
    return FavouriteParameterHolder(
      userId: dynamicData['user_id'],
      itemId: dynamicData['item_id'],
      cityId: dynamicData['city_id'],
    );
  }

  @override
  String getParamKey() {
    String key = '';

    if (userId != '') {
      key += userId;
    }
    if (itemId != '') {
      key += itemId;
    }
    if (cityId != '') {
      key += cityId;
    }

    return key;
  }
}
