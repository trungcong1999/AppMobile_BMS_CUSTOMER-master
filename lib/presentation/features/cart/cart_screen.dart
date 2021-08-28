// Home Screen
// Author: openflutterproject@gmail.com
// Date: 2020-02-06

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hosco/presentation/features/cart/views/cart_view.dart';
import 'package:hosco/presentation/features/wrapper.dart';
import 'package:hosco/presentation/widgets/widgets.dart';

import 'cart.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          'Giỏ hàng',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
      ),
      body: BlocProvider<CartBloc>(
          create: (context) {
            return CartBloc()..add(CartLoadedEvent());
          },
          child: Container(color: Colors.white, child: CartWrapper())),
    );
  }
}

class CartWrapper extends StatefulWidget {
  @override
  _CartWrapperState createState() => _CartWrapperState();
}

class _CartWrapperState extends OpenFlutterWrapperState<CartWrapper> {
  //State createState() => OpenFlutterWrapperState();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
        builder: (BuildContext context, CartState state) {
      return getPageView(<Widget>[CartView(changeView: changePage)]);
    });
  }
}
