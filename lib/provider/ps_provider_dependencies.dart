  import 'package:businesslistingapi/db/about_app_dao.dart';
import 'package:businesslistingapi/db/city_blog_dao.dart';
import 'package:businesslistingapi/db/city_dao.dart';
import 'package:businesslistingapi/db/city_info_dao.dart';
import 'package:businesslistingapi/db/city_map_dao.dart';
import 'package:businesslistingapi/db/paid_ad_item_dao.dart';
import 'package:businesslistingapi/db/specification_dao.dart';
import 'package:businesslistingapi/db/status_dao.dart';
import 'package:businesslistingapi/repository/about_app_repository.dart';
import 'package:businesslistingapi/repository/city_blog_repository.dart';
import 'package:businesslistingapi/repository/city_repository.dart';
import 'package:businesslistingapi/repository/delete_task_repository.dart';
import 'package:businesslistingapi/repository/item_paid_history_repository.dart';
import 'package:businesslistingapi/repository/paid_ad_item_repository.dart';
import 'package:businesslistingapi/db/category_map_dao.dart';
import 'package:businesslistingapi/db/comment_detail_dao.dart';
import 'package:businesslistingapi/db/comment_header_dao.dart';
import 'package:businesslistingapi/db/favourite_item_dao.dart';
import 'package:businesslistingapi/db/gallery_dao.dart';
import 'package:businesslistingapi/db/history_dao.dart';
import 'package:businesslistingapi/db/item_collection_header_dao.dart';
import 'package:businesslistingapi/db/rating_dao.dart';
import 'package:businesslistingapi/db/user_dao.dart';
import 'package:businesslistingapi/db/related_item_dao.dart';
import 'package:businesslistingapi/db/user_login_dao.dart';
import 'package:businesslistingapi/repository/Common/notification_repository.dart';
import 'package:businesslistingapi/repository/clear_all_data_repository.dart';
import 'package:businesslistingapi/repository/comment_detail_repository.dart';
import 'package:businesslistingapi/repository/comment_header_repository.dart';
import 'package:businesslistingapi/repository/coupon_discount_repository.dart';
import 'package:businesslistingapi/repository/gallery_repository.dart';
import 'package:businesslistingapi/repository/history_repsitory.dart';
import 'package:businesslistingapi/repository/item_collection_repository.dart';
import 'package:businesslistingapi/db/blog_dao.dart';
import 'package:businesslistingapi/repository/blog_repository.dart';
import 'package:businesslistingapi/repository/rating_repository.dart';
import 'package:businesslistingapi/repository/city_info_repository.dart';
import 'package:businesslistingapi/repository/specification_repository.dart';
import 'package:businesslistingapi/repository/status_repository.dart';
import 'package:businesslistingapi/repository/token_repository.dart';
import 'package:businesslistingapi/repository/user_repository.dart';
import 'package:businesslistingapi/viewobject/common/ps_value_holder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:businesslistingapi/api/ps_api_service.dart';
import 'package:businesslistingapi/db/cateogry_dao.dart';
import 'package:businesslistingapi/db/common/ps_shared_preferences.dart';
import 'package:businesslistingapi/db/noti_dao.dart';
import 'package:businesslistingapi/db/sub_category_dao.dart';
import 'package:businesslistingapi/db/item_dao.dart';
import 'package:businesslistingapi/db/item_map_dao.dart';
import 'package:businesslistingapi/repository/app_info_repository.dart';
import 'package:businesslistingapi/repository/category_repository.dart';
import 'package:businesslistingapi/repository/language_repository.dart';
import 'package:businesslistingapi/repository/contact_us_repository.dart';
import 'package:businesslistingapi/repository/noti_repository.dart';
import 'package:businesslistingapi/repository/item_repository.dart';
import 'package:businesslistingapi/repository/ps_theme_repository.dart';
import 'package:businesslistingapi/repository/sub_category_repository.dart';
import 'package:provider/single_child_widget.dart';

import 'entry/item_entry_provider.dart';

List<SingleChildWidget> providers = <SingleChildWidget>[
  ...independentProviders,
  ..._dependentProviders,
  ..._valueProviders,
];

List<SingleChildWidget> independentProviders = <SingleChildWidget>[
  Provider<PsSharedPreferences>.value(value: PsSharedPreferences.instance),
  Provider<PsApiService>.value(value: PsApiService()),
  Provider<StatusDao>.value(value: StatusDao.instance),
  Provider<CategoryDao>.value(value: CategoryDao()),
  Provider<CategoryMapDao>.value(value: CategoryMapDao.instance),
  Provider<SubCategoryDao>.value(
      value: SubCategoryDao()), //wrong type not contain instance
  Provider<ItemDao>.value(value: ItemDao.instance), //correct type with instance
  Provider<ItemMapDao>.value(value: ItemMapDao.instance),
  Provider<CityDao>.value(value: CityDao.instance), //correct type with instance
  Provider<CityMapDao>.value(value: CityMapDao.instance),
  Provider<NotiDao>.value(value: NotiDao.instance),
  Provider<ItemCollectionHeaderDao>.value(
      value: ItemCollectionHeaderDao.instance),
  Provider<CityInfoDao>.value(value: CityInfoDao.instance),
  Provider<BlogDao>.value(value: BlogDao.instance),
  Provider<CityBlogDao>.value(value: CityBlogDao.instance),
  Provider<UserDao>.value(value: UserDao.instance),
  Provider<UserLoginDao>.value(value: UserLoginDao.instance),
  Provider<RelatedItemDao>.value(value: RelatedItemDao.instance),
  Provider<CommentHeaderDao>.value(value: CommentHeaderDao.instance),
  Provider<CommentDetailDao>.value(value: CommentDetailDao.instance),
  Provider<RatingDao>.value(value: RatingDao.instance),
  Provider<PaidAdItemDao>.value(value: PaidAdItemDao.instance),
  Provider<HistoryDao>.value(value: HistoryDao.instance),
  Provider<GalleryDao>.value(value: GalleryDao.instance),
  Provider<AboutAppDao>.value(value: AboutAppDao.instance),
  Provider<SpecificationDao>.value(value: SpecificationDao.instance),
  Provider<FavouriteItemDao>.value(value: FavouriteItemDao.instance),

];

List<SingleChildWidget> _dependentProviders = <SingleChildWidget>[
  ProxyProvider<PsSharedPreferences, PsThemeRepository>(
    update: (_, PsSharedPreferences ssSharedPreferences,
            PsThemeRepository psThemeRepository) =>
        PsThemeRepository(psSharedPreferences: ssSharedPreferences),
  ),
  ProxyProvider<PsApiService, AppInfoRepository>(
    update:
        (_, PsApiService psApiService, AppInfoRepository appInfoRepository) =>
            AppInfoRepository(psApiService: psApiService),
  ),
  ProxyProvider<PsSharedPreferences, LanguageRepository>(
    update: (_, PsSharedPreferences ssSharedPreferences,
            LanguageRepository languageRepository) =>
        LanguageRepository(psSharedPreferences: ssSharedPreferences),
  ),
   ProxyProvider<PsApiService, ContactUsRepository>(
    update: (_, PsApiService psApiService,
            ContactUsRepository apiStatusRepository) =>
        ContactUsRepository(psApiService: psApiService),
  ),
  ProxyProvider2<PsApiService, CategoryDao, CategoryRepository>(
    update: (_, PsApiService psApiService, CategoryDao categoryDao,
            CategoryRepository categoryRepository2) =>
        CategoryRepository(
            psApiService: psApiService, categoryDao: categoryDao),
  ),
  ProxyProvider2<PsApiService, SubCategoryDao, SubCategoryRepository>(
    update: (_, PsApiService psApiService, SubCategoryDao subCategoryDao,
            SubCategoryRepository subCategoryRepository) =>
        SubCategoryRepository(
            psApiService: psApiService, subCategoryDao: subCategoryDao),
  ),
  ProxyProvider2<PsApiService, AboutAppDao, AboutAppRepository>(
    update: (_, PsApiService psApiService, AboutAppDao aboutUsDao,
            AboutAppRepository aboutUsRepository) =>
        AboutAppRepository(psApiService: psApiService, aboutUsDao: aboutUsDao),
  ),
  ProxyProvider2<PsApiService, StatusDao, StatusRepository>(
    update: (_, PsApiService psApiService, StatusDao statusDao,
            StatusRepository statusRepository2) =>
        StatusRepository(psApiService: psApiService, statusDao: statusDao),
  ),
  ProxyProvider2<PsApiService, ItemCollectionHeaderDao,
      ItemCollectionRepository>(
    update: (_,
            PsApiService psApiService,
            ItemCollectionHeaderDao itemCollectionHeaderDao,
            ItemCollectionRepository itemCollectionRepository) =>
        ItemCollectionRepository(
            psApiService: psApiService,
            itemCollectionHeaderDao: itemCollectionHeaderDao),
  ),
  ProxyProvider2<PsApiService, ItemDao, ItemRepository>(
    update: (_, PsApiService psApiService, ItemDao itemDao,
            ItemRepository categoryRepository2) =>
        ItemRepository(psApiService: psApiService, itemDao: itemDao),
  ),
  ProxyProvider2<PsApiService, CityDao, CityRepository>(
    update: (_, PsApiService psApiService, CityDao cityDao,
            CityRepository cityRepository) =>
        CityRepository(psApiService: psApiService, cityDao: cityDao),
  ),
  ProxyProvider2<PsApiService, NotiDao, NotiRepository>(
    update: (_, PsApiService psApiService, NotiDao notiDao,
            NotiRepository notiRepository) =>
        NotiRepository(psApiService: psApiService, notiDao: notiDao),
  ),
  ProxyProvider2<PsApiService, CityInfoDao, CityInfoRepository>(
    update: (_, PsApiService psApiService, CityInfoDao cityInfoDao,
            CityInfoRepository cityInfoRepository) =>
        CityInfoRepository(
            psApiService: psApiService, cityInfoDao: cityInfoDao),
  ),
  ProxyProvider<PsApiService, NotificationRepository>(
    update:
        (_, PsApiService psApiService, NotificationRepository userRepository) =>
            NotificationRepository(
      psApiService: psApiService,
    ),
  ),
  ProxyProvider3<PsApiService, UserDao, UserLoginDao, UserRepository>(
    update: (_, PsApiService psApiService, UserDao userDao,
            UserLoginDao userLoginDao, UserRepository userRepository) =>
        UserRepository(
            psApiService: psApiService,
            userDao: userDao,
            userLoginDao: userLoginDao),
  ),
  ProxyProvider<PsApiService, ItemPaidHistoryRepository>(
    update: (_, PsApiService psApiService,
            ItemPaidHistoryRepository itemPaidHistoryRepository) =>
        ItemPaidHistoryRepository(psApiService: psApiService),
  ),
  ProxyProvider<PsApiService, ClearAllDataRepository>(
    update: (_, PsApiService psApiService,
            ClearAllDataRepository clearAllDataRepository) =>
        ClearAllDataRepository(),
  ),
  ProxyProvider<PsApiService, DeleteTaskRepository>(
    update: (_, PsApiService psApiService,
            DeleteTaskRepository deleteTaskRepository) =>
        DeleteTaskRepository(),
  ),
  ProxyProvider2<PsApiService, BlogDao, BlogRepository>(
    update: (_, PsApiService psApiService, BlogDao blogDao,
            BlogRepository blogRepository) =>
        BlogRepository(psApiService: psApiService, blogDao: blogDao),
  ),
  ProxyProvider2<PsApiService, CityBlogDao, CityBlogRepository>(
    update: (_, PsApiService psApiService, CityBlogDao cityBlogDao,
            CityBlogRepository cityBlogRepository) =>
        CityBlogRepository(
            psApiService: psApiService, cityBlogDao: cityBlogDao),
  ),
  ProxyProvider2<PsApiService, CommentHeaderDao, CommentHeaderRepository>(
    update: (_, PsApiService psApiService, CommentHeaderDao commentHeaderDao,
            CommentHeaderRepository commentHeaderRepository) =>
        CommentHeaderRepository(
            psApiService: psApiService, commentHeaderDao: commentHeaderDao),
  ),
  ProxyProvider2<PsApiService, CommentDetailDao, CommentDetailRepository>(
    update: (_, PsApiService psApiService, CommentDetailDao commentDetailDao,
            CommentDetailRepository commentHeaderRepository) =>
        CommentDetailRepository(
            psApiService: psApiService, commentDetailDao: commentDetailDao),
  ),
  ProxyProvider2<PsApiService, RatingDao, RatingRepository>(
    update: (_, PsApiService psApiService, RatingDao ratingDao,
            RatingRepository ratingRepository) =>
        RatingRepository(psApiService: psApiService, ratingDao: ratingDao),
  ),
  ProxyProvider2<PsApiService, PaidAdItemDao, PaidAdItemRepository>(
    update: (_, PsApiService psApiService, PaidAdItemDao paidAdItemDao,
            PaidAdItemRepository paidAdItemRepository) =>
        PaidAdItemRepository(
            psApiService: psApiService, paidAdItemDao: paidAdItemDao),
  ),
  ProxyProvider2<PsApiService, HistoryDao, HistoryRepository>(
    update: (_, PsApiService psApiService, HistoryDao historyDao,
            HistoryRepository historyRepository) =>
        HistoryRepository(historyDao: historyDao),
  ),
  ProxyProvider2<PsApiService, GalleryDao, GalleryRepository>(
    update: (_, PsApiService psApiService, GalleryDao galleryDao,
            GalleryRepository galleryRepository) =>
        GalleryRepository(galleryDao: galleryDao, psApiService: psApiService),
  ),
  ProxyProvider2<PsApiService, SpecificationDao, SpecificationRepository>(
    update: (_, PsApiService psApiService, SpecificationDao specificationDao,
            SpecificationRepository specificationRepository) =>
        SpecificationRepository(
            specificationDao: specificationDao, psApiService: psApiService),
  ),
  ProxyProvider<PsApiService, CouponDiscountRepository>(
    update: (_, PsApiService psApiService,
            CouponDiscountRepository couponDiscountRepository) =>
        CouponDiscountRepository(psApiService: psApiService),
  ),
  ProxyProvider<PsApiService, TokenRepository>(
    update: (_, PsApiService psApiService, TokenRepository tokenRepository) =>
        TokenRepository(psApiService: psApiService),
  ),
];

List<SingleChildWidget> _valueProviders = <SingleChildWidget>[
  StreamProvider<PsValueHolder>(
    initialData: null,
    create: (BuildContext context) =>
        Provider.of<PsSharedPreferences>(context, listen: false).psValueHolder,
  )
];
