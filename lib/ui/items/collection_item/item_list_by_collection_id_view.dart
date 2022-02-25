import 'package:businesslistingapi/config/ps_colors.dart';
import 'package:businesslistingapi/config/ps_config.dart';
import 'package:businesslistingapi/constant/ps_dimens.dart';
import 'package:businesslistingapi/constant/route_paths.dart';
import 'package:businesslistingapi/provider/item/item_by_collectionid_provider.dart';
import 'package:businesslistingapi/repository/item_repository.dart';
import 'package:businesslistingapi/ui/common/base/ps_widget_with_multi_provider.dart';
import 'package:businesslistingapi/ui/common/ps_ui_widget.dart';
import 'package:businesslistingapi/ui/items/item/item_vertical_list_item.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:businesslistingapi/viewobject/common/ps_value_holder.dart';
import 'package:businesslistingapi/viewobject/holder/intent_holder/item_detail_intent_holder.dart';
import 'package:businesslistingapi/viewobject/item_collection_header.dart';
import 'package:businesslistingapi/viewobject/item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class ItemListByCollectionIdView extends StatefulWidget {
  const ItemListByCollectionIdView(
      {Key key,
      @required this.itemCollectionHeader,
      @required this.appBarTitle})
      : super(key: key);

  final ItemCollectionHeader itemCollectionHeader;
  final String appBarTitle;
  @override
  State<StatefulWidget> createState() {
    return _ItemListByCollectionIdView();
  }
}

class _ItemListByCollectionIdView extends State<ItemListByCollectionIdView>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  ItemByCollectionIdProvider _itemCollectionProvider;
  AnimationController animationController;
  Animation<double> animation;
  ItemRepository itemCollectionRepository;
  PsValueHolder psValueHolder;

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _itemCollectionProvider
            .nextItemListByCollectionId(widget.itemCollectionHeader.id);
      }
    });

    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
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

    if (!isConnectedToInternet && PsConfig.showAdMob) {
      print('loading ads....');
      checkConnection();
    }
    itemCollectionRepository = Provider.of<ItemRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    return WillPopScope(
      onWillPop: _requestPop,
      child: PsWidgetWithMultiProvider(
        child: MultiProvider(
            providers: <SingleChildWidget>[
              ChangeNotifierProvider<ItemByCollectionIdProvider>(
                  lazy: false,
                  create: (BuildContext context) {
                    _itemCollectionProvider = ItemByCollectionIdProvider(
                        repo: itemCollectionRepository,
                        psValueHolder: psValueHolder);
                    _itemCollectionProvider.loadItemListByCollectionId(
                        widget.itemCollectionHeader.id);
                    return _itemCollectionProvider;
                  }),
            ],
            child: Consumer<ItemByCollectionIdProvider>(builder:
                (BuildContext context, ItemByCollectionIdProvider provider,
                    Widget child) {
              if (provider.itemCollectionList != null &&
                  provider.itemCollectionList.data != null) {
                return Scaffold(
                    appBar: AppBar(
                      systemOverlayStyle: SystemUiOverlayStyle(
                        statusBarIconBrightness: Utils.getBrightnessForAppBar(context),
                      ),
                      backgroundColor: Utils.isLightMode(context)
                          ? PsColors.mainColor
                          : Colors.black12,
                      iconTheme: Theme.of(context)
                          .iconTheme
                          .copyWith(color: PsColors.white),
                      title: Text(
                        widget.appBarTitle,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(fontWeight: FontWeight.bold)
                            .copyWith(color: PsColors.white),
                      ),
                      titleSpacing: 0,
                      elevation: 0,
                      toolbarTextStyle:  TextStyle(color: PsColors.textPrimaryColor),
                    ),
                    body: Column(
                      children: <Widget>[
                        // const PsAdMobBannerWidget(),
                        // Visibility(
                        //   visible: PsConfig.showAdMob &&
                        //       isSuccessfullyLoaded &&
                        //       isConnectedToInternet,
                        //   child: AdmobBanner(
                        //     adUnitId: Utils.getBannerAdUnitId(),
                        //     adSize: AdmobBannerSize.FULL_BANNER,
                        //     listener:
                        //         (AdmobAdEvent event, Map<String, dynamic> map) {
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
                          child: Stack(
                            children: <Widget>[
                              Container(
                                  color: PsColors.baseColor,
                                  margin: const EdgeInsets.only(
                                      left: PsDimens.space4,
                                      right: PsDimens.space4,
                                      top: PsDimens.space4,
                                      bottom: PsDimens.space4),
                                  child: RefreshIndicator(
                                    child: CustomScrollView(
                                      controller: _scrollController,
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      slivers: <Widget>[
                                        SliverToBoxAdapter(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: PsDimens.space8),
                                            child: PsNetworkImage(
                                              photoKey: '',
                                              defaultPhoto: widget
                                                  .itemCollectionHeader
                                                  .defaultPhoto,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: PsDimens.space240,
                                            ),
                                          ),
                                        ),
                                        SliverGrid(
                                          gridDelegate:
                                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                                  maxCrossAxisExtent: 300,
                                                  childAspectRatio: 0.6),
                                          delegate: SliverChildBuilderDelegate(
                                            (BuildContext context, int index) {
                                              if (provider.itemCollectionList
                                                      .data !=
                                                  null) {
                                                final int count = provider
                                                    .itemCollectionList
                                                    .data
                                                    .length;
                                                return ItemVeticalListItem(
                                                  coreTagKey: '',
                                                  animationController:
                                                      animationController,
                                                  animation: Tween<double>(
                                                          begin: 0.0, end: 1.0)
                                                      .animate(
                                                    CurvedAnimation(
                                                      parent:
                                                          animationController,
                                                      curve: Interval(
                                                          (1 / count) * index,
                                                          1.0,
                                                          curve: Curves
                                                              .fastOutSlowIn),
                                                    ),
                                                  ),
                                                  item: provider
                                                      .itemCollectionList
                                                      .data[index],
                                                  onTap: () {
                                                    final Item item = provider
                                                        .itemCollectionList
                                                        .data[index];
                                                    final ItemDetailIntentHolder
                                                        holder =
                                                        ItemDetailIntentHolder(
                                                      itemId: item.id,
                                                      heroTagImage: '',
                                                      heroTagTitle: '',
                                                      heroTagOriginalPrice: '',
                                                      heroTagUnitPrice: '',
                                                    );

                                                    Navigator.pushNamed(context,
                                                        RoutePaths.itemDetail,
                                                        arguments: holder);
                                                  },
                                                );
                                              } else {
                                                return null;
                                              }
                                            },
                                            childCount: provider
                                                .itemCollectionList.data.length,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onRefresh: () {
                                      return provider
                                          .resetItemListByCollectionId(
                                              widget.itemCollectionHeader.id);
                                    },
                                  )),
                              PSProgressIndicator(
                                  provider.itemCollectionList.status)
                            ],
                          ),
                        ),
                      ],
                    ));
              } else {
                return Container();
              }
            })),
      ),
    );
  }
}
