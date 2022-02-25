import 'package:businesslistingapi/viewobject/common/ps_holder.dart'
    show PsHolder;
import 'package:flutter/cupertino.dart';

class CommentHeaderParameterHolder
    extends PsHolder<CommentHeaderParameterHolder> {
  CommentHeaderParameterHolder({
    @required this.userId,
    @required this.itemId,
    @required this.cityId,
    @required this.headerComment,
  });

  final String userId;
  final String itemId;
  final String cityId;
  final String headerComment;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['user_id'] = userId;
    map['item_id'] = itemId;
    map['city_id'] = cityId;
    map['header_comment'] = headerComment;

    return map;
  }

  @override
  CommentHeaderParameterHolder fromMap(dynamic dynamicData) {
    return CommentHeaderParameterHolder(
      userId: dynamicData['user_id'],
      itemId: dynamicData['item_id'],
      cityId: dynamicData['city_id'],
      headerComment: dynamicData['header_comment'],
    );
  }

  @override
  String getParamKey() {
    String key = '';

    if (userId != '') {
      key += userId;
    }
    if (itemId != '') {
      key += itemId;
    }
    if (cityId != '') {
      key += cityId;
    }
    if (headerComment != '') {
      key += headerComment;
    }
    return key;
  }
}
