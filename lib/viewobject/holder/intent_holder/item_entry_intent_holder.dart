import 'package:flutter/cupertino.dart';
import 'package:businesslistingapi/viewobject/item.dart';

class ItemEntryIntentHolder {
  const ItemEntryIntentHolder({
    @required this.flag,
    @required this.item,
  });
  final String flag;
  final Item item;
}
