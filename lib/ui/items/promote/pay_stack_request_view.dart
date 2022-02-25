import 'package:flutter/services.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:businesslistingapi/api/common/ps_resource.dart';
import 'package:businesslistingapi/config/ps_colors.dart';
import 'package:businesslistingapi/constant/ps_constants.dart';
import 'package:businesslistingapi/constant/ps_dimens.dart';
import 'package:businesslistingapi/constant/route_paths.dart';
import 'package:businesslistingapi/provider/promotion/item_promotion_provider.dart';
import 'package:businesslistingapi/provider/user/user_provider.dart';
import 'package:businesslistingapi/repository/user_repository.dart';
import 'package:businesslistingapi/ui/common/dialog/error_dialog.dart';
import 'package:businesslistingapi/ui/common/dialog/success_dialog.dart';
import 'package:businesslistingapi/ui/common/dialog/warning_dialog_view.dart';
import 'package:businesslistingapi/ui/common/ps_button_widget.dart';
import 'package:businesslistingapi/ui/common/ps_textfield_widget.dart';
import 'package:businesslistingapi/utils/ps_progress_dialog.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:businesslistingapi/viewobject/common/ps_value_holder.dart';
import 'package:businesslistingapi/viewobject/holder/item_paid_history_parameter_holder.dart';
import 'package:businesslistingapi/viewobject/holder/paystack_intent_holder.dart';
import 'package:businesslistingapi/viewobject/item.dart';
import 'package:businesslistingapi/viewobject/item_paid_history.dart';
import 'package:provider/provider.dart';

class PayStackRequestView extends StatefulWidget {
  const PayStackRequestView({
    Key key,
    @required this.item,
    @required this.amount,
    @required this.howManyDay,
    @required this.paymentMethod,
    @required this.startDate,
    @required this.payStackKey,
    @required this.startTimeStamp,
    @required this.itemPaidHistoryProvider,
    @required this.firstName,
    @required this.lastName,
    @required this.userEmail,
    //@required this.userPhone,
  }) : super(key: key);

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
  // final String userPhone;

  @override
  State<StatefulWidget> createState() {
    return PayStackRequestViewState();
  }
}

class PayStackRequestViewState extends State<PayStackRequestView> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  UserRepository repo1;
  PsValueHolder psValueHolder;
  bool bindDataFirstTime = true;
  String stripePublishableKey;
  String startDate;
  String startTimeStamp;
  final PaystackPlugin plugin = PaystackPlugin();


  @override
  void initState() {
    plugin.initialize(publicKey: widget.payStackKey);
    // MpesaFlutterPlugin.setConsumerKey('JyDkh1nIueVAP9dt0BA6onbVPmtdNQ5e');
    // MpesaFlutterPlugin.setConsumerSecret('mnifM6PEGYYlOXat');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    repo1 = Provider.of<UserRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    return ChangeNotifierProvider<UserProvider>(
      lazy: false,
      create: (BuildContext context) {
        final UserProvider provider =
            UserProvider(repo: repo1, psValueHolder: psValueHolder);
        provider.getUser(provider.psValueHolder.loginUserId);
        return provider;
      },
      child: Consumer<UserProvider>(
          builder: (BuildContext context, UserProvider provider, Widget child) {
        if (provider != null &&
            provider.user != null &&
            provider.user.data != null) {
          if (bindDataFirstTime) {
            emailController.text = provider.user.data.userEmail;
          }
        }
        return Scaffold(
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarIconBrightness: Utils.getBrightnessForAppBar(context),
            ),
            iconTheme: IconThemeData(color: PsColors.mainColorWithWhite),
            title: Text(
              Utils.getString(context, 'item_promote__pay_stack'),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline6.copyWith(
                  fontWeight: FontWeight.bold,
                  color: PsColors.mainColorWithWhite),
            ),
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: Container(
              color: PsColors.backgroundColor,
              padding: const EdgeInsets.only(
                  left: PsDimens.space8, right: PsDimens.space8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: PsDimens.space16,
                  ),
                  PsTextFieldWidget(
                      titleText:
                          Utils.getString(context, 'edit_profile__email'),
                      textAboutMe: false,
                      keyboardType: TextInputType.emailAddress,
                      hintText: 'exampleemail@gmail.com',
                      textEditingController: emailController),
                  const SizedBox(
                    height: PsDimens.space12,
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        left: PsDimens.space12, right: PsDimens.space12),
                    child: PSButtonWidget(
                        hasShadow: true,
                        width: double.infinity,
                        titleText: Utils.getString(context, 'credit_card__pay'),
                        onPressed: () async {
                          if (emailController.text == '') {
                            showDialog<dynamic>(
                                context: context,
                                builder: (BuildContext context) {
                                  return ErrorDialog(
                                    message: Utils.getString(
                                        context, 'edit_profile__email_error'),
                                  );
                                });
                          } else {
                            Navigator.pushNamed(
                                context, RoutePaths.payStackPayment,
                                arguments: PayStackInterntHolder(
                                    item: widget.item,
                                    amount: widget.amount,
                                    howManyDay: widget.howManyDay,
                                    paymentMethod:
                                        PsConst.PAYMENT_PAY_STACK_METHOD,
                                    stripePublishableKey: stripePublishableKey,
                                    startDate: widget.startDate,
                                    startTimeStamp: startTimeStamp.toString(),
                                    itemPaidHistoryProvider:
                                        widget.itemPaidHistoryProvider,
                                    userProvider: provider,
                                    payStackKey: widget.payStackKey,
                                    userEmail: emailController.text));
                          }
                        }),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

Future<void> callPaidAdSubmitApi(
    {String userEmail,
    double amount,
    ItemPromotionProvider provider,
    Item item,
    BuildContext context,
    String howManyDay,
    String paymentMethod,
    String startDate,
    String payStackKey}) async {
  //Preferably expect 'dynamic', response type varies a lot!
  dynamic transactionInitialisation;
  //Better wrap in a try-catch for lots of reasons.

  try {
    //Run it
    // var mpesa = Mpesa(
    //   clientKey: "gVSDHWmRGai9zWjOxWS0HRkjcFGwl88b",
    //   clientSecret: "kmtlKNRQNareBpqj",
    //   passKey: "YOUR_LNM_PASS_KEY_HERE",
    //   initiatorPassword: "YOUR_SECURITY_CREDENTIAL_HERE",
    //   environment: "sandbox",
    // );

    await PsProgressDialog.showDialog(context);

    print('TRANSACTION RESULT: ' + transactionInitialisation.toString());

    ///*******/
    /// GET ID here and Send to Server
    ///*******/
    ///

    if (transactionInitialisation['MerchantRequestID'] != null &&
        transactionInitialisation['CheckoutRequestID'] != null &&
        transactionInitialisation['ResponseCode'] != null &&
        transactionInitialisation['ResponseDescription'] != null &&
        transactionInitialisation['CustomerMessage'] != null) {
      print('success');

      final DateTime dateTime = DateTime.now();
      final int reultStartTimeStamp =
          Utils.getTimeStampDividedByOneThousand(dateTime);
      final ItemPaidHistoryParameterHolder itemPaidHistoryParameterHolder =
          ItemPaidHistoryParameterHolder(
              itemId: item.id,
              amount: Utils.getPriceFormat(amount.toString()),
              howManyDay: howManyDay,
              paymentMethod: paymentMethod,
              paymentMethodNounce: '',
              startDate: startDate,
              startTimeStamp: reultStartTimeStamp.toString(),
              razorId: '',
              isPaystack: PsConst.ZERO);

      final PsResource<ItemPaidHistory> paidHistoryData = await provider
          .postItemHistoryEntry(itemPaidHistoryParameterHolder.toMap());

      PsProgressDialog.dismissDialog();

      if (paidHistoryData.data != null) {
        showDialog<dynamic>(
            context: context,
            builder: (BuildContext contet) {
              return SuccessDialog(
                message: transactionInitialisation
                    .toString(), //Utils.getString(context, 'item_promote__success'),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              );
            });
      } else {
        showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
              return ErrorDialog(
                message: paidHistoryData.message,
              );
            });
      }
      /*Update your db with the init data received from initialization response,
          * Remaining bit will be sent via callback url*/
      return transactionInitialisation;
    } else {
      PsProgressDialog.dismissDialog();

      showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(
              message: transactionInitialisation.toString(),
            );
          });
    }
  } catch (e) {
    //For now, console might be useful
    print('CAUGHT EXCEPTION: ' + e.toString());
    PsProgressDialog.dismissDialog();
    showDialog<dynamic>(
        context: context,
        builder: (BuildContext context) {
          return ErrorDialog(message: transactionInitialisation.toString());
        });
  }
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
