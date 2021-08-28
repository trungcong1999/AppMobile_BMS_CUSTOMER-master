import 'dart:async';
import 'dart:collection';
import 'dart:math' as math;
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:hosco/config/app_settings.dart';
import 'package:hosco/config/routes.dart';
import 'package:hosco/config/theme.dart';
import 'package:hosco/data/model/cart_item.dart';
import 'package:hosco/data/model/commerce_image.dart';
import 'package:hosco/data/model/product.dart';
import 'package:hosco/data/model/product_attribute.dart';
import 'package:hosco/data/repositories/abstract/product_repository.dart';
import 'package:hosco/domain/usecases/cart/add_product_to_cart_use_case.dart';
import 'package:hosco/domain/usecases/cart/get_cart_products_use_case.dart';
import 'package:hosco/locator.dart';
import 'package:hosco/presentation/features/product_details/product_screen.dart';
import 'package:hosco/presentation/widgets/independent/base_product_list_item.dart';
import 'package:hosco/presentation/widgets/independent/base_product_tile.dart';
import 'package:hosco/presentation/widgets/independent/loading_view.dart';

class Main1View extends StatefulWidget {
  final Function changeView;
  final List<Product> products;
  final int cartTotal;

  const Main1View({
    Key key,
    this.products,
    this.changeView,
    this.cartTotal=0,
  }) : super(key: key);

  @override
  _Main1ViewState createState() => _Main1ViewState();
}

class _Main1ViewState extends State<Main1View> {
  final _scrollController = ScrollController();
  final _suggestionBloc = SuggestionBloc();
  int page = 0;
  String searchPattern;
  bool typing = false;
  int cartNum = 0;
  bool isListViewState = AppSettings.isListViewState;

  @override
  @protected
  @mustCallSuper
  void initState() {
    cartNum = widget.cartTotal;
    _suggestionBloc.fetchSuggestions(0, searchPattern, false);
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _suggestionBloc.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        page <= _suggestionBloc.totalPage) {
      _suggestionBloc.fetchSuggestions(++page, searchPattern, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);
    var width = MediaQuery.of(context).size.width;
    var widgetWidth = width - AppSizes.sidePadding * 2;
    cartNum = cartNum == 0 ? widget.cartTotal : cartNum;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.red,
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: typing
            ? TextField(
                cursorColor: Colors.black,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.go,
                autofocus: true,
                style: _theme.textTheme.subtitle2,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                    //hintStyle: TextStyle(color: Colors.white30),
                    hintText: 'Tìm kiếm...'),
                onChanged: (val) {
                  setState(() {
                    searchPattern = val;
                  });
                },
              )
            : Text(
                'Danh sách sản phẩm',
                style: TextStyle(color: Colors.white),
              ),
        // leading: Container(
        //   child: IconButton(
        //     icon: Icon(isListViewState ? Icons.view_list : Icons.view_module),
        //     onPressed: () {
        //       setState(() {
        //         isListViewState = !isListViewState;
        //       });
        //     },
        //   )
        // ),
        actions: [
          _shoppingCartBadge(),
        ],
      ), //FloatAppBar(_suggestionBloc),
      body: Container(child: _buildSuggestions()),
    );
  }

  Widget _shoppingCartBadge() {
    return Badge(
      position: BadgePosition.topEnd(top: 0, end: 3),
      animationDuration: Duration(milliseconds: 300),
      animationType: BadgeAnimationType.slide,
      badgeContent: Text(
        cartNum.toString() ?? 0,
        style: TextStyle(color: Colors.white),
      ),
      child: IconButton(
        icon: Icon(Icons.shopping_cart),
        onPressed: () {
          Navigator.pushNamed(context, hoscoRoutes.cart);
        },
        color: Colors.white,
      ),
    );
  }

  Widget _buildRow(Product product, String catId, bool isListViewState) {
    var _theme = Theme.of(context);
    var image = (product.images != null && product.images.isNotEmpty)
        ? NetworkImage(product.images.first.address)
        : AssetImage(CommerceImage.placeHolder().address);

    return BaseProductTile(
      onClick: () {
        Navigator.of(context).pushNamed(hoscoRoutes.product,
            arguments: ProductDetailsParameters(product.id, catId));
      },
      // bottomRoundButton: _getFavoritesButton(onFavoritesClick),
      bottomRoundButton: null,
      inactiveMessage:
          product.amountAvailable == null || product.amountAvailable > 0
              ? null
              : '', //'Sorry, this item is currently sold out',
      image: image,
      imageWidth: 200.0,
      imageHeight: 200.0,
      mainContentBuilder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //buildRating(context),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 3.5),
              child: Text(
                  product.title != null
                      ? (product.title.length > 25
                          ? product.title.substring(0, 25) + '...'
                          : product.title)
                      : '',
                  //style: Theme.of(context).textTheme.display1)
                  style: Theme.of(context).textTheme.display1.copyWith(
                        fontSize: 16.0,
                        letterSpacing: -1.0,
                        height: 1.0,
                      )),
            ),

            Row(
              children: [
                //Row(children: [
                Text(
                  product.price != null
                      ? NumberFormat.currency(
                                  locale: AppSettings.locale, symbol: 'đ')
                              .format(product.price) +
                          ' / ' +
                          product.unit
                      : '',
                  // product.price != null
                  //     ? NumberFormat.currency(
                  //             locale: AppSettings.locale, symbol: 'đ')
                  //         .format(product.price)
                  //     : '',
                  style: _theme.textTheme.display3.copyWith(
                    decoration: product.hasDiscountPrice
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    fontSize: 16.0,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 4.0,
                ),
                product.hasDiscountPrice
                    ? Container(
                        child: Text(
                            NumberFormat.currency(locale: AppSettings.locale)
                                .format(product
                                    .discountPrice), //'\$' + discountPrice.toStringAsFixed(0),
                            style: _theme.textTheme.display3.copyWith(
                              color: _theme.errorColor,
                            )))
                    : Container(),
                //])
              ],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              TextButton(
                  child: Text('Thêm giỏ hàng',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.all(8)),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.red),
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              side: BorderSide(color: Colors.redAccent)))),
                  onPressed: () async {
                    AddProductToCartUseCase addProductToCartUseCase = sl();
                    await addProductToCartUseCase.execute(CartItem(
                        product: product,
                        productQuantity: ProductQuantity(1),
                        selectedAttributes:
                            HashMap<ProductAttribute, String>()));
                    //HomeBloc().add(HomeLoadEvent());

                    GetCartProductsUseCase getCartProductsUseCase = sl();
                    final cartResults = await getCartProductsUseCase
                        .execute(GetCartProductParams());
                    int total = 0;
                    for (int i = 0; i < cartResults.cartItems.length; i++) {
                      total +=
                          cartResults.cartItems[i].productQuantity.quantity;
                    }

                    setState(() {
                      cartNum = total;
                    });
                  }),
              SizedBox(width: 10),
              ElevatedButton(
                  child: Text('Mua ngay', style: TextStyle(fontSize: 11)),
                  style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.black54),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                              side: BorderSide(color: Colors.black12)))),
                  onPressed: () async {
                    AddProductToCartUseCase addProductToCartUseCase = sl();
                    await addProductToCartUseCase.execute(CartItem(
                        product: product,
                        productQuantity: ProductQuantity(1),
                        selectedAttributes:
                            HashMap<ProductAttribute, String>()));
                    //HomeBloc().add(HomeLoadEvent());

                    GetCartProductsUseCase getCartProductsUseCase = sl();
                    final cartResults = await getCartProductsUseCase
                        .execute(GetCartProductParams());
                    int total = 0;
                    for (int i = 0; i < cartResults.cartItems.length; i++) {
                      total +=
                          cartResults.cartItems[i].productQuantity.quantity;
                    }

                    setState(() {
                      cartNum = total;
                    });
                    await Navigator.pushNamed(context, hoscoRoutes.cart);
                  })
            ]),
          ],
        );
      },
      // specialMark: specialMark
    );
  }

  Widget _buildSuggestions() {
    if (searchPattern != null) {
      _suggestionBloc.fetchSuggestions(0, searchPattern, true);
    }

    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      controller: _scrollController,
      slivers: [
        SliverPersistentHeader(
          pinned: true,
          delegate: SliverAppBarDelegate(
            minHeight: 50.0,
            maxHeight: 50.0,
            //child: _buildSearchField(context),
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(14, 10, 14, 10),
              child: CupertinoTextField(
                prefix: Icon(CupertinoIcons.search),
                textInputAction: TextInputAction.done,
                autocorrect: true,
                placeholder: 'Tìm kiếm',
                clearButtonMode: OverlayVisibilityMode.editing,
                maxLength: 40,
                //padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                onChanged: (String value) {
                  setState(() {
                    searchPattern = value;
                  });
                },
                onSubmitted: (String value) {
                  setState(() {
                    searchPattern = value;
                  });
                },
              ),
            ),
          ),
        ),
        StreamBuilder(
          stream: _suggestionBloc.suggestionStream,
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              final items = snapshot.data;
              return isListViewState
                  ? SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        //SliverGridDelegateWithMaxCrossAxisExtent(
                        mainAxisSpacing: 6.0,
                        crossAxisSpacing: 6.0,
                        //maxCrossAxisExtent: 200.0,
                        childAspectRatio:
                            .8, //AppSizes.tile_width / AppSizes.tile_height,
                        crossAxisCount: 2,
                      ),
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        Product prod = items[index];
                        return _buildRow(prod, '0', isListViewState);
                      }, childCount: items.length))
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (_, int index) {
                          Product prod = items[index];
                          return _buildRow(prod, '0', isListViewState);
                        },
                        childCount: items.length,
                      ),
                    );
            } else {
              return SliverFillRemaining(
                child: Center(
                  child: LoadingView(),
                ),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _getAddToCartButton(Product prod) {
    return Container(
        width: 30.0,
        height: 30.0,
        child: FloatingActionButton(
            heroTag: '' +
                math.Random()
                    .nextInt(1000000)
                    .toString(), //TODO make sure that there is only one product with specified id on screen and use it as a tag
            mini: true,
            backgroundColor: AppColors.white,
            onPressed: () async {
              AddProductToCartUseCase addProductToCartUseCase = sl();
              await addProductToCartUseCase.execute(CartItem(
                  product: prod,
                  productQuantity: ProductQuantity(1),
                  selectedAttributes: HashMap<ProductAttribute, String>()));
              //HomeBloc().add(HomeLoadEvent());

              GetCartProductsUseCase getCartProductsUseCase = sl();
              final cartResults =
                  await getCartProductsUseCase.execute(GetCartProductParams());
              int total = 0;
              for (int i = 0; i < cartResults.cartItems.length; i++) {
                total += cartResults.cartItems[i].productQuantity.quantity;
              }

              setState(() {
                cartNum = total;
              });
            },
            child: Icon(
              FontAwesomeIcons.shoppingBag,
              color: AppColors.darkGray,
              size: 13.0,
            )));
  }
}

class SuggestionBloc {
  final _suggestions = <Product>[];
  int _totalPage = 0;
  int _totalCount = 0;

  final StreamController<List<Product>> _suggestionController =
      StreamController<List<Product>>();

  Stream<List<Product>> get suggestionStream => _suggestionController.stream;

  int get totalPage => _totalPage;
  int get totalCount => _totalCount;

  void fetchSuggestions(int page, String patternSearch, bool reset) async {
    ProductRepository productRepository = sl();
    var prods = await productRepository.getRawProducts(
        searchPattern: patternSearch, pageIndex: page, pageSize: 20);
    _totalPage = prods.paging['TotalPage'];
    _totalCount = prods.paging['TotalCount'];
    //await Future.delayed(Duration(seconds: 2));
    if (reset) {
      _suggestions.clear();
    }
    if (!_suggestionController.isClosed) {
      _suggestions.addAll(prods.data.take(AppConsts.page_size));
      _suggestionController.sink.add(_suggestions);
    }
  }

  void dispose() {
    _suggestionController.close();
    _suggestions.clear();
  }
}

class FloatAppBar extends StatelessWidget with PreferredSizeWidget {
  final SuggestionBloc seachBloc;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  FloatAppBar(this.seachBloc);

  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);
    return Stack(
      children: <Widget>[
        Positioned(
          top: 7,
          right: 15,
          left: 15,
          bottom: 1,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  offset: Offset(5.0, 5.0),
                  blurRadius: 5.0,
                  color: Colors.black87.withOpacity(0.05),
                ),
              ],
            ),
            child: Row(
              children: <Widget>[
                // Material(
                //   type: MaterialType.transparency,
                //   child: IconButton(
                //     splashColor: Colors.grey,
                //     icon: Icon(Icons.menu),
                //     onPressed: () {
                //       Scaffold.of(context).openDrawer();
                //     },
                //   ),
                // ),
                Expanded(
                  child: TextField(
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.go,
                    style: _theme.textTheme.subtitle2,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 14),
                        hintText: 'Tìm kiếm...'),
                    onSubmitted: (val) {
                      seachBloc.fetchSuggestions(2, '', false);
                    },
                  ),
                ),
                // Spacer(),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    print('val');
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
