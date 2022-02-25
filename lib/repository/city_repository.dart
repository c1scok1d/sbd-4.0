import 'dart:async';
import 'package:businesslistingapi/constant/ps_constants.dart';
import 'package:businesslistingapi/db/city_dao.dart';
import 'package:businesslistingapi/db/city_map_dao.dart';
import 'package:flutter/material.dart';
import 'package:businesslistingapi/viewobject/holder/city_parameter_holder.dart';
import 'package:businesslistingapi/viewobject/city_map.dart';
import 'package:sembast/sembast.dart';
import 'package:businesslistingapi/api/common/ps_resource.dart';
import 'package:businesslistingapi/api/common/ps_status.dart';
import 'package:businesslistingapi/api/ps_api_service.dart';
import 'package:businesslistingapi/repository/Common/ps_repository.dart';
import 'package:businesslistingapi/viewobject/city.dart';

class CityRepository extends PsRepository {
  CityRepository(
      {@required PsApiService psApiService, @required CityDao cityDao}) {
    _psApiService = psApiService;
    _cityDao = cityDao;
  }
  String primaryKey = 'id';
  String mapKey = 'map_key';
  PsApiService _psApiService;
  CityDao _cityDao;

  void sinkCityListStream(
      StreamController<PsResource<List<City>>> cityListStream,
      PsResource<List<City>> dataList) {
    if (dataList != null && cityListStream != null) {
      cityListStream.sink.add(dataList);
    }
  }

  Future<dynamic> insert(City city) async {
    return _cityDao.insert(primaryKey, city);
  }

  Future<dynamic> update(City city) async {
    return _cityDao.update(city);
  }

  Future<dynamic> delete(City city) async {
    return _cityDao.delete(city);
  }

  Future<dynamic> getCityList(
      StreamController<PsResource<List<City>>> cityListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      CityParameterHolder holder,
      {bool isLoadFromServer = true}) async {
    // Prepare Holder and Map Dao
    final String paramKey = holder.getParamKey();
    final CityMapDao cityMapDao = CityMapDao.instance;

    // Load from Db and Send to UI
    sinkCityListStream(
        cityListStream,
        await _cityDao.getAllByMap(
            primaryKey, mapKey, paramKey, cityMapDao, CityMap(),
            status: status));

    // Server Call
    if (isConnectedToInternet) {
      final PsResource<List<City>> _resource =
          await _psApiService.getCityList(holder.toMap(), limit, offset);

      print('Param Key $paramKey');
      if (_resource.status == PsStatus.SUCCESS) {
        // Create Map List
        final List<CityMap> cityMapList = <CityMap>[];
        int i = 0;
        for (City data in _resource.data) {
          cityMapList.add(CityMap(
              id: data.id + paramKey,
              mapKey: paramKey,
              cityId: data.id,
              sorting: i++,
              addedDate: '2019'));
        }

        // Delete and Insert Map Dao
        print('Delete Key $paramKey');
        await cityMapDao
            .deleteWithFinder(Finder(filter: Filter.equals(mapKey, paramKey)));
        print('Insert All Key $paramKey');
        await cityMapDao.insertAll(primaryKey, cityMapList);

        // Insert City
        await _cityDao.insertAll(primaryKey, _resource.data);
      } else {
        if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
        // Delete and Insert Map Dao
        await cityMapDao
            .deleteWithFinder(Finder(filter: Filter.equals(mapKey, paramKey)));
        }
      }
      // Load updated Data from Db and Send to UI
      sinkCityListStream(
          cityListStream,
          await _cityDao.getAllByMap(
              primaryKey, mapKey, paramKey, cityMapDao, CityMap()));
    }
  }

  Future<dynamic> getNextPageCityList(
      StreamController<PsResource<List<City>>> cityListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      CityParameterHolder holder,
      {bool isLoadFromServer = true}) async {
    final String paramKey = holder.getParamKey();
    final CityMapDao cityMapDao = CityMapDao.instance;
    // Load from Db and Send to UI
    sinkCityListStream(
        cityListStream,
        await _cityDao.getAllByMap(
            primaryKey, mapKey, paramKey, cityMapDao, CityMap(),
            status: status));
    if (isConnectedToInternet) {
      final PsResource<List<City>> _resource =
          await _psApiService.getCityList(holder.toMap(), limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        // Create Map List
        final List<CityMap> cityMapList = <CityMap>[];
        final PsResource<List<CityMap>> existingMapList = await cityMapDao
            .getAll(finder: Finder(filter: Filter.equals(mapKey, paramKey)));

        int i = 0;
        if (existingMapList != null) {
          i = existingMapList.data.length + 1;
        }
        for (City data in _resource.data) {
          cityMapList.add(CityMap(
              id: data.id + paramKey,
              mapKey: paramKey,
              cityId: data.id,
              sorting: i++,
              addedDate: '2019'));
        }

        await cityMapDao.insertAll(primaryKey, cityMapList);

        // Insert City
        await _cityDao.insertAll(primaryKey, _resource.data);
      }
      sinkCityListStream(
          cityListStream,
          await _cityDao.getAllByMap(
              primaryKey, mapKey, paramKey, cityMapDao, CityMap()));
    }
  }
}
