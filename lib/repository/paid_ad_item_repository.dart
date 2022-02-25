import 'dart:async';
import 'package:flutter/material.dart';
import 'package:businesslistingapi/api/common/ps_resource.dart';
import 'package:businesslistingapi/api/common/ps_status.dart';
import 'package:businesslistingapi/api/ps_api_service.dart';
import 'package:businesslistingapi/constant/ps_constants.dart';
import 'package:businesslistingapi/db/paid_ad_item_dao.dart';
import 'package:businesslistingapi/viewobject/item_paid_history.dart';
import 'package:sembast/sembast.dart';

import 'Common/ps_repository.dart';

class PaidAdItemRepository extends PsRepository {
  PaidAdItemRepository(
      {@required PsApiService psApiService,
      @required PaidAdItemDao paidAdItemDao}) {
    _psApiService = psApiService;
    _paidAdItemDao = paidAdItemDao;
  }

  String primaryKey = 'id';
  PsApiService _psApiService;
  PaidAdItemDao _paidAdItemDao;

  Future<dynamic> insert(ItemPaidHistory paidAdItem) async {
    return _paidAdItemDao.insert(primaryKey, paidAdItem);
  }

  Future<dynamic> update(ItemPaidHistory paidAdItem) async {
    return _paidAdItemDao.update(paidAdItem);
  }

  Future<dynamic> delete(ItemPaidHistory paidAdItem) async {
    return _paidAdItemDao.delete(paidAdItem);
  }

  Future<dynamic> getPaidAdItemList(
      StreamController<PsResource<List<ItemPaidHistory>>> paidAdItemListStream,
      String loginUserId,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      {bool isNeedDelete = true,
      bool isLoadFromServer = true}) async {
    final Finder finder =
        Finder(filter: Filter.equals('added_user_id', loginUserId));
    paidAdItemListStream.sink
        .add(await _paidAdItemDao.getAll(status: status, finder: finder));

    if (isConnectedToInternet) {
      final PsResource<List<ItemPaidHistory>> _resource =
          await _psApiService.getPaidAdItemList(loginUserId, limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        if (isNeedDelete) {
          await _paidAdItemDao.deleteWithFinder(finder);
        }

        await _paidAdItemDao.insertAll(primaryKey, _resource.data);
      }else{
        if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
          await _paidAdItemDao.deleteWithFinder(finder);
        }
      }
      paidAdItemListStream.sink
            .add(await _paidAdItemDao.getAll(finder: finder));
    }
  }

  Future<dynamic> getNextPagePaidAdItemList(
      StreamController<PsResource<List<ItemPaidHistory>>> paidAdItemListStream,
      String loginUserId,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    final Finder finder =
        Finder(filter: Filter.equals('added_user_id', loginUserId));
    paidAdItemListStream.sink
        .add(await _paidAdItemDao.getAll(finder: finder, status: status));

    if (isConnectedToInternet) {
      final PsResource<List<ItemPaidHistory>> _resource =
          await _psApiService.getPaidAdItemList(loginUserId, limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        await _paidAdItemDao.insertAll(primaryKey, _resource.data);
      }
      paidAdItemListStream.sink
          .add(await _paidAdItemDao.getAll(finder: finder));
    }
  }
}
