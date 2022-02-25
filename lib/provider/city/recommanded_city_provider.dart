import 'dart:async';
import 'package:businesslistingapi/repository/city_repository.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:businesslistingapi/api/common/ps_resource.dart';
import 'package:businesslistingapi/api/common/ps_status.dart';
import 'package:businesslistingapi/provider/common/ps_provider.dart';
import 'package:businesslistingapi/viewobject/city.dart';
import 'package:businesslistingapi/viewobject/holder/city_parameter_holder.dart';

class RecommandedCityProvider extends PsProvider {
  RecommandedCityProvider({@required CityRepository repo, int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    print('RecommandedCityProvider : $hashCode');
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    recommandedCityListStream =
        StreamController<PsResource<List<City>>>.broadcast();

    subscription = recommandedCityListStream.stream
        .listen((PsResource<List<City>> resource) {
      updateOffset(resource.data.length);

      _recommandedCityList = Utils.removeDuplicateObj<City>(resource);

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }
  CityRepository _repo;
  PsResource<List<City>> _recommandedCityList =
      PsResource<List<City>>(PsStatus.NOACTION, '', <City>[]);

  PsResource<List<City>> get recommandedCityList => _recommandedCityList;
  StreamSubscription<PsResource<List<City>>> subscription;
  StreamController<PsResource<List<City>>> recommandedCityListStream;
  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('Recommanded Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadRecommandedCityList() async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    await _repo.getCityList(
        recommandedCityListStream,
        isConnectedToInternet,
        limit,
        offset,
        PsStatus.PROGRESS_LOADING,
        CityParameterHolder().getFeaturedCities());
  }

  Future<dynamic> nextRecommandedCityList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;

      await _repo.getCityList(
          recommandedCityListStream,
          isConnectedToInternet,
          limit,
          offset,
          PsStatus.PROGRESS_LOADING,
          CityParameterHolder().getFeaturedCities());
    }
  }

  Future<void> resetRecommandedCityList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo.getCityList(
        recommandedCityListStream,
        isConnectedToInternet,
        limit,
        offset,
        PsStatus.PROGRESS_LOADING,
        CityParameterHolder().getFeaturedCities());

    isLoading = false;
  }
}
