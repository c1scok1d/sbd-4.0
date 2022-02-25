import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:businesslistingapi/api/common/ps_resource.dart';
import 'package:businesslistingapi/api/common/ps_status.dart';
import 'package:businesslistingapi/config/ps_colors.dart';
import 'package:businesslistingapi/constant/ps_constants.dart';
import 'package:businesslistingapi/constant/ps_dimens.dart';
import 'package:businesslistingapi/constant/route_paths.dart';
import 'package:businesslistingapi/provider/app_info/app_info_provider.dart';
import 'package:businesslistingapi/provider/history/history_provider.dart';
import 'package:businesslistingapi/provider/item/favourite_item_provider.dart';
import 'package:businesslistingapi/provider/item/item_provider.dart';
import 'package:businesslistingapi/provider/item/related_item_provider.dart';
import 'package:businesslistingapi/provider/item/touch_count_provider.dart';
import 'package:businesslistingapi/repository/app_info_repository.dart';
import 'package:businesslistingapi/repository/history_repsitory.dart';
import 'package:businesslistingapi/repository/item_repository.dart';
import 'package:businesslistingapi/ui/common/base/ps_widget_with_multi_provider.dart';
import 'package:businesslistingapi/ui/common/dialog/choose_payment_type_dialog.dart';
import 'package:businesslistingapi/ui/common/ps_back_button_with_circle_bg_widget.dart';
import 'package:businesslistingapi/ui/common/ps_button_widget.dart';
import 'package:businesslistingapi/ui/common/ps_expansion_tile.dart';
import 'package:businesslistingapi/ui/common/ps_hero.dart';
import 'package:businesslistingapi/ui/common/ps_ui_widget.dart';
import 'package:businesslistingapi/ui/common/dialog/error_dialog.dart';
import 'package:businesslistingapi/ui/common/smooth_star_rating_widget.dart';
import 'package:businesslistingapi/ui/items/detail/views/category_tile_view.dart';
import 'package:businesslistingapi/ui/items/detail/views/contact_info_tile_view.dart';
import 'package:businesslistingapi/ui/items/detail/views/location_title_view.dart';
import 'package:businesslistingapi/ui/items/detail/views/related_tags_tile_view.dart';
import 'package:businesslistingapi/ui/items/detail/views/static_tile_view.dart';
import 'package:businesslistingapi/ui/items/detail/views/what_you_get_tile_view.dart';
import 'package:businesslistingapi/ui/rating/entry/rating_input_dialog.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:businesslistingapi/viewobject/basket_selected_attribute.dart';
import 'package:businesslistingapi/viewobject/common/ps_value_holder.dart';
import 'package:businesslistingapi/viewobject/holder/favourite_parameter_holder.dart';
import 'package:businesslistingapi/viewobject/holder/touch_count_parameter_holder.dart';
import 'package:businesslistingapi/viewobject/item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import 'views/terms_and_policy_tile_view.dart';

class ItemDetailView extends StatefulWidget {
  const ItemDetailView({
    @required this.itemId,
    this.heroTagImage,
    this.heroTagTitle,
    this.heroTagOriginalPrice,
    this.heroTagUnitPrice,
    this.intentId,
    this.intentQty,
    this.intentSelectedColorId,
    this.intentSelectedColorValue,
    this.intentBasketPrice,
    this.intentBasketSelectedAttributeList,
  });

  final String intentId;
  final String intentBasketPrice;
  final List<BasketSelectedAttribute> intentBasketSelectedAttributeList;
  final String intentSelectedColorId;
  final String intentSelectedColorValue;
  final String itemId;
  final String intentQty;
  final String heroTagImage;
  final String heroTagTitle;
  final String heroTagOriginalPrice;
  final String heroTagUnitPrice;
  @override
  _ItemDetailState createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetailView>
    with SingleTickerProviderStateMixin {
  ItemRepository itemRepo;
  ItemRepository relatedItemRepo;
  HistoryRepository historyRepo;
  HistoryProvider historyProvider;
  TouchCountProvider touchCountProvider;
  AppInfoProvider appInfoProvider;
  AppInfoRepository appInfoRepository;
  PsValueHolder psValueHolder;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 50),
    );
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  List<Item> basketList = <Item>[];
  bool isReadyToShowAppBarIcons = false;
  ItemDetailProvider itemDetailProvider;
  RelatedItemProvider relatedItemProvider;
  bool isCallFirstTime = true;

  @override
  Widget build(BuildContext context) {
    print('****** Building *********');
    if (!isReadyToShowAppBarIcons) {
      Timer(const Duration(milliseconds: 800), () {
        setState(() {
          isReadyToShowAppBarIcons = true;
        });
      });
    }

    psValueHolder = Provider.of<PsValueHolder>(context);
    itemRepo = Provider.of<ItemRepository>(context);
    relatedItemRepo = Provider.of<ItemRepository>(context);
    historyRepo = Provider.of<HistoryRepository>(context);
    appInfoRepository = Provider.of<AppInfoRepository>(context);

    return PsWidgetWithMultiProvider(
        child: MultiProvider(
            providers: <SingleChildWidget>[
          ChangeNotifierProvider<ItemDetailProvider>(
            lazy: false,
            create: (BuildContext context) {
              itemDetailProvider = ItemDetailProvider(
                  repo: itemRepo, psValueHolder: psValueHolder);

              final String loginUserId = Utils.checkUserLoginId(psValueHolder);
              itemDetailProvider.loadItem(widget.itemId, loginUserId);

              return itemDetailProvider;
            },
          ),
          ChangeNotifierProvider<RelatedItemProvider>(
            lazy: false,
            create: (BuildContext context) {
              relatedItemProvider = RelatedItemProvider(
                  repo: relatedItemRepo, psValueHolder: psValueHolder);

              return relatedItemProvider;
            },
          ),
          ChangeNotifierProvider<HistoryProvider>(
            lazy: false,
            create: (BuildContext context) {
              historyProvider = HistoryProvider(repo: historyRepo);
              return historyProvider;
            },
          ),
          ChangeNotifierProvider<TouchCountProvider>(
            lazy: false,
            create: (BuildContext context) {
              touchCountProvider = TouchCountProvider(
                  repo: itemRepo, psValueHolder: psValueHolder);
              final String loginUserId = Utils.checkUserLoginId(psValueHolder);

              final TouchCountParameterHolder touchCountParameterHolder =
                  TouchCountParameterHolder(
                      typeId: widget.itemId,
                      typeName: PsConst.FILTERING_TYPE_NAME_PRODUCT,
                      userId: loginUserId);
              touchCountProvider
                  .postTouchCount(touchCountParameterHolder.toMap());
              return touchCountProvider;
            },
          ),
          ChangeNotifierProvider<AppInfoProvider>(
              lazy: false,
              create: (BuildContext context) {
                appInfoProvider = AppInfoProvider(
                    repo: appInfoRepository, psValueHolder: psValueHolder);

                appInfoProvider.loadDeleteHistorywithNotifier();

                return appInfoProvider;
              }),
        ],
            child: Consumer<ItemDetailProvider>(
              builder: (BuildContext context, ItemDetailProvider provider,
                  Widget child) {
                if (provider != null &&
                    provider.itemDetail != null &&
                    provider.itemDetail.data != null) {
                  final List<IconData> icons = provider
                                  .itemDetail.data.phone1 ==
                              '' &&
                          provider.itemDetail.data.messenger == '' &&
                          provider.itemDetail.data.whatsapp == ''
                      ? <IconData>[]
                      : provider.itemDetail.data.phone1 == '' &&
                              provider.itemDetail.data.messenger == ''
                          ? <IconData>[
                              FontAwesome.whatsapp,
                            ]
                          : provider.itemDetail.data.phone1 == '' &&
                                  provider.itemDetail.data.whatsapp == ''
                              ? <IconData>[
                                  MaterialCommunityIcons.facebook_messenger,
                                ]
                              : provider.itemDetail.data.messenger == '' &&
                                      provider.itemDetail.data.whatsapp == ''
                                  ? <IconData>[
                                      Feather.phone,
                                    ]
                                  : provider.itemDetail.data.phone1 == ''
                                      ? <IconData>[
                                          MaterialCommunityIcons
                                              .facebook_messenger,
                                          FontAwesome.whatsapp,
                                        ]
                                      : provider.itemDetail.data.messenger == ''
                                          ? <IconData>[
                                              FontAwesome.whatsapp,
                                              Feather.phone,
                                            ]
                                          : itemDetailProvider.itemDetail.data
                                                      .whatsapp ==
                                                  ''
                                              ? <IconData>[
                                                  MaterialCommunityIcons
                                                      .facebook_messenger,
                                                  Feather.phone,
                                                ]
                                              : <IconData>[
                                                  MaterialCommunityIcons
                                                      .facebook_messenger,
                                                  FontAwesome.whatsapp,
                                                  Feather.phone,
                                                ];

                  final List<String> iconsLabel = provider
                                  .itemDetail.data.phone1 ==
                              '' &&
                          provider.itemDetail.data.messenger == '' &&
                          provider.itemDetail.data.whatsapp == ''
                      ? <String>[]
                      : provider.itemDetail.data.phone1 == '' &&
                              provider.itemDetail.data.messenger == ''
                          ? <String>[
                              Utils.getString(context, 'item_detail__whatsapp'),
                            ]
                          : provider.itemDetail.data.phone1 == '' &&
                                  provider.itemDetail.data.whatsapp ==
                                      ''
                              ? <String>[
                                  Utils.getString(
                                      context, 'item_detail__messenger')
                                ]
                              : provider.itemDetail.data.messenger ==
                                          '' &&
                                      provider
                                              .itemDetail.data.whatsapp ==
                                          ''
                                  ? <String>[
                                      Utils.getString(
                                          context, 'item_detail__call_phone')
                                    ]
                                  : provider.itemDetail.data.phone1 ==
                                          ''
                                      ? <String>[
                                          Utils.getString(context,
                                              'item_detail__messenger'),
                                          Utils.getString(
                                              context, 'item_detail__whatsapp')
                                        ]
                                      : provider
                                                  .itemDetail.data.messenger ==
                                              ''
                                          ? <String>[
                                              Utils.getString(context,
                                                  'item_detail__whatsapp'),
                                              Utils.getString(context,
                                                  'item_detail__call_phone')
                                            ]
                                          : provider.itemDetail.data
                                                      .whatsapp ==
                                                  ''
                                              ? <String>[
                                                  Utils.getString(context,
                                                      'item_detail__messenger'),
                                                  Utils.getString(context,
                                                      'item_detail__call_phone')
                                                ]
                                              : <String>[
                                                  Utils.getString(context,
                                                      'item_detail__messenger'),
                                                  Utils.getString(context,
                                                      'item_detail__whatsapp'),
                                                  Utils.getString(context,
                                                      'item_detail__call_phone')
                                                ];

                  if (isCallFirstTime) {
                    relatedItemProvider.loadRelatedItemList(
                      widget.itemId,
                      provider.itemDetail.data.catId,
                    );

                    ///
                    /// Add to History
                    ///
                    historyProvider.addHistoryList(provider.itemDetail.data);
                    isCallFirstTime = false;
                  }
                  print(
                      'detail : latest ${provider.itemDetail.data.defaultPhoto.imgId}');
                  return Stack(
                    children: <Widget>[
                      CustomScrollView(slivers: <Widget>[
                        SliverAppBar(
                          automaticallyImplyLeading: true,
                          systemOverlayStyle: SystemUiOverlayStyle(
                            statusBarIconBrightness: Utils.getBrightnessForAppBar(context),
                          ),
                          expandedHeight: PsDimens.space300,
                          iconTheme: Theme.of(context)
                              .iconTheme
                              .copyWith(color: PsColors.mainColorWithWhite),
                          leading: PsBackButtonWithCircleBgWidget(
                            isReadyToShow: isReadyToShowAppBarIcons,
                          ),
                          actions: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(
                                  left: PsDimens.space12,
                                  right: PsDimens.space4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: PsColors.black.withAlpha(100),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      right: PsDimens.space8,
                                      left: PsDimens.space8),
                                  child: InkWell(
                                      child: Icon(
                                        Icons.share,
                                        color: PsColors.white,
                                      ),
                                      onTap: () async {
                                        final Size size =
                                            MediaQuery.of(context).size;
                                        if (provider
                                                .itemDetail.data.dynamicLink !=
                                            null) {
                                          Share.share(
                                            'Go to App:\n' +
                                                provider.itemDetail.data
                                                    .dynamicLink,
                                            // +'Image:\n' + PsConfig.ps_app_image_url + itemImage,
                                            sharePositionOrigin: Rect.fromLTWH(
                                                0,
                                                0,
                                                size.width,
                                                size.height / 2),
                                          );
                                        }
                                      }),
                                ),
                              ),
                            ),
                          ],
                          floating: false,
                          pinned: false,
                          stretch: true,
                          backgroundColor: PsColors.mainColorWithBlack,
                          flexibleSpace: FlexibleSpaceBar(
                            background: Container(
                              color: PsColors.backgroundColor,
                              child: Stack(
                                alignment: Alignment.bottomRight,
                                children: <Widget>[
                                  PsNetworkImage(
                                    photoKey: '',
                                    defaultPhoto:
                                        provider.itemDetail.data.defaultPhoto,
                                    width: double.infinity,
                                    boxfit: BoxFit.cover,
                                    // height: MediaQuery.of(context).size.height,
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, RoutePaths.galleryGrid,
                                          arguments: provider.itemDetail.data);
                                    },
                                  ),
                                  if (provider.itemDetail.data.addedUserId ==
                                      provider.psValueHolder.loginUserId)
                                    Padding(
                                      padding:
                                          const EdgeInsets.all(PsDimens.space8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          if (provider
                                                  .itemDetail.data.paidStatus ==
                                              PsConst.ADSPROGRESS  && 
                                             provider.itemDetail.data
                                                      .addedUserId ==
                                                  provider.psValueHolder
                                                      .loginUserId)
                                            Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          PsDimens.space4),
                                                  color: PsColors.paidAdsColor),
                                              padding: const EdgeInsets.all(
                                                  PsDimens.space12),
                                              child: Text(
                                                Utils.getString(context,
                                                    'paid__ads_in_progress'),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .copyWith(
                                                        color: PsColors.white),
                                              ),
                                            )
                                          else if (provider.itemDetail.data
                                                      .paidStatus ==
                                                  PsConst.ADSFINISHED &&
                                              provider.itemDetail.data
                                                      .addedUserId ==
                                                  provider.psValueHolder
                                                      .loginUserId)
                                            Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          PsDimens.space4),
                                                  color: PsColors.black),
                                              padding: const EdgeInsets.all(
                                                  PsDimens.space12),
                                              child: Text(
                                                Utils.getString(context,
                                                    'paid__ads_in_completed'),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .copyWith(
                                                        color: PsColors.white),
                                              ),
                                            )
                                          else if (provider
                                                  .itemDetail.data.paidStatus ==
                                              PsConst.ADSNOTYETSTART)
                                            Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          PsDimens.space4),
                                                  color: Colors.yellow),
                                              padding: const EdgeInsets.all(
                                                  PsDimens.space12),
                                              child: Text(
                                                Utils.getString(context,
                                                    'paid__ads_is_not_yet_start'),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .copyWith(
                                                        color: PsColors.white),
                                              ),
                                            )
                                          else
                                            Container(),
                                          InkWell(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          PsDimens.space4),
                                                  color: Colors.black45),
                                              padding: const EdgeInsets.all(
                                                  PsDimens.space12),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Icon(
                                                    Ionicons.md_images,
                                                    color: PsColors.white,
                                                  ),
                                                  const SizedBox(
                                                      width: PsDimens.space12),
                                                  Text(
                                                    '${provider.itemDetail.data.imageCount}  ${Utils.getString(context, 'item_detail__photo')}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1
                                                        .copyWith(
                                                            color:
                                                                PsColors.white),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            onTap: () {
                                              Navigator.pushNamed(context,
                                                  RoutePaths.galleryGrid,
                                                  arguments:
                                                      provider.itemDetail.data);
                                            },
                                          ),
                                        ],
                                      ),
                                    )
                                  //  ],
                                  //   ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SliverList(
                          delegate: SliverChildListDelegate(<Widget>[
                            Container(
                              color: PsColors.baseColor,
                              child: Column(children: <Widget>[
                                _HeaderBoxWidget(
                                    itemDetail: provider,
                                    item: provider.itemDetail.data,
                                    heroTagTitle: widget.heroTagTitle,
                                    heroTagOriginalPrice:
                                        widget.heroTagOriginalPrice,
                                    heroTagUnitPrice: widget.heroTagUnitPrice),
                                StatisticTileView(
                                  itemDetail: provider,
                                ),
                                if (provider.itemDetail.data.addedUserId ==
                                        psValueHolder.loginUserId &&
                                    provider.itemDetail.data.itemStatusId ==
                                        PsConst.ONE &&
                                    (provider.itemDetail.data.paidStatus ==
                                            PsConst.ADSNOTAVAILABLE ||
                                        provider.itemDetail.data.paidStatus ==
                                            PsConst.ADSFINISHED) &&
                                    appInfoProvider.appInfo.data != null &&
                                    !isAllPaymentDisable(appInfoProvider))
                                  PromoteTileView(
                                      item: provider.itemDetail.data,
                                      provider: provider)
                                else
                                  Container(),
                                LocationTileView(
                                    item: provider.itemDetail.data),
                                if (provider
                                        .itemDetail.data.highlightInformation ==
                                    '')
                                  Container()
                                else
                                  TermsAndPolicyTileView(
                                    checkPolicyType: 4,
                                    title: Utils.getString(context,
                                        'item_detail__highlighted_info'),
                                    itemData: provider.itemDetail.data,
                                  ),
                                ContactInfoTileView(
                                  itemDetail: provider,
                                ),
                                if (provider
                                    .itemDetail.data.itemSpecList.isEmpty)
                                  Container()
                                else
                                  WhatYouGetTileView(
                                    itemSpecList:
                                        provider.itemDetail.data.itemSpecList,
                                  ),
                                GiveRatingWidget(
                                  itemDetail: provider,
                                ),
                                CategoryTileView(
                                    itemData: provider.itemDetail.data),
                                if (provider.itemDetail.data.terms == '')
                                  Container()
                                else
                                  TermsAndPolicyTileView(
                                    checkPolicyType: 1,
                                    title: Utils.getString(context,
                                        'item_detail__terms_and_condition'),
                                    itemData: provider.itemDetail.data,
                                  ),
                                if (provider
                                        .itemDetail.data.cancelationPolicy ==
                                    '')
                                  Container()
                                else
                                  TermsAndPolicyTileView(
                                    checkPolicyType: 2,
                                    title: Utils.getString(context,
                                        'item_detail__cancellation_policy'),
                                    itemData: provider.itemDetail.data,
                                  ),
                                if (provider.itemDetail.data.additionalInfo ==
                                    '')
                                  Container()
                                else
                                  TermsAndPolicyTileView(
                                    checkPolicyType: 3,
                                    title: Utils.getString(context,
                                        'item_detail__additional_info'),
                                    itemData: provider.itemDetail.data,
                                  ),
                                // UserCommentTileView(
                                //   itemDetail: provider,
                                // ),
                                RelatedTagsTileView(
                                  itemDetail: provider,
                                ),
                                const SizedBox(
                                  height: PsDimens.space40,
                                ),
                              ]),
                            )
                          ]),
                        )
                      ]),
                      Container(
                        alignment: Alignment.bottomCenter,
                        margin: const EdgeInsets.symmetric(
                            horizontal: PsDimens.space8,
                            vertical: PsDimens.space12),
                        child: _FloatingActionButton(
                          icons: icons,
                          label: iconsLabel,
                          controller: controller,
                          item: provider.itemDetail.data,
                        ),
                      ),
                    ],
                  );
                } else {
                  return Container();
                }
              },
            )));
  }
}

class PromoteTileView extends StatefulWidget {
  const PromoteTileView({Key key, @required this.item, @required this.provider})
      : super(key: key);

  final Item item;
  final ItemDetailProvider provider;

  @override
  _PromoteTileViewState createState() => _PromoteTileViewState();
}

class _PromoteTileViewState extends State<PromoteTileView> {
  @override
  Widget build(BuildContext context) {
    final Widget _expansionTileTitleWidget = Text(
        Utils.getString(context, 'item_detail__promote_your_item'),
        style: Theme.of(context).textTheme.subtitle1);

    final Widget _expansionTileLeadingIconWidget =
        Icon(Ionicons.ios_megaphone, color: PsColors.mainColor);

    return Consumer<AppInfoProvider>(builder:
        (BuildContext context, AppInfoProvider appInfoprovider, Widget child) {
      if (appInfoprovider.appInfo.data == null) {
        return Container();
      } else {
        return Container(
          margin: const EdgeInsets.only(
              left: PsDimens.space12,
              right: PsDimens.space12,
              bottom: PsDimens.space12),
          decoration: BoxDecoration(
            color: PsColors.backgroundColor,
            border: Border.all(color: PsColors.grey, width: 0.3),
            borderRadius:
                const BorderRadius.all(Radius.circular(PsDimens.space8)),
          ),
          child: PsExpansionTile(
            initiallyExpanded: true,
            leading: _expansionTileLeadingIconWidget,
            title: _expansionTileTitleWidget,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Divider(
                    height: PsDimens.space1,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(PsDimens.space12),
                    child: Text(Utils.getString(
                        context, 'item_detail__promote_sub_title')),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: PsDimens.space12,
                        right: PsDimens.space12,
                        bottom: PsDimens.space12),
                    child: Text(
                        Utils.getString(
                            context, 'item_detail__promote_description'),
                        style: Theme.of(context).textTheme.bodyText1),
                  ),
                  Container(
                      padding: const EdgeInsets.only(
                          left: PsDimens.space12, right: PsDimens.space12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          SizedBox(
                              width: PsDimens.space220,
                              child: PSButtonWithIconWidget(
                                  hasShadow: false,
                                  width: double.infinity,
                                  icon: Ionicons.ios_megaphone,
                                  titleText: Utils.getString(
                                      context, 'item_detail__promote'),
                                  onPressed: () async {
                                    if (appInfoprovider.appInfo.data
                                              .inAppPurchasedEnabled ==
                                            PsConst.ONE &&
                                        appInfoprovider.appInfo.data.stripeEnable ==
                                            PsConst.ZERO &&
                                        appInfoprovider.appInfo.data.paypalEnable ==
                                            PsConst.ZERO &&
                                        appInfoprovider
                                                .appInfo.data.payStackEnable ==
                                            PsConst.ZERO &&
                                        appInfoprovider.appInfo.data.razorEnable ==
                                            PsConst.ZERO) {
                                      // InAppPurchase View
                                      final dynamic returnData =
                                        await Navigator.pushNamed(
                                            context, RoutePaths.inAppPurchase,
                                            arguments: <String, dynamic>{
                                          'itemId': widget.item.id,
                                          'appInfo': appInfoprovider.appInfo.data
                                        });
                                      if (returnData == true ||
                                          returnData == null) {
                                        final String loginUserId =
                                            Utils.checkUserLoginId(
                                                widget.provider.psValueHolder);
                                        widget.provider.loadItem(
                                            widget.item.id, loginUserId);
                                        }
                                    } else if (appInfoprovider
                                            .appInfo.data.inAppPurchasedEnabled ==
                                          PsConst.ZERO) {
                                        //Original Item Promote View
                                        final dynamic returnData =
                                            await Navigator.pushNamed(
                                                context, RoutePaths.itemPromote,
                                                arguments: widget.item);
                                        if (returnData == true ||
                                            returnData == null) {
                                          final String loginUserId =
                                              Utils.checkUserLoginId(
                                                  widget.provider.psValueHolder);
                                          widget.provider.loadItem(
                                              widget.item.id, loginUserId);
                                        }
                                    } else {
                                      //choose payment
                                      showDialog<dynamic>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return ChoosePaymentTypeDialog(
                                              onInAppPurchaseTap: () async {
                                                final dynamic returnData =
                                                    await Navigator.pushNamed(
                                                        context,
                                                        RoutePaths.inAppPurchase,
                                                        arguments: <String,
                                                            dynamic>{
                                                      'itemId':
                                                          widget.item.id,
                                                      'appInfo': appInfoprovider
                                                          .appInfo.data
                                                    });
                                                if (returnData == true ||
                                                    returnData == null) {
                                                  final String loginUserId =
                                                      Utils.checkUserLoginId(widget
                                                          .provider.psValueHolder);
                                                  widget.provider.loadItem(
                                                      widget.item.id,
                                                      loginUserId);
                                                }
                                              },
                                              onOtherPaymentTap: () async {
                                                final dynamic returnData =
                                                    await Navigator.pushNamed(
                                                        context,
                                                        RoutePaths.itemPromote,
                                                        arguments: widget.item);
                                                if (returnData == true ||
                                                    returnData == null) {
                                                  final String loginUserId =
                                                      Utils.checkUserLoginId(widget
                                                          .provider.psValueHolder);
                                                  widget.provider.loadItem(
                                                      widget.item.id,
                                                      loginUserId);
                                                }
                                            },
                                          );
                                        }
                                      );
                                    }  
                                  }
                                )
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: PsDimens.space8),
                                child: Image.asset(
                                  'assets/images/baseline_promotion_color_74.png',
                                  width: PsDimens.space80,
                                  height: PsDimens.space80,
                            ),
                          ),
                        ],
                      )
                    )
                ],
              ),
            ],
          ),
        );
      }
    });
  }
}

class GiveRatingWidget extends StatefulWidget {
  const GiveRatingWidget({@required this.itemDetail});
  final ItemDetailProvider itemDetail;
  @override
  _GiveRatingWidgetState createState() => _GiveRatingWidgetState();
}

class _GiveRatingWidgetState extends State<GiveRatingWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(
          left: PsDimens.space12,
          right: PsDimens.space12,
          bottom: PsDimens.space16),
      padding: const EdgeInsets.all(PsDimens.space16),
      decoration: BoxDecoration(
          color: Colors.lightGreen[100],
          border: Border.all(color: PsColors.grey, width: 0.3),
          borderRadius: BorderRadius.circular(PsDimens.space8)),
      child: Column(
        children: <Widget>[
          Text(
            Utils.getString(context, 'give_rating__title'),
            style: Theme.of(context).textTheme.headline6,
          ),
          const SizedBox(height: PsDimens.space16),
          InkWell(
            onTap: () async {
              if (await Utils.checkInternetConnectivity()) {
                Utils.navigateOnUserVerificationView(context, () async {
                  await showDialog<dynamic>(
                      context: context,
                      builder: (BuildContext context) {
                        return RatingInputDialog(
                          itemprovider: widget.itemDetail,
                          checkType: true,
                        );
                      });
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
            child: SmoothStarRating(
                key: const Key('0.0'),
                rating: 0.0,
                allowHalfRating: false,
                starCount: 5,
                isReadOnly: true,
                size: PsDimens.space52,
                color: PsColors.ratingColor,
                borderColor: Utils.isLightMode(context)
                    ? PsColors.black.withAlpha(100)
                    : PsColors.white,
                onRated: (double v) async {},
                spacing: 0.0),
          ),
          const SizedBox(height: PsDimens.space20),
          Text(
            Utils.getString(context, 'give_rating__description'),
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ],
      ),
    );
  }
}

dynamic isAllPaymentDisable(AppInfoProvider appInfoProvider) {
  if (appInfoProvider.appInfo.data.inAppPurchasedEnabled == PsConst.ZERO &&
      appInfoProvider.appInfo.data.stripeEnable == PsConst.ZERO &&
      appInfoProvider.appInfo.data.paypalEnable == PsConst.ZERO &&
      appInfoProvider.appInfo.data.payStackEnable == PsConst.ZERO &&
      appInfoProvider.appInfo.data.razorEnable == PsConst.ZERO ) {
    return true;
  } else {
    return false;
  }
}

class _HeaderBoxWidget extends StatefulWidget {
  const _HeaderBoxWidget(
      {Key key,
      @required this.itemDetail,
      @required this.item,
      @required this.heroTagTitle,
      @required this.heroTagOriginalPrice,
      @required this.heroTagUnitPrice})
      : super(key: key);

  final ItemDetailProvider itemDetail;
  final Item item;
  final String heroTagTitle;
  final String heroTagOriginalPrice;
  final String heroTagUnitPrice;

  @override
  __HeaderBoxWidgetState createState() => __HeaderBoxWidgetState();
}

class __HeaderBoxWidgetState extends State<_HeaderBoxWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.item != null &&
        widget.itemDetail != null &&
        widget.itemDetail.itemDetail != null &&
        widget.itemDetail.itemDetail.data != null) {
      return Container(
        margin: const EdgeInsets.all(PsDimens.space12),
        decoration: BoxDecoration(
          color: PsColors.backgroundColor,
          borderRadius:
              const BorderRadius.all(Radius.circular(PsDimens.space8)),
        ),
        child: Column(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(PsDimens.space16),
                child: Column(
                  children: <Widget>[
                    _FavouriteWidget(
                        itemDetail: widget.itemDetail,
                        item: widget.item,
                        heroTagTitle: widget.heroTagTitle),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: PsDimens.space16,
                      ),
                      child: _HeaderRatingWidget(
                        itemDetail: widget.itemDetail,
                      ),
                    ),
                  ],
                )),
            if (widget.itemDetail.itemDetail.data.description != '')
              Container(
                margin: const EdgeInsets.only(
                    left: PsDimens.space20,
                    right: PsDimens.space20,
                    bottom: PsDimens.space8),
                child: Text(
                  widget.itemDetail.itemDetail.data.description ?? '',
                  maxLines: 4,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(letterSpacing: 0.8, fontSize: 16, height: 1.6),
                ),
              )
            else
              Container(),
            if (widget.itemDetail.itemDetail.data.description != '')
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, RoutePaths.descriptionDetail,
                      arguments: widget.itemDetail.itemDetail.data);
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: PsDimens.space12, bottom: PsDimens.space20),
                  child: Text(
                    Utils.getString(context, 'item_detail__read_more'),
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(color: PsColors.mainColor),
                  ),
                ),
              )
            else
              Container(),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}

class _FavouriteWidget extends StatefulWidget {
  const _FavouriteWidget(
      {Key key,
      @required this.itemDetail,
      @required this.item,
      @required this.heroTagTitle})
      : super(key: key);

  final ItemDetailProvider itemDetail;
  final Item item;
  final String heroTagTitle;

  @override
  __FavouriteWidgetState createState() => __FavouriteWidgetState();
}

class __FavouriteWidgetState extends State<_FavouriteWidget> {
  Widget icon;
  ItemRepository favouriteRepo;
  PsValueHolder psValueHolder;

  @override
  Widget build(BuildContext context) {
    favouriteRepo = Provider.of<ItemRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    if (widget.item != null &&
        widget.itemDetail != null &&
        widget.itemDetail.itemDetail != null &&
        widget.itemDetail.itemDetail.data != null &&
        widget.itemDetail.itemDetail.data.isFavourited != null) {
      return ChangeNotifierProvider<FavouriteItemProvider>(
          lazy: false,
          create: (BuildContext context) {
            final FavouriteItemProvider provider = FavouriteItemProvider(
                repo: favouriteRepo, psValueHolder: psValueHolder);

            return provider;
          },
          child: Consumer<FavouriteItemProvider>(builder: (BuildContext context,
              FavouriteItemProvider provider, Widget child) {
            return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: PsHero(
                        tag: widget.heroTagTitle,
                        child: Text(
                          widget.itemDetail.itemDetail.data.name ?? '',
                          style: Theme.of(context).textTheme.headline5,
                        )),
                  ),
                  GestureDetector(
                      onTap: () async {
                        if (await Utils.checkInternetConnectivity()) {
                          Utils.navigateOnUserVerificationView(context,
                              () async {
                            if (widget
                                    .itemDetail.itemDetail.data.isFavourited ==
                                '0') {
                              setState(() {
                                widget.itemDetail.itemDetail.data.isFavourited =
                                    '1';
                              });
                            } else {
                              setState(() {
                                widget.itemDetail.itemDetail.data.isFavourited =
                                    '0';
                              });
                            }

                            final FavouriteParameterHolder
                                favouriteParameterHolder =
                                FavouriteParameterHolder(
                              userId: provider.psValueHolder.loginUserId,
                              itemId: widget.item.id,
                              cityId: widget.item.city.id,
                            );

                            final PsResource<Item> _apiStatus =
                                await provider.postFavourite(
                                    favouriteParameterHolder.toMap());

                            if (_apiStatus.data != null) {
                              if (_apiStatus.status == PsStatus.SUCCESS) {
                                await widget.itemDetail.loadItemForFav(
                                    widget.item.id,
                                    provider.psValueHolder.loginUserId);
                              }
                              if (widget.itemDetail != null &&
                                  widget.itemDetail.itemDetail != null &&
                                  widget.itemDetail.itemDetail.data != null) {
                                if (widget.itemDetail.itemDetail.data
                                        .isFavourited ==
                                    PsConst.ONE) {
                                  icon = Container(
                                    padding: const EdgeInsets.only(
                                        top: PsDimens.space8,
                                        left: PsDimens.space8,
                                        right: PsDimens.space8,
                                        bottom: PsDimens.space6),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: PsColors.mainColor),
                                        shape: BoxShape.circle),
                                    child: Icon(Icons.favorite,
                                        color: PsColors.mainColor),
                                  );
                                } else {
                                  icon = Container(
                                    padding: const EdgeInsets.only(
                                        top: PsDimens.space8,
                                        left: PsDimens.space8,
                                        right: PsDimens.space8,
                                        bottom: PsDimens.space6),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: PsColors.mainColor),
                                        shape: BoxShape.circle),
                                    child: Icon(Icons.favorite_border,
                                        color: PsColors.mainColor),
                                  );
                                }
                              } else {
                                print('There is no comment');
                              }
                            }
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
                      child: widget.itemDetail.itemDetail.data.isFavourited !=
                              null
                          ? widget.itemDetail.itemDetail.data.isFavourited ==
                                  PsConst.ZERO
                              ? icon = Container(
                                  padding: const EdgeInsets.only(
                                      top: PsDimens.space8,
                                      left: PsDimens.space8,
                                      right: PsDimens.space8,
                                      bottom: PsDimens.space6),
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: PsColors.mainColor),
                                      shape: BoxShape.circle),
                                  child: Icon(Icons.favorite_border,
                                      color: PsColors.mainColor),
                                )
                              : icon = Container(
                                  padding: const EdgeInsets.only(
                                      top: PsDimens.space8,
                                      left: PsDimens.space8,
                                      right: PsDimens.space8,
                                      bottom: PsDimens.space6),
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: PsColors.mainColor),
                                      shape: BoxShape.circle),
                                  child: Icon(Icons.favorite,
                                      color: PsColors.mainColor),
                                )
                          : Container())
                ]);
          }));
    } else {
      return Container();
    }
  }
}

class _HeaderRatingWidget extends StatefulWidget {
  const _HeaderRatingWidget({
    Key key,
    @required this.itemDetail,
  }) : super(key: key);

  final ItemDetailProvider itemDetail;

  @override
  __HeaderRatingWidgetState createState() => __HeaderRatingWidgetState();
}

class __HeaderRatingWidgetState extends State<_HeaderRatingWidget> {
  @override
  Widget build(BuildContext context) {
    dynamic result;
    if (widget.itemDetail != null &&
        widget.itemDetail.itemDetail != null &&
        widget.itemDetail.itemDetail.data != null &&
        widget.itemDetail.itemDetail.data.ratingDetail != null) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
            onTap: () async {
              result = await Navigator.pushNamed(context, RoutePaths.ratingList,
                  arguments: widget.itemDetail.itemDetail.data.id);

              if (result != null && result) {
                setState(() {
                  widget.itemDetail.loadItem(
                      widget.itemDetail.itemDetail.data.id,
                      widget.itemDetail.psValueHolder.loginUserId);
                });
              }
              print(
                  'totalRatingValue ${widget.itemDetail.itemDetail.data.ratingDetail.totalRatingValue}');
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SmoothStarRating(
                    key: Key(widget.itemDetail.itemDetail.data.ratingDetail
                        .totalRatingValue),
                    rating: double.parse(widget.itemDetail.itemDetail.data
                        .ratingDetail.totalRatingValue),
                    allowHalfRating: false,
                    isReadOnly: true,
                    starCount: 5,
                    size: PsDimens.space16,
                    color: PsColors.ratingColor,
                    borderColor: Utils.isLightMode(context)
                        ? PsColors.black.withAlpha(100)
                        : PsColors.white,
                    onRated: (double v) async {},
                    spacing: 0.0),
                const SizedBox(
                  height: PsDimens.space10,
                ),
                GestureDetector(
                    onTap: () async {
                      result = await Navigator.pushNamed(
                          context, RoutePaths.ratingList,
                          arguments: widget.itemDetail.itemDetail.data.id);

                      if (result != null && result) {
                        // setState(() {
                        widget.itemDetail.loadItem(
                            widget.itemDetail.itemDetail.data.id,
                            widget.itemDetail.psValueHolder.loginUserId);
                        // });
                      }
                    },
                    child:
                        (widget.itemDetail.itemDetail.data.overallRating != '0')
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    widget.itemDetail.itemDetail.data
                                            .ratingDetail.totalRatingValue ??
                                        '',
                                    textAlign: TextAlign.left,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(),
                                  ),
                                  const SizedBox(
                                    width: PsDimens.space4,
                                  ),
                                  Text(
                                    '${Utils.getString(context, 'item_detail__out_of_five_stars')}(' +
                                        widget.itemDetail.itemDetail.data
                                            .ratingDetail.totalRatingCount +
                                        ' ${Utils.getString(context, 'item_detail__reviews')})',
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(),
                                  ),
                                ],
                              )
                            : Text(Utils.getString(
                                context, 'item_detail__no_rating'))),
                const SizedBox(
                  height: PsDimens.space10,
                ),
                // if (widget.itemDetail.itemDetail.data.isAvailable == '1')
                //   Text(
                //     Utils.getString(context, 'item_detail__in_stock'),
                //     style: Theme.of(context)
                //         .textTheme
                //         .bodyText2
                //         .copyWith(color: PsColors.mainDarkColor),
                //   )
                // else
                //   Container(),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                if (widget.itemDetail.itemDetail.data.isFeatured == '0')
                  Container()
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Image.asset(
                        'assets/images/baseline_feature_circle_24.png',
                        width: PsDimens.space32,
                        height: PsDimens.space32,
                      ),
                      const SizedBox(
                        width: PsDimens.space8,
                      ),
                      Text(
                        Utils.getString(context, 'item_detail__featured_items'),
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              color: PsColors.mainColor,
                            ),
                      ),
                    ],
                  ),
                const SizedBox(
                  height: PsDimens.space8,
                ),
                // Text(
                //   widget.itemDetail.itemDetail.data.code ?? '',
                //   style: Theme.of(context)
                //       .textTheme
                //       .bodyText2
                //       .copyWith(color: PsColors.mainDarkColor),
                // ),
              ],
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}

class _FloatingActionButton extends StatefulWidget {
  const _FloatingActionButton({
    Key key,
    @required this.controller,
    @required this.icons,
    @required this.label,
    @required this.item,
  }) : super(key: key);

  final AnimationController controller;
  final List<IconData> icons;
  final List<String> label;
  final Item item;
  @override
  __FloatingActionButtonState createState() => __FloatingActionButtonState();
}

class __FloatingActionButtonState extends State<_FloatingActionButton> {
  @override
  Widget build(BuildContext context) {
    final String whatsappUrl = 'https://wa.me/${widget.item.whatsapp}';
    final String messengerUrl = 'http://m.me/${widget.item.messenger}';
    final String phoneCall = 'tel://${widget.item.phone1}';

    if (widget.icons.isNotEmpty && widget.label.isNotEmpty) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List<Widget>.generate(widget.icons.length, (int index) {
          Widget _getChip() {
            return Chip(
              backgroundColor: PsColors.mainColor,
              label: InkWell(
                onTap: () async {
                  print(index);

                  if (await canLaunch(index == 0
                      ? messengerUrl
                      : index == 1
                          ? whatsappUrl
                          : phoneCall)) {
                    await launch(
                        index == 0
                            ? messengerUrl
                            : index == 1
                                ? whatsappUrl
                                : phoneCall,
                        forceSafariVC: false);
                  } else {
                    throw whatsappUrl;
                  }
                },
                child: Text(
                  widget.label[index],
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: PsColors.white,
                  ),
                ),
              ),
            );
          }

          final Widget child = Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.symmetric(horizontal: PsDimens.space8),
                child: ScaleTransition(
                  scale: CurvedAnimation(
                    parent: widget.controller,
                    curve:
                        Interval((index + 1) / 10, 1.0, curve: Curves.easeIn),
                  ),
                  child: _getChip(),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: PsDimens.space4, vertical: PsDimens.space2),
                child: ScaleTransition(
                  scale: CurvedAnimation(
                    parent: widget.controller,
                    curve: Interval(
                        0.0, 1.0 - index / widget.icons.length / 2.0,
                        curve: Curves.easeIn),
                  ),
                  child: FloatingActionButton(
                    heroTag: widget.label[index],
                    backgroundColor: PsColors.mainColor,
                    mini: true,
                    child: Icon(widget.icons[index], color: PsColors.white),
                    onPressed: () async {
                      print(index);
                      if (await canLaunch(index == 0
                          ? messengerUrl
                          : index == 1
                              ? whatsappUrl
                              : phoneCall)) {
                        await launch(
                            index == 0
                                ? messengerUrl
                                : index == 1
                                    ? whatsappUrl
                                    : phoneCall,
                            forceSafariVC: false);
                      } else {
                        throw whatsappUrl;
                      }
                    },
                  ),
                ),
              ),
            ],
          );
          return child;
        }).toList()
          ..add(
            Container(
              margin: const EdgeInsets.only(top: PsDimens.space8),
              child: FloatingActionButton(
                backgroundColor: PsColors.mainColor,
                child: AnimatedBuilder(
                  animation: widget.controller,
                  child: Icon(
                    widget.controller.isDismissed ? Icons.sms : Icons.sms,
                    color: PsColors.white,
                  ),
                  builder: (BuildContext context, Widget child) {
                    return Transform(
                      transform:
                          Matrix4.rotationZ(widget.controller.value * 0.5 * 8),
                      alignment: FractionalOffset.center,
                      child: child,
                    );
                  },
                ),
                onPressed: () {
                  if (widget.controller.isDismissed) {
                    widget.controller.forward();
                  } else {
                    widget.controller.reverse();
                  }
                },
              ),
            ),
          ),
      );
    } else {
      return Container();
    }
  }
}
