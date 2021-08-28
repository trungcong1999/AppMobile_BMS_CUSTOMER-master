// Checkout Screen
// Author: openflutterproject@gmail.com
// Date: 2020-02-17

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hosco/presentation/features/wrapper.dart';
import 'package:hosco/presentation/widgets/widgets.dart';

import 'checkout.dart';
import 'views/add_shipping_address_view.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          'Thanh toán',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
      ),
      body: BlocProvider<CheckoutBloc>(
            create: (context) {
              return CheckoutBloc()..add(CheckoutStartEvent());
            },
            child: Container(color: Colors.white, child: CheckoutWrapper()))
    );
  }
}

class CheckoutWrapper extends StatefulWidget {
  @override
  _CheckoutWrapperState createState() => _CheckoutWrapperState();
}

class _CheckoutWrapperState extends OpenFlutterWrapperState<CheckoutWrapper> {
  //State createState() => OpenFlutterWrapperState();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckoutBloc, CheckoutState>(
        builder: (BuildContext context, CheckoutState state) {
      return getPageView(<Widget>[
        CartView(changeView: changePage),
        PaymentMethodView(changeView: changePage),
        ShippingAddressView(changeView: changePage),
        AddShippingAddressView(changeView: changePage),
        Success1View(changeView: changePage),
        Success2View(changeView: changePage),
      ]);
    });
  }
}
