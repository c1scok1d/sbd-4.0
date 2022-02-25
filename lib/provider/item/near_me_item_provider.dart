import 'dart:async';

import 'package:businesslistingapi/api/common/ps_resource.dart';
import 'package:businesslistingapi/api/common/ps_status.dart';
import 'package:businesslistingapi/provider/common/ps_provider.dart';
import 'package:businesslistingapi/repository/item_repository.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:businesslistingapi/viewobject/holder/item_parameter_holder.dart';
import 'package:businesslistingapi/viewobject/item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofence/geofence.dart';

class NearMeItemProvider extends PsProvider {
  NearMeItemProvider({@required ItemRepository repo, int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    print('FeaturedItemProvider : $hashCode');
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    itemListStream = StreamController<PsResource<List<Item>>>.broadcast();

    subscription =
        itemListStream.stream.listen((PsResource<List<Item>> resource) {
      updateOffset(0);

      _itemList = Utils.removeDuplicateObj<Item>(resource);

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  ItemRepository _repo;
  PsResource<List<Item>> _itemList =
      PsResource<List<Item>>(PsStatus.NOACTION, '', <Item>[]);

  PsResource<List<Item>> get itemList => _itemList;
  StreamSubscription<PsResource<List<Item>>> subscription;
  StreamController<PsResource<List<Item>>> itemListStream;

  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('Feature Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadItemList(Coordinate c) async {
    print('loadItemList near me');
    isLoading = true;
    if (c == null) {
      print('loadItemList c was null');
      return;
      // if ((await PsSharedPreferences.instance.futureShared)
      //     .getBool(PsConst.GEO_SERVICE_KEY)) {
      //   Geofence.initialize();
      //   // c=await Geofence.getCurrentLocation();
      // }

      print('loadItemList c was ${c.longitude}');
    }
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    await _repo.getItemListByLoc(
        itemListStream,
        isConnectedToInternet,
        limit,
        offset,
        PsStatus.PROGRESS_LOADING,
        c.latitude,
        c.longitude,
        20,
        ItemParameterHolder().getSearchParameterHolder());
  }

  Future<dynamic> nextItemList(Coordinate c) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;

      await _repo.getItemListByLoc(
          itemListStream,
          isConnectedToInternet,
          limit,
          offset,
          PsStatus.PROGRESS_LOADING,
          c.latitude,
          c.longitude,
          20,
          ItemParameterHolder().getSearchParameterHolder());
    }
  }

  Future<void> resetNearMeItemList(Coordinate c) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    updateOffset(0);

    isLoading = true;
    await _repo.getItemListByLoc(
        itemListStream,
        isConnectedToInternet,
        limit,
        offset,
        PsStatus.PROGRESS_LOADING,
        c.latitude,
        c.longitude,
        20,
        ItemParameterHolder().getSearchParameterHolder());
  }
}
