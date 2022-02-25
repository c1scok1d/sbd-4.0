import 'dart:async';
import 'package:flutter/material.dart';
import 'package:businesslistingapi/api/common/ps_resource.dart';
import 'package:businesslistingapi/api/common/ps_status.dart';
import 'package:businesslistingapi/api/ps_api_service.dart';
import 'package:businesslistingapi/db/city_info_dao.dart';
import 'package:businesslistingapi/viewobject/city_info.dart';
import 'Common/ps_repository.dart';

class CityInfoRepository extends PsRepository {
  CityInfoRepository(
      {@required PsApiService psApiService,
      @required CityInfoDao cityInfoDao}) {
    _psApiService = psApiService;
    _cityInfoDao = cityInfoDao;
  }

  String primaryKey = 'id';
  PsApiService _psApiService;
  CityInfoDao _cityInfoDao;

  Future<dynamic> insert(CityInfo cityInfo) async {
    return _cityInfoDao.insert(primaryKey, cityInfo);
  }

  Future<dynamic> update(CityInfo cityInfo) async {
    return _cityInfoDao.update(cityInfo);
  }

  Future<dynamic> delete(CityInfo cityInfo) async {
    return _cityInfoDao.delete(cityInfo);
  }

  Future<dynamic> getCityInfo(
      StreamController<PsResource<CityInfo>> cityInfoListStream,
      bool isConnectedToInternet,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    cityInfoListStream.sink.add(await _cityInfoDao.getOne(status: status));

    if (isConnectedToInternet) {
      final PsResource<CityInfo> _resource = await _psApiService.getCityInfo();

      if (_resource.status == PsStatus.SUCCESS) {
        await _cityInfoDao.deleteAll();
        await _cityInfoDao.insert(primaryKey, _resource.data);
        cityInfoListStream.sink.add(await _cityInfoDao.getOne());
      }
    }
  }
}
