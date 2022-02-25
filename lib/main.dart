import 'dart:async';
import 'dart:io';

import 'package:businesslistingapi/config/ps_theme_data.dart';
import 'package:businesslistingapi/config/router.dart' as router;
import 'package:businesslistingapi/provider/common/ps_theme_provider.dart';
import 'package:businesslistingapi/provider/ps_provider_dependencies.dart';
import 'package:businesslistingapi/repository/ps_theme_repository.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:businesslistingapi/viewobject/common/language.dart';
import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:easy_localization/easy_localization.dart';
// import 'package:admob_flutter/admob_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_ios/in_app_purchase_ios.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/ps_colors.dart';
import 'config/ps_config.dart';
import 'constant/ps_constants.dart';
import 'constant/ps_dimens.dart';
import 'constant/route_paths.dart';
import 'db/common/ps_shared_preferences.dart';

Future<void> main() async {
  // add this, and it should be the first line in main method
  WidgetsFlutterBinding.ensureInitialized();

  // final FirebaseMessaging _fcm = FirebaseMessaging();
  // if (Platform.isIOS) {
  //   _fcm.requestNotificationPermissions(const IosNotificationSettings());
  // }

  final SharedPreferences prefs = await SharedPreferences.getInstance();

  if (prefs.getString('codeC') == null) {
   await prefs.setString('codeC', ''); //null);
    await prefs.setString('codeL', ''); //null);
  }

   // Firebase.initializeApp();

  await Firebase.initializeApp();

  // FirebaseMessaging.onBackgroundMessage(Utils.myBackgroundMessageHandler);

  await Firebase.initializeApp();
  NativeAdmob(adUnitID: Utils.getAdAppId());


    if (Platform.isIOS) {
    FirebaseMessaging.instance.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
      );

  }

  /// Update the iOS foreground notification presentation options to allow

  /// heads up notifications.

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,

  );



  // Admob.initialize(Utils.getAdAppId());

  if (Platform.isIOS) {
    FirebaseMessaging.instance.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
      );
  }

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  //check is apple signin is available
  await Utils.checkAppleSignInAvailable();

  // Inform the plugin that this app supports pending purchases on Android.
  // An error will occur on Android if you access the plugin `instance`
  // without this call.
  //
  // On iOS this is a no-op.
  if (Platform.isAndroid) {
    InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
  }else {
     InAppPurchaseIosPlatform.registerPlatform();	
  }
  
  MobileAds.instance.initialize();

  runApp(EasyLocalization(
      path: 'assets/langs',
      saveLocale: true,
      startLocale: PsConfig.defaultLanguage.toLocale(),
      supportedLocales: getSupportedLanguages(),
      child: PSApp()));
}

List<Locale> getSupportedLanguages() {
  final List<Locale> localeList = <Locale>[];
  for (final Language lang in PsConfig.psSupportedLanguageList) {
    localeList.add(Locale(lang.languageCode, lang.countryCode));
  }
  print('Loaded Languages');
  return localeList;
}

class PSApp extends StatefulWidget {
  @override
  _PSAppState createState() => _PSAppState();
}

// Future<dynamic> initAds() async {
//   if (PsConfig.showAdMob && await Utils.checkInternetConnectivity()) {
//     // FirebaseAdMob.instance.initialize(appId: Utils.getAdAppId());
//   }
// }

class _PSAppState extends State<PSApp> {
  Completer<ThemeData> themeDataCompleter;
  PsSharedPreferences psSharedPreferences;

  @override
  void initState() {
    super.initState();
    requestPermission(); //call request permission function
  }

  Future<ThemeData> getSharePerference(
      EasyLocalization provider, dynamic data) {
    Utils.psPrint('>> get share perference');
    if (themeDataCompleter == null) {
      Utils.psPrint('init completer');
      themeDataCompleter = Completer<ThemeData>();
    }

    if (psSharedPreferences == null) {
      Utils.psPrint('init ps shareperferences');
      psSharedPreferences = PsSharedPreferences.instance;
      Utils.psPrint('get shared');
      psSharedPreferences.futureShared.then((SharedPreferences sh) {
        psSharedPreferences.shared = sh;

        Utils.psPrint('init theme provider');
        final PsThemeProvider psThemeProvider = PsThemeProvider(
            repo: PsThemeRepository(psSharedPreferences: psSharedPreferences));

        Utils.psPrint('get theme');
        final ThemeData themeData = psThemeProvider.getTheme();
        themeDataCompleter.complete(themeData);
        Utils.psPrint('themedata loading completed');
      });
    }

    return themeDataCompleter.future;
  }

  List<Locale> getSupportedLanguages() {
    final List<Locale> localeList = <Locale>[];
    for (final Language lang in PsConfig.psSupportedLanguageList) {
      localeList.add(Locale(lang.languageCode, lang.countryCode));
    }
    print('Loaded Languages');
    return localeList;
  }

  //check permissions
  Future<void> requestPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showDeniedDialog();
      }
      return Future.error('Location permissions are denied');
    }

    if (permission == LocationPermission.always) {}
    if (permission == LocationPermission.whileInUse) {}

    //await prefs.setString('codeC', '');
    //await psSharedPreferences.shared.setString(
    //  PsConst.CURRENT_POSITION, Geolocator.getCurrentPosition().toString());
    //psSharedPreferences.setString(PsConst.VALUE_HOLDER__USER_NAME);
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
  //end code for taking permission

  @override
  Widget build(BuildContext context) {
    // init Color
    PsColors.loadColor(context);
    Utils.psPrint(EasyLocalization.of(context).locale.languageCode);
    return MultiProvider(
        providers: <SingleChildWidget>[
          ...providers,
        ],
        child: DynamicTheme(
            defaultBrightness: Brightness.light,
            data: (Brightness brightness) {
              if (brightness == Brightness.light) {
                return themeData(ThemeData.light());
              } else {
                return themeData(ThemeData.dark());
              }
            },
            themedWidgetBuilder: (BuildContext context, ThemeData theme) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Sable Business Directory',
                theme: theme,
                initialRoute: '/',
                onGenerateRoute: router.generateRoute,
                localizationsDelegates: <LocalizationsDelegate<dynamic>>[
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  EasyLocalization.of(context).delegate,
                ],
                supportedLocales: EasyLocalization.of(context).supportedLocales,
                locale: EasyLocalization.of(context).locale,
              );
            }));
  }

  void showDeniedDialog() {
    showDialog<void>(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                    height: 60,
                    width: double.infinity,
                    padding: const EdgeInsets.all(PsDimens.space8),
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5)),
                        color: PsColors.mainColor),
                    child: Row(
                      children: <Widget>[
                        const SizedBox(width: PsDimens.space4),
                        Icon(
                          Icons.pin_drop,
                          color: PsColors.white,
                        ),
                        const SizedBox(width: PsDimens.space4),
                        Text(
                          'Special Permissions Required',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: PsColors.white,
                          ),
                        ),
                      ],
                    )),
                const SizedBox(height: PsDimens.space20),
                Container(
                  padding: const EdgeInsets.only(
                      left: PsDimens.space16,
                      right: PsDimens.space16,
                      top: PsDimens.space8,
                      bottom: PsDimens.space8),
                  child: Text(
                    "You will not be alerted when you are near a registered black owned business.\n"
                    "\n\nWe respect user privacy. You location will never be recorded or shared for any reason.\n"
                    "\n\nTap 'Continue' to proceed without receiving alerts.\n"
                    "\n\nTo which  registered black owned businesses are near you select 'Grant Permission' and select 'Allow always\n",
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ),
                const SizedBox(height: PsDimens.space20),
                Divider(
                  thickness: 0.5,
                  height: 1,
                  color: Theme.of(context).iconTheme.color,
                ),
                ButtonBar(
                  children: [
                    MaterialButton(
                      height: 50,
                      minWidth: 100,
                      onPressed: () async {
                        requestPermission(); //call request permission function
                      },
                      child: Text(
                        'Grant Permission',
                        style: Theme.of(context)
                            .textTheme
                            .button
                            .copyWith(color: PsColors.mainColor),
                      ),
                    ),
                    MaterialButton(
                      height: 50,
                      minWidth: 100,
                      onPressed: () async {
                        (await PsSharedPreferences.instance.futureShared)
                            .setBool(PsConst.GEO_SERVICE_KEY, false);
                        Navigator.of(context).pop();
                        Navigator.pushReplacementNamed(
                          context,
                          RoutePaths.home,
                        );
                      },
                      child: Text(
                        'Continue',
                        style: Theme.of(context)
                            .textTheme
                            .button
                            .copyWith(color: PsColors.mainColor),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
