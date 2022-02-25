import 'dart:async';
import 'package:businesslistingapi/repository/city_blog_repository.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:businesslistingapi/api/common/ps_resource.dart';
import 'package:businesslistingapi/api/common/ps_status.dart';
import 'package:businesslistingapi/provider/common/ps_provider.dart';
import 'package:businesslistingapi/viewobject/blog.dart';

class CityBlogProvider extends PsProvider {
  CityBlogProvider({@required CityBlogRepository repo, int limit = 0})
      : super(repo, limit) {
    _repo = repo;

    print('City Blog Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });
    cityBlogListStream = StreamController<PsResource<List<Blog>>>.broadcast();
    subscription =
        cityBlogListStream.stream.listen((PsResource<List<Blog>> resource) {
      updateOffset(resource.data.length);

      _cityBlogList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  CityBlogRepository _repo;

  PsResource<List<Blog>> _cityBlogList =
      PsResource<List<Blog>>(PsStatus.NOACTION, '', <Blog>[]);

  PsResource<List<Blog>> get cityBlogList => _cityBlogList;
  StreamSubscription<PsResource<List<Blog>>> subscription;
  StreamController<PsResource<List<Blog>>> cityBlogListStream;
  @override
  void dispose() {
    subscription.cancel();
    cityBlogListStream.close();
    isDispose = true;
    print('City Blog Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadCityBlogList(String cityId) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo.getCityBlogList(cityBlogListStream, isConnectedToInternet,
        limit, offset, cityId, PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> nextCityBlogList(String cityId) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;
      await _repo.getNextPageCityBlogList(
          cityBlogListStream,
          isConnectedToInternet,
          limit,
          offset,
          cityId,
          PsStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetCityBlogList(String cityId) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo.getCityBlogList(cityBlogListStream, isConnectedToInternet,
        limit, offset, cityId, PsStatus.PROGRESS_LOADING);

    isLoading = false;
  }
}
