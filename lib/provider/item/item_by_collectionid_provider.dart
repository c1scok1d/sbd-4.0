import 'dart:async';
import 'package:businesslistingapi/api/common/ps_resource.dart';
import 'package:businesslistingapi/api/common/ps_status.dart';
import 'package:businesslistingapi/provider/common/ps_provider.dart';
import 'package:businesslistingapi/repository/item_repository.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:businesslistingapi/viewobject/common/ps_value_holder.dart';
import 'package:flutter/cupertino.dart';
import 'package:businesslistingapi/viewobject/item.dart';

class ItemByCollectionIdProvider extends PsProvider {
  ItemByCollectionIdProvider(
      {@required ItemRepository repo,
      @required this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    _repo = repo;

    print('Item By Collection Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    itemCollectionListStream =
        StreamController<PsResource<List<Item>>>.broadcast();
    subscription = itemCollectionListStream.stream
        .listen((PsResource<List<Item>> resource) {
      updateOffset(resource.data.length);

      _itemCollectionList = Utils.removeDuplicateObj<Item>(resource);

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  StreamController<PsResource<List<Item>>> itemCollectionListStream;

  ItemRepository _repo;
  PsValueHolder psValueHolder;

  PsResource<List<Item>> _itemCollectionList =
      PsResource<List<Item>>(PsStatus.NOACTION, '', <Item>[]);

  PsResource<List<Item>> get itemCollectionList => _itemCollectionList;
  StreamSubscription<PsResource<List<Item>>> subscription;

  @override
  void dispose() {
    subscription.cancel();
    itemCollectionListStream.close();
    isDispose = true;
    print('Item By Collection Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadItemListByCollectionId(String collectionId) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo.getAllitemListByCollectionId(
        itemCollectionListStream,
        isConnectedToInternet,
        collectionId,
        limit,
        offset,
        PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> nextItemListByCollectionId(String collectionId) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;
      await _repo.getNextPageitemListByCollectionId(
          itemCollectionListStream,
          isConnectedToInternet,
          collectionId,
          limit,
          offset,
          PsStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetItemListByCollectionId(String collectionId) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo.getAllitemListByCollectionId(
        itemCollectionListStream,
        isConnectedToInternet,
        collectionId,
        limit,
        offset,
        PsStatus.PROGRESS_LOADING);

    isLoading = false;
  }
}
