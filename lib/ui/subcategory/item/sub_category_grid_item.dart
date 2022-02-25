import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:businesslistingapi/config/ps_colors.dart';
import 'package:businesslistingapi/constant/ps_dimens.dart';
import 'package:businesslistingapi/ui/common/ps_ui_widget.dart';
import 'package:businesslistingapi/viewobject/sub_category.dart';

class SubCategoryGridItem extends StatelessWidget {
  const SubCategoryGridItem(
      {Key key,
      @required this.subCategory,
      this.onTap,
      this.animationController,
      this.animation})
      : super(key: key);

  final SubCategory subCategory;
  final Function onTap;
  final AnimationController animationController;
  final Animation<double> animation;
  @override
  Widget build(BuildContext context) {
    animationController.forward();
    return AnimatedBuilder(
        animation: animationController,
        child: InkWell(
            onTap: onTap,
            child: Card(
                elevation: 0.3,
                child: Container(
                    child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Stack(
                          children: <Widget>[
                            PsNetworkImage(
                              photoKey: '',
                              defaultPhoto: subCategory.defaultPhoto,
                              width: double.infinity,
                              height: PsDimens.space120,
                              boxfit: BoxFit.cover,
                            ),
                            Container(
                              width: double.infinity,
                              height: PsDimens.space120,
                              color: PsColors.black.withAlpha(110),
                            )
                          ],
                        )),
                    Text(
                      subCategory.name,
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.subtitle2.copyWith(
                          color: PsColors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                )))),
        builder: (BuildContext context, Widget child) {
          return FadeTransition(
            opacity: animation,
            child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 100 * (1.0 - animation.value), 0.0),
                child: child),
          );
        });
  }
}
