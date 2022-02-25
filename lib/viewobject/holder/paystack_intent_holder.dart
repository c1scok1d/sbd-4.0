import 'package:flutter/cupertino.dart';
import 'package:businesslistingapi/provider/promotion/item_promotion_provider.dart';
import 'package:businesslistingapi/provider/user/user_provider.dart';
import 'package:businesslistingapi/viewobject/item.dart';

class PayStackInterntHolder {
  const PayStackInterntHolder({
    @required this.item,
    @required this.amount,
    @required this.howManyDay,
    @required this.paymentMethod,
    @required this.stripePublishableKey,
    @required this.startDate,
    @required this.startTimeStamp,
    @required this.itemPaidHistoryProvider,
    @required this.userProvider,
    @required this.payStackKey,
    @required this.userEmail,
  });

  final Item item;
  final String amount;
  final String howManyDay;
  final String paymentMethod;
  final String stripePublishableKey;
  final String startDate;
  final String startTimeStamp;
  final ItemPromotionProvider itemPaidHistoryProvider;
  final UserProvider userProvider;
  final String payStackKey;
  final String userEmail;
}
