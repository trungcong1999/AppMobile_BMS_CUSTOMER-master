/*
 * @author Andrew Poteryahin <openflutterproject@gmail.com>
 * @copyright 2020 Open E-commerce App
 * @see cart_repository_impl.dart
 */

import 'package:hosco/config/storage.dart';
import 'package:hosco/data/repositories/abstract/cart_repository.dart';
import 'package:hosco/data/model/cart_item.dart';
import 'package:hosco/data/model/product.dart';
import 'package:hosco/data/model/product_attribute.dart';
import 'package:hosco/data/model/promo.dart';

class CartRepositoryImpl extends CartRepository{
  static CartProductDataStorage cartProductDataStorage 
    = CartProductDataStorage();

  @override
  Future addProductToCart(Product product, int quantity, Map<ProductAttribute, String> selectedAttributes) async {
    var cartItem = CartItem(
      product: product,
      productQuantity: ProductQuantity(quantity),
      selectedAttributes: selectedAttributes,
    );

    var exit = false;
    for(int i = 0; i < cartProductDataStorage.items.length; i++){
      if ( cartProductDataStorage.items[i].product.id == cartItem.product.id
      && cartItem.product.unit == cartProductDataStorage.items[i].product.unit) {
        exit = true;
        await changeQuantity(cartItem, cartProductDataStorage.items[i].productQuantity.quantity + quantity);
        break;
      }
    }
    if(!exit) {
      cartProductDataStorage.items.add(cartItem);
    }
  }

  @override
  Future changeQuantity(CartItem item, int newQuantity) async {
    for(int i = 0; i < cartProductDataStorage.items.length; i++){
      if ( cartProductDataStorage.items[i].product.id == item.product.id
          && item.product.unit == cartProductDataStorage.items[i].product.unit) {
        cartProductDataStorage.items[i].productQuantity.changeQuantity(newQuantity);
      }
    }
  }

  @override
  Future<Promo> getAppliedPromo() async {
    return cartProductDataStorage.appliedPromo;
  }

  @override
  Future<List<CartItem>> getCartContent() async {
    return cartProductDataStorage.items;
  }

  @override
  Future setPromo(Promo promo) async {
    cartProductDataStorage.appliedPromo = promo;
  }

  @override
  double getTotalPrice(){
    double totalPrice = 0;
    for (var i = 0; i < cartProductDataStorage.items.length; i++) {
      totalPrice += cartProductDataStorage.items[i].price;// * cartProductDataStorage.items[i].productQuantity.quantity;
    }
    return totalPrice;
  }

  @override
  double getCalculatedPrice(){
    final totalPrice = getTotalPrice();
    final calculatedTotalPrice = 
      cartProductDataStorage.appliedPromo != null ?
        totalPrice * (1 - cartProductDataStorage.appliedPromo.discount/100)
        : totalPrice;
    return calculatedTotalPrice;
  }

}

class CartProductDataStorage {
  List<CartItem> items = [];
  Promo appliedPromo;
}