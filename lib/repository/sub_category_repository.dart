import 'dart:async';
import 'package:flutter/material.dart';
import 'package:businesslistingapi/constant/ps_constants.dart';
import 'package:sembast/sembast.dart';
import 'package:businesslistingapi/api/common/ps_resource.dart';
import 'package:businesslistingapi/api/common/ps_status.dart';
import 'package:businesslistingapi/api/ps_api_service.dart';
import 'package:businesslistingapi/db/sub_category_dao.dart';
import 'package:businesslistingapi/repository/Common/ps_repository.dart';
import 'package:businesslistingapi/viewobject/sub_category.dart';

class SubCategoryRepository extends PsRepository {
  SubCategoryRepository(
      {@required PsApiService psApiService,
      @required SubCategoryDao subCategoryDao}) {
    _psApiService = psApiService;
    _subCategoryDao = subCategoryDao;
  }

  PsApiService _psApiService;
  SubCategoryDao _subCategoryDao;
  final String _primaryKey = 'id';

  Future<dynamic> insert(SubCategory subCategory) async {
    return _subCategoryDao.insert(_primaryKey, subCategory);
  }

  Future<dynamic> update(SubCategory subCategory) async {
    return _subCategoryDao.update(subCategory);
  }

  Future<dynamic> delete(SubCategory subCategory) async {
    return _subCategoryDao.delete(subCategory);
  }

  Future<dynamic> getSubCategoryListByCategoryId(
      StreamController<PsResource<List<SubCategory>>> subCategoryListStream,
      bool isConnectedToIntenet,
      Map<dynamic, dynamic> jsonMap,
      String loginUserId,
      int limit,
      int offset,
      PsStatus status,
      String categoryId,
      {bool isLoadFromServer = true}) async {
    final Finder finder = Finder(filter: Filter.equals('cat_id', categoryId));

    subCategoryListStream.sink
        .add(await _subCategoryDao.getAll(finder: finder, status: status));

    if (isConnectedToIntenet) {

    final PsResource<List<SubCategory>> _resource = await _psApiService
        .getSubCategoryList(jsonMap, loginUserId, limit, offset, categoryId);

    if (_resource.status == PsStatus.SUCCESS) {
      await _subCategoryDao.deleteWithFinder(finder);
      await _subCategoryDao.insertAll(_primaryKey, _resource.data);
    } else {
      if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
        await _subCategoryDao.deleteWithFinder(finder);
      }
    }
    subCategoryListStream.sink.add(await _subCategoryDao.getAll(finder: finder));
    }
  }

  Future<dynamic> getAllSubCategoryListByCategoryId(
      StreamController<PsResource<List<SubCategory>>> subCategoryListStream,
      bool isConnectedToIntenet,
      PsStatus status,
      Map<dynamic, dynamic> jsonMap,
      String categoryId,
      {bool isLoadFromServer = true}) async {
    final Finder finder = Finder(filter: Filter.equals('cat_id', categoryId));

    subCategoryListStream.sink
        .add(await _subCategoryDao.getAll(finder: finder, status: status));

    final PsResource<List<SubCategory>> _resource =
        await _psApiService.getAllSubCategoryList(jsonMap, categoryId);

    if (_resource.status == PsStatus.SUCCESS) {
      await _subCategoryDao.deleteWithFinder(finder);
      await _subCategoryDao.insertAll(_primaryKey, _resource.data);
    } else {
      if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
        await _subCategoryDao.deleteWithFinder(finder);
      }
    }
    subCategoryListStream.sink
        .add(await _subCategoryDao.getAll(finder: finder));
  }

  Future<dynamic> getNextPageSubCategoryList(
      StreamController<PsResource<List<SubCategory>>> subCategoryListStream,
      bool isConnectedToIntenet,
      Map<dynamic, dynamic> jsonMap,
      String loginUserId,
      int limit,
      int offset,
      PsStatus status,
      String categoryId,
      {bool isLoadFromServer = true}) async {
    final Finder finder = Finder(filter: Filter.equals('cat_id', categoryId));
    subCategoryListStream.sink
        .add(await _subCategoryDao.getAll(finder: finder, status: status));

    final PsResource<List<SubCategory>> _resource = await _psApiService
        .getSubCategoryList(jsonMap, loginUserId, limit, offset, categoryId);

    if (_resource.status == PsStatus.SUCCESS) {
      _subCategoryDao
          .insertAll(_primaryKey, _resource.data)
          .then((dynamic data) async {
        subCategoryListStream.sink
            .add(await _subCategoryDao.getAll(finder: finder));
      });
    } else {
      subCategoryListStream.sink
          .add(await _subCategoryDao.getAll(finder: finder));
    }
  }
}