import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:businesslistingapi/config/ps_config.dart';
import 'package:businesslistingapi/constant/ps_constants.dart';
import 'package:businesslistingapi/constant/route_paths.dart';
import 'package:businesslistingapi/provider/city_info/city_info_provider.dart';
import 'package:businesslistingapi/provider/delete_task/delete_task_provider.dart';
import 'package:businesslistingapi/repository/delete_task_repository.dart';
import 'package:businesslistingapi/repository/item_repository.dart';
import 'package:businesslistingapi/repository/user_repository.dart';
import 'package:businesslistingapi/ui/category/list/category_list_view.dart';
import 'package:businesslistingapi/ui/city_menu/city_menu_view.dart';
import 'package:businesslistingapi/ui/common/dialog/confirm_dialog_view.dart';
import 'package:businesslistingapi/ui/item_dashboard/item_home/item_home_dashboard_view.dart';
import 'package:businesslistingapi/ui/items/list_with_filter/item_list_with_filter_view.dart';
import 'package:businesslistingapi/ui/search/home_item_search_view.dart';
import 'package:businesslistingapi/viewobject/city.dart';
import 'package:businesslistingapi/viewobject/common/ps_value_holder.dart';
import 'package:businesslistingapi/viewobject/holder/item_parameter_holder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:businesslistingapi/config/ps_colors.dart';
import 'package:businesslistingapi/utils/utils.dart';

class ItemDashboardView extends StatefulWidget {
  const ItemDashboardView({Key key, @required this.city}) : super(key: key);
  final City city;
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<ItemDashboardView>
    with TickerProviderStateMixin {
  AnimationController animationController;
  AnimationController animationControllerForFab;

  Animation<double> animation;

  String appBarTitle = 'Home';
  int _currentIndex = PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT;
  bool isLogout = false;
  bool isFirstTime = true;
  String phoneUserName = '';
  String phoneNumber = '';
  String phoneId = '';

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  CityInfoProvider cityInfoProvider;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  @override
  void initState() {
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);

    animationControllerForFab = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this, value: 1);

    super.initState();
    // Utils.fcmConfigure(context, _fcm, valueHolder.loginUserId);
  }

  @override
  void dispose() {
    animationController.dispose();
    animationControllerForFab.dispose();
    super.dispose();
  }

  int getBottonNavigationIndex(int param) {
    int index = 0;
    switch (param) {
      case PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT:
        index = 0;
        break;
      case PsConst.REQUEST_CODE__DASHBOARD_EXPLORER_FRAGMENT:
        index = 1;
        break;
      case PsConst.REQUEST_CODE__DASHBOARD_CATEGORY_FRAGMENT:
        index = 2;
        break;
      case PsConst.REQUEST_CODE__DASHBOARD_SEARCH_FRAGMENT:
        index = 3;
        break;
      case PsConst.REQUEST_CODE__DASHBOARD_MORE_FRAGMENT:
        index = 4;
        break;

      default:
        index = 0;
        break;
    }
    return index;
  }

  dynamic getIndexFromBottonNavigationIndex(int param) {
    int index = PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT;
    String title;
    switch (param) {
      case 0:
        index = PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT;
        title = widget.city.name;
        break;
      case 1:
        index = PsConst.REQUEST_CODE__DASHBOARD_EXPLORER_FRAGMENT;
        title = Utils.getString(context, 'home__bottom_app_bar_explorer');
        break;
      case 2:
        index = PsConst.REQUEST_CODE__DASHBOARD_CATEGORY_FRAGMENT;
        title = Utils.getString(context, 'home__bottom_app_bar_interest');
        break;
      case 3:
        index = PsConst.REQUEST_CODE__DASHBOARD_SEARCH_FRAGMENT;
        title = Utils.getString(context, 'home__bottom_app_bar_search');
        break;
      case 4:
        index = PsConst.REQUEST_CODE__DASHBOARD_MORE_FRAGMENT;
        title = Utils.getString(context, 'city_menu__app_bar_name');
        break;
      default:
        index = 0;
        title = Utils.getString(context, 'app_name');
        break;
    }
    return <dynamic>[title, index];
  }

  UserRepository userRepository;
  ItemRepository itemRepository;
  PsValueHolder valueHolder;
  DeleteTaskRepository deleteTaskRepository;
  DeleteTaskProvider deleteTaskProvider;

  @override
  Widget build(BuildContext context) {
    userRepository = Provider.of<UserRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context);

    itemRepository = Provider.of<ItemRepository>(context);
    deleteTaskRepository = Provider.of<DeleteTaskRepository>(context);

    timeDilation = 1.0;

    if (isFirstTime) {
      appBarTitle = widget.city.name;
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

    Future<bool> _onWillPop() {
      return showDialog<dynamic>(
              context: context,
              builder: (BuildContext context) {
                return ConfirmDialogView(
                    description: Utils.getString(
                        context, 'home__quit_city_dialog_description'),
                    leftButtonText: Utils.getString(
                        context, 'app_info__cancel_button_name'),
                    rightButtonText: Utils.getString(context, 'dialog__ok'),
                    onAgreeTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
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
        appBar: AppBar(
          backgroundColor:
              Utils.isLightMode(context) ? PsColors.mainColor : Colors.black12,
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
            if (appBarTitle == widget.city.name)
              Visibility(
                visible: true,
                child: IconButton(
                  icon: Icon(Feather.book_open, color: PsColors.white),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      RoutePaths.cityBlogList,
                      arguments: widget.city.id,
                    );
                  },
                ),
              )
            else
              Container(),
          ],
        ),
        bottomNavigationBar: _currentIndex ==
                    PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT ||
                _currentIndex ==
                    PsConst.REQUEST_CODE__DASHBOARD_EXPLORER_FRAGMENT ||
                _currentIndex ==
                    PsConst.REQUEST_CODE__DASHBOARD_SEARCH_FRAGMENT ||
                _currentIndex ==
                    PsConst.REQUEST_CODE__DASHBOARD_CATEGORY_FRAGMENT ||
                _currentIndex == PsConst.REQUEST_CODE__DASHBOARD_MORE_FRAGMENT
            ? Visibility(
                visible: true,
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  currentIndex: getBottonNavigationIndex(_currentIndex),
                  showUnselectedLabels: true,
                  backgroundColor: PsColors.backgroundColor,
                  selectedItemColor: PsColors.mainColor,
                  elevation: 10,
                  onTap: (int index) {
                    final dynamic _returnValue =
                        getIndexFromBottonNavigationIndex(index);

                    updateSelectedIndexWithAnimation(
                        _returnValue[0], _returnValue[1]);
                  },
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: const Icon(
                        Icons.store,
                        size: 20,
                      ),
                      label:
                          Utils.getString(context, 'home__bottom_app_bar_home'),
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.location_on),
                      label: Utils.getString(
                          context, 'home__bottom_app_bar_explorer'),
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.dashboard),
                      label: Utils.getString(
                          context, 'home__bottom_app_bar_interest'),
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.search),
                      label: Utils.getString(
                          context, 'home__bottom_app_bar_search'),
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.menu),
                      label:
                          Utils.getString(context, 'home__bottom_app_bar_more'),
                    ),
                  ],
                ),
              )
            : null,
        floatingActionButton: _currentIndex ==
                    PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT ||
                _currentIndex ==
                    PsConst.REQUEST_CODE__DASHBOARD_EXPLORER_FRAGMENT ||
                _currentIndex ==
                    PsConst.REQUEST_CODE__DASHBOARD_SEARCH_FRAGMENT ||
                _currentIndex ==
                    PsConst.REQUEST_CODE__DASHBOARD_CATEGORY_FRAGMENT ||
                _currentIndex == PsConst.REQUEST_CODE__DASHBOARD_MORE_FRAGMENT
            ? Container(
                height: 65.0,
                width: 65.0,
                child: FittedBox(
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: PsColors.mainColor.withOpacity(0.3),
                              offset: const Offset(1.1, 1.1),
                              blurRadius: 10.0),
                        ],
                      ),
                      child: Container()),
                ),
              )
            : null,
        body: Builder(
          builder: (BuildContext context) {
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
                PsConst.REQUEST_CODE__DASHBOARD_EXPLORER_FRAGMENT) {
              final ItemParameterHolder itemParameterHolder =
                  ItemParameterHolder();
              itemParameterHolder.getLatestParameterHolder().cityId =
                  widget.city.id;
              return ItemListWithFilterView(
                checkPage: '1',
                key: const Key('1'),
                animationController: animationController,
                itemParameterHolder: itemParameterHolder,
              );
            } else if (_currentIndex ==
                PsConst.REQUEST_CODE__DASHBOARD_CATEGORY_FRAGMENT) {
              return CategoryListView(
                city: widget.city,
              );
            } else if (_currentIndex ==
                PsConst.REQUEST_CODE__DASHBOARD_MORE_FRAGMENT) {
              return CityMenuView(
                city: widget.city,
              );
            } else {
              animationController.forward();
              return ItemHomeDashboardViewWidget(
                widget.city,
                animationController,
                context,
                animationControllerForFab,
              );
            }
          },
        ),
      ),
    );
  }
}
