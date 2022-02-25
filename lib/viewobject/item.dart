import 'package:businesslistingapi/viewobject/category.dart';
import 'package:businesslistingapi/viewobject/city.dart';
import 'package:businesslistingapi/viewobject/common/ps_object.dart';
import 'package:businesslistingapi/viewobject/item_spec.dart';
import 'package:businesslistingapi/viewobject/rating_detail.dart';
import 'package:businesslistingapi/viewobject/sub_category.dart';
import 'package:businesslistingapi/viewobject/user.dart';
import 'package:quiver/core.dart';

import 'default_photo.dart';

class Item extends PsObject<Item> {
  Item(
      {this.id,
      this.cityId,
      this.catId,
      this.subCatId,
      this.itemStatusId,
      this.name,
      this.description,
      this.searchTag,
      this.highlightInformation,
      this.isFeatured,
      this.addedDate,
      this.addedUserId,
      this.updatedDate,
      this.updatedUserId,
      this.updatedFlag,
      this.overallRating,
      this.touchCount,
      this.favouriteCount,
      this.likeCount,
      this.lat,
      this.lng,
      this.openingHour,
      this.closingHour,
      this.isPromotion,
      this.phone1,
      this.phone2,
      this.phone3,
      this.email,
      this.address,
      this.facebook,
      this.googlePlus,
      this.twitter,
      this.youtube,
      this.instagram,
      this.pinterest,
      this.website,
      this.whatsapp,
      this.messenger,
      this.timeRemark,
      this.terms,
      this.cancelationPolicy,
      this.additionalInfo,
      this.featuredDate,
      this.isPaid,
      this.dynamicLink,
      this.addedDateStr,
      this.paidStatus,
      this.transStatus,
      this.defaultPhoto,
      this.city,
      this.category,
      this.subCategory,
      this.itemSpecList,
      this.user,
      this.isLiked,
      this.isFavourited,
      this.imageCount,
      this.commentHeaderCount,
      this.currencySymbol,
      this.currencyShortForm,
      this.ratingDetail});

  String id;
  String cityId;
  String catId;
  String subCatId;
  String itemStatusId;
  String name;
  String description;

  String searchTag;
  String highlightInformation;
  String isFeatured;
  String addedDate;
  String addedUserId;
  String updatedDate;
  String updatedUserId;
  String updatedFlag;
  String overallRating;
  String touchCount;
  String favouriteCount;
  String likeCount;
  String lat;
  String lng;
  String openingHour;
  String closingHour;
  String isPromotion;
  String phone1;
  String phone2;
  String phone3;
  String email;
  String address;
  String facebook;
  String googlePlus;
  String twitter;
  String youtube;
  String instagram;
  String pinterest;
  String website;
  String whatsapp;
  String messenger;
  String timeRemark;
  String terms;
  String cancelationPolicy;
  String additionalInfo;
  String featuredDate;
  String isPaid;
  String dynamicLink;
  String addedDateStr;
  String paidStatus;
  String transStatus;
  DefaultPhoto defaultPhoto;
  City city;
  Category category;
  SubCategory subCategory;
  List<ItemSpecification> itemSpecList;
  User user;
  String isLiked;
  String isFavourited;
  String imageCount;
  String commentHeaderCount;
  String currencySymbol;
  String currencyShortForm;
  RatingDetail ratingDetail;

  @override
  bool operator ==(dynamic other) => other is Item && id == other.id;

  @override
  int get hashCode => hash2(id.hashCode, id.hashCode);

  @override
  String getPrimaryKey() {
    return id;
  }

  @override
  Item fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return Item(
          id: dynamicData['id'],
          cityId: dynamicData['city_id'],
          catId: dynamicData['cat_id'],
          subCatId: dynamicData['sub_cat_id'],
          itemStatusId: dynamicData['item_status_id'],
          name: dynamicData['name'],
          description: dynamicData['description'],
          searchTag: dynamicData['search_tag'],
          highlightInformation: dynamicData['highlight_information'],
          isFeatured: dynamicData['is_featured'],
          addedDate: dynamicData['added_date'],
          addedUserId: dynamicData['added_user_id'],
          updatedDate: dynamicData['updated_date'],
          updatedUserId: dynamicData['updated_user_id'],
          updatedFlag: dynamicData['updated_flag'],
          overallRating: dynamicData['overall_rating'],
          touchCount: dynamicData['touch_count'],
          favouriteCount: dynamicData['favourite_count'],
          likeCount: dynamicData['like_count'],
          lat: dynamicData['lat'],
          lng: dynamicData['lng'],
          openingHour: dynamicData['opening_hour'],
          closingHour: dynamicData['closing_hour'],
          isPromotion: dynamicData['is_promotion'],
          phone1: dynamicData['phone1'],
          phone2: dynamicData['phone2'],
          phone3: dynamicData['phone3'],
          email: dynamicData['email'],
          address: dynamicData['address'],
          facebook: dynamicData['facebook'],
          googlePlus: dynamicData['google_plus'],
          twitter: dynamicData['twitter'],
          youtube: dynamicData['youtube'],
          instagram: dynamicData['instagram'],
          pinterest: dynamicData['pinterest'],
          website: dynamicData['website'],
          whatsapp: dynamicData['whatsapp'],
          messenger: dynamicData['messenger'],
          timeRemark: dynamicData['time_remark'],
          terms: dynamicData['terms'],
          cancelationPolicy: dynamicData['cancelation_policy'],
          additionalInfo: dynamicData['additional_info'],
          featuredDate: dynamicData['featured_date'],
          isPaid: dynamicData['is_paid'],
          dynamicLink: dynamicData['dynamic_link'],
          addedDateStr: dynamicData['added_date_str'],
          paidStatus: dynamicData['paid_status'],
          transStatus: dynamicData['trans_status'],
          defaultPhoto: DefaultPhoto().fromMap(dynamicData['default_photo']),
          city: City().fromMap(dynamicData['city']),
          category: Category().fromMap(dynamicData['category']),
          subCategory: SubCategory().fromMap(dynamicData['sub_category']),
          itemSpecList: ItemSpecification().fromMapList(dynamicData['specs']),
          user: User().fromMap(dynamicData['user']),
          isLiked: dynamicData['is_liked'],
          isFavourited: dynamicData['is_favourited'],
          imageCount: dynamicData['image_count'],
          commentHeaderCount: dynamicData['comment_header_count'],
          currencySymbol: dynamicData['currency_symbol'],
          currencyShortForm: dynamicData['currency_short_form'],
          ratingDetail: RatingDetail().fromMap(dynamicData['rating_details']));
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(dynamic object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = object.id;
      data['city_id'] = object.id;
      data['cat_id'] = object.catId;
      data['sub_cat_id'] = object.subCatId;
      data['item_status_id'] = object.itemStatusId;
      data['name'] = object.name;
      data['description'] = object.description;

      data['search_tag'] = object.searchTag;
      data['highlight_information'] = object.highlightInformation;
      data['is_featured'] = object.isFeatured;
      data['added_date'] = object.addedDate;
      data['added_user_id'] = object.addedUserId;
      data['updated_date'] = object.updatedDate;
      data['updated_user_id'] = object.updatedUserId;
      data['updated_flag'] = object.updatedFlag;
      data['overall_rating'] = object.overallRating;
      data['touch_count'] = object.touchCount;
      data['favourite_count'] = object.favouriteCount;
      data['like_count'] = object.likeCount;
      data['lat'] = object.lat;
      data['lng'] = object.lng;
      data['opening_hour'] = object.openingHour;
      data['closing_hour'] = object.closingHour;
      data['is_promotion'] = object.isPromotion;
      data['phone1'] = object.phone1;
      data['phone2'] = object.phone2;
      data['phone3'] = object.phone3;
      data['email'] = object.email;
      data['address'] = object.address;
      data['facebook'] = object.facebook;
      data['google_plus'] = object.googlePlus;
      data['twitter'] = object.twitter;
      data['youtube'] = object.youtube;
      data['instagram'] = object.instagram;
      data['pinterest'] = object.pinterest;
      data['website'] = object.website;
      data['whatsapp'] = object.whatsapp;
      data['messenger'] = object.messenger;
      data['time_remark'] = object.timeRemark;
      data['terms'] = object.terms;
      data['cancelation_policy'] = object.cancelationPolicy;
      data['additional_info'] = object.additionalInfo;
      data['featured_date'] = object.featuredDate;
      data['is_paid'] = object.isPaid;
      data['dynamic_link'] = object.dynamicLink;
      data['added_date_str'] = object.addedDateStr;
      data['paid_status'] = object.paidStatus;
      data['trans_status'] = object.transStatus;
      data['default_photo'] = DefaultPhoto().toMap(object.defaultPhoto);
      data['city'] = City().toMap(object.city);
      data['category'] = Category().toMap(object.category);
      data['user'] = User().toMap(object.user);
      data['sub_category'] = SubCategory().toMap(object.subCategory);
      data['specs'] = ItemSpecification().toMapList(object.itemSpecList);
      data['is_liked'] = object.isLiked;
      data['is_favourited'] = object.isFavourited;
      data['image_count'] = object.imageCount;
      data['comment_header_count'] = object.commentHeaderCount;
      data['currency_symbol'] = object.currencySymbol;
      data['currency_short_form'] = object.currencyShortForm;
      data['rating_details'] = RatingDetail().toMap(object.ratingDetail);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<Item> fromMapList(List<dynamic> dynamicDataList) {
    final List<Item> newFeedList = <Item>[];
    if (dynamicDataList != null) {
      for (dynamic json in dynamicDataList) {
        if (json != null) {
          newFeedList.add(fromMap(json));
        }
      }
    }
    return newFeedList;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<dynamic> objectList) {
    final List<Map<String, dynamic>> dynamicList = <Map<String, dynamic>>[];

    if (objectList != null) {
      for (dynamic data in objectList) {
        if (data != null) {
          dynamicList.add(toMap(data));
        }
      }
    }
    return dynamicList;
  }

  @override
  String toString() {
    return 'Item{id: $id, cityId: $cityId, catId: $catId, subCatId: $subCatId, itemStatusId: $itemStatusId, name: $name, description: $description, searchTag: $searchTag, highlightInformation: $highlightInformation, isFeatured: $isFeatured, addedDate: $addedDate, addedUserId: $addedUserId, updatedDate: $updatedDate, updatedUserId: $updatedUserId, updatedFlag: $updatedFlag, overallRating: $overallRating, touchCount: $touchCount, favouriteCount: $favouriteCount, likeCount: $likeCount, lat: $lat, lng: $lng, openingHour: $openingHour, closingHour: $closingHour, isPromotion: $isPromotion, phone1: $phone1, phone2: $phone2, phone3: $phone3, email: $email, address: $address, facebook: $facebook, googlePlus: $googlePlus, twitter: $twitter, youtube: $youtube, instagram: $instagram, pinterest: $pinterest, website: $website, whatsapp: $whatsapp, messenger: $messenger, timeRemark: $timeRemark, terms: $terms, cancelationPolicy: $cancelationPolicy, additionalInfo: $additionalInfo, featuredDate: $featuredDate, isPaid: $isPaid, dynamicLink: $dynamicLink, addedDateStr: $addedDateStr, paidStatus: $paidStatus, transStatus: $transStatus, defaultPhoto: $defaultPhoto, city: $city, category: $category, subCategory: $subCategory, itemSpecList: $itemSpecList, user: $user, isLiked: $isLiked, isFavourited: $isFavourited, imageCount: $imageCount, commentHeaderCount: $commentHeaderCount, currencySymbol: $currencySymbol, currencyShortForm: $currencyShortForm, ratingDetail: $ratingDetail}';
  }
}
