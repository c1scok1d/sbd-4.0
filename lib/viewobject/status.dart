import 'package:businesslistingapi/viewobject/common/ps_object.dart';

class Status extends PsObject<Status> {
  Status({this.id, this.title, this.addedDate});

  String id;
  String title;
  String addedDate;

  @override
  String getPrimaryKey() {
    return id;
  }

  @override
  Status fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return Status(
        id: dynamicData['id'],
        title: dynamicData['title'],
        addedDate: dynamicData['added_date'],
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(dynamic object) {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (object != null) {
      data['id'] = object.id;
      data['title'] = object.title;
      data['added_date'] = object.addedDate;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<Status> fromMapList(List<dynamic> dynamicDataList) {
    final List<Status> statusList = <Status>[];

    if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          statusList.add(fromMap(dynamicData));
        }
      }
    }
    return statusList;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<Status> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];

    if (objectList != null) {
      for (Status data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }

    return mapList;
  }
}
