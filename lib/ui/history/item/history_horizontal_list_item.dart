import 'package:businesslistingapi/config/ps_colors.dart';
import 'package:businesslistingapi/constant/ps_dimens.dart';
import 'package:businesslistingapi/ui/common/ps_ui_widget.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:businesslistingapi/viewobject/item.dart';
import 'package:flutter/material.dart';

class HistoryHorizontalListItem extends StatelessWidget {
  const HistoryHorizontalListItem(
      {Key key,
      @required this.history,
      this.onTap,
      this.animationController,
      this.animation})
      : super(key: key);

  final Item history;
  final Function onTap;
  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    if (history != null) {
      animationController.forward();
      return GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.all(PsDimens.space4),
          color: PsColors.backgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(PsDimens.space8),
            child: _ImageAndTextWidget(
              history: history,
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}

class _ImageAndTextWidget extends StatelessWidget {
  const _ImageAndTextWidget({
    Key key,
    @required this.history,
  }) : super(key: key);

  final Item history;

  @override
  Widget build(BuildContext context) {
    if (history != null && history.name != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          PsNetworkImage(
            photoKey: '',
            width: PsDimens.space120,
            height: PsDimens.space100,
            defaultPhoto: history.defaultPhoto,
          ),
          const SizedBox(
            height: PsDimens.space4,
          ),
          Text(
            history.name,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.subtitle2,
          ),
          // ),
          const SizedBox(
            height: PsDimens.space4,
          ),
          Text(
            history.addedDate == ''
                ? ''
                : Utils.getDateFormat(history.addedDate),
            style: Theme.of(context)
                .textTheme
                .caption
                .copyWith(color: PsColors.textPrimaryLightColor),
          ),
          const SizedBox(
            height: PsDimens.space4,
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}
