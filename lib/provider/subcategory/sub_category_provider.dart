import 'dart:async';

import 'package:businesslistingapi/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:businesslistingapi/api/common/ps_resource.dart';
import 'package:businesslistingapi/api/common/ps_status.dart';
import 'package:businesslistingapi/provider/common/ps_provider.dart';
import 'package:businesslistingapi/repository/sub_category_repository.dart';
import 'package:businesslistingapi/viewobject/holder/item_parameter_holder.dart';
import 'package:businesslistingapi/viewobject/holder/sub_category_parameter_holder.dart';
import 'package:businesslistingapi/viewobject/sub_category.dart';

class SubCategoryProvider extends PsProvider {
  SubCategoryProvider({@required SubCategoryRepository repo, int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    print('SubCategory Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    subCategoryListStream =
        StreamController<PsResource<List<SubCategory>>>.broadcast();
    subscription = subCategoryListStream.stream.listen((dynamic resource) {
      updateOffset(resource.data.length);

      _subCategoryList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  StreamController<PsResource<List<SubCategory>>> subCategoryListStream;
  SubCategoryRepository _repo;

  PsResource<List<SubCategory>> _subCategoryList =
      PsResource<List<SubCategory>>(PsStatus.NOACTION, '', <SubCategory>[]);

  PsResource<List<SubCategory>> get subCategoryList => _subCategoryList;
  StreamSubscription<PsResource<List<SubCategory>>> subscription;

  String categoryId = '';
  ItemParameterHolder itemByCategoryIdParamenterHolder =
      ItemParameterHolder().getItemByCategoryIdParameterHolder();
  
  SubCategoryParameterHolder subCategoryParameterHolder =
      SubCategoryParameterHolder().getLatestParameterHolder();


  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('SubCategory Provider Dispose: $hashCode');
    super.dispose();
  }

   Future<dynamic> loadSubCategoryList(Map<dynamic, dynamic> jsonMap,
      String loginUserId, String categoryId) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo.getSubCategoryListByCategoryId(
        subCategoryListStream,
        isConnectedToInternet,
        jsonMap,
        loginUserId,
        limit,
        offset,
        PsStatus.PROGRESS_LOADING,
        categoryId);
  }

  Future<dynamic> loadAllSubCategoryList(Map<dynamic, dynamic> jsonMap,
      String loginUserId, String categoryId) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo.getAllSubCategoryListByCategoryId(subCategoryListStream,
        isConnectedToInternet, PsStatus.PROGRESS_LOADING, jsonMap, categoryId);
  }

  Future<dynamic> nextSubCategoryList(Map<dynamic, dynamic> jsonMap,
      String loginUserId, String categoryId) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;

      await _repo.getNextPageSubCategoryList(
          subCategoryListStream,
          isConnectedToInternet,
          jsonMap,
          loginUserId,
          limit,
          offset,
          PsStatus.PROGRESS_LOADING,
          categoryId);
    }
  }

  Future<void> resetSubCategoryList(Map<dynamic, dynamic> jsonMap,
      String loginUserId, String categoryId) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    isLoading = true;

    updateOffset(0);

    await _repo.getSubCategoryListByCategoryId(
        subCategoryListStream,
        isConnectedToInternet,
        jsonMap,
        loginUserId,
        limit,
        offset,
        PsStatus.PROGRESS_LOADING,
        categoryId);

    isLoading = false;
  }
}
