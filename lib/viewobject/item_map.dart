import 'package:quiver/core.dart';
import 'package:businesslistingapi/viewobject/common/ps_map_object.dart';

class ItemMap extends PsMapObject<ItemMap> {
  ItemMap({this.id, this.mapKey, this.itemId, int sorting, this.addedDate}) {
    super.sorting = sorting;
  }

  String id;
  String mapKey;
  String itemId;
  String addedDate;

  @override
  bool operator ==(dynamic other) => other is ItemMap && id == other.id;

  @override
  int get hashCode => hash2(id.hashCode, id.hashCode);

  @override
  String getPrimaryKey() {
    return id;
  }

  @override
  ItemMap fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return ItemMap(
          id: dynamicData['id'],
          mapKey: dynamicData['map_key'],
          itemId: dynamicData['item_id'],
          sorting: dynamicData['sorting'],
          addedDate: dynamicData['added_date']);
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(dynamic object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = object.id;
      data['map_key'] = object.mapKey;
      data['item_id'] = object.itemId;
      data['sorting'] = object.sorting;
      data['added_date'] = object.addedDate;

      return data;
    } else {
      return null;
    }
  }

  @override
  List<ItemMap> fromMapList(List<dynamic> dynamicDataList) {
    final List<ItemMap> itemMapList = <ItemMap>[];

    if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          itemMapList.add(fromMap(dynamicData));
        }
      }
    }
    return itemMapList;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<dynamic> objectList) {
    final List<Map<String, dynamic>> dynamicList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (dynamic data in objectList) {
        if (data != null) {
          dynamicList.add(toMap(data));
        }
      }
    }

    return dynamicList;
  }

  @override
  List<String> getIdList(List<dynamic> mapList) {
    final List<String> idList = <String>[];
    if (mapList != null) {
      for (dynamic item in mapList) {
        if (item != null) {
          idList.add(item.itemId);
        }
      }
    }
    return idList;
  }
}
