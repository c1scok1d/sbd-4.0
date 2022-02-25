import 'package:flutter/cupertino.dart';
import 'package:businesslistingapi/viewobject/basket_selected_attribute.dart';
import 'package:businesslistingapi/viewobject/item.dart';

class BasketIntentHolder {
  const BasketIntentHolder({
    @required this.id,
    @required this.qty,
    @required this.selectedColorId,
    @required this.selectedColorValue,
    @required this.basketPrice,
    @required this.basketSelectedAttributeList,
    @required this.product,
  });
  final String id;
  final String basketPrice;
  final List<BasketSelectedAttribute> basketSelectedAttributeList;
  final String selectedColorId;
  final String selectedColorValue;
  final Item product;
  final String qty;
}
