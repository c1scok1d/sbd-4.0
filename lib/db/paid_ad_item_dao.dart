import 'package:businesslistingapi/db/common/ps_dao.dart';
import 'package:businesslistingapi/viewobject/item_paid_history.dart';
import 'package:sembast/sembast.dart';

class PaidAdItemDao extends PsDao<ItemPaidHistory> {
  PaidAdItemDao._() {
    init(ItemPaidHistory());
  }
  static const String STORE_NAME = 'PaidAdItem';
  final String _primaryKey = 'id';

  // Singleton instance
  static final PaidAdItemDao _singleton = PaidAdItemDao._();

  // Singleton accessor
  static PaidAdItemDao get instance => _singleton;

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String getPrimaryKey(ItemPaidHistory object) {
    return object.id;
  }

  @override
  Filter getFilter(ItemPaidHistory object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
