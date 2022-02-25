import '../../constant/ps_constants.dart';
import '../common/ps_holder.dart';

class ItemParameterHolder extends PsHolder<dynamic> {
  ItemParameterHolder() {
    keyword = '';
    cityId = '';
    catId = '';
    subCatId = '';
    isFeatured = '';
    ratingValue = '';
    isPromotion = '';
    lat = '';
    lng = '';
    miles = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    addedUserId = '';
    isPaid = '';
    itemStatusId = '1';
    itemLocationId = '';
    isAtoZ = '';
    isZtoA = '';
    isLatest = '';
    isPopular = '';
    defaultPhoto = '';
  }

  String keyword;
  String cityId;
  String catId;
  String subCatId;
  String isFeatured;
  String ratingValue;
  String isPromotion;
  String lat;
  String lng;
  String miles;
  String orderBy;
  String orderType;
  String addedUserId;
  String isPaid;
  String itemStatusId;
  String itemLocationId;
  String isAtoZ;
  String isZtoA;
  String isLatest;
  String isPopular;
  String defaultPhoto;
  bool isFiltered() {
    return !((isPromotion == '0' || isPromotion == '') &&
        (isFeatured == '0' || isFeatured == '') &&
        (isLatest == '0' || isLatest == '') &&
        (isPopular == '0' || isPopular == '') &&
        (isAtoZ == '0' || isAtoZ == '') &&
        (isZtoA == '0' || isZtoA == '') &&
        ratingValue == '');
  }

  bool isCatAndSubCatFiltered() {
    return !(catId == '' && subCatId == '');
  }

  ItemParameterHolder getItemByCategoryIdParameterHolder() {
    keyword = '';
    cityId = '';
    catId = '';
    subCatId = '';
    isFeatured = '';
    ratingValue = '';
    isPromotion = '';
    lat = '';
    lng = '';
    miles = '';
    orderBy = PsConst.FILTERING__TRENDING;
    orderType = PsConst.FILTERING__DESC;
    addedUserId = '';
    isPaid = '';
    itemLocationId = '';
    itemStatusId = '1';
    defaultPhoto = '';

    return this;
  }

  ItemParameterHolder getPendingItemParameterHolder() {
    keyword = '';
    catId = '';
    subCatId = '';
    isFeatured = '';
    ratingValue = '';
    isPromotion = '';
    lat = '';
    lng = '';
    miles = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    addedUserId = '';
    isPaid = '';
    itemLocationId = '';
    itemStatusId = '0';
    defaultPhoto = '';

    return this;
  }

  ItemParameterHolder getRejectedItemParameterHolder() {
    keyword = '';
    catId = '';
    subCatId = '';
    isFeatured = '';
    ratingValue = '';
    isPromotion = '';
    lat = '';
    lng = '';
    miles = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    addedUserId = '';
    isPaid = '';
    itemLocationId = '';
    itemStatusId = '3';
    defaultPhoto = '';

    return this;
  }

  ItemParameterHolder getDisabledItemParameterHolder() {
    keyword = '';
    catId = '';
    subCatId = '';
    isFeatured = '';
    ratingValue = '';
    isPromotion = '';
    lat = '';
    lng = '';
    miles = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    addedUserId = '';
    isPaid = '';
    itemLocationId = '';
    itemStatusId = '2';
    defaultPhoto = '';

    return this;
  }

  ItemParameterHolder getItemByAddedUserIdParameterHolder() {
    keyword = '';
    cityId = '';
    catId = '';
    subCatId = '';
    isFeatured = '';
    ratingValue = '';
    isPromotion = '';
    lat = '';
    lng = '';
    miles = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    addedUserId = '';
    isPaid = '';
    itemLocationId = '';
    itemStatusId = '1';
    defaultPhoto = '';

    return this;
  }

  ItemParameterHolder getDiscountParameterHolder() {
    keyword = '';
    cityId = '';
    catId = '';
    subCatId = '';
    isFeatured = '';
    ratingValue = '';
    isPromotion = PsConst.ONE;
    lat = '';
    lng = '';
    miles = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    addedUserId = '';
    isPaid = '';
    itemLocationId = '';
    itemStatusId = '1';
    defaultPhoto = '';

    return this;
  }

  ItemParameterHolder getFeaturedParameterHolder() {
    keyword = '';
    cityId = '';
    catId = '';
    subCatId = '';
    isFeatured = PsConst.ONE;
    ratingValue = '';
    isPromotion = '';
    lat = '';
    lng = '';
    miles = '';
    orderBy = PsConst.FILTERING_FEATURE;
    orderType = PsConst.FILTERING__DESC;
    addedUserId = '';
    isPaid = '';
    itemLocationId = '';
    itemStatusId = '1';
    defaultPhoto = '';

    return this;
  }

  ItemParameterHolder getNearMeParameterHolder() {
    keyword = '';
    cityId = '';
    catId = '';
    subCatId = '';
    isFeatured = '';
    ratingValue = '';
    isPromotion = '';
    lat = '';
    lng = '';
    miles = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    addedUserId = '';
    isPaid = '';
    itemLocationId = '';
    itemStatusId = '1';
    defaultPhoto = '';

    return this;
  }

  ItemParameterHolder getTrendingParameterHolder() {
    keyword = '';
    cityId = '';
    catId = '';
    subCatId = '';
    isFeatured = '';
    ratingValue = '';
    isPromotion = '';
    lat = '';
    lng = '';
    miles = '';
    orderBy = PsConst.FILTERING__TRENDING;
    orderType = PsConst.FILTERING__DESC;
    addedUserId = '';
    isPaid = '';
    itemLocationId = '';
    itemStatusId = '1';
    isPopular = '1';
    defaultPhoto = '';

    return this;
  }

  ItemParameterHolder getSearchParameterHolder() {
    keyword = '';
    cityId = '';
    catId = '';
    subCatId = '';
    isFeatured = '';
    ratingValue = '';
    isPromotion = '';
    lat = '';
    lng = '';
    miles = '';
    orderBy = '';
    orderType = PsConst.FILTERING__DESC;
    addedUserId = '';
    isPaid = '';
    itemLocationId = '';
    itemStatusId = '1';
    isAtoZ = '';
    isZtoA = '';
    isLatest = '';
    isPopular = '1';
    defaultPhoto = '';

    return this;
  }

  ItemParameterHolder getLatestParameterHolder() {
    keyword = '';
    cityId = '';
    catId = '';
    subCatId = '';
    isFeatured = '';
    ratingValue = '';
    isPromotion = '';
    lat = '';
    lng = '';
    miles = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    addedUserId = '';
    isPaid = '';
    itemLocationId = '';
    itemStatusId = '1';
    isLatest = '1';
    defaultPhoto = '';

    return this;
  }

  ItemParameterHolder resetParameterHolder() {
    keyword = '';
    cityId = '';
    catId = '';
    subCatId = '';
    isFeatured = '';
    ratingValue = '';
    isPromotion = '';
    lat = '';
    lng = '';
    miles = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    addedUserId = '';
    isPaid = '';
    itemLocationId = '';
    itemStatusId = '';
    defaultPhoto = '';

    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['keyword'] = keyword;
    map['city_id'] = cityId;
    map['cat_id'] = catId;
    map['sub_cat_id'] = subCatId;
    map['is_featured'] = isFeatured;
    map['rating_value'] = ratingValue;
    map['is_promotion'] = isPromotion;
    map['lat'] = lat;
    map['lng'] = lng;
    map['miles'] = miles;
    map['order_by'] = orderBy;
    map['order_type'] = orderType;
    map['added_user_id'] = addedUserId;
    map['is_paid'] = isPaid;
    map['item_location_id'] = itemLocationId;
    map['item_status_id'] = itemStatusId;
    map['default_photo'] = defaultPhoto;
    return map;
  }

  @override
  dynamic fromMap(dynamic dynamicData) {
    keyword = '';
    cityId = '';
    catId = '';
    subCatId = '';
    isFeatured = '';
    ratingValue = '';
    isPromotion = '';
    lat = '';
    lng = '';
    miles = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    addedUserId = '';
    isPaid = '';
    itemLocationId = '';
    itemStatusId = '';
    defaultPhoto = '';

    return this;
  }

  @override
  String getParamKey() {
    const String featured = 'featured';

    String result = '';

    if (keyword != '') {
      result += keyword + ':';
    }

    if (catId != '') {
      result += catId + ':';
    }

    if (cityId != '') {
      result += cityId + ':';
    }

    if (subCatId != '') {
      result += subCatId + ':';
    }

    if (isFeatured != '' && isFeatured != '0') {
      result += featured + ':';
    }

    if (ratingValue != '' && ratingValue != '') {
      result += ratingValue + ':';
    }
    if (isPromotion != '' && isPromotion != '') {
      result += isPromotion + ':';
    }

    if (lat != '' && lat != '') {
      result += lat + ':';
    }
    if (lng != '' && lng != '') {
      result += lng + ':';
    }
    if (itemLocationId != '') {
      result += itemLocationId + ':';
    }

    if (orderBy != '') {
      result += orderBy + ':';
    }

    if (orderType != '') {
      result += orderType;
    }

    if (isPaid != '' && isPaid != '') {
      result += isPaid + ':';
    }

    if (itemStatusId != '') {
      result += itemStatusId + ':';
    }

    if (defaultPhoto != '') {
      result += defaultPhoto + ':';
    }

    return result;
  }
}
