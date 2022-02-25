import 'package:businesslistingapi/config/ps_colors.dart';
import 'package:businesslistingapi/config/ps_config.dart';
import 'package:businesslistingapi/ui/user/more/more_view.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MoreContainerView extends StatefulWidget {
  const MoreContainerView({@required this.userName});

  final String userName;

  @override
  _MoreContainerViewState createState() => _MoreContainerViewState();
}

class _MoreContainerViewState extends State<MoreContainerView>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  //Function callLogoutCallBack;

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
          iconTheme: Theme.of(context)
              .iconTheme
              .copyWith(color: PsColors.mainColorWithWhite),
          title: Text(
            widget.userName,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6.copyWith(
                color: PsColors.mainColor, fontWeight: FontWeight.bold),
          ),
          elevation: 0,
        ),
        body: Container(
          color: PsColors.mainDividerColor,
          height: double.infinity,
          child: MoreView(
            //callLogoutCallBack: callLogoutCallBack,
            animationController: animationController,
          ),
        ),
      ),
    );
  }
}
