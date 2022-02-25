import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:businesslistingapi/api/common/ps_resource.dart';
import 'package:businesslistingapi/constant/ps_constants.dart';
import 'package:businesslistingapi/constant/ps_dimens.dart';
import 'package:businesslistingapi/provider/promotion/item_promotion_provider.dart';
import 'package:businesslistingapi/ui/common/base/ps_widget_with_appbar_with_no_provider.dart';
import 'package:businesslistingapi/ui/common/dialog/error_dialog.dart';
import 'package:businesslistingapi/ui/common/dialog/success_dialog.dart';
import 'package:businesslistingapi/ui/common/dialog/warning_dialog_view.dart';
import 'package:businesslistingapi/ui/common/ps_button_widget.dart';
import 'package:businesslistingapi/utils/ps_progress_dialog.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:businesslistingapi/viewobject/holder/item_paid_history_parameter_holder.dart';
import 'package:businesslistingapi/viewobject/item.dart';
import 'package:businesslistingapi/viewobject/item_paid_history.dart';


class CreditCardView extends StatefulWidget {
  const CreditCardView(
      {Key key,
      @required this.item,
      @required this.amount,
      @required this.howManyDay,
      @required this.paymentMethod,
      @required this.stripePublishableKey,
      @required this.startDate,
      @required this.startTimeStamp,
      @required this.itemPaidHistoryProvider})
      : super(key: key);

  final Item item;
  final String amount;
  final String howManyDay;
  final String paymentMethod;
  final String stripePublishableKey;
  final String startDate;
  final String startTimeStamp;
  final ItemPromotionProvider itemPaidHistoryProvider;

  @override
  State<StatefulWidget> createState() {
    return CreditCardViewState();
  }
}

dynamic callPaidAdSubmitApi(
  BuildContext context,
  Item item,
  String amount,
  String howManyDay,
  String paymentMethod,
  String stripePublishableKey,
  String startDate,
  String startTimeStamp,
  ItemPromotionProvider itemPaidHistoryProvider,
  // ProgressDialog progressDialog,
  String token,
) async {
  if (await Utils.checkInternetConnectivity()) {
    final ItemPaidHistoryParameterHolder itemPaidHistoryParameterHolder =
        ItemPaidHistoryParameterHolder(
            itemId: item.id,
            amount: amount,
            howManyDay: howManyDay,
            paymentMethod: paymentMethod,
            paymentMethodNounce: Platform.isIOS ? token : token,
            startDate: startDate,
            startTimeStamp: startTimeStamp,
            razorId: '',
            isPaystack: PsConst.ZERO);

    final PsResource<ItemPaidHistory> padiHistoryDataStatus =
        await itemPaidHistoryProvider
            .postItemHistoryEntry(itemPaidHistoryParameterHolder.toMap());

    if (padiHistoryDataStatus.data != null) {
      // progressDialog.dismiss();
      PsProgressDialog.dismissDialog();
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext contet) {
            return SuccessDialog(
              message: Utils.getString(context, 'item_promote__success'),
              onPressed: () {
                Navigator.pop(context, true);
              },
            );
          });
    } else {
      PsProgressDialog.dismissDialog();
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(
              message: padiHistoryDataStatus.message,
            );
          });
    }
  } else {
    showDialog<dynamic>(
        context: context,
        builder: (BuildContext context) {
          return ErrorDialog(
            message: Utils.getString(context, 'error_dialog__no_internet'),
          );
        });
  }
}

class CreditCardViewState extends State<CreditCardView> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  CardFieldInputDetails cardData;

  @override
  void initState() {
    Stripe.publishableKey = widget.stripePublishableKey;
    super.initState();
  }

  void setError(dynamic error) {
    showDialog<dynamic>(
        context: context,
        builder: (BuildContext context) {
          return ErrorDialog(
            message: Utils.getString(context, error.toString()),
          );
        });
  }

  dynamic callWarningDialog(BuildContext context, String text) {
    showDialog<dynamic>(
        context: context,
        builder: (BuildContext context) {
          return WarningDialog(
            message: Utils.getString(context, text),
            onPressed: () {},
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    dynamic stripeNow(String token) async {
      callPaidAdSubmitApi(
        context,
        widget.item,
        widget.amount,
        widget.howManyDay,
        widget.paymentMethod,
        widget.stripePublishableKey,
        widget.startDate,
        widget.startTimeStamp,
        widget.itemPaidHistoryProvider,
        // progressDialog,
        token,
      );
    }

    return PsWidgetWithAppBarWithNoProvider(
      appBarTitle: 'Credit Card',
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(PsDimens.space16),
            child: CardField(
              autofocus: true,
              onCardChanged: (CardFieldInputDetails card) async {
                setState(() {
                  cardData = card;
                });
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
                left: PsDimens.space12, right: PsDimens.space12),
            child: PSButtonWidget(
              hasShadow: true,
              width: double.infinity,
              titleText: Utils.getString(context, 'credit_card__pay'),
              onPressed: () async {
                if (cardData != null && cardData.complete) {
                  await PsProgressDialog.showDialog(context);
                  final PaymentMethod paymentMethod = await Stripe.instance
                      .createPaymentMethod(const PaymentMethodParams.card());
                  Utils.psPrint(paymentMethod.id);
                  await stripeNow(paymentMethod.id);
                } else {
                  callWarningDialog(
                      context, Utils.getString(context, 'contact_us__fail'));
                }
              },
            ),
          ),            
        ],
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    if (mounted) {
      setState(() {
        cardNumber = creditCardModel.cardNumber;
        expiryDate = creditCardModel.expiryDate;
        cardHolderName = creditCardModel.cardHolderName;
        cvvCode = creditCardModel.cvvCode;
        isCvvFocused = creditCardModel.isCvvFocused;
      });
    }
  }
}
