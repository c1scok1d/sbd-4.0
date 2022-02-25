import 'package:businesslistingapi/constant/ps_dimens.dart';
import 'package:businesslistingapi/provider/city_info/city_info_provider.dart';
import 'package:businesslistingapi/repository/city_info_repository.dart';
import 'package:businesslistingapi/ui/common/base/ps_widget_with_appbar_with_no_provider.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:businesslistingapi/viewobject/common/ps_value_holder.dart';
import 'package:flutter/material.dart';

class SettingPrivacyPolicyView extends StatefulWidget {
  const SettingPrivacyPolicyView(
      {@required this.checkType, @required this.description});
  final int checkType;
  final String description;
  @override
  _SettingPrivacyPolicyViewState createState() {
    return _SettingPrivacyPolicyViewState();
  }
}

class _SettingPrivacyPolicyViewState extends State<SettingPrivacyPolicyView>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  CityInfoProvider _cityInfoProvider;

  AnimationController animationController;
  Animation<double> animation;

  @override
  void dispose() {
    animationController.dispose();
    animation = null;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _cityInfoProvider.nextCityInfoList();
      }
    });

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..addListener(() => setState(() {}));

    animation = Tween<double>(
      begin: 0.0,
      end: 10.0,
    ).animate(animationController);
  }

  CityInfoRepository repo1;
  PsValueHolder valueHolder;
  @override
  Widget build(BuildContext context) {
    return PsWidgetWithAppBarWithNoProvider(
        appBarTitle: widget.checkType == 2
            ? Utils.getString(context, 'cancellation_policy__toolbar_name')
            : widget.checkType == 1
                ? Utils.getString(context, 'terms_and_condition__toolbar_name')
                : widget.checkType == 3
                    ? Utils.getString(context, 'additional_info__toolbar_name')
                    : Utils.getString(
                        context, 'terms_and_condition__toolbar_name'),
        child: Padding(
          padding: const EdgeInsets.all(PsDimens.space16),
          child: SingleChildScrollView(
            child: Text(
              widget.description,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(height: 1.5, fontSize: PsDimens.space16),
            ),
          ),
        ));
  }
}
