import 'package:businesslistingapi/viewobject/favourite_item.dart';
import 'package:sembast/sembast.dart';
import 'package:businesslistingapi/db/common/ps_dao.dart';

class FavouriteItemDao extends PsDao<FavouriteItem> {
  FavouriteItemDao._() {
    init(FavouriteItem());
  }
  static const String STORE_NAME = 'FavouriteItem';
  final String _primaryKey = 'id';

  // Singleton instance
  static final FavouriteItemDao _singleton = FavouriteItemDao._();

  // Singleton accessor
  static FavouriteItemDao get instance => _singleton;

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String getPrimaryKey(FavouriteItem object) {
    return object.id;
  }

  @override
  Filter getFilter(FavouriteItem object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
