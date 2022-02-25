import 'dart:async';
import 'package:flutter/material.dart';
import 'package:businesslistingapi/constant/ps_constants.dart';
import 'package:businesslistingapi/db/item_collection_header_dao.dart';
import 'package:businesslistingapi/viewobject/item_collection_header.dart';
import 'package:businesslistingapi/api/common/ps_resource.dart';
import 'package:businesslistingapi/api/common/ps_status.dart';
import 'package:businesslistingapi/api/ps_api_service.dart';
import 'package:businesslistingapi/repository/Common/ps_repository.dart';

class ItemCollectionRepository extends PsRepository {
  ItemCollectionRepository(
      {@required PsApiService psApiService,
      @required ItemCollectionHeaderDao itemCollectionHeaderDao}) {
    _psApiService = psApiService;
    _itemCollectionHeaderDao = itemCollectionHeaderDao;
  }

  PsApiService _psApiService;
  ItemCollectionHeaderDao _itemCollectionHeaderDao;
  final String _primaryKey = 'id';

  void sinkProductListStream(
      StreamController<PsResource<List<ItemCollectionHeader>>>
          itemCollectionListStream,
      PsResource<List<ItemCollectionHeader>> dataList) {
    if (dataList != null) {
      itemCollectionListStream.sink.add(dataList);
    }
  }

  void sinkProductStream(
      StreamController<PsResource<ItemCollectionHeader>> itemCollectionStream,
      PsResource<ItemCollectionHeader> data) {
    if (data != null) {
      itemCollectionStream.sink.add(data);
    }
  }

  Future<dynamic> insert(ItemCollectionHeader itemCollectionHeader) async {
    return _itemCollectionHeaderDao.insert(_primaryKey, itemCollectionHeader);
  }

  Future<dynamic> update(ItemCollectionHeader itemCollectionHeader) async {
    return _itemCollectionHeaderDao.update(itemCollectionHeader);
  }

  Future<dynamic> delete(ItemCollectionHeader itemCollectionHeader) async {
    return _itemCollectionHeaderDao.delete(itemCollectionHeader);
  }

  Future<dynamic> getItemCollectionList(
      StreamController<PsResource<List<ItemCollectionHeader>>>
          itemCollectionListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      String cityId,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    sinkProductListStream(itemCollectionListStream,
        await _itemCollectionHeaderDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<ItemCollectionHeader>> _resource =
          await _psApiService.getItemCollectionList(limit, offset, cityId);

      if (_resource.status == PsStatus.SUCCESS) {
        await _itemCollectionHeaderDao.deleteAll();
        await _itemCollectionHeaderDao.insertAll(_primaryKey, _resource.data);
      } else {
        if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
          await _itemCollectionHeaderDao.deleteAll();
        }
      }
      sinkProductListStream(
          itemCollectionListStream, await _itemCollectionHeaderDao.getAll());
    }
  }

  Future<dynamic> getNextPageItemCollectionList(
      StreamController<PsResource<List<ItemCollectionHeader>>>
          itemCollectionListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      String cityId,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    sinkProductListStream(itemCollectionListStream,
        await _itemCollectionHeaderDao.getAll(status: status));
    if (isConnectedToInternet) {
      final PsResource<List<ItemCollectionHeader>> _resource =
          await _psApiService.getItemCollectionList(limit, offset, cityId);

      if (_resource.status == PsStatus.SUCCESS) {
        _itemCollectionHeaderDao
            .insertAll(_primaryKey, _resource.data)
            .then((dynamic data) async {
          sinkProductListStream(itemCollectionListStream,
              await _itemCollectionHeaderDao.getAll());
        });
      } else {
        sinkProductListStream(
            itemCollectionListStream, await _itemCollectionHeaderDao.getAll());
      }
    }
  }
}
