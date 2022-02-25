import 'package:businesslistingapi/viewobject/city_map.dart';
import 'package:sembast/sembast.dart';
import 'package:businesslistingapi/db/common/ps_dao.dart';

class CityMapDao extends PsDao<CityMap> {
  CityMapDao._() {
    init(CityMap());
  }
  static const String STORE_NAME = 'CityMap';
  final String _primaryKey = 'id';

  // Singleton instance
  static final CityMapDao _singleton = CityMapDao._();

  // Singleton accessor
  static CityMapDao get instance => _singleton;

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String getPrimaryKey(CityMap object) {
    return object.id;
  }

  @override
  Filter getFilter(CityMap object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
