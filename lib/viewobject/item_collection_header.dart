import 'package:businesslistingapi/viewobject/item.dart';
import 'package:quiver/core.dart';
import 'package:businesslistingapi/viewobject/common/ps_object.dart';
import 'default_photo.dart';

class ItemCollectionHeader extends PsObject<ItemCollectionHeader> {
  ItemCollectionHeader(
      {this.id,
      this.name,
      this.cityId,
      this.status,
      this.addedDate,
      this.addedUserId,
      this.updatedDate,
      this.updatedUserId,
      this.updatedFlag,
      this.addedDateStr,
      this.defaultPhoto,
      this.itemList});
  String id;
  String name;
  String cityId;
  String status;
  String addedDate;
  String addedUserId;
  String updatedDate;
  String updatedUserId;
  String updatedFlag;
  String addedDateStr;
  DefaultPhoto defaultPhoto;
  List<Item> itemList;

  @override
  bool operator ==(dynamic other) =>
      other is ItemCollectionHeader && id == other.id;

  @override
  int get hashCode => hash2(id.hashCode, id.hashCode);

  @override
  String getPrimaryKey() {
    return id;
  }

  @override
  ItemCollectionHeader fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return ItemCollectionHeader(
          id: dynamicData['id'],
          name: dynamicData['name'],
          cityId: dynamicData['city_id'],
          status: dynamicData['status'],
          addedDate: dynamicData['added_date'],
          addedUserId: dynamicData['added_user_id'],
          updatedDate: dynamicData['updated_date'],
          updatedUserId: dynamicData['updated_user_id'],
          updatedFlag: dynamicData['updated_flag'],
          addedDateStr: dynamicData['added_date_str'],
          defaultPhoto: DefaultPhoto().fromMap(dynamicData['default_photo']),
          itemList: Item().fromMapList(dynamicData['items']));
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
      data['city_id'] = object.cityId;
      data['status'] = object.status;
      data['added_date'] = object.addedDate;
      data['added_user_id'] = object.addedUserId;
      data['updated_date'] = object.updatedDate;
      data['updated_user_id'] = object.updatedUserId;
      data['updated_flag'] = object.updatedFlag;
      data['added_date_str'] = object.addedDateStr;
      data['default_photo'] = DefaultPhoto().toMap(object.defaultPhoto);
      data['items'] = Item().toMapList(object.itemList);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<ItemCollectionHeader> fromMapList(List<dynamic> dynamicDataList) {
    final List<ItemCollectionHeader> subCategoryList = <ItemCollectionHeader>[];

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
