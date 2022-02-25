import 'package:flutter/material.dart';
import 'package:businesslistingapi/viewobject/AttributeDetail.dart';
import 'package:businesslistingapi/viewobject/item.dart';

class AttributeDetailIntentHolder {
  const AttributeDetailIntentHolder({
    @required this.product,
    @required this.attributeDetail,
  });
  final Item product;
  final List<AttributeDetail> attributeDetail;
}
