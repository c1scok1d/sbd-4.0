import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:businesslistingapi/constant/ps_constants.dart';
import 'package:businesslistingapi/constant/ps_dimens.dart';
import 'package:businesslistingapi/constant/route_paths.dart';
import 'package:businesslistingapi/provider/item/paid_ad_item_provider.dart';
import 'package:businesslistingapi/repository/paid_ad_item_repository.dart';
import 'package:businesslistingapi/ui/common/ps_ui_widget.dart';
import 'package:businesslistingapi/ui/paid_ad/paid_ad_item_vertical_list_item.dart';
import 'package:businesslistingapi/viewobject/common/ps_value_holder.dart';
import 'package:businesslistingapi/viewobject/holder/intent_holder/item_detail_intent_holder.dart';
import 'package:provider/provider.dart';

class PaidAdItemListView extends StatefulWidget {
  const PaidAdItemListView(
      {Key key, this.scrollController, @required this.animationController})
      : super(key: key);
  final AnimationController animationController;
  final ScrollController scrollController;
  @override
  _PaidAdItemListView createState() => _PaidAdItemListView();
}

class _PaidAdItemListView extends State<PaidAdItemListView>
    with TickerProviderStateMixin {
  PaidAdItemProvider _paidAdItemProvider;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    // if (widget.scrollController != null) {
    widget.scrollController.addListener(() {
      if (widget.scrollController.position.pixels ==
          widget.scrollController.position.maxScrollExtent) {
        _paidAdItemProvider.nextPaidAdItemList(psValueHolder.loginUserId);
      }
    });
    // } else {
    //   _scrollController.addListener(() {
    //     if (_scrollController.position.pixels ==
    //         _scrollController.position.maxScrollExtent) {
    //       _paidAdItemProvider.nextPaidAdItemList(psValueHolder.loginUserId);
    //     }
    //   });
    // }

    super.initState();
  }

  PaidAdItemRepository repo1;
  PsValueHolder psValueHolder;
  dynamic data;
  @override
  Widget build(BuildContext context) {
    // data = EasyLocalizationProvider.of(context).data;
    repo1 = Provider.of<PaidAdItemRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);
    print(
        '............................Build UI Again ............................');
    // return EasyLocalizationProvider(
    //     data: data,
    //     child:
    return ChangeNotifierProvider<PaidAdItemProvider>(
        lazy: false,
        create: (BuildContext context) {
          final PaidAdItemProvider provider =
              PaidAdItemProvider(repo: repo1, psValueHolder: psValueHolder);
          provider.loadPaidAdItemList(psValueHolder.loginUserId);
          _paidAdItemProvider = provider;
          return _paidAdItemProvider;
        },
        child: Consumer<PaidAdItemProvider>(
          builder: (BuildContext context, PaidAdItemProvider provider,
              Widget child) {
            return Stack(children: <Widget>[
              Container(
                  margin: const EdgeInsets.only(
                      left: PsDimens.space8,
                      right: PsDimens.space8,
                      top: PsDimens.space8,
                      bottom: PsDimens.space8),
                  child: RefreshIndicator(
                    child: CustomScrollView(
                        controller:
                            widget.scrollController ?? _scrollController,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        slivers: <Widget>[
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                if (provider.paidAdItemList.data != null ||
                                    provider.paidAdItemList.data.isNotEmpty) {
                                  final int count =
                                      provider.paidAdItemList.data.length;
                                  return PaidAdItemVerticalListItem(
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
                                    paidAdItem:
                                        provider.paidAdItemList.data[index],
                                    onTap: () {
                                      final ItemDetailIntentHolder holder =
                                          ItemDetailIntentHolder(
                                              itemId: provider.paidAdItemList
                                                  .data[index].item.id,
                                              heroTagImage:
                                                  provider.hashCode.toString() +
                                                      provider.paidAdItemList
                                                          .data[index].item.id +
                                                      PsConst.HERO_TAG__IMAGE,
                                              heroTagTitle:
                                                  provider.hashCode.toString() +
                                                      provider.paidAdItemList
                                                          .data[index].item.id +
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
                              childCount: provider.paidAdItemList.data.length,
                            ),
                          ),
                        ]),
                    onRefresh: () async {
                      return _paidAdItemProvider.resetPaidAdItemList(
                          provider.psValueHolder.loginUserId);
                    },
                  )),
              PSProgressIndicator(provider.paidAdItemList.status)
            ]);
          },
          // ),
        ));
  }
}
