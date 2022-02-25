import 'package:businesslistingapi/config/ps_colors.dart';
import 'package:businesslistingapi/constant/ps_constants.dart';
import 'package:businesslistingapi/constant/ps_dimens.dart';
import 'package:businesslistingapi/constant/route_paths.dart';
import 'package:businesslistingapi/db/common/ps_shared_preferences.dart';
import 'package:businesslistingapi/provider/app_info/app_info_provider.dart';
import 'package:businesslistingapi/provider/clear_all/clear_all_data_provider.dart';
import 'package:businesslistingapi/repository/app_info_repository.dart';
import 'package:businesslistingapi/repository/clear_all_data_repository.dart';
import 'package:businesslistingapi/viewobject/common/ps_value_holder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:geofence_service/geofence_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class ActivityPermissionRationale extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ActivityPermissionRationaleView();
  }
}

class ActivityPermissionRationaleView
    extends State<ActivityPermissionRationale> {
  dynamic callLogout(
      AppInfoProvider appInfoProvider, int index, BuildContext context) async {
    // updateSelectedIndex( index);
    await appInfoProvider.replaceLoginUserId('');
    await appInfoProvider.replaceLoginUserName('');
    // await deleteTaskProvider.deleteTask();
    await FacebookLogin().logOut();
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
  }

  String mImage = 'assets/images/making_thumbs_up_foreground.png';
  String mMessage =
      'The app requires a special permission \nto alert you when you are near a\nregistered black owned business';
  bool begin = false;
  int count = 0;
  final Widget _imageWidget = Container(
    width: 90,
    height: 90,
    child: Image.asset(
      'assets/images/icons/icon.png',
    ),
  );

  void getNextImage() {
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        begin = true;
        mImage = 'assets/images/smiling_peace_foreground.png';
        mMessage =
            'Click begin and allow all of the following\n permissions when prompted to receive alerts.';
      });
    });
  }

  void showRationale() {
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
                          'Special Permission',
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
                    'To alert you when you are near a registered business, '
                    'this app requires special permission to access your location while working in the background. '
                    '\n\nWe respect user privacy. Your location will never be recorded or shared for any reason.'
                    "\n\nTap 'Deny' to proceed without receiving notification alerts. "
                    "\n\nTap 'Continue' and select 'Allow all the time' from the next screen to receive alerts.",
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
                        Navigator.of(context).pop();
                        // Check whether to allow location permission.
                        await FlLocation.requestLocationPermission();
                      },
                      child: Text(
                        'Continue',
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
                        /*Navigator.of(context).pop();
                        (await PsSharedPreferences.instance.futureShared)
                            .setBool(PsConst.GEO_SERVICE_KEY, false); */
                        showDeniedDialog();
                      },
                      child: Text(
                        'Deny',
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
                    "\n\nTo enable alerts when near a registered black owned business select 'allow all the time' at [Go to Settings] > [Permissions]\n",
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
                        Navigator.of(context).pop();
                        await FlLocation.requestLocationPermission();
                      },
                      child: Text(
                        'Go to Settings',
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

  @override
  Widget build(BuildContext context) {
    AppInfoRepository repo1;
    AppInfoProvider provider;
    ClearAllDataRepository clearAllDataRepository;
    ClearAllDataProvider clearAllDataProvider;
    PsValueHolder valueHolder;

    PsColors.loadColor(context);
    valueHolder = Provider.of<PsValueHolder>(context);
    repo1 = Provider.of<AppInfoRepository>(context);
    clearAllDataRepository = Provider.of<ClearAllDataRepository>(context);

    if (valueHolder == null) {
      return Container();
    }

    getNextImage();
    //requestPermission();

    // final dynamic data = EasyLocalizationProvider.of(context).data;
    return
        // EasyLocalizationProvider(
        //   data: data,
        //   child:
        MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<ClearAllDataProvider>(
            lazy: false,
            create: (BuildContext context) {
              clearAllDataProvider = ClearAllDataProvider(
                  repo: clearAllDataRepository, psValueHolder: valueHolder);

              return clearAllDataProvider;
            }),
        ChangeNotifierProvider<AppInfoProvider>(
            lazy: false,
            create: (BuildContext context) {
              provider =
                  AppInfoProvider(repo: repo1, psValueHolder: valueHolder);
              // callDateFunction(provider, clearAllDataProvider, context);
              return provider;
            }),
      ],
      child: Consumer<AppInfoProvider>(
        builder: (BuildContext context, AppInfoProvider clearAllDataProvider,
            Widget child) {
          return Consumer<AppInfoProvider>(builder: (BuildContext context,
              AppInfoProvider clearAllDataProvider, Widget child) {
            return Container(
                height: 400,
                color: PsColors.white,
                child: Stack(
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const SizedBox(
                          height: PsDimens.space80,
                        ),
                        _imageWidget,
                        const SizedBox(
                          height: PsDimens.space16,
                        ),
                        Flexible(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            child: Text(mMessage,
                                maxLines: 6,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: PsColors.black,
                                        fontSize: 14)),
                          ),
                        ),
                        const SizedBox(
                          height: PsDimens.space8,
                        ),
                        Container(
                          width: 350,
                          child: Image.asset(
                            mImage,
                          ),
                        ),
                        const SizedBox(
                          height: PsDimens.space8,
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        margin: const EdgeInsets.only(left: 16, bottom: 16),
                        child: Visibility(
                          child: ElevatedButton(
                            style:
                                ElevatedButton.styleFrom(primary: Colors.black),
                            onPressed: () async {
                              if (await Permission.locationAlways.isGranted) {
                                (await PsSharedPreferences
                                        .instance.futureShared)
                                    .setBool(PsConst.GEO_SERVICE_KEY, true);
                                Navigator.pushReplacementNamed(
                                  context,
                                  RoutePaths.home,
                                );
                                return;
                              } else {
                                showRationale();
                              }
                            },
                            child: const Text('Begin'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ));
          });
        },
      ),
      // ),
    );
  }
}

class PsButtonWidget extends StatefulWidget {
  const PsButtonWidget({
    @required this.provider,
    @required this.text,
  });

  final AppInfoProvider provider;
  final String text;

  @override
  _PsButtonWidgetState createState() => _PsButtonWidgetState();
}

class _PsButtonWidgetState extends State<PsButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(PsColors.loadingCircleColor),
        strokeWidth: 5.0);
  }
}
