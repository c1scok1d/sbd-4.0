import 'package:businesslistingapi/viewobject/item_spec.dart';
import 'package:sembast/sembast.dart';
import 'package:businesslistingapi/db/common/ps_dao.dart';

class SpecificationDao extends PsDao<ItemSpecification> {
  SpecificationDao._() {
    init(ItemSpecification());
  }

  static const String STORE_NAME = 'Specification';
  final String _primaryKey = 'id';
  // Singleton instance
  static final SpecificationDao _singleton = SpecificationDao._();

  // Singleton accessor
  static SpecificationDao get instance => _singleton;

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String getPrimaryKey(ItemSpecification object) {
    return object.itemId;
  }

  @override
  Filter getFilter(ItemSpecification object) {
    return Filter.equals(_primaryKey, object.itemId);
  }
}
