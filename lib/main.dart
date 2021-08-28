

import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hosco/config/routes.dart';
import 'package:hosco/config/storage.dart';
import 'package:hosco/config/theme.dart';
import 'package:hosco/data/repositories/abstract/config_repository.dart';
import 'package:hosco/data/repositories/abstract/favorites_repository.dart';
import 'package:hosco/data/model/filter_rules.dart';
import 'package:hosco/data/repositories/abstract/product_repository.dart';
import 'package:hosco/data/repositories/abstract/user_repository.dart';
import 'package:hosco/locator.dart';
import 'package:hosco/presentation/features/forget_password/forget_password_screen.dart';
import 'package:hosco/presentation/features/sign_in/sign_in.dart';
import 'package:hosco/presentation/features/filters/filters_screen.dart';
import 'package:hosco/presentation/features/product_details/product_screen.dart';
import 'package:hosco/presentation/features/products/products.dart';
import 'package:hosco/presentation/features/sign_in/signin_screen.dart';
import 'package:hosco/presentation/features/sign_up/signup_screen.dart';
import 'package:hosco/presentation/features/splash_screen.dart';
import 'package:unicorndial/unicorndial.dart';
import 'package:url_launcher/url_launcher.dart';

import 'config/routes.dart';
import 'data/repositories/abstract/cart_repository.dart';
import 'data/repositories/abstract/category_repository.dart';
import 'presentation/features/authentication/authentication.dart';
import 'presentation/features/forget_password/forget_password.dart';
import 'presentation/features/sign_up/sign_up_bloc.dart';
import 'presentation/features/cart/cart.dart';
import 'presentation/features/categories/categories.dart';
import 'presentation/features/checkout/checkout.dart';
import 'presentation/features/favorites/favorites.dart';
import 'presentation/features/home/home.dart';
import 'presentation/features/profile/profile.dart';

import 'locator.dart' as service_locator;

class SimpleBlocDelegate extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
  }

  @override
  void onError(Cubit bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print(error);
  }
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    'This channel is used for important notifications',
    importance: Importance.high,
    playSound: true);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> _firebaseMessagingBackgroundandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Message: ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  await service_locator.init();
  var delegate = await LocalizationDelegate.create(
    fallbackLocale: 'en_US',
    supportedLocales: ['en_US', 'vi'],
  );

  
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  Bloc.observer = SimpleBlocDelegate();
  runApp(
    BlocProvider<AuthenticationBloc>(
      create: (context) => AuthenticationBloc()..add(AppStarted()),
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<CategoryRepository>(
            create: (context) => sl(),
          ),
          RepositoryProvider<ProductRepository>(
            create: (context) => sl(),
          ),
          RepositoryProvider<FavoritesRepository>(
            create: (context) => sl(),
          ),
          RepositoryProvider<UserRepository>(
            create: (context) => sl(),
          ),
          RepositoryProvider<CartRepository>(
            create: (context) => sl(),
          ),
          RepositoryProvider<ConfigRepository>(
            create: (context) => sl(),
          )
        ],
        child: LocalizedApp(
          delegate,
          hoscoApp(),
        ),
      ),
    ),
  );
}

class hoscoApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    var childButtons = List<UnicornButton>();
//Icon(Icons.directions_car))));

    return LocalizationProvider(
        state: LocalizationProvider.of(context).state,
        child: MaterialApp(
          home: Scaffold(
            // floatingActionButton: Padding(
            //   padding: const EdgeInsets.only(bottom: 50.0),
            //   child: UnicornDialer(
            //       backgroundColor: Color.fromRGBO(255, 255, 255, 0.6),
            //       parentButtonBackground: Colors.redAccent,
            //       orientation: UnicornOrientation.VERTICAL,
            //       parentButton: Icon(Icons.share_outlined),
            //       childButtons: childButtons),
            // ),
            // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, state) {
              if (state is Authenticated) {
                return HomeScreen();
              } else {
                return _buildSignInBloc();
              }
            }),
          ),
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            localizationDelegate,
          ],
          onGenerateRoute: _registerRoutesWithParameters,
          supportedLocales: localizationDelegate.supportedLocales,
          debugShowCheckedModeBanner: false,
          locale: localizationDelegate.currentLocale,
          title: 'MasterPro Loyalty',
          theme: hoscoTheme.of(context),
          routes: _registerRoutes(),
        ));
  }


  Map<String, WidgetBuilder> _registerRoutes() {
    return <String, WidgetBuilder>{

      hoscoRoutes.cart: (context) =>
          BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
            if (state is Authenticated) {
              return CartScreen();
            } else {
              return _buildSignInBloc();
            }
          }),
      hoscoRoutes.checkout: (context) =>
          BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
            if (state is Authenticated) {
              return CheckoutScreen();
            } else {
              return _buildSignInBloc();
            }
          }),
      hoscoRoutes.favourites: (context) =>
          BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
            if (state is Authenticated) {
              return FavouriteScreen();
            } else {
              return _buildSignInBloc();
            }
          }),
      hoscoRoutes.signin: (context) => _buildSignInBloc(),
      hoscoRoutes.signup: (context) => _buildSignUpBloc(),
      hoscoRoutes.forgotPassword: (context) => _buildForgetPasswordBloc(),
      hoscoRoutes.profile: (context) =>
          BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
            //TODO: revise authentication later. Right now no login is required.
            if (state is Authenticated) {
              return ProfileScreen(); //TODO profile properties should be here
            } else if (state is Unauthenticated) {
              return _buildSignInBloc();
            } else {
              return SplashScreen();
            }
            return ProfileScreen();
          }),
    };
  }

  BlocProvider<ForgetPasswordBloc> _buildForgetPasswordBloc() {
    return BlocProvider<ForgetPasswordBloc>(
      create: (context) => ForgetPasswordBloc(
        userRepository: RepositoryProvider.of<UserRepository>(context),
      ),
      child: ForgetPasswordScreen(),
    );
  }

  BlocProvider<SignInBloc> _buildSignInBloc() {
    return BlocProvider<SignInBloc>(
      create: (context) => SignInBloc(
        userRepository: RepositoryProvider.of<UserRepository>(context),
        authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
      ),
      child: SignInScreen(),
    );
  }

  BlocProvider<SignUpBloc> _buildSignUpBloc() {
    return BlocProvider<SignUpBloc>(
      create: (context) => SignUpBloc(
        userRepository: RepositoryProvider.of<UserRepository>(context),
        authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
      ),
      child: SignUpScreen(),
    );
  }

  Route _registerRoutesWithParameters(RouteSettings settings) {
    if (settings.name == hoscoRoutes.shop) {
      final CategoriesParameters args = settings.arguments;
      return MaterialPageRoute(
        builder: (context) {
          return BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              if (state is Authenticated) {
                return CategoriesScreen(
                  parameters: args,
                );
              } else {
                return _buildSignInBloc();
              }
            },
          );
          return CategoriesScreen(
            parameters: args,
          );
        },
      );
    } else if (settings.name == hoscoRoutes.productList) {
      final ProductListScreenParameters productListScreenParameters =
          settings.arguments;
      return MaterialPageRoute(builder: (context) {
        return ProductsScreen(
          parameters: productListScreenParameters,
        );
      });
    } else if (settings.name == hoscoRoutes.product) {
      final ProductDetailsParameters parameters = settings.arguments;
      return MaterialPageRoute(builder: (context) {
        return ProductDetailsScreen(parameters);
      });
    } else if (settings.name == hoscoRoutes.filters) {
      final FilterRules filterRules = settings.arguments;
      return MaterialPageRoute(builder: (context) {
        return FiltersScreen(filterRules);
      });
    } else {
      return MaterialPageRoute(
        builder: (context) {
          return BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
            if (state is Authenticated) {
              return HomeScreen();
            } else {
              return _buildSignInBloc();
            }
          });
          //return HomeScreen();
        },
      );
    }
  }
}
