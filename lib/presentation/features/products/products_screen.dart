// Produt List Screen
// Author: openflutterproject@gmail.com
// Date: 2020-02-06

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
import 'package:hosco/data/model/category.dart';
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
import 'package:hosco/presentation/widgets/independent/search_bar.dart';
import 'package:hosco/presentation/widgets/widgets.dart';

class ProductsScreen extends StatefulWidget {
  final ProductListScreenParameters parameters;

  const ProductsScreen({Key key, this.parameters}) : super(key: key);

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class ProductListScreenParameters {
  final ProductCategory category;
  final int cartTotal;

  ProductListScreenParameters(this.category, this.cartTotal);
}

class _ProductsScreenState extends State<ProductsScreen> {//with AutomaticKeepAliveClientMixin<ProductsScreen>{

  int cartNum = 0;
  int page = 0;
  String searchPattern;
  final _scrollController = ScrollController();
  final _suggestionBloc = SuggestionBloc();

  bool isListViewState = AppSettings.isListViewState;

  @override
  bool get wantKeepAlive => true;

  @override
  @protected
  @mustCallSuper
  void initState() {
    _suggestionBloc.fetchSuggestions(widget.parameters.category?.id??'0', 0, '', false);
    _scrollController.addListener(_scrollListener);
    cartNum = widget.parameters.cartTotal;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _suggestionBloc.dispose();
  }

  void _scrollListener() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (currentScroll == maxScroll && page <= _suggestionBloc.totalPage) {
      _suggestionBloc.fetchSuggestions(widget.parameters.category?.id??'0', ++page, searchPattern, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if(searchPattern != null) {
      _suggestionBloc.fetchSuggestions(widget.parameters.category?.id??'0', 0, searchPattern, true);
    }
    //cartNum = _suggestionBloc.cartTotal;

    return SafeArea(
      child: OpenFlutterScaffold(
        background: null,
        title: null, //widget.parameters.category?.name??'',
        body: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          slivers: [
            CupertinoSliverNavigationBar(
              // padding: EdgeInsetsDirectional.fromSTEB(5, 0, 5, 0),
              leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black,),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
              largeTitle: Text(widget.parameters.category?.name??'',),
              middle: Center(
                child: OpenFlutterSearchBar(searchKey: searchPattern, onChange: (val) {
                  setState(() {
                    searchPattern = val;
                  });
                } ,),
              ),
              trailing: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CupertinoButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () {
                        setState(() {
                          isListViewState = !isListViewState;
                        });
                      },
                      child: Icon(
                        isListViewState ? Icons.view_list : Icons.view_module,
                        color: CupertinoColors.black,
                        size: 24,
                      )
                  ),
                  _shoppingCartBadge()
                ],
              ),
            ),

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

            /*
            SizeChangingAppBar(
              title: widget.parameters.category?.name??'',
              filterRules: FilterRules(selectedHashTags: null, hashTags: []),
              //sortRules: state.sortBy,
              //isListView: state is ProductsListViewState,
              onFilterRulesChanged: (filter) {
                BlocProvider.of<ProductsBloc>(context)
                    .add(ProductChangeFilterRulesEvent(filter));
              },
              onSortRulesChanged: (sort) {
                BlocProvider.of<ProductsBloc>(context)
                    .add(ProductChangeSortRulesEvent(sort));
              },
              onViewChanged: () {
                setState(() {
                  isListViewState = !isListViewState;
                });
              },
            ),
            */
            StreamBuilder(
              stream: _suggestionBloc.suggestionStream,
              builder: (_, snapshot) {
                if (snapshot.hasData) {
                  final items = snapshot.data;
                  return isListViewState ? SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount( //SliverGridDelegateWithMaxCrossAxisExtent(
                        mainAxisSpacing: 6.0,
                        crossAxisSpacing: 6.0,
                        childAspectRatio: AppSizes.tile_width / AppSizes.tile_height,
                        crossAxisCount: 2,
                      ),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        Product prod = items[index];
                        return _buildRow(prod, widget.parameters.category?.id??'0', isListViewState);
                      },
                      childCount: items.length
                    )
                  ) : SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (_, int index) {
                            Product prod = items[index];
                        return _buildRow(prod, widget.parameters.category?.id??'0', isListViewState);
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
        ),
        /*
        body: BlocProvider<ProductsBloc>(
            create: (context) {
              return ProductsBloc(
                  category: widget.parameters.category, pageIndex: page)
                ..add(ScreenLoadedEvent());
            },
            child: BlocConsumer<ProductsBloc, ProductsState>(
              listener: (context, state) {
                if (state.hasError) {
                  ErrorDialog.showErrorDialog(context, state.error);
                }
              },
              builder: (context, state) {
                return CustomScrollView(
                  //controller: _scrollController,
                  slivers: <Widget>[
                    SizeChangingAppBar(
                      title: state.data?.category?.name??'',
                      filterRules: state.filterRules,
                      sortRules: state.sortBy,
                      isListView: state is ProductsListViewState,
                      onFilterRulesChanged: (filter) {
                        BlocProvider.of<ProductsBloc>(context)
                            .add(ProductChangeFilterRulesEvent(filter));
                      },
                      onSortRulesChanged: (sort) {
                        BlocProvider.of<ProductsBloc>(context)
                            .add(ProductChangeSortRulesEvent(sort));
                      },
                      onViewChanged: () {
                        BlocProvider.of<ProductsBloc>(context)
                            .add(ProductsChangeViewEvent());
                      },
                    ),
                    /*
                    state is ProductsListViewState
                        ? ProductsListView()
                        : ProductsTileView(),*/
                  ],
                );
              },
            )),
        */bottomMenuIndex: 1,
      )
    );
  }

  Widget _buildRow(Product product, String catId, bool isListViewState) {
    var _theme = Theme.of(context);
    var image = (product.images != null && product.images.isNotEmpty)
    ? NetworkImage(product.images.first.address)
        : AssetImage(CommerceImage.placeHolder().address);

    return isListViewState ? BaseProductTile(
      onClick: () {
        Navigator.of(context).pushNamed(
            hoscoRoutes.product,
            arguments: ProductDetailsParameters(
                product.id,
                catId));
      },
        //bottomRoundButton: _getAddToCartButton(product),
        inactiveMessage: product.amountAvailable == null || product.amountAvailable > 0
            ? null
            : '',// 'Hết hàng',// 'Sorry, this item is currently sold out',
        image: image,
        imageWidth: 200.0,
        imageHeight: 180.0,
        mainContentBuilder: (context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //buildRating(context),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 2.5),
                child: Text(product.title != null ? (product.title.length > 25 ? product.title.substring(0, 25) + '...' : product.title ) : '',
                    style: Theme.of(context).textTheme.headline4.copyWith(
                      fontSize: 12.0, height: 1.0, letterSpacing: -1.0
                    )),
              ),
              Row(
                children: [
                  //Row(children: [
                    Text(
                      product.price != null ? NumberFormat.currency(locale: AppSettings.locale, symbol: 'đ').format(product.price) : '',
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
                    product.hasDiscountPrice ? Container( child: Text(NumberFormat.currency(locale: AppSettings.locale, symbol: 'đ').format(product.discountPrice), //'\$' + discountPrice.toStringAsFixed(0),
                        style: _theme.textTheme.display3.copyWith(
                            color: _theme.errorColor
                        ))) : Container(),
                  //])
                ],
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextButton(
                        child: Text(
                            'Thêm giỏ hàng',
                          style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold)
                        ),
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(8)),
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
                            backgroundColor: MaterialStateProperty.all(Colors.red),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    side: BorderSide(color: Colors.redAccent)
                                )
                            )
                        ),
                        onPressed: () async {
                          AddProductToCartUseCase addProductToCartUseCase = sl();
                          await addProductToCartUseCase.execute(CartItem(
                              product: product,
                              productQuantity: ProductQuantity(1),
                              selectedAttributes: HashMap<ProductAttribute, String>()
                          ));
                          //HomeBloc().add(HomeLoadEvent());

                          GetCartProductsUseCase getCartProductsUseCase = sl();
                          final cartResults = await getCartProductsUseCase.execute(GetCartProductParams());
                          int total = 0;
                          for(int i = 0; i < cartResults.cartItems.length; i++) {
                            total += cartResults.cartItems[i].productQuantity.quantity;
                          }

                          setState(() {
                            cartNum = total;
                          });
                        }
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                        child: Text(
                            'Mua ngay',
                            style: TextStyle(fontSize: 11)
                        ),
                        style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.black54),
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                    side: BorderSide(color: Colors.black12)
                                )
                            )
                        ),
                        onPressed: () async {
                          AddProductToCartUseCase addProductToCartUseCase = sl();
                          await addProductToCartUseCase.execute(CartItem(
                              product: product,
                              productQuantity: ProductQuantity(1),
                              selectedAttributes: HashMap<ProductAttribute, String>()
                          ));
                          //HomeBloc().add(HomeLoadEvent());

                          GetCartProductsUseCase getCartProductsUseCase = sl();
                          final cartResults = await getCartProductsUseCase.execute(GetCartProductParams());
                          int total = 0;
                          for(int i = 0; i < cartResults.cartItems.length; i++) {
                            total += cartResults.cartItems[i].productQuantity.quantity;
                          }

                          setState(() {
                            cartNum = total;
                          });
                          await Navigator.pushNamed(context, hoscoRoutes.cart);
                        }
                    )
                  ]
              ),
            ],
          );
        },
        // specialMark: specialMark
    ) : BaseProductListItem(
        onClick: () {
          Navigator.of(context).pushNamed(
              hoscoRoutes.product,
              arguments: ProductDetailsParameters(
                  product.id,
                  catId));
        },
        //bottomRoundButton: _getAddToCartButton(product),
        image: image,
        imageHeight: 130.0,
        mainContentBuilder: (context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(product.title.length > 25 ? product.title.substring(0, 25) + '...' : product.title , style: Theme.of(context).textTheme.display1),
              Text(product.subTitle, style: Theme.of(context).textTheme.body1),
              //buildRating(context),
              //buildPrice(Theme.of(context)),
              Row(children: <Widget>[
                Text(
                  product.price != null ? NumberFormat.currency(locale: AppSettings.locale, symbol: 'đ').format(product.price) : '',
                  style: Theme.of(context).textTheme.display3.copyWith(
                    decoration: TextDecoration.none,
                    fontSize: 16.0,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 4.0,
                ),
                //hasDiscountPrice ? buildDiscountPrice(_theme) : Container(),
              ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextButton(
                        child: Text(
                            'Thêm giỏ hàng',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)
                        ),
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(8)),
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
                            backgroundColor: MaterialStateProperty.all(Colors.red),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    side: BorderSide(color: Colors.redAccent)
                                )
                            )
                        ),
                        onPressed: () async {
                          AddProductToCartUseCase addProductToCartUseCase = sl();
                          await addProductToCartUseCase.execute(CartItem(
                              product: product,
                              productQuantity: ProductQuantity(1),
                              selectedAttributes: HashMap<ProductAttribute, String>()
                          ));
                          //HomeBloc().add(HomeLoadEvent());

                          GetCartProductsUseCase getCartProductsUseCase = sl();
                          final cartResults = await getCartProductsUseCase.execute(GetCartProductParams());
                          int total = 0;
                          for(int i = 0; i < cartResults.cartItems.length; i++) {
                            total += cartResults.cartItems[i].productQuantity.quantity;
                          }

                          setState(() {
                            cartNum = total;
                          });
                        }
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                        child: Text(
                            'Mua ngay',
                            style: TextStyle(fontSize: 11)
                        ),
                        style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.black54),
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                    side: BorderSide(color: Colors.black12)
                                )
                            )
                        ),
                        onPressed: () async {
                          AddProductToCartUseCase addProductToCartUseCase = sl();
                          await addProductToCartUseCase.execute(CartItem(
                              product: product,
                              productQuantity: ProductQuantity(1),
                              selectedAttributes: HashMap<ProductAttribute, String>()
                          ));
                          //HomeBloc().add(HomeLoadEvent());

                          GetCartProductsUseCase getCartProductsUseCase = sl();
                          final cartResults = await getCartProductsUseCase.execute(GetCartProductParams());
                          int total = 0;
                          for(int i = 0; i < cartResults.cartItems.length; i++) {
                            total += cartResults.cartItems[i].productQuantity.quantity;
                          }

                          setState(() {
                            cartNum = total;
                          });
                          await Navigator.pushNamed(context, hoscoRoutes.cart);
                        }
                    )
                  ]
              )
            ],
          );
        }
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
              selectedAttributes: HashMap<ProductAttribute, String>()
          ));

          GetCartProductsUseCase getCartProductsUseCase = sl();
          final cartResults = await getCartProductsUseCase.execute(GetCartProductParams());
          int total = 0;
          for(int i = 0; i < cartResults.cartItems.length; i++) {
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
        )
      )
    );
  }

  Widget _shoppingCartBadge() {
    return Badge(
      position: BadgePosition.topEnd(top: 0, end: 3),
      animationDuration: Duration(milliseconds: 300),
      animationType: BadgeAnimationType.slide,
      badgeContent: Text(
        '$cartNum',
        style: TextStyle(color: Colors.white),
      ),
      child: IconButton(icon: Icon(Icons.shopping_cart),
          color: Colors.teal,
          onPressed: () {
            Navigator.pushNamed(context, hoscoRoutes.cart);
      }),
    );
  }
}

class SuggestionBloc {
  final _suggestions = <Product>[];
  int _totalPage = 0;
  int _totalCount = 0;
  int _cartTotal = 0;

  final StreamController<List<Product>> _suggestionController = StreamController<List<Product>>();
  final _loadNextController = StreamController<bool>();

  Stream<List<Product>> get suggestionStream => _suggestionController.stream;

  Stream<bool> get isLoadingNext => _loadNextController.stream;

  int get totalPage => _totalPage;

  int get totalCount => _totalCount;

  int get cartTotal => _cartTotal;

  void fetchSuggestions(String categoryId, int page, String patternSearch, bool reset) async {
    GetCartProductsUseCase getCartProductsUseCase = sl();
    final cartResults = await getCartProductsUseCase.execute(GetCartProductParams());
    for(int i = 0; i < cartResults.cartItems.length; i++) {
      _cartTotal += cartResults.cartItems[i].productQuantity.quantity;
    }

    ProductRepository productRepository = sl();
    var prods = await productRepository.getRawProducts(searchPattern: patternSearch,
        categoryId: categoryId,
        pageIndex: page, pageSize: AppConsts.page_size);
    _totalPage = prods.paging['TotalPage'];
    _totalCount = prods.paging['TotalCount'];
    //await Future.delayed(Duration(seconds: 2));
    if(reset) {
      _suggestions.clear();
    }
    _suggestions.addAll(prods.data.take(AppConsts.page_size));
    _suggestionController.sink.add(_suggestions);
  }

  void dispose() {
    _suggestionController.close();
    _suggestions.clear();
    _loadNextController.close();
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