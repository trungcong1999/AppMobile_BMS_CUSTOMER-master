// List of products in the card view
// Author: openflutterproject@gmail.com
// Date: 2020-02-06

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hosco/config/routes.dart';
import 'package:hosco/config/theme.dart';
import 'package:hosco/presentation/features/product_details/product_screen.dart';
import 'package:hosco/presentation/widgets/extensions/product_view.dart';

import '../products.dart';

class ProductsTileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsBloc, ProductsState>(builder: (context, state) {
      return SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          childAspectRatio: AppSizes.tile_width / AppSizes.tile_height,
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSizes.sidePadding),
                child: state.data.products[index].getTileView(
                  context: context,
                  onFavoritesClick: () {
                    BlocProvider.of<ProductsBloc>(context).add(
                        ProductMakeFavoriteEvent(
                            !state.data.products[index].isFavorite,
                            state.data.products[index]));
                  },
                  showProductInfo: () {
                    Navigator.of(context).pushNamed(
                        hoscoRoutes.product,
                        arguments: ProductDetailsParameters(
                            state.data.products[index].id,
                            state.data.category.id));
                  },
                ));
          },
          childCount: state.data.products.length,
        ),
      );
    });
  }
}
