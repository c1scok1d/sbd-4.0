import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:businesslistingapi/repository/app_info_repository.dart';
import 'package:businesslistingapi/provider/app_info/app_info_provider.dart';
import 'package:businesslistingapi/config/ps_config.dart';
import 'package:businesslistingapi/constant/ps_constants.dart';
import 'package:businesslistingapi/constant/ps_dimens.dart';
import 'package:businesslistingapi/constant/route_paths.dart';
import 'package:businesslistingapi/provider/city_info/city_info_provider.dart';
import 'package:businesslistingapi/provider/common/notification_provider.dart';
import 'package:businesslistingapi/provider/delete_task/delete_task_provider.dart';
import 'package:businesslistingapi/provider/user/user_provider.dart';
import 'package:businesslistingapi/repository/Common/notification_repository.dart';
import 'package:businesslistingapi/repository/delete_task_repository.dart';
import 'package:businesslistingapi/repository/item_repository.dart';
import 'package:businesslistingapi/repository/city_info_repository.dart';
import 'package:businesslistingapi/repository/user_repository.dart';
import 'package:businesslistingapi/ui/city/grid/all_city_grid_view.dart';
import 'package:businesslistingapi/ui/common/dialog/confirm_dialog_view.dart';
import 'package:businesslistingapi/ui/common/dialog/noti_dialog.dart';
import 'package:businesslistingapi/ui/common/dialog/share_app_dialog.dart';
import 'package:businesslistingapi/ui/dashboard/home/home_dashboard_view.dart';
import 'package:businesslistingapi/ui/history/list/history_list_view.dart';
import 'package:businesslistingapi/ui/items/favourite/favourite_product_list_view.dart';
import 'package:businesslistingapi/ui/items/item_upload/item_upload_list_view.dart';
import 'package:businesslistingapi/ui/language/setting/language_setting_view.dart';
import 'package:businesslistingapi/ui/contact/contact_us_view.dart';
import 'package:businesslistingapi/ui/paid_ad/paid_ad_item_list_view.dart';
import 'package:businesslistingapi/ui/privacy_policy/privacy_policy_view.dart';
import 'package:businesslistingapi/ui/search/home_item_search_view.dart';
import 'package:businesslistingapi/ui/setting/setting_view.dart';
import 'package:businesslistingapi/ui/user/forgot_password/forgot_password_view.dart';
import 'package:businesslistingapi/ui/user/login/login_view.dart';
import 'package:businesslistingapi/ui/user/phone/sign_in/phone_sign_in_view.dart';
import 'package:businesslistingapi/ui/user/phone/verify_phone/verify_phone_view.dart';
import 'package:businesslistingapi/ui/user/profile/profile_view.dart';
import 'package:businesslistingapi/ui/user/register/register_view.dart';
import 'package:businesslistingapi/ui/user/verify/verify_email_view.dart';
import 'package:businesslistingapi/viewobject/common/ps_value_holder.dart';
import 'package:businesslistingapi/viewobject/holder/city_parameter_holder.dart';
import 'package:businesslistingapi/viewobject/holder/intent_holder/item_detail_intent_holder.dart';
import 'package:businesslistingapi/viewobject/holder/intent_holder/item_entry_intent_holder.dart';
import 'package:businesslistingapi/viewobject/holder/item_parameter_holder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:businesslistingapi/viewobject/item.dart';
import 'package:businesslistingapi/viewobject/user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:businesslistingapi/config/ps_colors.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:provider/single_child_widget.dart';

class DashboardView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<DashboardView>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();

  AnimationController animationController;
  AnimationController animationControllerForFab;

  Animation<double> animation;

  String appBarTitle = 'Home';
  int _currentIndex = PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT;
  String _userId = '';
  bool isLogout = false;
  bool isFirstTime = true;
  String phoneUserName = '';
  String phoneNumber = '';
  String phoneId = '';
  AppInfoProvider appInfoProvider;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  CityInfoProvider cityInfoProvider;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  bool isResumed = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      isResumed = true;
      initDynamicLinks(context);
    }
  }

  @override
  void initState() {
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);

    animationControllerForFab = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this, value: 1);
    initDynamicLinks(context);
    super.initState();
    // Utils.fcmConfigure(context, _fcm, valueHolder.loginUserId);
  }

  @override
  void dispose() {
    animationController.dispose();
    animationControllerForFab.dispose();
    super.dispose();
  }

  Future<void> initDynamicLinks(BuildContext context) async {
    Future<dynamic>.delayed(const Duration(seconds: 3)); //recomme
    String itemId = '';
    if (!isResumed) {
      final PendingDynamicLinkData data =
          await FirebaseDynamicLinks.instance.getInitialLink();

      if (data != null && data?.link != null) {
        final Uri deepLink = data?.link;
        if (deepLink != null) {
          final String path = deepLink.path;
          final List<String> pathList = path.split('=');
          itemId = pathList[1];
          final ItemDetailIntentHolder holder = ItemDetailIntentHolder(
            itemId: itemId,
            heroTagImage: '-1' + pathList[1] + PsConst.HERO_TAG__IMAGE,
            heroTagTitle: '-1' + pathList[1] + PsConst.HERO_TAG__TITLE,
            heroTagOriginalPrice:
                '-1' + pathList[1] + PsConst.HERO_TAG__ORIGINAL_PRICE,
            heroTagUnitPrice: '-1' + pathList[1] + PsConst.HERO_TAG__UNIT_PRICE,
          );
          Navigator.pushNamed(context, RoutePaths.itemDetail,
              arguments: holder);
        }
      }
    }

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;
      if (deepLink != null) {
        final String path = deepLink.path;
        final List<String> pathList = path.split('=');
        if (itemId == '') {
          final ItemDetailIntentHolder holder = ItemDetailIntentHolder(
              itemId: pathList[1],
              heroTagImage: '-1' + pathList[1] + PsConst.HERO_TAG__IMAGE,
              heroTagTitle: '-1' + pathList[1] + PsConst.HERO_TAG__TITLE);
          Navigator.pushNamed(context, RoutePaths.itemDetail,
              arguments: holder);
        }
      }
      debugPrint('DynamicLinks onLink $deepLink');
    }, onError: (OnLinkErrorException e) async {
      debugPrint('DynamicLinks onError $e');
    });
  }

  CityInfoRepository cityInfoRepository;
  UserRepository userRepository;
  ItemRepository itemRepository;
  PsValueHolder valueHolder;
  DeleteTaskRepository deleteTaskRepository;
  DeleteTaskProvider deleteTaskProvider;
  NotificationRepository notificationRepository;
  AppInfoRepository appInfoRepository;

  @override
  Widget build(BuildContext context) {
    cityInfoRepository = Provider.of<CityInfoRepository>(context);
    userRepository = Provider.of<UserRepository>(context);
    appInfoRepository = Provider.of<AppInfoRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context);
    itemRepository = Provider.of<ItemRepository>(context);
    deleteTaskRepository = Provider.of<DeleteTaskRepository>(context);
    notificationRepository = Provider.of<NotificationRepository>(context);

    timeDilation = 1.0;

    if (isFirstTime) {
      appBarTitle = Utils.getString(context, 'app_name');

      Utils.subscribeToTopic(valueHolder.notiSetting ?? true);
      Utils.fcmConfigure(context, _fcm, valueHolder.loginUserId);
      isFirstTime = false;
    }

    Future<void> updateSelectedIndexWithAnimation(
        String title, int index) async {
      await animationController.reverse().then<dynamic>((void data) {
        if (!mounted) {
          return;
        }

        setState(() {
          appBarTitle = title;
          _currentIndex = index;
        });
      });
    }

    Future<void> updateSelectedIndexWithAnimationUserId(
        String title, int index, String userId) async {
      await animationController.reverse().then<dynamic>((void data) {
        if (!mounted) {
          return;
        }
        if (userId != null) {
          _userId = userId;
        }
        setState(() {
          appBarTitle = title;
          _currentIndex = index;
        });
      });
    }

    Future<bool> _onWillPop() {
      return showDialog<dynamic>(
              context: context,
              builder: (BuildContext context) {
                return ConfirmDialogView(
                    description: Utils.getString(
                        context, 'home__quit_dialog_description'),
                    leftButtonText: Utils.getString(
                        context, 'app_info__cancel_button_name'),
                    rightButtonText: Utils.getString(context, 'dialog__ok'),
                    onAgreeTap: () {
                      SystemNavigator.pop();
                    });
              }) ??
          false;
    }

    final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
            parent: animationController,
            curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          key: scaffoldKey,
          drawer: Drawer(
            child: MultiProvider(
              providers: <SingleChildWidget>[
                ChangeNotifierProvider<UserProvider>(
                    lazy: false,
                    create: (BuildContext context) {
                      return UserProvider(
                          repo: userRepository, psValueHolder: valueHolder);
                    }),
                ChangeNotifierProvider<DeleteTaskProvider>(
                    lazy: false,
                    create: (BuildContext context) {
                      deleteTaskProvider = DeleteTaskProvider(
                          repo: deleteTaskRepository,
                          psValueHolder: valueHolder);
                      return deleteTaskProvider;
                    }),
              ],
              child: Consumer<UserProvider>(
                builder: (BuildContext context, UserProvider provider,
                    Widget child) {
                  print(provider.psValueHolder.loginUserId);
                  return ListView(padding: EdgeInsets.zero, children: <Widget>[
                    _DrawerHeaderWidget(),
                    ListTile(
                      title: Text(
                          Utils.getString(context, 'home__menu_drawer_home')),
                    ),
                    _DrawerMenuWidget(
                        icon: Icons.store,
                        title:
                            Utils.getString(context, 'home__menu_drawer_home'),
                        index: PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT,
                        onTap: (String title, int index) {
                          Navigator.pop(context);
                          updateSelectedIndexWithAnimation(
                              Utils.getString(context, 'app_name'), index);
                        }),
                    _DrawerMenuWidget(
                        icon: Icons.schedule,
                        title: Utils.getString(
                            context, 'home__menu_drawer_all_city'),
                        index: PsConst.REQUEST_CODE__MENU_ALL_CITY_FRAGMENT,
                        onTap: (String title, int index) {
                          Navigator.pop(context);
                          updateSelectedIndexWithAnimation(title, index);
                        }),
                    _DrawerMenuWidget(
                        icon: Icons.trending_up,
                        title: Utils.getString(
                            context, 'home__menu_drawer_popular_city'),
                        index: PsConst.REQUEST_CODE__MENU_POPULAR_CITY_FRAGMENT,
                        onTap: (String title, int index) {
                          Navigator.pop(context);
                          updateSelectedIndexWithAnimation(title, index);
                        }),
                    _DrawerMenuWidget(
                        icon: FontAwesome5.gem,
                        title: Utils.getString(
                            context, 'home__menu_drawer_recommended_city'),
                        index:
                            PsConst.REQUEST_CODE__MENU_RECOMMAND_CITY_FRAGMENT,
                        onTap: (String title, int index) {
                          Navigator.pop(context);
                          updateSelectedIndexWithAnimation(title, index);
                        }),
                    const Divider(
                      height: PsDimens.space1,
                    ),
                    ListTile(
                      title: Text(Utils.getString(
                          context, 'home__menu_drawer_user_info')),
                    ),
                    _DrawerMenuWidget(
                        icon: Icons.person,
                        title: Utils.getString(
                            context, 'home__menu_drawer_profile'),
                        index: PsConst
                            .REQUEST_CODE__MENU_SELECT_WHICH_USER_FRAGMENT,
                        onTap: (String title, int index) {
                          Navigator.pop(context);
                          title = (valueHolder == null ||
                                  valueHolder.userIdToVerify == null ||
                                  valueHolder.userIdToVerify == '')
                              ? Utils.getString(
                                  context, 'home__menu_drawer_profile')
                              : Utils.getString(
                                  context, 'home__bottom_app_bar_verify_email');
                          updateSelectedIndexWithAnimation(title, index);
                        }),
                    if (provider != null)
                      if (provider.psValueHolder.loginUserId != null &&
                          provider.psValueHolder.loginUserId != '')
                        Visibility(
                          visible: true,
                          child: _DrawerMenuWidget(
                              icon: Icons.cloud,
                              title: Utils.getString(
                                  context, 'home__menu_drawer_uploaded_item'),
                              index: PsConst
                                  .REQUEST_CODE__MENU_UPLOAD_ITEM_FRAGMENT,
                              onTap: (String title, int index) {
                                Navigator.pop(context);
                                updateSelectedIndexWithAnimation(title, index);
                              }),
                        ),
                    if (provider != null)
                      if (provider.psValueHolder.loginUserId != null &&
                          provider.psValueHolder.loginUserId != '')
                        Visibility(
                          visible: true,
                          child: _DrawerMenuWidget(
                              icon: Icons.favorite_border,
                              title: Utils.getString(
                                  context, 'home__menu_drawer_favourite'),
                              index:
                                  PsConst.REQUEST_CODE__MENU_FAVOURITE_FRAGMENT,
                              onTap: (String title, int index) {
                                Navigator.pop(context);
                                updateSelectedIndexWithAnimation(title, index);
                              }),
                        ),
                    if (provider != null)
                      if (provider.psValueHolder.loginUserId != null &&
                          provider.psValueHolder.loginUserId != '')
                        Visibility(
                          visible: true,
                          child: _DrawerMenuWidget(
                            icon: Icons.swap_horiz,
                            title: Utils.getString(context,
                                'home__menu_drawer_paid_ad_transaction'),
                            index: PsConst
                                .REQUEST_CODE__MENU_PAID_AD_TRANSACTION_FRAGMENT,
                            onTap: (String title, int index) {
                              Navigator.pop(context);
                              updateSelectedIndexWithAnimation(title, index);
                            },
                          ),
                        ),
                    if (provider != null)
                      if (provider.psValueHolder.loginUserId != null &&
                          provider.psValueHolder.loginUserId != '')
                        Visibility(
                          visible: true,
                          child: _DrawerMenuWidget(
                              icon: Icons.book,
                              title: Utils.getString(
                                  context, 'home__menu_drawer_user_history'),
                              index: PsConst
                                  .REQUEST_CODE__MENU_USER_HISTORY_FRAGMENT,
                              onTap: (String title, int index) {
                                Navigator.pop(context);
                                updateSelectedIndexWithAnimation(title, index);
                              }),
                        ),
                    if (provider != null)
                      if (provider.psValueHolder.loginUserId != null &&
                          provider.psValueHolder.loginUserId != '')
                        Visibility(
                          visible: true,
                          child: ListTile(
                            leading: Icon(
                              Icons.power_settings_new,
                              color: PsColors.mainColorWithWhite,
                            ),
                            title: Text(
                              Utils.getString(
                                  context, 'home__menu_drawer_logout'),
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            onTap: () async {
                              Navigator.pop(context);
                              showDialog<dynamic>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ConfirmDialogView(
                                        description: Utils.getString(context,
                                            'home__logout_dialog_description'),
                                        leftButtonText: Utils.getString(context,
                                            'home__logout_dialog_cancel_button'),
                                        rightButtonText: Utils.getString(
                                            context,
                                            'home__logout_dialog_ok_button'),
                                        onAgreeTap: () async {
                                          Navigator.of(context).pop();
                                          setState(() {
                                            _currentIndex = PsConst
                                                .REQUEST_CODE__MENU_HOME_FRAGMENT;
                                          });
                                         await provider.replaceLoginUserId('');
                                          await deleteTaskProvider.deleteTask();
                                          await FacebookLogin().logOut();
                                          await GoogleSignIn().signOut();
                                          await fb_auth.FirebaseAuth.instance.signOut();
                                        });
                                  });
                            },
                          ),
                        ),
                    const Divider(
                      height: PsDimens.space1,
                    ),
                    ListTile(
                      title: Text(
                          Utils.getString(context, 'home__menu_drawer_app')),
                    ),
                    _DrawerMenuWidget(
                        icon: Icons.g_translate,
                        title: Utils.getString(
                            context, 'home__menu_drawer_language'),
                        index: PsConst.REQUEST_CODE__MENU_LANGUAGE_FRAGMENT,
                        onTap: (String title, int index) {
                          Navigator.pop(context);
                          updateSelectedIndexWithAnimation('', index);
                        }),
                         _DrawerMenuWidget(
                        icon: Icons.contacts,
                        title: Utils.getString(
                            context, 'home__menu_drawer_contact_us'),
                        index: PsConst.REQUEST_CODE__MENU_CONTACT_US_FRAGMENT,
                        onTap: (String title, int index) {
                          Navigator.pop(context);
                          updateSelectedIndexWithAnimation(title, index);
                        }),
                    _DrawerMenuWidget(
                        icon: Icons.settings,
                        title: Utils.getString(
                            context, 'home__menu_drawer_setting'),
                        index: PsConst.REQUEST_CODE__MENU_SETTING_FRAGMENT,
                        onTap: (String title, int index) {
                          Navigator.pop(context);
                          updateSelectedIndexWithAnimation(title, index);
                        }),
                    _DrawerMenuWidget(
                        icon: Icons.info_outline,
                        title: Utils.getString(
                            context, 'privacy_policy__toolbar_name'),
                        index: PsConst
                            .REQUEST_CODE__MENU_TERMS_AND_CONDITION_FRAGMENT,
                        onTap: (String title, int index) {
                          Navigator.pop(context);
                          updateSelectedIndexWithAnimation(title, index);
                        }),
                        ListTile(
                    leading: Icon(
                      Icons.share,
                      color: PsColors.mainColorWithWhite,
                    ),
                    title: Text(
                      Utils.getString(
                          context, 'home__menu_drawer_share_this_app'),
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                               showDialog<dynamic>(
                      context: context,
                      builder: (BuildContext context) {
                        return ShareAppDialog(
                          onPressed: () {
                            Navigator.pop(context,true);
                          },
                        );
                      });
                    },
                  ),
                    ListTile(
                      leading: Icon(
                        Icons.star_border,
                        color: PsColors.mainColorWithWhite,
                      ),
                      title: Text(
                        Utils.getString(
                            context, 'home__menu_drawer_rate_this_app'),
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        if (Platform.isIOS) {
                          Utils.launchAppStoreURL(
                              iOSAppId: PsConfig.iOSAppStoreId,
                              writeReview: true);
                        } else {
                          Utils.launchURL();
                        }
                      },
                    )
                  ]);
                },
              ),
            ),
          ),
          appBar: AppBar(
            backgroundColor: Utils.isLightMode(context)
                ? PsColors.mainColor
                : Colors.black12,
            title: Text(
              appBarTitle,
              style: Theme.of(context).textTheme.headline6.copyWith(
                    fontWeight: FontWeight.bold,
                    color: PsColors.white,
                  ),
            ),
            titleSpacing: 0,
            elevation: 0,
            iconTheme: IconThemeData(color: PsColors.white),
            toolbarTextStyle:  TextStyle(color: PsColors.textPrimaryColor),
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarIconBrightness: Utils.getBrightnessForAppBar(context),
            ),
            actions: <Widget>[
              if (appBarTitle ==
                  Utils.getString(context, 'home__menu_drawer_uploaded_item'))
                Visibility(
                  visible: true,
                  child: InkWell(
                    child: Container(
                      margin: const EdgeInsets.only(top: PsDimens.space18),
                      child: Text(
                        'ADD',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .copyWith(color: PsColors.white),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    onTap: () async {
                      final dynamic returnData = await Navigator.pushNamed(
                          context, RoutePaths.itemEntry,
                          arguments: ItemEntryIntentHolder(
                              flag: PsConst.ADD_NEW_ITEM, item: Item()));
                      if (returnData != null) {
                        setState(() {});
                      }
                    },
                  ),
                )
              else
                Container(),
              IconButton(
                icon: Icon(Icons.notifications_none, color: PsColors.white),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    RoutePaths.notiList,
                  );
                },
              ),
            ],
          ),
          body: ChangeNotifierProvider<NotificationProvider>(
            lazy: false,
            create: (BuildContext context) {
              final NotificationProvider provider = NotificationProvider(
                  repo: notificationRepository, psValueHolder: valueHolder);

              if (provider.psValueHolder.deviceToken == null ||
                  provider.psValueHolder.deviceToken == '') {
                final FirebaseMessaging _fcm = FirebaseMessaging.instance;
                Utils.saveDeviceToken(_fcm, provider);
              } else {
                print(
                    'Notification Token is already registered. Notification Setting : true.');
              }

              return provider;
            },
            child: Builder(
              builder: (BuildContext context) {
                if (_currentIndex ==
                    PsConst
                        .REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT) {
                  return ChangeNotifierProvider<UserProvider>(
                      lazy: false,
                      create: (BuildContext context) {
                        final UserProvider provider = UserProvider(
                            repo: userRepository, psValueHolder: valueHolder);

                        return provider;
                      },
                      child: Consumer<UserProvider>(builder:
                          (BuildContext context, UserProvider provider,
                              Widget child) {
                        if (provider == null ||
                            provider.psValueHolder.userIdToVerify == null ||
                            provider.psValueHolder.userIdToVerify == '') {
                          if (provider == null ||
                              provider.psValueHolder == null ||
                              provider.psValueHolder.loginUserId == null ||
                              provider.psValueHolder.loginUserId == '') {
                            return _CallLoginWidget(
                                currentIndex: _currentIndex,
                                animationController: animationController,
                                animation: animation,
                                updateCurrentIndex: (String title, int index) {
                                  if (index != null) {
                                    updateSelectedIndexWithAnimation(
                                        title, index);
                                  }
                                },
                                updateUserCurrentIndex:
                                    (String title, int index, String userId) {
                                  if (index != null) {
                                    updateSelectedIndexWithAnimation(
                                        title, index);
                                  }
                                  if (userId != null) {
                                    _userId = userId;
                                    provider.psValueHolder.loginUserId = userId;
                                  }
                                });
                          } else {
                            return ProfileView(
                              scaffoldKey: scaffoldKey,
                              animationController: animationController,
                              flag: _currentIndex,
                              userId: provider.psValueHolder.loginUserId,
                            );
                          }
                        } else {
                          return _CallVerifyEmailWidget(
                              animationController: animationController,
                              animation: animation,
                              currentIndex: _currentIndex,
                              userId: _userId,
                              updateCurrentIndex: (String title, int index) {
                                updateSelectedIndexWithAnimation(title, index);
                              },
                              updateUserCurrentIndex: (String title, int index,
                                  String userId) async {
                                if (userId != null) {
                                  _userId = userId;
                                  provider.psValueHolder.loginUserId = userId;
                                }
                                setState(() {
                                  appBarTitle = title;
                                  _currentIndex = index;
                                });
                              });
                        }
                      }));
                }
                if (_currentIndex ==
                    PsConst.REQUEST_CODE__DASHBOARD_SEARCH_FRAGMENT) {
                  // 2nd Way
                  //SearchItemProvider searchItemProvider;

                  return CustomScrollView(
                    scrollDirection: Axis.vertical,
                    slivers: <Widget>[
                      HomeItemSearchView(
                          animationController: animationController,
                          animation: animation,
                          itemParameterHolder:
                              ItemParameterHolder().getLatestParameterHolder())
                    ],
                  );
                } else if (_currentIndex ==
                        PsConst.REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT ||
                    _currentIndex ==
                        PsConst.REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT) {
                  return Stack(children: <Widget>[
                    Container(
                      color: PsColors.mainLightColorWithBlack,
                      width: double.infinity,
                      height: double.maxFinite,
                    ),
                    CustomScrollView(
                        scrollDirection: Axis.vertical,
                        slivers: <Widget>[
                          PhoneSignInView(
                              animationController: animationController,
                              goToLoginSelected: () {
                                animationController
                                    .reverse()
                                    .then<dynamic>((void data) {
                                  if (!mounted) {
                                    return;
                                  }
                                  if (_currentIndex ==
                                      PsConst
                                          .REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT) {
                                    updateSelectedIndexWithAnimation(
                                        Utils.getString(context, 'home__login'),
                                        PsConst
                                            .REQUEST_CODE__MENU_LOGIN_FRAGMENT);
                                  }
                                  if (_currentIndex ==
                                      PsConst
                                          .REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT) {
                                    updateSelectedIndexWithAnimation(
                                        Utils.getString(context, 'home__login'),
                                        PsConst
                                            .REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT);
                                  }
                                });
                              },
                              phoneSignInSelected: (String name, String phoneNo,
                                  String verifyId) {
                                phoneUserName = name;
                                phoneNumber = phoneNo;
                                phoneId = verifyId;
                                if (_currentIndex ==
                                    PsConst
                                        .REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT) {
                                  updateSelectedIndexWithAnimation(
                                      Utils.getString(
                                          context, 'home__verify_phone'),
                                      PsConst
                                          .REQUEST_CODE__MENU_PHONE_VERIFY_FRAGMENT);
                                }
                                if (_currentIndex ==
                                    PsConst
                                        .REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT) {
                                  updateSelectedIndexWithAnimation(
                                      Utils.getString(
                                          context, 'home__verify_phone'),
                                      PsConst
                                          .REQUEST_CODE__DASHBOARD_PHONE_VERIFY_FRAGMENT);
                                }
                              })
                        ])
                  ]);
                } else if (_currentIndex ==
                        PsConst.REQUEST_CODE__DASHBOARD_PHONE_VERIFY_FRAGMENT ||
                    _currentIndex ==
                        PsConst.REQUEST_CODE__MENU_PHONE_VERIFY_FRAGMENT) {
                  return _CallVerifyPhoneWidget(
                      userName: phoneUserName,
                      phoneNumber: phoneNumber,
                      phoneId: phoneId,
                      animationController: animationController,
                      animation: animation,
                      currentIndex: _currentIndex,
                      updateCurrentIndex: (String title, int index) {
                        updateSelectedIndexWithAnimation(title, index);
                      },
                      updateUserCurrentIndex:
                          (String title, int index, String userId) async {
                        if (userId != null) {
                          _userId = userId;
                        }
                        setState(() {
                          appBarTitle = title;
                          _currentIndex = index;
                        });
                      });
                } else if (_currentIndex ==
                        PsConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT ||
                    _currentIndex ==
                        PsConst.REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT) {
                  return ProfileView(
                    scaffoldKey: scaffoldKey,
                    animationController: animationController,
                    flag: _currentIndex,
                    userId: _userId,
                  );
                } else if (_currentIndex ==
                    PsConst.REQUEST_CODE__MENU_ALL_CITY_FRAGMENT) {
                  return AllCityListView(
                    key: const Key('1'),
                    animationController: animationController,
                    scrollController: _scrollController,
                    cityParameterHolder:
                        CityParameterHolder().getRecentCities(),
                  );
                } else if (_currentIndex ==
                    PsConst.REQUEST_CODE__MENU_POPULAR_CITY_FRAGMENT) {
                  return AllCityListView(
                    key: const Key('2'),
                    animationController: animationController,
                    scrollController: _scrollController,
                    cityParameterHolder:
                        CityParameterHolder().getPopularCities(),
                  );
                } else if (_currentIndex ==
                    PsConst.REQUEST_CODE__MENU_RECOMMAND_CITY_FRAGMENT) {
                  return AllCityListView(
                    key: const Key('3'),
                    animationController: animationController,
                    scrollController: _scrollController,
                    cityParameterHolder:
                        CityParameterHolder().getFeaturedCities(),
                  );
                } else if (_currentIndex ==
                        PsConst
                            .REQUEST_CODE__DASHBOARD_FORGOT_PASSWORD_FRAGMENT ||
                    _currentIndex ==
                        PsConst.REQUEST_CODE__MENU_FORGOT_PASSWORD_FRAGMENT) {
                  return Stack(children: <Widget>[
                    Container(
                      color: PsColors.mainLightColorWithBlack,
                      width: double.infinity,
                      height: double.maxFinite,
                    ),
                    CustomScrollView(
                        scrollDirection: Axis.vertical,
                        slivers: <Widget>[
                          ForgotPasswordView(
                            animationController: animationController,
                            goToLoginSelected: () {
                              animationController
                                  .reverse()
                                  .then<dynamic>((void data) {
                                if (!mounted) {
                                  return;
                                }
                                if (_currentIndex ==
                                    PsConst
                                        .REQUEST_CODE__MENU_FORGOT_PASSWORD_FRAGMENT) {
                                  updateSelectedIndexWithAnimation(
                                      Utils.getString(context, 'home__login'),
                                      PsConst
                                          .REQUEST_CODE__MENU_LOGIN_FRAGMENT);
                                }
                                if (_currentIndex ==
                                    PsConst
                                        .REQUEST_CODE__DASHBOARD_FORGOT_PASSWORD_FRAGMENT) {
                                  updateSelectedIndexWithAnimation(
                                      Utils.getString(context, 'home__login'),
                                      PsConst
                                          .REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT);
                                }
                              });
                            },
                          )
                        ])
                  ]);
                } else if (_currentIndex ==
                        PsConst.REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT ||
                    _currentIndex ==
                        PsConst.REQUEST_CODE__MENU_REGISTER_FRAGMENT) {
                  return Stack(children: <Widget>[
                    Container(
                      color: PsColors.mainLightColorWithBlack,
                      width: double.infinity,
                      height: double.maxFinite,
                    ),
                    CustomScrollView(
                        scrollDirection: Axis.vertical,
                        slivers: <Widget>[
                      RegisterView(
                        animationController: animationController,
                        onRegisterSelected: (User user) {
                          _userId = user.userId;
                          // widget.provider.psValueHolder.loginUserId = userId;
                          if (user.status == PsConst.ONE) {
                            updateSelectedIndexWithAnimationUserId(
                                Utils.getString(
                                    context, 'home__menu_drawer_profile'),
                                PsConst
                                    .REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT,
                                user.userId);
                          } else {
                            if (_currentIndex ==
                                PsConst.REQUEST_CODE__MENU_REGISTER_FRAGMENT) {
                              updateSelectedIndexWithAnimation(
                                  Utils.getString(
                                      context, 'home__verify_email'),
                                  PsConst
                                      .REQUEST_CODE__MENU_VERIFY_EMAIL_FRAGMENT);
                            } else if (_currentIndex ==
                                PsConst
                                    .REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT) {
                              updateSelectedIndexWithAnimation(
                                  Utils.getString(
                                      context, 'home__verify_email'),
                                  PsConst
                                      .REQUEST_CODE__DASHBOARD_VERIFY_EMAIL_FRAGMENT);
                            } else {
                              updateSelectedIndexWithAnimationUserId(
                                  Utils.getString(
                                      context, 'home__menu_drawer_profile'),
                                  PsConst
                                      .REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT,
                                  user.userId);
                            }
                          }
                        },
                        goToLoginSelected: () {
                          animationController
                              .reverse()
                              .then<dynamic>((void data) {
                            if (!mounted) {
                              return;
                            }
                            if (_currentIndex ==
                                PsConst.REQUEST_CODE__MENU_REGISTER_FRAGMENT) {
                              updateSelectedIndexWithAnimation(
                                  Utils.getString(context, 'home_login'),
                                  PsConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT);
                            }
                            if (_currentIndex ==
                                PsConst
                                    .REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT) {
                              updateSelectedIndexWithAnimation(
                                  Utils.getString(context, 'home_login'),
                                  PsConst
                                      .REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT);
                            }
                          });
                        })
                      ])
                  ]);
                } else if (_currentIndex ==
                        PsConst.REQUEST_CODE__DASHBOARD_VERIFY_EMAIL_FRAGMENT ||
                    _currentIndex ==
                        PsConst.REQUEST_CODE__MENU_VERIFY_EMAIL_FRAGMENT) {
                  return _CallVerifyEmailWidget(
                      animationController: animationController,
                      animation: animation,
                      currentIndex: _currentIndex,
                      userId: _userId,
                      updateCurrentIndex: (String title, int index) {
                        updateSelectedIndexWithAnimation(title, index);
                      },
                      updateUserCurrentIndex:
                          (String title, int index, String userId) async {
                        if (userId != null) {
                          _userId = userId;
                        }
                        setState(() {
                          appBarTitle = title;
                          _currentIndex = index;
                        });
                      });
                } else if (_currentIndex ==
                        PsConst.REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT ||
                    _currentIndex ==
                        PsConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT) {
                  return _CallLoginWidget(
                      currentIndex: _currentIndex,
                      animationController: animationController,
                      animation: animation,
                      updateCurrentIndex: (String title, int index) {
                        updateSelectedIndexWithAnimation(title, index);
                      },
                      updateUserCurrentIndex:
                          (String title, int index, String userId) {
                        setState(() {
                          if (index != null) {
                            appBarTitle = title;
                            _currentIndex = index;
                          }
                        });
                        if (userId != null) {
                          _userId = userId;
                        }
                      });
                } else if (_currentIndex ==
                    PsConst.REQUEST_CODE__MENU_SELECT_WHICH_USER_FRAGMENT) {
                  return ChangeNotifierProvider<UserProvider>(
                      lazy: false,
                      create: (BuildContext context) {
                        final UserProvider provider = UserProvider(
                            repo: userRepository, psValueHolder: valueHolder);

                        return provider;
                      },
                      child: Consumer<UserProvider>(builder:
                          (BuildContext context, UserProvider provider,
                              Widget child) {
                        if (provider == null ||
                            provider.psValueHolder.userIdToVerify == null ||
                            provider.psValueHolder.userIdToVerify == '') {
                          if (provider == null ||
                              provider.psValueHolder == null ||
                              provider.psValueHolder.loginUserId == null ||
                              provider.psValueHolder.loginUserId == '') {
                            return Stack(
                              children: <Widget>[
                                Container(
                                  color: PsColors.mainLightColorWithBlack,
                                  width: double.infinity,
                                  height: double.maxFinite,
                                ),
                                CustomScrollView(
                                    scrollDirection: Axis.vertical,
                                    slivers: <Widget>[
                                      LoginView(
                                        animationController:
                                            animationController,
                                        animation: animation,
                                        onGoogleSignInSelected:
                                            (String userId) {
                                          setState(() {
                                            _currentIndex = PsConst
                                                .REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT;
                                          });
                                          _userId = userId;
                                          provider.psValueHolder.loginUserId =
                                              userId;
                                        },
                                        onFbSignInSelected: (String userId) {
                                          setState(() {
                                            _currentIndex = PsConst
                                                .REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT;
                                          });
                                          _userId = userId;
                                          provider.psValueHolder.loginUserId =
                                              userId;
                                        },
                                        onPhoneSignInSelected: () {
                                          if (_currentIndex ==
                                              PsConst
                                                  .REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT) {
                                            updateSelectedIndexWithAnimation(
                                                Utils.getString(context,
                                                    'home__phone_signin'),
                                                PsConst
                                                    .REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT);
                                          }
                                          if (_currentIndex ==
                                              PsConst
                                                  .REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT) {
                                            updateSelectedIndexWithAnimation(
                                                Utils.getString(context,
                                                    'home__phone_signin'),
                                                PsConst
                                                    .REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT);
                                          }
                                          if (_currentIndex ==
                                              PsConst
                                                  .REQUEST_CODE__MENU_SELECT_WHICH_USER_FRAGMENT) {
                                            updateSelectedIndexWithAnimation(
                                                Utils.getString(context,
                                                    'home__phone_signin'),
                                                PsConst
                                                    .REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT);
                                          }
                                          if (_currentIndex ==
                                              PsConst
                                                  .REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT) {
                                            updateSelectedIndexWithAnimation(
                                                Utils.getString(context,
                                                    'home__phone_signin'),
                                                PsConst
                                                    .REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT);
                                          }
                                        },
                                        onProfileSelected: (String userId) {
                                          setState(() {
                                            _currentIndex = PsConst
                                                .REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT;
                                            _userId = userId;
                                            provider.psValueHolder.loginUserId =
                                                userId;
                                          });
                                        },
                                        onForgotPasswordSelected: () {
                                          setState(() {
                                            _currentIndex = PsConst
                                                .REQUEST_CODE__MENU_FORGOT_PASSWORD_FRAGMENT;
                                            appBarTitle = Utils.getString(
                                                context,
                                                'home__forgot_password');
                                          });
                                        },
                                        onSignInSelected: () {
                                          updateSelectedIndexWithAnimation(
                                              Utils.getString(
                                                  context, 'home__register'),
                                              PsConst
                                                  .REQUEST_CODE__MENU_REGISTER_FRAGMENT);
                                        },
                                      ),
                                    ])
                              ],
                            );
                          } else {
                            return ProfileView(
                              scaffoldKey: scaffoldKey,
                              animationController: animationController,
                              flag: _currentIndex,
                              userId: provider.psValueHolder.loginUserId,
                            );
                          }
                        } else {
                          return _CallVerifyEmailWidget(
                              animationController: animationController,
                              animation: animation,
                              currentIndex: _currentIndex,
                              userId: _userId,
                              updateCurrentIndex: (String title, int index) {
                                updateSelectedIndexWithAnimation(title, index);
                              },
                              updateUserCurrentIndex: (String title, int index,
                                  String userId) async {
                                if (userId != null) {
                                  _userId = userId;
                                  provider.psValueHolder.loginUserId = userId;
                                }
                                setState(() {
                                  appBarTitle = title;
                                  _currentIndex = index;
                                });
                              });
                        }
                      }));
                } else if (_currentIndex ==
                    PsConst.REQUEST_CODE__MENU_UPLOAD_ITEM_FRAGMENT) {
                  return ItemUploadListView(
                      animationController: animationController);
                } else if (_currentIndex ==
                    PsConst.REQUEST_CODE__MENU_FAVOURITE_FRAGMENT) {
                  return FavouriteItemListView(
                      animationController: animationController);
                } else if (_currentIndex ==
                    PsConst.REQUEST_CODE__MENU_PAID_AD_TRANSACTION_FRAGMENT) {
                  final ScrollController scrollController = ScrollController();
                  return PaidAdItemListView(
                    scrollController: scrollController,
                    animationController: animationController,
                  );
                } else if (_currentIndex ==
                    PsConst.REQUEST_CODE__MENU_USER_HISTORY_FRAGMENT) {
                  return HistoryListView(
                      animationController: animationController);
                } else if (_currentIndex ==
                    PsConst.REQUEST_CODE__MENU_LANGUAGE_FRAGMENT) {
                  return LanguageSettingView(
                      animationController: animationController,
                      languageIsChanged: () {});
                       } else if (_currentIndex ==
                    PsConst.REQUEST_CODE__MENU_CONTACT_US_FRAGMENT) {
                  return ContactUsView(
                      animationController: animationController);
                } else if (_currentIndex ==
                    PsConst.REQUEST_CODE__MENU_SETTING_FRAGMENT) {
                  return Container(
                    color: PsColors.coreBackgroundColor,
                    height: double.infinity,
                    child: SettingView(
                      animationController: animationController,
                    ),
                  );
                } else if (_currentIndex ==
                    PsConst.REQUEST_CODE__MENU_TERMS_AND_CONDITION_FRAGMENT) {
                  return PrivacyPolicyView(
                    animationController: animationController,
                  );
                }
                // else if (_currentIndex ==
                //     PsConst.REQUEST_CODE__DASHBOARD_EXPLORER_FRAGMENT) {
                //   return ItemListWithFilterView(
                //     key: const Key('1'),
                //     animationController: animationController,
                //     itemParameterHolder:
                //         ItemParameterHolder().getLatestParameterHolder(),
                //   );
                // } else if (_currentIndex ==
                //     PsConst.REQUEST_CODE__DASHBOARD_CATEGORY_FRAGMENT) {
                //   return CategoryListView(
                //       // animationController: animationController,
                //       );
                // }
                else {
                  animationController.forward();
                  return HomeDashboardViewWidget(
                      _scrollController,
                      animationController,
                      context,
                      animationControllerForFab, (String payload) {
                    return showDialog<dynamic>(
                      context: context,
                      builder: (_) {
                        return NotiDialog(message: '$payload');
                      },
                    );
                  });
                }
              },
            ),
          )),
    );
  }
}

class _CallLoginWidget extends StatelessWidget {
  const _CallLoginWidget(
      {@required this.animationController,
      @required this.animation,
      @required this.updateCurrentIndex,
      @required this.updateUserCurrentIndex,
      @required this.currentIndex});
  final Function updateCurrentIndex;
  final Function updateUserCurrentIndex;
  final AnimationController animationController;
  final Animation<double> animation;
  final int currentIndex;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          color: PsColors
              .mainLightColorWithBlack, //ps_wtheme_core_background_color,
          width: double.infinity,
          height: double.maxFinite,
        ),
        CustomScrollView(scrollDirection: Axis.vertical, slivers: <Widget>[
          LoginView(
            animationController: animationController,
            animation: animation,
            onGoogleSignInSelected: (String userId) {
              if (currentIndex == PsConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT) {
                updateUserCurrentIndex(
                    Utils.getString(context, 'home__menu_drawer_profile'),
                    PsConst.REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT,
                    userId);
              } else {
                updateUserCurrentIndex(
                    Utils.getString(context, 'home__menu_drawer_profile'),
                    PsConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT,
                    userId);
              }
            },
            onFbSignInSelected: (String userId) {
              if (currentIndex == PsConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT) {
                updateUserCurrentIndex(
                    Utils.getString(context, 'home__menu_drawer_profile'),
                    PsConst.REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT,
                    userId);
              } else {
                updateUserCurrentIndex(
                    Utils.getString(context, 'home__menu_drawer_profile'),
                    PsConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT,
                    userId);
              }
            },
            onPhoneSignInSelected: () {
              if (currentIndex == PsConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT) {
                updateCurrentIndex(
                    Utils.getString(context, 'home__phone_signin'),
                    PsConst.REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT);
              }
              if (currentIndex ==
                  PsConst.REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT) {
                updateCurrentIndex(
                    Utils.getString(context, 'home__phone_signin'),
                    PsConst.REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT);
              }
              if (currentIndex ==
                  PsConst.REQUEST_CODE__MENU_SELECT_WHICH_USER_FRAGMENT) {
                updateCurrentIndex(
                    Utils.getString(context, 'home__phone_signin'),
                    PsConst.REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT);
              }
              if (currentIndex ==
                  PsConst.REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT) {
                updateCurrentIndex(
                    Utils.getString(context, 'home__phone_signin'),
                    PsConst.REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT);
              }
            },
            onProfileSelected: (String userId) {
              if (currentIndex == PsConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT) {
                updateUserCurrentIndex(
                    Utils.getString(context, 'home__menu_drawer_profile'),
                    PsConst.REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT,
                    userId);
              } else {
                updateUserCurrentIndex(
                    Utils.getString(context, 'home__menu_drawer_profile'),
                    PsConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT,
                    userId);
              }
            },
            onForgotPasswordSelected: () {
              if (currentIndex == PsConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT) {
                updateCurrentIndex(
                    Utils.getString(context, 'home__forgot_password'),
                    PsConst.REQUEST_CODE__MENU_FORGOT_PASSWORD_FRAGMENT);
              } else {
                updateCurrentIndex(
                    Utils.getString(context, 'home__forgot_password'),
                    PsConst.REQUEST_CODE__DASHBOARD_FORGOT_PASSWORD_FRAGMENT);
              }
            },
            onSignInSelected: () {
              if (currentIndex == PsConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT) {
                updateCurrentIndex(Utils.getString(context, 'home__register'),
                    PsConst.REQUEST_CODE__MENU_REGISTER_FRAGMENT);
              } else {
                updateCurrentIndex(Utils.getString(context, 'home__register'),
                    PsConst.REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT);
              }
            },
          ),
        ])
      ],
    );
  }
}

class _CallVerifyPhoneWidget extends StatelessWidget {
  const _CallVerifyPhoneWidget(
      {this.userName,
      this.phoneNumber,
      this.phoneId,
      @required this.updateCurrentIndex,
      @required this.updateUserCurrentIndex,
      @required this.animationController,
      @required this.animation,
      @required this.currentIndex});

  final String userName;
  final String phoneNumber;
  final String phoneId;
  final Function updateCurrentIndex;
  final Function updateUserCurrentIndex;
  final int currentIndex;
  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    animationController.forward();
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: VerifyPhoneView(
          userName: userName,
          phoneNumber: phoneNumber,
          phoneId: phoneId,
          animationController: animationController,
          onProfileSelected: (String userId) {
            if (currentIndex ==
                PsConst.REQUEST_CODE__MENU_PHONE_VERIFY_FRAGMENT) {
              updateUserCurrentIndex(
                  Utils.getString(context, 'home__menu_drawer_profile'),
                  PsConst.REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT,
                  userId);
            } else if (currentIndex ==
                PsConst.REQUEST_CODE__DASHBOARD_PHONE_VERIFY_FRAGMENT) {
              updateUserCurrentIndex(
                  Utils.getString(context, 'home__menu_drawer_profile'),
                  PsConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT,
                  userId);
            }
          },
          onSignInSelected: () {
            if (currentIndex ==
                PsConst.REQUEST_CODE__MENU_PHONE_VERIFY_FRAGMENT) {
              updateCurrentIndex(Utils.getString(context, 'home__phone_signin'),
                  PsConst.REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT);
            } else if (currentIndex ==
                PsConst.REQUEST_CODE__DASHBOARD_PHONE_VERIFY_FRAGMENT) {
              updateCurrentIndex(Utils.getString(context, 'home__phone_signin'),
                  PsConst.REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT);
            }
          },
        ));
  }
}

class _CallVerifyEmailWidget extends StatelessWidget {
  const _CallVerifyEmailWidget(
      {@required this.updateCurrentIndex,
      @required this.updateUserCurrentIndex,
      @required this.animationController,
      @required this.animation,
      @required this.currentIndex,
      @required this.userId});
  final Function updateCurrentIndex;
  final Function updateUserCurrentIndex;
  final int currentIndex;
  final AnimationController animationController;
  final Animation<double> animation;
  final String userId;

  @override
  Widget build(BuildContext context) {
    animationController.forward();
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: VerifyEmailView(
          animationController: animationController,
          userId: userId,
          onProfileSelected: (String userId) {
            if (currentIndex ==
                PsConst.REQUEST_CODE__MENU_VERIFY_EMAIL_FRAGMENT) {
              updateUserCurrentIndex(
                  Utils.getString(context, 'home__menu_drawer_profile'),
                  PsConst.REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT,
                  userId);
            } else if (currentIndex ==
                PsConst.REQUEST_CODE__DASHBOARD_VERIFY_EMAIL_FRAGMENT) {
              updateUserCurrentIndex(
                  Utils.getString(context, 'home__menu_drawer_profile'),
                  PsConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT,
                  userId);
              // updateCurrentIndex(PsConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT);
            }
          },
          onSignInSelected: () {
            if (currentIndex ==
                PsConst.REQUEST_CODE__MENU_VERIFY_EMAIL_FRAGMENT) {
              updateCurrentIndex(Utils.getString(context, 'home__register'),
                  PsConst.REQUEST_CODE__MENU_REGISTER_FRAGMENT);
            } else if (currentIndex ==
                PsConst.REQUEST_CODE__DASHBOARD_VERIFY_EMAIL_FRAGMENT) {
              updateCurrentIndex(Utils.getString(context, 'home__register'),
                  PsConst.REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT);
            } else if (currentIndex ==
                PsConst.REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT) {
              updateCurrentIndex(Utils.getString(context, 'home__register'),
                  PsConst.REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT);
            } else if (currentIndex ==
                PsConst.REQUEST_CODE__MENU_SELECT_WHICH_USER_FRAGMENT) {
              updateCurrentIndex(Utils.getString(context, 'home__register'),
                  PsConst.REQUEST_CODE__MENU_REGISTER_FRAGMENT);
            }
          },
        ));
  }
}

class _DrawerMenuWidget extends StatefulWidget {
  const _DrawerMenuWidget({
    Key key,
    @required this.icon,
    @required this.title,
    @required this.onTap,
    @required this.index,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final Function onTap;
  final int index;

  @override
  __DrawerMenuWidgetState createState() => __DrawerMenuWidgetState();
}

class __DrawerMenuWidgetState extends State<_DrawerMenuWidget> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Icon(widget.icon, color: PsColors.mainColorWithWhite),
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.bodyText2,
        ),
        onTap: () {
          widget.onTap(widget.title, widget.index);
        });
  }
}

class _DrawerHeaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      child: Column(
        children: <Widget>[
          Image.asset(
            'assets/images/flutter_app_icon.png',
            width: PsDimens.space100,
            height: PsDimens.space72,
          ),
          const SizedBox(
            height: PsDimens.space8,
          ),
          Text(
            Utils.getString(context, 'app_name'),
            style: Theme.of(context)
                .textTheme
                .subtitle1
                .copyWith(color: PsColors.white),
          ),
        ],
      ),
      decoration: BoxDecoration(color: PsColors.mainColor),
    );
  }
}
