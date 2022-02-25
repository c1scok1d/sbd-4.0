import 'package:businesslistingapi/viewobject/common/ps_holder.dart'
    show PsHolder;
import 'package:flutter/cupertino.dart';

class RatingParameterHolder extends PsHolder<RatingParameterHolder> {
  RatingParameterHolder({
    @required this.userId,
    @required this.itemId,
    @required this.cityId,
    @required this.title,
    @required this.description,
    @required this.rating,
  });

  final String userId;
  final String itemId;
  final String cityId;
  final String title;
  final String description;
  final String rating;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['user_id'] = userId;
    map['item_id'] = itemId;
    map['city_id'] = cityId;
    map['title'] = title;
    map['description'] = description;
    map['rating'] = rating;

    return map;
  }

  @override
  RatingParameterHolder fromMap(dynamic dynamicData) {
    return RatingParameterHolder(
      userId: dynamicData['user_id'],
      itemId: dynamicData['item_id'],
      cityId: dynamicData['city_id'],
      title: dynamicData['title'],
      description: dynamicData['description'],
      rating: dynamicData['rating'],
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

    if (title != '') {
      key += title;
    }
    if (description != '') {
      key += description;
    }
    if (rating != '') {
      key += rating;
    }
    return key;
  }
}
