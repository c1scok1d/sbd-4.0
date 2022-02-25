import 'package:businesslistingapi/viewobject/item_collection_header.dart';
import 'package:sembast/sembast.dart';
import 'package:businesslistingapi/db/common/ps_dao.dart';

class ItemCollectionHeaderDao extends PsDao<ItemCollectionHeader> {
  ItemCollectionHeaderDao._() {
    init(ItemCollectionHeader());
  }

  static const String STORE_NAME = 'ItemCollectionHeader';
  final String _primaryKey = 'id';
  // Singleton instance
  static final ItemCollectionHeaderDao _singleton = ItemCollectionHeaderDao._();

  // Singleton accessor
  static ItemCollectionHeaderDao get instance => _singleton;

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String getPrimaryKey(ItemCollectionHeader object) {
    return object.id;
  }

  @override
  Filter getFilter(ItemCollectionHeader object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
