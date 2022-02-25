import 'package:flutter/material.dart';
import 'package:businesslistingapi/config/ps_colors.dart';
import 'package:businesslistingapi/constant/ps_dimens.dart';
import 'package:businesslistingapi/viewobject/item_spec.dart';

class ItemSpecificationListItem extends StatelessWidget {
  const ItemSpecificationListItem({
    Key key,
    @required this.specification,
    this.onSpecificationTap,
    this.onDeleteTap,
    this.animationController,
    this.animation,
  }) : super(key: key);

  final ItemSpecification specification;
  final Function onSpecificationTap;
  final Function onDeleteTap;
  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    animationController.forward();
    return AnimatedBuilder(
        animation: animationController,
        child: GestureDetector(
            onTap: onSpecificationTap,
            child: Container(
              margin: const EdgeInsets.only(
                  left: PsDimens.space12,
                  right: PsDimens.space12,
                  bottom: PsDimens.space12),
              padding: const EdgeInsets.all(PsDimens.space12),
              decoration: BoxDecoration(
                  border: Border.all(color: PsColors.grey),
                  borderRadius: BorderRadius.circular(PsDimens.space12)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    specification.name,
                    style: Theme.of(context).textTheme.bodyText1,
                    textAlign: TextAlign.start,
                  ),
                  Row(
                    children: <Widget>[
                      InkWell(
                        onTap: onSpecificationTap,
                        child: Text(
                          'Edit',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(color: PsColors.mainColor),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      const SizedBox(
                        width: PsDimens.space8,
                      ),
                      InkWell(
                        onTap: onDeleteTap,
                        child: Icon(
                          Icons.delete,
                          size: PsDimens.space32,
                          color: PsColors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
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
