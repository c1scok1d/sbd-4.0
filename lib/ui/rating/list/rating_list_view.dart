import 'package:businesslistingapi/config/ps_colors.dart';
import 'package:businesslistingapi/config/ps_config.dart';
import 'package:businesslistingapi/constant/ps_dimens.dart';
import 'package:businesslistingapi/constant/route_paths.dart';
import 'package:businesslistingapi/provider/item/item_provider.dart';
import 'package:businesslistingapi/provider/rating/rating_provider.dart';
import 'package:businesslistingapi/repository/item_repository.dart';
import 'package:businesslistingapi/repository/rating_repository.dart';
import 'package:businesslistingapi/ui/common/base/ps_widget_with_appbar_with_two_provider.dart';
import 'package:businesslistingapi/ui/common/dialog/error_dialog.dart';
import 'package:businesslistingapi/ui/common/dialog/info_dialog.dart';
// import 'package:businesslistingapi/ui/common/ps_admob_banner_widget.dart';
import 'package:businesslistingapi/ui/common/ps_button_widget.dart';
import 'package:businesslistingapi/ui/common/smooth_star_rating_widget.dart';
import 'package:businesslistingapi/ui/rating/entry/rating_input_dialog.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:businesslistingapi/viewobject/common/ps_value_holder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../item/rating_list_item.dart';

class RatingListView extends StatefulWidget {
  const RatingListView({
    Key key,
    @required this.itemDetailid,
  }) : super(key: key);

  final String itemDetailid;
  @override
  _RatingListViewState createState() => _RatingListViewState();
}

class _RatingListViewState extends State<RatingListView>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  RatingRepository ratingRepo;
  RatingProvider ratingProvider;
  ItemDetailProvider itemDetailProvider;
  ItemRepository itemRepository;
  PsValueHolder psValueHolder;

  @override
  void initState() {
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

    ratingRepo = Provider.of<RatingRepository>(context);
    itemRepository = Provider.of<ItemRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);
    return WillPopScope(
        onWillPop: _requestPop,
        child: PsWidgetWithAppBarWithTwoProvider<RatingProvider,
                ItemDetailProvider>(
            appBarTitle: Utils.getString(context, 'rating_list__title') ?? '',
            actions: <Widget>[
              IconButton(
                icon: const Icon(
                  Icons.border_color,
                ),
                onPressed: () async {
                  if (await Utils.checkInternetConnectivity()) {
                    Utils.navigateOnUserVerificationView(context, () async {
                      await showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return RatingInputDialog(
                              itemprovider: itemDetailProvider,
                              checkType: false,
                            );
                          });

                      ratingProvider.refreshRatingList(widget.itemDetailid);

                      await itemDetailProvider.loadItem(widget.itemDetailid,
                          itemDetailProvider.psValueHolder.loginUserId);
                    });
                  } else {
                    showDialog<dynamic>(
                        context: context,
                        builder: (BuildContext context) {
                          return ErrorDialog(
                            message: Utils.getString(
                                context, 'error_dialog__no_internet'),
                          );
                        });
                  }
                },
              ),
            ],
            initProvider1: () {
              ratingProvider = RatingProvider(repo: ratingRepo);
              return ratingProvider;
            },
            onProviderReady1: (RatingProvider provider) {
              provider.loadRatingList(widget.itemDetailid);
            },
            initProvider2: () {
              itemDetailProvider = ItemDetailProvider(
                  repo: itemRepository, psValueHolder: psValueHolder);
              return itemDetailProvider;
            },
            onProviderReady2: (ItemDetailProvider itemDetailProvider) {
              itemDetailProvider.loadItem(
                  widget.itemDetailid, psValueHolder.loginUserId);
            },
            child: Consumer<RatingProvider>(builder: (BuildContext context,
                RatingProvider ratingProvider, Widget child) {
              return Container(
                color: PsColors.coreBackgroundColor,
                child: RefreshIndicator(
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: <Widget>[
                      // const SliverToBoxAdapter(
                      //   child: PsAdMobBannerWidget(),
                      // ),
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
                      HeaderWidget(
                          itemDetailId: widget.itemDetailid,
                          ratingProvider: ratingProvider),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return RatingListItem(
                              rating: ratingProvider.ratingList.data[index],
                              onTap: () {},
                            );
                          },
                          childCount: ratingProvider.ratingList.data.length,
                        ),
                      )
                    ],
                  ),
                  onRefresh: () {
                    return ratingProvider.resetRatingList(widget.itemDetailid);
                  },
                ),
              );
            })));
  }
}

class HeaderWidget extends StatefulWidget {
  const HeaderWidget(
      {Key key, @required this.itemDetailId, @required this.ratingProvider})
      : super(key: key);
  final String itemDetailId;
  final RatingProvider ratingProvider;

  @override
  _HeaderWidgetState createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  ItemRepository repo;
  PsValueHolder psValueHolder;

  @override
  Widget build(BuildContext context) {
    repo = Provider.of<ItemRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    const Widget _spacingWidget = SizedBox(
      height: PsDimens.space10,
    );
    return SliverToBoxAdapter(
      child: Consumer<ItemDetailProvider>(builder: (BuildContext context,
          ItemDetailProvider itemDetailProvider, Widget child) {
        if (itemDetailProvider.itemDetail != null &&
            itemDetailProvider.itemDetail.data != null &&
            itemDetailProvider.itemDetail.data.ratingDetail != null) {
          return Container(
            color: PsColors.backgroundColor,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: PsDimens.space12,
                  right: PsDimens.space12,
                  bottom: PsDimens.space8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _spacingWidget,
                  Text(
                      '${itemDetailProvider.itemDetail.data.ratingDetail.totalRatingCount} ${Utils.getString(context, 'rating_list__customer_reviews')}'),
                  const SizedBox(
                    height: PsDimens.space4,
                  ),
                  Row(
                    children: <Widget>[
                      SmoothStarRating(
                          key: Key(itemDetailProvider
                              .itemDetail.data.ratingDetail.totalRatingValue),
                          rating: double.parse(itemDetailProvider
                              .itemDetail.data.ratingDetail.totalRatingValue),
                          allowHalfRating: false,
                          starCount: 5,
                          size: PsDimens.space16,
                          color: PsColors.ratingColor,
                          borderColor: Utils.isLightMode(context)
                              ? PsColors.black.withAlpha(100)
                              : PsColors.white,
                          spacing: 0.0),
                      const SizedBox(
                        width: PsDimens.space100,
                      ),
                      Text(
                          '${itemDetailProvider.itemDetail.data.ratingDetail.totalRatingValue} ${Utils.getString(context, 'rating_list__out_of_five_stars')}'),
                    ],
                  ),
                  _RatingWidget(
                      starCount:
                          Utils.getString(context, 'rating_list__five_star'),
                      value: double.parse(itemDetailProvider
                          .itemDetail.data.ratingDetail.fiveStarCount),
                      percentage:
                          '${itemDetailProvider.itemDetail.data.ratingDetail.fiveStarPercent} ${Utils.getString(context, 'rating_list__percent')}'),
                  _RatingWidget(
                      starCount:
                          Utils.getString(context, 'rating_list__four_star'),
                      value: double.parse(itemDetailProvider
                          .itemDetail.data.ratingDetail.fourStarCount),
                      percentage:
                          '${itemDetailProvider.itemDetail.data.ratingDetail.fourStarPercent} ${Utils.getString(context, 'rating_list__percent')}'),
                  _RatingWidget(
                      starCount:
                          Utils.getString(context, 'rating_list__three_star'),
                      value: double.parse(itemDetailProvider
                          .itemDetail.data.ratingDetail.threeStarCount),
                      percentage:
                          '${itemDetailProvider.itemDetail.data.ratingDetail.threeStarPercent} ${Utils.getString(context, 'rating_list__percent')}'),
                  _RatingWidget(
                      starCount:
                          Utils.getString(context, 'rating_list__two_star'),
                      value: double.parse(itemDetailProvider
                          .itemDetail.data.ratingDetail.twoStarCount),
                      percentage:
                          '${itemDetailProvider.itemDetail.data.ratingDetail.twoStarPercent} ${Utils.getString(context, 'rating_list__percent')}'),
                  _RatingWidget(
                      starCount:
                          Utils.getString(context, 'rating_list__one_star'),
                      value: double.parse(itemDetailProvider
                          .itemDetail.data.ratingDetail.oneStarCount),
                      percentage:
                          '${itemDetailProvider.itemDetail.data.ratingDetail.oneStarPercent} ${Utils.getString(context, 'rating_list__percent')}'),
                  _spacingWidget,
                  const Divider(
                    height: PsDimens.space1,
                  ),
                  _WriteReviewButtonWidget(
                    itemprovider: itemDetailProvider,
                    ratingProvider: widget.ratingProvider,
                    itemId: widget.itemDetailId,
                  ),
                  const SizedBox(
                    height: PsDimens.space12,
                  ),
                ],
              ),
            ),
          );
        } else {
          return Container();
        }
      }),
    );
  }
}

class _RatingWidget extends StatelessWidget {
  const _RatingWidget({
    Key key,
    @required this.starCount,
    @required this.value,
    @required this.percentage,
  }) : super(key: key);

  final String starCount;
  final double value;
  final String percentage;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: PsDimens.space4),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(
            starCount,
            style: Theme.of(context).textTheme.subtitle2,
          ),
          const SizedBox(
            width: PsDimens.space12,
          ),
          Expanded(
            flex: 5,
            child: LinearProgressIndicator(
              value: value,
            ),
          ),
          const SizedBox(
            width: PsDimens.space12,
          ),
          Container(
            width: PsDimens.space68,
            child: Text(
              percentage,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
        ],
      ),
    );
  }
}

class _WriteReviewButtonWidget extends StatelessWidget {
  const _WriteReviewButtonWidget({
    Key key,
    @required this.itemprovider,
    @required this.ratingProvider,
    @required this.itemId,
  }) : super(key: key);

  final ItemDetailProvider itemprovider;
  final RatingProvider ratingProvider;
  final String itemId;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: PsDimens.space10),
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        width: double.infinity,
        height: PsDimens.space36,
        child: PSButtonWidget(
          hasShadow: true,
          width: double.infinity,
          titleText: Utils.getString(context, 'rating_list__write_review'),
          onPressed: () async {
            if (itemprovider.psValueHolder.loginUserId == null) {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return InfoDialog(
                      message: Utils.getString(
                        context,
                        Utils.getString(context, 'comment__login_first'),
                      ),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          RoutePaths.login_container,
                        );
                      },
                    );
                  });
            } else {
              if (await Utils.checkInternetConnectivity()) {
                Utils.navigateOnUserVerificationView(context, () async {
                  await showDialog<dynamic>(
                      context: context,
                      builder: (BuildContext context) {
                        return RatingInputDialog(
                          itemprovider: itemprovider,
                          checkType: false,
                        );
                      });

                  ratingProvider.refreshRatingList(itemId);
                  await itemprovider.loadItem(
                      itemId, itemprovider.psValueHolder.loginUserId);
                });
              } else {
                showDialog<dynamic>(
                    context: context,
                    builder: (BuildContext context) {
                      return ErrorDialog(
                        message: Utils.getString(
                            context, 'error_dialog__no_internet'),
                      );
                    });
              }
            }
          },
        ),
      ),
    );
  }
}
