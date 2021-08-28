// Home Screen View #1: Big top banner, list of products
// Author: openflutterproject@gmail.com
// Date: 2020-02-06

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:hosco/config/app_settings.dart';
import 'package:hosco/config/routes.dart';
import 'package:hosco/config/theme.dart';
import 'package:hosco/data/model/cart_item.dart';
import 'package:hosco/data/model/product.dart';
import 'package:hosco/data/model/promo.dart';
import 'package:hosco/presentation/widgets/data_driven/cart_tile.dart';
import 'package:hosco/presentation/widgets/data_driven/promo_tile.dart';
import 'package:hosco/presentation/widgets/independent/bottom_popup.dart';
import 'package:hosco/presentation/widgets/independent/summary_line.dart';
import 'package:hosco/presentation/widgets/widgets.dart';

import '../cart.dart';
import '../cart_bloc.dart';
import '../cart_state.dart';

class CartView extends StatefulWidget {
  final List<Product> products;
  final Function changeView;

  const CartView({Key key, this.products, this.changeView}) : super(key: key);

  @override
  _CartViewState createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  TextEditingController _promoController;

  @override
  void initState() {
    _promoController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _promoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);
    var width = MediaQuery.of(context).size.width;
    final bloc = BlocProvider.of<CartBloc>(context);

    return BlocListener<CartBloc, CartState>(listener: (context, state) {
      if (state is CartErrorState) {
        return Container(
          padding: EdgeInsets.all(AppSizes.sidePadding),
          child: Text('An error occurred',
            style: _theme.textTheme.bodyText1
              .copyWith(color: _theme.errorColor)));
      }
      return Container();
    }, child: BlocBuilder<CartBloc, CartState>(builder: (context, state) {
      if (state is CartLoadedState) {
        return Stack(children: <Widget>[
          SingleChildScrollView(
              child: Column(children: <Widget>[
            
            Column(children: buildCartItems(state.cartProducts, bloc)),
                Padding(
                  padding: EdgeInsets.only(bottom: AppSizes.sidePadding * 2),
                ),
                /*state.cartProducts.isNotEmpty ?  OpenFlutterInputButton(
                  placeHolder:
                    state.appliedPromo != null ?
                      state.appliedPromo.promoCode
                      : 'Enter your promo code',
                  controller: _promoController,
                  width: width,
                  onClick: (() => {bloc..add(CartShowPopupEvent())}),
                ) : Container(),
                Padding(
                  padding: EdgeInsets.only(bottom: AppSizes.sidePadding * 2),
                ),*/
                state.appliedPromo != null ?
                  Column(
                    children: <Widget> [
                      OpenFlutterSummaryLine(
                        title: 'Tổng tiền hàng:',
                        summary: '\$' + state.totalPrice?.toStringAsFixed(2)),
                      OpenFlutterSummaryLine(
                        title: 'Discount %:',
                        summary: state.appliedPromo.discount.toStringAsFixed(0) + '%'),
                      OpenFlutterSummaryLine(
                        title: 'Thành tiền:',
                        summary: '\$' + state.calculatedPrice?.toStringAsFixed(2)),
                      ]
                    )  :
                    state.cartProducts.isNotEmpty ? OpenFlutterSummaryLine(
                      title: 'Tổng tiền hàng:',
                      summary: NumberFormat.currency(locale: AppSettings.locale).format(state.totalPrice??0), //state.totalPrice?.toStringAsFixed(2)
                    ) : Container(),
                Padding(
                  padding: EdgeInsets.only(bottom: AppSizes.sidePadding * 2),
                ),
                state.cartProducts.isNotEmpty ? OpenFlutterButton(
                  onPressed: (() => {
                        Navigator.of(context)
                            .pushNamed(hoscoRoutes.checkout)
                      }),
                  title: 'ĐẶT HÀNG',
                  icon: Icons.credit_card_outlined,
                ) : Container(
                  child: Text('Không có sản phẩm nào',style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold ),),
                ),
                OpenFlutterButton(
                  onPressed: (() => {
                    Navigator.pop(context)
                  }),
                  backgroundColor: Colors.teal,
                  borderColor: Colors.teal,
                  title: 'TIẾP TỤC MUA HÀNG',
                  icon: Icons.arrow_back,
                )
          ])),
          state.showPromoPopup ? 
            OpenFlutterBottomPopup(
              title: '',
              child: Column(
                children: <Widget>[
                  OpenFlutterInputButton(
                    placeHolder: 'Enter your promo code',
                    controller: _promoController,
                    width: width,
                    onClick: (() => {
                        bloc
                          ..add(CartPromoCodeAppliedEvent(
                            //TODO: check that code is valid
                            promoCode: _promoController.text))
                      }),
                  ),
                  Padding(
                    padding:
                      EdgeInsets.only(bottom: AppSizes.sidePadding)),
                  OpenFlutterBlockSubtitle(
                    width: width,
                    title: 'Mã giảm giá',
                  ),
                  //OpenFlutterInputField(controller: null, hint: 'Tax', onValueChanged: (String value) => {print(value)}),
                  Column(children: buildPromos(state.promos, bloc))
                ],
              ),
            )
            : Container()
        ]);
      }
      return Container();
    }));
  }

  List<Widget> buildPromos(List<Promo> promos, CartBloc bloc) {
    var widgets = <Widget>[];
    for (var i = 0; i < promos.length; i++) {
      widgets.add(Container(
          padding: EdgeInsets.symmetric(
              horizontal: AppSizes.sidePadding, vertical: AppSizes.sidePadding),
          child: OpenFlutterPromoTile(
            textColor: promos[i].textColor,
            item: promos[i],
            onClickApply: (() =>
                {bloc..add(CartPromoAppliedEvent(promo: promos[i]))}),
          )));
    }
    return widgets;
  }

  List<Widget> buildCartItems(List<CartItem> items, CartBloc bloc) {
    var widgets = <Widget>[];
    if (items.isNotEmpty) {
    for (var i = 0; i < items.length; i++) {
      widgets.add(Container(
          padding: EdgeInsets.symmetric(
              horizontal: AppSizes.sidePadding, vertical: AppSizes.sidePadding),
          child: OpenFlutterCartTile(
            item: items[i],
            onChangeQuantity: ((int quantity) => {
              if(quantity > 0) {// TODO
                bloc..add(CartQuantityChangedEvent(
                      item: items[i], newQuantity: quantity)),
                if(quantity < 1) {
                  items.remove(items[i]),
                },

                // Navigator.of(context)
                //     .pushNamed(hoscoRoutes.cart)
              }
            }),
            onAddToFav: () {
              bloc.add(CartAddToFavsEvent(item: items[i]));
            },
            onRemoveFromCart: () {
              bloc.add(CartRemoveFromCartEvent(item: items[i]));
              items.remove(items[i]);
            },
          )));
    }}
    return widgets;
  }
}
