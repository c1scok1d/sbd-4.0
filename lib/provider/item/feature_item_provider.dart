import 'dart:async';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:businesslistingapi/api/common/ps_resource.dart';
import 'package:businesslistingapi/api/common/ps_status.dart';
import 'package:businesslistingapi/provider/common/ps_provider.dart';
import 'package:businesslistingapi/repository/item_repository.dart';
import 'package:businesslistingapi/viewobject/holder/item_parameter_holder.dart';
import 'package:businesslistingapi/viewobject/item.dart';

class FeaturedItemProvider extends PsProvider {
  FeaturedItemProvider({@required ItemRepository repo, int limit = 0})
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

  Future<dynamic> loadItemList(ItemParameterHolder itemParameterHolder) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    await _repo.getItemList(itemListStream, isConnectedToInternet, limit,
        offset, PsStatus.PROGRESS_LOADING, itemParameterHolder);
  }

  Future<dynamic> nextItemList(ItemParameterHolder itemParameterHolder) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;

      await _repo.getItemList(itemListStream, isConnectedToInternet, limit,
          offset, PsStatus.PROGRESS_LOADING, itemParameterHolder);
    }
  }

  Future<void> resetFeatureItemList(
      ItemParameterHolder itemParameterHolder) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    updateOffset(0);

    isLoading = true;
    await _repo.getItemList(itemListStream, isConnectedToInternet, limit,
        offset, PsStatus.PROGRESS_LOADING, itemParameterHolder);
  }
}
