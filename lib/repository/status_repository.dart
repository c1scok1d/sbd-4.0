import 'dart:async';
import 'package:flutter/material.dart';
import 'package:businesslistingapi/api/common/ps_resource.dart';
import 'package:businesslistingapi/api/common/ps_status.dart';
import 'package:businesslistingapi/api/ps_api_service.dart';
import 'package:businesslistingapi/constant/ps_constants.dart';
import 'package:businesslistingapi/db/status_dao.dart';
import 'package:businesslistingapi/viewobject/status.dart';
import 'Common/ps_repository.dart';

class StatusRepository extends PsRepository {
  StatusRepository(
      {@required PsApiService psApiService, @required StatusDao statusDao}) {
    _psApiService = psApiService;
    _statusDao = statusDao;
  }

  String primaryKey = 'id';
  PsApiService _psApiService;
  StatusDao _statusDao;

  Future<dynamic> insert(Status status) async {
    return _statusDao.insert(primaryKey, status);
  }

  Future<dynamic> update(Status status) async {
    return _statusDao.update(status);
  }

  Future<dynamic> delete(Status status) async {
    return _statusDao.delete(status);
  }

  Future<dynamic> getAllStatusList(
      StreamController<PsResource<List<Status>>> statusListStream,
      bool isConnectedToInternet,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    statusListStream.sink.add(await _statusDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<Status>> _resource =
          await _psApiService.getStatusList();

      if (_resource.status == PsStatus.SUCCESS) {
        await _statusDao.deleteAll();
        await _statusDao.insertAll(primaryKey, _resource.data);
      }else{
        if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
          await _statusDao.deleteAll();
        }
      }
      statusListStream.sink.add(await _statusDao.getAll());
    }
  }

  Future<dynamic> getNextPageStatusList(
      StreamController<PsResource<List<Status>>> statusListStream,
      bool isConnectedToInternet,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    statusListStream.sink.add(await _statusDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<Status>> _resource =
          await _psApiService.getStatusList();

      if (_resource.status == PsStatus.SUCCESS) {
        await _statusDao.insertAll(primaryKey, _resource.data);
      }
      statusListStream.sink.add(await _statusDao.getAll());
    }
  }
}
