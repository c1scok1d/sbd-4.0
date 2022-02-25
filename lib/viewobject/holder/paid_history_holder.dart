import 'package:flutter/cupertino.dart';
import 'package:businesslistingapi/provider/promotion/item_promotion_provider.dart';
import 'package:businesslistingapi/viewobject/item.dart';

class PaidHistoryHolder {
  const PaidHistoryHolder(
      {@required this.item,
      @required this.amount,
      @required this.howManyDay,
      @required this.paymentMethod,
      @required this.stripePublishableKey,
      @required this.startDate,
      @required this.startTimeStamp,
      @required this.itemPaidHistoryProvider,
      @required this.payStackKey});

  final Item item;
  final String amount;
  final String howManyDay;
  final String paymentMethod;
  final String stripePublishableKey;
  final String startDate;
  final String startTimeStamp;
  final ItemPromotionProvider itemPaidHistoryProvider;
  final String payStackKey;
}
