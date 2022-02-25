import 'package:flutter_icons/flutter_icons.dart';
import 'package:businesslistingapi/config/ps_colors.dart';
import 'package:businesslistingapi/config/ps_config.dart';
import 'package:businesslistingapi/constant/ps_constants.dart';
import 'package:businesslistingapi/ui/category/item/category_vertical_list_item.dart';
import 'package:businesslistingapi/ui/common/base/ps_widget_with_appbar.dart';
import 'package:businesslistingapi/ui/common/dialog/filter_dialog.dart';
import 'package:businesslistingapi/ui/common/ps_admob_banner_widget.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:businesslistingapi/viewobject/common/ps_value_holder.dart';
import 'package:businesslistingapi/viewobject/holder/category_parameter_holder.dart';
import 'package:businesslistingapi/viewobject/holder/intent_holder/item_list_intent_holder.dart';
import 'package:businesslistingapi/viewobject/holder/item_parameter_holder.dart';
import 'package:flutter/material.dart';
import 'package:businesslistingapi/viewobject/holder/touch_count_parameter_holder.dart';
import 'package:provider/provider.dart';
import 'package:businesslistingapi/constant/ps_dimens.dart';
import 'package:businesslistingapi/constant/route_paths.dart';
import 'package:businesslistingapi/provider/category/category_provider.dart';
import 'package:businesslistingapi/repository/category_repository.dart';
import 'package:businesslistingapi/ui/common/ps_ui_widget.dart';

class CategorySortingListView extends StatefulWidget {
  @override
  _CategoryListViewState createState() {
    return _CategoryListViewState();
  }
}

class _CategoryListViewState extends State<CategorySortingListView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  CategoryProvider _categoryProvider;
  final CategoryParameterHolder categoryIconList = CategoryParameterHolder();

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
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // _categoryProvider.nextCategoryList(categoryIconList.toMap());
        _categoryProvider.nextCategoryList(
            _categoryProvider.categoryParameterHolder.toMap(),
            Utils.checkUserLoginId(_categoryProvider.psValueHolder));
      }
    });

    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);

    super.initState();
  }

  CategoryRepository repo1;
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

    repo1 = Provider.of<CategoryRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);
    print(
        '............................Build UI Again ............................');
    return WillPopScope(
        onWillPop: _requestPop,
        child: PsWidgetWithAppBar<CategoryProvider>(
        appBarTitle:
            Utils.getString(context, 'category_list__category_list') ?? '',
         actions: <Widget>[
            IconButton(
              icon: Icon(MaterialCommunityIcons.filter_remove_outline,
                  color: PsColors.white),
              onPressed: () {
                showDialog<dynamic>(
                    context: context,
                    builder: (BuildContext context) {
                      return FilterDialog(
                        onAscendingTap: () async {
                          _categoryProvider.categoryParameterHolder.orderBy =
                              PsConst.FILTERING_CAT_NAME;
                          _categoryProvider.categoryParameterHolder.orderType =
                              PsConst.FILTERING__ASC;
                          _categoryProvider.resetCategoryList(
                              _categoryProvider.categoryParameterHolder.toMap(),
                              Utils.checkUserLoginId(
                                  _categoryProvider.psValueHolder));
                        },
                        onDescendingTap: () {
                          _categoryProvider.categoryParameterHolder.orderBy =
                              PsConst.FILTERING_CAT_NAME;
                          _categoryProvider.categoryParameterHolder.orderType =
                              PsConst.FILTERING__DESC;
                          _categoryProvider.resetCategoryList(
                              _categoryProvider.categoryParameterHolder.toMap(),
                              Utils.checkUserLoginId(
                                  _categoryProvider.psValueHolder));
                        },
                      );
                    });
              },
            )
          ],
          initProvider: () {
            return CategoryProvider(repo: repo1, psValueHolder: psValueHolder);
          },
          onProviderReady: (CategoryProvider provider) {
            provider.categoryParameterHolder.cityId = provider.psValueHolder.cityId;
            provider.loadCategoryList(provider.categoryParameterHolder.toMap(),
                Utils.checkUserLoginId(provider.psValueHolder));

            _categoryProvider = provider;
          },

          builder: 
              (BuildContext context, CategoryProvider provider, Widget child) {
            return Stack(children: <Widget>[
              Column(children: <Widget>[
                const PsAdMobBannerWidget(),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                        left: PsDimens.space8,
                        right: PsDimens.space8,
                        top: PsDimens.space8,
                        bottom: PsDimens.space8),
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
                                      maxCrossAxisExtent: 200.0,
                                      childAspectRatio: 1.6),
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  if (provider.categoryList.data != null ||
                                      provider.categoryList.data.isNotEmpty) {
                                    final int count =
                                        provider.categoryList.data.length;
                                    return CategoryVerticalListItem(
                                      animationController:
                                          animationController,
                                      animation:
                                          Tween<double>(begin: 0.0, end: 1.0)
                                              .animate(
                                        CurvedAnimation(
                                          parent: animationController,
                                          curve: Interval(
                                              (1 / count) * index, 1.0,
                                              curve: Curves.fastOutSlowIn),
                                        ),
                                      ),
                                      category:
                                          provider.categoryList.data[index],

                                      onTap: () {
                                        if (PsConfig.isShowSubCategory) {
                                            Navigator.pushNamed(context,
                                                RoutePaths.subCategoryList,
                                                arguments: provider
                                                    .categoryList
                                                    .data[index]);
                                            } else {
                                              final String loginUserId =
                                                  Utils.checkUserLoginId(
                                                      psValueHolder);
                                              final TouchCountParameterHolder
                                                  touchCountParameterHolder =
                                                  TouchCountParameterHolder(
                                                      typeId: provider
                                                          .categoryList
                                                          .data[index]
                                                          .id,
                                                      typeName: PsConst
                                                          .FILTERING_TYPE_NAME_CATEGORY,
                                                      userId: loginUserId);

                                              provider.postTouchCount(
                                                  touchCountParameterHolder
                                                      .toMap());

                                              final ItemParameterHolder
                                                  itemParameterHolder =
                                                  ItemParameterHolder()
                                                      .getLatestParameterHolder();
                                              itemParameterHolder.catId =
                                                  provider.categoryList
                                                      .data[index].id;
                                              Navigator.pushNamed(context,
                                                  RoutePaths.filterItemList,
                                                  arguments:
                                                      ItemListIntentHolder(
                                                    checkPage: '1',
                                                    appBarTitle: provider
                                                        .categoryList
                                                        .data[index]
                                                        .name,
                                                    itemParameterHolder:
                                                        itemParameterHolder,
                                                  ));
                                            }
                                          },
                                        );
                                  } else {
                                    return null;
                                  }
                                },
                                childCount: provider.categoryList.data.length,
                              ),
                            ),
                          ]),
                      onRefresh: () {
                        return provider.resetCategoryList(
                            _categoryProvider.categoryParameterHolder.toMap(),
                            Utils.checkUserLoginId(_categoryProvider.psValueHolder));
                      },
                    ),
                  ),
                ),
              ]),
              PSProgressIndicator(provider.categoryList.status)
            ]);
          })
        );
  }
}
