import 'package:flutter/cupertino.dart';
import 'package:businesslistingapi/viewobject/item_collection_header.dart';

class CollectionIntentHolder {
  const CollectionIntentHolder({
    @required this.itemCollectionHeader,
    @required this.appBarTitle,
  });
  final ItemCollectionHeader itemCollectionHeader;
  final String appBarTitle;
}
