import 'dart:async';

import 'package:businesslistingapi/config/ps_colors.dart';
import 'package:businesslistingapi/constant/ps_constants.dart';
import 'package:businesslistingapi/constant/ps_dimens.dart';
import 'package:businesslistingapi/constant/route_paths.dart';
import 'package:businesslistingapi/db/common/ps_shared_preferences.dart';
import 'package:businesslistingapi/provider/common/notification_provider.dart';
import 'package:businesslistingapi/repository/Common/notification_repository.dart';
import 'package:businesslistingapi/repository/blog_repository.dart';
import 'package:businesslistingapi/repository/category_repository.dart';
import 'package:businesslistingapi/repository/city_repository.dart';
import 'package:businesslistingapi/repository/item_collection_repository.dart';
import 'package:businesslistingapi/repository/item_repository.dart';
import 'package:businesslistingapi/ui/common/base/ps_widget_with_appbar.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:businesslistingapi/viewobject/common/ps_value_holder.dart';
import 'package:businesslistingapi/viewobject/holder/noti_register_holder.dart';
import 'package:businesslistingapi/viewobject/holder/noti_unregister_holder.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofence/geofence.dart' as geo;
import 'package:flutter_icons/flutter_icons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSettingView extends StatefulWidget {
  @override
  _NotificationSettingViewState createState() =>
      _NotificationSettingViewState();
}

NotificationRepository notiRepository;
NotificationProvider notiProvider;
PsValueHolder _psValueHolder;
final FirebaseMessaging _fcm = FirebaseMessaging.instance;
bool hasAlreadyListened = false;
geo.Coordinate globalCoordinate;
PsValueHolder valueHolder;
CategoryRepository categoryRepo;
ItemRepository itemRepo;
CityRepository cityRepo;
BlogRepository blogRepo;
ItemCollectionRepository itemCollectionRepo;

class _NotificationSettingViewState extends State<NotificationSettingView>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    notiRepository = Provider.of<NotificationRepository>(context);
    _psValueHolder = Provider.of<PsValueHolder>(context);

    categoryRepo = Provider.of<CategoryRepository>(context);
    itemRepo = Provider.of<ItemRepository>(context);
    cityRepo = Provider.of<CityRepository>(context);
    blogRepo = Provider.of<BlogRepository>(context);
    itemCollectionRepo = Provider.of<ItemCollectionRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context);

    print(
        '............................Build UI Again ...........................');

    return PsWidgetWithAppBar<NotificationProvider>(
        appBarTitle:
            Utils.getString(context, 'noti_setting__toolbar_name') ?? '',
        initProvider: () {
          return NotificationProvider(
              repo: notiRepository, psValueHolder: _psValueHolder);
        },
        onProviderReady: (NotificationProvider provider) {
          notiProvider = provider;
        },
        builder: (BuildContext context, NotificationProvider provider,
            Widget child) {
          return _NotificationSettingWidget(notiProvider: provider);
        });
  }
}

class _NotificationSettingWidget extends StatefulWidget {
  const _NotificationSettingWidget({this.notiProvider});
  final NotificationProvider notiProvider;
  @override
  __NotificationSettingWidgetState createState() =>
      __NotificationSettingWidgetState();
}

class __NotificationSettingWidgetState
    extends State<_NotificationSettingWidget> {
  bool isSwitched = true;
  bool isGeoEnabled = true;
  @override
  Future<void> initState() {
    super.initState();
    PsSharedPreferences.instance.futureShared.then((pref) {
      try {
        if (isGeoEnabled != pref.getBool(PsConst.GEO_SERVICE_KEY)) {
          isGeoEnabled = pref.getBool(PsConst.GEO_SERVICE_KEY);
          setState(() {});
        }
      } on Exception catch (e) {
        print('GEO_SERVICE_KEY not available');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print('******* Login User Id : ${notiProvider.psValueHolder.loginUserId}');

    if (notiProvider.psValueHolder.notiSetting != null) {
      isSwitched = notiProvider.psValueHolder.notiSetting;
    }
    final Widget _switchButtonwidget = Switch(
        value: isSwitched,
        onChanged: (bool value) {
          setState(() async {
            isSwitched = value;
            notiProvider.psValueHolder.notiSetting = value;
           await notiProvider.replaceNotiSetting(value);
          });

          if (isSwitched == true) {
            _fcm.subscribeToTopic('broadcast');
            if (notiProvider.psValueHolder.deviceToken != null &&
                notiProvider.psValueHolder.deviceToken != '') {
              final NotiRegisterParameterHolder notiRegisterParameterHolder =
                  NotiRegisterParameterHolder(
                      platformName: PsConst.PLATFORM,
                      deviceId: notiProvider.psValueHolder.deviceToken,
                      loginUserId:
                          Utils.checkUserLoginId(notiProvider.psValueHolder));
              notiProvider
                  .rawRegisterNotiToken(notiRegisterParameterHolder.toMap());
            }
          } else {
            _fcm.unsubscribeFromTopic('broadcast');
            if (notiProvider.psValueHolder.deviceToken != null &&
                notiProvider.psValueHolder.deviceToken != '') {
              final NotiUnRegisterParameterHolder
                  notiUnRegisterParameterHolder = NotiUnRegisterParameterHolder(
                      platformName: PsConst.PLATFORM,
                      deviceId: notiProvider.psValueHolder.deviceToken,
                      loginUserId:
                          Utils.checkUserLoginId(notiProvider.psValueHolder));
              notiProvider.rawUnRegisterNotiToken(
                  notiUnRegisterParameterHolder.toMap());
            }
          }
        },
        activeTrackColor: PsColors.mainColor,
        activeColor: PsColors.mainColor);
    final Widget _geofenceSwitch = Switch(
        value: isGeoEnabled,
        onChanged: (bool value) async {
          if (isGeoEnabled && await Permission.locationAlways.isGranted) {
            final SharedPreferences sharedPreferences =
                await PsSharedPreferences.instance.futureShared;
            await sharedPreferences.setBool(PsConst.GEO_SERVICE_KEY, value);
          } else {
            await requestPermission();
          }

          setState(() async {
            final SharedPreferences sharedPreferences =
                await PsSharedPreferences.instance.futureShared;
            if (sharedPreferences.getBool(PsConst.GEO_SERVICE_KEY)) {
              isGeoEnabled = true;
              //startBackgroundTracking(globalCoordinate);
            } else {
              isGeoEnabled = false;
            }
          });

          //end of code - if PsConst.GEO_SERVICE_KEY is true: set switch to on else set switch to off
        },
        activeTrackColor: PsColors.mainColor,
        activeColor: PsColors.mainColor);

    final Widget _notiSettingTextWidget = Text(
      Utils.getString(context, 'noti_setting__onof'),
      style: Theme.of(context).textTheme.subtitle1,
    );
    final Widget _geoSettingTextWidget = Text(
      'Geo Notification Setting (Off/On)',
      style: Theme.of(context).textTheme.subtitle1,
    );

    final Widget _messageTextWidget = Row(
      children: <Widget>[
        const Icon(
          FontAwesome.bullhorn,
          size: PsDimens.space16,
        ),
        const SizedBox(
          width: PsDimens.space16,
        ),
        Text(
          Utils.getString(context, 'noti__latest_message'),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ],
    );
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
              left: PsDimens.space8,
              top: PsDimens.space8,
              bottom: PsDimens.space8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _notiSettingTextWidget,
              _switchButtonwidget,
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              left: PsDimens.space8,
              top: PsDimens.space8,
              bottom: PsDimens.space8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _geoSettingTextWidget,
              _geofenceSwitch,
            ],
          ),
        ),
        const Divider(
          height: PsDimens.space1,
        ),
        Padding(
          padding: const EdgeInsets.only(
              top: PsDimens.space20,
              bottom: PsDimens.space20,
              left: PsDimens.space8),
          child: _messageTextWidget,
        ),
      ],
    );
  }

  Future<void> requestPermission() async {
    print('REQUESTING PERMISSION');
    await Navigator.pushReplacementNamed(
      context,
      RoutePaths.permissionRationale,
    );
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    if (hasAlreadyListened) return;
    print('😡 initPlatform state');
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    setState(() {});
  }
}
