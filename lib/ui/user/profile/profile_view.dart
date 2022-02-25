import 'package:flutter/rendering.dart';
import 'package:businesslistingapi/api/common/ps_status.dart';
import 'package:businesslistingapi/config/ps_colors.dart';
import 'package:businesslistingapi/constant/ps_constants.dart';
import 'package:businesslistingapi/constant/ps_dimens.dart';
import 'package:businesslistingapi/constant/route_paths.dart';
import 'package:businesslistingapi/provider/item/added_item_provider.dart';
import 'package:businesslistingapi/provider/item/disabled_item_provider.dart';
import 'package:businesslistingapi/provider/item/paid_ad_item_provider.dart';
import 'package:businesslistingapi/provider/item/pending_item_provider.dart';
import 'package:businesslistingapi/provider/item/rejected_item_provider.dart';
import 'package:businesslistingapi/provider/user/user_provider.dart';
import 'package:businesslistingapi/repository/item_repository.dart';
import 'package:businesslistingapi/repository/paid_ad_item_repository.dart';
import 'package:businesslistingapi/repository/user_repository.dart';
import 'package:businesslistingapi/ui/common/dialog/error_dialog.dart';
import 'package:businesslistingapi/ui/common/ps_frame_loading_widget.dart';
import 'package:businesslistingapi/ui/common/ps_ui_widget.dart';
import 'package:businesslistingapi/ui/history/list/history_horizontal_list_view.dart';
import 'package:businesslistingapi/ui/items/item/item_horizontal_list_item.dart';
import 'package:businesslistingapi/ui/paid_ad/paid_ad_item_horizontal_list_item.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:businesslistingapi/viewobject/common/ps_value_holder.dart';
import 'package:flutter/material.dart';
import 'package:businesslistingapi/viewobject/holder/intent_holder/item_detail_intent_holder.dart';
import 'package:businesslistingapi/viewobject/holder/intent_holder/item_entry_intent_holder.dart';
import 'package:businesslistingapi/viewobject/holder/intent_holder/user_item_intent_holder.dart';
import 'package:businesslistingapi/viewobject/holder/item_parameter_holder.dart';
import 'package:businesslistingapi/viewobject/item.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({
    Key key,
    this.animationController,
    @required this.flag,
    this.userId,
    @required this.scaffoldKey,
  }) : super(key: key);

  final AnimationController animationController;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final int flag;
  final String userId;
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

ScrollController scrollController = ScrollController();
AnimationController animationControllerForFab;

class _ProfilePageState extends State<ProfileView>
    with SingleTickerProviderStateMixin {
  UserRepository userRepository;

  @override
  void initState() {
    animationControllerForFab = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this, value: 1);

    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (animationControllerForFab != null) {
          animationControllerForFab.reverse();
        }
      }
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (animationControllerForFab != null) {
          animationControllerForFab.forward();
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.animationController.forward();

    return Scaffold(
      floatingActionButton: FadeTransition(
        opacity: animationControllerForFab,
        child: ScaleTransition(
          scale: animationControllerForFab,
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
      body:
          //  SingleChildScrollView(
          //     child: Container(
          //   color: PsColors.coreBackgroundColor,
          //   height: widget.flag ==
          //           PsConst.REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT
          //       ? MediaQuery.of(context).size.height - 100
          //       : MediaQuery.of(context).size.height - 40,
          //   child:
          CustomScrollView(scrollDirection: Axis.vertical, slivers: <Widget>[
        _ProfileDetailWidget(
          animationController: widget.animationController,
          animation: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: widget.animationController,
              curve:
                  const Interval((1 / 4) * 2, 1.0, curve: Curves.fastOutSlowIn),
            ),
          ),
          userId: widget.userId,
        ),
        // _TransactionListViewWidget(
        //   scaffoldKey: widget.scaffoldKey,
        //   animationController: widget.animationController,
        //   userId: widget.userId,
        // )

        _PaidAdWidget(
          animationController: widget.animationController,
          animation: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: widget.animationController,
              curve:
                  const Interval((1 / 4) * 2, 1.0, curve: Curves.fastOutSlowIn),
            ),
          ),
          userId: widget.userId, //animationController,
        ),

        SliverToBoxAdapter(
            child: HistoryHorizontalListView(
          animationController: widget.animationController,
          animation: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: widget.animationController,
              curve:
                  const Interval((1 / 4) * 2, 1.0, curve: Curves.fastOutSlowIn),
            ),
          ),
        )),
        _ListingDataWidget(
          animationController: widget.animationController,
          userId: widget.userId,
          animation: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: widget.animationController,
              curve:
                  const Interval((1 / 4) * 2, 1.0, curve: Curves.fastOutSlowIn),
            ),
          ),
          headerTitle: Utils.getString(context, 'profile__listing'),
          status: '1', //animationController,
        ),
        _PendingListingDataWidget(
          animationController: widget.animationController,
          userId: widget.userId,
          animation: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: widget.animationController,
              curve:
                  const Interval((1 / 4) * 2, 1.0, curve: Curves.fastOutSlowIn),
            ),
          ),
          headerTitle: Utils.getString(context, 'profile__pending_listing'),
          status: '0', //animationController,
        ),

        _RejectedListingDataWidget(
          animationController: widget.animationController,
          userId: widget.userId,
          animation: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: widget.animationController,
              curve:
                  const Interval((1 / 4) * 2, 1.0, curve: Curves.fastOutSlowIn),
            ),
          ),
          headerTitle: Utils.getString(context, 'profile__rejected_listing'),
          status: '3', //animationController,
        ),
        _DisabledListingDataWidget(
          animationController: widget.animationController,
          userId: widget.userId,
          animation: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: widget.animationController,
              curve:
                  const Interval((1 / 4) * 2, 1.0, curve: Curves.fastOutSlowIn),
            ),
          ),
          headerTitle: Utils.getString(context, 'profile__disable_listing'),
          status: '2', //animationController,
        ),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: PsDimens.space36,
          ),
        )
      ]),
      //)),
    );
  }
}

class _PaidAdWidget extends StatefulWidget {
  const _PaidAdWidget(
      {Key key,
      @required this.animationController,
      this.userId,
      this.animation})
      : super(key: key);

  final AnimationController animationController;
  final String userId;
  final Animation<double> animation;

  @override
  __PaidAdWidgetState createState() => __PaidAdWidgetState();
}

class __PaidAdWidgetState extends State<_PaidAdWidget> {
  PaidAdItemRepository paidAdItemRepository;
  PsValueHolder psValueHolder;
  ItemParameterHolder parameterHolder;

  @override
  Widget build(BuildContext context) {
    paidAdItemRepository = Provider.of<PaidAdItemRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    return SliverToBoxAdapter(
        child: ChangeNotifierProvider<PaidAdItemProvider>(
            lazy: false,
            create: (BuildContext context) {
              final PaidAdItemProvider provider = PaidAdItemProvider(
                  repo: paidAdItemRepository, psValueHolder: psValueHolder);
              if (provider.psValueHolder.loginUserId == null ||
                  provider.psValueHolder.loginUserId == '') {
                provider.loadPaidAdItemList(widget.userId);
              } else {
                provider.loadPaidAdItemList(provider.psValueHolder.loginUserId);
              }

              return provider;
            },
            child: Consumer<PaidAdItemProvider>(builder: (BuildContext context,
                PaidAdItemProvider itemProvider, Widget child) {
              return AnimatedBuilder(
                  animation: widget.animationController,
                  child: (itemProvider.paidAdItemList.data != null &&
                          itemProvider.paidAdItemList.data.isNotEmpty)
                      ? Column(children: <Widget>[
                          _HeaderWidget(
                            headerName:
                                Utils.getString(context, 'profile__paid_ad'),
                            viewAllClicked: () {
                              Navigator.pushNamed(
                                context,
                                RoutePaths.paidAdItemList,
                              );
                            },
                          ),
                          Container(
                              height: 400,
                              width: MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      itemProvider.paidAdItemList.data.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (itemProvider.paidAdItemList.status ==
                                        PsStatus.BLOCK_LOADING) {
                                      return Shimmer.fromColors(
                                          baseColor: Colors.grey[300],
                                          highlightColor: Colors.white,
                                          child: Row(children: const <Widget>[
                                            PsFrameUIForLoading(),
                                          ]));
                                    } else {
                                      return PaidAdItemHorizontalListItem(
                                        paidAdItem: itemProvider
                                            .paidAdItemList.data[index],
                                        onTap: () {
                                          // final Item item = provider.historyList.data.reversed.toList()[index];
                                          final ItemDetailIntentHolder holder =
                                              ItemDetailIntentHolder(
                                                  itemId: itemProvider
                                                      .paidAdItemList
                                                      .data[index]
                                                      .item
                                                      .id,
                                                  heroTagImage: itemProvider
                                                          .hashCode
                                                          .toString() +
                                                      itemProvider
                                                          .paidAdItemList
                                                          .data[index]
                                                          .item
                                                          .id +
                                                      PsConst.HERO_TAG__IMAGE,
                                                  heroTagTitle: itemProvider
                                                          .hashCode
                                                          .toString() +
                                                      itemProvider
                                                          .paidAdItemList
                                                          .data[index]
                                                          .item
                                                          .id +
                                                      PsConst.HERO_TAG__TITLE);
                                          Navigator.pushNamed(
                                              context, RoutePaths.itemDetail,
                                              arguments: holder
                                              // itemProvider
                                              //     .paidAdItemList.data[index].item
                                              );
                                        },
                                      );
                                    }
                                  }))
                        ])
                      : Container(),
                  builder: (BuildContext context, Widget child) {
                    return FadeTransition(
                        opacity: widget.animation,
                        child: Transform(
                            transform: Matrix4.translationValues(
                                0.0, 100 * (1.0 - widget.animation.value), 0.0),
                            child: child));
                  });
            })));
  }
}

class _ListingDataWidget extends StatefulWidget {
  const _ListingDataWidget(
      {Key key,
      @required this.animationController,
      this.userId,
      @required this.headerTitle,
      @required this.status,
      this.animation})
      : super(key: key);

  final AnimationController animationController;
  final String userId;
  final String headerTitle;
  final String status;
  final Animation<double> animation;

  @override
  __ListingDataWidgetState createState() => __ListingDataWidgetState();
}

class __ListingDataWidgetState extends State<_ListingDataWidget> {
  ItemRepository itemRepository;

  PsValueHolder psValueHolder;

  @override
  Widget build(BuildContext context) {
    itemRepository = Provider.of<ItemRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    return SliverToBoxAdapter(
        child: ChangeNotifierProvider<AddedItemProvider>(
            lazy: false,
            create: (BuildContext context) {
              final AddedItemProvider provider = AddedItemProvider(
                  repo: itemRepository, psValueHolder: psValueHolder);
              if (provider.psValueHolder.loginUserId == null ||
                  provider.psValueHolder.loginUserId == '') {
                provider.addedUserParameterHolder.addedUserId = widget.userId;
                provider.addedUserParameterHolder.itemStatusId = widget.status;
                provider.loadItemList(
                    widget.userId, provider.addedUserParameterHolder);
              } else {
                provider.addedUserParameterHolder.addedUserId =
                    provider.psValueHolder.loginUserId;
                provider.addedUserParameterHolder.itemStatusId = widget.status;
                provider.loadItemList(provider.psValueHolder.loginUserId,
                    provider.addedUserParameterHolder);
              }

              return provider;
            },
            child: Consumer<AddedItemProvider>(builder: (BuildContext context,
                AddedItemProvider itemProvider, Widget child) {
              return AnimatedBuilder(
                  animation: widget.animationController,
                  child: (itemProvider.itemList.data != null &&
                          itemProvider.itemList.data.isNotEmpty)
                      ? Column(children: <Widget>[
                          _HeaderWidget(
                            headerName: widget.headerTitle,
                            viewAllClicked: () {
                              Navigator.pushNamed(
                                  context, RoutePaths.userItemList,
                                  arguments: UserItemIntentHolder(
                                      userId: itemProvider
                                          .psValueHolder.loginUserId,
                                      status: widget.status,
                                      title: widget.headerTitle));
                            },
                          ),
                          Container(
                              height: PsDimens.space320,
                              width: MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: itemProvider.itemList.data.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (itemProvider.itemList.status ==
                                        PsStatus.BLOCK_LOADING) {
                                      return Shimmer.fromColors(
                                          baseColor: Colors.grey[300],
                                          highlightColor: Colors.white,
                                          child: Row(children: const <Widget>[
                                            PsFrameUIForLoading(),
                                          ]));
                                    } else {
                                      return ItemHorizontalListItem(
                                        item: itemProvider.itemList.data[index],
                                        coreTagKey:
                                            itemProvider.hashCode.toString() +
                                                itemProvider
                                                    .itemList.data[index].id,
                                        onTap: () {
                                          print(itemProvider
                                              .itemList
                                              .data[index]
                                              .defaultPhoto
                                              .imgPath);
                                          final Item item = itemProvider
                                              .itemList.data.reversed
                                              .toList()[index];
                                          final ItemDetailIntentHolder holder =
                                              ItemDetailIntentHolder(
                                                  itemId: item.id,
                                                  heroTagImage: itemProvider
                                                          .hashCode
                                                          .toString() +
                                                      item.id +
                                                      PsConst.HERO_TAG__IMAGE,
                                                  heroTagTitle: itemProvider
                                                          .hashCode
                                                          .toString() +
                                                      item.id +
                                                      PsConst.HERO_TAG__TITLE);
                                          Navigator.pushNamed(
                                              context, RoutePaths.itemDetail,
                                              arguments: holder);
                                        },
                                      );
                                    }
                                  }))
                        ])
                      : Container(),
                  builder: (BuildContext context, Widget child) {
                    return FadeTransition(
                        opacity: widget.animation,
                        child: Transform(
                            transform: Matrix4.translationValues(
                                0.0, 100 * (1.0 - widget.animation.value), 0.0),
                            child: child));
                  });
            })));
  }
}

class _PendingListingDataWidget extends StatefulWidget {
  const _PendingListingDataWidget(
      {Key key,
      @required this.animationController,
      this.userId,
      @required this.headerTitle,
      @required this.status,
      this.animation})
      : super(key: key);

  final AnimationController animationController;
  final String userId;
  final String headerTitle;
  final String status;
  final Animation<double> animation;

  @override
  ___PendingListingDataWidgetState createState() =>
      ___PendingListingDataWidgetState();
}

class ___PendingListingDataWidgetState
    extends State<_PendingListingDataWidget> {
  ItemRepository itemRepository;

  PsValueHolder psValueHolder;

  @override
  Widget build(BuildContext context) {
    itemRepository = Provider.of<ItemRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    return SliverToBoxAdapter(
        child: ChangeNotifierProvider<PendingItemProvider>(
            lazy: false,
            create: (BuildContext context) {
              final PendingItemProvider provider = PendingItemProvider(
                  repo: itemRepository, psValueHolder: psValueHolder);
              if (provider.psValueHolder.loginUserId == null ||
                  provider.psValueHolder.loginUserId == '') {
                provider.addedUserParameterHolder.addedUserId = widget.userId;
                provider.addedUserParameterHolder.itemStatusId = widget.status;
                provider.loadItemList(
                    widget.userId, provider.addedUserParameterHolder);
              } else {
                provider.addedUserParameterHolder.addedUserId =
                    provider.psValueHolder.loginUserId;
                provider.addedUserParameterHolder.itemStatusId = widget.status;
                provider.loadItemList(provider.psValueHolder.loginUserId,
                    provider.addedUserParameterHolder);
              }

              return provider;
            },
            child: Consumer<PendingItemProvider>(builder: (BuildContext context,
                PendingItemProvider itemProvider, Widget child) {
              return AnimatedBuilder(
                  animation: widget.animationController,
                  child: (itemProvider.itemList.data != null &&
                          itemProvider.itemList.data.isNotEmpty)
                      ? Column(children: <Widget>[
                          _HeaderWidget(
                            headerName: widget.headerTitle,
                            viewAllClicked: () {
                              Navigator.pushNamed(
                                  context, RoutePaths.userItemList,
                                  arguments: UserItemIntentHolder(
                                      userId: itemProvider
                                          .psValueHolder.loginUserId,
                                      status: widget.status,
                                      title: widget.headerTitle));
                            },
                          ),
                          Container(
                              height: PsDimens.space320,
                              width: MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: itemProvider.itemList.data.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (itemProvider.itemList.status ==
                                        PsStatus.BLOCK_LOADING) {
                                      return Shimmer.fromColors(
                                          baseColor: Colors.grey[300],
                                          highlightColor: Colors.white,
                                          child: Row(children: const <Widget>[
                                            PsFrameUIForLoading(),
                                          ]));
                                    } else {
                                      return ItemHorizontalListItem(
                                        item: itemProvider.itemList.data[index],
                                        coreTagKey:
                                            itemProvider.hashCode.toString() +
                                                itemProvider
                                                    .itemList.data[index].id,
                                        onTap: () {
                                          print(itemProvider
                                              .itemList
                                              .data[index]
                                              .defaultPhoto
                                              .imgPath);
                                          final Item item = itemProvider
                                              .itemList.data.reversed
                                              .toList()[index];
                                          final ItemDetailIntentHolder holder =
                                              ItemDetailIntentHolder(
                                                  itemId: item.id,
                                                  heroTagImage: itemProvider
                                                          .hashCode
                                                          .toString() +
                                                      item.id +
                                                      PsConst.HERO_TAG__IMAGE,
                                                  heroTagTitle: itemProvider
                                                          .hashCode
                                                          .toString() +
                                                      item.id +
                                                      PsConst.HERO_TAG__TITLE);
                                          Navigator.pushNamed(
                                              context, RoutePaths.itemDetail,
                                              arguments: holder);
                                        },
                                      );
                                    }
                                  }))
                        ])
                      : Container(),
                  builder: (BuildContext context, Widget child) {
                    return FadeTransition(
                        opacity: widget.animation,
                        child: Transform(
                            transform: Matrix4.translationValues(
                                0.0, 100 * (1.0 - widget.animation.value), 0.0),
                            child: child));
                  });
            })));
  }
}

class _DisabledListingDataWidget extends StatefulWidget {
  const _DisabledListingDataWidget(
      {Key key,
      @required this.animationController,
      this.userId,
      @required this.headerTitle,
      @required this.status,
      this.animation})
      : super(key: key);

  final AnimationController animationController;
  final String userId;
  final String headerTitle;
  final String status;
  final Animation<double> animation;

  @override
  __DisabledListingDataWidgetState createState() =>
      __DisabledListingDataWidgetState();
}

class __DisabledListingDataWidgetState
    extends State<_DisabledListingDataWidget> {
  ItemRepository itemRepository;

  PsValueHolder psValueHolder;

  @override
  Widget build(BuildContext context) {
    itemRepository = Provider.of<ItemRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    return SliverToBoxAdapter(
        child: ChangeNotifierProvider<DisabledItemProvider>(
            lazy: false,
            create: (BuildContext context) {
              final DisabledItemProvider provider = DisabledItemProvider(
                  repo: itemRepository, psValueHolder: psValueHolder);
              if (provider.psValueHolder.loginUserId == null ||
                  provider.psValueHolder.loginUserId == '') {
                provider.addedUserParameterHolder.addedUserId = widget.userId;
                provider.addedUserParameterHolder.itemStatusId = widget.status;
                provider.loadItemList(
                    widget.userId, provider.addedUserParameterHolder);
              } else {
                provider.addedUserParameterHolder.addedUserId =
                    provider.psValueHolder.loginUserId;
                provider.addedUserParameterHolder.itemStatusId = widget.status;
                provider.loadItemList(provider.psValueHolder.loginUserId,
                    provider.addedUserParameterHolder);
              }

              return provider;
            },
            child: Consumer<DisabledItemProvider>(builder:
                (BuildContext context, DisabledItemProvider itemProvider,
                    Widget child) {
              return AnimatedBuilder(
                  animation: widget.animationController,
                  child: (itemProvider.itemList.data != null &&
                          itemProvider.itemList.data.isNotEmpty)
                      ? Column(children: <Widget>[
                          _HeaderWidget(
                            headerName: widget.headerTitle,
                            viewAllClicked: () {
                              Navigator.pushNamed(
                                  context, RoutePaths.userItemList,
                                  arguments: UserItemIntentHolder(
                                      userId: itemProvider
                                          .psValueHolder.loginUserId,
                                      status: widget.status,
                                      title: widget.headerTitle));
                            },
                          ),
                          Container(
                              height: PsDimens.space320,
                              width: MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: itemProvider.itemList.data.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (itemProvider.itemList.status ==
                                        PsStatus.BLOCK_LOADING) {
                                      return Shimmer.fromColors(
                                          baseColor: Colors.grey[300],
                                          highlightColor: Colors.white,
                                          child: Row(children: const <Widget>[
                                            PsFrameUIForLoading(),
                                          ]));
                                    } else {
                                      return ItemHorizontalListItem(
                                        item: itemProvider.itemList.data[index],
                                        coreTagKey:
                                            itemProvider.hashCode.toString() +
                                                itemProvider
                                                    .itemList.data[index].id,
                                        onTap: () {
                                          print(itemProvider
                                              .itemList
                                              .data[index]
                                              .defaultPhoto
                                              .imgPath);
                                          final Item item = itemProvider
                                              .itemList.data.reversed
                                              .toList()[index];
                                          final ItemDetailIntentHolder holder =
                                              ItemDetailIntentHolder(
                                                  itemId: item.id,
                                                  heroTagImage: itemProvider
                                                          .hashCode
                                                          .toString() +
                                                      item.id +
                                                      PsConst.HERO_TAG__IMAGE,
                                                  heroTagTitle: itemProvider
                                                          .hashCode
                                                          .toString() +
                                                      item.id +
                                                      PsConst.HERO_TAG__TITLE);
                                          Navigator.pushNamed(
                                              context, RoutePaths.itemDetail,
                                              arguments: holder);
                                        },
                                      );
                                    }
                                  }))
                        ])
                      : Container(),
                  builder: (BuildContext context, Widget child) {
                    return FadeTransition(
                        opacity: widget.animation,
                        child: Transform(
                            transform: Matrix4.translationValues(
                                0.0, 100 * (1.0 - widget.animation.value), 0.0),
                            child: child));
                  });
            })));
  }
}

class _RejectedListingDataWidget extends StatefulWidget {
  const _RejectedListingDataWidget(
      {Key key,
      @required this.animationController,
      this.userId,
      @required this.headerTitle,
      @required this.status,
      this.animation})
      : super(key: key);

  final AnimationController animationController;
  final String userId;
  final String headerTitle;
  final String status;
  final Animation<double> animation;

  @override
  ___RejectedListingDataWidgetState createState() =>
      ___RejectedListingDataWidgetState();
}

class ___RejectedListingDataWidgetState
    extends State<_RejectedListingDataWidget> {
  ItemRepository itemRepository;

  PsValueHolder psValueHolder;

  @override
  Widget build(BuildContext context) {
    itemRepository = Provider.of<ItemRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    return SliverToBoxAdapter(
        child: ChangeNotifierProvider<RejectedItemProvider>(
            lazy: false,
            create: (BuildContext context) {
              final RejectedItemProvider provider = RejectedItemProvider(
                  repo: itemRepository, psValueHolder: psValueHolder);
              if (provider.psValueHolder.loginUserId == null ||
                  provider.psValueHolder.loginUserId == '') {
                provider.addedUserParameterHolder.addedUserId = widget.userId;
                provider.addedUserParameterHolder.itemStatusId = widget.status;
                provider.loadItemList(
                    widget.userId, provider.addedUserParameterHolder);
              } else {
                provider.addedUserParameterHolder.addedUserId =
                    provider.psValueHolder.loginUserId;
                provider.addedUserParameterHolder.itemStatusId = widget.status;
                provider.loadItemList(provider.psValueHolder.loginUserId,
                    provider.addedUserParameterHolder);
              }

              return provider;
            },
            child: Consumer<RejectedItemProvider>(builder:
                (BuildContext context, RejectedItemProvider itemProvider,
                    Widget child) {
              return AnimatedBuilder(
                  animation: widget.animationController,
                  child: (itemProvider.itemList.data != null &&
                          itemProvider.itemList.data.isNotEmpty)
                      ? Column(children: <Widget>[
                          _HeaderWidget(
                            headerName: widget.headerTitle,
                            viewAllClicked: () {
                              Navigator.pushNamed(
                                  context, RoutePaths.userItemList,
                                  arguments: UserItemIntentHolder(
                                      userId: itemProvider
                                          .psValueHolder.loginUserId,
                                      status: widget.status,
                                      title: widget.headerTitle));
                            },
                          ),
                          Container(
                              height: PsDimens.space320,
                              width: MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: itemProvider.itemList.data.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (itemProvider.itemList.status ==
                                        PsStatus.BLOCK_LOADING) {
                                      return Shimmer.fromColors(
                                          baseColor: Colors.grey[300],
                                          highlightColor: Colors.white,
                                          child: Row(children: const <Widget>[
                                            PsFrameUIForLoading(),
                                          ]));
                                    } else {
                                      return ItemHorizontalListItem(
                                        item: itemProvider.itemList.data[index],
                                        coreTagKey:
                                            itemProvider.hashCode.toString() +
                                                itemProvider
                                                    .itemList.data[index].id,
                                        onTap: () {
                                          print(itemProvider
                                              .itemList
                                              .data[index]
                                              .defaultPhoto
                                              .imgPath);
                                          final Item item = itemProvider
                                              .itemList.data.reversed
                                              .toList()[index];
                                          final ItemDetailIntentHolder holder =
                                              ItemDetailIntentHolder(
                                                  itemId: item.id,
                                                  heroTagImage: itemProvider
                                                          .hashCode
                                                          .toString() +
                                                      item.id +
                                                      PsConst.HERO_TAG__IMAGE,
                                                  heroTagTitle: itemProvider
                                                          .hashCode
                                                          .toString() +
                                                      item.id +
                                                      PsConst.HERO_TAG__TITLE);
                                          Navigator.pushNamed(
                                              context, RoutePaths.itemDetail,
                                              arguments: holder);
                                        },
                                      );
                                    }
                                  }))
                        ])
                      : Container(),
                  builder: (BuildContext context, Widget child) {
                    return FadeTransition(
                        opacity: widget.animation,
                        child: Transform(
                            transform: Matrix4.translationValues(
                                0.0, 100 * (1.0 - widget.animation.value), 0.0),
                            child: child));
                  });
            })));
  }
}

class _HeaderWidget extends StatelessWidget {
  const _HeaderWidget({
    Key key,
    @required this.headerName,
    @required this.viewAllClicked,
  }) : super(key: key);

  final String headerName;
  final Function viewAllClicked;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: viewAllClicked,
      child: Padding(
        padding: const EdgeInsets.only(
            top: PsDimens.space20,
            left: PsDimens.space16,
            right: PsDimens.space16,
            bottom: PsDimens.space16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(headerName,
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.subtitle1),
            InkWell(
              child: Text(
                Utils.getString(context, 'profile__view_all'),
                textAlign: TextAlign.start,
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .copyWith(color: PsColors.mainColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileDetailWidget extends StatefulWidget {
  const _ProfileDetailWidget({
    Key key,
    this.animationController,
    this.animation,
    @required this.userId,
  }) : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;
  final String userId;

  @override
  __ProfileDetailWidgetState createState() => __ProfileDetailWidgetState();
}

class __ProfileDetailWidgetState extends State<_ProfileDetailWidget> {
  @override
  Widget build(BuildContext context) {
    const Widget _dividerWidget = Divider(
      height: 1,
    );
    UserRepository userRepository;
    PsValueHolder psValueHolder;
    UserProvider provider;
    userRepository = Provider.of<UserRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);
    provider = UserProvider(repo: userRepository, psValueHolder: psValueHolder);

    return SliverToBoxAdapter(
      child: ChangeNotifierProvider<UserProvider>(
          lazy: false,
          create: (BuildContext context) {
            print(provider.getCurrentFirebaseUser());
            if (provider.psValueHolder.loginUserId == null ||
                provider.psValueHolder.loginUserId == '') {
              provider.getUser(widget.userId);
            } else {
              provider.getUser(provider.psValueHolder.loginUserId);
            }
            return provider;
          },
          child: Consumer<UserProvider>(builder:
              (BuildContext context, UserProvider provider, Widget child) {
            if (provider.user != null && provider.user.data != null) {
              return AnimatedBuilder(
                  animation: widget.animationController,
                  child: Container(
                    color: PsColors.backgroundColor,
                    child: Column(
                      children: <Widget>[
                        _ImageAndTextWidget(userProvider: provider),
                        _dividerWidget,
                        _EditAndHistoryRowWidget(userProvider: provider),
                        _dividerWidget,
                        _FavAndSettingWidget(userProvider: provider),
                        _dividerWidget,
                        _JoinDateWidget(userProvider: provider),
                        _dividerWidget,
                      ],
                    ),
                  ),
                  builder: (BuildContext context, Widget child) {
                    return FadeTransition(
                        opacity: widget.animation,
                        child: Transform(
                          transform: Matrix4.translationValues(
                              0.0, 100 * (1.0 - widget.animation.value), 0.0),
                          child: child,
                        ));
                  });
            } else {
              return Container();
            }
          })),
    );
  }
}

class _JoinDateWidget extends StatelessWidget {
  const _JoinDateWidget({this.userProvider});
  final UserProvider userProvider;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(PsDimens.space16),
        child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  Utils.getString(context, 'profile__join_on'),
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                const SizedBox(
                  width: PsDimens.space2,
                ),
                Text(
                  userProvider.user.data.addedDate == ''
                      ? ''
                      : Utils.getDateFormat(userProvider.user.data.addedDate),
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ],
            )));
  }
}

class _FavAndSettingWidget extends StatelessWidget {
  const _FavAndSettingWidget({this.userProvider});
  final UserProvider userProvider;
  @override
  Widget build(BuildContext context) {
    const Widget _sizedBoxWidget = SizedBox(
      width: PsDimens.space4,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
            flex: 2,
            child: MaterialButton(
              height: 50,
              minWidth: double.infinity,
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  RoutePaths.favouriteItemList,
                );
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.favorite,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  _sizedBoxWidget,
                  Text(
                    Utils.getString(context, 'profile__favourite'),
                    textAlign: TextAlign.start,
                    softWrap: false,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )),
        Container(
          color: Theme.of(context).dividerColor,
          width: PsDimens.space1,
          height: PsDimens.space48,
        ),
        Expanded(
            flex: 2,
            child: MaterialButton(
              height: 50,
              minWidth: double.infinity,
              onPressed: () {
                Navigator.pushNamed(context, RoutePaths.more,
                    arguments: userProvider.user.data.userName);
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.more_horiz,
                      color: Theme.of(context).iconTheme.color),
                  _sizedBoxWidget,
                  Text(
                    Utils.getString(context, 'profile__more'),
                    softWrap: false,
                    textAlign: TextAlign.start,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ))
      ],
    );
  }
}

class _EditAndHistoryRowWidget extends StatelessWidget {
  const _EditAndHistoryRowWidget({@required this.userProvider});
  final UserProvider userProvider;
  @override
  Widget build(BuildContext context) {
    final Widget _verticalLineWidget = Container(
      color: Theme.of(context).dividerColor,
      width: PsDimens.space1,
      height: PsDimens.space48,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _EditAndHistoryTextWidget(
          userProvider: userProvider,
          checkText: 0,
        ),
        _verticalLineWidget,
        _EditAndHistoryTextWidget(
          userProvider: userProvider,
          checkText: 1,
        ),
        _verticalLineWidget,
        _EditAndHistoryTextWidget(
          userProvider: userProvider,
          checkText: 2,
        )
      ],
    );
  }
}

class _EditAndHistoryTextWidget extends StatelessWidget {
  const _EditAndHistoryTextWidget({
    Key key,
    @required this.userProvider,
    @required this.checkText,
  }) : super(key: key);

  final UserProvider userProvider;
  final int checkText;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 2,
        child: MaterialButton(
            height: 50,
            minWidth: double.infinity,
            onPressed: () async {
              if (checkText == 0) {
                final dynamic returnData = await Navigator.pushNamed(
                  context,
                  RoutePaths.editProfile,
                );
                if (returnData != null && returnData is bool) {
                  userProvider.getUser(userProvider.psValueHolder.loginUserId);
                }
              } else if (checkText == 1) {
                Navigator.pushNamed(
                  context,
                  RoutePaths.historyList,
                );
              } else if (checkText == 2) {
                Navigator.pushNamed(
                  context,
                  RoutePaths.notiList,
                );
              }
            },
            child: checkText == 0
                ? Text(
                    Utils.getString(context, 'profile__edit'),
                    softWrap: false,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(fontWeight: FontWeight.bold),
                  )
                : checkText == 1
                    ? Text(
                        Utils.getString(context, 'profile__history'),
                        softWrap: false,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(fontWeight: FontWeight.bold),
                      )
                    : Text(
                        Utils.getString(context, 'profile__notification'),
                        softWrap: false,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(fontWeight: FontWeight.bold),
                      )));
  }
}

class _ImageAndTextWidget extends StatelessWidget {
  const _ImageAndTextWidget({this.userProvider});
  final UserProvider userProvider;
  @override
  Widget build(BuildContext context) {
    final Widget _imageWidget = PsNetworkCircleImageForUser(
      photoKey: '',
      imagePath: userProvider.user.data.userProfilePhoto,
      boxfit: BoxFit.cover,
      onTap: () {},
    );
    const Widget _spacingWidget = SizedBox(
      height: PsDimens.space4,
    );
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(
          top: PsDimens.space16, bottom: PsDimens.space16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const SizedBox(width: PsDimens.space16),
              Container(
                  width: PsDimens.space80,
                  height: PsDimens.space80,
                  child: _imageWidget),
              const SizedBox(width: PsDimens.space16),
            ],
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text(
                  userProvider.user.data.userName,
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.headline6,
                ),
                _spacingWidget,
                Text(
                  userProvider.user.data.userPhone != ''
                      ? userProvider.user.data.userPhone
                      : Utils.getString(context, 'profile__phone_no'),
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(color: PsColors.textPrimaryLightColor),
                ),
                _spacingWidget,
                Text(
                  userProvider.user.data.userAboutMe != ''
                      ? userProvider.user.data.userAboutMe
                      : Utils.getString(context, 'profile__about_me'),
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(color: PsColors.textPrimaryLightColor),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
