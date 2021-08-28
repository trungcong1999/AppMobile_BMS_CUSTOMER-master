// Bottom menu widget for Open Flutter E-commerce App
// Author: openflutterproject@gmail.com
// Date: 2020-02-06

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hosco/config/app_settings.dart';
import 'package:hosco/config/routes.dart';
import 'package:hosco/config/storage.dart';
import 'package:hosco/config/theme.dart';
import 'package:hosco/data/repositories/cart_repository_impl.dart';
import 'package:hosco/domain/usecases/cart/get_cart_products_use_case.dart';
import 'package:hosco/locator.dart';
import 'package:hosco/presentation/features/cart/cart.dart';
import 'package:hosco/presentation/features/favorites/favorites.dart';
import 'package:hosco/presentation/features/home/home.dart';
import 'package:hosco/presentation/features/profile/profile.dart';

class OpenFlutterBottomMenu extends StatelessWidget {
  final int menuIndex;

  OpenFlutterBottomMenu(this.menuIndex);

  String get item_count => null;

  Color colorByIndex(ThemeData theme, int index) {
    return index == menuIndex ? theme.accentColor : theme.primaryColorLight;
  }

  BottomNavigationBarItem getItem(
      String image, String title, ThemeData theme, int index) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 6.0,
          horizontal: 16.0,
        ),
        decoration: BoxDecoration(
          color: menuIndex == index ? Colors.blue[600] : Colors.transparent,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: SvgPicture.asset(
          image,
          color: menuIndex == index ? Colors.white : Colors.grey,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 10.0,
          color: colorByIndex(theme, index),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    List<BottomNavigationBarItem> menuItems = [
      getItem('assets/icons/bottom_menu/home.svg', 'Home', _theme, 0),
      getItem('assets/icons/bottom_menu/cart.svg', 'Danh mục', _theme, 1),
      //getItem('assets/icons/bottom_menu/bag.svg', 'Giỏ hàng', _theme, 2),
      // getItem('assets/icons/bottom_menu/favorites.svg', 'Yêu thích', _theme, 3),
    ];
    if (AppSettings.profileEnabled) {
      menuItems.add(getItem(
          'assets/icons/bottom_menu/profile.svg', 'Tài khoản', _theme, 2));
    }
    // return Scaffold(
    //   extendBody: true,
    //   floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    //   floatingActionButton: FloatingActionButton(
    //     elevation: 10.0,
    //     child: Icon(
    //       Icons.qr_code,
    //     ),
    //     onPressed: () {},
    //   ),
    //   bottomNavigationBar: BottomAppBar(
    //     shape: CircularNotchedRectangle(),
    //     color: Colors.white,
    //     child: Container(
    //       height: 60,
    //       child: Padding(
    //         padding: const EdgeInsets.symmetric(horizontal: 20),
    //         child: Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: [
    //             IconButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (_)=>HomeScreen()));}, icon: Icon(Icons.home),iconSize: 40,color: menuIndex==0?Colors.red:Colors.grey,),
    //             IconButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (_)=>FavouriteScreen()));}, icon: Icon(Icons.card_giftcard),iconSize: 40,color: menuIndex==1?Colors.red:Colors.grey,),
    //             SizedBox.shrink(),
    //             IconButton(onPressed: (){}, icon: Icon(Icons.map_sharp),iconSize: 40,color: menuIndex==2?Colors.red:Colors.grey,),
    //             IconButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (_)=>ProfileScreen()));}, icon: Icon(Icons.verified_user),iconSize: 40,color: menuIndex==3?Colors.red:Colors.grey,),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(15), topLeft: Radius.circular(15)),
        boxShadow: [
          BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
        child: BlocProvider(
          create: (_) => CartBloc()..add(CartLoadedEvent()),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey,
            currentIndex: menuIndex,
            onTap: (value) {
              switch (value) {
                case 0:
                  Navigator.pushNamed(context, hoscoRoutes.home);
                  break;
                case 1:
                  Navigator.pushNamed(context, hoscoRoutes.shop);
                  break;
                // case 2:
                //   Navigator.pushNamed(context, hoscoRoutes.cart);
                //   break;
                /*case 3:
                Navigator.pushNamed(
                    context, hoscoRoutes.favourites);
                break;*/
                case 2:
                  Navigator.pushNamed(context, hoscoRoutes.profile);
                  break;
              }
            },
            items: menuItems,
          ),
        ),
      ),
    );
  }
}
