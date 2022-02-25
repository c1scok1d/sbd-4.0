import 'package:businesslistingapi/provider/promotion/item_promotion_provider.dart';

import 'package:businesslistingapi/viewobject/item.dart';

class PayStackRequestInterntHolder {
  const PayStackRequestInterntHolder(
      {this.item,
      this.amount,
      this.howManyDay,
      this.paymentMethod,
      this.startDate,
      this.payStackKey,
      this.startTimeStamp,
      this.itemPaidHistoryProvider,
      this.firstName,
      this.lastName,
      this.userEmail});

  final Item item;
  final String amount;
  final String howManyDay;
  final String paymentMethod;
  final String startDate;
  final String payStackKey;
  final String startTimeStamp;
  final ItemPromotionProvider itemPaidHistoryProvider;
  final String firstName;
  final String lastName;
  final String userEmail;
}
