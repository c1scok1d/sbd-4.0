import 'package:businesslistingapi/api/common/ps_resource.dart';
import 'package:businesslistingapi/config/ps_colors.dart';
import 'package:businesslistingapi/config/ps_config.dart';
import 'package:businesslistingapi/constant/ps_constants.dart';
import 'package:businesslistingapi/constant/ps_dimens.dart';
import 'package:businesslistingapi/constant/route_paths.dart';
import 'package:businesslistingapi/db/common/ps_shared_preferences.dart';
import 'package:businesslistingapi/provider/gallery/gallery_provider.dart';
import 'package:businesslistingapi/ui/common/dialog/error_dialog.dart';
import 'package:businesslistingapi/ui/common/dialog/image_upload_dialog.dart';
import 'package:businesslistingapi/ui/common/dialog/warning_dialog_view.dart';
import 'package:businesslistingapi/ui/common/ps_button_widget.dart';
import 'package:businesslistingapi/ui/common/ps_ui_widget.dart';
import 'package:businesslistingapi/utils/ps_progress_dialog.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:businesslistingapi/viewobject/default_photo.dart';
import 'package:businesslistingapi/viewobject/holder/delete_imge_parameter_holder.dart';
import 'package:businesslistingapi/viewobject/holder/intent_holder/user_item_intent_holder.dart';
import 'package:businesslistingapi/viewobject/item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ItemImageUploadView extends StatefulWidget {
  const ItemImageUploadView({
    @required this.flag,
    @required this.itemId,
    this.image,
    this.item,
    this.isPromotion,
    @required this.galleryProvider,
  });

  final String flag;
  final String itemId;
  final String isPromotion;
  final Item item;
  final DefaultPhoto image;
  final GalleryProvider galleryProvider;

  @override
  ItemImageUploadViewState createState() => ItemImageUploadViewState();
}

class ItemImageUploadViewState extends State<ItemImageUploadView>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  bool isSelectedImagePath = false;
  String imageId = '';
  String userId = '';
  List<Asset> images = <Asset>[];
  Asset selectedImageAsset;
  DefaultPhoto previousImage;
  final TextEditingController userInputSearchKeyWord = TextEditingController();

  @override
  Widget build(BuildContext context) {
    previousImage = widget.image;
    Asset defaultAssetImage;

    Future<dynamic> uploadImage(String itemId) async {
      bool _isDone = isSelectedImagePath;

      if (!PsProgressDialog.isShowing()) {
        await PsProgressDialog.showDialog(context);
      }

      final PsResource<DefaultPhoto> _apiStatus = await widget.galleryProvider
          .postItemImageUpload(
              itemId,
              imageId,
              await Utils.getImageFileFromAssets(
                  selectedImageAsset, PsConfig.uploadImageSize));
      if (_apiStatus.data != null) {
        isSelectedImagePath = false;
        _isDone = isSelectedImagePath;
        if (isSelectedImagePath) {
          await uploadImage(itemId);
        }
      }
      SharedPreferences s= await PsSharedPreferences.instance.futureShared;
      userId=s.getString(PsConst.VALUE_HOLDER__USER_ID);
      PsProgressDialog.dismissDialog();

      if (!_isDone) {
        showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
              return ImageUploadDialog(
                message:
                    Utils.getString(context, 'item_image_upload__uploaded'),
                onPressed: (bool uploadAnother) {
                  if (uploadAnother) {
                    setState(() {
                      userInputSearchKeyWord.text = '';
                      selectedImageAsset = null;
                      isSelectedImagePath = false;
                      previousImage = null;
                    });
                  } else {
                    Navigator.pop(context, images);
                    if (widget.isPromotion == '1') {
                      Navigator.pushNamed(
                        context,
                        RoutePaths.itemPromote,
                        arguments: widget.item,
                      );
                    } else {
                      Navigator.pushNamed(
                        context,
                        RoutePaths.userItemList,
                        arguments: UserItemIntentHolder(
                            userId: userId,
                            status: '1',
                            title: 'My Items List'),
                      );
                    }
                  }
                },
              );
            });
      }

      return;
    }

    dynamic updateImages(List<Asset> resultList, int index) {
      if (index == -1) {
        selectedImageAsset = defaultAssetImage;
      }
      setState(() {
        images = resultList;
        print(images);

        if (resultList.isEmpty) {
          selectedImageAsset = defaultAssetImage;
          isSelectedImagePath = false;
        }

        //for single select image
        if (index == 0 && resultList.isNotEmpty) {
          if (previousImage != null) {
            final DeleteImageParameterHolder deleteImageParameterHolder =
                DeleteImageParameterHolder(
              itemId: widget.itemId,
              imgId: widget.image.imgId,
            );
            widget.galleryProvider
                .postDeleteImage(deleteImageParameterHolder.toMap());
          }
          selectedImageAsset = resultList[0];
          isSelectedImagePath = true;
        }
      });
    }

    Future<void> loadSingleImage(int index) async {
      List<Asset> resultList = <Asset>[];

      try {
        resultList = await MultiImagePicker.pickImages(
          maxImages: 1,
          enableCamera: true,
          selectedAssets: images,
          //widget.images,
          cupertinoOptions: CupertinoOptions(
            takePhotoIcon: 'chat',
            backgroundColor:
                '' + Utils.convertColorToString(PsColors.whiteColorWithBlack),
          ),
          materialOptions: MaterialOptions(
            actionBarColor: Utils.convertColorToString(PsColors.black),
            actionBarTitleColor: Utils.convertColorToString(PsColors.white),
            statusBarColor: Utils.convertColorToString(PsColors.black),
            lightStatusBar: false,
            actionBarTitle: '',
            allViewTitle: 'All Photos',
            useDetailsView: false,
            selectCircleStrokeColor:
                Utils.convertColorToString(PsColors.mainColor),
          ),
        );
      } on Exception catch (e) {
        e.toString();
      }

      // If the widget was removed from the tree while the asynchronous platform
      // message was in flight, we want to discard the reply rather than calling
      // setState to update our non-existent appearance.
      if (!mounted) {
        return;
      }
      for (int i = 0; i < resultList.length; i++) {
        if (resultList[i].name.contains('.webp')) {
          showDialog<dynamic>(
              context: context,
              builder: (BuildContext context) {
                return ErrorDialog(
                  message: Utils.getString(context, 'error_dialog__webp_image'),
                );
              });
          return;
        }
      }
      updateImages(resultList, index);
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

    print(
        '............................Build UI Again ............................');
    return WillPopScope(
        onWillPop: _requestPop,
        child: Scaffold(
            appBar: AppBar(
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarIconBrightness: Utils.getBrightnessForAppBar(context),
              ),
              iconTheme: Theme.of(context)
                  .iconTheme
                  .copyWith(color: PsColors.mainColorWithWhite),
              title: Text(
                Utils.getString(context, 'item_entry__app_bar_name'),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline6.copyWith(
                    fontWeight: FontWeight.bold,
                    color: PsColors.mainColorWithWhite),
              ),
              elevation: 0,
            ),
            body: widget.galleryProvider.galleryList != null &&
                    widget.galleryProvider.galleryList.data != null
                ? SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(
                                  left: PsDimens.space16,
                                  right: PsDimens.space16,
                                  top: PsDimens.space16,
                                  bottom: PsDimens.space48),
                              width: PsDimens.space140,
                              height: PsDimens.space44,
                              child: PSButtonWidget(
                                  hasShadow: true,
                                  width: double.infinity,
                                  titleText: Utils.getString(context,
                                      'item_image_upload__choose_photo_btn'),
                                  onPressed: () async {
                                    loadSingleImage(0);
                                  }),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: PsDimens.space20,
                                  right: PsDimens.space20,
                                  bottom: PsDimens.space20),
                              child: TextField(
                                controller: userInputSearchKeyWord,
                                decoration: InputDecoration(
                                    hintText: Utils.getString(context,
                                        'item_image_upload__item_description')),
                              ),
                            ),
                            ItemEntryImageWidget(
                              index: 0,
                              selectedImage: selectedImageAsset,
                              galleryImage: (previousImage != null &&
                                      selectedImageAsset == null)
                                  ? previousImage
                                  : null,
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                loadSingleImage(0);
                              },
                            ),
                          ],
                        ),
                        Container(
                            alignment: Alignment.bottomCenter,
                            margin: const EdgeInsets.only(
                                left: PsDimens.space16,
                                right: PsDimens.space16,
                                top: PsDimens.space16,
                                bottom: PsDimens.space28),
                            width: double.infinity,
                            height: PsDimens.space44,
                            child: PSButtonWidget(
                                hasShadow: true,
                                width: double.infinity,
                                titleText: Utils.getString(
                                    context, 'item_image_upload__upload_btn'),
                                onPressed: () async {
                                  if (previousImage == null &&
                                      selectedImageAsset == null) {
                                    showDialog<dynamic>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return WarningDialog(
                                            message: Utils.getString(context,
                                                'item_image_upload__need_image'),
                                            onPressed: () {},
                                          );
                                        });
                                  } else if (userInputSearchKeyWord.text ==
                                      '') {
                                    showDialog<dynamic>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return WarningDialog(
                                            message: Utils.getString(context,
                                                'item_image_upload__need_image_description'),
                                            onPressed: () {},
                                          );
                                        });
                                  } else if (!isSelectedImagePath) {
                                    showDialog<dynamic>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return WarningDialog(
                                            message: Utils.getString(context,
                                                'item_image_upload__already_added_image'),
                                            onPressed: () {},
                                          );
                                        });
                                  } else if (isSelectedImagePath &&
                                      userInputSearchKeyWord.text != '') {
                                    uploadImage(widget.itemId);
                                  }
                                })),
                      ],
                    ),
                  )
                : Container()));
  }
}

class ItemEntryImageWidget extends StatefulWidget {
  const ItemEntryImageWidget({
    Key key,
    @required this.index,
    @required this.galleryImage,
    @required this.selectedImage,
    this.onTap,
  }) : super(key: key);

  final Function onTap;
  final int index;
  final DefaultPhoto galleryImage;
  final Asset selectedImage;
  @override
  State<StatefulWidget> createState() {
    return ItemEntryImageWidgetState();
  }
}

class ItemEntryImageWidgetState extends State<ItemEntryImageWidget> {
  int i = 0;
  @override
  Widget build(BuildContext context) {
    if (widget.galleryImage != null) {
      return Padding(
        padding: const EdgeInsets.only(right: 4, left: 4),
        child: InkWell(
          onTap: widget.onTap,
          child: PsNetworkImageWithUrl(
            photoKey: '',
            width: double.infinity,
            height: 220,
            boxfit: BoxFit.contain,
            imagePath: widget.galleryImage.imgPath,
          ),
        ),
      );
    } else {
      if (widget.selectedImage != null) {
        final Asset asset = widget.selectedImage;
        return Padding(
          padding: const EdgeInsets.only(right: 4, left: 4),
          child: InkWell(
            onTap: widget.onTap,
            child: Container(
              width: double.infinity,
              height: 220,
              child: AssetThumb(
                height: 220,
                asset: asset,
                quality: 100,
                width: 100,
              ),
            ),
          ),
        );
      } else {
        return Padding(
            padding: const EdgeInsets.only(right: 4, left: 4),
            child: InkWell(
              onTap: widget.onTap,
              child: Container(
                width: double.infinity,
                height: 220,
                child: Image.asset(
                  'assets/images/placeholder_image.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ));
      }
    }
  }
}
