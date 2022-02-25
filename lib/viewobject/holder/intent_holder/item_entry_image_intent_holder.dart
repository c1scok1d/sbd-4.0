import 'package:flutter/cupertino.dart';
import 'package:businesslistingapi/provider/gallery/gallery_provider.dart';
import 'package:businesslistingapi/viewobject/default_photo.dart';

import '../../item.dart';

class ItemEntryImageIntentHolder {
  const ItemEntryImageIntentHolder({
    @required this.flag,
    @required this.itemId,
    this.image,
    this.item,
    this.isPromotion,
    @required this.provider,
  });
  final String flag;
  final String itemId;
  final String isPromotion;
  final Item item;
  final DefaultPhoto image;
  final GalleryProvider provider;
}
