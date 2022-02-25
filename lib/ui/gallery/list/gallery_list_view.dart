import 'package:businesslistingapi/api/common/ps_resource.dart';
import 'package:businesslistingapi/config/ps_colors.dart';
import 'package:businesslistingapi/config/ps_config.dart';
import 'package:businesslistingapi/constant/ps_dimens.dart';
import 'package:businesslistingapi/constant/route_paths.dart';
// import 'package:businesslistingapi/provider/delete_image/delete_image_provider.dart';
import 'package:businesslistingapi/provider/gallery/gallery_provider.dart';
// import 'package:businesslistingapi/repository/delete_image_repository.dart';
// import 'package:businesslistingapi/ui/common/base/ps_widget_with_multi_provider.dart';
import 'package:businesslistingapi/ui/gallery/list/gallery_list_item.dart';
import 'package:businesslistingapi/viewobject/item.dart';
import 'package:flutter/material.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:businesslistingapi/viewobject/api_status.dart';
import 'package:businesslistingapi/viewobject/holder/delete_imge_parameter_holder.dart';
import 'package:businesslistingapi/viewobject/holder/intent_holder/item_entry_image_intent_holder.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
// import 'package:provider/provider.dart';
// import 'package:provider/single_child_widget.dart';

class GalleryListView extends StatefulWidget {
  const GalleryListView({
    Key key,
    @required this.itemId,
    this.onImageTap,
    this.item,
    @required this.galleryProvider,
    // @required this.deleteImageProvider,
  }) : super(key: key);

  final String itemId;
  final Item item;
  final Function onImageTap;
  final GalleryProvider galleryProvider;
  // final DeleteImageProvider deleteImageProvider;
  @override
  _GalleryListViewState createState() => _GalleryListViewState();
}

class _GalleryListViewState extends State<GalleryListView>
    with SingleTickerProviderStateMixin {
  // DeleteImageProvider deleteImageProvider;
  AnimationController animationController;
  Animation<double> animation;

  @override
  void initState() {
    // _scrollController.addListener(() {
    //   if (_scrollController.position.pixels ==
    //       _scrollController.position.maxScrollExtent) {
    //     _itemCollectionProvider
    //         .nextItemListByCollectionId(widget.itemCollectionHeader.id);
    //   }
    // });

    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final DeleteImageRepository deleteImageRepo =
    //     Provider.of<DeleteImageRepository>(context);

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

    print(
        '............................Build UI Again ............................');
    return WillPopScope(
        onWillPop: _requestPop,
        child:
            //  PsWidgetWithMultiProvider(
            //     child: MultiProvider(
            //         providers: <SingleChildWidget>[
            //       ChangeNotifierProvider<DeleteImageProvider>(
            //         lazy: false,
            //         create: (BuildContext context) {
            //           deleteImageProvider =
            //               DeleteImageProvider(repo: deleteImageRepo);
            //           return deleteImageProvider;
            //         },
            //       ),
            //     ],
            //         child: Consumer<DeleteImageProvider>(builder:
            //             (BuildContext context,
            //                 DeleteImageProvider deleteImageProvider, Widget child) {
            Scaffold(
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarIconBrightness: Utils.getBrightnessForAppBar(context),
            ),
            iconTheme: Theme.of(context)
                .iconTheme
                .copyWith(color: PsColors.mainColorWithWhite),
            title: Text(
              'Image List',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(fontWeight: FontWeight.bold)
                  .copyWith(color: PsColors.mainColorWithWhite),
            ),
            titleSpacing: 0,
            elevation: 0,
            toolbarTextStyle:  TextStyle(color: PsColors.textPrimaryColor),
            actions: <Widget>[
              InkWell(
                onTap: () async {
                  final dynamic retrunData = await Navigator.pushNamed(
                      context, RoutePaths.imageUpload,
                      arguments: ItemEntryImageIntentHolder(
                          flag: '',
                          itemId: widget.itemId,
                          item: widget.item,
                          provider: widget.galleryProvider));

                  if (retrunData != null && retrunData is List<Asset>) {
                    await widget.galleryProvider.loadImageList(
                      widget.itemId,
                    );
                    setState(() {});
                  }
                },
                child: Container(
                  alignment: Alignment.centerRight,
                  margin: const EdgeInsets.only(
                      left: PsDimens.space8, right: PsDimens.space8),
                  child: Text(
                    'ADD',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                        fontWeight: FontWeight.bold, color: PsColors.mainColor),
                  ),
                ),
              ),
            ],
          ),
          body: Container(
            color: Theme.of(context).cardColor,
            height: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  slivers: <Widget>[
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return GalleryListItem(
                              image: widget
                                  .galleryProvider.galleryList.data[index],
                              animationController: animationController,
                              animation:
                                  Tween<double>(begin: 0.0, end: 1.0).animate(
                                CurvedAnimation(
                                  parent: animationController,
                                  curve: Interval(
                                      (1 /
                                              widget.galleryProvider.galleryList
                                                  .data.length) *
                                          index,
                                      1.0,
                                      curve: Curves.fastOutSlowIn),
                                ),
                              ),
                              deleteIconTap: () async {
                                if (await Utils.checkInternetConnectivity()) {
                                  final DeleteImageParameterHolder
                                      deleteImageParameterHolder =
                                      DeleteImageParameterHolder(
                                    itemId: widget.itemId,
                                    imgId: widget.galleryProvider.galleryList
                                        .data[index].imgId,
                                  );

                                  final PsResource<ApiStatus> _apiStatus =
                                      await widget.galleryProvider
                                          .postDeleteImage(
                                              deleteImageParameterHolder
                                                  .toMap());

                                  if (_apiStatus.data != null) {
                                    print(_apiStatus.data.message);
                                    await widget.galleryProvider
                                        .loadImageList(widget.itemId);
                                    print(widget
                                        .galleryProvider.galleryList.data.length
                                        .toString());
                                    setState(() {});
                                  }
                                }
                              },
                              onImageTap: () async {
                                final dynamic retrunData =
                                    await Navigator.pushNamed(
                                        context, RoutePaths.imageUpload,
                                        arguments: ItemEntryImageIntentHolder(
                                            flag: '',
                                            itemId: widget.itemId,
                                            item: widget.item,
                                            image: widget.galleryProvider
                                                .galleryList.data[index],
                                            provider: widget.galleryProvider));
                                if (retrunData != null &&
                                    retrunData is List<Asset>) {
                                  widget.galleryProvider
                                      .loadImageList(widget.itemId);
                                  setState(() {});
                                }
                              });
                        },
                        childCount:
                            widget.galleryProvider.galleryList.data.length,
                      ),
                    )
                  ]),
            ),
          ),
        ));
    // } else {
    //   return Container();
    // }
    // }))),
    // );
  }
}
