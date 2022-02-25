import 'package:quiver/core.dart';
import 'package:businesslistingapi/viewobject/common/ps_map_object.dart';

class GalleryImage extends PsMapObject<GalleryImage> {
  GalleryImage({this.id, int sorting}) {
    super.sorting = sorting;
  }
  String id;

  @override
  bool operator ==(dynamic other) => other is GalleryImage && id == other.id;

  @override
  int get hashCode => hash2(id.hashCode, id.hashCode);

  @override
  String getPrimaryKey() {
    return id;
  }

  @override
  GalleryImage fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return GalleryImage(
          id: dynamicData['img_parent_id'], sorting: dynamicData['sorting']);
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(dynamic object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['img_parent_id'] = object.id;
      data['sorting'] = object.sorting;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<GalleryImage> fromMapList(List<dynamic> dynamicDataList) {
    final List<GalleryImage> galleryImageMapList = <GalleryImage>[];

    if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          galleryImageMapList.add(fromMap(dynamicData));
        }
      }
    }
    return galleryImageMapList;
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
      for (dynamic galleryImage in mapList) {
        if (galleryImage != null) {
          idList.add(galleryImage.id);
        }
      }
    }
    return idList;
  }
}
