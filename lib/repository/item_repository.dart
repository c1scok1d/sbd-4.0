import 'dart:async';

import 'package:businesslistingapi/api/common/ps_resource.dart';
import 'package:businesslistingapi/api/common/ps_status.dart';
import 'package:businesslistingapi/api/ps_api_service.dart';
import 'package:businesslistingapi/constant/ps_constants.dart';
import 'package:businesslistingapi/db/favourite_item_dao.dart';
import 'package:businesslistingapi/db/item_collection_dao.dart';
import 'package:businesslistingapi/db/item_dao.dart';
import 'package:businesslistingapi/db/item_map_dao.dart';
import 'package:businesslistingapi/db/related_item_dao.dart';
import 'package:businesslistingapi/repository/Common/ps_repository.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:businesslistingapi/viewobject/api_status.dart';
import 'package:businesslistingapi/viewobject/download_item.dart';
import 'package:businesslistingapi/viewobject/favourite_item.dart';
import 'package:businesslistingapi/viewobject/holder/item_parameter_holder.dart';
import 'package:businesslistingapi/viewobject/item.dart';
import 'package:businesslistingapi/viewobject/item_map.dart';
import 'package:businesslistingapi/viewobject/product_collection.dart';
import 'package:businesslistingapi/viewobject/related_item.dart';
import 'package:flutter/material.dart';
import 'package:sembast/sembast.dart';

class ItemRepository extends PsRepository {
  ItemRepository(
      {@required PsApiService psApiService, @required ItemDao itemDao}) {
    _psApiService = psApiService;
    _itemDao = itemDao;
  }
  String primaryKey = 'id';
  String mapKey = 'map_key';
  String collectionIdKey = 'collection_id';
  String mainItemIdKey = 'main_item_id';
  PsApiService _psApiService;
  ItemDao _itemDao;

  void sinkItemListStream(
      StreamController<PsResource<List<Item>>> itemListStream,
      PsResource<List<Item>> dataList) {
    if (dataList != null && itemListStream != null) {
      itemListStream.sink.add(dataList);
    }
  }

  void sinkFavouriteItemListStream(
      StreamController<PsResource<List<Item>>> favouriteItemListStream,
      PsResource<List<Item>> dataList) {
    if (dataList != null && favouriteItemListStream != null) {
      favouriteItemListStream.sink.add(dataList);
    }
  }

  void sinkCollectionItemListStream(
      StreamController<PsResource<List<Item>>> collectionItemListStream,
      PsResource<List<Item>> dataList) {
    if (dataList != null && collectionItemListStream != null) {
      collectionItemListStream.sink.add(dataList);
    }
  }

  void sinkItemDetailStream(StreamController<PsResource<Item>> itemDetailStream,
      PsResource<Item> data) {
    if (data != null) {
      itemDetailStream.sink.add(data);
    }
  }

  void sinkRelatedItemListStream(
      StreamController<PsResource<List<Item>>> relatedItemListStream,
      PsResource<List<Item>> dataList) {
    if (dataList != null && relatedItemListStream != null) {
      relatedItemListStream.sink.add(dataList);
    }
  }

  Future<dynamic> insert(Item item) async {
    return _itemDao.insert(primaryKey, item);
  }

  Future<dynamic> update(Item item) async {
    return _itemDao.update(item);
  }

  Future<dynamic> delete(Item item) async {
    return _itemDao.delete(item);
  }

  Future<dynamic> getItemListByLoc(
      StreamController<PsResource<List<Item>>> itemListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      double lat,
      double lng,
      double miles,
      ItemParameterHolder holder,
      {bool isLoadFromServer = true}) async {
    print('getItemListByLoc start');
    // Server Call
    if (isConnectedToInternet) {
      final PsResource<List<Item>> _resource =
          await _psApiService.getItemListByLocation(
              holder.toMap(), limit, offset, lat, lng, miles);

      print('getItemListByLoc ${_resource.toString()}');
      if (_resource.status == PsStatus.SUCCESS) {
        // Create Map List
        print('Status is success');
      } else {
        if (_resource.errorCode == PsConst.ERROR_CODE_10001) {}
        // Load updated Data from Db and Send to UI

      }
      sinkItemListStream(itemListStream, _resource);
    }
  }

  Future<dynamic> getItemList(
      StreamController<PsResource<List<Item>>> itemListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      ItemParameterHolder holder,
      {bool isLoadFromServer = true}) async {
    // Prepare Holder and Map Dao
    final String paramKey = holder.getParamKey();
    final ItemMapDao itemMapDao = ItemMapDao.instance;

    // Load from Db and Send to UI
    sinkItemListStream(
        itemListStream,
        await _itemDao.getAllByMap(
            primaryKey, mapKey, paramKey, itemMapDao, ItemMap(),
            status: status));

    // Server Call
    if (isConnectedToInternet) {
      final PsResource<List<Item>> _resource =
          await _psApiService.getItemList(holder.toMap(), limit, offset);

      print('Param Key $paramKey');
      if (_resource.status == PsStatus.SUCCESS) {
        // Create Map List
        final List<ItemMap> itemMapList = <ItemMap>[];
        int i = 0;
        for (Item data in _resource.data) {
          itemMapList.add(ItemMap(
              id: data.id + paramKey,
              mapKey: paramKey,
              itemId: data.id,
              sorting: i++,
              addedDate: '2019'));
        }

        // Delete and Insert Map Dao
        print('Delete Key $paramKey');
        await itemMapDao
            .deleteWithFinder(Finder(filter: Filter.equals(mapKey, paramKey)));
        print('Insert All Key $paramKey');
        await itemMapDao.insertAll(primaryKey, itemMapList);

        // Insert Item
        await _itemDao.insertAll(primaryKey, _resource.data);
      } else {
        if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
          // Delete and Insert Map Dao
          await itemMapDao.deleteWithFinder(
              Finder(filter: Filter.equals(mapKey, paramKey)));
        }
      }
      // Load updated Data from Db and Send to UI
      sinkItemListStream(
          itemListStream,
          await _itemDao.getAllByMap(
              primaryKey, mapKey, paramKey, itemMapDao, ItemMap()));
    }
  }

  Future<dynamic> getNextPageItemList(
      StreamController<PsResource<List<Item>>> itemListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      ItemParameterHolder holder,
      {bool isLoadFromServer = true}) async {
    final String paramKey = holder.getParamKey();
    final ItemMapDao itemMapDao = ItemMapDao.instance;
    // Load from Db and Send to UI
    sinkItemListStream(
        itemListStream,
        await _itemDao.getAllByMap(
            primaryKey, mapKey, paramKey, itemMapDao, ItemMap(),
            status: status));
    if (isConnectedToInternet) {
      final PsResource<List<Item>> _resource =
          await _psApiService.getItemList(holder.toMap(), limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        // Create Map List
        final List<ItemMap> itemMapList = <ItemMap>[];
        final PsResource<List<ItemMap>> existingMapList = await itemMapDao
            .getAll(finder: Finder(filter: Filter.equals(mapKey, paramKey)));

        int i = 0;
        if (existingMapList != null) {
          i = existingMapList.data.length + 1;
        }
        for (Item data in _resource.data) {
          itemMapList.add(ItemMap(
              id: data.id + paramKey,
              mapKey: paramKey,
              itemId: data.id,
              sorting: i++,
              addedDate: '2019'));
        }

        await itemMapDao.insertAll(primaryKey, itemMapList);

        // Insert Item
        await _itemDao.insertAll(primaryKey, _resource.data);
      }
      sinkItemListStream(
          itemListStream,
          await _itemDao.getAllByMap(
              primaryKey, mapKey, paramKey, itemMapDao, ItemMap()));
    }
  }

  Future<dynamic> getItemDetail(
      StreamController<PsResource<Item>> itemDetailStream,
      String itemId,
      String loginUserId,
      bool isConnectedToInternet,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    final Finder finder = Finder(filter: Filter.equals(primaryKey, itemId));
    sinkItemDetailStream(itemDetailStream,
        await _itemDao.getOne(status: status, finder: finder));

    if (isConnectedToInternet) {
      final PsResource<Item> _resource =
          await _psApiService.getItemDetail(itemId, loginUserId);

      if (_resource.status == PsStatus.SUCCESS) {
        await _itemDao.deleteWithFinder(finder);
        await _itemDao.insert(primaryKey, _resource.data);
        sinkItemDetailStream(
            itemDetailStream, await _itemDao.getOne(finder: finder));
      }
    }
  }

  Future<dynamic> getItemDetailForFav(
      StreamController<PsResource<Item>> itemDetailStream,
      String itemId,
      String loginUserId,
      bool isConnectedToInternet,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    final Finder finder = Finder(filter: Filter.equals(primaryKey, itemId));

    if (isConnectedToInternet) {
      final PsResource<Item> _resource =
          await _psApiService.getItemDetail(itemId, loginUserId);

      if (_resource.status == PsStatus.SUCCESS) {
        await _itemDao.deleteWithFinder(finder);
        await _itemDao.insert(primaryKey, _resource.data);
        sinkItemDetailStream(
            itemDetailStream, await _itemDao.getOne(finder: finder));
      }
    }
  }

  Future<PsResource<Item>> postItemEntry(Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet, PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<Item> _resource =
        await _psApiService.postItemEntry(jsonMap);
    if (_resource.status == PsStatus.SUCCESS) {
      return _resource;
    } else {
      final Completer<PsResource<Item>> completer =
          Completer<PsResource<Item>>();
      completer.complete(_resource);
      return completer.future;
    }
  }

  Future<dynamic> getItemFromDB(String itemId,
      StreamController<dynamic> itemStream, PsStatus status) async {
    final Finder finder = Finder(filter: Filter.equals(primaryKey, itemId));

    itemStream.sink.add(await _itemDao.getOne(finder: finder, status: status));
  }

  Future<PsResource<List<DownloadItem>>> postDownloadItemList(
      Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<List<DownloadItem>> _resource =
        await _psApiService.postDownloadItemList(jsonMap);
    if (_resource.status == PsStatus.SUCCESS) {
      return _resource;
    } else {
      final Completer<PsResource<List<DownloadItem>>> completer =
          Completer<PsResource<List<DownloadItem>>>();
      completer.complete(_resource);
      return completer.future;
    }
  }

  Future<dynamic> getAllFavouritesList(
      StreamController<PsResource<List<Item>>> favouriteItemListStream,
      String loginUserId,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    // Prepare Holder and Map Dao
    // final String paramKey = holder.getParamKey();
    final FavouriteItemDao favouriteItemDao = FavouriteItemDao.instance;

    // Load from Db and Send to UI
    sinkFavouriteItemListStream(
        favouriteItemListStream,
        await _itemDao.getAllByJoin(
            primaryKey, favouriteItemDao, FavouriteItem(),
            status: status));

    // Server Call
    if (isConnectedToInternet) {
      final PsResource<List<Item>> _resource =
          await _psApiService.getFavouriteList(loginUserId, limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        // Create Map List
        final List<FavouriteItem> favouriteItemMapList = <FavouriteItem>[];
        int i = 0;
        for (Item data in _resource.data) {
          favouriteItemMapList.add(FavouriteItem(
            id: data.id,
            sorting: i++,
          ));
        }

        // Delete and Insert Map Dao
        await favouriteItemDao.deleteAll();
        await favouriteItemDao.insertAll(primaryKey, favouriteItemMapList);

        // Insert Item
        await _itemDao.insertAll(primaryKey, _resource.data);
      } else {
        if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
        // Delete and Insert Map Dao
        await favouriteItemDao.deleteAll();
        }
      }
      // Load updated Data from Db and Send to UI
      sinkFavouriteItemListStream(
          favouriteItemListStream,
          await _itemDao.getAllByJoin(
              primaryKey, favouriteItemDao, FavouriteItem()));
    }
  }

  Future<dynamic> getNextPageFavouritesList(
      StreamController<PsResource<List<Item>>> favouriteItemListStream,
      String loginUserId,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    final FavouriteItemDao favouriteItemDao = FavouriteItemDao.instance;
    // Load from Db and Send to UI
    sinkFavouriteItemListStream(
        favouriteItemListStream,
        await _itemDao.getAllByJoin(
            primaryKey, favouriteItemDao, FavouriteItem(),
            status: status));

    if (isConnectedToInternet) {
      final PsResource<List<Item>> _resource =
          await _psApiService.getFavouriteList(loginUserId, limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        // Create Map List
        final List<FavouriteItem> favouriteItemMapList = <FavouriteItem>[];
        final PsResource<List<FavouriteItem>> existingMapList =
            await favouriteItemDao.getAll();

        int i = 0;
        if (existingMapList != null) {
          i = existingMapList.data.length + 1;
        }
        for (Item data in _resource.data) {
          favouriteItemMapList.add(FavouriteItem(
            id: data.id,
            sorting: i++,
          ));
        }

        await favouriteItemDao.insertAll(primaryKey, favouriteItemMapList);

        // Insert Item
        await _itemDao.insertAll(primaryKey, _resource.data);
      }
      sinkFavouriteItemListStream(
          favouriteItemListStream,
          await _itemDao.getAllByJoin(
              primaryKey, favouriteItemDao, FavouriteItem()));
    }
  }

  Future<PsResource<Item>> postFavourite(Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet, PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<Item> _resource =
        await _psApiService.postFavourite(jsonMap);
    if (_resource.status == PsStatus.SUCCESS) {
      return _resource;
    } else {
      final Completer<PsResource<Item>> completer =
          Completer<PsResource<Item>>();
      completer.complete(_resource);
      return completer.future;
    }
  }

  Future<PsResource<ApiStatus>> postTouchCount(Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet, PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<ApiStatus> _resource =
        await _psApiService.postTouchCount(jsonMap);
    if (_resource.status == PsStatus.SUCCESS) {
      return _resource;
    } else {
      final Completer<PsResource<ApiStatus>> completer =
          Completer<PsResource<ApiStatus>>();
      completer.complete(_resource);
      return completer.future;
    }
  }

  Future<dynamic> getRelatedItemList(
      StreamController<PsResource<List<Item>>> relatedItemListStream,
      String itemId,
      String categoryId,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    // Prepare Holder and Map Dao
    // final String paramKey = holder.getParamKey();
    final Finder finder = Finder(filter: Filter.equals(mainItemIdKey, itemId));
    final RelatedItemDao relatedItemDao = RelatedItemDao.instance;

    // Load from Db and Send to UI

    sinkCollectionItemListStream(
        relatedItemListStream,
        await _itemDao.getAllDataListWithFilterId(
            itemId, mainItemIdKey, relatedItemDao, RelatedItem(),
            status: status));

    // Server Call
    if (isConnectedToInternet) {
      final PsResource<List<Item>> _resource = await _psApiService
          .getRelatedItemList(itemId, categoryId, limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        // Create Map List
        final List<RelatedItem> relatedItemMapList = <RelatedItem>[];
        int i = 0;
        for (Item data in _resource.data) {
          relatedItemMapList.add(RelatedItem(
            id: data.id,
            mainItemId: itemId,
            sorting: i++,
          ));
        }

        // Delete and Insert Map Dao
        // await relatedItemDao.deleteAll();
        await relatedItemDao.deleteWithFinder(finder);
        await relatedItemDao.insertAll(primaryKey, relatedItemMapList);

        // Insert Item
        await _itemDao.insertAll(primaryKey, _resource.data);
        
      }else{
        if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
          // await relatedItemDao.deleteAll();
          await relatedItemDao.deleteWithFinder(finder);
        }
      }
      // Load updated Data from Db and Send to UI
        sinkCollectionItemListStream(
            relatedItemListStream,
            await _itemDao.getAllDataListWithFilterId(
                itemId, mainItemIdKey, relatedItemDao, RelatedItem(),
                status: status));
    }
  }

  ///Item list By Collection Id

  Future<dynamic> getAllitemListByCollectionId(
      StreamController<PsResource<List<Item>>> itemCollectionStream,
      bool isConnectedToInternet,
      String collectionId,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    final Finder finder =
        Finder(filter: Filter.equals(collectionIdKey, collectionId));
    final ItemCollectionDao itemCollectionDao = ItemCollectionDao.instance;

    // Load from Db and Send to UI
    sinkCollectionItemListStream(
        itemCollectionStream,
        await _itemDao.getAllDataListWithFilterId(
            collectionId, collectionIdKey, itemCollectionDao, ItemCollection(),
            status: status));

    // Server Call
    if (isConnectedToInternet) {
      final PsResource<List<Item>> _resource = await _psApiService
          .getItemListByCollectionId(collectionId, limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        // Create Map List
        final List<ItemCollection> itemCollectionMapList = <ItemCollection>[];
        int i = 0;
        for (Item data in _resource.data) {
          itemCollectionMapList.add(ItemCollection(
            id: data.id,
            collectionId: collectionId,
            sorting: i++,
          ));
        }

        // Delete and Insert Map Dao
        await itemCollectionDao.deleteWithFinder(finder);
        await itemCollectionDao.insertAll(primaryKey, itemCollectionMapList);

        // Insert Item
        await _itemDao.insertAll(primaryKey, _resource.data);
      }else{
        if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
          // Delete and Insert Map Dao
          await itemCollectionDao.deleteWithFinder(finder);
        }
      }
      // Load updated Data from Db and Send to UI

      sinkCollectionItemListStream(
          itemCollectionStream,
          await _itemDao.getAllDataListWithFilterId(collectionId,
              collectionIdKey, itemCollectionDao, ItemCollection()));

      Utils.psPrint('End of Collection Item');
    }
  }

  Future<dynamic> getNextPageitemListByCollectionId(
      StreamController<PsResource<List<Item>>> itemCollectionStream,
      bool isConnectedToInternet,
      String collectionId,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    final Finder finder =
        Finder(filter: Filter.equals('collection_id', collectionId));
    final ItemCollectionDao itemCollectionDao = ItemCollectionDao.instance;
    // Load from Db and Send to UI
    sinkCollectionItemListStream(
        itemCollectionStream,
        await _itemDao.getAllDataListWithFilterId(
            collectionId, collectionIdKey, itemCollectionDao, ItemCollection(),
            status: status));

    if (isConnectedToInternet) {
      final PsResource<List<Item>> _resource = await _psApiService
          .getItemListByCollectionId(collectionId, limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        // Create Map List
        final List<ItemCollection> itemCollectionMapList = <ItemCollection>[];
        final PsResource<List<ItemCollection>> existingMapList =
            await itemCollectionDao.getAll(finder: finder);

        int i = 0;
        if (existingMapList != null) {
          i = existingMapList.data.length + 1;
        }
        for (Item data in _resource.data) {
          itemCollectionMapList.add(ItemCollection(
            id: data.id,
            collectionId: collectionId,
            sorting: i++,
          ));
        }

        await itemCollectionDao.insertAll(primaryKey, itemCollectionMapList);

        // Insert Item
        await _itemDao.insertAll(primaryKey, _resource.data);
      }
      sinkCollectionItemListStream(
          itemCollectionStream,
          await _itemDao.getAllDataListWithFilterId(collectionId,
              collectionIdKey, itemCollectionDao, ItemCollection()));
      Utils.psPrint('End of Collection Item');
    }
  }

  Future<dynamic> getItemListByUserId(
      StreamController<PsResource<List<Item>>> itemListStream,
      String loginUserId,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      ItemParameterHolder holder,
      {bool isLoadFromServer = true}) async {
    // Prepare Holder and Map Dao
    final String paramKey = holder.getParamKey();
    final ItemMapDao itemMapDao = ItemMapDao.instance;

    // Load from Db and Send to UI
    sinkItemListStream(
        itemListStream,
        await _itemDao.getAllByMap(
            primaryKey, mapKey, paramKey, itemMapDao, ItemMap(),
            status: status));

    // Server Call
    if (isConnectedToInternet) {
      final PsResource<List<Item>> _resource = await _psApiService
          .getItemListByUserId(holder.toMap(), limit, offset, loginUserId);

      print('Param Key $paramKey');
      if (_resource.status == PsStatus.SUCCESS) {
        // Create Map List
        final List<ItemMap> itemMapList = <ItemMap>[];
        int i = 0;
        for (Item data in _resource.data) {
          itemMapList.add(ItemMap(
              id: data.id + paramKey,
              mapKey: paramKey,
              itemId: data.id,
              sorting: i++,
              addedDate: '2019'));
        }

        // Delete and Insert Map Dao
        print('Delete Key $paramKey');
        await itemMapDao
            .deleteWithFinder(Finder(filter: Filter.equals(mapKey, paramKey)));
        print('Insert All Key $paramKey');
        await itemMapDao.insertAll(primaryKey, itemMapList);

        // Insert Item
        await _itemDao.insertAll(primaryKey, _resource.data);
      } else {
        if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
          // Delete and Insert Map Dao
          await itemMapDao.deleteWithFinder(
              Finder(filter: Filter.equals(mapKey, paramKey)));
        }
      }
      // Load updated Data from Db and Send to UI
      sinkItemListStream(
          itemListStream,
          await _itemDao.getAllByMap(
              primaryKey, mapKey, paramKey, itemMapDao, ItemMap()));
    }
  }

  Future<dynamic> getNextPageItemListByUserId(
      StreamController<PsResource<List<Item>>> itemListStream,
      String loginUserId,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      ItemParameterHolder holder,
      {bool isLoadFromServer = true}) async {
    final String paramKey = holder.getParamKey();
    final ItemMapDao itemMapDao = ItemMapDao.instance;
    // Load from Db and Send to UI
    sinkItemListStream(
        itemListStream,
        await _itemDao.getAllByMap(
            primaryKey, mapKey, paramKey, itemMapDao, ItemMap(),
            status: status));
    if (isConnectedToInternet) {
      final PsResource<List<Item>> _resource = await _psApiService
          .getItemListByUserId(holder.toMap(), limit, offset, loginUserId);

      if (_resource.status == PsStatus.SUCCESS) {
        // Create Map List
        final List<ItemMap> itemMapList = <ItemMap>[];
        final PsResource<List<ItemMap>> existingMapList = await itemMapDao
            .getAll(finder: Finder(filter: Filter.equals(mapKey, paramKey)));

        int i = 0;
        if (existingMapList != null) {
          i = existingMapList.data.length + 1;
        }
        for (Item data in _resource.data) {
          itemMapList.add(ItemMap(
              id: data.id + paramKey,
              mapKey: paramKey,
              itemId: data.id,
              sorting: i++,
              addedDate: '2019'));
        }

        await itemMapDao.insertAll(primaryKey, itemMapList);

        // Insert Item
        await _itemDao.insertAll(primaryKey, _resource.data);
      }
      sinkItemListStream(
          itemListStream,
          await _itemDao.getAllByMap(
              primaryKey, mapKey, paramKey, itemMapDao, ItemMap()));
    }
  }

  Future<PsResource<ApiStatus>> postDeleteItem(Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet, PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<ApiStatus> _resource =
        await _psApiService.postDeleteItem(jsonMap);
    if (_resource.status == PsStatus.SUCCESS) {
      return _resource;
    } else {
      final Completer<PsResource<ApiStatus>> completer =
          Completer<PsResource<ApiStatus>>();
      completer.complete(_resource);
      return completer.future;
    }
  }
}
