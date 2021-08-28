import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hosco/data/model/product_attribute.dart';
import 'package:hosco/presentation/widgets/widgets.dart';

import '../wrapper.dart';
import 'product_bloc.dart';
import 'product_event.dart';
import 'product_state.dart';
import 'views/details.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductDetailsParameters parameters;

  const ProductDetailsScreen(
    this.parameters, {
    Key key,
  }) : super(key: key);

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class ProductDetailsParameters {
  final String productId;
  final String categoryId;
  final HashMap<ProductAttribute, String> selectedAttributes;

  const ProductDetailsParameters(this.productId, this.categoryId,
      {this.selectedAttributes});
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    //print('productId: ${widget.parameters.productId}');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chi tiết sản phẩm',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.red,
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
      ),
      body: BlocProvider<ProductBloc>(
        create: (context) {
          return ProductBloc(productId: widget.parameters.productId)
            ..add(ProductScreenLoadedEvent(
                productId: widget.parameters.productId,
                categoryId: widget.parameters.categoryId));
        },
        child: ProductWrapper(),
      ),
    );
  }
}

class ProductWrapper extends StatefulWidget {
  @override
  _ProductWrapperState createState() => _ProductWrapperState();
}

class _ProductWrapperState extends OpenFlutterWrapperState<ProductWrapper> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
        cubit: BlocProvider.of<ProductBloc>(context),
        builder: (BuildContext context, ProductState state) {
          if (state is ProductLoadedState) {
            return ProductDetailsView(
                product: state.product,
                similarProducts: state.similarProducts,
                changeView: changePage);
          }
          return Container();
        });
  }
}
