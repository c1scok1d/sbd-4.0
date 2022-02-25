import 'package:businesslistingapi/viewobject/common/ps_holder.dart';

class ItemEntryParameterHolder extends PsHolder<ItemEntryParameterHolder> {
  ItemEntryParameterHolder({
    this.id,
    this.cityId,
    this.catId,
    this.subCatId,
    this.status,
    this.name,
    this.description,
    this.searchTag,
    this.highlightInformation,
    this.isFeatured,
    this.userId,
    this.lat,
    this.lng,
    this.openingHour,
    this.closingHour,
    this.isPromotion,
    this.phone1,
    this.phone2,
    this.phone3,
    this.email,
    this.address,
    this.facebook,
    this.googlePlus,
    this.twitter,
    this.youtube,
    this.instagram,
    this.pinterest,
    this.website,
    this.whatsapp,
    this.messenger,
    this.timeRemark,
    this.terms,
    this.cancelationPolicy,
    this.additionalInfo,
  });

  final String id;
  final String cityId;
  final String catId;
  final String subCatId;
  final String status;
  final String name;
  final String description;
  final String searchTag;
  final String highlightInformation;
  final String isFeatured;
  final String userId;
  final String lat;
  final String lng;
  final String openingHour;
  final String closingHour;
  final String isPromotion;
  final String phone1;
  final String phone2;
  final String phone3;
  final String email;
  final String address;
  final String facebook;
  final String googlePlus;
  final String twitter;
  final String youtube;
  final String instagram;
  final String pinterest;
  final String website;
  final String whatsapp;
  final String messenger;
  final String timeRemark;
  final String terms;
  final String cancelationPolicy;
  final String additionalInfo;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['id'] = id;
    map['city_id'] = cityId;
    map['cat_id'] = catId;
    map['sub_cat_id'] = subCatId;
    map['status'] = status;
    map['name'] = name;
    map['description'] = description;
    map['search_tag'] = searchTag;
    map['highlight_information'] = highlightInformation;
    map['is_featured'] = isFeatured;
    map['user_id'] = userId;
    map['lat'] = lat;
    map['lng'] = lng;
    map['opening_hour'] = openingHour;
    map['closing_hour'] = closingHour;
    map['is_promotion'] = isPromotion;
    map['phone1'] = phone1;
    map['phone2'] = phone2;
    map['phone3'] = phone3;
    map['email'] = email;
    map['address'] = address;
    map['facebook'] = facebook;
    map['google_plus'] = googlePlus;
    map['twitter'] = twitter;
    map['youtube'] = youtube;
    map['instagram'] = instagram;
    map['pinterest'] = pinterest;
    map['website'] = website;
    map['whatsapp'] = whatsapp;
    map['messenger'] = messenger;
    map['time_remark'] = timeRemark;
    map['terms'] = terms;
    map['cancelation_policy'] = cancelationPolicy;
    map['additional_info'] = additionalInfo;

    return map;
  }

  @override
  ItemEntryParameterHolder fromMap(dynamic dynamicData) {
    return ItemEntryParameterHolder(
      id: dynamicData['id'],
      cityId: dynamicData['city_id'],
      catId: dynamicData['cat_id'],
      subCatId: dynamicData['sub_cat_id'],
      status: dynamicData['status'],
      name: dynamicData['name'],
      description: dynamicData['description'],
      searchTag: dynamicData['search_tag'],
      highlightInformation: dynamicData['highlight_information'],
      isFeatured: dynamicData['is_featured'],
      userId: dynamicData['user_id'],
      lat: dynamicData['lat'],
      lng: dynamicData['lng'],
      openingHour: dynamicData['opening_hour'],
      closingHour: dynamicData['closing_hour'],
      isPromotion: dynamicData['is_promotion'],
      phone1: dynamicData['phone1'],
      phone2: dynamicData['phone2'],
      phone3: dynamicData['phone3'],
      email: dynamicData['email'],
      address: dynamicData['address'],
      facebook: dynamicData['facebook'],
      googlePlus: dynamicData['google_plus'],
      twitter: dynamicData['twitter'],
      youtube: dynamicData['youtube'],
      instagram: dynamicData['instagram'],
      pinterest: dynamicData['pinterest'],
      website: dynamicData['website'],
      whatsapp: dynamicData['whatsapp'],
      messenger: dynamicData['messenger'],
      timeRemark: dynamicData['time_remark'],
      terms: dynamicData['terms'],
      cancelationPolicy: dynamicData['cancelation_policy'],
      additionalInfo: dynamicData['additional_info'],
    );
  }

  @override
  String getParamKey() {
    String key = '';

    if (id != '') {
      key += id;
    }
    if (cityId != '') {
      key += cityId;
    }
    if (catId != '') {
      key += catId;
    }
    if (subCatId != '') {
      key += subCatId;
    }
    if (status != '') {
      key += status;
    }
    if (name != '') {
      key += name;
    }
    if (description != '') {
      key += description;
    }
    if (searchTag != '') {
      key += searchTag;
    }
    if (highlightInformation != '') {
      key += highlightInformation;
    }
    if (isFeatured != '') {
      key += isFeatured;
    }
    if (userId != '') {
      key += userId;
    }
    if (lat != '') {
      key += lat;
    }
    if (lng != '') {
      key += lng;
    }
    if (openingHour != '') {
      key += openingHour;
    }
    if (closingHour != '') {
      key += closingHour;
    }
    if (isPromotion != '') {
      key += isPromotion;
    }
    if (phone1 != '') {
      key += phone1;
    }
    if (phone2 != '') {
      key += phone2;
    }
    if (phone3 != '') {
      key += phone3;
    }
    if (email != '') {
      key += email;
    }
    if (address != '') {
      key += address;
    }
    if (facebook != '') {
      key += facebook;
    }
    if (googlePlus != '') {
      key += googlePlus;
    }
    if (twitter != '') {
      key += twitter;
    }

    if (youtube != '') {
      key += youtube;
    }
    if (instagram != '') {
      key += instagram;
    }
    if (pinterest != '') {
      key += pinterest;
    }
    if (website != '') {
      key += website;
    }
    if (whatsapp != '') {
      key += whatsapp;
    }
    if (messenger != '') {
      key += messenger;
    }
    if (timeRemark != '') {
      key += timeRemark;
    }
    if (terms != '') {
      key += terms;
    }
    if (cancelationPolicy != '') {
      key += cancelationPolicy;
    }
    if (additionalInfo != '') {
      key += additionalInfo;
    }

    return key;
  }
}
