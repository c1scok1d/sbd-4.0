import 'package:businesslistingapi/constant/ps_constants.dart';
import 'package:businesslistingapi/viewobject/common/ps_holder.dart';

class CategoryParameterHolder extends PsHolder<dynamic> {
  CategoryParameterHolder() {
    cityId = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
  }

  String cityId;
  String orderBy;
  String orderType;

  CategoryParameterHolder getTrendingParameterHolder() {
    cityId = '';
    orderBy = PsConst.FILTERING__TRENDING;
    orderType = PsConst.FILTERING__DESC;

    return this;
  }

  CategoryParameterHolder getLatestParameterHolder() {
    cityId = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;

    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['city_id'] = cityId;
    map['order_by'] = orderBy;
    map['order_type'] = orderType;

    return map;
  }

  @override
  dynamic fromMap(dynamic dynamicData) {
    cityId = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;

    return this;
  }

  @override
  String getParamKey() {
    String result = '';

    if (cityId != '') {
      result += cityId + ':';
    }
    if (orderBy != '') {
      result += orderBy + ':';
    }
    if (orderType != '') {
      result += orderType;
    }

    return result;
  }
}
