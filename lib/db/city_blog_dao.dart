import 'package:businesslistingapi/viewobject/blog.dart';
import 'package:sembast/sembast.dart';
import 'package:businesslistingapi/db/common/ps_dao.dart' show PsDao;

class CityBlogDao extends PsDao<Blog> {
  CityBlogDao._() {
    init(Blog());
  }
  static const String STORE_NAME = 'CityBlog';
  final String _primaryKey = 'id';

  // Singleton instance
  static final CityBlogDao _singleton = CityBlogDao._();

  // Singleton accessor
  static CityBlogDao get instance => _singleton;

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String getPrimaryKey(Blog object) {
    return object.id;
  }

  @override
  Filter getFilter(Blog object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
