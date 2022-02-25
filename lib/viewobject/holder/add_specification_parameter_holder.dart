import 'package:businesslistingapi/viewobject/common/ps_holder.dart' show PsHolder;
import 'package:flutter/cupertino.dart';

class AddSpecificationParameterHolder
    extends PsHolder<AddSpecificationParameterHolder> {
  AddSpecificationParameterHolder({
    @required this.itemId,
    @required this.name,
    @required this.description,
  });

  final String itemId;
  final String name;
  final String description;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['item_id'] = itemId;
    map['name'] = name;
    map['description'] = description;
    return map;
  }

  @override
  AddSpecificationParameterHolder fromMap(dynamic dynamicData) {
    return AddSpecificationParameterHolder(
      itemId: dynamicData['item_id'],
      name: dynamicData['name'],
      description: dynamicData['description'],
    );
  }

  @override
  String getParamKey() {
    String key = '';

    if (itemId != '') {
      key += itemId;
    }
    if (name != '') {
      key += name;
    }
    if (description != '') {
      key += description;
    }

    return key;
  }
}
