import 'dart:async';
import 'package:businesslistingapi/config/ps_colors.dart';
import 'package:businesslistingapi/config/ps_config.dart';
import 'package:businesslistingapi/constant/ps_dimens.dart';
import 'package:businesslistingapi/ui/common/ps_ui_widget.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:businesslistingapi/viewobject/item.dart';
import 'package:flutter/services.dart';

class DescriptionDetailView extends StatefulWidget {
  const DescriptionDetailView({Key key, @required this.itemData})
      : super(key: key);

  final Item itemData;

  @override
  _DescriptionDetailViewState createState() => _DescriptionDetailViewState();
}

class _DescriptionDetailViewState extends State<DescriptionDetailView> {
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
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness: Utils.getBrightnessForAppBar(context),
          ),
          iconTheme: Theme.of(context)
              .iconTheme
              .copyWith(color: PsColors.mainColorWithWhite),
          title: Text(widget.itemData.name ?? '',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(fontWeight: FontWeight.bold)
                  .copyWith(color: PsColors.mainColorWithWhite)),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              PsNetworkImage(
                photoKey: '',
                height: PsDimens.space300,
                width: double.infinity,
                defaultPhoto: widget.itemData.defaultPhoto,
                boxfit: BoxFit.cover,
              ),
              Container(
                margin: const EdgeInsets.all(PsDimens.space12),
                child: Text(
                  widget.itemData.description,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(height: 1.5),
                ),
              ),
            ],
          ),
        ));
  }
}

class TextWidget extends StatefulWidget {
  const TextWidget({
    Key key,
    @required this.itemData,
  }) : super(key: key);

  final Item itemData;

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
              widget.itemData.name,
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
