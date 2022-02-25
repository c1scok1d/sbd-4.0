import 'package:businesslistingapi/api/common/ps_status.dart';
import 'package:businesslistingapi/config/ps_colors.dart';
import 'package:businesslistingapi/config/ps_config.dart';
import 'package:businesslistingapi/constant/ps_constants.dart';
import 'package:businesslistingapi/provider/item/search_item_provider.dart';
import 'package:businesslistingapi/repository/item_repository.dart';
import 'package:businesslistingapi/ui/items/item/item_vertical_list_item.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:businesslistingapi/viewobject/common/ps_value_holder.dart';
import 'package:businesslistingapi/viewobject/holder/intent_holder/item_detail_intent_holder.dart';
import 'package:businesslistingapi/viewobject/holder/item_parameter_holder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:businesslistingapi/viewobject/item.dart';
import 'package:provider/provider.dart';
import 'package:businesslistingapi/constant/ps_dimens.dart';
import 'package:businesslistingapi/constant/route_paths.dart';
import 'package:businesslistingapi/ui/common/ps_ui_widget.dart';

class ItemListWithFilterView extends StatefulWidget {
  const ItemListWithFilterView(
      {Key key,
      @required this.itemParameterHolder,
      @required this.animationController,
      this.changeAppBarTitle,
      @required this.checkPage})
      : super(key: key);

  final ItemParameterHolder itemParameterHolder;
  final AnimationController animationController;
  final Function changeAppBarTitle;
  final String checkPage;

  @override
  _ItemListWithFilterViewState createState() => _ItemListWithFilterViewState();
}

class _ItemListWithFilterViewState extends State<ItemListWithFilterView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  SearchItemProvider _searchItemProvider;
  bool isVisible = true;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _offset = 0;
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _searchItemProvider
            .nextItemListByKey(_searchItemProvider.itemParameterHolder);
      }
      setState(() {
        final double offset = _scrollController.offset;
        _delta += offset - _oldOffset;
        if (_delta > _containerMaxHeight)
          _delta = _containerMaxHeight;
        else if (_delta < 0) {
          _delta = 0;
        }
        _oldOffset = offset;
        _offset = -_delta;
      });

      print(' Offset $_offset');
    });
  }

  final double _containerMaxHeight = 60;
  double _offset, _delta = 0, _oldOffset = 0;
  ItemRepository itemRepo;
  dynamic data;
  PsValueHolder valueHolder;
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

  @override
  Widget build(BuildContext context) {
    itemRepo = Provider.of<ItemRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context);

    if (!isConnectedToInternet && PsConfig.showAdMob) {
      print('loading ads....');
      checkConnection();
    }
    print(
        '............................Build UI Again ............................');
    return ChangeNotifierProvider<SearchItemProvider>(
        lazy: false,
        create: (BuildContext context) {
          final SearchItemProvider provider =
              SearchItemProvider(repo: itemRepo, psValueHolder: valueHolder);
          provider.loadItemListByKey(widget.itemParameterHolder);
          _searchItemProvider = provider;
          _searchItemProvider.itemParameterHolder = widget.itemParameterHolder;
          return _searchItemProvider;
        },
        child: Consumer<SearchItemProvider>(builder:
            (BuildContext context, SearchItemProvider provider, Widget child) {
          return Column(
            children: <Widget>[
              // const PsAdMobBannerWidget(),
              // Visibility(
              //   visible: PsConfig.showAdMob &&
              //       isSuccessfullyLoaded &&
              //       isConnectedToInternet,
              //   child: AdmobBanner(
              //     adUnitId: Utils.getBannerAdUnitId(),
              //     adSize: AdmobBannerSize.FULL_BANNER,
              //     listener: (AdmobAdEvent event, Map<String, dynamic> map) {
              //       print('BannerAd event is $event');
              //       if (event == AdmobAdEvent.loaded) {
              //         isSuccessfullyLoaded = true;
              //       } else {
              //         isSuccessfullyLoaded = false;
              //         setState(() {});
              //       }
              //     },
              //   ),
              // ),
              Expanded(
                child: Container(
                  color: PsColors.coreBackgroundColor,
                  child: Stack(children: <Widget>[
                    if (provider.itemList.data.isNotEmpty &&
                        provider.itemList.data != null)
                      Container(
                          color: PsColors.coreBackgroundColor,
                          margin: const EdgeInsets.only(
                              left: PsDimens.space8,
                              right: PsDimens.space8,
                              top: PsDimens.space4,
                              bottom: PsDimens.space4),
                          child: RefreshIndicator(
                            child: CustomScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                controller: _scrollController,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                slivers: <Widget>[
                                  SliverGrid(
                                    gridDelegate:
                                        const SliverGridDelegateWithMaxCrossAxisExtent(
                                            maxCrossAxisExtent: 220,
                                            childAspectRatio: 0.6),
                                    delegate: SliverChildBuilderDelegate(
                                      (BuildContext context, int index) {
                                        if (provider.itemList.data != null ||
                                            provider.itemList.data.isNotEmpty) {
                                          List<Item> dataList =
                                              provider.itemList.data;
                                          if (provider
                                                  .itemParameterHolder.isAtoZ ==
                                              '1') {
                                            dataList.sort((Item a, Item b) =>
                                                a.name.compareTo(b.name));
                                            print(dataList[0].name);
                                          }
                                          if (provider
                                                  .itemParameterHolder.isZtoA ==
                                              '1') {
                                            dataList.sort((Item a, Item b) =>
                                                b.name.compareTo(a.name));
                                            print(dataList[0].name);
                                          } else {
                                            dataList = provider.itemList.data;
                                          }

                                          final int count =
                                              provider.itemList.data.length;
                                          return ItemVeticalListItem(
                                            coreTagKey:
                                                provider.hashCode.toString() +
                                                    provider.itemList
                                                        .data[index].id,
                                            animationController:
                                                widget.animationController,
                                            animation: Tween<double>(
                                                    begin: 0.0, end: 1.0)
                                                .animate(
                                              CurvedAnimation(
                                                parent:
                                                    widget.animationController,
                                                curve: Interval(
                                                    (1 / count) * index, 1.0,
                                                    curve:
                                                        Curves.fastOutSlowIn),
                                              ),
                                            ),
                                            item: dataList[index],
                                            onTap: () async {
                                              final Item item = dataList[index];
                                              final ItemDetailIntentHolder
                                                  holder =
                                                  ItemDetailIntentHolder(
                                                itemId: item.id,
                                                heroTagImage: provider.hashCode
                                                        .toString() +
                                                    item.id +
                                                    PsConst.HERO_TAG__IMAGE,
                                                heroTagTitle: provider.hashCode
                                                        .toString() +
                                                    item.id +
                                                    PsConst.HERO_TAG__TITLE,
                                                heroTagOriginalPrice: provider
                                                        .hashCode
                                                        .toString() +
                                                    item.id +
                                                    PsConst
                                                        .HERO_TAG__ORIGINAL_PRICE,
                                                heroTagUnitPrice: provider
                                                        .hashCode
                                                        .toString() +
                                                    item.id +
                                                    PsConst
                                                        .HERO_TAG__UNIT_PRICE,
                                              );

                                              final dynamic result =
                                                  await Navigator.pushNamed(
                                                      context,
                                                      RoutePaths.itemDetail,
                                                      arguments: holder);

                                              if (result == null) {
                                                provider.loadItemListByKey(
                                                    widget.itemParameterHolder);
                                              }
                                            },
                                          );
                                        } else {
                                          return null;
                                        }
                                      },
                                      childCount: provider.itemList.data.length,
                                    ),
                                  ),
                                ]),
                            onRefresh: () {
                              return provider.resetLatestItemList(
                                  _searchItemProvider.itemParameterHolder);
                            },
                          ))
                    else if (provider.itemList.status !=
                            PsStatus.PROGRESS_LOADING &&
                        provider.itemList.status != PsStatus.BLOCK_LOADING &&
                        provider.itemList.status != PsStatus.NOACTION)
                      Align(
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Image.asset(
                                'assets/images/baseline_empty_item_grey_24.png',
                                height: 100,
                                width: 150,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(
                                height: PsDimens.space32,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: PsDimens.space20,
                                    right: PsDimens.space20),
                                child: Text(
                                  Utils.getString(
                                      context, 'procuct_list__no_result_data'),
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(),
                                ),
                              ),
                              const SizedBox(
                                height: PsDimens.space20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (widget.checkPage == '1')
                      Positioned(
                        bottom: _offset,
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          margin: const EdgeInsets.only(
                              left: PsDimens.space12,
                              top: PsDimens.space8,
                              right: PsDimens.space12,
                              bottom: PsDimens.space16),
                          child: Container(
                              width: double.infinity,
                              height: _containerMaxHeight,
                              child: BottomNavigationImageAndText(
                                changeAppBarTitle: widget.changeAppBarTitle,
                                searchItemProvider: _searchItemProvider,
                              )),
                        ),
                      )
                    else
                      Container(),
                    PSProgressIndicator(provider.itemList.status),
                  ]),
                ),
              )
            ],
          );
        }));
  }
}

class BottomNavigationImageAndText extends StatefulWidget {
  const BottomNavigationImageAndText(
      {this.searchItemProvider, this.changeAppBarTitle});

  final SearchItemProvider searchItemProvider;
  final Function changeAppBarTitle;

  @override
  _BottomNavigationImageAndTextState createState() =>
      _BottomNavigationImageAndTextState();
}

class _BottomNavigationImageAndTextState
    extends State<BottomNavigationImageAndText> {
  bool isClickBaseLineList = false;
  bool isClickBaseLineTune = false;

  @override
  Widget build(BuildContext context) {
    if (widget.searchItemProvider.itemParameterHolder.isFiltered()) {
      isClickBaseLineTune = true;
    }

    if (widget.searchItemProvider.itemParameterHolder
        .isCatAndSubCatFiltered()) {
      isClickBaseLineList = true;
    }

    // if(widget.searchItemProvider.itemParameterHolder.getLatestParameterHolder()){

    // }

    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: PsColors.mainLightShadowColor),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: PsColors.mainShadowColor,
                offset: const Offset(1.1, 1.1),
                blurRadius: 10.0),
          ],
          color: PsColors.backgroundColor,
          borderRadius:
              const BorderRadius.all(Radius.circular(PsDimens.space8))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          GestureDetector(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                PsIconWithCheck(
                  icon: MaterialCommunityIcons.format_list_bulleted_type,
                  color: isClickBaseLineList
                      ? PsColors.mainColor
                      : PsColors.iconColor,
                ),
                Text(Utils.getString(context, 'search__category'),
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                        color: isClickBaseLineList
                            ? PsColors.mainColor
                            : PsColors.textPrimaryColor)),
              ],
            ),
            onTap: () async {
              final Map<String, String> dataHolder = <String, String>{};
              dataHolder[PsConst.CATEGORY_ID] =
                  widget.searchItemProvider.itemParameterHolder.catId;
              dataHolder[PsConst.SUB_CATEGORY_ID] =
                  widget.searchItemProvider.itemParameterHolder.subCatId;
              dataHolder[PsConst.CITY_ID] =
                  widget.searchItemProvider.psValueHolder.cityId;
              final dynamic result = await Navigator.pushNamed(
                  context, RoutePaths.filterExpantion,
                  arguments: dataHolder);

              if (result != null) {
                widget.searchItemProvider.itemParameterHolder.catId =
                    result[PsConst.CATEGORY_ID];
                widget.searchItemProvider.itemParameterHolder.subCatId =
                    result[PsConst.SUB_CATEGORY_ID];

                widget.searchItemProvider.resetLatestItemList(
                    widget.searchItemProvider.itemParameterHolder);

                if (result[PsConst.CATEGORY_ID] == '' &&
                    result[PsConst.SUB_CATEGORY_ID] == '') {
                  isClickBaseLineList = false;
                } else {
                  widget.changeAppBarTitle(result[PsConst.CATEGORY_NAME]);
                  isClickBaseLineList = true;
                }
              }
            },
          ),
          GestureDetector(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                PsIconWithCheck(
                  icon: Icons.filter_list,
                  color: isClickBaseLineTune
                      ? PsColors.mainColor
                      : PsColors.iconColor,
                ),
                Text(Utils.getString(context, 'search__filter'),
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                        color: isClickBaseLineTune
                            ? PsColors.mainColor
                            : PsColors.textPrimaryColor))
              ],
            ),
            onTap: () async {
              final dynamic result = await Navigator.pushNamed(
                  context, RoutePaths.itemSearch,
                  arguments: widget.searchItemProvider.itemParameterHolder);
              if (result != null) {
                widget.searchItemProvider.itemParameterHolder = result;
                widget.searchItemProvider.resetLatestItemList(
                    widget.searchItemProvider.itemParameterHolder);

                if (widget.searchItemProvider.itemParameterHolder
                    .isFiltered()) {
                  isClickBaseLineTune = true;
                } else {
                  isClickBaseLineTune = false;
                }
              }
            },
          ),
          GestureDetector(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                PsIconWithCheck(
                  icon: Icons.sort,
                  color: PsColors.mainColor,
                ),
                Text(Utils.getString(context, 'search__map_filter'),
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                        color: isClickBaseLineTune
                            ? PsColors.mainColor
                            : PsColors.textPrimaryColor))
              ],
            ),
            onTap: () async {
              if (widget.searchItemProvider.itemParameterHolder.lat == '' &&
                  widget.searchItemProvider.itemParameterHolder.lng == '') {
                widget.searchItemProvider.itemParameterHolder.lat =
                    widget.searchItemProvider.psValueHolder.cityLat;
                widget.searchItemProvider.itemParameterHolder.lng =
                    widget.searchItemProvider.psValueHolder.cityLng;
              }
              if(PsConfig.isUseGoogleMap) {
                final dynamic result = await Navigator.pushNamed(
                  context, RoutePaths.googleMapFilter,
                  arguments: widget.searchItemProvider.itemParameterHolder);
                if (result != null && result is ItemParameterHolder) {
                  widget.searchItemProvider.itemParameterHolder = result;
                  if (widget.searchItemProvider.itemParameterHolder.miles !=
                          null &&
                      widget.searchItemProvider.itemParameterHolder.miles != '' &&
                      double.parse(widget
                              .searchItemProvider.itemParameterHolder.miles) <
                          1) {
                    widget.searchItemProvider.itemParameterHolder.miles = '1';
                  } //for 0.5 km, it is less than 1 miles and error
                  widget.searchItemProvider.resetLatestItemList(
                      widget.searchItemProvider.itemParameterHolder);
                }
              } else {
                final dynamic result = await Navigator.pushNamed(
                    context, RoutePaths.mapFilter,
                    arguments: widget.searchItemProvider.itemParameterHolder);
                if (result != null && result is ItemParameterHolder) {
                  widget.searchItemProvider.itemParameterHolder = result;
                  if (widget.searchItemProvider.itemParameterHolder.miles !=
                          null &&
                      widget.searchItemProvider.itemParameterHolder.miles != '' &&
                      double.parse(widget
                              .searchItemProvider.itemParameterHolder.miles) <
                          1) {
                    widget.searchItemProvider.itemParameterHolder.miles = '1';
                  } //for 0.5 km, it is less than 1 miles and error
                  widget.searchItemProvider.resetLatestItemList(
                      widget.searchItemProvider.itemParameterHolder);
                }
              }
            },
          ),
        ],
      ),
    );
  }
}

class PsIconWithCheck extends StatelessWidget {
  const PsIconWithCheck({Key key, this.icon, this.color}) : super(key: key);
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Icon(icon, color: color ?? PsColors.grey);
  }
}
