// Home Screen View #2: small top banner, list of products sale and new
// Author: openflutterproject@gmail.com
// Date: 2020-02-06

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hosco/config/routes.dart';
import 'package:hosco/config/server_addresses.dart';
import 'package:hosco/config/storage.dart';
import 'package:hosco/config/theme.dart';
import 'package:hosco/data/error/exceptions.dart';
import 'package:hosco/data/local/news/service_news.dart';
import 'package:hosco/data/model/article_news.dart';
import 'package:hosco/data/model/product.dart';
import 'package:hosco/presentation/features/categories/categories.dart';
import 'package:hosco/presentation/features/endows/endow.dart';
import 'package:hosco/presentation/features/home/views/header_home.dart';
import 'package:hosco/presentation/features/news/news_screen.dart';
import 'package:hosco/presentation/features/news/views/trending_container.dart';
import 'package:hosco/presentation/features/notification/notification_screen.dart';
import 'package:hosco/presentation/features/product_details/product_screen.dart';
import 'package:hosco/presentation/widgets/independent/loading_view.dart';
import 'package:hosco/presentation/widgets/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Main2View extends StatefulWidget {
  final Function changeView;
  final List<Product> products;

  const Main2View({
    Key key,
    this.changeView,
    this.products,
  }) : super(key: key);

  @override
  _Main2ViewState createState() => _Main2ViewState();
}

class _Main2ViewState extends State<Main2View> {
  Future<dynamic> fetchData() async {
    var customerID = Storage().account?.id;
    final response = await http.get(
      ServerAddresses.getCurrentPoint + '/' + customerID,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + Storage().token
      },
    );

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      return json['data'];
    } else {
      throw HttpRequestException();
    }
  }

  Future<List<dynamic>> _postData() async {
    final String url =
        'http://api.phanmembanhang.com/api/Category/ProductListLoyalty';
    final msg = jsonEncode({
      'ProductName': '',
      'ProductCode': '',
      'Description': '',
      'Visible': true,
      'Instock': 0,
      'ProductGroup': '7e80863f-1500-4fe9-ab89-1586dc85e967',
      'PageSize': 10,
      'PageIndex': 0
    });
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ' + Storage().token
        },
        body: msg);
    // print('${response.statusCode}');
    if (response.statusCode == 200) {
      var body = json.decode(response.body)['data'];

      return body;
    } else {
      //throw HttpRequestException();
      throw HttpRequestException();
    }
  }

  Future<dynamic> fetchGetCustomerInfo() async {
    var customerID = Storage().account?.id;
    final response = await http.get(
      ServerAddresses.getCustomerInfo + '/' + customerID,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + Storage().token
      },
    );

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      return json['data'];
    } else {
      throw HttpRequestException();
    }
  }

  ServiceNews client = ServiceNews();
  // Future<List<dynamic>> getDataNews() async {
  //   var response = await http.get(
  //     ServerAddresses.getHotNews,
  //     headers: {
  //       'Content-Type': 'application/json; charset=UTF-8',
  //       'Authorization': 'Bearer ' + Storage().token
  //     },
  //   );
  //   if (response.statusCode == 200) {
  //     var json = jsonDecode(response.body);
  //     return json['data'];
  //   } else {
  //     throw HttpRequestException();
  //   }
  // }

  @override
  void initState() {
    fetchData();
    _postData();
    fetchGetCustomerInfo();
    // getDataNews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);
    var width = MediaQuery.of(context).size.width;
    var widgetWidth = width - AppSizes.sidePadding * 2;

    return SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
          _buildTopStack(),
          SizedBox(
            height: 50,
          ),
          OpenFlutterBlockHeader(
            width: widgetWidth,
            title: 'Sản phẩm nổi bật',
            // linkText: 'Xem thêm',
            // onLinkTap: () => {
            //   Navigator.of(context).pushNamed(hoscoRoutes.shop,
            //       arguments: CategoriesParameters('2'))
            // },
            description: '',
          ),
          _buildProductList(context),
          Padding(padding: EdgeInsets.only(top: AppSizes.sidePadding)),
          OpenFlutterBlockHeader(
            width: widgetWidth,
            title: 'Tin tức nổi bật',
            linkText: 'Xem thêm',
            onLinkTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => NewsScreen()));
            },
            description: '',
          ),
          _buildEndowList(context),
          OpenFlutterBlockHeader(
            width: widgetWidth,
            title: 'Ưu đãi nổi bật',
            linkText: 'Xem thêm',
            onLinkTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => EndowsScreen()));
            },
            description: '',
          ),
          _buildFeatureList(context),
          Padding(padding: EdgeInsets.only(top: 70)),
        ]));
  }

  Stack _buildTopStack() {
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      overflow: Overflow.visible,
      children: [
        _buildBackgroundCover(),
        _buildGreetings(),
        _buildMoodsHolder(),
      ],
    );
  }

  _buildBackgroundCover() {
    return Container(
      height: 150.0,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
    );
  }

  _buildGreetings() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            backgroundImage:
                                NetworkImage(Storage().account?.avatar),
                            radius: 35,
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                Storage().account?.name ?? '',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              child: Row(
                                children: [
                                  FutureBuilder(
                                    future: fetchGetCustomerInfo(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        final item = snapshot.data;
                                        return Text(
                                          '${item['GroupName']} |',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        );
                                      } else {
                                        return Text(
                                          'Khách lẻ |',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        );
                                      }
                                    },
                                  ),
                                  FutureBuilder(
                                      future: fetchData(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot snapshot) {
                                        // print(snapshot.data);
                                        if (snapshot.hasData) {
                                          var number = snapshot.data;

                                          return Text(' ${format(number)}',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12));
                                        } else {
                                          return Text(' 0',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12));
                                        }
                                      }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // SizedBox(width: 130,),

            // Stack(
            //   children: [
            //     NotificationIcon(
            //       text: '',
            //       iconData: Icons.notifications,
            //       notificationCount: 11,
            //       onTap: () {
            //         Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //                 builder: (context) => NotificationScreenView()));
            //       },
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  _buildMoodsHolder() {
    return Positioned(
      bottom: -35,
      child: Container(
        height: 100,
        width: MediaQuery.of(context).size.width - 30,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15)),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                spreadRadius: 5.5,
                blurRadius: 5.5,
              )
            ]),
        child: Moods(),
      ),
    );
  }

  Widget _buildProductList(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2.4,
      width: MediaQuery.of(context).size.width,
      child: FutureBuilder(
        future: _postData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState != ConnectionState.waiting &&
              snapshot.hasData) {
            final list = snapshot.data;
            return ListView.builder(
              primary: false,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              // itemCount: restaurants == null
              //     ? 0
              //     : (restaurants.length > 10 ? 10 : restaurants.length),
              itemCount:
                  list == null ? 0 : (list.length > 10 ? 10 : list.length),
              itemBuilder: (BuildContext context, int index) {
                final restaurant = list[index];
                final price = restaurant['Price'];
                return Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Padding(
                      padding: EdgeInsets.only(top: 0.0, bottom: 0.0),
                      child: Container(
                        height: MediaQuery.of(context).size.height / 2.9,
                        width: MediaQuery.of(context).size.width / 1.8,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed(hoscoRoutes.product,
                                arguments: ProductDetailsParameters(
                                    restaurant['Id'], '0'));
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            elevation: 3.0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Stack(
                                  children: <Widget>[
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              3.7,
                                      width: MediaQuery.of(context).size.width,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10.0),
                                          topRight: Radius.circular(10.0),
                                        ),
                                        child: (restaurant['Picture']
                                                    .isNotEmpty &&
                                                restaurant['Picture'] != null)
                                            ? Image.network(
                                                '${restaurant['Picture']}')
                                            : Image.asset(
                                                'assets/placeholder.png'),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5.0),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 2),
                                  child: Container(
                                    constraints:
                                        BoxConstraints(maxWidth: 200),
                                    width: MediaQuery.of(context).size.width,
                                    child: Text(
                                       restaurant['Name']??'',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w800,
                                      ),
                                      textAlign: TextAlign.left,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 2),
                                  child: Container(
                                    constraints:
                                        BoxConstraints(maxWidth: 200),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          NumberFormat.currency(
                                                  locale: 'vi', symbol: 'đ')
                                              .format(restaurant['Price']),
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        // IconButton(
                                        //   onPressed: () {
                                        //     print('hello');
                                        //   },
                                        //   icon: Icon(Icons.add_circle_sharp),
                                        //   color: Colors.red,
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5.0),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ));
              },
            );
          } else {
            return LoadingView();
          }
        },
      ),
    );
  }

  Widget _buildEndowList(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2.72,
      width: MediaQuery.of(context).size.width,
      child: FutureBuilder(
        future: client.getDataNews(2),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            List<ArticleNews> articles = snapshot.data;
            return ListView.builder(
              primary: false,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: articles == null
                  ? 0
                  : (articles.length > 10 ? 10 : articles.length),
              itemBuilder: (context, index) =>
                  TrendingContainer(articles[index], context),
            );
          } else {
            return LoadingView();
          }
        },
      ),
    );
  }

  Widget _buildFeatureList(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2.72,
      width: MediaQuery.of(context).size.width,
      child: FutureBuilder(
        future: client.getDataNews(3),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            List<ArticleNews> articlesFeature = snapshot.data;
            return ListView.builder(
              primary: false,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: articlesFeature == null
                  ? 0
                  : (articlesFeature.length > 10 ? 10 : articlesFeature.length),
              itemBuilder: (context, index) =>
                  TrendingContainer(articlesFeature[index], context),
            );
          } else {
            return LoadingView();
          }
        },
      ),
    );
  }
}

String format(double n) {
  return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 2);
}

class NotificationIcon extends StatelessWidget {
  final IconData iconData;
  final String text;
  final VoidCallback onTap;
  final int notificationCount;
  const NotificationIcon({
    Key key,
    @required this.iconData,
    @required this.text,
    this.onTap,
    this.notificationCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 72,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  iconData,
                  size: 30,
                  color: Colors.white,
                ),
                Text(text, overflow: TextOverflow.ellipsis),
              ],
            ),
            Positioned(
              top: 0,
              right: -1,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.yellow),
                alignment: Alignment.center,
                child: Text(
                  '$notificationCount',
                  style: TextStyle(color: Colors.blue[700]),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
