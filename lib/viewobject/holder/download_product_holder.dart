import 'package:businesslistingapi/viewobject/common/ps_holder.dart' show PsHolder;
import 'package:flutter/cupertino.dart';

class DownloadItemParameterHolder
    extends PsHolder<DownloadItemParameterHolder> {
  DownloadItemParameterHolder(
      {@required this.userId, @required this.productId});

  final String userId;
  final String productId;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['user_id'] = userId;
    map['product_id'] = productId;

    return map;
  }

  @override
  DownloadItemParameterHolder fromMap(dynamic dynamicData) {
    return DownloadItemParameterHolder(
      userId: dynamicData['user_id'],
      productId: dynamicData['product_id'],
    );
  }

  @override
  String getParamKey() {
    String key = '';

    if (userId != '') {
      key += userId;
    }
    if (productId != '') {
      key += productId;
    }
    return key;
  }
}
