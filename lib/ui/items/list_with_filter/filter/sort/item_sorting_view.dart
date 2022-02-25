// import 'package:admob_flutter/admob_flutter.dart';
// import 'package:admob_flutter/admob_flutter.dart';
import 'package:businesslistingapi/config/ps_colors.dart';
import 'package:businesslistingapi/config/ps_config.dart';
import 'package:businesslistingapi/constant/ps_constants.dart';
import 'package:businesslistingapi/constant/ps_dimens.dart';
import 'package:businesslistingapi/provider/item/search_item_provider.dart';
import 'package:businesslistingapi/repository/item_repository.dart';
import 'package:businesslistingapi/ui/common/base/ps_widget_with_appbar.dart';
// import 'package:businesslistingapi/ui/common/ps_admob_banner_widget.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:businesslistingapi/viewobject/holder/item_parameter_holder.dart';
import 'package:provider/provider.dart';

class ItemSortingView extends StatefulWidget {
  const ItemSortingView({@required this.itemParameterHolder});

  final ItemParameterHolder itemParameterHolder;

  @override
  _ItemSortingViewState createState() => _ItemSortingViewState();
}

class _ItemSortingViewState extends State<ItemSortingView> {
  ItemRepository itemRepo;
  SearchItemProvider _searchItemProvider;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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
    itemRepo = Provider.of<ItemRepository>(context);

    if (!isConnectedToInternet && PsConfig.showAdMob) {
      print('loading ads....');
      checkConnection();
    }

    return PsWidgetWithAppBar<SearchItemProvider>(
      appBarTitle: Utils.getString(context, 'search__map_filter') ?? '',
      initProvider: () {
        return SearchItemProvider(repo: itemRepo);
      },
      onProviderReady: (SearchItemProvider provider) {
        _searchItemProvider = provider;
        _searchItemProvider.itemParameterHolder = widget.itemParameterHolder;
      },
      builder:
          (BuildContext context, SearchItemProvider provider, Widget child) {
        return Column(
          children: <Widget>[
            GestureDetector(
              child: SortingView(
                  image: 'assets/images/baesline_access_time_black_24.png',
                  titleText: Utils.getString(context, 'item_filter__latest'),
                  checkImage: _searchItemProvider.itemParameterHolder.orderBy ==
                          PsConst.FILTERING__ADDED_DATE
                      ? 'assets/images/baseline_check_green_24.png'
                      : ''),
              onTap: () {
                print('sort by latest item');
                setState(() {
                  _searchItemProvider.itemParameterHolder.isLatest = '1';
                  _searchItemProvider.itemParameterHolder.isAtoZ = '0';
                  _searchItemProvider.itemParameterHolder.isZtoA = '0';
                  _searchItemProvider.itemParameterHolder.isPopular = '0';

                  _searchItemProvider.itemParameterHolder.orderBy =
                      PsConst.FILTERING__ADDED_DATE;
                  _searchItemProvider.itemParameterHolder.orderType =
                      PsConst.FILTERING__DESC;
                });
              },
            ),
            GestureDetector(
              child: SortingView(
                  image: 'assets/images/baseline_graph_black_24.png',
                  titleText: Utils.getString(context, 'item_filter__popular'),
                  checkImage: _searchItemProvider.itemParameterHolder.orderBy ==
                          PsConst.FILTERING__TRENDING
                      ? 'assets/images/baseline_check_green_24.png'
                      : ''),
              onTap: () {
                print('sort by popular item');
                setState(() {
                  _searchItemProvider.itemParameterHolder.isPopular = '1';
                  _searchItemProvider.itemParameterHolder.isAtoZ = '0';
                  _searchItemProvider.itemParameterHolder.isZtoA = '0';
                  _searchItemProvider.itemParameterHolder.isLatest = '0';

                  _searchItemProvider.itemParameterHolder.orderBy =
                      PsConst.FILTERING__TRENDING;
                  _searchItemProvider.itemParameterHolder.orderType =
                      PsConst.FILTERING__DESC;
                });
              },
            ),
            GestureDetector(
              child: SortingView(
                  image: 'assets/images/baseline_price_down_black_24.png',
                  titleText: Utils.getString(context, 'item_filter__atoz'),
                  checkImage: _searchItemProvider.itemParameterHolder.orderBy ==
                              PsConst.FILTERING_PRICE &&
                          _searchItemProvider.itemParameterHolder.orderType ==
                              PsConst.FILTERING__ASC
                      ? 'assets/images/baseline_check_green_24.png'
                      : ''),
              onTap: () {
                print('sort by lowest price');
                setState(() {
                  _searchItemProvider.itemParameterHolder.orderBy = '';
                  _searchItemProvider.itemParameterHolder.isAtoZ = '1';
                  _searchItemProvider.itemParameterHolder.isZtoA = '0';
                  _searchItemProvider.itemParameterHolder.isPopular = '0';
                  _searchItemProvider.itemParameterHolder.isLatest = '0';
                  _searchItemProvider.itemParameterHolder.orderType =
                      PsConst.FILTERING__ASC;
                });
              },
            ),
            GestureDetector(
              child: SortingView(
                  image: 'assets/images/baseline_price_up_black_24.png',
                  titleText: Utils.getString(context, 'item_filter__ztoa'),
                  checkImage: _searchItemProvider.itemParameterHolder.orderBy ==
                              PsConst.FILTERING_PRICE &&
                          _searchItemProvider.itemParameterHolder.orderType ==
                              PsConst.FILTERING__DESC
                      ? 'assets/images/baseline_check_green_24.png'
                      : ''),
              onTap: () {
                print('sort by highest price ');
                setState(() {
                  _searchItemProvider.itemParameterHolder.orderBy = '';
                  _searchItemProvider.itemParameterHolder.isZtoA = '1';
                  _searchItemProvider.itemParameterHolder.isAtoZ = '0';
                  _searchItemProvider.itemParameterHolder.isPopular = '0';
                  _searchItemProvider.itemParameterHolder.isLatest = '0';
                  _searchItemProvider.itemParameterHolder.orderType =
                      PsConst.FILTERING__DESC;
                });
                // Navigator.pop(context, _searchItemProvider.itemParameterHolder);
              },
            ),
            const Divider(
              height: PsDimens.space1,
            ),
            const SizedBox(
              height: PsDimens.space8,
            ),
            // const PsAdMobBannerWidget(
            //   admobBannerSize: AdmobBannerSize.MEDIUM_RECTANGLE,
            // ),
            // Visibility(
            //   visible: PsConfig.showAdMob &&
            //       isSuccessfullyLoaded &&
            //       isConnectedToInternet,
            //   child: AdmobBanner(
            //     adUnitId: Utils.getBannerAdUnitId(),
            //     adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
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
          ],
        );
      },
    );
  }
}

class SortingView extends StatefulWidget {
  const SortingView(
      {@required this.image,
      @required this.titleText,
      @required this.checkImage});

  final String titleText;
  final String image;
  final String checkImage;

  @override
  State<StatefulWidget> createState() => _SortingViewState();
}

class _SortingViewState extends State<SortingView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: PsColors.backgroundColor,
      width: MediaQuery.of(context).size.width,
      height: PsDimens.space60,
      margin: const EdgeInsets.only(top: PsDimens.space4),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(PsDimens.space16),
                child: Image.asset(
                  widget.image,
                  color: Theme.of(context).iconTheme.color,
                  width: PsDimens.space24,
                  height: PsDimens.space24,
                ),
              ),
              const SizedBox(
                width: PsDimens.space10,
              ),
              Text(widget.titleText,
                  style: Theme.of(context).textTheme.subtitle2),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
                right: PsDimens.space20, left: PsDimens.space20),
            child: Image.asset(
              widget.checkImage,
              width: PsDimens.space20,
              height: PsDimens.space20,
            ),
          ),
        ],
      ),
    );
  }
}
