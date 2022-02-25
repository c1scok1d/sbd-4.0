import 'dart:async';
import 'package:businesslistingapi/repository/item_repository.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:businesslistingapi/viewobject/common/ps_value_holder.dart';
import 'package:businesslistingapi/viewobject/item.dart';
import 'package:flutter/material.dart';
import 'package:businesslistingapi/api/common/ps_resource.dart';
import 'package:businesslistingapi/api/common/ps_status.dart';
import 'package:businesslistingapi/provider/common/ps_provider.dart';

class RelatedItemProvider extends PsProvider {
  RelatedItemProvider(
      {@required ItemRepository repo,
      @required this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    print('RelatedItemProvider : $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });
    relatedItemListStream =
        StreamController<PsResource<List<Item>>>.broadcast();
    subscription =
        relatedItemListStream.stream.listen((PsResource<List<Item>> resource) {
      updateOffset(resource.data.length);

      _relatedItemList = Utils.removeDuplicateObj<Item>(resource);

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  PsValueHolder psValueHolder;
  ItemRepository _repo;

  PsResource<List<Item>> _relatedItemList =
      PsResource<List<Item>>(PsStatus.NOACTION, '', <Item>[]);

  PsResource<List<Item>> get relatedItemList => _relatedItemList;
  StreamSubscription<PsResource<List<Item>>> subscription;
  StreamController<PsResource<List<Item>>> relatedItemListStream;

  @override
  void dispose() {
    subscription.cancel();
    print('Related Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadRelatedItemList(
    String itemId,
    String categoryId,
  ) async {
    isLoading = true;

    limit = 10;
    offset = 0;

    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo.getRelatedItemList(relatedItemListStream, itemId, categoryId,
        isConnectedToInternet, limit, offset, PsStatus.PROGRESS_LOADING);
  }
}
