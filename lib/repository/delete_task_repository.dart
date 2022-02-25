import 'dart:async';
import 'package:businesslistingapi/api/common/ps_resource.dart';
import 'package:businesslistingapi/api/common/ps_status.dart';
import 'package:businesslistingapi/db/favourite_item_dao.dart';
import 'package:businesslistingapi/db/history_dao.dart';
import 'package:businesslistingapi/db/user_login_dao.dart';
import 'package:businesslistingapi/repository/Common/ps_repository.dart';
import 'package:businesslistingapi/viewobject/user_login.dart';

class DeleteTaskRepository extends PsRepository {
  Future<dynamic> deleteTask(
      StreamController<PsResource<List<UserLogin>>> allListStream) async {
    final FavouriteItemDao _favProductDao = FavouriteItemDao.instance;
    final UserLoginDao _userLoginDao = UserLoginDao.instance;
    final HistoryDao _historyDao = HistoryDao.instance;
    await _favProductDao.deleteAll();
    await _userLoginDao.deleteAll();
    await _historyDao.deleteAll();

    allListStream.sink
        .add(await _userLoginDao.getAll(status: PsStatus.SUCCESS));
  }
}
