import 'package:flutter/cupertino.dart';

class PsValueHolder {
  PsValueHolder({
    @required this.loginUserId,
    @required this.userIdToVerify,
    @required this.userNameToVerify,
    @required this.userEmailToVerify,
    @required this.userPasswordToVerify,
    @required this.deviceToken,
    @required this.notiSetting,
    @required this.isToShowIntroSlider,
    @required this.overAllTaxLabel,
    @required this.overAllTaxValue,
    @required this.shippingTaxLabel,
    @required this.messenger,
    @required this.whatsApp,
    @required this.phone,
    @required this.shippingTaxValue,
    @required this.appInfoVersionNo,
    @required this.appInfoForceUpdate,
    @required this.appInfoForceUpdateTitle,
    @required this.appInfoForceUpdateMsg,
    @required this.startDate,
    @required this.endDate,
    @required this.paypalEnabled,
    @required this.stripeEnabled,
    @required this.codEnabled,
    @required this.bankEnabled,
    @required this.publishKey,
    @required this.shippingId,
    @required this.standardShippingEnable,
    @required this.zoneShippingEnable,
    @required this.noShippingEnable,
    @required this.cityId,
    @required this.cityName,
    @required this.cityLat,
    @required this.cityLng,
  });
  String loginUserId;
  String userIdToVerify;
  String userNameToVerify;
  String userEmailToVerify;
  String userPasswordToVerify;
  String deviceToken;
  bool notiSetting;
  bool isToShowIntroSlider;
  String overAllTaxLabel;
  String overAllTaxValue;
  String shippingTaxLabel;
  String messenger;
  String whatsApp;
  String phone;
  String shippingTaxValue;
  String appInfoVersionNo;
  bool appInfoForceUpdate;
  String appInfoForceUpdateTitle;
  String appInfoForceUpdateMsg;
  String startDate;
  String endDate;
  String paypalEnabled;
  String stripeEnabled;
  String codEnabled;
  String bankEnabled;
  String publishKey;
  String shippingId;
  String standardShippingEnable;
  String zoneShippingEnable;
  String noShippingEnable;
  String cityId;
  String cityName;
  String cityLat;
  String cityLng;

  @override
  String toString() {
    return 'PsValueHolder{loginUserId: $loginUserId, userIdToVerify: $userIdToVerify, userNameToVerify: $userNameToVerify, userEmailToVerify: $userEmailToVerify, userPasswordToVerify: $userPasswordToVerify, deviceToken: $deviceToken, notiSetting: $notiSetting, isToShowIntroSlider: $isToShowIntroSlider, overAllTaxLabel: $overAllTaxLabel, overAllTaxValue: $overAllTaxValue, shippingTaxLabel: $shippingTaxLabel, messenger: $messenger, whatsApp: $whatsApp, phone: $phone, shippingTaxValue: $shippingTaxValue, appInfoVersionNo: $appInfoVersionNo, appInfoForceUpdate: $appInfoForceUpdate, appInfoForceUpdateTitle: $appInfoForceUpdateTitle, appInfoForceUpdateMsg: $appInfoForceUpdateMsg, startDate: $startDate, endDate: $endDate, paypalEnabled: $paypalEnabled, stripeEnabled: $stripeEnabled, codEnabled: $codEnabled, bankEnabled: $bankEnabled, publishKey: $publishKey, shippingId: $shippingId, standardShippingEnable: $standardShippingEnable, zoneShippingEnable: $zoneShippingEnable, noShippingEnable: $noShippingEnable, cityId: $cityId, cityName: $cityName, cityLat: $cityLat, cityLng: $cityLng}';
  }
}
