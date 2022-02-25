import 'package:quiver/core.dart';
import 'package:businesslistingapi/viewobject/common/ps_map_object.dart';

class CityMap extends PsMapObject<CityMap> {
  CityMap({this.id, this.mapKey, this.cityId, int sorting, this.addedDate}) {
    super.sorting = sorting;
  }

  String id;
  String mapKey;
  String cityId;
  String addedDate;

  @override
  bool operator ==(dynamic other) => other is CityMap && id == other.id;

  @override
  int get hashCode => hash2(id.hashCode, id.hashCode);

  @override
  String getPrimaryKey() {
    return id;
  }

  @override
  CityMap fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return CityMap(
          id: dynamicData['id'],
          mapKey: dynamicData['map_key'],
          cityId: dynamicData['city_id'],
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
      data['city_id'] = object.cityId;
      data['sorting'] = object.sorting;
      data['added_date'] = object.addedDate;

      return data;
    } else {
      return null;
    }
  }

  @override
  List<CityMap> fromMapList(List<dynamic> dynamicDataList) {
    final List<CityMap> cityMapList = <CityMap>[];

    if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          cityMapList.add(fromMap(dynamicData));
        }
      }
    }
    return cityMapList;
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
      for (dynamic city in mapList) {
        if (city != null) {
          idList.add(city.cityId);
        }
      }
    }
    return idList;
  }
}
