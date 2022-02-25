import 'dart:async';

import 'package:businesslistingapi/config/ps_config.dart';
import 'package:businesslistingapi/repository/item_repository.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:businesslistingapi/api/common/ps_resource.dart';
import 'package:businesslistingapi/api/common/ps_status.dart';
import 'package:businesslistingapi/provider/common/ps_provider.dart';
import 'package:businesslistingapi/viewobject/common/ps_value_holder.dart';
import 'package:businesslistingapi/viewobject/holder/item_parameter_holder.dart';
import 'package:businesslistingapi/viewobject/item.dart';

class SearchItemProvider extends PsProvider {
  SearchItemProvider(
      {@required ItemRepository repo, this.psValueHolder, int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    print('SearchItemProvider : $hashCode');
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
  PsValueHolder psValueHolder;
  PsResource<List<Item>> _itemList =
      PsResource<List<Item>>(PsStatus.NOACTION, '', <Item>[]);

  PsResource<List<Item>> get itemList => _itemList;
  StreamSubscription<PsResource<List<Item>>> subscription;
  StreamController<PsResource<List<Item>>> itemListStream;

  ItemParameterHolder itemParameterHolder;

  bool isSwitchedFeaturedItem = false;
  bool isSwitchedDiscountPrice = false;

  String selectedCategoryName = '';
  String selectedSubCategoryName = '';

  String categoryId = '';
  String subCategoryId = '';

  bool isfirstRatingClicked = false;
  bool isSecondRatingClicked = false;
  bool isThirdRatingClicked = false;
  bool isfouthRatingClicked = false;
  bool isFifthRatingClicked = false;

  String _itemLocationId;

  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('Search Item Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadItemListByKey(
      ItemParameterHolder itemParameterHolder) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    if (PsConfig.noFilterWithLocationOnMap) {
      if (itemParameterHolder.lat != '' &&
          itemParameterHolder.lng != '' &&
          itemParameterHolder.lat != null &&
          itemParameterHolder.lng != null) {
        _itemLocationId = itemParameterHolder.itemLocationId;
        itemParameterHolder.itemLocationId = '';
      } else {
        if (_itemLocationId != null && _itemLocationId != '') {
          itemParameterHolder.itemLocationId = _itemLocationId;
        }
      }
    }

    await _repo.getItemList(itemListStream, isConnectedToInternet, limit,
        offset, PsStatus.PROGRESS_LOADING, itemParameterHolder);
  }

  Future<dynamic> nextItemListByKey(
      ItemParameterHolder itemParameterHolder) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;
      print('*** Next Page Loading $limit $offset');
      await _repo.getNextPageItemList(itemListStream, isConnectedToInternet,
          limit, offset, PsStatus.PROGRESS_LOADING, itemParameterHolder);
    }
  }

  Future<void> resetLatestItemList(
      ItemParameterHolder itemParameterHolder) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    updateOffset(0);

    isLoading = true;
    await _repo.getItemList(itemListStream, isConnectedToInternet, limit,
        offset, PsStatus.PROGRESS_LOADING, itemParameterHolder);
  }
}
