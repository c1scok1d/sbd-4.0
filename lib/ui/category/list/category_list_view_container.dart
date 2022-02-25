import 'package:businesslistingapi/config/ps_colors.dart';
import 'package:businesslistingapi/config/ps_config.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:businesslistingapi/viewobject/city.dart';
import 'package:flutter/services.dart';
import 'category_list_view.dart';

class CategoryListViewContainerView extends StatefulWidget {
  const CategoryListViewContainerView(
      {@required this.appBarTitle, @required this.city});

  final String appBarTitle;
  final City city;
  @override
  _CategoryListWithFilterContainerViewState createState() =>
      _CategoryListWithFilterContainerViewState();
}

class _CategoryListWithFilterContainerViewState
    extends State<CategoryListViewContainerView>
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

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

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
          backgroundColor:
              Utils.isLightMode(context) ? PsColors.mainColor : Colors.black12,
          iconTheme:
              Theme.of(context).iconTheme.copyWith(color: PsColors.white),
          title: Text(
            widget.appBarTitle,
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(fontWeight: FontWeight.bold, color: PsColors.white),
          ),
          elevation: 0,
        ),
        body: CategoryListView(
          city: widget.city,
        ),
      ),
    );
  }
}
