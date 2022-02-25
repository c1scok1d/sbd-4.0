import 'package:flutter/material.dart';
import 'package:businesslistingapi/config/ps_config.dart';
import 'package:businesslistingapi/constant/ps_constants.dart';
import 'package:businesslistingapi/constant/ps_dimens.dart';
import 'package:businesslistingapi/constant/route_paths.dart';
import 'package:businesslistingapi/provider/item/added_item_provider.dart';
import 'package:businesslistingapi/repository/item_repository.dart';
import 'package:businesslistingapi/ui/common/base/ps_widget_with_appbar.dart';
import 'package:businesslistingapi/ui/common/ps_ui_widget.dart';
import 'package:businesslistingapi/ui/items/item/item_vertical_list_item.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:businesslistingapi/viewobject/common/ps_value_holder.dart';
import 'package:businesslistingapi/viewobject/holder/intent_holder/item_detail_intent_holder.dart';
import 'package:businesslistingapi/viewobject/item.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class UserItemListView extends StatefulWidget {
  const UserItemListView(
      {@required this.addedUserId,
      @required this.status,
      @required this.title});
  final String addedUserId;
  final String status;
  final String title;

  @override
  _UserItemListViewState createState() {
    return _UserItemListViewState();
  }
}

class _UserItemListViewState extends State<UserItemListView>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  AddedItemProvider _userAddedItemProvider;

  AnimationController animationController;

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        final String loginUserId = Utils.checkUserLoginId(psValueHolder);
        _userAddedItemProvider.nextItemList(
            loginUserId, _userAddedItemProvider.addedUserParameterHolder);
      }
    });
  }

  ItemRepository repo1;
  PsValueHolder psValueHolder;
  @override
  Widget build(BuildContext context) {
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

    timeDilation = 1.0;
    repo1 = Provider.of<ItemRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    return WillPopScope(
      onWillPop: _requestPop,
      child: PsWidgetWithAppBar<AddedItemProvider>(
          appBarTitle: widget.title,
          initProvider: () {
            return AddedItemProvider(repo: repo1, psValueHolder: psValueHolder);
          },
          onProviderReady: (AddedItemProvider provider) {
            final String loginUserId = Utils.checkUserLoginId(psValueHolder);

            provider.addedUserParameterHolder.addedUserId = widget.addedUserId;
            provider.addedUserParameterHolder.itemStatusId = widget.status;
            provider.loadItemList(
                loginUserId, provider.addedUserParameterHolder);

            _userAddedItemProvider = provider;
          },
          builder:
              (BuildContext context, AddedItemProvider provider, Widget child) {
            return Stack(children: <Widget>[
              Container(
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
                                    maxCrossAxisExtent: 280,
                                    childAspectRatio: 0.55),
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                if (provider.itemList.data != null ||
                                    provider.itemList.data.isNotEmpty) {
                                  final int count =
                                      provider.itemList.data.length;
                                  return ItemVeticalListItem(
                                    coreTagKey: provider.hashCode.toString() +
                                        provider.itemList.data[index].id,
                                    animationController: animationController,
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
                                    item: provider.itemList.data[index],
                                    onTap: () {
                                      print(provider.itemList.data[index]
                                          .defaultPhoto.imgPath);
                                      final Item item = provider
                                          .itemList.data.reversed
                                          .toList()[index];
                                      final ItemDetailIntentHolder holder =
                                          ItemDetailIntentHolder(
                                              itemId:
                                                  item.id,
                                              heroTagImage:
                                                  provider.hashCode.toString() +
                                                      item.id +
                                                      PsConst.HERO_TAG__IMAGE,
                                              heroTagTitle:
                                                  provider.hashCode.toString() +
                                                      item.id +
                                                      PsConst.HERO_TAG__TITLE);
                                      Navigator.pushNamed(
                                          context, RoutePaths.itemDetail,
                                          arguments: holder);
                                    },
                                  );
                                } else {
                                  return null;
                                }
                              },
                              childCount: provider.itemList.data.length,
                            ),
                          ),
                        ]),
                    onRefresh: () async {
                      _userAddedItemProvider.addedUserParameterHolder
                          .addedUserId = widget.addedUserId;

                      return _userAddedItemProvider.resetItemList(
                          provider.psValueHolder.loginUserId,
                          provider.addedUserParameterHolder);
                    },
                  )),
              PSProgressIndicator(provider.itemList.status)
            ]);
          }),
    );
  }
}
