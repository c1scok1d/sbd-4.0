import 'package:businesslistingapi/config/ps_colors.dart';
import 'package:businesslistingapi/constant/ps_dimens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:businesslistingapi/viewobject/status.dart';

class StatusListItem extends StatelessWidget {
  const StatusListItem(
      {Key key,
      @required this.status,
      @required this.selectedName,
      this.onTap,
      this.animationController,
      this.animation})
      : super(key: key);

  final Status status;
  final String selectedName;
  final Function onTap;
  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    animationController.forward();
    return AnimatedBuilder(
      animation: animationController,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          color: selectedName == status.title
              ? Colors.green[100]
              : PsColors.backgroundColor,
          width: MediaQuery.of(context).size.width,
          height: PsDimens.space52,
          margin: const EdgeInsets.only(top: PsDimens.space4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(PsDimens.space16),
                child: Text(
                  status.title,
                  textAlign: TextAlign.start,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              if (selectedName == status.title)
                Padding(
                  padding: const EdgeInsets.only(
                      right: PsDimens.space20, left: PsDimens.space20),
                  child: Image.asset(
                    'assets/images/baseline_check_green_24.png',
                    width: PsDimens.space20,
                    height: PsDimens.space20,
                  ),
                )
              else
                Container(),
            ],
          ),
        ),
      ),
      builder: (BuildContext contenxt, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 100 * (1.0 - animation.value), 0.0),
            child: child,
          ),
        );
      },
    );
  }
}
