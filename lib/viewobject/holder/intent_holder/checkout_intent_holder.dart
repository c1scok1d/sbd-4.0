import 'package:businesslistingapi/viewobject/basket.dart';
import 'package:flutter/cupertino.dart';

class CheckoutIntentHolder {
  const CheckoutIntentHolder({
    @required this.basketList,
    @required this.publishKey,
  });
  final List<Basket> basketList;
  final String publishKey;
}
