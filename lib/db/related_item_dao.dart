import 'package:businesslistingapi/viewobject/related_item.dart';
import 'package:sembast/sembast.dart';
import 'package:businesslistingapi/db/common/ps_dao.dart';

class RelatedItemDao extends PsDao<RelatedItem> {
  RelatedItemDao._() {
    init(RelatedItem());
  }

  static const String STORE_NAME = 'RelatedItem';
  final String _primaryKey = 'id';
  // Singleton instance
  static final RelatedItemDao _singleton = RelatedItemDao._();

  // Singleton accessor
  static RelatedItemDao get instance => _singleton;

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String getPrimaryKey(RelatedItem object) {
    return object.id;
  }

  @override
  Filter getFilter(RelatedItem object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
