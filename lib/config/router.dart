import 'package:businesslistingapi/provider/city/city_list_view.dart';
import 'package:businesslistingapi/ui/app_loading/permission_rationale.dart';
import 'package:flutter/material.dart';
import 'package:businesslistingapi/constant/route_paths.dart';
import 'package:businesslistingapi/ui/app_info/app_info_view.dart';
import 'package:businesslistingapi/ui/app_loading/app_loading_view.dart';
import 'package:businesslistingapi/ui/blog/list/city_blog_list_container.dart';
import 'package:businesslistingapi/ui/category/filter_list/category_filter_list_view.dart';
import 'package:businesslistingapi/ui/category/list/category_sorting_list_view.dart';
import 'package:businesslistingapi/ui/city/container/city_grid_container_view.dart';
import 'package:businesslistingapi/ui/city_info/city_info_container_view.dart';
import 'package:businesslistingapi/ui/contact/contact_us_container_view.dart';
import 'package:businesslistingapi/ui/dashboard/core/dashboard_view.dart';
import 'package:businesslistingapi/ui/gallery/list/gallery_list_view.dart';
import 'package:businesslistingapi/ui/introslider/intro_slider_view.dart';
import 'package:businesslistingapi/ui/item_dashboard/core/item_dashboard_view.dart';
import 'package:businesslistingapi/ui/items/collection_item/item_list_by_collection_id_view.dart';
import 'package:businesslistingapi/ui/items/detail/description_detail/description_detail_view.dart';
import 'package:businesslistingapi/ui/items/detail/item_detail_view.dart';
import 'package:businesslistingapi/ui/items/entry/item_entry_container.dart';
import 'package:businesslistingapi/ui/items/entry/item_image_upload_view.dart';
import 'package:businesslistingapi/ui/items/favourite/favourite_product_list_container.dart';
import 'package:businesslistingapi/ui/items/item/user_item_list_view.dart';
import 'package:businesslistingapi/ui/items/item_upload/item_upload_container_view.dart';
import 'package:businesslistingapi/ui/items/list_with_filter/filter/category/filter_list_view.dart';
import 'package:businesslistingapi/ui/items/list_with_filter/filter/filter/item_search_view.dart';
import 'package:businesslistingapi/ui/items/list_with_filter/filter/sort/item_sorting_view.dart';
import 'package:businesslistingapi/ui/items/list_with_filter/item_list_with_filter_container.dart';
import 'package:businesslistingapi/ui/items/promote/CreditCardView.dart';
import 'package:businesslistingapi/ui/items/promote/InAppPurchaseView.dart';
import 'package:businesslistingapi/ui/items/promote/ItemPromoteView.dart';
import 'package:businesslistingapi/ui/items/promote/choose_payment_view.dart';
import 'package:businesslistingapi/ui/items/promote/pay_stack_request_view.dart';
import 'package:businesslistingapi/ui/items/promote/pay_stack_view.dart';
import 'package:businesslistingapi/ui/language/list/language_list_view.dart';
import 'package:businesslistingapi/ui/map/google_map_filter_view.dart';
import 'package:businesslistingapi/ui/map/google_map_pin_view.dart';
import 'package:businesslistingapi/ui/map/map_filter_view.dart';
import 'package:businesslistingapi/ui/map/map_pin_view.dart';
import 'package:businesslistingapi/ui/noti/detail/noti_view.dart';
import 'package:businesslistingapi/ui/noti/list/noti_list_view.dart';
import 'package:businesslistingapi/ui/paid_ad/paid_ad_item_list_container.dart';
import 'package:businesslistingapi/ui/privacy_policy/privacy_policy_container_view.dart';
import 'package:businesslistingapi/ui/setting/setting_privacy_policy_view.dart';
import 'package:businesslistingapi/ui/specification/add_specification/add_specification_view.dart';
import 'package:businesslistingapi/ui/specification/specification_list_view.dart';
import 'package:businesslistingapi/ui/status/status_list_view.dart';
import 'package:businesslistingapi/ui/subcategory/filter/sub_category_search_list_view.dart';
import 'package:businesslistingapi/ui/subcategory/list/sub_category_grid_view.dart';
import 'package:businesslistingapi/ui/user/edit_profile/edit_profile_view.dart';
import 'package:businesslistingapi/ui/user/forgot_password/forgot_password_container_view.dart';
import 'package:businesslistingapi/ui/user/login/login_container_view.dart';
import 'package:businesslistingapi/ui/user/more/more_container_view.dart';
import 'package:businesslistingapi/ui/user/password_update/change_password_view.dart';
import 'package:businesslistingapi/ui/user/verify/verify_email_container_view.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:businesslistingapi/viewobject/category.dart';
import 'package:businesslistingapi/viewobject/city.dart';
// import 'package:businesslistingapi/viewobject/city_info.dart';
import 'package:businesslistingapi/viewobject/holder/intent_holder/add_specification_intent_holder.dart';
import 'package:businesslistingapi/viewobject/holder/intent_holder/city_intent_holder.dart';
import 'package:businesslistingapi/viewobject/holder/intent_holder/collection_intent_holder.dart';
import 'package:businesslistingapi/viewobject/holder/intent_holder/comment_detail_holder.dart';
import 'package:businesslistingapi/viewobject/holder/intent_holder/grallery_list_intent_holder.dart';
import 'package:businesslistingapi/viewobject/holder/intent_holder/item_entry_image_intent_holder.dart';
import 'package:businesslistingapi/viewobject/holder/intent_holder/item_entry_intent_holder.dart';
import 'package:businesslistingapi/viewobject/holder/intent_holder/map_pin_intent_holder.dart';
import 'package:businesslistingapi/viewobject/holder/intent_holder/item_detail_intent_holder.dart';
import 'package:businesslistingapi/ui/blog/detail/blog_view.dart';
import 'package:businesslistingapi/ui/blog/list/blog_list_container.dart';
import 'package:businesslistingapi/ui/collection/header_list/collection_header_list_container.dart';
import 'package:businesslistingapi/ui/comment/detail/comment_detail_list_view.dart';
import 'package:businesslistingapi/ui/comment/list/comment_list_view.dart';
import 'package:businesslistingapi/ui/force_update/force_update_view.dart';
import 'package:businesslistingapi/ui/gallery/detail/gallery_view.dart';
import 'package:businesslistingapi/ui/gallery/grid/gallery_grid_view.dart';
import 'package:businesslistingapi/ui/history/list/history_list_container.dart';
import 'package:businesslistingapi/ui/noti/notification_setting/notification_setting_view.dart';
import 'package:businesslistingapi/ui/rating/list/rating_list_view.dart';
import 'package:businesslistingapi/ui/setting/setting_container_view.dart';
import 'package:businesslistingapi/ui/user/phone/sign_in/phone_sign_in_container_view.dart';
import 'package:businesslistingapi/ui/user/phone/verify_phone/verify_phone_container_view.dart';
import 'package:businesslistingapi/ui/user/profile/profile_container_view.dart';
import 'package:businesslistingapi/ui/user/register/register_container_view.dart';
import 'package:businesslistingapi/viewobject/blog.dart';
import 'package:businesslistingapi/viewobject/default_photo.dart';
import 'package:businesslistingapi/viewobject/holder/intent_holder/item_list_intent_holder.dart';
import 'package:businesslistingapi/viewobject/holder/intent_holder/paystack_request_intent_holder.dart';
import 'package:businesslistingapi/viewobject/holder/intent_holder/sub_category_intent_holder.dart';
import 'package:businesslistingapi/viewobject/holder/intent_holder/terms_and_condition_intent_holder.dart';
import 'package:businesslistingapi/viewobject/holder/intent_holder/user_item_intent_holder.dart';
import 'package:businesslistingapi/viewobject/holder/intent_holder/verify_phone_internt_holder.dart';
import 'package:businesslistingapi/viewobject/holder/item_parameter_holder.dart';
import 'package:businesslistingapi/viewobject/holder/paid_history_holder.dart';
import 'package:businesslistingapi/viewobject/holder/paystack_intent_holder.dart';
import 'package:businesslistingapi/viewobject/noti.dart';
import 'package:businesslistingapi/viewobject/item.dart';
import 'package:businesslistingapi/viewobject/ps_app_info.dart';
import 'package:businesslistingapi/viewobject/ps_app_version.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              AppLoadingView());

    case '${RoutePaths.home}':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              DashboardView());
    case '${RoutePaths.permissionRationale}':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              PermissionRationale());

    case '${RoutePaths.itemHome}':
      final Object args = settings.arguments;
      final City city = args ?? City;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              ItemDashboardView(city: city));
    case '${RoutePaths.appinfo}':
      return MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => AppInfoView());

    case '${RoutePaths.force_update}':
      final Object args = settings.arguments;
      final PSAppVersion psAppVersion = args ?? PSAppVersion;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              ForceUpdateView(psAppVersion: psAppVersion));

    case '${RoutePaths.user_register_container}':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              RegisterContainerView());
    case '${RoutePaths.login_container}':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              LoginContainerView());

    case '${RoutePaths.user_verify_email_container}':
      final Object args = settings.arguments;
      final String userId = args ?? String;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              VerifyEmailContainerView(userId: userId));

    case '${RoutePaths.user_forgot_password_container}':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              ForgotPasswordContainerView());

    case '${RoutePaths.user_phone_signin_container}':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              PhoneSignInContainerView());

    case '${RoutePaths.user_phone_verify_container}':
      final Object args = settings.arguments;

      final VerifyPhoneIntentHolder verifyPhoneIntentParameterHolder =
          args ?? VerifyPhoneIntentHolder;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              VerifyPhoneContainerView(
                userName: verifyPhoneIntentParameterHolder.userName,
                phoneNumber: verifyPhoneIntentParameterHolder.phoneNumber,
                phoneId: verifyPhoneIntentParameterHolder.phoneId,
              ));

    case '${RoutePaths.user_update_password}':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              ChangePasswordView());

    case '${RoutePaths.profile_container}':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              ProfileContainerView());

    case '${RoutePaths.languageList}':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              LanguageListView());

    case '${RoutePaths.introSlider}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        final Object args = settings.arguments;
        final int settingSlider = args ?? int;
        return IntroSliderView(settingSlider:settingSlider);
      });

    case '${RoutePaths.categoryList}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        return CategorySortingListView();
      });  

    // case '${RoutePaths.categoryList}':
    //   final Object args = settings.arguments;
    //   final CategoryContainerIntentHolder categoryContainerIntentHolder =
    //       args ?? CategoryContainerIntentHolder;
    //   return PageRouteBuilder<dynamic>(
    //       pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
    //           CategoryListViewContainerView(
    //             appBarTitle: categoryContainerIntentHolder.appBarTitle,
    //             city: categoryContainerIntentHolder.city,
    //           ));

    case '${RoutePaths.citySearch}':
      final Object args = settings.arguments;
      final CityIntentHolder cityIntentHolder = args ?? CityIntentHolder;

      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              CityGridContainerView(
                appBarTitle: cityIntentHolder.appBarTitle,
                cityParameterHolder: cityIntentHolder.cityParameterHolder,
              ));

    case '${RoutePaths.notiList}':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              const NotiListView());
    case '${RoutePaths.creditCard}':
      final Object args = settings.arguments;

      final PaidHistoryHolder paidHistoryHolder = args ?? PaidHistoryHolder;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              CreditCardView(
                item: paidHistoryHolder.item,
                amount: paidHistoryHolder.amount,
                howManyDay: paidHistoryHolder.howManyDay,
                paymentMethod: paidHistoryHolder.paymentMethod,
                stripePublishableKey: paidHistoryHolder.stripePublishableKey,
                startDate: paidHistoryHolder.startDate,
                startTimeStamp: paidHistoryHolder.startTimeStamp,
                itemPaidHistoryProvider:
                    paidHistoryHolder.itemPaidHistoryProvider,
              ));
    case '${RoutePaths.payStackPayment}':
      final Object args = settings.arguments;

      final PayStackInterntHolder payStackInterntHolder =
          args ?? PayStackInterntHolder;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              PayStackView(
                item: payStackInterntHolder.item,
                amount: payStackInterntHolder.amount,
                howManyDay: payStackInterntHolder.howManyDay,
                paymentMethod: payStackInterntHolder.paymentMethod,
                stripePublishableKey:
                    payStackInterntHolder.stripePublishableKey,
                startDate: payStackInterntHolder.startDate,
                startTimeStamp: payStackInterntHolder.startTimeStamp,
                itemPaidHistoryProvider:
                    payStackInterntHolder.itemPaidHistoryProvider,
                userProvider: payStackInterntHolder.userProvider,
                payStackKey: payStackInterntHolder.payStackKey,
                userEmail: payStackInterntHolder.userEmail,
              ));

    case '${RoutePaths.payStackRequestPayment}':
      final Object args = settings.arguments;

      final PayStackRequestInterntHolder payStackRequestInterntHolder =
          args ?? PayStackRequestInterntHolder;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              PayStackRequestView(
                item: payStackRequestInterntHolder.item,
                amount: payStackRequestInterntHolder.amount,
                howManyDay: payStackRequestInterntHolder.howManyDay,
                paymentMethod: payStackRequestInterntHolder.paymentMethod,
                startDate: payStackRequestInterntHolder.startDate,
                startTimeStamp: payStackRequestInterntHolder.startTimeStamp,
                itemPaidHistoryProvider:
                    payStackRequestInterntHolder.itemPaidHistoryProvider,
                payStackKey: payStackRequestInterntHolder.payStackKey,
                firstName: payStackRequestInterntHolder.firstName,
                lastName: payStackRequestInterntHolder.lastName,
                userEmail: payStackRequestInterntHolder.userEmail,
              ));

    case '${RoutePaths.notiSetting}':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              NotificationSettingView());
    case '${RoutePaths.setting}':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              SettingContainerView());
    case '${RoutePaths.uploaded}':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              UploadedItemContainerView());
    case '${RoutePaths.more}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        final Object args = settings.arguments;
        final String userName = args ?? String;
        return MoreContainerView(userName: userName);
      });
    case '${RoutePaths.subCategoryList}':
      final Object args = settings.arguments;
      final Category category = args ?? Category;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              SubCategoryGridView(category: category));

    case '${RoutePaths.noti}':
      final Object args = settings.arguments;
      final Noti noti = args ?? Noti;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              NotiView(noti: noti));

    case '${RoutePaths.filterItemList}':
      final Object args = settings.arguments;
      final ItemListIntentHolder itemListIntentHolder =
          args ?? ItemListIntentHolder;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              ItemListWithFilterContainerView(
                checkPage: itemListIntentHolder.checkPage,
                appBarTitle: itemListIntentHolder.appBarTitle,
                itemParameterHolder: itemListIntentHolder.itemParameterHolder,
              ));

    case '${RoutePaths.itemEntry}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        final Object args = settings.arguments;
        final ItemEntryIntentHolder itemEntryIntentHolder =
            args ?? ItemEntryIntentHolder;
        return ItemEntryContainerView(
          flag: itemEntryIntentHolder.flag,
          item: itemEntryIntentHolder.item,
        );
      });

    case '${RoutePaths.imageUpload}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        final Object args = settings.arguments;
        final ItemEntryImageIntentHolder itemEntryImageIntentHolder =
            args ?? ItemEntryImageIntentHolder;
        return ItemImageUploadView(
          flag: itemEntryImageIntentHolder.flag,
          itemId: itemEntryImageIntentHolder.itemId,
          isPromotion: itemEntryImageIntentHolder.isPromotion,
          image: itemEntryImageIntentHolder.image,
          item: itemEntryImageIntentHolder.item,
          galleryProvider: itemEntryImageIntentHolder.provider,
        );
      });

    case '${RoutePaths.specificationList}':
      final Object args = settings.arguments;
      final String itemId = args ?? String;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              SpecificationListView(
                itemId: itemId,
              ));

    case '${RoutePaths.addSpecification}':
      final Object args = settings.arguments;
      final SpecificationIntentHolder specificationIntentHolder =
          args ?? SpecificationIntentHolder;

      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              AddSpecificationView(
                itemId: specificationIntentHolder.itemId,
                specificationProvider:
                    specificationIntentHolder.specificationProvider,
                name: specificationIntentHolder.name,
                description: specificationIntentHolder.description,
              ));

    case '${RoutePaths.privacyPolicy}':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              PrivacyPolicyContainerView());

    case '${RoutePaths.termsAndCondition}':
      final Object args = settings.arguments;
      final TermsAndConditionIntentHolder termsAndConditionIntentHolder =
          args ?? TermsAndConditionIntentHolder;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              SettingPrivacyPolicyView(
                checkType: termsAndConditionIntentHolder.checkType,
                description: termsAndConditionIntentHolder.description,
              ));

    case '${RoutePaths.itemPromote}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        final Object args = settings.arguments;
        final Item item = args ?? Item;
        return ItemPromoteView(item: item);
      });

    case '${RoutePaths.blogList}':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              BlogListContainerView());

    case '${RoutePaths.cityBlogList}':
      final Object args = settings.arguments;
      final String cityId = args ?? String;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              CityBlogListContainerView(cityId: cityId));

    case '${RoutePaths.blogDetail}':
      final Object args = settings.arguments;
      final Blog blog = args ?? Blog;
      return MaterialPageRoute<Widget>(builder: (BuildContext context) {
        return BlogView(
          blog: blog,
          heroTagImage: blog.id,
        );
      });

    case '${RoutePaths.paidAdItemList}':
      return MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => PaidItemListContainerView());

    case '${RoutePaths.userItemList}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        final Object args = settings.arguments;
        final UserItemIntentHolder itemEntryIntentHolder =
            args ?? UserItemIntentHolder;

        return UserItemListView(
          addedUserId: itemEntryIntentHolder.userId,
          status: itemEntryIntentHolder.status,
          title: itemEntryIntentHolder.title,
        );
      });

    case '${RoutePaths.cityInfoContainerView}':
      final Object args = settings.arguments;
      final City cityInfo = args ?? City;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              CityInfoContainerView(cityInfo: cityInfo));

    case '${RoutePaths.historyList}':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              HistoryListContainerView());

    case '${RoutePaths.descriptionDetail}':
      final Object args = settings.arguments;
      final Item itemData = args ?? Item;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              DescriptionDetailView(itemData: itemData));
    case '${RoutePaths.itemDetail}':
      final Object args = settings.arguments;
      final ItemDetailIntentHolder holder = args ?? ItemDetailIntentHolder;
      return MaterialPageRoute<Widget>(builder: (BuildContext context) {
        return ItemDetailView(
          itemId: holder.itemId,
          heroTagImage: holder.heroTagImage,
          heroTagTitle: holder.heroTagTitle,
          heroTagOriginalPrice: holder.heroTagOriginalPrice,
          heroTagUnitPrice: holder.heroTagUnitPrice,
          intentId: holder.id,
          intentQty: holder.qty,
          intentSelectedColorId: holder.selectedColorId,
          intentSelectedColorValue: holder.selectedColorValue,
          intentBasketPrice: holder.basketPrice,
          intentBasketSelectedAttributeList: holder.basketSelectedAttributeList,
        );
      });

        case '${RoutePaths.contactUs}':
      return MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => ContactUsContainerView());

    case '${RoutePaths.filterExpantion}':
      final dynamic args = settings.arguments;

      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              FilterListView(selectedData: args));

    case '${RoutePaths.commentList}':
      final Object args = settings.arguments;
      final Item item = args ?? Item;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              CommentListView(item: item));

    case '${RoutePaths.itemSearch}':
      final Object args = settings.arguments;
      final ItemParameterHolder itemParameterHolder =
          args ?? ItemParameterHolder;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              ItemSearchView(itemParameterHolder: itemParameterHolder));

    case '${RoutePaths.mapFilter}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        final Object args = settings.arguments;
        final ItemParameterHolder itemParameterHolder =
            args ?? ItemParameterHolder;
        return MapFilterView(itemParameterHolder: itemParameterHolder);
      });

    case '${RoutePaths.googleMapFilter}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        final Object args = settings.arguments;
        final ItemParameterHolder itemParameterHolder =
            args ?? ItemParameterHolder;
        return GoogleMapFilterView(
            itemParameterHolder: itemParameterHolder);
      }); 

    case '${RoutePaths.mapPin}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        final Object args = settings.arguments;
        final MapPinIntentHolder mapPinIntentHolder =
            args ?? MapPinIntentHolder;
        return MapPinView(
          flag: mapPinIntentHolder.flag,
          maplat: mapPinIntentHolder.mapLat,
          maplng: mapPinIntentHolder.mapLng,
        );
      });

    case '${RoutePaths.googleMapPin}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        final Object args = settings.arguments;
        final MapPinIntentHolder mapPinIntentHolder =
            args ?? MapPinIntentHolder;
        return GoogleMapPinView(
          flag: mapPinIntentHolder.flag,
          maplat: mapPinIntentHolder.mapLat,
          maplng: mapPinIntentHolder.mapLng,
          city: mapPinIntentHolder.city,
          item: mapPinIntentHolder.item,
        );
      });

    case '${RoutePaths.googleMapPin2}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        final Object args = settings.arguments;
        final MapPinIntentHolder mapPinIntentHolder =
            args ?? MapPinIntentHolder;
        return GoogleMapPinView(
          flag: mapPinIntentHolder.flag,
          maplat: mapPinIntentHolder.mapLat,
          maplng: mapPinIntentHolder.mapLng,
          city: mapPinIntentHolder.city,
        );
      }); 

    case '${RoutePaths.itemSort}':
      final Object args = settings.arguments;
      final ItemParameterHolder itemParameterHolder =
          args ?? ItemParameterHolder;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              ItemSortingView(itemParameterHolder: itemParameterHolder));

    case '${RoutePaths.commentDetail}':
      final Object args = settings.arguments;
      final CommentDetailHolder commentDetailHolder =
          args ?? CommentDetailHolder;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              CommentDetailListView(
                commentHeader: commentDetailHolder.commentHeader,
                cityId: commentDetailHolder.cityId,
              ));

    case '${RoutePaths.favouriteItemList}':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              FavouriteItemListContainerView());

    case '${RoutePaths.collectionProductList}':
      final Object args = settings.arguments;
      final String cityId = args ?? String;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              CollectionHeaderListContainerView(cityId: cityId));

    case '${RoutePaths.itemListByCollectionId}':
      final Object args = settings.arguments;
      final CollectionIntentHolder collectionIntentHolder =
          args ?? CollectionIntentHolder;

      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              ItemListByCollectionIdView(
                itemCollectionHeader:
                    collectionIntentHolder.itemCollectionHeader,
                appBarTitle: collectionIntentHolder.appBarTitle,
              ));

    case '${RoutePaths.ratingList}':
      final Object args = settings.arguments;
      final String itemDetailId = args ?? String;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              RatingListView(itemDetailid: itemDetailId));

    case '${RoutePaths.editProfile}':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              EditProfileView());

    case '${RoutePaths.galleryGrid}':
      final Object args = settings.arguments;
      final Item product = args ?? Item;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              GalleryGridView(product: product));

    case '${RoutePaths.galleryList}':
      final Object args = settings.arguments;
      final GalleryListIntentHolder galleryListIntentHolder =
          args ?? GalleryListIntentHolder;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              GalleryListView(
                itemId: galleryListIntentHolder.itemId,
                galleryProvider: galleryListIntentHolder.galleryProvider,
              ));

    case '${RoutePaths.choosePayment}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        final Map<String, dynamic> args = settings.arguments;
        final Item item = args['item'];
        final PSAppInfo appInfo = args['appInfo'];
        Utils.psPrint(appInfo.inAppPurchasedPrdIdAndroid);
        // final Product product = args ?? Product;
        return ChoosePaymentVIew(item: item, appInfo: appInfo);
      });

    case '${RoutePaths.inAppPurchase}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        final Map<String, dynamic> args = settings.arguments;
        // final String itemId = args ?? String;
        final String itemId = args['itemId'];
        final PSAppInfo appInfo = args['appInfo'];

        return InAppPurchaseView(itemId, appInfo);
      });

    case '${RoutePaths.galleryDetail}':
      final Object args = settings.arguments;
      final DefaultPhoto selectedDefaultImage = args ?? DefaultPhoto;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              GalleryView(selectedDefaultImage: selectedDefaultImage));

    case '${RoutePaths.searchCategory}':
      final Object args = settings.arguments;
      final String categoryName = args ?? String;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              CategoryFilterListView(categoryName: categoryName));
    case '${RoutePaths.searchSubCategory}':
      final Object args = settings.arguments;
      final SubCategoryIntentHolder subCategoryIntentHolder =
          args ?? SubCategoryIntentHolder;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              SubCategorySearchListView(
                categoryId: subCategoryIntentHolder.categoryId,
                subCategoryName: subCategoryIntentHolder.subCategoryName,
              ));
    case '${RoutePaths.statusList}':
      final Object args = settings.arguments;
      final String statusName = args ?? String;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              StatusListView(statusName: statusName));
    case '${RoutePaths.cityList}':
      final Object args = settings.arguments;
      final String statusName = args ?? String;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              CityListView(statusName: statusName));

    default:
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              AppLoadingView());
  }
}
