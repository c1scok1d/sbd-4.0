import 'package:businesslistingapi/viewobject/product_collection.dart';
import 'package:sembast/sembast.dart';
import 'package:businesslistingapi/db/common/ps_dao.dart';

class ItemCollectionDao extends PsDao<ItemCollection> {
  ItemCollectionDao._() {
    init(ItemCollection());
  }

  static const String STORE_NAME = 'ItemCollection';
  final String _primaryKey = 'id';
  final String collectionId = 'collection_id';

  // Singleton instance
  static final ItemCollectionDao _singleton = ItemCollectionDao._();

  // Singleton accessor
  static ItemCollectionDao get instance => _singleton;

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String getPrimaryKey(ItemCollection object) {
    return object.id;
  }

  @override
  Filter getFilter(ItemCollection object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
