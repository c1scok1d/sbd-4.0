import 'package:businesslistingapi/api/common/ps_status.dart';
import 'package:businesslistingapi/config/ps_colors.dart';
import 'package:businesslistingapi/config/ps_config.dart';
import 'package:businesslistingapi/provider/status/status_provider.dart';
import 'package:businesslistingapi/repository/city_repository.dart';
import 'package:businesslistingapi/repository/status_repository.dart';
import 'package:businesslistingapi/ui/city/item/city_list_item.dart';
import 'package:businesslistingapi/ui/common/base/ps_widget_with_appbar.dart';
import 'package:businesslistingapi/ui/common/ps_frame_loading_widget.dart';
import 'package:businesslistingapi/ui/common/ps_ui_widget.dart';
import 'package:businesslistingapi/ui/status/status_list_item.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:businesslistingapi/viewobject/holder/city_parameter_holder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'city_provider.dart';

class CityListView extends StatefulWidget {
  const CityListView({@required this.statusName});

  final String statusName;
  @override
  State<StatefulWidget> createState() {
    return _CityListViewState();
  }
}

class _CityListViewState extends State<CityListView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  CityProvider _cityProvider;
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
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _cityProvider.nextCityListByKey(CityParameterHolder().getAllCities());
      }
    });

    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    animation = Tween<double>(
      begin: 0.0,
      end: 10.0,
    ).animate(animationController);
    super.initState();
  }

  CityRepository cityRepo;
  String selectedName = 'selectedName';

  @override
  Widget build(BuildContext context) {
    if (widget.statusName != null && selectedName != '') {
      selectedName = widget.statusName;
    }
    Future<bool> _requestPop() {
      animationController.reverse().then<dynamic>(
            (void data) {
          if (!mounted) {
            return Future<bool>.value(false);
          }
          if (selectedName == '') {
            Navigator.pop(context, true);
          } else {
            Navigator.pop(context, false);
          }
          return Future<bool>.value(true);
        },
      );
      return Future<bool>.value(false);
    }

    cityRepo = Provider.of<CityRepository>(context);

    print(
        '............................Build UI Again ............................');

    return WillPopScope(
      onWillPop: _requestPop,
      child: PsWidgetWithAppBar<CityProvider>(
          appBarTitle:
          Utils.getString(context, 'edit_profile__city_name') ?? '',
          initProvider: () {
            return CityProvider(
              repo: cityRepo,
              // psValueHolder: Provider.of<PsValueHolder>(context)
            );
          },
          onProviderReady: (CityProvider provider) {
            provider.loadCityListByKey(CityParameterHolder().getAllCities());
            _cityProvider = provider;
          },
          builder:
              (BuildContext context, CityProvider provider, Widget child) {
            return Stack(children: <Widget>[
              Container(
                  child: RefreshIndicator(
                    child: ListView.builder(
                        controller: _scrollController,
                        itemCount: provider.cityList.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (provider.cityList.status ==
                              PsStatus.BLOCK_LOADING) {
                            return Shimmer.fromColors(
                                baseColor: PsColors.grey,
                                highlightColor: PsColors.white,
                                child: Column(children: const <Widget>[
                                  PsFrameUIForLoading(),
                                  PsFrameUIForLoading(),
                                  PsFrameUIForLoading(),
                                  PsFrameUIForLoading(),
                                  PsFrameUIForLoading(),
                                  PsFrameUIForLoading(),
                                  PsFrameUIForLoading(),
                                  PsFrameUIForLoading(),
                                  PsFrameUIForLoading(),
                                  PsFrameUIForLoading(),
                                ]));
                          } else {
                            final int count = provider.cityList.data.length;
                            animationController.forward();
                            return FadeTransition(
                                opacity: animation,
                                child: CityListItem(
                                  selectedName: selectedName,
                                  animationController: animationController,
                                  animation:
                                  Tween<double>(begin: 0.0, end: 1.0).animate(
                                    CurvedAnimation(
                                      parent: animationController,
                                      curve: Interval((1 / count) * index, 1.0,
                                          curve: Curves.fastOutSlowIn),
                                    ),
                                  ),
                                  city: provider.cityList.data[index],
                                  onTap: () {
                                    Navigator.pop(
                                        context, provider.cityList.data[index]);
                                  },
                                ));
                          }
                        }),
                    onRefresh: () {
                      return provider.resetCityListByKey(CityParameterHolder().getAllCities());
                    },
                  )),
              PSProgressIndicator(provider.cityList.status)
            ]);
          }),
    );
  }
}
