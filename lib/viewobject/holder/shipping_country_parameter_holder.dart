import 'package:businesslistingapi/viewobject/common/ps_holder.dart' show PsHolder;
import 'package:flutter/cupertino.dart';

class ShippingCountryParameterHolder
    extends PsHolder<ShippingCountryParameterHolder> {
  ShippingCountryParameterHolder({
    @required this.shopId,
  });

  final String shopId;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['contact_id'] = shopId;

    return map;
  }

  @override
  ShippingCountryParameterHolder fromMap(dynamic dynamicData) {
    return ShippingCountryParameterHolder(
      shopId: dynamicData['contact_id'],
    );
  }

  @override
  String getParamKey() {
    String key = '';

    if (shopId != '') {
      key += shopId;
    }
    return key;
  }
}
