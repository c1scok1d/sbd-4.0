import 'package:businesslistingapi/config/ps_colors.dart';
import 'package:businesslistingapi/constant/ps_dimens.dart';
import 'package:businesslistingapi/ui/common/ps_ui_widget.dart';
import 'package:businesslistingapi/ui/common/smooth_star_rating_widget.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:businesslistingapi/viewobject/item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ItemHorizontalListItem extends StatelessWidget {
  const ItemHorizontalListItem({
    Key key,
    @required this.item,
    @required this.coreTagKey,
    this.onTap,
  }) : super(key: key);

  final Item item;
  final Function onTap;
  final String coreTagKey;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 0.0,
          color: PsColors.transparent,
          child: Container(
            margin: const EdgeInsets.symmetric(
                horizontal: PsDimens.space4, vertical: PsDimens.space12),
            decoration: const BoxDecoration(
              // color: PsColors.backgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(PsDimens.space12)),
            ),
            width: PsDimens.space180,
            child: Stack(
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
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
                        left: PsDimens.space10,
                        top: PsDimens.space12,
                        right: PsDimens.space8,
                      ),
                      child: Text(
                        item.name,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyText1,
                        maxLines: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: PsDimens.space10,
                          top: PsDimens.space2,
                          right: PsDimens.space8,
                          bottom: PsDimens.space2),
                      child: Text(
                        item.city.name,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(color: PsColors.mainColor),
                        maxLines: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: PsDimens.space8,
                        right: PsDimens.space8, /*bottom: PsDimens.space4*/
                      ),
                      child: Visibility(
                        visible: false,
                        child: Text(
                          item.description,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.caption,
                          maxLines: 1,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: PsDimens.space8,
                          top: PsDimens.space4,
                          right: PsDimens.space8),
                      child: SmoothStarRating(
                          key: Key(item.ratingDetail?.totalRatingValue),
                          rating: item.ratingDetail == null
                              ? double.parse('0')
                              : double.parse(
                                      item.ratingDetail?.totalRatingValue) ??
                                  0,
                          allowHalfRating: false,
                          isReadOnly: true,
                          onRated: (double v) async {
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
                        right: PsDimens.space8,
                      ),
                      child: Row(
                        children: <Widget>[
                          Text(
                              '${item.ratingDetail == null ? '0' : item.ratingDetail.totalRatingValue} ${Utils.getString(context, 'feature_slider__rating')}',
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.caption),
                          Expanded(
                            child: Text(
                                '( ${item.ratingDetail == null ? '0' : item.ratingDetail.totalRatingCount} ${Utils.getString(context, 'feature_slider__reviewer')} )',
                                textAlign: TextAlign.start,
                                softWrap: false,
                                style: Theme.of(context).textTheme.caption),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
