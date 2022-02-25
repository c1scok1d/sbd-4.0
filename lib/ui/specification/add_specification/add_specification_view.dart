import 'package:businesslistingapi/api/common/ps_resource.dart';
import 'package:businesslistingapi/config/ps_colors.dart';
import 'package:businesslistingapi/config/ps_config.dart';
import 'package:businesslistingapi/constant/ps_dimens.dart';
import 'package:businesslistingapi/provider/specification/specification_provider.dart';
import 'package:businesslistingapi/ui/common/dialog/error_dialog.dart';
import 'package:businesslistingapi/ui/common/dialog/success_dialog.dart';
import 'package:businesslistingapi/ui/common/ps_button_widget.dart';
import 'package:businesslistingapi/ui/common/ps_textfield_widget.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:businesslistingapi/viewobject/holder/add_specification_parameter_holder.dart';
import 'package:businesslistingapi/viewobject/item_spec.dart';
import 'package:flutter/services.dart';

class AddSpecificationView extends StatefulWidget {
  const AddSpecificationView(
      {Key key,
      @required this.specificationProvider,
      @required this.itemId,
      @required this.name,
      @required this.description})
      : super(key: key);
  final SpecificationProvider specificationProvider;
  final String itemId;
  final String name;
  final String description;
  @override
  _AddSpecificationViewState createState() => _AddSpecificationViewState();
}

class _AddSpecificationViewState extends State<AddSpecificationView>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

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
    if (widget.name != '' && widget.description != '') {
      nameController.text = widget.name;
      descriptionController.text = widget.description;
    }
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

    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));
    animationController.forward();
    const Widget _largeSpacingWidget = SizedBox(
      height: PsDimens.space8,
    );
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
                Utils.getString(context, 'add_specification__app_bar_name'),
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(fontWeight: FontWeight.bold)
                    .copyWith(color: PsColors.mainColorWithWhite)),
            elevation: 0,
          ),
          body: AnimatedBuilder(
              animation: animationController,
              child: SingleChildScrollView(
                  child: Container(
                padding: const EdgeInsets.all(PsDimens.space8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    PsTextFieldWidget(
                        titleText:
                            Utils.getString(context, 'add_specification__name'),
                        textAboutMe: false,
                        hintText:
                            Utils.getString(context, 'add_specification__name'),
                        textEditingController: nameController),
                    PsTextFieldWidget(
                        titleText: Utils.getString(
                            context, 'add_specification__description'),
                        textAboutMe: false,
                        height: PsDimens.space160,
                        hintText: Utils.getString(
                            context, 'add_specification__description'),
                        textEditingController: descriptionController),
                    Container(
                      margin: const EdgeInsets.only(
                          left: PsDimens.space16,
                          top: PsDimens.space16,
                          right: PsDimens.space16,
                          bottom: PsDimens.space40),
                      child: PsButtonWidget(
                        provider: widget.specificationProvider,
                        nameText: nameController,
                        descriptionText: descriptionController,
                        itemId: widget.itemId,
                      ),
                    ),
                    _largeSpacingWidget,
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
              }),
        ));
  }
}

class PsButtonWidget extends StatelessWidget {
  const PsButtonWidget({
    @required this.nameText,
    @required this.descriptionText,
    @required this.provider,
    @required this.itemId,
  });

  final TextEditingController nameText, descriptionText;
  final SpecificationProvider provider;
  final String itemId;

  @override
  Widget build(BuildContext context) {
    return PSButtonWidget(
        hasShadow: true,
        width: double.infinity,
        titleText: Utils.getString(context, 'add_specification__save_btn'),
        onPressed: () async {
          if (nameText.text == '' || descriptionText.text == '') {
            showDialog<dynamic>(
                context: context,
                builder: (BuildContext context) {
                  return ErrorDialog(
                    message: Utils.getString(
                        context, 'add_specification__insert_value'),
                  );
                });
          } else {
            if (await Utils.checkInternetConnectivity()) {
              final AddSpecificationParameterHolder
                  addSpecificationParameterHolder =
                  AddSpecificationParameterHolder(
                itemId: itemId,
                name: nameText.text,
                description: descriptionText.text,
              );

              final PsResource<ItemSpecification> _apiStatus = await provider
                  .postSpecification(addSpecificationParameterHolder.toMap());

              if (_apiStatus.data != null) {
                print('Success');
                nameText.clear();
                descriptionText.clear();
                showDialog<dynamic>(
                    context: context,
                    builder: (BuildContext context) {
                      if (_apiStatus.data != null) {
                        return SuccessDialog(
                          message: Utils.getString(
                              context, 'add_specification__success'),
                          onPressed: () {
                            Navigator.pop(context, _apiStatus.data);
                          },
                        );
                      } else {
                        return ErrorDialog(
                          message: Utils.getString(
                              context, 'add_specification__fail'),
                        );
                      }
                    });
              }
            } else {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return ErrorDialog(
                      message:
                          Utils.getString(context, 'error_dialog__no_internet'),
                    );
                  });
            }
          }
        });
  }
}
