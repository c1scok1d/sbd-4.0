import 'package:sembast/sembast.dart';
import 'package:businesslistingapi/db/common/ps_dao.dart';
import 'package:businesslistingapi/viewobject/item.dart';

class ItemDao extends PsDao<Item> {
  ItemDao._() {
    init(Item());
  }

  static const String STORE_NAME = 'Item';
  final String _primaryKey = 'id';
  // Singleton instance
  static final ItemDao _singleton = ItemDao._();

  // Singleton accessor
  static ItemDao get instance => _singleton;

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
