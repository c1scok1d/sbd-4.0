import 'dart:async';
import 'package:flutter/material.dart';
import 'package:businesslistingapi/api/common/ps_resource.dart';
import 'package:businesslistingapi/api/common/ps_status.dart';
import 'package:businesslistingapi/api/ps_api_service.dart';
import 'package:businesslistingapi/constant/ps_constants.dart';
import 'package:businesslistingapi/db/city_blog_dao.dart';
import 'package:businesslistingapi/viewobject/blog.dart';
import 'Common/ps_repository.dart';

class CityBlogRepository extends PsRepository {
  CityBlogRepository(
      {@required PsApiService psApiService,
      @required CityBlogDao cityBlogDao}) {
    _psApiService = psApiService;
    _cityBlogDao = cityBlogDao;
  }

  String primaryKey = 'id';
  PsApiService _psApiService;
  CityBlogDao _cityBlogDao;

  Future<dynamic> insert(Blog cityBlog) async {
    return _cityBlogDao.insert(primaryKey, cityBlog);
  }

  Future<dynamic> update(Blog cityBlog) async {
    return _cityBlogDao.update(cityBlog);
  }

  Future<dynamic> delete(Blog cityBlog) async {
    return _cityBlogDao.delete(cityBlog);
  }

  Future<dynamic> getCityBlogList(
      StreamController<PsResource<List<Blog>>> cityBlogListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      String cityId,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    cityBlogListStream.sink.add(await _cityBlogDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<Blog>> _resource =
          await _psApiService.getBlogListByCityId(cityId, limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        await _cityBlogDao.deleteAll();
        await _cityBlogDao.insertAll(primaryKey, _resource.data);
      }else{
        if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
          await _cityBlogDao.deleteAll();
        }
      }
      cityBlogListStream.sink.add(await _cityBlogDao.getAll());
    }
  }

  Future<dynamic> getNextPageCityBlogList(
      StreamController<PsResource<List<Blog>>> cityBlogListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      String cityId,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    cityBlogListStream.sink.add(await _cityBlogDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<Blog>> _resource =
          await _psApiService.getBlogListByCityId(cityId, limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        await _cityBlogDao.insertAll(primaryKey, _resource.data);
      }
      cityBlogListStream.sink.add(await _cityBlogDao.getAll());
    }
  }
}
