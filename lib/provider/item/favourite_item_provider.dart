import 'dart:async';

import 'package:businesslistingapi/api/common/ps_resource.dart';
import 'package:businesslistingapi/api/common/ps_status.dart';
import 'package:businesslistingapi/provider/common/ps_provider.dart';
import 'package:businesslistingapi/repository/item_repository.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:businesslistingapi/viewobject/common/ps_value_holder.dart';
import 'package:businesslistingapi/viewobject/item.dart';
import 'package:flutter/cupertino.dart';

class FavouriteItemProvider extends PsProvider {
  FavouriteItemProvider(
      {@required ItemRepository repo,
      @required this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    _repo = repo;

    print('Favourite Item Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    favouriteListStream = StreamController<PsResource<List<Item>>>.broadcast();
    subscription =
        favouriteListStream.stream.listen((PsResource<List<Item>> resource) {
      updateOffset(resource.data.length);

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

  StreamController<PsResource<List<Item>>> favouriteListStream;

  ItemRepository _repo;
  PsValueHolder psValueHolder;

  PsResource<Item> _favourite = PsResource<Item>(PsStatus.NOACTION, '', null);
  PsResource<Item> get user => _favourite;

  PsResource<List<Item>> _itemList =
      PsResource<List<Item>>(PsStatus.NOACTION, '', <Item>[]);

  PsResource<List<Item>> get favouriteItemList => _itemList;
  StreamSubscription<PsResource<List<Item>>> subscription;

  @override
  void dispose() {
    //_repo.cate.close();
    subscription.cancel();
    favouriteListStream.close();
    isDispose = true;
    print('Favourite Item Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadFavouriteItemList() async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo.getAllFavouritesList(
        favouriteListStream,
        psValueHolder.loginUserId,
        isConnectedToInternet,
        limit,
        offset,
        PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> nextFavouriteItemList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;
      await _repo.getNextPageFavouritesList(
          favouriteListStream,
          psValueHolder.loginUserId,
          isConnectedToInternet,
          limit,
          offset,
          PsStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetFavouriteItemList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo.getAllFavouritesList(
        favouriteListStream,
        psValueHolder.loginUserId,
        isConnectedToInternet,
        limit,
        offset,
        PsStatus.PROGRESS_LOADING);

    isLoading = false;
  }

  Future<dynamic> postFavourite(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _favourite = await _repo.postFavourite(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _favourite;
  }
}
