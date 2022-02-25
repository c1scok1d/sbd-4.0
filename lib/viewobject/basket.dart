import 'package:businesslistingapi/viewobject/common/ps_object.dart';
import 'package:businesslistingapi/viewobject/item.dart';
import 'package:quiver/core.dart';

import 'basket_selected_attribute.dart';

class Basket extends PsObject<Basket> {
  Basket(
      {this.id,
      this.itemId,
      this.qty,
      this.cityId,
      this.selectedColorId,
      this.selectedColorValue,
      this.basketPrice,
      this.basketOriginalPrice,
      this.isConnected,
      this.selectedAttributeTotalPrice,
      this.item,
      this.basketSelectedAttributeList});

  String id;
  String itemId;
  String qty;
  String cityId;
  String selectedColorId;
  String selectedColorValue;
  String basketPrice;
  String basketOriginalPrice;
  String isConnected;
  String selectedAttributeTotalPrice;
  String selectedAttributesPrice;
  Item item;
  List<BasketSelectedAttribute> basketSelectedAttributeList;

  @override
  bool operator ==(dynamic other) => other is Basket && id == other.id;

  @override
  int get hashCode {
    return hash2(id.hashCode, id.hashCode);
  }

  @override
  String getPrimaryKey() {
    return id;
  }

  @override
  Basket fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return Basket(
        id: dynamicData['id'],
        itemId: dynamicData['item_id'],
        qty: dynamicData['qty'],
        cityId: dynamicData['contact_id'],
        selectedColorId: dynamicData['selected_color_id'],
        selectedColorValue: dynamicData['selected_color_value'],
        basketPrice: dynamicData['basket_price'],
        basketOriginalPrice: dynamicData['basket_original_price'],
        isConnected: dynamicData['is_connected'],
        selectedAttributeTotalPrice:
            dynamicData['selected_attribute_total_price'],
        item: Item().fromMap(dynamicData['item']),
        basketSelectedAttributeList: BasketSelectedAttribute()
            .fromMapList(dynamicData['basket_selected_attribute']),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(Basket object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = object.id;
      data['item_id'] = object.itemId;
      data['qty'] = object.qty;
      data['contact_id'] = object.cityId;
      data['selected_color_id'] = object.selectedColorId;
      data['selected_color_value'] = object.selectedColorValue;
      data['basket_price'] = object.basketPrice;
      data['basket_original_price'] = object.basketOriginalPrice;
      data['is_connected'] = object.isConnected;
      data['selected_attribute_total_price'] =
          object.selectedAttributeTotalPrice;
      data['item'] = Item().toMap(object.item);
      data['basket_selected_attribute'] = BasketSelectedAttribute()
          .toMapList(object.basketSelectedAttributeList);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<Basket> fromMapList(List<dynamic> dynamicDataList) {
    final List<Basket> basketList = <Basket>[];

    if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          basketList.add(fromMap(dynamicData));
        }
      }
    }
    return basketList;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<Basket> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (Basket data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }
    return mapList;
  }
}
