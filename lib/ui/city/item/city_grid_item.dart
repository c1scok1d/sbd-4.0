import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:businesslistingapi/constant/ps_dimens.dart';
import 'package:businesslistingapi/ui/common/ps_ui_widget.dart';
import 'package:businesslistingapi/viewobject/city.dart';

class CityGridItem extends StatelessWidget {
  const CityGridItem({
    Key key,
    @required this.city,
    this.onTap,
    this.animationController,
    this.animation,
  }) : super(key: key);

  final City city;
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
              child: ClipPath(
                child: Container(child: CityWidget(city: city, onTap: onTap)),
                clipper: ShapeBorderClipper(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4))),
              ),
            )),
        builder: (BuildContext context, Widget child) {
          return FadeTransition(
              opacity: animation,
              child: Transform(
                  transform: Matrix4.translationValues(
                      0.0, 100 * (1.0 - animation.value), 0.0),
                  child: child));
        });
  }
}

class CityWidget extends StatelessWidget {
  const CityWidget({Key key, @required this.city, @required this.onTap})
      : super(key: key);

  final City city;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(PsDimens.space8)),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: PsNetworkImage(
              photoKey: '',
              defaultPhoto: city.defaultPhoto,
              width: double.infinity,
              //height: double.infinity,
              boxfit: BoxFit.cover,
              onTap: onTap,
            ),
          ),
          Container(
            margin: const EdgeInsets.all(PsDimens.space12),
            child: Text(
              city.name,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
        ],
      ),
    );
  }
}
