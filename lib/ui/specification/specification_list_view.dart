import 'package:businesslistingapi/config/ps_colors.dart';
import 'package:businesslistingapi/config/ps_config.dart';
import 'package:businesslistingapi/constant/ps_dimens.dart';
import 'package:businesslistingapi/constant/route_paths.dart';
import 'package:businesslistingapi/provider/specification/specification_provider.dart';
import 'package:businesslistingapi/repository/specification_repository.dart';
import 'package:businesslistingapi/ui/common/base/ps_widget_with_multi_provider.dart';
import 'package:flutter/material.dart';
import 'package:businesslistingapi/ui/common/dialog/warning_dialog_view.dart';
import 'package:businesslistingapi/ui/specification/specification_list_item_view.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:businesslistingapi/viewobject/holder/delete_specification_paramenter_holder.dart';
import 'package:businesslistingapi/viewobject/holder/intent_holder/add_specification_intent_holder.dart';
import 'package:businesslistingapi/viewobject/item_spec.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class SpecificationListView extends StatefulWidget {
  const SpecificationListView({
    Key key,
    @required this.itemId,
  }) : super(key: key);

  final String itemId;
  @override
  _SpecificationListViewState createState() => _SpecificationListViewState();
}

class _SpecificationListViewState extends State<SpecificationListView>
    with SingleTickerProviderStateMixin {
  SpecificationProvider specificationProvider;
  AnimationController animationController;
  Animation<double> animation;

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
    final SpecificationRepository specificationRepository =
        Provider.of<SpecificationRepository>(context);

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
        child: PsWidgetWithMultiProvider(
            child: MultiProvider(
                providers: <SingleChildWidget>[
              ChangeNotifierProvider<SpecificationProvider>(
                lazy: false,
                create: (BuildContext context) {
                  specificationProvider =
                      SpecificationProvider(repo: specificationRepository);
                  specificationProvider.loadSpecificationList(widget.itemId);
                  return specificationProvider;
                },
              ),
            ],
                child: Scaffold(
                    appBar: AppBar(
                      systemOverlayStyle: SystemUiOverlayStyle(
                        statusBarIconBrightness: Utils.getBrightnessForAppBar(context),
                      ),
                      iconTheme: Theme.of(context)
                          .iconTheme
                          .copyWith(color: PsColors.mainColorWithWhite),
                      title: Text(
                        Utils.getString(
                            context, 'specification_list__app_bar_name'),
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(fontWeight: FontWeight.bold)
                            .copyWith(color: PsColors.mainColorWithWhite),
                      ),
                      titleSpacing: 0,
                      elevation: 0,
                      toolbarTextStyle:  TextStyle(color: PsColors.textPrimaryColor),
                      actions: <Widget>[
                        InkWell(
                          onTap: () async {
                            final dynamic returnData =
                                await Navigator.pushNamed(
                                    context, RoutePaths.addSpecification,
                                    arguments: SpecificationIntentHolder(
                                      itemId: widget.itemId,
                                      specificationProvider:
                                          specificationProvider,
                                      name: '',
                                      description: '',
                                    ));
                            if (returnData != null &&
                                returnData is ItemSpecification) {
                              await specificationProvider
                                  .loadSpecificationList(returnData.itemId);
                              setState(() {});
                            }
                          },
                          child: Container(
                            alignment: Alignment.centerRight,
                            margin: const EdgeInsets.only(
                                left: PsDimens.space8, right: PsDimens.space8),
                            child: Text(
                              Utils.getString(
                                  context, 'specification_list__add_btn'),
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: PsColors.mainColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                    body: Consumer<SpecificationProvider>(builder:
                        (BuildContext context,
                            SpecificationProvider specificationProvider,
                            Widget child) {
                      if (specificationProvider.specificationList != null &&
                          specificationProvider.specificationList.data !=
                              null &&
                          specificationProvider
                              .specificationList.data.isNotEmpty) {
                        return Container(
                          color: Theme.of(context).cardColor,
                          height: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: CustomScrollView(shrinkWrap: true, slivers: <
                                Widget>[
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    return ItemSpecificationListItem(
                                        specification: specificationProvider
                                            .specificationList.data[index],
                                        animationController:
                                            animationController,
                                        animation:
                                            Tween<double>(begin: 0.0, end: 1.0)
                                                .animate(
                                          CurvedAnimation(
                                            parent: animationController,
                                            curve: Interval(
                                                (1 /
                                                        specificationProvider
                                                            .specificationList
                                                            .data
                                                            .length) *
                                                    index,
                                                1.0,
                                                curve: Curves.fastOutSlowIn),
                                          ),
                                        ),
                                        onDeleteTap: () async {
                                          showDialog<dynamic>(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return WarningDialog(
                                                  message: Utils.getString(
                                                      context,
                                                      'specification_list__delete_warning'),
                                                  onPressed: () async {
                                                    if (await Utils
                                                        .checkInternetConnectivity()) {
                                                      if (await Utils
                                                          .checkInternetConnectivity()) {
                                                        final DeleteSpecificationParameterHolder
                                                            deleteSpecificationParameterHolder =
                                                            DeleteSpecificationParameterHolder(
                                                          itemId: widget.itemId,
                                                          id: specificationProvider
                                                              .specificationList
                                                              .data[index]
                                                              .id,
                                                        );
                                                        await specificationProvider
                                                            .postDeleteSpecification(
                                                                deleteSpecificationParameterHolder
                                                                    .toMap());
                                                        await specificationProvider
                                                            .loadSpecificationList(
                                                                widget.itemId);
                                                        setState(() {});
                                                      }
                                                    }
                                                  },
                                                );
                                              });
                                        },
                                        onSpecificationTap: () async {
                                          final dynamic returnData =
                                              await Navigator.pushNamed(context,
                                                  RoutePaths.addSpecification,
                                                  arguments:
                                                      SpecificationIntentHolder(
                                                    itemId: widget.itemId,
                                                    specificationProvider:
                                                        specificationProvider,
                                                    name: specificationProvider
                                                        .specificationList
                                                        .data[index]
                                                        .name,
                                                    description:
                                                        specificationProvider
                                                            .specificationList
                                                            .data[index]
                                                            .description,
                                                  ));
                                          if (returnData != null &&
                                              returnData is ItemSpecification) {
                                            // postDeleteSpecification
                                            if (await Utils
                                                .checkInternetConnectivity()) {
                                              final DeleteSpecificationParameterHolder
                                                  deleteSpecificationParameterHolder =
                                                  DeleteSpecificationParameterHolder(
                                                itemId: returnData.itemId,
                                                id: specificationProvider
                                                    .specificationList
                                                    .data[index]
                                                    .id,
                                              );
                                              await specificationProvider
                                                  .postDeleteSpecification(
                                                      deleteSpecificationParameterHolder
                                                          .toMap());
                                              await specificationProvider
                                                  .loadSpecificationList(
                                                      returnData.itemId);
                                              setState(() {});
                                            }
                                          }
                                        });
                                  },
                                  childCount: specificationProvider
                                      .specificationList.data.length,
                                ),
                              )
                            ]),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    })))));
  }
}
