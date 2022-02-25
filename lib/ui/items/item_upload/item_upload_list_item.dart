import 'package:businesslistingapi/config/ps_colors.dart';
import 'package:businesslistingapi/constant/ps_dimens.dart';
import 'package:businesslistingapi/ui/common/ps_ui_widget.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:businesslistingapi/viewobject/item.dart';
import 'package:flutter/material.dart';

class ItemUploadListItem extends StatelessWidget {
  const ItemUploadListItem(
      {Key key,
      @required this.item,
      this.onTap,
      this.deleteOnTap,
      this.animationController,
      this.animation})
      : super(key: key);

  final Item item;
  final Function onTap;
  final Function deleteOnTap;
  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    if (item != null) {
      animationController.forward();
      return AnimatedBuilder(
          animation: animationController,
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              margin: const EdgeInsets.only(top: PsDimens.space8),
              color: PsColors.backgroundColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _ImageAndTextWidget(
                  item: item,
                  deleteOnTap: deleteOnTap,
                ),
              ),
            ),
          ),
          builder: (BuildContext context, Widget child) {
            return FadeTransition(
                opacity: animation,
                child: Transform(
                  transform: Matrix4.translationValues(
                      0.0, 100 * (1.0 - animation.value), 0.0),
                  child: child,
                ));
          });
    } else {
      return Container();
    }
  }
}

class _ImageAndTextWidget extends StatelessWidget {
  const _ImageAndTextWidget({
    Key key,
    @required this.item,
    @required this.deleteOnTap,
  }) : super(key: key);

  final Item item;
  final Function deleteOnTap;

  @override
  Widget build(BuildContext context) {
    if (item != null && item.name != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Row(
            children: <Widget>[
              PsNetworkImage(
                photoKey: '',
                width: PsDimens.space100,
                height: PsDimens.space100,
                defaultPhoto: item.defaultPhoto,
              ),
              const SizedBox(
                width: PsDimens.space8,
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: PsDimens.space8),
                    child: Text(
                      item.name,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ),
                  const SizedBox(
                    height: PsDimens.space8,
                  ),
                  Text(
                    item.addedDate == ''
                        ? ''
                        : Utils.getDateFormat(item.addedDate),
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        .copyWith(color: PsColors.textPrimaryLightColor),
                  ),
                ],
              ),
            ],
          ),
          InkWell(
            onTap: deleteOnTap,
            child: Icon(
              Icons.delete,
              size: PsDimens.space32,
              color: PsColors.mainColor,
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}
