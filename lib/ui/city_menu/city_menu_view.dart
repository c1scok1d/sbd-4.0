import 'package:flutter_icons/flutter_icons.dart';
import 'package:businesslistingapi/config/ps_colors.dart';
import 'package:businesslistingapi/config/ps_config.dart';
import 'package:businesslistingapi/constant/ps_dimens.dart';
import 'package:businesslistingapi/constant/route_paths.dart';
import 'package:businesslistingapi/provider/user/user_provider.dart';
import 'package:businesslistingapi/repository/user_repository.dart';
import 'package:businesslistingapi/ui/common/ps_ui_widget.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:businesslistingapi/viewobject/city.dart';
import 'package:businesslistingapi/viewobject/common/ps_value_holder.dart';
import 'package:businesslistingapi/viewobject/holder/intent_holder/category_container_intent_holder.dart';
import 'package:businesslistingapi/viewobject/holder/intent_holder/item_list_intent_holder.dart';
import 'package:businesslistingapi/viewobject/holder/item_parameter_holder.dart';
import 'package:businesslistingapi/viewobject/user.dart';
import 'package:provider/provider.dart';

class CityMenuView extends StatefulWidget {
  const CityMenuView({@required this.city});
  final City city;
  @override
  _CityMenuViewState createState() {
    return _CityMenuViewState();
  }
}

class _CityMenuViewState extends State<CityMenuView>
    with TickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;

  @override
  void dispose() {
    animationController.dispose();
    animation = null;
    super.dispose();
  }

  @override
  void initState() {
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);

    super.initState();
  }

  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet && PsConfig.showAdMob) {
        setState(() {});
      }
    });
  }

  final ItemParameterHolder itemParameterHolder = ItemParameterHolder();
  UserRepository userRepository;
  PsValueHolder valueHolder;

  @override
  Widget build(BuildContext context) {
    userRepository = Provider.of<UserRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context);
    if (!isConnectedToInternet && PsConfig.showAdMob) {
      print('loading ads....');
      checkConnection();
    }
    Future<bool> _requestPop() {
      animationController.reverse().then<dynamic>(
        (void data) {
          if (!mounted) {
            return Future<bool>.value(false);
          }
          Navigator.pop(context, true);
          return Future<bool>.value(true);
        },
      );
      return Future<bool>.value(false);
    }

    print(
        '............................Build UI Again ............................');
    return WillPopScope(
        onWillPop: _requestPop,
        child: ChangeNotifierProvider<UserProvider>(
            lazy: false,
            create: (BuildContext context) {
              final UserProvider provider = UserProvider(
                  repo: userRepository, psValueHolder: valueHolder);
              provider.getUser(valueHolder.loginUserId);
              return provider;
            },
            child: Consumer<UserProvider>(builder:
                (BuildContext context, UserProvider provider, Widget child) {
              return SingleChildScrollView(
                child: Column(children: <Widget>[
                  // const PsAdMobBannerWidget(),

                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: PsColors.grey, width: 0.01),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                            margin: const EdgeInsets.all(PsDimens.space12),
                            width: 100,
                            height: 100,
                            child: CircleAvatar(
                              child: PsNetworkCircleImage(
                                photoKey: '',
                                imagePath: '',
                                width: double.infinity,
                                height: PsDimens.space200,
                                boxfit: BoxFit.cover,
                                onTap: () async {},
                              ),
                            )),
                        if (provider == null ||
                            provider.psValueHolder == null ||
                            provider.psValueHolder.loginUserId == null ||
                            provider.psValueHolder.loginUserId == '')
                          InkWell(
                              onTap: () async {
                                final dynamic returnData =
                                    await Navigator.pushNamed(
                                  context,
                                  RoutePaths.login_container,
                                );

                                if (returnData != null && returnData is User) {
                                  setState(() {
                                    //   userName = returnData.userName;
                                    //   userPhoneNo = returnData.userPhone;
                                    //   userEmail = returnData.userEmail;
                                    provider.psValueHolder.loginUserId =
                                        returnData.userId;

                                    provider.getUser(returnData.userId);
                                  });
                                }
                              },
                              child: Container(
                                height: PsDimens.space40,
                                width: PsDimens.space68,
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(
                                  bottom: PsDimens.space16,
                                ),
                                decoration: BoxDecoration(
                                  color: PsColors.mainColor,
                                  borderRadius:
                                      BorderRadius.circular(PsDimens.space4),
                                  border: Border.all(
                                      color: PsColors.mainShadowColor),
                                ),
                                child: Text(
                                  'Sing In',
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                              ))
                        else if (provider != null &&
                            provider.user != null &&
                            provider.user.data != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(provider.user.data.userName,
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context).textTheme.bodyText1),
                              const SizedBox(height: PsDimens.space12),
                              Text(provider.user.data.userPhone,
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context).textTheme.bodyText1),
                              const SizedBox(height: PsDimens.space12),
                              Text(provider.user.data.userEmail,
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context).textTheme.bodyText1),
                              const SizedBox(height: PsDimens.space20),
                            ],
                          )
                        else
                          Container()
                      ],
                    ),
                  ),

                  const SizedBox(height: PsDimens.space16),

                  _IconsAndTextWidget(
                    icon: MaterialCommunityIcons.view_dashboard_outline,
                    name: Utils.getString(context, 'city_menu__interest'),
                    onTap: () {
                      Navigator.pushNamed(context, RoutePaths.categoryList,
                          arguments: CategoryContainerIntentHolder(
                              appBarTitle: Utils.getString(
                                  context, 'dashboard__categories'),
                              city: widget.city));
                    },
                  ),
                  _IconsAndTextWidget(
                    icon: Icons.schedule,
                    name: Utils.getString(
                        context, 'city_menu__latest_destinations'),
                    onTap: () {
                      itemParameterHolder.getLatestParameterHolder().cityId =
                          widget.city.id;
                      Navigator.pushNamed(context, RoutePaths.filterItemList,
                          arguments: ItemListIntentHolder(
                            checkPage: '0',
                            appBarTitle: Utils.getString(
                                context, 'city_menu__latest_destinations'),
                            itemParameterHolder: itemParameterHolder,
                          ));
                    },
                  ),
                  _IconsAndTextWidget(
                    icon: Feather.percent,
                    name: Utils.getString(context, 'city_menu__promotions'),
                    onTap: () {
                      itemParameterHolder.getDiscountParameterHolder().cityId =
                          widget.city.id;
                      Navigator.pushNamed(context, RoutePaths.filterItemList,
                          arguments: ItemListIntentHolder(
                              checkPage: '0',
                              appBarTitle: Utils.getString(
                                  context, 'city_menu__promotions'),
                              itemParameterHolder: itemParameterHolder));
                    },
                  ),
                  _IconsAndTextWidget(
                    icon: SimpleLineIcons.diamond,
                    name: Utils.getString(
                        context, 'city_menu__featured_destinations'),
                    onTap: () {
                      itemParameterHolder.getFeaturedParameterHolder().cityId =
                          widget.city.id;
                      Navigator.pushNamed(context, RoutePaths.filterItemList,
                          arguments: ItemListIntentHolder(
                              checkPage: '0',
                              appBarTitle: Utils.getString(
                                  context, 'city_menu__featured_destinations'),
                              itemParameterHolder: itemParameterHolder));
                    },
                  ),
                  _IconsAndTextWidget(
                    icon: Icons.trending_up,
                    name: Utils.getString(
                        context, 'city_menu__popular_destinations'),
                    onTap: () {
                      itemParameterHolder.getTrendingParameterHolder().cityId =
                          widget.city.id;
                      Navigator.pushNamed(context, RoutePaths.filterItemList,
                          arguments: ItemListIntentHolder(
                              checkPage: '0',
                              appBarTitle: Utils.getString(
                                  context, 'city_menu__popular_destinations'),
                              itemParameterHolder: itemParameterHolder));
                    },
                  ),
                  _IconsAndTextWidget(
                    icon: SimpleLineIcons.folder_alt,
                    name: Utils.getString(context, 'city_menu__collections'),
                    onTap: () {
                      Navigator.pushNamed(
                          context, RoutePaths.collectionProductList,
                          arguments: widget.city.id);
                    },
                  ),
                ]),
              );
            })));
  }
}

class _IconsAndTextWidget extends StatelessWidget {
  const _IconsAndTextWidget(
      {@required this.icon, @required this.name, @required this.onTap});
  final IconData icon;
  final String name;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: PsColors.grey, width: 0.2),
          // color: PsColors.mainColor,
        ),
        padding: const EdgeInsets.all(PsDimens.space16),
        child: Row(
          children: <Widget>[
            Icon(
              icon,
              size: PsDimens.space28,
              color: Theme.of(context).iconTheme.color,
            ),
            const SizedBox(
              width: PsDimens.space12,
            ),
            Text(name,
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.bodyText1),
          ],
        ),
      ),
    );
  }
}
