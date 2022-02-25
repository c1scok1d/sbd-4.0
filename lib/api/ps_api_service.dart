import 'dart:io';

import 'package:businesslistingapi/api/ps_url.dart';
import 'package:businesslistingapi/config/ps_config.dart';
import 'package:businesslistingapi/viewobject/about_app.dart';
import 'package:businesslistingapi/viewobject/api_status.dart';
import 'package:businesslistingapi/viewobject/blog.dart';
import 'package:businesslistingapi/viewobject/category.dart';
import 'package:businesslistingapi/viewobject/city.dart';
import 'package:businesslistingapi/viewobject/city_info.dart';
import 'package:businesslistingapi/viewobject/comment_detail.dart';
import 'package:businesslistingapi/viewobject/comment_header.dart';
import 'package:businesslistingapi/viewobject/coupon_discount.dart';
import 'package:businesslistingapi/viewobject/default_photo.dart';
import 'package:businesslistingapi/viewobject/download_item.dart';
import 'package:businesslistingapi/viewobject/item.dart';
import 'package:businesslistingapi/viewobject/item_collection_header.dart';
import 'package:businesslistingapi/viewobject/item_paid_history.dart';
import 'package:businesslistingapi/viewobject/item_spec.dart';
import 'package:businesslistingapi/viewobject/noti.dart';
import 'package:businesslistingapi/viewobject/ps_app_info.dart';
import 'package:businesslistingapi/viewobject/rating.dart';
import 'package:businesslistingapi/viewobject/status.dart';
import 'package:businesslistingapi/viewobject/sub_category.dart';
import 'package:businesslistingapi/viewobject/user.dart';

import 'common/ps_api.dart';
import 'common/ps_resource.dart';

class PsApiService extends PsApi {
  ///
  /// App Info
  ///
  Future<PsResource<PSAppInfo>> postPsAppInfo(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_post_ps_app_info_url}';
    return await postData<PSAppInfo, PSAppInfo>(PSAppInfo(), url, jsonMap);
  }

  ///
  /// User Register
  ///
  Future<PsResource<User>> postUserRegister(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_post_ps_user_register_url}';
    return await postData<User, User>(User(), url, jsonMap);
  }

  ///
  /// User Verify Email
  ///
  Future<PsResource<User>> postUserEmailVerify(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_post_ps_user_email_verify_url}';
    return await postData<User, User>(User(), url, jsonMap);
  }

  ///
  /// User Login
  ///
  Future<PsResource<User>> postUserLogin(Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_post_ps_user_login_url}';
    return await postData<User, User>(User(), url, jsonMap);
  }

  ///
  /// FB Login
  ///
  Future<PsResource<User>> postFBLogin(Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_post_ps_fb_login_url}';
    return await postData<User, User>(User(), url, jsonMap);
  }

  ///
  /// Google Login
  ///
  Future<PsResource<User>> postGoogleLogin(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_post_ps_google_login_url}';
    return await postData<User, User>(User(), url, jsonMap);
  }

  ///
  /// Apple Login
  ///
  Future<PsResource<User>> postAppleLogin(Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_post_ps_apple_login_url}';
    return await postData<User, User>(User(), url, jsonMap);
  }

  ///
  /// User Forgot Password
  ///
  Future<PsResource<ApiStatus>> postForgotPassword(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_post_ps_user_forgot_password_url}';
    return await postData<ApiStatus, ApiStatus>(ApiStatus(), url, jsonMap);
  }

   ///
  /// Contact
  ///
  Future<PsResource<ApiStatus>> postContactUs(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_contact_us_url}';
    return await postData<ApiStatus, ApiStatus>(ApiStatus(), url, jsonMap);
  }


  ///
  /// User Change Password
  ///
  Future<PsResource<ApiStatus>> postChangePassword(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_post_ps_user_change_password_url}';
    return await postData<ApiStatus, ApiStatus>(ApiStatus(), url, jsonMap);
  }

  ///
  /// User Profile Update
  ///
  Future<PsResource<User>> postProfileUpdate(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_post_ps_user_update_profile_url}';
    return await postData<User, User>(User(), url, jsonMap);
  }

  ///
  /// User Phone Login
  ///
  Future<PsResource<User>> postPhoneLogin(Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_post_ps_phone_login_url}';
    return await postData<User, User>(User(), url, jsonMap);
  }

  ///
  /// User Resend Code
  ///
  Future<PsResource<ApiStatus>> postResendCode(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_post_ps_resend_code_url}';
    return await postData<ApiStatus, ApiStatus>(ApiStatus(), url, jsonMap);
  }

  ///
  /// Touch Count
  ///
  Future<PsResource<ApiStatus>> postTouchCount(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_post_ps_touch_count_url}';
    return await postData<ApiStatus, ApiStatus>(ApiStatus(), url, jsonMap);
  }

  ///
  /// Get User
  ///
  Future<PsResource<List<User>>> getUser(String userId) async {
    final String url =
        '${PsUrl.ps_user_url}/api_key/${PsConfig.ps_api_key}/user_id/$userId';

    return await getServerCall<User, List<User>>(User(), url);
  }

  Future<PsResource<User>> postImageUpload(
      String userId, String platformName, File imageFile) async {
    const String url = '${PsUrl.ps_image_upload_url}';

    return await postUploadImage<User, User>(User(), url, 'user_id', userId,
        'platform_name', platformName, imageFile);
  }

  ///
  /// About App
  ///
  Future<PsResource<List<AboutApp>>> getAboutAppDataList() async {
    const String url =
        '${PsUrl.ps_about_app_url}/api_key/${PsConfig.ps_api_key}/';
    return await getServerCall<AboutApp, List<AboutApp>>(AboutApp(), url);
  }

  ///
  /// Category
  ///
  // Future<PsResource<List<Category>>> getCategoryList(
  //     int limit, int offset, Map<dynamic, dynamic> jsonMap) async {
  //   final String url =
  //       '${PsUrl.ps_category_url}/api_key/${PsConfig.ps_api_key}/limit/$limit/offset/$offset';

  //   return await postData<Category, List<Category>>(Category(), url, jsonMap);
  // }

  ///
  /// Item Paid History
  ///
  Future<PsResource<ItemPaidHistory>> postItemPaidHistory(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_item_paid_history_entry_url}';
    return await postData<ItemPaidHistory, ItemPaidHistory>(
        ItemPaidHistory(), url, jsonMap);
  }

  ///
  /// Paid Ad List
  ///
  Future<PsResource<List<ItemPaidHistory>>> getPaidAdItemList(
      String loginUserId, int limit, int offset) async {
    final String url =
        '${PsUrl.ps_paid_ad_item_list_url}/api_key/${PsConfig.ps_api_key}/login_user_id/$loginUserId/limit/$limit/offset/$offset';

    return await getServerCall<ItemPaidHistory, List<ItemPaidHistory>>(
        ItemPaidHistory(), url);
  }

  ///
  /// Category
  ///
  Future<PsResource<List<Category>>> getCategoryList(
      Map<dynamic, dynamic> jsonMap,
      String loginUserId,
      int limit,
      int offset) async {
    final String url =
        '${PsUrl.ps_category_url}/api_key/${PsConfig.ps_api_key}/limit/$limit/offset/$offset/login_user_id/$loginUserId';

    return await postData<Category, List<Category>>(Category(), url, jsonMap);
  }

  // Future<PsResource<List<Category>>> getAllCategoryList(
  //     Map<dynamic, dynamic> jsonMap) async {
  //   final String url =
  //       '${PsUrl.ps_category_url}/api_key/${PsConfig.ps_api_key}';

  //   return await postData<Category, List<Category>>(Category(), url, jsonMap);
  // }

  ///
  /// Sub Category
  ///
  Future<PsResource<List<SubCategory>>> getSubCategoryList(
      Map<dynamic, dynamic> jsonMap,
      String loginUserId,
      int limit,
      int offset,
      String categoryId) async {
    final String url =
        '${PsUrl.ps_subCategory_url}/api_key/${PsConfig.ps_api_key}/limit/$limit/offset/$offset/cat_id/$categoryId/login_user_id/$loginUserId';

    return await postData<SubCategory, List<SubCategory>>(
        SubCategory(), url, jsonMap);
  }

  Future<PsResource<List<SubCategory>>> getAllSubCategoryList(
      Map<dynamic, dynamic> jsonMap, String categoryId) async {
    final String url =
        '${PsUrl.ps_subCategory_url}/api_key/${PsConfig.ps_api_key}/cat_id/$categoryId';

    return await postData<SubCategory, List<SubCategory>>(
        SubCategory(), url, jsonMap);
  }

  //noti
  Future<PsResource<List<Noti>>> getNotificationList(
      Map<dynamic, dynamic> paramMap, int limit, int offset) async {
    final String url =
        '${PsUrl.ps_noti_url}/api_key/${PsConfig.ps_api_key}/limit/$limit/offset/$offset';

    return await postData<Noti, List<Noti>>(Noti(), url, paramMap);
  }

  //
  /// Item
  ///
  Future<PsResource<List<Item>>> getItemList(
      Map<dynamic, dynamic> paramMap, int limit, int offset) async {
    final String url =
        '${PsUrl.ps_search_item_url}/api_key/${PsConfig.ps_api_key}/limit/$limit/offset/$offset';

    return await postData<Item, List<Item>>(Item(), url, paramMap);
  }

  //
  /// Search City
  ///
  Future<PsResource<List<City>>> getCityList(
      Map<dynamic, dynamic> paramMap, int limit, int offset) async {
    final String url =
        '${PsUrl.ps_search_city_url}/api_key/${PsConfig.ps_api_key}/limit/$limit/offset/$offset';

    return await postData<City, List<City>>(City(), url, paramMap);
  }

  ///
  /// Search Item
  ///
  Future<PsResource<List<Item>>> getItemListByUserId(
      Map<dynamic, dynamic> jsonMap,
      int limit,
      int offset,
      String loginUserId) async {
    final String url =
        '${PsUrl.ps_search_item_url}/api_key/${PsConfig.ps_api_key}/limit/$limit/offset/$offset/login_user_id/$loginUserId';

    return await postData<Item, List<Item>>(Item(), url, jsonMap);
  }
  ///
  /// Search Item
  ///
  Future<PsResource<List<Item>>> getItemListByLocation(
      Map<dynamic, dynamic> jsonMap,
      int limit,
      int offset,
      double lat,
      double lng,
      double miles) async {//api_key/sableisblackbusiness/limit/20/offset/0/lat/41.539120/lng/-87.642700/miles/23
    final String url =
        '${PsUrl.ps_search_item_url}/api_key/${PsConfig.ps_api_key}/limit/$limit/offset/$offset/lat/$lat/lng/$lng/miles/$miles';

    return await getServerCall<Item, List<Item>>(Item(), url);
    return await postData<Item, List<Item>>(Item(), url, jsonMap);
  }

////
  /// Item Detail
  ///
  Future<PsResource<Item>> getItemDetail(
      String itemId, String loginUserId) async {
    final String url =
        '${PsUrl.ps_item_detail_url}/api_key/${PsConfig.ps_api_key}/id/$itemId/login_user_id/$loginUserId';
    PsResource<Item> x= await getServerCall<Item, Item>(Item(), url);
    print('Network Response'+x.data.toString());
    return x;
  }

  Future<PsResource<List<Item>>> getRelatedItemList(
      String itemId, String categoryId, int limit, int offset) async {
    final String url =
        '${PsUrl.ps_related_item_url}/api_key/${PsConfig.ps_api_key}/id/$itemId/cat_id/$categoryId/limit/$limit/offset/$offset';
    print(url);
    return await getServerCall<Item, List<Item>>(Item(), url);
  }

  //
  /// Item Collection
  ///
  Future<PsResource<List<ItemCollectionHeader>>> getItemCollectionList(
      int limit, int offset, String cityId) async {
    final String url =
        '${PsUrl.ps_collection_url}/api_key/${PsConfig.ps_api_key}/limit/$limit/offset/$offset/city_id/$cityId';

    return await getServerCall<ItemCollectionHeader,
        List<ItemCollectionHeader>>(ItemCollectionHeader(), url);
  }

  ///Setting
  ///

  Future<PsResource<CityInfo>> getCityInfo() async {
    const String url =
        '${PsUrl.ps_city_info_url}/api_key/${PsConfig.ps_api_key}';
    return await getServerCall<CityInfo, CityInfo>(CityInfo(), url);
  }

  ///Blog
  ///

  Future<PsResource<List<Blog>>> getBlogList(int limit, int offset) async {
    final String url =
        '${PsUrl.ps_bloglist_url}/api_key/${PsConfig.ps_api_key}/limit/$limit/offset/$offset';

    return await getServerCall<Blog, List<Blog>>(Blog(), url);
  }

  ///
  ///Blog
  ///

  Future<PsResource<List<Blog>>> getBlogListByCityId(
      String cityId, int limit, int offset) async {
    final String url =
        '${PsUrl.ps_bloglist_url}/api_key/${PsConfig.ps_api_key}/limit/$limit/offset/$offset/city_id/$cityId';

    return await getServerCall<Blog, List<Blog>>(Blog(), url);
  }

  ///
  /// Comments
  ///
  Future<PsResource<List<CommentHeader>>> getCommentList(
      String itemId, int limit, int offset) async {
    final String url =
        '${PsUrl.ps_comment_list_url}/api_key/${PsConfig.ps_api_key}/item_id/$itemId/limit/$limit/offset/$offset';

    return await getServerCall<CommentHeader, List<CommentHeader>>(
        CommentHeader(), url);
  }

  Future<PsResource<List<CommentDetail>>> getCommentDetail(
      String headerId, int limit, int offset) async {
    final String url =
        '${PsUrl.ps_comment_detail_url}/api_key/${PsConfig.ps_api_key}/header_id/$headerId/limit/$limit/offset/$offset';

    return await getServerCall<CommentDetail, List<CommentDetail>>(
        CommentDetail(), url);
  }

  Future<PsResource<CommentHeader>> getCommentHeaderById(
      String commentId) async {
    final String url =
        '${PsUrl.ps_comment_list_url}/api_key/${PsConfig.ps_api_key}/id/$commentId';

    return await getServerCall<CommentHeader, CommentHeader>(
        CommentHeader(), url);
  }

  ///
  // /// Favourites
  // ///
  // Future<PsResource<List<Item>>> getFavouritesList(
  //     String loginUserId, int limit, int offset) async {
  //   final String url =
  //       '${PsUrl.ps_favouriteList_url}/api_key/${PsConfig.ps_api_key}/login_user_id/$loginUserId/limit/$limit/offset/$offset';

  //   return await getServerCall<Item, List<Item>>(Item(), url);
  // }

  ///
  /// Product List By Collection Id
  ///
  Future<PsResource<List<Item>>> getItemListByCollectionId(
      String collectionId, int limit, int offset) async {
    final String url =
        '${PsUrl.ps_all_collection_url}/api_key/${PsConfig.ps_api_key}/id/$collectionId/limit/$limit/offset/$offset';

    return await getServerCall<Item, List<Item>>(Item(), url);
  }

  Future<PsResource<List<CommentHeader>>> postCommentHeader(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_commentHeaderPost_url}';
    return await postData<CommentHeader, List<CommentHeader>>(
        CommentHeader(), url, jsonMap);
  }

  Future<PsResource<List<CommentDetail>>> postCommentDetail(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_commentDetailPost_url}';
    return await postData<CommentDetail, List<CommentDetail>>(
        CommentDetail(), url, jsonMap);
  }

  Future<PsResource<List<DownloadItem>>> postDownloadItemList(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_downloadProductPost_url}';
    return await postData<DownloadItem, List<DownloadItem>>(
        DownloadItem(), url, jsonMap);
  }

  Future<PsResource<ApiStatus>> rawRegisterNotiToken(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_noti_register_url}';
    return await postData<ApiStatus, ApiStatus>(ApiStatus(), url, jsonMap);
  }

  Future<PsResource<ApiStatus>> rawUnRegisterNotiToken(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_noti_unregister_url}';
    return await postData<ApiStatus, ApiStatus>(ApiStatus(), url, jsonMap);
  }

  Future<PsResource<Noti>> postNoti(Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_noti_post_url}';
    return await postData<Noti, Noti>(Noti(), url, jsonMap);
  }

  ///
  /// Rating
  ///
  Future<PsResource<Rating>> postRating(Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_rating_post_url}';
    return await postData<Rating, Rating>(Rating(), url, jsonMap);
  }

  Future<PsResource<List<Rating>>> getRatingList(
      String itemId, int limit, int offset) async {
    final String url =
        '${PsUrl.ps_rating_list_url}/api_key/${PsConfig.ps_api_key}/item_id/$itemId/limit/$limit/offset/$offset';

    return await getServerCall<Rating, List<Rating>>(Rating(), url);
  }

  ///
  ///Favourite
  ///
  Future<PsResource<List<Item>>> getFavouriteList(
      String loginUserId, int limit, int offset) async {
    final String url =
        '${PsUrl.ps_favourite_list_url}/api_key/${PsConfig.ps_api_key}/login_user_id/$loginUserId/limit/$limit/offset/$offset';

    return await getServerCall<Item, List<Item>>(Item(), url);
  }

  Future<PsResource<Item>> postFavourite(Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_favourite_post_url}';
    return await postData<Item, Item>(Item(), url, jsonMap);
  }

  ///
  /// Gallery
  ///
  Future<PsResource<List<DefaultPhoto>>> getImageList(
    String parentImgId,
    // String imageType,
    // int limit,
    // int offset
  ) async {
    final String url =
        '${PsUrl.ps_gallery_url}/api_key/${PsConfig.ps_api_key}/img_parent_id/$parentImgId/img_type/item';

    return await getServerCall<DefaultPhoto, List<DefaultPhoto>>(
        DefaultPhoto(), url);
  }

  ///
  /// Specification
  ///
  Future<PsResource<List<ItemSpecification>>> getSpecificationList(
      String itemId) async {
    final String url =
        '${PsUrl.ps_specification_url}/api_key/${PsConfig.ps_api_key}/item_id/$itemId';
    print(url);
    return await getServerCall<ItemSpecification, List<ItemSpecification>>(
        ItemSpecification(), url);
  }

  Future<PsResource<ItemSpecification>> postSpecification(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_add_specification_url}';
    return await postData<ItemSpecification, ItemSpecification>(
        ItemSpecification(), url, jsonMap);
  }

  Future<PsResource<ApiStatus>> postDeleteSpecification(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_delete_specification_url}';
    return await postData<ApiStatus, ApiStatus>(ApiStatus(), url, jsonMap);
  }

  Future<PsResource<DefaultPhoto>> postItemImageUpload(
      String itemId, String imgId, File imageFile) async {
    const String url = '${PsUrl.ps_item_image_upload_url}';

    return postUploadImage<DefaultPhoto, DefaultPhoto>(
        DefaultPhoto(), url, 'item_id', itemId, 'img_id', imgId, imageFile);
  }

  ///
  /// Image Delete
  ///
  Future<PsResource<ApiStatus>> postDeleteImage(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_item_image_delete_url}';
    return await postData<ApiStatus, ApiStatus>(ApiStatus(), url, jsonMap);
  }

  ///
  /// CouponDiscount
  ///
  Future<PsResource<CouponDiscount>> postCouponDiscount(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_couponDiscount_url}';
    return await postData<CouponDiscount, CouponDiscount>(
        CouponDiscount(), url, jsonMap);
  }

  ///
  /// Item Entry
  ///
  Future<PsResource<Item>> postItemEntry(Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_item_entry_url}';
    return await postData<Item, Item>(Item(), url, jsonMap);
  }

  ///
  /// Item Delete
  ///
  Future<PsResource<ApiStatus>> postDeleteItem(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_item_delete_url}';
    return await postData<ApiStatus, ApiStatus>(ApiStatus(), url, jsonMap);
  }

  ///
  /// get Status
  ///
  Future<PsResource<List<Status>>> getStatusList() async {
    const String url = '${PsUrl.ps_status_url}/api_key/${PsConfig.ps_api_key}';

    return await getServerCall<Status, List<Status>>(Status(), url);
  }

  ///
  /// Token
  ///
  Future<PsResource<ApiStatus>> getToken() async {
    const String url = '${PsUrl.ps_token_url}/api_key/${PsConfig.ps_api_key}';
    return await getServerCall<ApiStatus, ApiStatus>(ApiStatus(), url);
  }
}
