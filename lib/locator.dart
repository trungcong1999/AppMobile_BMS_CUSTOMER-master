import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:hosco/data/repositories/abstract/cart_repository.dart';
import 'package:hosco/data/repositories/abstract/config_repository.dart';
import 'package:hosco/data/repositories/abstract/category_repository.dart';
import 'package:hosco/data/repositories/abstract/favorites_repository.dart';
import 'package:hosco/data/repositories/abstract/payment_method_repository.dart';
import 'package:hosco/data/repositories/abstract/product_repository.dart';
import 'package:hosco/data/repositories/abstract/promo_repository.dart';
import 'package:hosco/data/repositories/abstract/shipping_address_repository.dart';
import 'package:hosco/data/repositories/abstract/user_repository.dart';
import 'package:hosco/data/repositories/abstract/order_repository.dart';
import 'package:hosco/data/network/network_status.dart';
import 'package:hosco/data/repositories/cart_repository_impl.dart';
import 'package:hosco/data/repositories/category_repository_impl.dart';
import 'package:hosco/data/repositories/order_repository_impl.dart';
import 'package:hosco/data/repositories/payment_method_repository_impl.dart';
import 'package:hosco/data/repositories/product_repository_impl.dart';
import 'package:hosco/data/repositories/promo_repository_impl.dart';
import 'package:hosco/data/repositories/shipping_address_repository_impl.dart';
import 'package:hosco/data/repositories/user_repository_impl.dart';
import 'package:hosco/data/repositories/config_repository_impl.dart';
import 'package:hosco/data/woocommerce/repositories/remote_user_repository.dart';
import 'package:hosco/data/woocommerce/repositories/woocommerce_wrapper.dart';
import 'package:hosco/domain/usecases/cart/add_product_to_cart_use_case.dart';
import 'package:hosco/domain/usecases/cart/change_cart_item_quantity_use_case.dart';
import 'package:hosco/domain/usecases/cart/get_cart_products_use_case.dart';
import 'package:hosco/domain/usecases/cart/remove_product_from_cart_use_case.dart';
import 'package:hosco/domain/usecases/categories/find_categories_by_filter_use_case.dart';
import 'package:hosco/domain/usecases/checkout/checkout_start_use_case.dart';
import 'package:hosco/domain/usecases/favorites/add_to_favorites_use_case.dart';
import 'package:hosco/domain/usecases/favorites/get_favorite_products_use_case.dart';
import 'package:hosco/domain/usecases/favorites/remove_from_favorites_use_case.dart';
import 'package:hosco/domain/usecases/products/find_products_by_filter_use_case.dart';
import 'package:hosco/domain/usecases/products/get_home_products_use_case.dart';
import 'package:hosco/domain/usecases/products/get_product_by_id_use_case.dart';
import 'package:hosco/domain/usecases/promos/get_promos_use_case.dart';

final sl = GetIt.instance;

//Service locator description
void init() {
  //Singleton for NetworkStatus identification
  sl.registerLazySingleton<NetworkStatus>(() => NetworkStatusImpl(DataConnectionChecker()));

  //get home page products use case
  sl.registerLazySingleton<GetHomePageProductsUseCase>(() => GetHomePageProductsUseCaseImpl());
  
  //checkout start use case
  sl.registerLazySingleton<CheckoutStartUseCase>(() => CheckoutStartUseCaseImpl());
  
  //get promo coupons
  sl.registerLazySingleton<GetPromosUseCase>(() => GetPromosUseCaseImpl());
  
  //remove from favorites
  sl.registerLazySingleton<RemoveFromFavoritesUseCase>(() => RemoveFromFavoritesUseCaseImpl());
  
  //get favorite product list
  sl.registerLazySingleton<GetFavoriteProductsUseCase>(() => GetFavoriteProductsUseCaseImpl());
  
  //change cart quantity use case 
  sl.registerLazySingleton<RemoveProductFromCartUseCase>(() => RemoveProductFromCartUseCaseImpl());
  
  //change cart quantity use case 
  sl.registerLazySingleton<ChangeCartItemQuantityUseCase>(() => ChangeCartItemQuantityUseCaseImpl());

  //get cart product use case  
  sl.registerLazySingleton<GetCartProductsUseCase>(() => GetCartProductsUseCaseImpl());

  //add to favorite use case 
  sl.registerLazySingleton<AddToFavoritesUseCase>(() => AddToFavoritesUseCaseImpl());

  //add to cart use case
  sl.registerLazySingleton<AddProductToCartUseCase>(() => AddProductToCartUseCaseImpl());

  //get categories list by filter use case
  sl.registerLazySingleton<FindCategoriesByFilterUseCase>(() => FindCategoriesByFilterUseCaseImpl());

  //get product list by filter use case
  sl.registerLazySingleton<FindProductsByFilterUseCase>(() => FindProductsByFilterUseCaseImpl());

  //get product details by id use case
  sl.registerLazySingleton<GetProductByIdUseCase>(() => GetProductByIdUseCaseImpl());

  //Singleton for HTTP request
  sl.registerLazySingleton(() => http.Client());

  sl.registerLazySingleton<WoocommercWrapperAbstract>(
    () => WoocommerceWrapper(client: sl()),
  );
  
  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(),
  );
  
  sl.registerLazySingleton<RemoteUserRepository>(
    () => RemoteUserRepository(),
  );

  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(remoteUserRepository: sl()),
  );

  sl.registerLazySingleton<ConfigRepository>(
        () => ConfigRepositoryImpl(),
  );

  sl.registerLazySingleton<OrderRepository>(
        () => OrderRepositoryImpl(),
  );
  
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(),
  );

  sl.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(),
  );

  sl.registerLazySingleton<FavoritesRepository>(
    () => ProductRepositoryImpl(),
  );

  sl.registerLazySingleton<PromoRepository>(
    () => PromoRepositoryImpl(),
  );

  sl.registerLazySingleton<ShippingAddressRepository>(
    () => ShippingAddressRepositoryImpl(ShippingAddressDataStorage([])),
  );

  sl.registerLazySingleton<PaymentMethodRepository>(
    () => PaymentMethodRepositoryImpl(PaymentMethodDataStorage([]))
  );  
}
