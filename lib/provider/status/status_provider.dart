import 'dart:async';
import 'package:flutter/material.dart';
import 'package:businesslistingapi/api/common/ps_resource.dart';
import 'package:businesslistingapi/api/common/ps_status.dart';
import 'package:businesslistingapi/provider/common/ps_provider.dart';
import 'package:businesslistingapi/repository/status_repository.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:businesslistingapi/viewobject/status.dart';

class StatusProvider extends PsProvider {
  StatusProvider({@required StatusRepository repo, int limit = 0})
      : super(repo, limit) {
    _repo = repo;

    print('Status Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });
    statusListStream = StreamController<PsResource<List<Status>>>.broadcast();
    subscription =
        statusListStream.stream.listen((PsResource<List<Status>> resource) {
      updateOffset(resource.data.length);

      _statusList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  StatusRepository _repo;

  PsResource<List<Status>> _statusList =
      PsResource<List<Status>>(PsStatus.NOACTION, '', <Status>[]);

  PsResource<List<Status>> get statusList => _statusList;
  StreamSubscription<PsResource<List<Status>>> subscription;
  StreamController<PsResource<List<Status>>> statusListStream;
  @override
  void dispose() {
    subscription.cancel();
    statusListStream.close();
    isDispose = true;
    print('Status Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadStatusList() async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo.getAllStatusList(
        statusListStream, isConnectedToInternet, PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> nextStatusList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;
      await _repo.getNextPageStatusList(
          statusListStream, isConnectedToInternet, PsStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetStatusList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo.getAllStatusList(
        statusListStream, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    isLoading = false;
  }
}
