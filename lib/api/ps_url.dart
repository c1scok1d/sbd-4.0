import 'package:businesslistingapi/config/ps_config.dart';

class PsUrl {
  PsUrl._();

  ///
  /// APIs Url
  ///
  static const String ps_item_detail_url = 'rest/items/get';

  static const String ps_category_url = 'rest/categories/search';

  static const String ps_category_list_url = 'rest/categories/get';

  static const String ps_item_paid_history_entry_url =
      'rest/paid_items/add/api_key/${PsConfig.ps_api_key}';

       static const String ps_contact_us_url =
      'rest/contacts/add/api_key/${PsConfig.ps_api_key}';

  static const String ps_paid_ad_item_list_url = 'rest/paid_items/get';

  static const String ps_about_app_url = 'rest/abouts/get';

  static const String ps_image_upload_url =
      'rest/images/upload/api_key/${PsConfig.ps_api_key}';

  static const String ps_collection_url = 'rest/collections/get';

  static const String ps_all_collection_url = 'rest/items/all_collection_items';

  static const String ps_post_ps_app_info_url =
      'rest/appinfo/get_delete_history/api_key/${PsConfig.ps_api_key}';

  static const String ps_post_ps_user_register_url =
      'rest/users/add/api_key/${PsConfig.ps_api_key}/';

  static const String ps_post_ps_user_email_verify_url =
      'rest/users/verify/api_key/${PsConfig.ps_api_key}/';

  static const String ps_post_ps_user_login_url =
      'rest/users/login/api_key/${PsConfig.ps_api_key}/';

  static const String ps_post_ps_user_forgot_password_url =
      'rest/users/reset/api_key/${PsConfig.ps_api_key}/';

  static const String ps_post_ps_user_change_password_url =
      'rest/users/password_update/api_key/${PsConfig.ps_api_key}/';

  static const String ps_post_ps_user_update_profile_url =
      'rest/users/profile_update/api_key/${PsConfig.ps_api_key}';

  static const String ps_post_ps_phone_login_url =
      'rest/users/phone_register/api_key/${PsConfig.ps_api_key}';

  static const String ps_post_ps_fb_login_url =
      'rest/users/register/api_key/${PsConfig.ps_api_key}';

  static const String ps_post_ps_google_login_url =
      'rest/users/google_register/api_key/${PsConfig.ps_api_key}';

  static const String ps_post_ps_apple_login_url =
      'rest/users/apple_register/api_key/${PsConfig.ps_api_key}';

  static const String ps_post_ps_resend_code_url =
      'rest/users/request_code/api_key/${PsConfig.ps_api_key}/';

  static const String ps_post_ps_touch_count_url =
      'rest/touches/add_touch/api_key/${PsConfig.ps_api_key}';

  static const String ps_search_item_url = 'rest/items/search';

  static const String ps_search_city_url = 'rest/cities/search';

  // static const String ps_products_search_url =
  //     'rest/products/search/api_key/${PsConfig.ps_api_key}/';

  static const String ps_subCategory_url = 'rest/subcategories/search';

  static const String ps_user_url = 'rest/users/get';

  static const String ps_noti_url = 'rest/notis/all_notis';

  static const String ps_city_info_url = 'rest/cities/get_city_info';

  static const String ps_bloglist_url = 'rest/feeds/get';

  static const String ps_blog_list_by_city_id_url = 'rest/feeds/get';

  static const String ps_transactionList_url = 'rest/transactionheaders/get';

  static const String ps_transactionDetail_url = 'rest/transactiondetails/get';

  static const String ps_related_item_url = 'rest/items/related_item_trending';

  static const String ps_comment_list_url = 'rest/commentheaders/get';

  static const String ps_comment_detail_url = 'rest/commentdetails/get';

  static const String ps_commentHeaderPost_url =
      'rest/commentheaders/press/api_key/${PsConfig.ps_api_key}';

  static const String ps_commentDetailPost_url =
      'rest/commentdetails/press/api_key/${PsConfig.ps_api_key}';

  static const String ps_downloadProductPost_url =
      'rest/downloads/download_product/api_key/${PsConfig.ps_api_key}';

  static const String ps_noti_register_url =
      'rest/notis/register/api_key/${PsConfig.ps_api_key}';

  static const String ps_noti_post_url =
      'rest/notis/is_read/api_key/${PsConfig.ps_api_key}';

  static const String ps_noti_unregister_url =
      'rest/notis/unregister/api_key/${PsConfig.ps_api_key}';

  static const String ps_rating_post_url =
      'rest/rates/add_rating/api_key/${PsConfig.ps_api_key}';

  static const String ps_rating_list_url = 'rest/rates/get';

  static const String ps_favourite_post_url =
      'rest/favourites/press/api_key/${PsConfig.ps_api_key}';

  static const String ps_favourite_list_url = 'rest/items/get_favourite';

  static const String ps_gallery_url = 'rest/images/get';

  static const String ps_specification_url = 'rest/items/item_specification';

  static const String ps_add_specification_url =
      'rest/items/add_spec/api_key/${PsConfig.ps_api_key}';

  static const String ps_delete_specification_url =
      'rest/items/delete_spec/api_key/${PsConfig.ps_api_key}';

  static const String ps_item_image_upload_url =
      'rest/images/upload_item/api_key/${PsConfig.ps_api_key}';

  static const String ps_item_image_delete_url =
      'rest/images/delete_image/api_key/${PsConfig.ps_api_key}';

  static const String ps_item_delete_url =
      'rest/items/item_delete/api_key/${PsConfig.ps_api_key}';

  static const String ps_couponDiscount_url =
      'rest/coupons/check/api_key/${PsConfig.ps_api_key}';

  static const String ps_item_entry_url =
      'rest/items/submit_items/api_key/${PsConfig.ps_api_key}';

  static const String ps_status_url = 'rest/items/item_status';

  static const String ps_token_url = 'rest/paypal/get_token';

  static const String ps_transaction_submit_url =
      'rest/transactionheaders/submit/api_key/${PsConfig.ps_api_key}';

  static const String ps_collection_item_url =
      'rest/items/all_collection_items';
}
