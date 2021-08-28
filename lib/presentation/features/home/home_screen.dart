// Home Screen
// Author: openflutterproject@gmail.com
// Date: 2020-02-06

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hosco/config/storage.dart';
import 'package:hosco/data/model/product.dart';
import 'package:hosco/main.dart';
import 'package:hosco/presentation/features/wrapper.dart';
import 'package:hosco/presentation/widgets/widgets.dart';

import 'home.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: OpenFlutterScaffold(
      background: null,
      title: null,
      body: BlocProvider<HomeBloc>(
          create: (context) {
            return HomeBloc()..add(HomeLoadEvent());
          },
          child: HomeWrapper()),
      bottomMenuIndex: 0,
    ));
  }
}
class HomeWrapper extends StatefulWidget {
  @override
  _HomeWrapperState createState() => _HomeWrapperState();
}

class _HomeWrapperState extends OpenFlutterWrapperState<HomeWrapper> {
  //State createState() => OpenFlutterWrapperState();
  

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification androidNotification = message.notification?.android;
      if (notification != null && androidNotification != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published! ');
    //   Navigator.pushNamed(context, '/message',
    //       arguments: MessageArguments(message, true));
    // });
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
          context: context,
          builder: (_) {
            print(notification.body);
            return AlertDialog(
              title: Text(notification.title),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Test :${notification.body}'),
                  ],
                ),
              ),
            );
          },
        );
      }
    });

    // subscribe to topic on each app start-up
  final tentcode = Storage()?.account?.tenantCode;
  final userName = Storage()?.account?.username;
  FirebaseMessaging.instance.subscribeToTopic('app-notifi-$tentcode-$userName');
  FirebaseMessaging.instance.subscribeToTopic('app-notifi-crm-$tentcode');
  // FirebaseMessaging.instance.unsubscribeFromTopic('app-notifi-$tentcode-$userName');
  // FirebaseMessaging.instance.unsubscribeFromTopic('app-notifi-crm-$tentcode');
  FirebaseMessaging.instance.getToken().then((token){
    print(token);
  });
  }
 
  

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
        builder: (BuildContext context, HomeState state) {
      return getPageView(<Widget>[
        // MainView(changeView: changePage,),
        Main2View(
          changeView: changePage,
          products: state is HomeLoadedState ? state.newProducts : <Product>[],
        ),
        // Main1View(
        //   changeView: changePage,
        //   products: state is HomeLoadedState ? state.newProducts : <Product>[],
        //   cartTotal: state is HomeLoadedState ? state.cartNum??0 : 0,
        // ),
        /*
        Main2View(
          changeView: changePage,
          salesProducts:
            state is HomeLoadedState ? state.salesProducts : <Product>[],
          newProducts:
            state is HomeLoadedState ? state.newProducts : <Product>[]),
        Main3View(changeView: changePage),
        Main4View(changeView: changePage)*/
      ]);
    });
  }
}
