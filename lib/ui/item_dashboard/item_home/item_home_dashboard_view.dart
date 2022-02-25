
import 'package:businesslistingapi/config/ps_colors.dart';
import 'package:businesslistingapi/config/ps_config.dart';
import 'package:businesslistingapi/constant/ps_constants.dart';
import 'package:businesslistingapi/provider/blog/blog_provider.dart';
// import 'package:businesslistingapi/provider/city_info/city_info_provider.dart';
import 'package:businesslistingapi/provider/item/discount_item_provider.dart';
import 'package:businesslistingapi/provider/item/feature_item_provider.dart';
import 'package:businesslistingapi/provider/item/search_item_provider.dart';
import 'package:businesslistingapi/provider/item/trending_item_provider.dart';
import 'package:businesslistingapi/provider/itemcollection/item_collection_provider.dart';
// import 'package:businesslistingapi/repository/Common/notification_repository.dart';
import 'package:businesslistingapi/repository/blog_repository.dart';
import 'package:businesslistingapi/repository/city_info_repository.dart';
import 'package:businesslistingapi/repository/item_collection_repository.dart';
import 'package:businesslistingapi/ui/category/item/category_horizontal_list_item.dart';
import 'package:businesslistingapi/ui/common/dialog/error_dialog.dart';
import 'package:businesslistingapi/ui/common/ps_frame_loading_widget.dart';
// import 'package:businesslistingapi/ui/common/dialog/noti_dialog.dart';
import 'package:businesslistingapi/ui/common/ps_ui_widget.dart';
import 'package:businesslistingapi/ui/item_dashboard/item_home/item_blog_slider.dart';
import 'package:businesslistingapi/ui/items/item/item_horizontal_list_item.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:businesslistingapi/viewobject/blog.dart';
import 'package:businesslistingapi/viewobject/city.dart';
import 'package:businesslistingapi/viewobject/common/ps_value_holder.dart';
import 'package:businesslistingapi/viewobject/holder/category_parameter_holder.dart';
import 'package:businesslistingapi/viewobject/holder/intent_holder/category_container_intent_holder.dart';
import 'package:businesslistingapi/viewobject/holder/intent_holder/collection_intent_holder.dart';
import 'package:businesslistingapi/viewobject/holder/intent_holder/item_entry_intent_holder.dart';
import 'package:businesslistingapi/viewobject/holder/intent_holder/item_detail_intent_holder.dart';
import 'package:businesslistingapi/viewobject/holder/intent_holder/item_list_intent_holder.dart';
import 'package:businesslistingapi/viewobject/holder/item_parameter_holder.dart';
import 'package:businesslistingapi/viewobject/holder/touch_count_parameter_holder.dart';
import 'package:businesslistingapi/viewobject/item.dart';
import 'package:flutter/material.dart';
import 'package:businesslistingapi/viewobject/item_collection_header.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:businesslistingapi/api/common/ps_status.dart';
import 'package:businesslistingapi/constant/ps_dimens.dart';
import 'package:businesslistingapi/constant/route_paths.dart';
import 'package:businesslistingapi/provider/category/category_provider.dart';
import 'package:businesslistingapi/repository/category_repository.dart';
import 'package:businesslistingapi/repository/item_repository.dart';

class ItemHomeDashboardViewWidget extends StatefulWidget {
  const ItemHomeDashboardViewWidget(
    this.city,
    this.animationController,
    this.context,
    this.animationControllerForFab,
    // this.onNotiClicked
  );

  final City city;
  final AnimationController animationController;
  final AnimationController animationControllerForFab;
  final BuildContext context;

  // final Function onNotiClicked;

  @override
  _ItemHomeDashboardViewWidgetState createState() =>
      _ItemHomeDashboardViewWidgetState();
}

class _ItemHomeDashboardViewWidgetState
    extends State<ItemHomeDashboardViewWidget> {
  PsValueHolder valueHolder;
  CategoryRepository categoryRepo;
  ItemRepository itemRepo;
  BlogRepository blogRepo;
  ItemCollectionRepository itemCollectionRepo;
  CityInfoRepository shopInfoRepository;
  BlogProvider _blogProvider;
  SearchItemProvider _searchItemProvider;
  DiscountItemProvider _discountItemProvider;
  TrendingItemProvider _trendingItemProvider;
  FeaturedItemProvider _featuredItemProvider;
  ItemCollectionProvider _itemCollectionProvider;
  ItemParameterHolder discountItemParameterHolder;
  ItemParameterHolder searchItemParameterHolder;
  ItemParameterHolder trendingItemParameterHolder;
  ItemParameterHolder featuredItemParameterHolder;

  // NotificationRepository notificationRepository;
  CategoryProvider _categoryProvider;
  final int count = 8;
  final CategoryParameterHolder trendingCategory = CategoryParameterHolder();
  // final CategoryParameterHolder categoryIconList = CategoryParameterHolder();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    categoryRepo = Provider.of<CategoryRepository>(context);
    itemRepo = Provider.of<ItemRepository>(context);
    blogRepo = Provider.of<BlogRepository>(context);
    itemCollectionRepo = Provider.of<ItemCollectionRepository>(context);
    shopInfoRepository = Provider.of<CityInfoRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context);

    return MultiProvider(
        providers: <SingleChildWidget>[
          ChangeNotifierProvider<CategoryProvider>(
              lazy: false,
              create: (BuildContext context) {
                _categoryProvider ??= CategoryProvider(
                    repo: categoryRepo,
                    psValueHolder: valueHolder,
                    limit: PsConfig.CATEGORY_LOADING_LIMIT);
                _categoryProvider.categoryParameterHolder.cityId = 
                    _categoryProvider.psValueHolder.cityId;
                _categoryProvider.loadCategoryList(_categoryProvider.categoryParameterHolder.toMap(),
                Utils.checkUserLoginId(_categoryProvider.psValueHolder));
                return _categoryProvider;
              }),
          ChangeNotifierProvider<BlogProvider>(
              lazy: false,
              create: (BuildContext context) {
                _blogProvider = BlogProvider(repo: blogRepo);
                _blogProvider.loadBlogList();

                return _blogProvider;
              }),
          ChangeNotifierProvider<SearchItemProvider>(
              lazy: false,
              create: (BuildContext context) {
                searchItemParameterHolder = ItemParameterHolder();
                searchItemParameterHolder.getLatestParameterHolder().cityId =
                    widget.city.id;
                _searchItemProvider = SearchItemProvider(
                    repo: itemRepo,
                    limit: PsConfig.LATEST_PRODUCT_LOADING_LIMIT);
                _searchItemProvider
                    .loadItemListByKey(searchItemParameterHolder);
                _searchItemProvider.replaceCityInfoData(widget.city.id,
                    widget.city.name, widget.city.lat, widget.city.lng);
                return _searchItemProvider;
              }),
          ChangeNotifierProvider<DiscountItemProvider>(
              lazy: false,
              create: (BuildContext context) {
                discountItemParameterHolder = ItemParameterHolder();
                discountItemParameterHolder
                    .getDiscountParameterHolder()
                    .cityId = widget.city.id;
                _discountItemProvider = DiscountItemProvider(
                    repo: itemRepo,
                    limit: PsConfig.DISCOUNT_PRODUCT_LOADING_LIMIT);
                _discountItemProvider.loadItemList(discountItemParameterHolder);
                return _discountItemProvider;
              }),
          ChangeNotifierProvider<TrendingItemProvider>(
              lazy: false,
              create: (BuildContext context) {
                trendingItemParameterHolder = ItemParameterHolder();
                trendingItemParameterHolder
                    .getTrendingParameterHolder()
                    .cityId = widget.city.id;
                _trendingItemProvider = TrendingItemProvider(
                    repo: itemRepo,
                    limit: PsConfig.TRENDING_PRODUCT_LOADING_LIMIT);
                _trendingItemProvider.loadItemList(
                    PsConst.PROPULAR_ITEM_COUNT, trendingItemParameterHolder);
                return _trendingItemProvider;
              }),
          ChangeNotifierProvider<FeaturedItemProvider>(
              lazy: false,
              create: (BuildContext context) {
                featuredItemParameterHolder = ItemParameterHolder();
                featuredItemParameterHolder
                    .getFeaturedParameterHolder()
                    .cityId = widget.city.id;
                _featuredItemProvider = FeaturedItemProvider(
                    repo: itemRepo,
                    limit: PsConfig.FEATURE_PRODUCT_LOADING_LIMIT);
                _featuredItemProvider.loadItemList(featuredItemParameterHolder);
                return _featuredItemProvider;
              }),
          ChangeNotifierProvider<ItemCollectionProvider>(
              lazy: false,
              create: (BuildContext context) {
                _itemCollectionProvider = ItemCollectionProvider(
                    repo: itemCollectionRepo,
                    limit: PsConfig.COLLECTION_PRODUCT_LOADING_LIMIT);
                _itemCollectionProvider.loadItemCollectionList(widget.city.id);
                return _itemCollectionProvider;
              }),
        ],
        child: Scaffold(
            floatingActionButton: FadeTransition(
              opacity: widget.animationControllerForFab,
              child: ScaleTransition(
                scale: widget.animationControllerForFab,
                child: FloatingActionButton(
                  onPressed: () async {
                    if (await Utils.checkInternetConnectivity()) {
                      Utils.navigateOnUserVerificationView(context, () async {
                        Navigator.pushNamed(context, RoutePaths.itemEntry,
                            arguments: ItemEntryIntentHolder(
                                flag: PsConst.ADD_NEW_ITEM, item: Item()));
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
                  child: Icon(Icons.add, color: PsColors.white),
                  backgroundColor: PsColors.mainColor,
                  // label: Text(Utils.getString(context, 'dashboard__submit_ad'),
                  //     style: Theme.of(context)
                  //         .textTheme
                  //         .caption
                  //         .copyWith(color: PsColors.white)),
                ),
              ),
            ),
            body: Container(
                color: PsColors.coreBackgroundColor,
                child: RefreshIndicator(
                  onRefresh: () {
                   _categoryProvider.resetCategoryList(
                        _categoryProvider.categoryParameterHolder.toMap(),
                        Utils.checkUserLoginId(_categoryProvider.psValueHolder));
                    _blogProvider.resetBlogList();
                    _searchItemProvider
                        .resetLatestItemList(searchItemParameterHolder);
                    _discountItemProvider
                        .resetDiscountItemList(discountItemParameterHolder);
                    _trendingItemProvider
                        .resetTrendingItemList(trendingItemParameterHolder);
                    _featuredItemProvider
                        .resetFeatureItemList(featuredItemParameterHolder);
                    return _itemCollectionProvider
                        .resetItemCollectionList(widget.city.id);
                  },
                  child: CustomScrollView(
                    scrollDirection: Axis.vertical,
                    slivers: <Widget>[
                      _CityInfoWidget(
                        city: widget.city,
                        animationController: widget.animationController,
                        animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                                parent: widget.animationController,
                                curve: Interval((1 / count) * 1, 1.0,
                                    curve: Curves.fastOutSlowIn))), //animation
                      ),

                      ///
                      /// category List Widget
                      ///
                      _ItemHomeCategoryHorizontalListWidget(
                        city: widget.city,
                        psValueHolder: valueHolder,
                        animationController: widget.animationController,
                        animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                                parent: widget.animationController,
                                curve: Interval((1 / count) * 2, 1.0,
                                    curve: Curves.fastOutSlowIn))), //animation
                      ),

                      _ItemHomeFeaturedItemHorizontalListWidget(
                        cityId: widget.city.id,
                        animationController: widget.animationController,
                        animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                                parent: widget.animationController,
                                curve: Interval((1 / count) * 3, 1.0,
                                    curve: Curves.fastOutSlowIn))),
                      ),
                      // const PsAdMobBannerWidget(),

                      _ItemHomeTrendingItemHorizontalListWidget(
                        cityId: widget.city.id,
                        animationController: widget.animationController,
                        animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                                parent: widget.animationController,
                                curve: Interval((1 / count) * 6, 1.0,
                                    curve: Curves.fastOutSlowIn))), //animation
                      ),
                      _ItemHomeLatestItemHorizontalListWidget(
                        cityId: widget.city.id,
                        animationController: widget.animationController,
                        animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                                parent: widget.animationController,
                                curve: Interval((1 / count) * 4, 1.0,
                                    curve: Curves.fastOutSlowIn))), //animation
                      ),
                      _ItemHomeOnPromotionHorizontalListWidget(
                        cityId: widget.city.id,
                        animationController: widget.animationController,
                        animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                                parent: widget.animationController,
                                curve: Interval((1 / count) * 3, 1.0,
                                    curve: Curves.fastOutSlowIn))), //animation
                      ),
                      _ItemHomeBlogSliderWidget(
                        cityId: widget.city.id,
                        animationController: widget.animationController,
                        animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                                parent: widget.animationController,
                                curve: Interval((1 / count) * 5, 1.0,
                                    curve: Curves.fastOutSlowIn))), //animation
                      ),
                      // const PsAdMobBannerWidget(),

                      _ItemHomeCollectionItemListWidget(
                        animationController: widget.animationController,

                        animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                                parent: widget.animationController,
                                curve: Interval((1 / count) * 7, 1.0,
                                    curve: Curves.fastOutSlowIn))), //animation
                      ),
                    ],
                  ),
                ))));
  }
}

class _ItemHomeLatestItemHorizontalListWidget extends StatefulWidget {
  const _ItemHomeLatestItemHorizontalListWidget({
    Key key,
    @required this.animationController,
    @required this.animation,
    @required this.cityId,
  }) : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;
  final String cityId;

  @override
  __ItemHomeLatestItemHorizontalListWidgetState createState() =>
      __ItemHomeLatestItemHorizontalListWidgetState();
}

class __ItemHomeLatestItemHorizontalListWidgetState
    extends State<_ItemHomeLatestItemHorizontalListWidget> {
  @override
  Widget build(BuildContext context) {
    final ItemParameterHolder itemParameterHolder = ItemParameterHolder();
    itemParameterHolder.getLatestParameterHolder().cityId = widget.cityId;
    return SliverToBoxAdapter(
      child: Consumer<SearchItemProvider>(
        builder: (BuildContext context, SearchItemProvider itemProvider,
            Widget child) {
          return AnimatedBuilder(
              animation: widget.animationController,
              child: Column(children: <Widget>[
                _MyHeaderWidget(
                  headerName:
                      Utils.getString(context, 'dashboard__popular_item'),
                  viewAllClicked: () {
                    Navigator.pushNamed(context, RoutePaths.filterItemList,
                        arguments: ItemListIntentHolder(
                          checkPage: '1',
                          appBarTitle: Utils.getString(
                              context, 'dashboard__popular_item'),
                          itemParameterHolder: itemParameterHolder,
                        ));
                  },
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: PsDimens.space16),
                  child: Text(
                    Utils.getString(
                        context, 'dashboard__popular_item_description'),
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                Container(
                    height: PsDimens.space320,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(left: PsDimens.space16),
                        itemCount: itemProvider.itemList.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (itemProvider.itemList.status ==
                              PsStatus.BLOCK_LOADING) {
                            return Shimmer.fromColors(
                                baseColor: PsColors.grey,
                                highlightColor: PsColors.white,
                                child: Row(children: const <Widget>[
                                  PsFrameUIForLoading(),
                                ]));
                          } else {
                            final Item item = itemProvider.itemList.data[index];

                            return ItemHorizontalListItem(
                              coreTagKey: itemProvider.hashCode.toString() +
                                  item.id, //'latest',
                              item: item,
                              onTap: () async {
                                print(item.defaultPhoto.imgPath);

                                final ItemDetailIntentHolder holder =
                                    ItemDetailIntentHolder(
                                  itemId: item.id,
                                  heroTagImage: '',
                                  heroTagTitle: '',
                                  heroTagOriginalPrice: '',
                                  heroTagUnitPrice: '',
                                );

                                final dynamic result =
                                    await Navigator.pushNamed(
                                        context, RoutePaths.itemDetail,
                                        arguments: holder);
                                if (result == null) {
                                  setState(() {
                                    itemProvider
                                        .loadItemListByKey(itemParameterHolder);
                                  });
                                }
                              },
                            );
                          }
                        }))
              ]),
              // : Container(),,
              builder: (BuildContext context, Widget child) {
                if (itemProvider.itemList.data != null &&
                    itemProvider.itemList.data.isNotEmpty) {
                  return FadeTransition(
                    opacity: widget.animation,
                    child: Transform(
                      transform: Matrix4.translationValues(
                          0.0, 100 * (1.0 - widget.animation.value), 0.0),
                      child: child,
                    ),
                  );
                } else {
                  return Container();
                }
              });
        },
      ),
    );
  }
}

class _ItemHomeBlogSliderWidget extends StatelessWidget {
  const _ItemHomeBlogSliderWidget({
    Key key,
    @required this.animationController,
    @required this.animation,
    @required this.cityId,
  }) : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;
  final String cityId;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Consumer<BlogProvider>(builder:
          (BuildContext context, BlogProvider blogProvider, Widget child) {
        return AnimatedBuilder(
            animation: animationController,
            child: (blogProvider.blogList != null &&
                    blogProvider.blogList.data.isNotEmpty)
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _MyHeaderWidget(
                        headerName:
                            Utils.getString(context, 'dashboard__blog_item'),
                        viewAllClicked: () {
                          Navigator.pushNamed(
                            context,
                            RoutePaths.cityBlogList,
                            arguments: cityId,
                          );
                        },
                      ),
                      Container(
                        width: double.infinity,
                        child: ItemBlogSliderView(
                          blogList: blogProvider.blogList.data,
                          onTap: (Blog blog) {
                            Navigator.pushNamed(
                              context,
                              RoutePaths.blogDetail,
                              arguments: blog,
                            );
                          },
                        ),
                      ),
                      // const PsAdMobBannerWidget(),
                    ],
                  )
                : Container(),
            builder: (BuildContext context, Widget child) {
              return FadeTransition(
                  opacity: animation,
                  child: Transform(
                    transform: Matrix4.translationValues(
                        0.0, 100 * (1.0 - animation.value), 0.0),
                    child: child,
                  ));
            });
      }),
    );
  }
}

class _ItemHomeFeaturedItemHorizontalListWidget extends StatefulWidget {
  const _ItemHomeFeaturedItemHorizontalListWidget({
    Key key,
    @required this.animationController,
    @required this.animation,
    @required this.cityId,
  }) : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;
  final String cityId;

  @override
  __ItemHomeFeaturedItemHorizontalListWidgetState createState() =>
      __ItemHomeFeaturedItemHorizontalListWidgetState();
}

class __ItemHomeFeaturedItemHorizontalListWidgetState
    extends State<_ItemHomeFeaturedItemHorizontalListWidget> {
  @override
  Widget build(BuildContext context) {
    final ItemParameterHolder itemParameterHolder = ItemParameterHolder();
    itemParameterHolder.getFeaturedParameterHolder().cityId = widget.cityId;
    return SliverToBoxAdapter(
      child: Consumer<FeaturedItemProvider>(
        builder: (BuildContext context, FeaturedItemProvider itemProvider,
            Widget child) {
          return AnimatedBuilder(
            animation: widget.animationController,
            child: (itemProvider.itemList.data != null &&
                    itemProvider.itemList.data.isNotEmpty)
                ? Column(
                    children: <Widget>[
                      Container(
                        color: Utils.isLightMode(context)
                            ? Colors.yellow[50]
                            : Colors.black12,
                        child: Column(
                          children: <Widget>[
                            _MyHeaderWidget(
                              headerName: Utils.getString(
                                  context, 'dashboard__feature_item'),
                              viewAllClicked: () {
                                Navigator.pushNamed(
                                    context, RoutePaths.filterItemList,
                                    arguments: ItemListIntentHolder(
                                        checkPage: '1',
                                        appBarTitle: Utils.getString(
                                            context, 'dashboard__feature_item'),
                                        itemParameterHolder:
                                            itemParameterHolder));
                              },
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding:
                                  const EdgeInsets.only(left: PsDimens.space16),
                              child: Text(
                                Utils.getString(context,
                                    'dashboard__feature_item_description'),
                                textAlign: TextAlign.start,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                            Container(
                                height: PsDimens.space300,
                                color: Utils.isLightMode(context)
                                    ? Colors.yellow[50]
                                    : Colors.black12,
                                width: MediaQuery.of(context).size.width,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    padding: const EdgeInsets.only(
                                        left: PsDimens.space16),
                                    itemCount:
                                        itemProvider.itemList.data.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      if (itemProvider.itemList.status ==
                                          PsStatus.BLOCK_LOADING) {
                                        return Shimmer.fromColors(
                                            baseColor: PsColors.grey,
                                            highlightColor: PsColors.white,
                                            child: Row(children: const <Widget>[
                                              PsFrameUIForLoading(),
                                            ]));
                                      } else {
                                        final Item item =
                                            itemProvider.itemList.data[index];
                                        return ItemHorizontalListItem(
                                          coreTagKey:
                                              itemProvider.hashCode.toString() +
                                                  item.id, //'feature',
                                          item:
                                              itemProvider.itemList.data[index],
                                          onTap: () async {
                                            print(itemProvider
                                                .itemList
                                                .data[index]
                                                .defaultPhoto
                                                .imgPath);
                                            final ItemDetailIntentHolder
                                                holder = ItemDetailIntentHolder(
                                              itemId: item.id,
                                              heroTagImage: '',
                                              heroTagTitle: '',
                                              heroTagOriginalPrice: '',
                                              heroTagUnitPrice: '',
                                            );

                                            final dynamic result =
                                                await Navigator.pushNamed(
                                                    context,
                                                    RoutePaths.itemDetail,
                                                    arguments: holder);
                                            if (result == null) {
                                              setState(() {
                                                itemProvider.loadItemList(
                                                    itemParameterHolder);
                                              });
                                            }
                                          },
                                        );
                                      }
                                    }))
                          ],
                        ),
                      ),
                      // const PsAdMobBannerWidget(),
                    ],
                  )
                : Container(),
            builder: (BuildContext context, Widget child) {
              return FadeTransition(
                opacity: widget.animation,
                child: Transform(
                  transform: Matrix4.translationValues(
                      0.0, 100 * (1.0 - widget.animation.value), 0.0),
                  child: child,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _ItemHomeTrendingItemHorizontalListWidget extends StatefulWidget {
  const _ItemHomeTrendingItemHorizontalListWidget({
    Key key,
    @required this.animationController,
    @required this.animation,
    @required this.cityId,
  }) : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;
  final String cityId;

  @override
  __ItemHomeTrendingItemHorizontalListWidgetState createState() =>
      __ItemHomeTrendingItemHorizontalListWidgetState();
}

class __ItemHomeTrendingItemHorizontalListWidgetState
    extends State<_ItemHomeTrendingItemHorizontalListWidget> {
  @override
  Widget build(BuildContext context) {
    final ItemParameterHolder itemParameterHolder = ItemParameterHolder();
    itemParameterHolder.getTrendingParameterHolder().cityId = widget.cityId;
    return SliverToBoxAdapter(
      child: Consumer<TrendingItemProvider>(
        builder: (BuildContext context, TrendingItemProvider itemProvider,
            Widget child) {
          return AnimatedBuilder(
            animation: widget.animationController,
            child: (itemProvider.itemList.data != null &&
                    itemProvider.itemList.data.isNotEmpty)
                ? Column(
                    children: <Widget>[
                      _MyHeaderWidget(
                        headerName: Utils.getString(
                            context, 'dashboard__trending_item'),
                        viewAllClicked: () {
                          Navigator.pushNamed(
                              context, RoutePaths.filterItemList,
                              arguments: ItemListIntentHolder(
                                  checkPage: '1',
                                  appBarTitle: Utils.getString(
                                      context, 'dashboard__trending_item'),
                                  itemParameterHolder: itemParameterHolder));
                        },
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: PsDimens.space16),
                        child: Text(
                          Utils.getString(
                              context, 'dashboard__trending_item_description'),
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                      CustomScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          slivers: <Widget>[
                            SliverGrid(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 0.68),
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    if (itemProvider.itemList.status ==
                                        PsStatus.BLOCK_LOADING) {
                                      return Shimmer.fromColors(
                                          baseColor: PsColors.grey,
                                          highlightColor: PsColors.white,
                                          child: Row(children: const <Widget>[
                                            PsFrameUIForLoading(),
                                          ]));
                                    } else {
                                      final Item item =
                                          itemProvider.itemList.data[index];
                                      return ItemHorizontalListItem(
                                        coreTagKey:
                                            itemProvider.hashCode.toString() +
                                                item.id,
                                        item: itemProvider.itemList.data[index],
                                        onTap: () async {
                                          print(itemProvider
                                              .itemList
                                              .data[index]
                                              .defaultPhoto
                                              .imgPath);
                                          final ItemDetailIntentHolder holder =
                                              ItemDetailIntentHolder(
                                            itemId: item.id,
                                            heroTagImage: '',
                                            heroTagTitle: '',
                                            heroTagOriginalPrice: '',
                                            heroTagUnitPrice: '',
                                          );
                                          final dynamic result =
                                              await Navigator.pushNamed(context,
                                                  RoutePaths.itemDetail,
                                                  arguments: holder);
                                          if (result == null) {
                                            setState(() {
                                              itemProvider.loadItemList(
                                                  PsConst.PROPULAR_ITEM_COUNT,
                                                  itemParameterHolder);
                                            });
                                          }
                                        },
                                      );
                                    }
                                  },
                                  childCount: itemProvider.itemList.data.length,
                                ))
                          ])
                    ],
                  )
                : Container(),
            builder: (BuildContext context, Widget child) {
              return FadeTransition(
                opacity: widget.animation,
                child: Transform(
                  transform: Matrix4.translationValues(
                      0.0, 100 * (1.0 - widget.animation.value), 0.0),
                  child: child,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _ItemHomeOnPromotionHorizontalListWidget extends StatefulWidget {
  const _ItemHomeOnPromotionHorizontalListWidget({
    Key key,
    @required this.animationController,
    @required this.animation,
    @required this.cityId,
  }) : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;
  final String cityId;

  @override
  __ItemHomeOnPromotionHorizontalListWidgetState createState() =>
      __ItemHomeOnPromotionHorizontalListWidgetState();
}

class __ItemHomeOnPromotionHorizontalListWidgetState
    extends State<_ItemHomeOnPromotionHorizontalListWidget> {
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
    final ItemParameterHolder itemParameterHolder = ItemParameterHolder();
    itemParameterHolder.getDiscountParameterHolder().cityId = widget.cityId;
    if (!isConnectedToInternet && PsConfig.showAdMob) {
      print('loading ads....');
      checkConnection();
    }
    return SliverToBoxAdapter(child: Consumer<DiscountItemProvider>(builder:
        (BuildContext context, DiscountItemProvider itemProvider,
            Widget child) {
      return AnimatedBuilder(
          animation: widget.animationController,
          child: (itemProvider.itemList.data != null &&
                  itemProvider.itemList.data.isNotEmpty)
              ? Column(children: <Widget>[
                  _MyHeaderWidget(
                    headerName:
                        Utils.getString(context, 'dashboard__promotion_item'),
                    viewAllClicked: () {
                      Navigator.pushNamed(context, RoutePaths.filterItemList,
                          arguments: ItemListIntentHolder(
                              checkPage: '1',
                              appBarTitle: Utils.getString(
                                  context, 'dashboard__promotion_item'),
                              itemParameterHolder: itemParameterHolder));
                    },
                  ),
                  Container(
                      height: PsDimens.space320,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding:
                              const EdgeInsets.only(left: PsDimens.space16),
                          itemCount: itemProvider.itemList.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (itemProvider.itemList.status ==
                                PsStatus.BLOCK_LOADING) {
                              return Shimmer.fromColors(
                                  baseColor: PsColors.grey,
                                  highlightColor: PsColors.white,
                                  child: Row(children: const <Widget>[
                                    PsFrameUIForLoading(),
                                  ]));
                            } else {
                              final Item item =
                                  itemProvider.itemList.data[index];
                              return ItemHorizontalListItem(
                                coreTagKey:
                                    itemProvider.hashCode.toString() + item.id,
                                item: itemProvider.itemList.data[index],
                                onTap: () async {
                                  print(itemProvider.itemList.data[index]
                                      .defaultPhoto.imgPath);
                                  final ItemDetailIntentHolder holder =
                                      ItemDetailIntentHolder(
                                    itemId: item.id,
                                    heroTagImage: '',
                                    heroTagTitle: '',
                                    heroTagOriginalPrice: '',
                                    heroTagUnitPrice: '',
                                  );
                                  final dynamic result =
                                      await Navigator.pushNamed(
                                          context, RoutePaths.itemDetail,
                                          arguments: holder);
                                  if (result == null) {
                                    setState(() {
                                      // ItemParameterHolder().getDiscountParameterHolder()
                                      itemProvider
                                          .loadItemList(itemParameterHolder);
                                    });
                                  }
                                },
                              );
                            }
                          })),
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
                ])
              : Container(),
          builder: (BuildContext context, Widget child) {
            return FadeTransition(
                opacity: widget.animation,
                child: Transform(
                  transform: Matrix4.translationValues(
                      0.0, 100 * (1.0 - widget.animation.value), 0.0),
                  child: child,
                ));
          });
    }));
  }
}

class _CityInfoWidget extends StatelessWidget {
  const _CityInfoWidget({
    Key key,
    @required this.city,
    @required this.animationController,
    @required this.animation,
  }) : super(
          key: key,
        );

  final City city;
  final AnimationController animationController;
  final Animation<double> animation;
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: AnimatedBuilder(
            animation: animationController,
            child: (city != null && city.name != '')
                ? Column(children: <Widget>[
                    PsNetworkImage(
                      photoKey: '',
                      defaultPhoto: city.defaultPhoto,
                      width: double.infinity,
                      height: 220,
                      onTap: () {
                        Utils.psPrint(city.defaultPhoto.imgParentId);
                      },
                    ),
                    Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(PsDimens.space16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Container(
                              width: double.infinity,
                              child: Text(city.name,
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(
                              height: PsDimens.space12,
                            ),
                            Container(
                              width: double.infinity,
                              child: Text(
                                city.description ?? '',
                                textAlign: TextAlign.start,
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(height: 1.5),
                              ),
                            ),
                          ],
                        )),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                            context, RoutePaths.cityInfoContainerView,
                            arguments: city);
                      },
                      child: Text(
                        Utils.getString(context, 'dashboard__about_city'),
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .copyWith(color: PsColors.mainColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: PsDimens.space20),
                    Divider(
                      height: PsDimens.space1,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ])
                : Container(),
            builder: (BuildContext context, Widget child) {
              return FadeTransition(
                  opacity: animation,
                  child: Transform(
                    transform: Matrix4.translationValues(
                        0.0, 100 * (1.0 - animation.value), 0.0),
                    child: child,
                  ));
            }));
    // }),
    // );
  }
}

class _ItemHomeCollectionItemListWidget extends StatelessWidget {
  const _ItemHomeCollectionItemListWidget({
    Key key,
    @required this.animationController,
    @required this.animation,
  }) : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    // const int count = 5;
    // final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
    //     .animate(CurvedAnimation(
    //         parent: animationController,
    //         curve: const Interval((1 / count) * 1, 1.0,
    //             curve: Curves.fastOutSlowIn)));

    return SliverToBoxAdapter(
      child: Consumer<ItemCollectionProvider>(builder: (BuildContext context,
          ItemCollectionProvider collectionProvider, Widget child) {
        return AnimatedBuilder(
            animation: animationController,
            child: (collectionProvider.itemCollectionList != null &&
                    collectionProvider.itemCollectionList.data.isNotEmpty)
                ? ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(left: PsDimens.space16),
                    itemCount:
                        collectionProvider.itemCollectionList.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (collectionProvider.itemCollectionList.status ==
                          PsStatus.BLOCK_LOADING) {
                        return Shimmer.fromColors(
                            baseColor: PsColors.grey,
                            highlightColor: PsColors.white,
                            child: Row(children: const <Widget>[
                              PsFrameUIForLoading(),
                            ]));
                      } else {
                        return _ItemHomeCollectionItemsHorizontalListWidget(
                          headerName: collectionProvider
                              .itemCollectionList.data[index].name,
                          collectionData:
                              collectionProvider.itemCollectionList.data[index],
                        );
                      }
                    })
                : Container(),
            builder: (BuildContext context, Widget child) {
              return FadeTransition(
                  opacity: animation,
                  child: Transform(
                    transform: Matrix4.translationValues(
                        0.0, 100 * (1.0 - animation.value), 0.0),
                    child: child,
                  ));
            });
      }),
    );
  }
}

class _ItemHomeCollectionItemsHorizontalListWidget extends StatefulWidget {
  const _ItemHomeCollectionItemsHorizontalListWidget({
    Key key,
    @required this.collectionData,
    @required this.headerName,
  }) : super(key: key);

  final ItemCollectionHeader collectionData;
  final String headerName;

  @override
  __ItemHomeCollectionItemsHorizontalListWidgetState createState() =>
      __ItemHomeCollectionItemsHorizontalListWidgetState();
}

class __ItemHomeCollectionItemsHorizontalListWidgetState
    extends State<_ItemHomeCollectionItemsHorizontalListWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.collectionData.itemList != null &&
        widget.collectionData.itemList.isNotEmpty) {
      return Column(
        children: <Widget>[
          _MyHeaderWidget(
            headerName: widget.headerName,
            itemCollectionHeader: widget.collectionData,
            viewAllClicked: () {
              Navigator.pushNamed(context, RoutePaths.itemListByCollectionId,
                  arguments: CollectionIntentHolder(
                    itemCollectionHeader: widget.collectionData,
                    appBarTitle: widget.headerName,
                  ));
            },
          ),
          Container(
              height: PsDimens.space320,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.collectionData.itemList.length,
                  padding: const EdgeInsets.only(left: PsDimens.space16),
                  itemBuilder: (BuildContext context, int index) {
                    final Item item = widget.collectionData.itemList[index];
                    return ItemHorizontalListItem(
                      coreTagKey: '',
                      item: item,
                      onTap: () async {
                        print(item.defaultPhoto.imgPath);
                        final ItemDetailIntentHolder holder =
                            ItemDetailIntentHolder(
                          itemId: item.id,
                          heroTagImage: '',
                          heroTagTitle: '',
                          heroTagOriginalPrice: '',
                          heroTagUnitPrice: '',
                        );
                        final dynamic result = await Navigator.pushNamed(
                            context, RoutePaths.itemDetail,
                            arguments: holder);
                        if (result == null) {
                          setState(() {
                            // item.loadItemList();
                          });
                        }
                      },
                    );
                  }))
        ],
      );
    } else {
      return Container();
    }
  }
}

class _ItemHomeCategoryHorizontalListWidget extends StatefulWidget {
  const _ItemHomeCategoryHorizontalListWidget(
      {Key key,
      @required this.city,
      @required this.animationController,
      @required this.animation,
      @required this.psValueHolder})
      : super(key: key);

  final City city;
  final AnimationController animationController;
  final Animation<double> animation;
  final PsValueHolder psValueHolder;

  @override
  __ItemHomeCategoryHorizontalListWidgetState createState() =>
      __ItemHomeCategoryHorizontalListWidgetState();
}

class __ItemHomeCategoryHorizontalListWidgetState
    extends State<_ItemHomeCategoryHorizontalListWidget> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(child: Consumer<CategoryProvider>(
      builder: (BuildContext context, CategoryProvider categoryProvider,
          Widget child) {
        return AnimatedBuilder(
            animation: widget.animationController,
            child: (categoryProvider.categoryList.data != null &&
                    categoryProvider.categoryList.data.isNotEmpty)
                ? Column(mainAxisAlignment: MainAxisAlignment.start, children: <
                    Widget>[
                    _MyHeaderWidget(
                      headerName:
                          Utils.getString(context, 'dashboard__categories'),
                      viewAllClicked: () {
                        Navigator.pushNamed(context, RoutePaths.categoryList,
                            arguments: CategoryContainerIntentHolder(
                                appBarTitle: Utils.getString(
                                    context, 'dashboard__categories'),
                                city: widget.city));
                      },
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: PsDimens.space16),
                      child: Text(
                        Utils.getString(
                            context, 'dashboard__category_description'),
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    Container(
                      height: PsDimens.space140,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          shrinkWrap: true,
                          padding:
                              const EdgeInsets.only(left: PsDimens.space16),
                          scrollDirection: Axis.horizontal,
                          itemCount: categoryProvider.categoryList.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (categoryProvider.categoryList.status ==
                                PsStatus.BLOCK_LOADING) {
                              return Shimmer.fromColors(
                                  baseColor: PsColors.grey,
                                  highlightColor: PsColors.white,
                                  child: Row(children: const <Widget>[
                                    PsFrameUIForLoading(),
                                  ]));
                            } else {
                              return CategoryHorizontalListItem(
                                category:
                                    categoryProvider.categoryList.data[index],
                                onTap: () {
                                  final String loginUserId =
                                      Utils.checkUserLoginId(
                                          categoryProvider.psValueHolder);

                                  final TouchCountParameterHolder
                                      touchCountParameterHolder =
                                      TouchCountParameterHolder(
                                          typeId: categoryProvider
                                              .categoryList.data[index].id,
                                          typeName: PsConst
                                              .FILTERING_TYPE_NAME_CATEGORY,
                                          userId: loginUserId);

                                  categoryProvider.postTouchCount(
                                      touchCountParameterHolder.toMap());
                                  if (PsConfig.isShowSubCategory) {
                                    Navigator.pushNamed(
                                        context, RoutePaths.subCategoryList,
                                        arguments: categoryProvider
                                            .categoryList.data[index]);
                                  } else {
                                    print(categoryProvider.categoryList
                                        .data[index].defaultPhoto.imgPath);
                                    final ItemParameterHolder
                                        itemParameterHolder =
                                        ItemParameterHolder()
                                            .getLatestParameterHolder();
                                    itemParameterHolder.catId = categoryProvider
                                        .categoryList.data[index].id;
                                    Navigator.pushNamed(
                                        context, RoutePaths.filterItemList,
                                        arguments: ItemListIntentHolder(
                                          checkPage: '1',
                                          appBarTitle: categoryProvider
                                              .categoryList.data[index].name,
                                          itemParameterHolder:
                                              itemParameterHolder,
                                        ));
                                  }
                                },
                              );
                            }
                          }),
                    )
                  ])
                : Container(),
            builder: (BuildContext context, Widget child) {
              return FadeTransition(
                  opacity: widget.animation,
                  child: Transform(
                    transform: Matrix4.translationValues(
                        0.0, 30 * (1.0 - widget.animation.value), 0.0),
                    child: child,
                  ));
            });
      },
    ));
  }
}

class _MyHeaderWidget extends StatefulWidget {
  const _MyHeaderWidget({
    Key key,
    @required this.headerName,
    this.itemCollectionHeader,
    @required this.viewAllClicked,
  }) : super(key: key);

  final String headerName;
  final Function viewAllClicked;
  final ItemCollectionHeader itemCollectionHeader;

  @override
  __MyHeaderWidgetState createState() => __MyHeaderWidgetState();
}

class __MyHeaderWidgetState extends State<_MyHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.viewAllClicked();
      },
      child: Padding(
        padding: const EdgeInsets.only(
            top: PsDimens.space20,
            left: PsDimens.space16,
            right: PsDimens.space16,
            bottom: PsDimens.space10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: Text(widget.headerName,
                  style: Theme.of(context).textTheme.headline6.copyWith(
                      fontWeight: FontWeight.bold,
                      color: PsColors.textPrimaryDarkColor)),
            ),
            Text(
              Utils.getString(context, 'dashboard__view_all'),
              textAlign: TextAlign.start,
              style: Theme.of(context)
                  .textTheme
                  .caption
                  .copyWith(color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
