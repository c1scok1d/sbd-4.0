import 'dart:async';
import 'dart:io';
import 'package:businesslistingapi/constant/ps_constants.dart';
import 'package:businesslistingapi/db/gallery_dao.dart';
import 'package:businesslistingapi/viewobject/api_status.dart';
import 'package:businesslistingapi/viewobject/default_photo.dart';
import 'package:flutter/material.dart';
import 'package:businesslistingapi/api/common/ps_resource.dart';
import 'package:businesslistingapi/api/common/ps_status.dart';
import 'package:businesslistingapi/api/ps_api_service.dart';
import 'package:sembast/sembast.dart';

import 'Common/ps_repository.dart';

class GalleryRepository extends PsRepository {
  GalleryRepository(
      {@required PsApiService psApiService, @required GalleryDao galleryDao}) {
    _psApiService = psApiService;
    _galleryDao = galleryDao;
  }

  String primaryKey = 'id';
  String imgParentId = 'img_parent_id';
  PsApiService _psApiService;
  GalleryDao _galleryDao;

  Future<dynamic> insert(DefaultPhoto image) async {
    return _galleryDao.insert(primaryKey, image);
  }

  Future<dynamic> update(DefaultPhoto image) async {
    return _galleryDao.update(image);
  }

  Future<dynamic> delete(DefaultPhoto image) async {
    return _galleryDao.delete(image);
  }

  Future<dynamic> getAllImageList(
      StreamController<PsResource<List<DefaultPhoto>>> galleryListStream,
      String parentImgId,
      bool isConnectedToInternet,
      PsStatus status,
      {bool isNeedDelete = true,
      bool isLoadFromServer = true}) async {
    galleryListStream.sink.add(await _galleryDao.getAll(
        finder: Finder(filter: Filter.equals(imgParentId, parentImgId)),
        status: status));

    if (isConnectedToInternet) {
      final PsResource<List<DefaultPhoto>> _resource =
          await _psApiService.getImageList(parentImgId);

      if (_resource.status == PsStatus.SUCCESS) {
        if (isNeedDelete) {
          await _galleryDao.deleteWithFinder(
              Finder(filter: Filter.equals(imgParentId, parentImgId)));
        }
        await _galleryDao.insertAll(primaryKey, _resource.data);
      } else {
        if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
          // Delete and Insert Map Dao
          await _galleryDao.deleteWithFinder(
              Finder(filter: Filter.equals(imgParentId, parentImgId)));
        }
      }
      galleryListStream.sink.add(await _galleryDao.getAll(
          finder: Finder(filter: Filter.equals(imgParentId, parentImgId))));
    }
  }

  Future<PsResource<DefaultPhoto>> postItemImageUpload(String itemId,
      String imgId, File imageFile, bool isConnectedToInternet, PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<DefaultPhoto> _resource =
        await _psApiService.postItemImageUpload(itemId, imgId, imageFile);
    if (_resource.status == PsStatus.SUCCESS) {
      await _galleryDao
          .deleteWithFinder(Finder(filter: Filter.equals(imgParentId, imgId)));
      await insert(_resource.data);
      return _resource;
    } else {
      final Completer<PsResource<DefaultPhoto>> completer =
          Completer<PsResource<DefaultPhoto>>();
      completer.complete(_resource);
      return completer.future;
    }
  }

  Future<PsResource<ApiStatus>> postDeleteImage(Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet, PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<ApiStatus> _resource =
        await _psApiService.postDeleteImage(jsonMap);
    if (_resource.status == PsStatus.SUCCESS) {
      return _resource;
    } else {
      final Completer<PsResource<ApiStatus>> completer =
          Completer<PsResource<ApiStatus>>();
      completer.complete(_resource);
      return completer.future;
    }
  }
}
