import 'package:businesslistingapi/viewobject/common/ps_holder.dart'
    show PsHolder;
import 'package:flutter/cupertino.dart';

class CommentDetailParameterHolder
    extends PsHolder<CommentDetailParameterHolder> {
  CommentDetailParameterHolder(
      {@required this.userId,
      @required this.headerId,
      @required this.cityId,
      @required this.detailComment});

  final String userId;
  final String headerId;
  final String cityId;
  final String detailComment;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['user_id'] = userId;
    map['header_id'] = headerId;
    map['city_id'] = cityId;
    map['detail_comment'] = detailComment;

    return map;
  }

  @override
  CommentDetailParameterHolder fromMap(dynamic dynamicData) {
    return CommentDetailParameterHolder(
      userId: dynamicData['user_id'],
      headerId: dynamicData['header_id'],
      cityId: dynamicData['city_id'],
      detailComment: dynamicData['detail_comment'],
    );
  }

  @override
  String getParamKey() {
    String key = '';

    if (userId != '') {
      key += userId;
    }
    if (headerId != '') {
      key += headerId;
    }
    if (cityId != '') {
      key += cityId;
    }
    if (detailComment != '') {
      key += detailComment;
    }
    return key;
  }
}
