import 'package:quiver/core.dart';
import 'common/ps_map_object.dart';

class RelatedItem extends PsMapObject<RelatedItem> {
  RelatedItem({this.id, this.mainItemId, int sorting}) {
    super.sorting = sorting;
  }
  String id;
  String mainItemId;

  @override
  bool operator ==(dynamic other) => other is RelatedItem && id == other.id;

  @override
  int get hashCode => hash2(id.hashCode, id.hashCode);

  @override
  String getPrimaryKey() {
    return id;
  }

  @override
  RelatedItem fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return RelatedItem(
          id: dynamicData['id'],
          sorting: dynamicData['sorting'],
          mainItemId: dynamicData['main_item_id']);
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(dynamic object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = object.id;
      data['sorting'] = object.sorting;
      data['main_item_id'] = object.mainItemId;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<RelatedItem> fromMapList(List<dynamic> dynamicDataList) {
    final List<RelatedItem> relatedItemMapList = <RelatedItem>[];

    if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          relatedItemMapList.add(fromMap(dynamicData));
        }
      }
    }
    return relatedItemMapList;
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
          idList.add(item.id);
        }
      }
    }
    return idList;
  }
}
