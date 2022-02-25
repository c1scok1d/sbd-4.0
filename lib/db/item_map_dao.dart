import 'package:businesslistingapi/viewobject/item_map.dart';
import 'package:sembast/sembast.dart';
import 'package:businesslistingapi/db/common/ps_dao.dart';

class ItemMapDao extends PsDao<ItemMap> {
  ItemMapDao._() {
    init(ItemMap());
  }
  static const String STORE_NAME = 'ItemMap';
  final String _primaryKey = 'id';

  // Singleton instance
  static final ItemMapDao _singleton = ItemMapDao._();

  // Singleton accessor
  static ItemMapDao get instance => _singleton;

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String getPrimaryKey(ItemMap object) {
    return object.id;
  }

  @override
  Filter getFilter(ItemMap object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
