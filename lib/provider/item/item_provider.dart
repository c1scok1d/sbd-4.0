import 'dart:async';
import 'package:businesslistingapi/repository/item_repository.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:businesslistingapi/viewobject/common/ps_value_holder.dart';
import 'package:businesslistingapi/viewobject/download_item.dart';
import 'package:businesslistingapi/viewobject/item.dart';
import 'package:flutter/material.dart';
import 'package:businesslistingapi/api/common/ps_resource.dart';
import 'package:businesslistingapi/api/common/ps_status.dart';
import 'package:businesslistingapi/provider/common/ps_provider.dart';

class ItemDetailProvider extends PsProvider {
  ItemDetailProvider(
      {@required ItemRepository repo,
      @required this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    print('ItemDetailProvider : $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    itemDetailStream = StreamController<PsResource<Item>>.broadcast();
    subscription = itemDetailStream.stream.listen((PsResource<Item> resource) {
      _item = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        if (_item != null) {
          notifyListeners();
        }
      }
    });
  }

  ItemRepository _repo;
  PsValueHolder psValueHolder;

  PsResource<Item> _item = PsResource<Item>(PsStatus.NOACTION, '', null);

  PsResource<Item> get itemDetail => _item;
  StreamSubscription<PsResource<Item>> subscription;
  StreamController<PsResource<Item>> itemDetailStream;
  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('Item Detail Provider Dispose: $hashCode');
    super.dispose();
  }

  void updateItem(Item item) {
    _item.data = item;
  }

  Future<dynamic> loadItem(
    String itemId,
    String loginUserId,
  ) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    await _repo.getItemDetail(itemDetailStream, itemId, loginUserId,
        isConnectedToInternet, PsStatus.BLOCK_LOADING);
  }

  Future<dynamic> loadItemForFav(
    String itemId,
    String loginUserId,
  ) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    await _repo.getItemDetailForFav(itemDetailStream, itemId, loginUserId,
        isConnectedToInternet, PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> nextItem(
    String itemId,
    String loginUserId,
  ) async {
    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;
      isConnectedToInternet = await Utils.checkInternetConnectivity();
      await _repo.getItemDetail(itemDetailStream, itemId, loginUserId,
          isConnectedToInternet, PsStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetItemDetail(
    String itemId,
    String loginUserId,
  ) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo.getItemDetail(itemDetailStream, itemId, loginUserId,
        isConnectedToInternet, PsStatus.BLOCK_LOADING);

    isLoading = false;
  }

  PsResource<List<DownloadItem>> _downloadItem =
      PsResource<List<DownloadItem>>(PsStatus.NOACTION, '', null);
  PsResource<List<DownloadItem>> get user => _downloadItem;

  Future<dynamic> postDownloadItemList(Map<dynamic, dynamic> jsonMap) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _downloadItem = await _repo.postDownloadItemList(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _downloadItem;
  }
}
