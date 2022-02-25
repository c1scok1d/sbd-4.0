import 'package:businesslistingapi/config/ps_colors.dart';
import 'package:businesslistingapi/config/ps_config.dart';
import 'package:businesslistingapi/constant/ps_constants.dart';
import 'package:businesslistingapi/constant/ps_dimens.dart';
import 'package:businesslistingapi/constant/route_paths.dart';
import 'package:businesslistingapi/provider/item/search_item_provider.dart';
import 'package:businesslistingapi/repository/item_repository.dart';
import 'package:businesslistingapi/ui/common/ps_button_widget.dart';
import 'package:businesslistingapi/ui/common/ps_advance_filtering_widget.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:businesslistingapi/viewobject/holder/intent_holder/item_list_intent_holder.dart';
import 'package:businesslistingapi/viewobject/holder/item_parameter_holder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:businesslistingapi/ui/common/ps_textfield_widget.dart';

class HomeItemSearchView extends StatefulWidget {
  const HomeItemSearchView({
    @required this.itemParameterHolder,
    @required this.animation,
    @required this.animationController,
  });

  final ItemParameterHolder itemParameterHolder;
  final AnimationController animationController;
  final Animation<double> animation;

  @override
  _ItemSearchViewState createState() => _ItemSearchViewState();
}

class _ItemSearchViewState extends State<HomeItemSearchView> {
  ItemRepository repo1;
  SearchItemProvider _searchItemProvider;

  final TextEditingController userInputItemNameTextEditingController =
      TextEditingController();
  final TextEditingController userInputMaximunPriceEditingController =
      TextEditingController();
  final TextEditingController userInputMinimumPriceEditingController =
      TextEditingController();

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
    print(
        '............................Build UI Again ............................');

    final Widget _searchButtonWidget = PSButtonWidget(
        hasShadow: true,
        width: double.infinity,
        titleText: Utils.getString(context, 'home_search__search'),
        onPressed: () async {
          if (userInputItemNameTextEditingController.text != null &&
              userInputItemNameTextEditingController.text != '') {
            _searchItemProvider.itemParameterHolder.keyword =
                userInputItemNameTextEditingController.text;
          } else {
            _searchItemProvider.itemParameterHolder.keyword = '';
          }
          // if (userInputMaximunPriceEditingController.text != null) {
          //   _searchItemProvider.itemParameterHolder.maxPrice =
          //       userInputMaximunPriceEditingController.text;
          // } else {
          //   _searchItemProvider.itemParameterHolder.maxPrice = '';
          // }
          // if (userInputMinimumPriceEditingController.text != null) {
          //   _searchItemProvider.itemParameterHolder.minPrice =
          //       userInputMinimumPriceEditingController.text;
          // } else {
          //   _searchItemProvider.itemParameterHolder.minPrice = '';
          // }
          if (_searchItemProvider.isfirstRatingClicked) {
            _searchItemProvider.itemParameterHolder.ratingValue =
                PsConst.RATING_ONE;
          }

          if (_searchItemProvider.isSecondRatingClicked) {
            _searchItemProvider.itemParameterHolder.ratingValue =
                PsConst.RATING_TWO;
          }

          if (_searchItemProvider.isThirdRatingClicked) {
            _searchItemProvider.itemParameterHolder.ratingValue =
                PsConst.RATING_THREE;
          }

          if (_searchItemProvider.isfouthRatingClicked) {
            _searchItemProvider.itemParameterHolder.ratingValue =
                PsConst.RATING_FOUR;
          }

          if (_searchItemProvider.isFifthRatingClicked) {
            _searchItemProvider.itemParameterHolder.ratingValue =
                PsConst.RATING_FIVE;
          }

          if (_searchItemProvider.isSwitchedFeaturedItem) {
            _searchItemProvider.itemParameterHolder.isFeatured =
                PsConst.IS_FEATURED;
          } else {
            _searchItemProvider.itemParameterHolder.isFeatured = PsConst.ZERO;
          }
          if (_searchItemProvider.isSwitchedDiscountPrice) {
            _searchItemProvider.itemParameterHolder.isPromotion =
                PsConst.IS_PROMOTION;
          } else {
            _searchItemProvider.itemParameterHolder.isPromotion = PsConst.ZERO;
          }
          if (_searchItemProvider.categoryId != null) {
            _searchItemProvider.itemParameterHolder.catId =
                _searchItemProvider.categoryId;
          }
          if (_searchItemProvider.subCategoryId != null) {
            _searchItemProvider.itemParameterHolder.subCatId =
                _searchItemProvider.subCategoryId;
          }
          print('userInputText' + userInputItemNameTextEditingController.text);
          final dynamic result =
              await Navigator.pushNamed(context, RoutePaths.filterItemList,
                  arguments: ItemListIntentHolder(
                    checkPage: '1',
                    appBarTitle:
                        Utils.getString(context, 'home_search__app_bar_title'),
                    itemParameterHolder:
                        _searchItemProvider.itemParameterHolder,
                  ));
          if (result != null && result is ItemParameterHolder) {
            _searchItemProvider.itemParameterHolder = result;
          }
        });

    repo1 = Provider.of<ItemRepository>(context);
    return SliverToBoxAdapter(
        child: ChangeNotifierProvider<SearchItemProvider>(
            lazy: false,
            create: (BuildContext content) {
              _searchItemProvider = SearchItemProvider(repo: repo1);
              _searchItemProvider.itemParameterHolder =
                  widget.itemParameterHolder;
              _searchItemProvider
                  .loadItemListByKey(_searchItemProvider.itemParameterHolder);

              return _searchItemProvider;
            },
            child: Consumer<SearchItemProvider>(
              builder: (BuildContext context, SearchItemProvider provider,
                  Widget child) {
                if (_searchItemProvider.itemList != null &&
                    _searchItemProvider.itemList.data != null) {
                  widget.animationController.forward();
                  return SingleChildScrollView(
                    child: AnimatedBuilder(
                        animation: widget.animationController,
                        child: Container(
                          color: PsColors.baseColor,
                          child: Column(
                            children: <Widget>[
                              // const PsAdMobBannerWidget(),
                              // Visibility(
                              //   visible: PsConfig.showAdMob &&
                              //       isSuccessfullyLoaded &&
                              //       isConnectedToInternet,
                              //   child: AdmobBanner(
                              //     adUnitId: Utils.getBannerAdUnitId(),
                              //     adSize: AdmobBannerSize.FULL_BANNER,
                              //     listener: (AdmobAdEvent event,
                              //         Map<String, dynamic> map) {
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
                              _SortingWidget(
                                searchItemProvider: provider,
                              ),
                              _ItemNameWidget(
                                userInputItemNameTextEditingController:
                                    userInputItemNameTextEditingController,
                              ),

                              _RatingRangeWidget(),
                              _SpecialCheckWidget(),
                              Container(
                                  margin: const EdgeInsets.only(
                                      left: PsDimens.space16,
                                      top: PsDimens.space16,
                                      right: PsDimens.space16,
                                      bottom: PsDimens.space40),
                                  child: _searchButtonWidget),
                            ],
                          ),
                        ),
                        builder: (BuildContext context, Widget child) {
                          return FadeTransition(
                              opacity: widget.animation,
                              child: Transform(
                                transform: Matrix4.translationValues(0.0,
                                    100 * (1.0 - widget.animation.value), 0.0),
                                child: child,
                              ));
                        }),
                  );
                } else {
                  return Container();
                }
              },
            )));
  }
}

class _ItemNameWidget extends StatefulWidget {
  const _ItemNameWidget({this.userInputItemNameTextEditingController});

  final TextEditingController userInputItemNameTextEditingController;

  @override
  __ItemNameWidgetState createState() => __ItemNameWidgetState();
}

class __ItemNameWidgetState extends State<_ItemNameWidget> {
  @override
  Widget build(BuildContext context) {
    print('*****' + widget.userInputItemNameTextEditingController.text);
    return Column(
      children: <Widget>[
        PsTextFieldWidget(
            titleText: Utils.getString(context, 'home_search__set_item_name'),
            hintText: Utils.getString(context, 'home_search__not_set'),
            textEditingController:
                widget.userInputItemNameTextEditingController),
      ],
    );
  }
}

class _ChangeRatingColor extends StatelessWidget {
  const _ChangeRatingColor({
    Key key,
    @required this.title,
    @required this.checkColor,
  }) : super(key: key);

  final String title;
  final bool checkColor;

  @override
  Widget build(BuildContext context) {
    final Color defaultBackgroundColor = PsColors.backgroundColor;
    return Container(
      width: MediaQuery.of(context).size.width / 5.5,
      height: PsDimens.space104,
      decoration: BoxDecoration(
        color: checkColor ? defaultBackgroundColor : PsColors.mainColor,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Icon(
              Icons.star,
              color: checkColor ? PsColors.iconColor : PsColors.white,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.caption.copyWith(
                    color: checkColor ? PsColors.iconColor : PsColors.white,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RatingRangeWidget extends StatefulWidget {
  @override
  __RatingRangeWidgetState createState() => __RatingRangeWidgetState();
}

class __RatingRangeWidgetState extends State<_RatingRangeWidget> {
  @override
  Widget build(BuildContext context) {
    final SearchItemProvider provider =
        Provider.of<SearchItemProvider>(context);

    dynamic _firstRatingRangeSelected() {
      if (!provider.isfirstRatingClicked) {
        return _ChangeRatingColor(
          title: Utils.getString(context, 'home_search__one_and_higher'),
          checkColor: true,
        );
      } else {
        return _ChangeRatingColor(
          title: Utils.getString(context, 'home_search__one_and_higher'),
          checkColor: false,
        );
      }
    }

    dynamic _secondRatingRangeSelected() {
      if (!provider.isSecondRatingClicked) {
        return _ChangeRatingColor(
          title: Utils.getString(context, 'home_search__two_and_higher'),
          checkColor: true,
        );
      } else {
        return _ChangeRatingColor(
          title: Utils.getString(context, 'home_search__two_and_higher'),
          checkColor: false,
        );
      }
    }

    dynamic _thirdRatingRangeSelected() {
      if (!provider.isThirdRatingClicked) {
        return _ChangeRatingColor(
          title: Utils.getString(context, 'home_search__three_and_higher'),
          checkColor: true,
        );
      } else {
        return _ChangeRatingColor(
          title: Utils.getString(context, 'home_search__three_and_higher'),
          checkColor: false,
        );
      }
    }

    dynamic _fouthRatingRangeSelected() {
      if (!provider.isfouthRatingClicked) {
        return _ChangeRatingColor(
          title: Utils.getString(context, 'home_search__four_and_higher'),
          checkColor: true,
        );
      } else {
        return _ChangeRatingColor(
          title: Utils.getString(context, 'home_search__four_and_higher'),
          checkColor: false,
        );
      }
    }

    dynamic _fifthRatingRangeSelected() {
      if (!provider.isFifthRatingClicked) {
        return _ChangeRatingColor(
          title: Utils.getString(context, 'home_search__five'),
          checkColor: true,
        );
      } else {
        return _ChangeRatingColor(
          title: Utils.getString(context, 'home_search__five'),
          checkColor: false,
        );
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(PsDimens.space12),
          child: Row(
            children: <Widget>[
              Text(Utils.getString(context, 'home_search__rating_range'),
                  style: Theme.of(context).textTheme.bodyText1),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width / 5.5,
              decoration: const BoxDecoration(),
              child: InkWell(
                onTap: () {
                  if (!provider.isfirstRatingClicked) {
                    provider.isfirstRatingClicked = true;
                    provider.isSecondRatingClicked = false;
                    provider.isThirdRatingClicked = false;
                    provider.isfouthRatingClicked = false;
                    provider.isFifthRatingClicked = false;
                  } else {
                    setAllRatingFalse(provider);
                  }

                  setState(() {});
                },
                child: _firstRatingRangeSelected(),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(PsDimens.space4),
              width: MediaQuery.of(context).size.width / 5.5,
              decoration: const BoxDecoration(),
              child: InkWell(
                onTap: () {
                  if (!provider.isSecondRatingClicked) {
                    provider.isfirstRatingClicked = false;
                    provider.isSecondRatingClicked = true;
                    provider.isThirdRatingClicked = false;
                    provider.isfouthRatingClicked = false;
                    provider.isFifthRatingClicked = false;
                  } else {
                    setAllRatingFalse(provider);
                  }

                  setState(() {});
                },
                child: _secondRatingRangeSelected(),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 5.5,
              decoration: const BoxDecoration(),
              child: InkWell(
                onTap: () {
                  if (!provider.isThirdRatingClicked) {
                    provider.isfirstRatingClicked = false;
                    provider.isSecondRatingClicked = false;
                    provider.isThirdRatingClicked = true;
                    provider.isfouthRatingClicked = false;
                    provider.isFifthRatingClicked = false;
                  } else {
                    setAllRatingFalse(provider);
                  }

                  setState(() {});
                },
                child: _thirdRatingRangeSelected(),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(PsDimens.space4),
              width: MediaQuery.of(context).size.width / 5.5,
              decoration: const BoxDecoration(),
              child: InkWell(
                onTap: () {
                  if (!provider.isfouthRatingClicked) {
                    provider.isfirstRatingClicked = false;
                    provider.isSecondRatingClicked = false;
                    provider.isThirdRatingClicked = false;
                    provider.isfouthRatingClicked = true;
                    provider.isFifthRatingClicked = false;
                  } else {
                    setAllRatingFalse(provider);
                  }

                  setState(() {});
                },
                child: _fouthRatingRangeSelected(),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 5.5,
              child: InkWell(
                onTap: () {
                  if (!provider.isFifthRatingClicked) {
                    provider.isfirstRatingClicked = false;
                    provider.isSecondRatingClicked = false;
                    provider.isThirdRatingClicked = false;
                    provider.isfouthRatingClicked = false;
                    provider.isFifthRatingClicked = true;
                  } else {
                    setAllRatingFalse(provider);
                  }

                  setState(() {});
                },
                child: _fifthRatingRangeSelected(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

dynamic setAllRatingFalse(SearchItemProvider provider) {
  provider.isfirstRatingClicked = false;
  provider.isSecondRatingClicked = false;
  provider.isThirdRatingClicked = false;
  provider.isfouthRatingClicked = false;
  provider.isFifthRatingClicked = false;
}

class _SortingWidget extends StatefulWidget {
  const _SortingWidget({@required this.searchItemProvider});
  final SearchItemProvider searchItemProvider;

  @override
  __SortingWidgetState createState() => __SortingWidgetState();
}

class __SortingWidgetState extends State<_SortingWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          margin: const EdgeInsets.all(PsDimens.space12),
          child: Text(Utils.getString(context, 'home_search__sorting'),
              style: Theme.of(context).textTheme.headline6),
        ),
        GestureDetector(
          child: SortingView(
              image: 'assets/images/baesline_access_time_black_24.png',
              titleText: Utils.getString(context, 'item_filter__latest'),
              checkImage:
                  widget.searchItemProvider.itemParameterHolder.orderBy ==
                          PsConst.FILTERING__ADDED_DATE
                      ? 'assets/images/baseline_check_green_24.png'
                      : ''),
          onTap: () {
            print('sort by latest item');

            setState(() {
              widget.searchItemProvider.itemParameterHolder.isLatest = '1';
              widget.searchItemProvider.itemParameterHolder.isAtoZ = '0';
              widget.searchItemProvider.itemParameterHolder.isZtoA = '0';
              widget.searchItemProvider.itemParameterHolder.isPopular = '0';

              widget.searchItemProvider.itemParameterHolder.orderBy =
                  PsConst.FILTERING__ADDED_DATE;
              widget.searchItemProvider.itemParameterHolder.orderType =
                  PsConst.FILTERING__DESC;
            });
          },
        ),
        GestureDetector(
          child: SortingView(
              image: 'assets/images/baseline_graph_black_24.png',
              titleText: Utils.getString(context, 'item_filter__popular'),
              checkImage:
                  widget.searchItemProvider.itemParameterHolder.orderBy ==
                          PsConst.FILTERING__TRENDING
                      ? 'assets/images/baseline_check_green_24.png'
                      : ''),
          onTap: () {
            print('sort by popular item');
            setState(() {
              widget.searchItemProvider.itemParameterHolder.isPopular = '1';
              widget.searchItemProvider.itemParameterHolder.isAtoZ = '0';
              widget.searchItemProvider.itemParameterHolder.isZtoA = '0';
              widget.searchItemProvider.itemParameterHolder.isLatest = '0';

              widget.searchItemProvider.itemParameterHolder.orderBy =
                  PsConst.FILTERING__TRENDING;
              widget.searchItemProvider.itemParameterHolder.orderType =
                  PsConst.FILTERING__DESC;
            });
          },
        ),
        GestureDetector(
          child: SortingView(
              image: 'assets/images/baseline_price_down_black_24.png',
              titleText: Utils.getString(context, 'item_filter__atoz'),
              checkImage:
                  widget.searchItemProvider.itemParameterHolder.orderBy == '' &&
                          widget.searchItemProvider.itemParameterHolder
                                  .orderType ==
                              PsConst.FILTERING__ASC
                      ? 'assets/images/baseline_check_green_24.png'
                      : ''),
          onTap: () {
            print('sort by A to Z');

            setState(() {
              widget.searchItemProvider.itemParameterHolder.orderBy = '';
              widget.searchItemProvider.itemParameterHolder.isAtoZ = '1';
              widget.searchItemProvider.itemParameterHolder.isZtoA = '0';
              widget.searchItemProvider.itemParameterHolder.isPopular = '0';
              widget.searchItemProvider.itemParameterHolder.isLatest = '0';
              widget.searchItemProvider.itemParameterHolder.orderType =
                  PsConst.FILTERING__ASC;
            });
          },
        ),
        GestureDetector(
          child: SortingView(
              image: 'assets/images/baseline_price_up_black_24.png',
              titleText: Utils.getString(context, 'item_filter__ztoa'),
              checkImage:
                  widget.searchItemProvider.itemParameterHolder.orderBy == '' &&
                          widget.searchItemProvider.itemParameterHolder
                                  .orderType ==
                              PsConst.FILTERING__DESC
                      ? 'assets/images/baseline_check_green_24.png'
                      : ''),
          onTap: () {
            print('sort by Z to A ');
            setState(() {
              widget.searchItemProvider.itemParameterHolder.orderBy = '';
              widget.searchItemProvider.itemParameterHolder.isZtoA = '1';
              widget.searchItemProvider.itemParameterHolder.isAtoZ = '0';
              widget.searchItemProvider.itemParameterHolder.isPopular = '0';
              widget.searchItemProvider.itemParameterHolder.isLatest = '0';
              widget.searchItemProvider.itemParameterHolder.orderType =
                  PsConst.FILTERING__DESC;
            });
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
      ],
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
                  style: Theme.of(context).textTheme.bodyText1),
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

class _SpecialCheckWidget extends StatefulWidget {
  @override
  __SpecialCheckWidgetState createState() => __SpecialCheckWidgetState();
}

class __SpecialCheckWidgetState extends State<_SpecialCheckWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(PsDimens.space12),
          child: Row(
            children: <Widget>[
              Text(Utils.getString(context, 'home_search__advance_filtering'),
                  style: Theme.of(context).textTheme.bodyText1),
            ],
          ),
        ),
        AdvanceFilteringWidget(
            title: Utils.getString(context, 'home_search__featured_item'),
            icon: FontAwesome5.gem,
            checkTitle: 1,
            size: PsDimens.space18),
        const Divider(
          height: PsDimens.space1,
        ),
        AdvanceFilteringWidget(
            title: Utils.getString(context, 'home_search__discount_item'),
            icon: Feather.percent,
            checkTitle: 2,
            size: PsDimens.space18),
        const Divider(
          height: PsDimens.space1,
        ),
      ],
    );
  }
}

class _AdvanceFilteringWidget extends StatefulWidget {
  const _AdvanceFilteringWidget({
    Key key,
    @required this.title,
    @required this.icon,
    @required this.checkTitle,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final bool checkTitle;

  @override
  __AdvanceFilteringWidgetState createState() =>
      __AdvanceFilteringWidgetState();
}

class __AdvanceFilteringWidgetState extends State<_AdvanceFilteringWidget> {
  @override
  Widget build(BuildContext context) {
    final SearchItemProvider provider =
        Provider.of<SearchItemProvider>(context);

    return Container(
        width: double.infinity,
        height: PsDimens.space52,
        child: Container(
          margin: const EdgeInsets.all(PsDimens.space12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(
                    widget.icon,
                    size: PsDimens.space20,
                  ),
                  const SizedBox(
                    width: PsDimens.space10,
                  ),
                  Text(
                    widget.title,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(fontWeight: FontWeight.normal),
                  ),
                ],
              ),
              if (widget.checkTitle)
                Switch(
                  value: provider.isSwitchedFeaturedItem,
                  onChanged: (bool value) {
                    setState(() {
                      provider.isSwitchedFeaturedItem = value;
                    });
                  },
                  activeTrackColor: PsColors.mainColor,
                  activeColor: PsColors.mainColor,
                )
              else
                Switch(
                  value: provider.isSwitchedDiscountPrice,
                  onChanged: (bool value) {
                    setState(() {
                      provider.isSwitchedDiscountPrice = value;
                    });
                  },
                  activeTrackColor: PsColors.mainColor,
                  activeColor: PsColors.mainColor,
                ),
            ],
          ),
        ));
  }
}
