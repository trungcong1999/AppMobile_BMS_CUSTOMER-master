
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hosco/config/routes.dart';
import 'package:hosco/config/theme.dart';
import 'package:hosco/data/model/category.dart';
import 'package:hosco/presentation/features/products/products.dart';

import '../categories.dart';
import '../categories_bloc.dart';
import '../categories_event.dart';
import '../categories_state.dart';

class CategoriesListView extends StatefulWidget {
  final int cartTotal;

  const CategoriesListView({Key key, this.cartTotal}) : super(key: key);

  @override
  _CategoriesListViewState createState() => _CategoriesListViewState();
}

class _CategoriesListViewState extends State<CategoriesListView> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var widgetWidth = width - AppSizes.sidePadding * 4;
    var _theme = Theme.of(context);
    return BlocListener<CategoryBloc, CategoryState>(
        listener: (context, state) {
      if (state is CategoryErrorState) {
        return Container(
            padding: EdgeInsets.all(AppSizes.sidePadding),
            child: Text('An error occured',
                style: _theme.textTheme.display1
                    .copyWith(color: _theme.errorColor)));
      }
      return Container();
    }, child:
            BlocBuilder<CategoryBloc, CategoryState>(builder: (context, state) {
      if (state is CategoryListViewState) {
        return Container( //SingleChildScrollView
          child: Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: AppSizes.sidePadding)),
              /*OpenFlutterButton(
                onPressed: (() => {
                      BlocProvider.of<CategoryBloc>(context)
                          .add(CategoryShowTilesEvent('0')),
                    }),
                title: 'VIEW ALL ITEMS',
                width: widgetWidth,
                height: 50.0,
              ),*/
              Padding(
                padding: EdgeInsets.only(
                  top: AppSizes.sidePadding,
                ),
              ),
              Expanded(
                  child: Padding(
                      padding: EdgeInsets.only(top: 0,bottom: 4,left: 6,right: 6),
                      child: GridView.count(
                          crossAxisCount: 3,
                          childAspectRatio: 1.0,
                          // padding: const EdgeInsets.all(10.0),
                          mainAxisSpacing: 4.0,
                          crossAxisSpacing: 4.0,
                          shrinkWrap: true,
                          semanticChildCount: state.categories.length,
                          scrollDirection: Axis.vertical,
                          children: state.categories.map((ProductCategory item) {
                            return InkWell(
                              onTap: item.isCategoryContainer
                              ? () {
                                BlocProvider.of<CategoryBloc>(context)
                                    .add(ChangeCategoryParent(item.id));
                                }
                                    : () {
                              Navigator.of(context).pushNamed(
                              hoscoRoutes.productList,
                              arguments: ProductListScreenParameters(item, widget.cartTotal));
                              },
                                //child: OpenFlutterCatregoryListElement(category: item),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 60.0,
                                      height: 60.0,
                                      decoration:
                                      BoxDecoration(shape: BoxShape.circle, color: Colors.green[800]),
                                      child: CircleAvatar(
                                        radius: 60.0,
                                        backgroundColor: Colors.transparent,
                                        backgroundImage: item.image.isLocal ? AssetImage('assets/icons/signin/icon.png') : 
                                          NetworkImage(item.image.address)
                                        ,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(item.name)
                                  ],
                                )
                              );
                          }).toList())
                  )
              )
              // Column(
              //   children: buildCategoryList(state.categories),
              // )
            ],
          ),
        );
      }
      return Center(
        child: CircularProgressIndicator(),
      );
    }));
  }

  List<Widget> buildCategoryList(List<ProductCategory> categories) {
    var elements = <Widget>[];
    if ( categories != null ) {
      elements.add(
          Expanded(
            child: Padding(
                padding: EdgeInsets.only(top: 10,bottom: 90,left: 10,right: 10),
          child: GridView.count(
              crossAxisCount: 3,
              childAspectRatio: 1.0,
              padding: const EdgeInsets.all(10.0),
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
              shrinkWrap: true,
              semanticChildCount: categories.length,
              scrollDirection: Axis.vertical,
              children: categories.map((ProductCategory item) {
                return Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Container(
                    child: Text(item.name),
                    padding: EdgeInsets.all(20.0),
                    height: 135.0,
                    width: 135.0,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1.0,
                        color: Color(0xFFF9AD16),
                      ),
                    ),
                  ),
                );
                /*
                return InkWell(
                  onTap: item.isCategoryContainer
                  ? () {
                    BlocProvider.of<CategoryBloc>(context)
                        .add(ChangeCategoryParent(item.id));
                    }
                        : () {
                  Navigator.of(context).pushNamed(
                  hoscoRoutes.productList,
                  arguments: ProductListScreenParameters(item));
                  },
                    child: OpenFlutterCatregoryListElement(category: item),
                  );*/
              }).toList())
            )
        )
      );
/*
      for (var i = 0; i < categories.length; i++) {
        elements.add(
          InkWell(
            onTap: categories[i].isCategoryContainer
                ? () {
                    BlocProvider.of<CategoryBloc>(context)
                        .add(ChangeCategoryParent(categories[i].id));
                  }
                : () {
                    Navigator.of(context).pushNamed(
                        hoscoRoutes.productList,
                        arguments: ProductListScreenParameters(categories[i]));
                  },
            child: OpenFlutterCatregoryListElement(category: categories[i]),
          ),
        );
      }*/
    }
    return elements;
  }
}
