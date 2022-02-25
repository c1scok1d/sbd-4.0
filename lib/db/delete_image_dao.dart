import 'package:businesslistingapi/viewobject/gallery_image.dart';
import 'package:sembast/sembast.dart';
import 'package:businesslistingapi/db/common/ps_dao.dart';

class DeleteImageDao extends PsDao<GalleryImage> {
  DeleteImageDao._() {
    init(GalleryImage());
  }

  static const String STORE_NAME = 'GalleryImage';
  final String _primaryKey = 'id';
  // Singleton instance
  static final DeleteImageDao _singleton = DeleteImageDao._();

  // Singleton accessor
  static DeleteImageDao get instance => _singleton;

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String getPrimaryKey(GalleryImage object) {
    return object.id;
  }

  @override
  Filter getFilter(GalleryImage object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
