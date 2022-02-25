import 'package:businesslistingapi/viewobject/common/ps_object.dart';
import 'default_photo.dart';

class CityInfo extends PsObject<CityInfo> {
  CityInfo(
      {this.id,
      this.name,
      this.description,
      this.phone,
      this.email,
      this.address,
      this.lat,
      this.lng,
      this.addedDate,
      this.status,
      this.isFeatured,
      this.termsAndCondition,
      this.featuredDate,
      this.addedUserId,
      this.updatedDate,
      this.updatedUserId,
      this.touchCount,
      this.addedDateStr,
      this.defaultPhoto});
  String id;
  String name;
  String description;
  String phone;
  String email;
  String address;
  String lat;
  String lng;
  String addedDate;
  String status;
  String isFeatured;
  String termsAndCondition;
  String featuredDate;
  String addedUserId;
  String updatedDate;
  String updatedUserId;
  String touchCount;
  String addedDateStr;
  DefaultPhoto defaultPhoto;

  @override
  String getPrimaryKey() {
    return id;
  }

  @override
  CityInfo fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return CityInfo(
        id: dynamicData['id'],
        name: dynamicData['name'],
        description: dynamicData['description'],
        phone: dynamicData['phone'],
        email: dynamicData['email'],
        address: dynamicData['address'],
        lat: dynamicData['lat'],
        lng: dynamicData['lng'],
        addedDate: dynamicData['added_date'],
        status: dynamicData['status'],
        isFeatured: dynamicData['is_featured'],
        termsAndCondition: dynamicData['Terms & Conditions'],
        featuredDate: dynamicData['featured_date'],
        addedUserId: dynamicData['added_user_id'],
        updatedDate: dynamicData['updated_date'],
        updatedUserId: dynamicData['updated_user_id'],
        touchCount: dynamicData['touch_count'],
        addedDateStr: dynamicData['added_date_str'],
        defaultPhoto: DefaultPhoto().fromMap(dynamicData['default_photo']),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(dynamic object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = object.id;
      data['name'] = object.name;
      data['description'] = object.description;
      data['phone'] = object.phone;
      data['email'] = object.email;
      data['address'] = object.address;
      data['lat'] = object.lat;
      data['lng'] = object.lng;
      data['added_date'] = object.addedDate;
      data['status'] = object.status;
      data['is_featured'] = object.isFeatured;
      data['Terms & Conditions'] = object.termsAndCondition;
      data['featured_date'] = object.featuredDate;
      data['added_user_id'] = object.addedUserId;
      data['updated_date'] = object.updatedDate;
      data['updated_user_id'] = object.updatedUserId;
      data['touch_count'] = object.touchCount;
      data['added_date_str'] = object.addedDateStr;
      data['default_photo'] = DefaultPhoto().toMap(object.defaultPhoto);

      return data;
    } else {
      return null;
    }
  }

  @override
  List<CityInfo> fromMapList(List<dynamic> dynamicDataList) {
    final List<CityInfo> subCategoryList = <CityInfo>[];

    if (dynamicDataList != null) {
      for (dynamic json in dynamicDataList) {
        if (json != null) {
          subCategoryList.add(fromMap(json));
        }
      }
    }
    return subCategoryList;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<dynamic> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (dynamic data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }

    return mapList;
  }
}
