import 'package:businesslistingapi/viewobject/city_info.dart';
import 'package:sembast/sembast.dart';
import 'package:businesslistingapi/db/common/ps_dao.dart' show PsDao;

class CityInfoDao extends PsDao<CityInfo> {
  CityInfoDao._() {
    init(CityInfo());
  }
  static const String STORE_NAME = 'CityInfo';
  final String _primaryKey = 'id';

  // Singleton instance
  static final CityInfoDao _singleton = CityInfoDao._();

  // Singleton accessor
  static CityInfoDao get instance => _singleton;

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String getPrimaryKey(CityInfo object) {
    return object.id;
  }

  @override
  Filter getFilter(CityInfo object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
