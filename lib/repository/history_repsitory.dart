import 'dart:async';
import 'package:businesslistingapi/db/history_dao.dart';
import 'package:businesslistingapi/viewobject/item.dart';
import 'package:flutter/material.dart';
import 'package:businesslistingapi/api/common/ps_resource.dart';
import 'package:businesslistingapi/api/common/ps_status.dart';

import 'Common/ps_repository.dart';

class HistoryRepository extends PsRepository {
  HistoryRepository({@required HistoryDao historyDao}) {
    _historyDao = historyDao;
  }

  String primaryKey = 'id';
  HistoryDao _historyDao;

  Future<dynamic> insert(Item history) async {
    return _historyDao.insert(primaryKey, history);
  }

  Future<dynamic> update(Item history) async {
    return _historyDao.update(history);
  }

  Future<dynamic> delete(Item history) async {
    return _historyDao.delete(history);
  }

  Future<dynamic> getAllHistoryList(
      StreamController<PsResource<List<Item>>> historyListStream,
      PsStatus status) async {
    historyListStream.sink.add(await _historyDao.getAll(status: status));
  }

  Future<dynamic> addAllHistoryList(
      StreamController<PsResource<List<Item>>> historyListStream,
      PsStatus status,
      Item product) async {
    await _historyDao.insert(primaryKey, product);
    historyListStream.sink.add(await _historyDao.getAll(status: status));
  }
}
