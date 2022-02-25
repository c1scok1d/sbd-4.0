import 'package:flutter/material.dart';
import 'package:businesslistingapi/constant/ps_dimens.dart';
import 'package:businesslistingapi/provider/city_info/city_info_provider.dart';
import 'package:businesslistingapi/repository/city_info_repository.dart';
import 'package:businesslistingapi/viewobject/common/ps_value_holder.dart';
import 'package:provider/provider.dart';

class TermsAndConditionsView extends StatefulWidget {
  const TermsAndConditionsView({Key key, @required this.animationController})
      : super(key: key);
  final AnimationController animationController;
  @override
  _TermsAndConditionsViewState createState() => _TermsAndConditionsViewState();
}

class _TermsAndConditionsViewState extends State<TermsAndConditionsView> {
  CityInfoRepository repo1;
  PsValueHolder psValueHolder;
  CityInfoProvider provider;
  @override
  Widget build(BuildContext context) {
    repo1 = Provider.of<CityInfoRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);
    final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
            parent: widget.animationController,
            curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));
    widget.animationController.forward();
    return ChangeNotifierProvider<CityInfoProvider>(
        lazy: false,
        create: (BuildContext context) {
          provider = CityInfoProvider(
              repo: repo1,
              //  ownerCode: null,
              psValueHolder: psValueHolder);
          provider.loadCityInfo();
          return provider;
        },
        child: Consumer<CityInfoProvider>(builder: (BuildContext context,
            CityInfoProvider basketProvider, Widget child) {
          return AnimatedBuilder(
            animation: widget.animationController,
            child: Padding(
              padding: const EdgeInsets.all(PsDimens.space16),
              child: SingleChildScrollView(
                child: Text(
                  provider.cityInfo != null && provider.cityInfo.data != null
                      ? provider.cityInfo.data.termsAndCondition
                      : '',
                  style: Theme.of(context).textTheme.bodyText1,
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
                ),
              );
            },
          );
        }));
  }
}
