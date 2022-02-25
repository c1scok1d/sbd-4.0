import 'dart:async';
import 'package:businesslistingapi/repository/city_repository.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:businesslistingapi/api/common/ps_resource.dart';
import 'package:businesslistingapi/api/common/ps_status.dart';
import 'package:businesslistingapi/provider/common/ps_provider.dart';
import 'package:businesslistingapi/viewobject/city.dart';
import 'package:businesslistingapi/viewobject/holder/city_parameter_holder.dart';

class CityProvider extends PsProvider {
  CityProvider({@required CityRepository repo, int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    print('CityProvider : $hashCode');
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    cityListStream = StreamController<PsResource<List<City>>>.broadcast();

    subscription =
        cityListStream.stream.listen((PsResource<List<City>> resource) {
      updateOffset(resource.data.length);

      _cityList = Utils.removeDuplicateObj<City>(resource);

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        if (_cityList != null && _cityList.data.isNotEmpty) {
          notifyListeners();
        }
      }
    });
  }
  CityRepository _repo;
  PsResource<List<City>> _cityList =
      PsResource<List<City>>(PsStatus.NOACTION, '', <City>[]);

  PsResource<List<City>> get cityList => _cityList;
  StreamSubscription<PsResource<List<City>>> subscription;
  StreamController<PsResource<List<City>>> cityListStream;
  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('Recent Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadCityListByKey(
      CityParameterHolder cityParameterHolder) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    await _repo.getCityList(cityListStream, isConnectedToInternet, limit,
        offset, PsStatus.PROGRESS_LOADING, cityParameterHolder);
  }

  Future<dynamic> nextCityListByKey(
      CityParameterHolder cityParameterHolder) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;

      await _repo.getCityList(cityListStream, isConnectedToInternet, limit,
          offset, PsStatus.PROGRESS_LOADING, cityParameterHolder);
    }
  }

  Future<void> resetCityListByKey(
      CityParameterHolder cityParameterHolder) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo.getCityList(cityListStream, isConnectedToInternet, limit,
        offset, PsStatus.PROGRESS_LOADING, cityParameterHolder);

    isLoading = false;
  }
}
