import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:businesslistingapi/config/ps_colors.dart';
import 'package:businesslistingapi/config/ps_config.dart';
import 'package:businesslistingapi/constant/ps_constants.dart';
import 'package:businesslistingapi/constant/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:businesslistingapi/ui/common/dialog/filter_dialog.dart';
import 'package:businesslistingapi/ui/subcategory/item/sub_category_grid_item.dart';
import 'package:businesslistingapi/viewobject/common/ps_value_holder.dart';
import 'package:businesslistingapi/viewobject/holder/intent_holder/item_list_intent_holder.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:shimmer/shimmer.dart';
import 'package:businesslistingapi/api/common/ps_status.dart';
import 'package:businesslistingapi/constant/ps_dimens.dart';
import 'package:businesslistingapi/provider/subcategory/sub_category_provider.dart';
import 'package:businesslistingapi/repository/sub_category_repository.dart';
import 'package:businesslistingapi/ui/common/ps_ui_widget.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:businesslistingapi/viewobject/category.dart';

class SubCategoryGridView extends StatefulWidget {
  const SubCategoryGridView({this.category});
  final Category category;
  @override
  _SubCategoryGridViewState createState() {
    return _SubCategoryGridViewState();
  }
}

class _SubCategoryGridViewState extends State<SubCategoryGridView>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  SubCategoryProvider _subCategoryProvider;

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
        final String categId = widget.category.id;
        Utils.psPrint('CategoryId number is $categId');
        _subCategoryProvider.nextSubCategoryList(
            _subCategoryProvider.subCategoryParameterHolder.toMap(),
            Utils.checkUserLoginId(valueHolder),
            widget.category.id);
      }
    });
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    super.initState();
  }

  SubCategoryRepository repo1;
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
    if (!isConnectedToInternet && PsConfig.showAdMob) {
      print('loading ads....');
      checkConnection();
    }
    timeDilation = 1.0;
    repo1 = Provider.of<SubCategoryRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context);

    return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness: Utils.getBrightnessForAppBar(context),
          ),
          iconTheme:
              Theme.of(context).iconTheme.copyWith(color: PsColors.white),
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
                          _subCategoryProvider.subCategoryParameterHolder
                              .orderBy = PsConst.FILTERING_SUBCAT_NAME;
                          _subCategoryProvider.subCategoryParameterHolder
                              .orderType = PsConst.FILTERING__ASC;
                          _subCategoryProvider.resetSubCategoryList(
                            _subCategoryProvider.subCategoryParameterHolder
                                .toMap(),
                            Utils.checkUserLoginId(valueHolder),
                            widget.category.id,
                          );
                        },
                        onDescendingTap: () {
                          _subCategoryProvider.subCategoryParameterHolder
                              .orderBy = PsConst.FILTERING_SUBCAT_NAME;
                          _subCategoryProvider.subCategoryParameterHolder
                              .orderType = PsConst.FILTERING__DESC;
                          _subCategoryProvider.resetSubCategoryList(
                            _subCategoryProvider.subCategoryParameterHolder
                                .toMap(),
                            Utils.checkUserLoginId(valueHolder),
                             widget.category.id,
                          );
                        },
                      );
                    });
              },
            )
          ],
          backgroundColor:
              Utils.isLightMode(context) ? PsColors.mainColor : Colors.black12,
          title: Text(
            widget.category.name,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(color: PsColors.white),
          ),
        ),
        body: ChangeNotifierProvider<SubCategoryProvider>(
            lazy: false,
            create: (BuildContext context) {
              _subCategoryProvider = SubCategoryProvider(repo: repo1);
              _subCategoryProvider.loadSubCategoryList(
                  _subCategoryProvider.subCategoryParameterHolder.toMap(),
                  Utils.checkUserLoginId(valueHolder),
                  widget.category.id);
              return _subCategoryProvider;
            },
            child: Consumer<SubCategoryProvider>(builder: (BuildContext context,
                SubCategoryProvider provider, Widget child) {
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
                          child: RefreshIndicator(
                        onRefresh: () {
                          return provider.resetSubCategoryList(
                              provider.subCategoryParameterHolder.toMap(),
                              Utils.checkUserLoginId(valueHolder),
                              widget.category.id);
                        },
                        child: CustomScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            controller: _scrollController,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            slivers: <Widget>[
                              SliverGrid(
                                gridDelegate:
                                    const SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: 240,
                                        childAspectRatio: 1.4),
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    if (provider.subCategoryList.status ==
                                        PsStatus.BLOCK_LOADING) {
                                      return Shimmer.fromColors(
                                          baseColor: PsColors.grey,
                                          highlightColor: PsColors.white,
                                          child:
                                              Column(children: const <Widget>[
                                            FrameUIForLoading(),
                                            FrameUIForLoading(),
                                            FrameUIForLoading(),
                                            FrameUIForLoading(),
                                            FrameUIForLoading(),
                                            FrameUIForLoading(),
                                          ]));
                                    } else {
                                      final int count =
                                          provider.subCategoryList.data.length;
                                      return SubCategoryGridItem(
                                        subCategory: provider
                                            .subCategoryList.data[index],
                                        onTap: () {
                                          provider
                                              .itemByCategoryIdParamenterHolder
                                              .catId = provider.categoryId;
                                          provider.itemByCategoryIdParamenterHolder
                                                  .subCatId =
                                              provider.subCategoryList
                                                  .data[index].id;
                                          Navigator.pushNamed(context,
                                              RoutePaths.filterItemList,
                                              arguments: ItemListIntentHolder(
                                                  checkPage: '1',
                                                  appBarTitle: provider
                                                      .subCategoryList
                                                      .data[index]
                                                      .name,
                                                  itemParameterHolder: provider
                                                      .itemByCategoryIdParamenterHolder));
                                        },
                                        animationController:
                                            animationController,
                                        animation:
                                            Tween<double>(begin: 0.0, end: 1.0)
                                                .animate(CurvedAnimation(
                                          parent: animationController,
                                          curve: Interval(
                                              (1 / count) * index, 1.0,
                                              curve: Curves.fastOutSlowIn),
                                        )),
                                      );
                                    }
                                  },
                                  childCount:
                                      provider.subCategoryList.data.length,
                                ),
                              ),
                            ]),
                      )),
                      PSProgressIndicator(provider.subCategoryList.status)
                    ]),
                  )
                ],
              );
            })));
  }
}

class FrameUIForLoading extends StatelessWidget {
  const FrameUIForLoading({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
            height: 70,
            width: 70,
            margin: const EdgeInsets.all(PsDimens.space16),
            decoration: BoxDecoration(color: PsColors.grey)),
        Expanded(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Container(
              height: 15,
              margin: const EdgeInsets.all(PsDimens.space8),
              decoration: BoxDecoration(color: PsColors.grey)),
          Container(
              height: 15,
              margin: const EdgeInsets.all(PsDimens.space8),
              decoration: BoxDecoration(color: PsColors.grey)),
        ]))
      ],
    );
  }
}
