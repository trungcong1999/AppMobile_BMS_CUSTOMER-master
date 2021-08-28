import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hosco/config/app_settings.dart';
import 'package:hosco/config/routes.dart';
import 'package:hosco/config/theme.dart';
import 'package:hosco/data/model/category.dart';
import 'package:hosco/data/model/commerce_image.dart';
import 'package:hosco/data/model/product.dart';
import 'package:hosco/data/model/product_attribute.dart';
import 'package:hosco/presentation/features/home/home.dart';
import 'package:hosco/presentation/features/home/home_bloc.dart';
import 'package:hosco/presentation/features/product_details/views/attribute_bottom_sheet.dart';
import 'package:hosco/presentation/features/product_reviews/product_review_and_rating_screen.dart';
import 'package:hosco/presentation/widgets/widgets.dart';
import 'package:intl/intl.dart';

import '../product.dart';
import '../product_bloc.dart';
import '../product_state.dart';

class ProductDetailsView extends StatefulWidget {
  final Product product;
  final Function changeView;
  final ProductCategory category;
  final bool hasReviews;

  final List<Product> similarProducts;

  const ProductDetailsView(
      {Key key,
      @required this.product,
      @required this.changeView,
      @required this.similarProducts,
      this.category,
      this.hasReviews = false})
      : assert(product != null),
        super(key: key);

  @override
  _ProductDetailsViewState createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  Orientation orientation;
  bool favorite;
  ProductBloc bloc;

  @override
  void initState() {
    favorite = widget.product?.isFavorite ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);
    final dividerTheme =
        Theme.of(context).copyWith(dividerColor: AppColors.darkGray);

    bloc = BlocProvider.of<ProductBloc>(context);
    return BlocListener(
        cubit: bloc,
        listener: (context, state) {
          if (state is ProductErrorState) {
            return Container(
                padding: EdgeInsets.all(AppSizes.sidePadding),
                child: Text('Đã có lỗi xảy ra',
                    style: _theme.textTheme.display1
                        .copyWith(color: _theme.errorColor)));
          }
          return Container();
        },
        child: BlocBuilder(
            cubit: bloc,
            builder: (BuildContext context, ProductState state) {
              if (state is ProductLoadedState) {
                if (state.product.images.isEmpty) {
                  state.product.images.add(CommerceImage.placeHolder());
                }

                return Scaffold(
                  body: getBody(state),
                  bottomSheet: getBottom(state, _theme),
                  // child: Container(
                  //   color: Colors.white,
                  //   child: Column(
                  //     mainAxisSize: MainAxisSize.min,
                  //     crossAxisAlignment: CrossAxisAlignment.center,
                  //     children: <Widget>[
                  //       Container(
                  //         height: deviceHeight * 0.5,
                  //         child: ListView.builder(
                  //           itemBuilder: (context, index) => Padding(
                  //               padding: EdgeInsets.only(
                  //                   right: AppSizes.sidePadding),
                  //               child: state.product.images[index].address
                  //                       .startsWith('http')
                  //                   ? Image.network(
                  //                       state.product.images[index].address)
                  //                   : Image.asset(
                  //                       state.product.images[index].address)),
                  //           scrollDirection: Axis.horizontal,
                  //           itemCount: state.product.images.length,
                  //         ),
                  //       ),
                  //       Container(
                  //         decoration: BoxDecoration(
                  //           color: Colors.white,
                  //           borderRadius: BorderRadius.only(
                  //             topLeft: Radius.circular(40),
                  //             topRight: Radius.circular(40),
                  //           ),
                  //           boxShadow: [
                  //             BoxShadow(
                  //                 color: Colors.black.withOpacity(.2),
                  //                 offset: Offset(0, -4),
                  //                 blurRadius: 8),
                  //           ],
                  //         ),
                  //         child: Column(
                  //           children: [
                  //             productDetails(_theme),
                  //             Container(
                  //               width: deviceWidth,
                  //               padding: const EdgeInsets.symmetric(
                  //                   vertical: 20, horizontal: 30),
                  //               decoration: BoxDecoration(
                  //                 color: Colors.white,
                  //                 borderRadius: BorderRadius.only(
                  //                   topLeft: Radius.circular(20),
                  //                   topRight: Radius.circular(20),
                  //                 ),
                  //                 boxShadow: [
                  //                   BoxShadow(
                  //                     color: Colors.black.withOpacity(.07),
                  //                     offset: Offset(0, -3),
                  //                     blurRadius: 12,
                  //                   ),
                  //                 ],
                  //               ),
                  //               child: Row(
                  //                 children: [
                  //                   Expanded(
                  //                     child: Column(
                  //                       crossAxisAlignment:
                  //                           CrossAxisAlignment.start,
                  //                       children: (state.product
                  //                                 .selectableAttributes !=
                  //                             null
                  //                         ? state.product.selectableAttributes
                  //                             .map((value) =>
                  //                                 selectionOutlineButton(
                  //                                     deviceWidth,
                  //                                     value,
                  //                                     state.productAttributes
                  //                                             .selectedAttributes[
                  //                                         value]))
                  //                             .toList()
                  //                         : List<Widget>()) +[
                  //                           Text('Tổng',style: TextStyle(fontSize: 14,color: Colors.black),),
                  //                         Text(
                  //                           state.product.price != null
                  //                               ? NumberFormat.currency(
                  //                                       locale: AppSettings
                  //                                           .locale,
                  //                                       symbol: 'đ')
                  //                                   .format(
                  //                                       state.product.price)
                  //                               : '',
                  //                           style: _theme.textTheme.display3
                  //                               .copyWith(
                  //                                   decoration:
                  //                                       TextDecoration.none,
                  //                                   fontSize: 20.0,
                  //                                   color: Colors.black,
                  //                                   fontWeight:
                  //                                       FontWeight.bold),
                  //                         ),
                  //                       ],
                  //                     ),
                  //                   ),
                  //                   Material(
                  //                     color: Color.fromRGBO(243, 175, 45, 1),
                  //                     borderRadius: BorderRadius.circular(10),
                  //                     child: InkWell(
                  //                       onTap: () {_addItemToCart(context, state);},
                  //                       borderRadius:
                  //                           BorderRadius.circular(10),
                  //                       child: Container(
                  //                         padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                  //                         decoration: BoxDecoration(
                  //                           borderRadius:
                  //                               BorderRadius.circular(10),
                  //                         ),
                  //                         child: Text(
                  //                           'Thêm vào giỏ',
                  //                           style: TextStyle(
                  //                               fontSize: 20,
                  //                               fontWeight: FontWeight.bold,
                  //                               color: Colors.black),
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //             // Container(
                  //             //   width: deviceWidth,
                  //             //   margin: EdgeInsets.only(bottom: 13),
                  //             //   height: 90,
                  //             //   child: Center(
                  //             //     child: OpenFlutterButton(
                  //             //       title: 'THÊM VÀO GIỎ HÀNG',
                  //             //       onPressed: () {
                  //             //         _addItemToCart(context, state);
                  //             //       },
                  //             //       width: deviceWidth * 0.88,
                  //             //       height: 50,
                  //             //     ),
                  //             //   ),
                  //             // ),
                  //           ],
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                );
              }
              return Container();
            }));
  }

  void setFavourite(ProductBloc bloc) {
    if (!favorite) {
      bloc.add(
          ProductAddToFavoritesEvent()); //TODO ask for real parameters if required
    } else {
      bloc.add(ProductRemoveFromFavoritesEvent());
    }
    setState(() {
      favorite = !favorite;
    });
  }

  void _showSelectAttributeBottomSheet(
      BuildContext context, ProductAttribute attribute,
      {Function onSelect, String selectedValue}) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(34), topRight: Radius.circular(34)),
        ),
        builder: (BuildContext context) => AttributeBottomSheet(
            productAttribute: attribute,
            selectedValue: selectedValue,
            onValueSelect: ((String value, ProductAttribute productAttribute) =>
                {
                  bloc..add(ProductSetAttributeEvent(value, productAttribute)),
                  Navigator.pop(context),
                  onSelect()
                })));
  } //modelBottomSheet for selecting size

  Widget selectionOutlineButton(var deviceWidth, ProductAttribute attribute,
      String alreadySelectedValue) {
    //select size and select color widget
    return OutlineButton(
      onPressed: () => _showSelectAttributeBottomSheet(context, attribute,
          selectedValue: alreadySelectedValue),
      child: Container(
        margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              alreadySelectedValue ?? attribute.name,
              style: TextStyle(
                  fontSize: 14,
                  color: AppColors.black,
                  fontWeight: FontWeight.w300),
            ),
            Icon(Icons.keyboard_arrow_down)
          ],
        ),
        width: deviceWidth * 0.29,
      ),
      borderSide: BorderSide(color: AppColors.darkGray),
      highlightedBorderColor: AppColors.red,
      focusColor: AppColors.white,
      highlightColor: Colors.white,
      hoverColor: AppColors.red,
      shape:
          ContinuousRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
    );
  }

  Widget productDetails(ThemeData theme) {
    //title,rating,price of product
    return Container(
      // margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 17.0,top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
              left: 30,
              right: 30,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Text(
                    widget.product.title ?? '',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                OpenFlutterFavouriteButton(
                  favourite: favorite,
                  setFavourite: () => {setFavourite(bloc)},
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
              left: 30,
              right: 30,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        widget.product.description ?? '',
                        style: TextStyle(height: 5, fontSize: 11),
                      ),
                    ),
                    widget.category == null
                        ? Container()
                        : Text(
                            widget.category.name,
                            style: theme.textTheme.body1,
                          ),
                    SizedBox(
                      height: 5,
                    ),
                    Divider(),
                  ],
                ),
              ],
            ),
          ),
          /*
          GestureDetector(
            onTap: widget.hasReviews
                ? () {
                    navigateToReviewDetail(context);
                  }
                : null,
            child: Container(
              child: OpenFlutterProductRating(
                rating: widget.product.averageRating,
                ratingCount: widget.product.ratingCount,
                alignment: MainAxisAlignment.start,
              ),
            ),
          ),*/
        ],
      ),
    );
  }

  void navigateToReviewDetail(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ProductReviewRatingScreen(
        product: widget.product,
      ),
    ));
  }

  void _addItemToCart(BuildContext context, ProductLoadedState state) async {
    if (state.productAttributes.selectedAttributes.length ==
        state.product.selectableAttributes.length) {
      print('fucking......');
      BlocProvider.of<ProductBloc>(context).add(ProductAddToCartEvent());
      await Navigator.pushNamed(context, hoscoRoutes.cart);
    } else {
      for (int i = 0; i < state.product.selectableAttributes.length; i++) {
        final attribute = state.product.selectableAttributes[i];
        if (!state.productAttributes.selectedAttributes
            .containsKey(attribute)) {
          await _showSelectAttributeBottomSheet(context, attribute,
              onSelect: i == 0
                  ? (() => {
                        BlocProvider.of<ProductBloc>(context)
                            .add(ProductAddToCartEvent()),
                        Navigator.pushNamed(context, hoscoRoutes.cart)
                      })
                  : null);
        }
      }
    }
  }

  Widget getBody(ProductLoadedState state) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: ListView(
          children: <Widget>[
            Card(
              elevation: 2,
              child: Container(
                height: 400,
                child: ListView.builder(
                  itemBuilder: (context, index) => Padding(
                      padding: EdgeInsets.only(right: AppSizes.sidePadding),
                      child: state.product.images[index].address
                              .startsWith('http')
                          ? Image.network(state.product.images[index].address)
                          : Image.asset(state.product.images[index].address)),
                  scrollDirection: Axis.horizontal,
                  itemCount: state.product.images.length,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Text(
                      widget.product.title ?? '',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  OpenFlutterFavouriteButton(
                    favourite: favorite,
                    setFavourite: () => {setFavourite(bloc)},
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      widget.product.description ?? '',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.2,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getBottom(ProductLoadedState state, ThemeData _theme) {
    var deviceWidth = MediaQuery.of(context).size.width;
    var deviceHeight = MediaQuery.of(context).size.height;
    return Container(
      height: 80,
      width: deviceWidth,
      decoration: BoxDecoration(
          color: Colors.red[500],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          )),
      child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: (state.product.selectableAttributes != null
                      ? state.product.selectableAttributes
                          .map((value) => selectionOutlineButton(
                              deviceWidth,
                              value,
                              state
                                  .productAttributes.selectedAttributes[value]))
                          .toList()
                      : List<Widget>()) +
                  [
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tổng',
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            state.product.price != null
                                ? NumberFormat.currency(
                                        locale: AppSettings.locale, symbol: 'đ')
                                    .format(state.product.price)
                                : '',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
            ),
            FlatButton(
              height: 50,
              color: Colors.yellow[400],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onPressed: () {
                _addItemToCart(context, state);
              },
              child: Text(
                'Thêm vào giỏ',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
