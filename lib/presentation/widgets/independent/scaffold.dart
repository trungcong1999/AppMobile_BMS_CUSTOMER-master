//Scaffold for Open Flutter E-commerce App
//Author: openflutterproject@gmail.com
//Date: 2020-02-06

import 'package:flutter/material.dart';
import 'package:hosco/presentation/features/endows/endows_screen.dart';
import 'package:hosco/presentation/features/favorites/favorites.dart';
import 'package:hosco/presentation/features/home/home.dart';
import 'package:hosco/presentation/features/map/googlemap_screen.dart';
import 'package:hosco/presentation/features/profile/profile.dart';
import 'package:hosco/presentation/features/qrcode/qrcode_screen.dart';

import '../widgets.dart';

class OpenFlutterScaffold extends StatelessWidget {
  final Color background;
  final String title;
  final Widget body;
  final int bottomMenuIndex;
  final List<String> tabBarList;
  final TabController tabController;

  const OpenFlutterScaffold(
      {Key key,
      this.background,
       this.title,
       this.body,
       this.bottomMenuIndex,
      this.tabBarList,
      this.tabController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tabBars = <Tab>[];
    var _theme = Theme.of(context);
    // if (tabBarList != null) {
    //   for (var i = 0; i < tabBarList.length; i++) {
    //     tabBars.add(Tab(key: UniqueKey(), text: tabBarList[i]));
    //   }
    // }
    Widget tabWidget = tabBars.isNotEmpty
        ? TabBar(
            unselectedLabelColor: _theme.primaryColor,
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
            labelColor: _theme.primaryColor,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            tabs: tabBars,
            controller: tabController,
            indicatorColor: _theme.accentColor,
            indicatorSize: TabBarIndicatorSize.tab)
        : null;
    return Scaffold(
      backgroundColor: background,
      appBar: title != null
          ? AppBar(title: Text(title), bottom: tabWidget,)
          : null,
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        height: 60.0,
        width: 60.0,
        child: FittedBox(
          child: FloatingActionButton(
            elevation: 10.0,
            child: Container(
              child: Image(
                image: AssetImage('assets/icons/favourites/4233990.png'),
                height: 25,
                width: 25,
                color: Colors.white,
              ),
            ),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => QrCodeScreen()));
            },
          ),
        ),
      ),

      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: Colors.white,
        child: Container(
          height: 65,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => HomeScreen()));
                      },
                      icon: Container(
                        child: Image(
                          image: AssetImage('assets/icons/favourites/home.png'),
                          color:
                              bottomMenuIndex == 0 ? Colors.red : Colors.grey,
                          height: 30,
                          width: 32,
                        ),
                      ),
                      iconSize: 32,
                    ),
                    Text(
                      'Trang Chủ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: bottomMenuIndex == 0 ? Colors.red : Colors.grey,
                      ),
                    ),
                  ],
                ),
                
                //cua hang
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Main1View()));
                      },
                      icon: Container(
                        child: Image(
                          image: AssetImage('assets/images/checkout/cartbag.png'),
                          color:
                              bottomMenuIndex == 1 ? Colors.red : Colors.grey,
                          height: 31,
                          width: 35,
                        ),
                      ),
                      iconSize: 32,
                    ),
                    Text(
                      'Mua Sắm',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: bottomMenuIndex == 1 ? Colors.red : Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox.shrink(),
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => EndowsScreen()));
                      },
                      icon: Container(
                        child: Image(
                          image: AssetImage('assets/icons/favourites/gift.png'),
                          color:
                              bottomMenuIndex == 2 ? Colors.red : Colors.grey,
                          height: 30,
                          width: 32,
                        ),
                      ),
                      iconSize: 32,
                    ),
                    Text(
                      'Ưu Đãi',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: bottomMenuIndex == 2 ? Colors.red : Colors.grey,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => ProfileScreen()));
                      },
                      icon: Container(
                        child: Image(
                          image: AssetImage('assets/icons/favourites/user.png'),
                          color:
                              bottomMenuIndex == 3 ? Colors.red : Colors.grey,
                          height: 30,
                          width: 32,
                        ),
                      ),
                      iconSize: 32,
                    ),
                    Text(
                      'Cá Nhân',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: bottomMenuIndex == 3 ? Colors.red : Colors.grey,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: body,
      // bottomNavigationBar: OpenFlutterBottomMenu(bottomMenuIndex),
    );
  }
}
