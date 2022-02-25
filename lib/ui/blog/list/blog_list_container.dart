import 'package:businesslistingapi/config/ps_colors.dart';
import 'package:businesslistingapi/config/ps_config.dart';
import 'package:businesslistingapi/ui/blog/list/blog_list_view.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BlogListContainerView extends StatefulWidget {
  @override
  _BlogListContainerViewState createState() => _BlogListContainerViewState();
}

class _BlogListContainerViewState extends State<BlogListContainerView>
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
          backgroundColor:
              Utils.isLightMode(context) ? PsColors.mainColor : Colors.black12,
          title: Text(Utils.getString(context, 'blog_list__app_bar_name'),
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(fontWeight: FontWeight.bold)
                  .copyWith(color: PsColors.white)),
          elevation: 0,
        ),
        body: Container(
          color: PsColors.coreBackgroundColor,
          height: double.infinity,
          child: BlogListView(
            animationController: animationController,
          ),
        ),
      ),
    );
  }
}
