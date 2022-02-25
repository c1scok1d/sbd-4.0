import 'package:businesslistingapi/config/ps_config.dart';
import 'package:businesslistingapi/constant/ps_constants.dart';
import 'package:businesslistingapi/constant/ps_dimens.dart';
import 'package:businesslistingapi/constant/route_paths.dart';
import 'package:businesslistingapi/provider/item/favourite_item_provider.dart';
import 'package:businesslistingapi/repository/item_repository.dart';
import 'package:businesslistingapi/ui/common/ps_ui_widget.dart';
import 'package:businesslistingapi/ui/items/item/item_vertical_list_item.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:businesslistingapi/viewobject/common/ps_value_holder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:businesslistingapi/viewobject/holder/intent_holder/item_detail_intent_holder.dart';
import 'package:businesslistingapi/viewobject/item.dart';
import 'package:provider/provider.dart';

class FavouriteItemListView extends StatefulWidget {
  const FavouriteItemListView({Key key, @required this.animationController})
      : super(key: key);
  final AnimationController animationController;
  @override
  _FavouriteItemListView createState() => _FavouriteItemListView();
}

class _FavouriteItemListView extends State<FavouriteItemListView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  FavouriteItemProvider _favouriteItemProvider;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _favouriteItemProvider.nextFavouriteItemList();
      }
    });

    super.initState();
  }

  ItemRepository itemRepo;
  PsValueHolder psValueHolder;
  dynamic data;
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
    psValueHolder = Provider.of<PsValueHolder>(context);

    if (!isConnectedToInternet && PsConfig.showAdMob) {
      print('loading ads....');
      checkConnection();
    }
    print(
        '............................Build UI Again ............................');
    return ChangeNotifierProvider<FavouriteItemProvider>(
      lazy: false,
      create: (BuildContext context) {
        final FavouriteItemProvider provider =
            FavouriteItemProvider(repo: itemRepo, psValueHolder: psValueHolder);
        provider.loadFavouriteItemList();
        _favouriteItemProvider = provider;
        return _favouriteItemProvider;
      },
      child: Consumer<FavouriteItemProvider>(
        builder: (BuildContext context, FavouriteItemProvider provider,
            Widget child) {
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
                child: Stack(children: <Widget>[
                  Container(
                      margin: const EdgeInsets.only(
                          left: PsDimens.space4,
                          right: PsDimens.space4,
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
                                    if (provider.favouriteItemList.data !=
                                            null ||
                                        provider.favouriteItemList.data
                                            .isNotEmpty) {
                                      final int count = provider
                                          .favouriteItemList.data.length;
                                      return ItemVeticalListItem(
                                        coreTagKey:
                                            provider.hashCode.toString() +
                                                provider.favouriteItemList
                                                    .data[index].id,
                                        animationController:
                                            widget.animationController,
                                        animation:
                                            Tween<double>(begin: 0.0, end: 1.0)
                                                .animate(
                                          CurvedAnimation(
                                            parent: widget.animationController,
                                            curve: Interval(
                                                (1 / count) * index, 1.0,
                                                curve: Curves.fastOutSlowIn),
                                          ),
                                        ),
                                        item: provider
                                            .favouriteItemList.data[index],
                                        onTap: () async {
                                          final Item item = provider
                                              .favouriteItemList.data[index];
                                          final ItemDetailIntentHolder holder =
                                              ItemDetailIntentHolder(
                                            itemId: item.id,
                                            heroTagImage:
                                                provider.hashCode.toString() +
                                                    item.id +
                                                    PsConst.HERO_TAG__IMAGE,
                                            heroTagTitle:
                                                provider.hashCode.toString() +
                                                    item.id +
                                                    PsConst.HERO_TAG__TITLE,
                                            heroTagOriginalPrice: provider
                                                    .hashCode
                                                    .toString() +
                                                item.id +
                                                PsConst
                                                    .HERO_TAG__ORIGINAL_PRICE,
                                            heroTagUnitPrice: provider.hashCode
                                                    .toString() +
                                                item.id +
                                                PsConst.HERO_TAG__UNIT_PRICE,
                                          );

                                          await Navigator.pushNamed(
                                              context, RoutePaths.itemDetail,
                                              arguments: holder);

                                          await provider
                                              .resetFavouriteItemList();
                                        },
                                      );
                                    } else {
                                      return null;
                                    }
                                  },
                                  childCount:
                                      provider.favouriteItemList.data.length,
                                ),
                              ),
                            ]),
                        onRefresh: () {
                          return provider.resetFavouriteItemList();
                        },
                      )),
                  PSProgressIndicator(provider.favouriteItemList.status)
                ]),
              )
            ],
          );
        },
      ),
    );
  }
}
