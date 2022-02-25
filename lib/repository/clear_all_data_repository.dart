import 'dart:async';
import 'package:businesslistingapi/api/common/ps_resource.dart';
import 'package:businesslistingapi/api/common/ps_status.dart';
import 'package:businesslistingapi/db/blog_dao.dart';
import 'package:businesslistingapi/db/category_map_dao.dart';
import 'package:businesslistingapi/db/cateogry_dao.dart';
import 'package:businesslistingapi/db/comment_detail_dao.dart';
import 'package:businesslistingapi/db/comment_header_dao.dart';
import 'package:businesslistingapi/db/item_collection_dao.dart';
import 'package:businesslistingapi/db/item_dao.dart';
import 'package:businesslistingapi/db/item_map_dao.dart';
import 'package:businesslistingapi/db/rating_dao.dart';
import 'package:businesslistingapi/db/sub_category_dao.dart';
import 'package:businesslistingapi/repository/Common/ps_repository.dart';
import 'package:businesslistingapi/viewobject/item.dart';

class ClearAllDataRepository extends PsRepository {
  Future<dynamic> clearAllData(
      StreamController<PsResource<List<Item>>> allListStream) async {
    final ItemDao _productDao = ItemDao.instance;
    final CategoryDao _categoryDao = CategoryDao();
    final CommentHeaderDao _commentHeaderDao = CommentHeaderDao.instance;
    final CommentDetailDao _commentDetailDao = CommentDetailDao.instance;
    final CategoryMapDao _categoryMapDao = CategoryMapDao.instance;
    final ItemCollectionDao _productCollectionDao = ItemCollectionDao.instance;
    final ItemMapDao _productMapDao = ItemMapDao.instance;
    final RatingDao _ratingDao = RatingDao.instance;
    final SubCategoryDao _subCategoryDao = SubCategoryDao();
    final BlogDao _blogDao = BlogDao.instance;
    await _productDao.deleteAll();
    await _blogDao.deleteAll();
    await _categoryDao.deleteAll();
    await _commentHeaderDao.deleteAll();
    await _commentDetailDao.deleteAll();
    await _categoryMapDao.deleteAll();
    await _productCollectionDao.deleteAll();
    await _productMapDao.deleteAll();
    await _ratingDao.deleteAll();
    await _subCategoryDao.deleteAll();

    allListStream.sink.add(await _productDao.getAll(status: PsStatus.SUCCESS));
  }
}
