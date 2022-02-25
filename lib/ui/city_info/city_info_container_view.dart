import 'package:flutter/material.dart';
import 'package:businesslistingapi/config/ps_colors.dart';
import 'package:businesslistingapi/config/ps_config.dart';
import 'package:businesslistingapi/ui/city_info/city_info_view.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:businesslistingapi/viewobject/city.dart';
import 'package:flutter/services.dart';

class CityInfoContainerView extends StatefulWidget {
  const CityInfoContainerView({
    Key key,
    @required this.cityInfo,
  }) : super(key: key);

  final City cityInfo;
  @override
  _CityInfoContainerViewState createState() => _CityInfoContainerViewState();
}

class _CityInfoContainerViewState extends State<CityInfoContainerView>
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

  @override
  Widget build(BuildContext context) {
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
          iconTheme:
              Theme.of(context).iconTheme.copyWith(color: PsColors.white),
          title: Text(widget.cityInfo.name,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(fontWeight: FontWeight.bold)
                  .copyWith(color: PsColors.white)),
          elevation: 0,
          backgroundColor:
              Utils.isLightMode(context) ? PsColors.mainColor : Colors.black12,
        ),
        body: Container(
          color: PsColors.coreBackgroundColor,
          height: double.infinity,
          child: CityInfoView(
              cityInfo: widget.cityInfo,
              animationController: animationController,
              animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                      parent: animationController,
                      curve: const Interval((1 / 2) * 1, 1.0,
                          curve: Curves.fastOutSlowIn)))),
        ),
      ),
    );
  }
}
