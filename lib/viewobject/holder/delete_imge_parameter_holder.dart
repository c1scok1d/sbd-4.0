import 'package:businesslistingapi/viewobject/common/ps_holder.dart' show PsHolder;
import 'package:flutter/cupertino.dart';

class DeleteImageParameterHolder extends PsHolder<DeleteImageParameterHolder> {
  DeleteImageParameterHolder({
    @required this.itemId,
    @required this.imgId,
  });

  final String itemId;
  final String imgId;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['item_id'] = itemId;
    map['img_id'] = imgId;
    return map;
  }

  @override
  DeleteImageParameterHolder fromMap(dynamic dynamicData) {
    return DeleteImageParameterHolder(
      itemId: dynamicData['item_id'],
      imgId: dynamicData['img_id'],
    );
  }

  @override
  String getParamKey() {
    String key = '';

    if (itemId != '') {
      key += itemId;
    }
    if (imgId != '') {
      key += imgId;
    }

    return key;
  }
}
