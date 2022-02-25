import 'dart:async';
import 'dart:io';
import 'package:businesslistingapi/repository/gallery_repository.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:businesslistingapi/viewobject/api_status.dart';
import 'package:businesslistingapi/viewobject/default_photo.dart';
import 'package:flutter/material.dart';
import 'package:businesslistingapi/api/common/ps_resource.dart';
import 'package:businesslistingapi/api/common/ps_status.dart';
import 'package:businesslistingapi/provider/common/ps_provider.dart';

class GalleryProvider extends PsProvider {
  GalleryProvider({@required GalleryRepository repo, int limit = 0})
      : super(repo, limit) {
    _repo = repo;

    print('Gallery Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    galleryListStream =
        StreamController<PsResource<List<DefaultPhoto>>>.broadcast();
    subscription = galleryListStream.stream
        .listen((PsResource<List<DefaultPhoto>> resource) {
      updateOffset(resource.data.length);

      _galleryList = resource;
      if (_galleryList != null) {
        selectedImageList = _galleryList.data;
      }

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  GalleryRepository _repo;

  List<DefaultPhoto> selectedImageList = <DefaultPhoto>[];

  PsResource<List<DefaultPhoto>> _galleryList =
      PsResource<List<DefaultPhoto>>(PsStatus.NOACTION, '', <DefaultPhoto>[]);

  PsResource<DefaultPhoto> _defaultPhoto =
      PsResource<DefaultPhoto>(PsStatus.NOACTION, '', null);

  String itemId;

  PsResource<ApiStatus> _deleteImage =
      PsResource<ApiStatus>(PsStatus.NOACTION, '', null);

  PsResource<List<DefaultPhoto>> get galleryList => _galleryList;
  StreamSubscription<PsResource<List<DefaultPhoto>>> subscription;
  StreamController<PsResource<List<DefaultPhoto>>> galleryListStream;
  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('Gallery Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadImageList(
    String parentImgId,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo.getAllImageList(galleryListStream, parentImgId,
        isConnectedToInternet, PsStatus.PROGRESS_LOADING);
  }

  // Future<dynamic> refreshImageList(String parentImgId) async {
  //   isLoading = true;

  //   isConnectedToInternet = await Utils.checkInternetConnectivity();
  //   await _repo.getAllImageList(galleryListStream, isConnectedToInternet,
  //       parentImgId, limit, 0, PsStatus.PROGRESS_LOADING,
  //       isNeedDelete: false);
  // }

  Future<void> refreshImageList(String parentImgId) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo.getAllImageList(galleryListStream, parentImgId,
        isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    isLoading = false;
  }

  Future<dynamic> postItemImageUpload(
    String itemId,
    String imgId,
    File imageFile,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _defaultPhoto = await _repo.postItemImageUpload(itemId, imgId, imageFile,
        isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _defaultPhoto;
  }

  Future<dynamic> postDeleteImage(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _deleteImage = await _repo.postDeleteImage(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _deleteImage;
  }
}
