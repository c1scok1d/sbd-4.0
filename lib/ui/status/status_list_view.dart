import 'package:businesslistingapi/api/common/ps_status.dart';
import 'package:businesslistingapi/config/ps_colors.dart';
import 'package:businesslistingapi/config/ps_config.dart';
import 'package:businesslistingapi/provider/status/status_provider.dart';
import 'package:businesslistingapi/repository/status_repository.dart';
import 'package:businesslistingapi/ui/common/base/ps_widget_with_appbar.dart';
import 'package:businesslistingapi/ui/common/ps_frame_loading_widget.dart';
import 'package:businesslistingapi/ui/common/ps_ui_widget.dart';
import 'package:businesslistingapi/ui/status/status_list_item.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class StatusListView extends StatefulWidget {
  const StatusListView({@required this.statusName});

  final String statusName;
  @override
  State<StatefulWidget> createState() {
    return _StatusListViewState();
  }
}

class _StatusListViewState extends State<StatusListView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  StatusProvider _statusProvider;
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
        _statusProvider.nextStatusList();
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

  StatusRepository statusRepo;
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

    statusRepo = Provider.of<StatusRepository>(context);

    print(
        '............................Build UI Again ............................');

    return WillPopScope(
      onWillPop: _requestPop,
      child: PsWidgetWithAppBar<StatusProvider>(
          appBarTitle:
              Utils.getString(context, 'status_list__app_bar_name') ?? '',
          initProvider: () {
            return StatusProvider(
              repo: statusRepo,
              // psValueHolder: Provider.of<PsValueHolder>(context)
            );
          },
          onProviderReady: (StatusProvider provider) {
            provider.loadStatusList();
            _statusProvider = provider;
          },
          builder:
              (BuildContext context, StatusProvider provider, Widget child) {
            return Stack(children: <Widget>[
              Container(
                  child: RefreshIndicator(
                child: ListView.builder(
                    controller: _scrollController,
                    itemCount: provider.statusList.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (provider.statusList.status ==
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
                        final int count = provider.statusList.data.length;
                        animationController.forward();
                        return FadeTransition(
                            opacity: animation,
                            child: StatusListItem(
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
                              status: provider.statusList.data[index],
                              onTap: () {
                                Navigator.pop(
                                    context, provider.statusList.data[index]);
                              },
                            ));
                      }
                    }),
                onRefresh: () {
                  return provider.resetStatusList();
                },
              )),
              PSProgressIndicator(provider.statusList.status)
            ]);
          }),
    );
  }
}
