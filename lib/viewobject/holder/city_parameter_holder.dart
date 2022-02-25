import 'package:businesslistingapi/constant/ps_constants.dart';
import 'package:businesslistingapi/viewobject/common/ps_holder.dart';

class CityParameterHolder extends PsHolder<CityParameterHolder> {
  CityParameterHolder(
      {this.id, this.keyWord, this.isFeatured, this.orderBy, this.orderType});

  String id;
  String keyWord;
  String isFeatured;
  String orderBy;
  String orderType;

  @override
  CityParameterHolder fromMap(dynamic dynamicData) {
    return CityParameterHolder(
        id: dynamicData['id'],
        keyWord: dynamicData['keyword'],
        isFeatured: dynamicData['is_featured'],
        orderBy: dynamicData['order_by'],
        orderType: dynamicData['order_type']);
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['id'] = id;
    map['keyword'] = keyWord;
    map['is_featured'] = isFeatured;
    map['order_by'] = orderBy;
    map['order_type'] = orderType;

    return map;
  }

  CityParameterHolder getRecentCities() {
    id = '';
    keyWord = '';
    isFeatured = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;

    return this;
  }

  CityParameterHolder getAllCities() {
    id = '';
    keyWord = '';
    isFeatured = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;

    return this;
  }

  CityParameterHolder getPopularCities() {
    id = '';
    keyWord = '';
    isFeatured = '';
    orderBy = PsConst.FILTERING__TRENDING;
    orderType = PsConst.FILTERING__DESC;

    return this;
  }

  CityParameterHolder getFeaturedCities() {
    id = '';
    keyWord = '';
    isFeatured = PsConst.ONE;
    orderBy = PsConst.FILTERING_FEATURE;
    orderType = PsConst.FILTERING__DESC;

    return this;
  }

  @override
  String getParamKey() {
    String key = '';

    if (id != '') {
      key += id;
    }
    if (keyWord != '') {
      key += keyWord;
    }
    if (isFeatured != '') {
      key += isFeatured;
    }
    if (orderBy != '') {
      key += orderBy;
    }
    if (orderType != '') {
      key += orderType;
    }
    return key;
  }
}
