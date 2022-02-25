import 'package:businesslistingapi/viewobject/city.dart';
import 'package:sembast/sembast.dart';
import 'package:businesslistingapi/db/common/ps_dao.dart';

class CityDao extends PsDao<City> {
  CityDao._() {
    init(City());
  }

  static const String STORE_NAME = 'City';
  final String _primaryKey = 'id';
  // Singleton instance
  static final CityDao _singleton = CityDao._();

  // Singleton accessor
  static CityDao get instance => _singleton;

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String getPrimaryKey(City object) {
    return object.id;
  }

  @override
  Filter getFilter(City object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
