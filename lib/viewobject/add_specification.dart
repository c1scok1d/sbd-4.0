import 'package:quiver/core.dart';
import 'package:businesslistingapi/viewobject/common/ps_map_object.dart';

class AddSpecification extends PsMapObject<AddSpecification> {
  AddSpecification({this.id, int sorting}) {
    super.sorting = sorting;
  }
  String id;

  @override
  bool operator ==(dynamic other) =>
      other is AddSpecification && id == other.id;

  @override
  int get hashCode => hash2(id.hashCode, id.hashCode);

  @override
  String getPrimaryKey() {
    return id;
  }

  @override
  AddSpecification fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return AddSpecification(
          id: dynamicData['id'], sorting: dynamicData['sorting']);
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
      return data;
    } else {
      return null;
    }
  }

  @override
  List<AddSpecification> fromMapList(List<dynamic> dynamicDataList) {
    final List<AddSpecification> addSpecificationMapList = <AddSpecification>[];

    if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          addSpecificationMapList.add(fromMap(dynamicData));
        }
      }
    }
    return addSpecificationMapList;
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
      for (dynamic specification in mapList) {
        if (specification != null) {
          idList.add(specification.id);
        }
      }
    }
    return idList;
  }
}
