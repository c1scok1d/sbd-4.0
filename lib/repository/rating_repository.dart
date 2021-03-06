import 'dart:async';
import 'package:businesslistingapi/constant/ps_constants.dart';
import 'package:businesslistingapi/db/rating_dao.dart';
import 'package:businesslistingapi/viewobject/rating.dart';
import 'package:flutter/material.dart';
import 'package:businesslistingapi/api/common/ps_resource.dart';
import 'package:businesslistingapi/api/common/ps_status.dart';
import 'package:businesslistingapi/api/ps_api_service.dart';
import 'package:sembast/sembast.dart';

import 'Common/ps_repository.dart';

class RatingRepository extends PsRepository {
  RatingRepository(
      {@required PsApiService psApiService, @required RatingDao ratingDao}) {
    _psApiService = psApiService;
    _ratingDao = ratingDao;
  }

  String primaryKey = 'id';
  PsApiService _psApiService;
  RatingDao _ratingDao;

  Future<dynamic> insert(Rating rating) async {
    return _ratingDao.insert(primaryKey, rating);
  }

  Future<dynamic> update(Rating rating) async {
    return _ratingDao.update(rating);
  }

  Future<dynamic> delete(Rating rating) async {
    return _ratingDao.delete(rating);
  }

  Future<dynamic> getAllRatingList(
      StreamController<PsResource<List<Rating>>> ratingListStream,
      String itemId,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      {bool isNeedDelete = true,
      bool isLoadFromServer = true}) async {
    final Finder finder = Finder(filter: Filter.equals('item_id', itemId));
    ratingListStream.sink
        .add(await _ratingDao.getAll(finder: finder, status: status));

    if (isConnectedToInternet) {
      final PsResource<List<Rating>> _resource =
          await _psApiService.getRatingList(itemId, limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        if (isNeedDelete) {
          await _ratingDao.deleteWithFinder(finder);
        }
        await _ratingDao.insertAll(primaryKey, _resource.data);
      }else{
        if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
          await _ratingDao.deleteWithFinder(finder);
        }
      }
      ratingListStream.sink.add(await _ratingDao.getAll(finder: finder));
    }
  }

  Future<dynamic> getNextPageRatingList(
      StreamController<PsResource<List<Rating>>> ratingListStream,
      String itemId,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    final Finder finder = Finder(filter: Filter.equals('item_id', itemId));
    ratingListStream.sink
        .add(await _ratingDao.getAll(finder: finder, status: status));

    if (isConnectedToInternet) {
      final PsResource<List<Rating>> _resource =
          await _psApiService.getRatingList(itemId, limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        await _ratingDao.insertAll(primaryKey, _resource.data);
      }
      ratingListStream.sink.add(await _ratingDao.getAll(finder: finder));
    }
  }

  Future<PsResource<Rating>> postRating(
      StreamController<PsResource<Rating>> ratingStream,
      Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet,
      {bool isLoadFromServer = true}) async {
    final PsResource<Rating> _resource =
        await _psApiService.postRating(jsonMap);
    if (_resource.status == PsStatus.SUCCESS) {
      // ratingStream.sink.add(await _ratingDao.getOne());
      return _resource;
    } else {
      final Completer<PsResource<Rating>> completer =
          Completer<PsResource<Rating>>();
      completer.complete(_resource);
      ratingStream.sink.add(await _ratingDao.getOne());
      return completer.future;
    }
  }
}
