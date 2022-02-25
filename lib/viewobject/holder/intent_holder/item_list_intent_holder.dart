import 'package:flutter/cupertino.dart';
import 'package:businesslistingapi/viewobject/holder/item_parameter_holder.dart';

class ItemListIntentHolder {
  const ItemListIntentHolder({
    @required this.itemParameterHolder,
    @required this.appBarTitle,
    @required this.checkPage,
  });
  final ItemParameterHolder itemParameterHolder;
  final String appBarTitle;
  final String checkPage;
}
