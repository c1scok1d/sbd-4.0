import 'package:businesslistingapi/config/ps_config.dart';
import 'package:businesslistingapi/provider/blog/city_blog_provider.dart';
import 'package:flutter/material.dart';
import 'package:businesslistingapi/repository/city_blog_repository.dart';
import 'package:businesslistingapi/ui/blog/item/blog_list_item.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:businesslistingapi/constant/ps_dimens.dart';
import 'package:businesslistingapi/constant/route_paths.dart';
import 'package:businesslistingapi/ui/common/ps_ui_widget.dart';

class CityBlogListView extends StatefulWidget {
  const CityBlogListView(
      {Key key, @required this.animationController, @required this.cityId})
      : super(key: key);
  final AnimationController animationController;
  final String cityId;
  @override
  _CityBlogListViewState createState() => _CityBlogListViewState();
}

class _CityBlogListViewState extends State<CityBlogListView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  CityBlogProvider _cityBlogProvider;
  Animation<double> animation;

  @override
  void dispose() {
    animation = null;
    super.dispose();
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _cityBlogProvider.nextCityBlogList(widget.cityId);
      }
    });

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

  CityBlogRepository repo1;
  dynamic data;
  @override
  Widget build(BuildContext context) {
    repo1 = Provider.of<CityBlogRepository>(context);

    if (!isConnectedToInternet && PsConfig.showAdMob) {
      print('loading ads....');
      checkConnection();
    }

    print(
        '............................Build UI Again ............................');
    return ChangeNotifierProvider<CityBlogProvider>(
      lazy: false,
      create: (BuildContext context) {
        final CityBlogProvider provider = CityBlogProvider(repo: repo1);
        provider.loadCityBlogList(widget.cityId);
        _cityBlogProvider = provider;
        return _cityBlogProvider;
      },
      child: Consumer<CityBlogProvider>(
        builder:
            (BuildContext context, CityBlogProvider provider, Widget child) {
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
                  child: Stack(
                children: <Widget>[
                  Container(
                      margin: const EdgeInsets.only(
                          left: PsDimens.space16,
                          right: PsDimens.space16,
                          top: PsDimens.space8,
                          bottom: PsDimens.space8),
                      child: RefreshIndicator(
                        child: CustomScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            controller: _scrollController,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            slivers: <Widget>[
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    if (provider.cityBlogList.data != null ||
                                        provider.cityBlogList.data.isNotEmpty) {
                                      final int count =
                                          provider.cityBlogList.data.length;
                                      return BlogListItem(
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
                                        blog: provider.cityBlogList.data[index],
                                        onTap: () {
                                          print(provider
                                              .cityBlogList
                                              .data[index]
                                              .defaultPhoto
                                              .imgPath);
                                          Navigator.pushNamed(
                                              context, RoutePaths.blogDetail,
                                              arguments: provider
                                                  .cityBlogList.data[index]);
                                        },
                                      );
                                    } else {
                                      return null;
                                    }
                                  },
                                  childCount: provider.cityBlogList.data.length,
                                ),
                              ),
                            ]),
                        onRefresh: () {
                          return provider.resetCityBlogList(widget.cityId);
                        },
                      )),
                  PSProgressIndicator(provider.cityBlogList.status)
                ],
              ))
            ],
          );
        },
      ),
    );
  }
}
