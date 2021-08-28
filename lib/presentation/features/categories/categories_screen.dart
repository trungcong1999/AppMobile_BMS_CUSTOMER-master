// Category list screen
// Author: openflutterproject@gmail.com
// Date: 2020-02-06

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hosco/config/routes.dart';
import 'package:hosco/presentation/features/wrapper.dart';
import 'package:hosco/presentation/widgets/independent/loading_view.dart';
import 'package:hosco/presentation/widgets/widgets.dart';

import 'categories.dart';

class CategoriesScreen extends StatefulWidget {
  final CategoriesParameters parameters;

  const CategoriesScreen({Key key, this.parameters}) : super(key: key);

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class CategoriesParameters {
  final String categoryId;

  const CategoriesParameters(this.categoryId);
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    print('widget parameters at categories screen ${widget.parameters}');
    return SafeArea(
        child: BlocProvider<CategoryBloc>(
            create: (context) {
              return CategoryBloc()
                ..add(CategoryShowListEvent(widget.parameters == null
                    ? '0'
                    : widget.parameters.categoryId));
            },
            child: CategoriesWrapper()));
  }
}

class CategoriesWrapper extends StatefulWidget {
  @override
  _CategoriesWrapperState createState() => _CategoriesWrapperState();
}

class _CategoriesWrapperState
    extends OpenFlutterWrapperState<CategoriesWrapper> {

  int cartNum = 0;

  @override
  @protected
  @mustCallSuper
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CategoryBloc, CategoryState>(
        child: getPageView(<Widget>[
          LoadingView(),
          buildListScreen(context),
          CategoriesTileView(changeView: changePage),
        ]),
        listenWhen: (CategoryState bloc, CategoryState state) {
          if(state is CategoryListViewState) {
            setState(() {
              cartNum = state.cartTotal??0;
            });
          }
        },
        listener: (BuildContext context, CategoryState state) {
          final index = state is CategoryLoadingState
              ? 0
              : state is CategoryListViewState ? 1 : 2;
          changePage(changeType: ViewChangeType.Exact, index: index);
        });
  }

  Widget buildListScreen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Nhóm sản phẩm'),
          //bottom: tabWidget,
          actions: <Widget>[
            _shoppingCartBadge()
        ]),
      body: CategoriesListView(cartTotal: cartNum),
      bottomNavigationBar: OpenFlutterBottomMenu(1),
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
      child: IconButton(icon: Icon(Icons.shopping_cart), onPressed: () {
        Navigator.pushNamed(context, hoscoRoutes.cart);
      }, color: Colors.teal,),
    );
  }
}
