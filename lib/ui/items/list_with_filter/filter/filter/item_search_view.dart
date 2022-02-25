import 'package:businesslistingapi/config/ps_colors.dart';
import 'package:businesslistingapi/constant/ps_constants.dart';
import 'package:businesslistingapi/constant/ps_dimens.dart';
import 'package:businesslistingapi/provider/item/search_item_provider.dart';
import 'package:businesslistingapi/repository/item_repository.dart';
import 'package:businesslistingapi/ui/common/base/ps_widget_with_appbar.dart';
import 'package:businesslistingapi/ui/common/ps_button_widget.dart';
import 'package:businesslistingapi/ui/common/ps_advance_filtering_widget.dart';
import 'package:businesslistingapi/ui/common/ps_textfield_widget.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:businesslistingapi/viewobject/holder/item_parameter_holder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

class ItemSearchView extends StatefulWidget {
  const ItemSearchView({
    @required this.itemParameterHolder,
  });

  final ItemParameterHolder itemParameterHolder;

  @override
  _ItemSearchViewState createState() => _ItemSearchViewState();
}

class _ItemSearchViewState extends State<ItemSearchView> {
  ItemRepository itemRepository;
  SearchItemProvider _searchItemProvider;

  final TextEditingController userInputItemNameTextEditingController =
      TextEditingController();
  final TextEditingController userInputMaximunPriceEditingController =
      TextEditingController();
  final TextEditingController userInputMinimumPriceEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    print(
        '............................Build UI Again ............................');

    final Widget _searchButtonWidget = PSButtonWidget(
      hasShadow: true,
      width: double.infinity,
      titleText: Utils.getString(context, 'home_search__search'),
      onPressed: () {
        if (userInputItemNameTextEditingController.text != null) {
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

        if (!_searchItemProvider.isfirstRatingClicked &&
            !_searchItemProvider.isSecondRatingClicked &&
            !_searchItemProvider.isThirdRatingClicked &&
            !_searchItemProvider.isfouthRatingClicked &&
            !_searchItemProvider.isFifthRatingClicked) {
          _searchItemProvider.itemParameterHolder.ratingValue = '';
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

        print('userInputText' + userInputItemNameTextEditingController.text);

        Navigator.pop(context, _searchItemProvider.itemParameterHolder);
      },
    );

    itemRepository = Provider.of<ItemRepository>(context);

    return PsWidgetWithAppBar<SearchItemProvider>(
        appBarTitle: Utils.getString(context, 'search__filter') ?? '',
        initProvider: () {
          return SearchItemProvider(repo: itemRepository);
        },
        onProviderReady: (SearchItemProvider provider) {
          _searchItemProvider = provider;
          _searchItemProvider.itemParameterHolder = widget.itemParameterHolder;

          userInputItemNameTextEditingController.text =
              widget.itemParameterHolder.keyword;
          // userInputMinimumPriceEditingController.text =
          //     widget.itemParameterHolder.minPrice;
          // userInputMaximunPriceEditingController.text =
          //     widget.itemParameterHolder.maxPrice;

          if (widget.itemParameterHolder.ratingValue == PsConst.RATING_ONE) {
            _searchItemProvider.isfirstRatingClicked = true;
          } else if (widget.itemParameterHolder.ratingValue ==
              PsConst.RATING_TWO) {
            _searchItemProvider.isSecondRatingClicked = true;
          } else if (widget.itemParameterHolder.ratingValue ==
              PsConst.RATING_THREE) {
            _searchItemProvider.isThirdRatingClicked = true;
          } else if (widget.itemParameterHolder.ratingValue ==
              PsConst.RATING_FOUR) {
            _searchItemProvider.isfouthRatingClicked = true;
          } else if (widget.itemParameterHolder.ratingValue ==
              PsConst.RATING_FIVE) {
            _searchItemProvider.isFifthRatingClicked = true;
          }

          if (widget.itemParameterHolder.isPromotion == PsConst.ONE) {
            _searchItemProvider.isSwitchedDiscountPrice = true;
          } else {
            _searchItemProvider.isSwitchedDiscountPrice = false;
          }
          if (widget.itemParameterHolder.isFeatured == PsConst.ONE) {
            _searchItemProvider.isSwitchedFeaturedItem = true;
          } else {
            _searchItemProvider.isSwitchedFeaturedItem = false;
          }
        },
        actions: <Widget>[
          IconButton(
              icon: Icon(MaterialCommunityIcons.filter_remove_outline,
                  color: PsColors.white),
              onPressed: () {
                print('Click Clear Button');
                userInputItemNameTextEditingController.text = '';
                userInputMaximunPriceEditingController.text = '';
                userInputMinimumPriceEditingController.text = '';
                _searchItemProvider.isfirstRatingClicked = false;
                _searchItemProvider.isSecondRatingClicked = false;
                _searchItemProvider.isThirdRatingClicked = false;
                _searchItemProvider.isfouthRatingClicked = false;
                _searchItemProvider.isFifthRatingClicked = false;

                _searchItemProvider.isSwitchedFeaturedItem = false;
                _searchItemProvider.isSwitchedDiscountPrice = false;
                setState(() {});
              }),
        ],
        builder:
            (BuildContext context, SearchItemProvider provider, Widget child) {
          return CustomScrollView(
            scrollDirection: Axis.vertical,
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: SingleChildScrollView(
                  child: Container(
                    color: PsColors.baseColor,
                    child: Column(
                      children: <Widget>[
                        _SortingWidget(
                          searchItemProvider: provider,
                        ),
                        _ItemNameWidget(
                          userInputItemNameTextEditingController:
                              userInputItemNameTextEditingController,
                        ),
                        // _PriceWidget(
                        //   userInputMinimumPriceEditingController:
                        //       userInputMinimumPriceEditingController,
                        //   userInputMaximunPriceEditingController:
                        //       userInputMaximunPriceEditingController,
                        // ),
                        _RatingRangeWidget(),
                        _SpecialCheckWidget(),
                        Container(
                          margin: const EdgeInsets.only(
                              left: PsDimens.space16,
                              top: PsDimens.space16,
                              right: PsDimens.space16,
                              bottom: PsDimens.space40),
                          child: _searchButtonWidget,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }
}

dynamic setAllRatingFalse(SearchItemProvider provider) {
  provider.isfirstRatingClicked = false;
  provider.isSecondRatingClicked = false;
  provider.isThirdRatingClicked = false;
  provider.isfouthRatingClicked = false;
  provider.isFifthRatingClicked = false;
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
            // Navigator.pop(context, searchItemProvider.itemParameterHolder);
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

            // Navigator.pop(context, searchItemProvider.itemParameterHolder);
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

            // Navigator.pop(context, searchItemProvider.itemParameterHolder);
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
            // Navigator.pop(context, searchItemProvider.itemParameterHolder);
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
            const SizedBox(
              height: PsDimens.space2,
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
          width: double.infinity,
          margin: const EdgeInsets.all(PsDimens.space12),
          child: Text(Utils.getString(context, 'home_search__rating_range'),
              style: Theme.of(context).textTheme.bodyText1),
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

// class _PriceWidget extends StatelessWidget {
//   const _PriceWidget(
//       {this.userInputMinimumPriceEditingController,
//       this.userInputMaximunPriceEditingController});
//   final TextEditingController userInputMinimumPriceEditingController;
//   final TextEditingController userInputMaximunPriceEditingController;
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         Container(
//           width: double.infinity,
//           margin: const EdgeInsets.all(PsDimens.space12),
//           child: Text(Utils.getString(context, 'home_search__price'),
//               style: Theme.of(context).textTheme.bodyText1),
//         ),
//         _PriceTextWidget(
//           title: Utils.getString(context, 'home_search__lowest_price'),
//           textField: TextField(
//             maxLines: null,
//             style: Theme.of(context).textTheme.bodyText2,
//             decoration: InputDecoration(
//                 contentPadding: const EdgeInsets.only(
//                     left: PsDimens.space8, bottom: PsDimens.space12),
//                 border: InputBorder.none,
//                 hintText: Utils.getString(context, 'home_search__not_set'),
//                 hintStyle: Theme.of(context)
//                     .textTheme
//                     .bodyText2
//                     .copyWith(color: PsColors.textPrimaryLightColor)),
//             keyboardType: TextInputType.number,
//             controller: userInputMinimumPriceEditingController,
//           ),
//         ),
//         const Divider(
//           height: PsDimens.space1,
//         ),
//         _PriceTextWidget(
//           title: Utils.getString(context, 'home_search__highest_price'),
//           textField: TextField(
//             maxLines: null,
//             style: Theme.of(context).textTheme.bodyText2,
//             decoration: InputDecoration(
//                 contentPadding: const EdgeInsets.only(
//                     left: PsDimens.space8, bottom: PsDimens.space12),
//                 border: InputBorder.none,
//                 hintText: Utils.getString(context, 'home_search__not_set'),
//                 hintStyle: Theme.of(context)
//                     .textTheme
//                     .bodyText2
//                     .copyWith(color: PsColors.textPrimaryLightColor)),
//             keyboardType: TextInputType.number,
//             controller: userInputMaximunPriceEditingController,
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _PriceTextWidget extends StatelessWidget {
//   const _PriceTextWidget({
//     Key key,
//     @required this.title,
//     @required this.textField,
//   }) : super(key: key);

//   final String title;
//   final TextField textField;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       color: PsColors.backgroundColor,
//       child: Container(
//         margin: const EdgeInsets.all(PsDimens.space12),
//         alignment: Alignment.centerLeft,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: <Widget>[
//             Text(
//               title,
//               style: Theme.of(context).textTheme.bodyText2,
//             ),
//             Container(
//                 decoration: BoxDecoration(
//                     color: PsColors.backgroundColor,
//                     borderRadius: BorderRadius.circular(PsDimens.space4),
//                     border: Border.all(color: PsColors.mainDividerColor)),
//                 width: PsDimens.space120,
//                 height: PsDimens.space36,
//                 child: textField),
//           ],
//         ),
//       ),
//     );
//   }
// }

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
          width: double.infinity,
          child: Text(
              Utils.getString(context, 'home_search__advance_filtering'),
              style: Theme.of(context).textTheme.bodyText1),
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
