import 'package:businesslistingapi/config/ps_colors.dart';
import 'package:businesslistingapi/constant/ps_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:businesslistingapi/constant/ps_dimens.dart';
import 'package:businesslistingapi/ui/common/ps_ui_widget.dart';
import 'package:businesslistingapi/ui/common/smooth_star_rating_widget.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:businesslistingapi/viewobject/item.dart';

class ItemVeticalListItem extends StatelessWidget {
  const ItemVeticalListItem(
      {Key key,
      @required this.item,
      this.onTap,
      this.animationController,
      this.animation,
      this.coreTagKey})
      : super(key: key);

  final Item item;
  final Function onTap;
  final String coreTagKey;
  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    animationController.forward();
    return AnimatedBuilder(
        animation: animationController,
        child: GestureDetector(
            onTap: onTap,
            child: GridTile(
              header: Container(
                padding: const EdgeInsets.all(PsDimens.space8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Container(
                    //     child: item.isDiscount == PsConst.ONE
                    //         ? Container(
                    //             width: PsDimens.space52,
                    //             height: PsDimens.space24,
                    //             child: Stack(
                    //               children: <Widget>[
                    //                 Image.asset(
                    //                     'assets/images/baseline_percent_tag_orange_24.png',
                    //                     matchTextDirection: true,
                    //                     color: PsColors.mainColor),
                    //                 Center(
                    //                   child: Text(
                    //                     '-${item.discountPercent}%',
                    //                     textAlign: TextAlign.start,
                    //                     style: Theme.of(context)
                    //                         .textTheme
                    //                         .bodyText2
                    //                         .copyWith(
                    //                             color:
                    //                                 PsColors.white),
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //           )
                    //         : Container()),

                    Padding(
                      padding: const EdgeInsets.only(
                          left: PsDimens.space8, top: PsDimens.space8),
                      child: Align(
                          alignment: Alignment.topRight,
                          child: item.isFeatured == PsConst.ONE
                              ? Image.asset(
                                  'assets/images/baseline_feature_circle_24.png',
                                  width: PsDimens.space32,
                                  height: PsDimens.space32,
                                )
                              : Container()),
                    )
                  ],
                ),
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: PsDimens.space8, vertical: PsDimens.space8),
                decoration: BoxDecoration(
                  color: PsColors.backgroundColor,
                  borderRadius:
                      const BorderRadius.all(Radius.circular(PsDimens.space8)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.circular(PsDimens.space8)),
                        ),
                        child: ClipPath(
                          child: PsNetworkImage(
                            photoKey: '',
                            defaultPhoto: item.defaultPhoto,
                            width: PsDimens.space180,
                            height: double.infinity,
                            boxfit: BoxFit.cover,
                            onTap: () {
                              Utils.psPrint(item.defaultPhoto.imgParentId);
                              onTap();
                            },
                          ),
                          clipper: const ShapeBorderClipper(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(PsDimens.space8)))),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: PsDimens.space8,
                          top: PsDimens.space12,
                          right: PsDimens.space8,
                          bottom: PsDimens.space12),
                      child: Text(
                        item.name,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyText1,
                        maxLines: 1,
                      ),
                      // ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(
                        left: PsDimens.space8,
                        right: PsDimens.space8,
                      ),
                      child: Text(
                        item.city.name,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(color: PsColors.mainColor),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      // ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(
                        left: PsDimens.space8,
                        top: PsDimens.space8,
                        right: PsDimens.space8,
                      ),
                      child: Text(
                        item.description,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyText1,
                        maxLines: 1,
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(
                    //       left: PsDimens.space8,
                    //       top: PsDimens.space4,
                    //       right: PsDimens.space8),
                    //   child: Row(
                    //     children: <Widget>[
                    //       PsHero(
                    //         tag:
                    //             '$coreTagKey$PsConst.HERO_TAG__UNIT_PRICE',
                    //         flightShuttleBuilder:
                    //             Utils.flightShuttleBuilder,
                    //         child: Material(
                    //           type: MaterialType.transparency,
                    //           child: Text(
                    //               '${item.currencySymbol}${Utils.getPriceFormat(item.unitPrice)}',
                    //               textAlign: TextAlign.start,
                    //               style: Theme.of(context)
                    //                   .textTheme
                    //                   .subtitle2
                    //                   .copyWith(
                    //                       color: PsColors.mainColor)),
                    //         ),
                    //       ),
                    //       Padding(
                    //           padding: const EdgeInsets.only(
                    //               left: PsDimens.space8,
                    //               right: PsDimens.space8),
                    //           child: item.isDiscount == PsConst.ONE
                    //               ? PsHero(
                    //                   tag:
                    //                       '$coreTagKey$PsConst.HERO_TAG__ORIGINAL_PRICE',
                    //                   flightShuttleBuilder:
                    //                       Utils.flightShuttleBuilder,
                    //                   child: Material(
                    //                     color: PsColors.transparent,
                    //                     child: Text(
                    //                       '${item.currencySymbol}${Utils.getPriceFormat(item.originalPrice)}',
                    //                       textAlign: TextAlign.start,
                    //                       style: Theme.of(context)
                    //                           .textTheme
                    //                           .bodyText2
                    //                           .copyWith(
                    //                               decoration:
                    //                                   TextDecoration
                    //                                       .lineThrough),
                    //                     ),
                    //                   ),
                    //                 )
                    //               : Container()),
                    //     ],
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: PsDimens.space8,
                          top: PsDimens.space8,
                          right: PsDimens.space4),
                      child: SmoothStarRating(
                          key: Key(item.ratingDetail.totalRatingValue),
                          rating:
                              double.parse(item.ratingDetail.totalRatingValue),
                          allowHalfRating: false,
                          onRated: (double v) {
                            onTap();
                          },
                          starCount: 5,
                          size: 20.0,
                          color: PsColors.ratingColor,
                          borderColor: Utils.isLightMode(context)
                              ? PsColors.black.withAlpha(100)
                              : PsColors.white,
                          spacing: 0.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: PsDimens.space4,
                          bottom: PsDimens.space12,
                          left: PsDimens.space12,
                          right: PsDimens.space12),
                      child: Row(
                        children: <Widget>[
                          Text(
                              '${item.ratingDetail.totalRatingValue} ${Utils.getString(context, 'feature_slider__rating')}',
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.caption),
                          Expanded(
                            child: Text(
                                '( ${item.ratingDetail.totalRatingCount} ${Utils.getString(context, 'feature_slider__reviewer')} )',
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.caption),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )),
        builder: (BuildContext context, Widget child) {
          return FadeTransition(
              opacity: animation,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 100 * (1.0 - animation.value), 0.0),
                child: child,
              ));
        });
  }
}
