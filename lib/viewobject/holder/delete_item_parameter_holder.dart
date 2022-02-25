import 'package:businesslistingapi/viewobject/common/ps_holder.dart' show PsHolder;
import 'package:flutter/cupertino.dart';

class DeleteItemParameterHolder extends PsHolder<DeleteItemParameterHolder> {
  DeleteItemParameterHolder({
    @required this.itemId,
    @required this.userId,
  });

  final String itemId;
  final String userId;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['item_id'] = itemId;
    map['user_id'] = userId;
    return map;
  }

  @override
  DeleteItemParameterHolder fromMap(dynamic dynamicData) {
    return DeleteItemParameterHolder(
      itemId: dynamicData['item_id'],
      userId: dynamicData['user_id'],
    );
  }

  @override
  String getParamKey() {
    String key = '';

    if (itemId != '') {
      key += itemId;
    }
    if (userId != '') {
      key += userId;
    }

    return key;
  }
}
