import 'package:businesslistingapi/viewobject/item.dart';
import 'package:sembast/sembast.dart';
import 'package:businesslistingapi/db/common/ps_dao.dart' show PsDao;

class HistoryDao extends PsDao<Item> {
  HistoryDao._() {
    init(Item());
  }
  static const String STORE_NAME = 'History';
  final String _primaryKey = 'id';

  // Singleton instance
  static final HistoryDao _singleton = HistoryDao._();

  // Singleton accessor
  static HistoryDao get instance => _singleton;

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String getPrimaryKey(Item object) {
    return object.id;
  }

  @override
  Filter getFilter(Item object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
