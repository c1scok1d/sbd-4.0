import 'package:businesslistingapi/api/common/ps_resource.dart';
import 'package:businesslistingapi/api/common/ps_status.dart';
import 'package:businesslistingapi/config/ps_colors.dart';
import 'package:businesslistingapi/constant/ps_dimens.dart';
import 'package:businesslistingapi/constant/route_paths.dart';
import 'package:businesslistingapi/provider/item/item_provider.dart';
import 'package:businesslistingapi/provider/rating/rating_provider.dart';
import 'package:businesslistingapi/repository/rating_repository.dart';
import 'package:businesslistingapi/ui/common/dialog/warning_dialog_view.dart';
import 'package:businesslistingapi/ui/common/ps_button_widget.dart';
import 'package:businesslistingapi/ui/common/ps_textfield_widget.dart';
import 'package:businesslistingapi/ui/common/smooth_star_rating_widget.dart';
import 'package:businesslistingapi/utils/ps_progress_dialog.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:businesslistingapi/viewobject/holder/rating_holder.dart';
import 'package:flutter/material.dart';
import 'package:businesslistingapi/viewobject/rating.dart';
import 'package:provider/provider.dart';

class RatingInputDialog extends StatefulWidget {
  const RatingInputDialog({
    Key key,
    @required this.itemprovider,
    @required this.checkType,
  }) : super(key: key);

  final ItemDetailProvider itemprovider;
  final bool checkType;
  @override
  _RatingInputDialogState createState() => _RatingInputDialogState();
}

class _RatingInputDialogState extends State<RatingInputDialog> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  double rating;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final RatingRepository ratingRepo = Provider.of<RatingRepository>(context);

    final Widget _headerWidget = Container(
        height: PsDimens.space52,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            color: PsColors.mainColor),
        child: Row(
          children: <Widget>[
            const SizedBox(width: PsDimens.space12),
            Icon(
              Icons.rate_review,
              color: PsColors.white,
            ),
            const SizedBox(width: PsDimens.space8),
            Text(
              Utils.getString(context, 'rating_entry__user_rating_entry'),
              textAlign: TextAlign.start,
              style: TextStyle(
                color: PsColors.white,
              ),
            ),
          ],
        ));
    return ChangeNotifierProvider<RatingProvider>(
        lazy: false,
        create: (BuildContext context) {
          final RatingProvider provider = RatingProvider(repo: ratingRepo);
          // provider.loadRatingList(widget.itemprovider.itemDetail.data.id);
          return provider;
        },
        child: Consumer<RatingProvider>(builder:
            (BuildContext context, RatingProvider provider, Widget child) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _headerWidget,
                  const SizedBox(
                    height: PsDimens.space16,
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        Utils.getString(context, 'rating_entry__your_rating'),
                        style: Theme.of(context).textTheme.bodyText2.copyWith(),
                      ),
                      if (rating == null)
                        SmoothStarRating(
                          isRTl:
                                Directionality.of(context) == TextDirection.rtl,
                            allowHalfRating: false,
                            rating: 0.0,
                            starCount: 5,
                            size: PsDimens.space40,
                            color: PsColors.ratingColor,
                            onRated: (double rating1) {
                              setState(() {
                                rating = rating1;
                              });
                            },
                            borderColor: Utils.isLightMode(context)
                                ? PsColors.black.withAlpha(100)
                                : PsColors.white,
                            spacing: 0.0)
                      else
                        SmoothStarRating(
                          isRTl:
                                Directionality.of(context) == TextDirection.rtl,
                            allowHalfRating: false,
                            rating: rating,
                            starCount: 5,
                            size: PsDimens.space40,
                            color: PsColors.ratingColor,
                            onRated: (double rating1) {
                              setState(() {
                                rating = rating1;
                              });
                            },
                            borderColor: Utils.isLightMode(context)
                                ? PsColors.black.withAlpha(100)
                                : PsColors.white,
                            spacing: 0.0),
                      PsTextFieldWidget(
                          titleText:
                              Utils.getString(context, 'rating_entry__title'),
                          hintText:
                              Utils.getString(context, 'rating_entry__title'),
                          textEditingController: titleController),
                      PsTextFieldWidget(
                          height: PsDimens.space120,
                          keyboardType: TextInputType.multiline,
                          titleText:
                              Utils.getString(context, 'rating_entry__message'),
                          hintText:
                              Utils.getString(context, 'rating_entry__message'),
                          textEditingController: descriptionController),
                      const Divider(
                        height: 0.5,
                      ),
                      const SizedBox(
                        height: PsDimens.space16,
                      ),
                      _ButtonWidget(
                        descriptionController: descriptionController,
                        provider: provider,
                        itemProvider: widget.itemprovider,
                        titleController: titleController,
                        rating: rating,
                        checkType: widget.checkType,
                      ),
                      const SizedBox(
                        height: PsDimens.space16,
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        }));
  }
}

class _ButtonWidget extends StatefulWidget {
  const _ButtonWidget({
    Key key,
    @required this.checkType,
    @required this.titleController,
    @required this.descriptionController,
    @required this.provider,
    @required this.itemProvider,
    @required this.rating,
  }) : super(key: key);

  final bool checkType;
  final TextEditingController titleController, descriptionController;
  final RatingProvider provider;
  final ItemDetailProvider itemProvider;
  final double rating;

  @override
  __ButtonWidgetState createState() => __ButtonWidgetState();
}

class __ButtonWidgetState extends State<_ButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: PsDimens.space8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: SizedBox(
              width: double.infinity,
              height: PsDimens.space36,
              child: PSButtonWidget(
                hasShadow: false,
                colorData: PsColors.grey,
                width: double.infinity,
                titleText: Utils.getString(context, 'rating_entry__cancel'),
                onPressed: () async {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          const SizedBox(
            width: PsDimens.space8,
          ),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              height: PsDimens.space36,
              child: PSButtonWidget(
                hasShadow: true,
                width: double.infinity,
                titleText: Utils.getString(context, 'rating_entry__submit'),
                onPressed: () async {
                  if (widget.titleController.text.isNotEmpty &&
                      widget.descriptionController.text.isNotEmpty &&
                      widget.rating != null &&
                      widget.rating.toString() != '0.0') {
                    final RatingParameterHolder commentHeaderParameterHolder =
                        RatingParameterHolder(
                      userId: widget.itemProvider.psValueHolder.loginUserId,
                      itemId: widget.itemProvider.itemDetail.data.id,
                      cityId: widget.itemProvider.itemDetail.data.cityId,
                      title: widget.titleController.text,
                      description: widget.descriptionController.text,
                      rating: widget.rating.toString(),
                    );

                    await PsProgressDialog.showDialog(context);
                    final PsResource<Rating> _apiStatus = await widget.provider
                        .postRating(commentHeaderParameterHolder.toMap());
                    PsProgressDialog.dismissDialog();

                    // if (_apiStatus.data != null) {
                    if (_apiStatus.status == PsStatus.SUCCESS) {
                      if (widget.checkType) {
                        final dynamic result = await Navigator.pushNamed(
                            context, RoutePaths.ratingList,
                            arguments: widget.itemProvider.itemDetail.data.id);

                        if (result != null && result) {
                          setState(() {
                            widget.itemProvider.loadItem(
                                widget.itemProvider.itemDetail.data.id,
                                widget.itemProvider.psValueHolder.loginUserId);
                          });
                        }
                      }
                      Navigator.pop(context);
                      //   setState(() {});
                    }
                    // }
                  } else {
                    print('There is no comment');

                    showDialog<dynamic>(
                        context: context,
                        builder: (BuildContext context) {
                          return WarningDialog(
                            message:
                                Utils.getString(context, 'rating_entry__error'),
                            onPressed: () {},
                          );
                        });
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
