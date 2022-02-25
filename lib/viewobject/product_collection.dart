import 'package:quiver/core.dart';
import 'common/ps_map_object.dart';

class ItemCollection extends PsMapObject<ItemCollection> {
  ItemCollection({this.collectionId, this.id, int sorting}) {
    super.sorting = sorting;
  }
  String id;
  String collectionId;

  @override
  bool operator ==(dynamic other) => other is ItemCollection && id == other.id;

  @override
  int get hashCode => hash2(id.hashCode, id.hashCode);

  @override
  String getPrimaryKey() {
    return id;
  }

  @override
  ItemCollection fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return ItemCollection(
          id: dynamicData['id'],
          collectionId: dynamicData['collection_id'],
          sorting: dynamicData['sorting']);
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(dynamic object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = object.id;
      data['collection_id'] = object.collectionId;
      data['sorting'] = object.sorting;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<ItemCollection> fromMapList(List<dynamic> dynamicDataList) {
    final List<ItemCollection> productCollectionMapList = <ItemCollection>[];

    if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          productCollectionMapList.add(fromMap(dynamicData));
        }
      }
    }
    return productCollectionMapList;
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
      for (dynamic product in mapList) {
        if (product != null) {
          idList.add(product.id);
        }
      }
    }
    return idList;
  }

  List<String> getCollectionList(List<dynamic> mapList) {
    final List<String> idList = <String>[];
    if (mapList != null) {
      for (dynamic collection in mapList) {
        if (collection != null) {
          idList.add(collection.collectionId);
        }
      }
    }
    return idList;
  }

  List<ItemCollection> getItemCollectionList(List<dynamic> mapList) {
    final List<ItemCollection> idList = <ItemCollection>[];
    if (mapList != null) {
      for (dynamic collection in mapList) {
        if (collection != null) {
          idList.add(collection.collectionId);
        }
      }
    }
    return idList;
  }
}
