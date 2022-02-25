import 'dart:async';
import 'package:businesslistingapi/config/ps_colors.dart';
import 'package:businesslistingapi/config/ps_config.dart';
import 'package:businesslistingapi/constant/ps_dimens.dart';
import 'package:businesslistingapi/constant/route_paths.dart';
// import 'package:businesslistingapi/ui/common/ps_admob_banner_widget.dart';
import 'package:businesslistingapi/ui/common/ps_back_button_with_circle_bg_widget.dart';
import 'package:businesslistingapi/ui/common/ps_ui_widget.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:businesslistingapi/viewobject/blog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BlogView extends StatefulWidget {
  const BlogView({Key key, @required this.blog, @required this.heroTagImage})
      : super(key: key);

  final Blog blog;
  final String heroTagImage;

  @override
  _BlogViewState createState() => _BlogViewState();
}

class _BlogViewState extends State<BlogView> {
  bool isReadyToShowAppBarIcons = false;

  @override
  Widget build(BuildContext context) {
    if (!isReadyToShowAppBarIcons) {
      Timer(const Duration(milliseconds: 800), () {
        setState(() {
          isReadyToShowAppBarIcons = true;
        });
      });
    }

    return Scaffold(
        body: CustomScrollView(
      shrinkWrap: true,
      slivers: <Widget>[
        SliverAppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness: Utils.getBrightnessForAppBar(context),
          ),
          expandedHeight: PsDimens.space300,
          floating: true,
          pinned: true,
          snap: false,
          elevation: 0,
          leading: PsBackButtonWithCircleBgWidget(
              isReadyToShow: isReadyToShowAppBarIcons),
          backgroundColor: PsColors.mainColor,
          flexibleSpace: FlexibleSpaceBar(
            background: PsNetworkImage(
              photoKey: widget.heroTagImage,
              height: PsDimens.space300,
              width: double.infinity,
              defaultPhoto: widget.blog.defaultPhoto,
              boxfit: BoxFit.cover,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: TextWidget(
            blog: widget.blog,
          ),
        )
      ],
    ));
  }
}

class TextWidget extends StatefulWidget {
  const TextWidget({
    Key key,
    @required this.blog,
  }) : super(key: key);

  final Blog blog;

  @override
  _TextWidgetState createState() => _TextWidgetState();
}

class _TextWidgetState extends State<TextWidget> {
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet && PsConfig.showAdMob) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isConnectedToInternet && PsConfig.showAdMob) {
      print('loading ads....');
      checkConnection();
    }
    return Container(
      color: PsColors.backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(PsDimens.space12),
            child: Text(
              widget.blog.name,
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: PsDimens.space12,
                right: PsDimens.space12,
                bottom: PsDimens.space12),
            child: Text(
              widget.blog.description,
              style:
                  Theme.of(context).textTheme.bodyText1.copyWith(height: 1.5),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                RoutePaths.itemHome,
                arguments: widget.blog.city,
              );
            },
            child: Container(
                color: PsColors.backgroundColor,
                padding: const EdgeInsets.only(
                    top: PsDimens.space4,
                    bottom: PsDimens.space12,
                    left: PsDimens.space8,
                    right: PsDimens.space8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(PsDimens.space4),
                        child: PsNetworkImage(
                          height: PsDimens.space60,
                          width: PsDimens.space60,
                          photoKey: '${widget.blog.id} ${widget.blog.city.id}',
                          defaultPhoto: widget.blog.defaultPhoto,
                          boxfit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: PsDimens.space12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.blog.city.name,
                          maxLines: 1,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        const SizedBox(height: PsDimens.space8),
                        Text(
                          widget.blog.addedDateStr,
                          maxLines: 1,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ],
                    ),
                  ],
                )),
          ),
          // const PsAdMobBannerWidget(),
          // Visibility(
          //   visible: PsConfig.showAdMob &&
          //       isSuccessfullyLoaded &&
          //       isConnectedToInternet,
          //   child: AdmobBanner(
          //     adUnitId: Utils.getBannerAdUnitId(),
          //     adSize: AdmobBannerSize.FULL_BANNER,
          //     listener: (AdmobAdEvent event, Map<String, dynamic> map) {
          //       print('BannerAd event is $event');
          //       if (event == AdmobAdEvent.loaded) {
          //         isSuccessfullyLoaded = true;
          //       } else {
          //         isSuccessfullyLoaded = false;
          //         setState(() {});
          //       }
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
