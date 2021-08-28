import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hosco/config/app_settings.dart';
import 'package:hosco/config/server_addresses.dart';
import 'package:hosco/config/storage.dart';
import 'package:hosco/config/theme.dart';
import 'package:hosco/data/error/exceptions.dart';
import 'package:hosco/data/local/news/service_news.dart';
import 'package:hosco/data/model/purchase_order.dart';
import 'package:hosco/presentation/features/profile/views/order_details.dart';
import 'package:hosco/presentation/widgets/independent/loading_view.dart';
import 'package:intl/intl.dart';

import '../../../../config/routes.dart';
import 'package:http/http.dart' as http;

class MyOrdersView extends StatefulWidget {
  const MyOrdersView({Key key}) : super(key: key);

  @override
  _MyOrdersViewState createState() => _MyOrdersViewState();
}

class _MyOrdersViewState extends State<MyOrdersView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final List<Widget> tabs = <Widget>[
    // Padding(
    //   padding: const EdgeInsets.symmetric(horizontal: 2),
    //   child: Tab(text: 'Chờ xử lý'),
    // ),
    // Padding(
    //   padding: const EdgeInsets.symmetric(horizontal: 2),
    //   child: Tab(text: 'Đang vận chuyển'),
    // ),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Tab(text: 'Hoàn thành'),
    ),
    // Padding(
    //   padding: const EdgeInsets.symmetric(horizontal: 2),
    //   child: Tab(text: 'Đã hủy'),
    // ),
  ];
  ServiceNews client = ServiceNews();
  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Lịch sử đơn hàng',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.red,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamed(context, hoscoRoutes.profile);
            },
          ),
        ),
        // body: DefaultTabController(
        //   length: tabs.length,
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: <Widget>[
        //       Container(
        //         padding: EdgeInsets.symmetric(horizontal: 4),
        //         child: Column(
        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //             children: <Widget>[
        //               TabBar(
        //                 indicatorSize: TabBarIndicatorSize.tab,
        //                 labelColor: AppColors.red,
        //                 indicatorColor: Colors.red,
        //                 unselectedLabelColor: AppColors.black,
        //                 isScrollable: true,
        //                 tabs: tabs,
        //                 unselectedLabelStyle: _theme.textTheme.display3,
        //                 labelStyle: TextStyle(
        //                   fontWeight: FontWeight.w700,
        //                 ),
        //               ),
        //             ]),
        //       ),
        //       Padding(padding: EdgeInsets.only(bottom: AppSizes.sidePadding)),
        //       Expanded(
        //         child: Padding(
        //           padding: EdgeInsets.symmetric(horizontal: 4),
        //           child: TabBarView(
        //             children: <Widget>[
        //               // buildOrderListProgressing(),
        //               // buildOrderListTransported(),
        //               buildOrderListComplete(),
        //               // buildOrderListCancelled(),
        //             ],
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        body: Container(
          child: SingleChildScrollView(child: buildOrderListComplete(),),
        ),
      ),
    );
  }

  Widget buildOrderListProgressing() {
    var _theme = Theme.of(context);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    DateTime now = new DateTime.now();
    return FutureBuilder(
      future: client.postPurchaseOrderData(0,DateFormat('yyyy-MM-dd').format(now).toString()),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          List<PurchaseOrderList> purchaseList = snapshot.data;
          return ListView.builder(
            primary: false,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: purchaseList.length,
            itemBuilder: (BuildContext context, int index) {
              final item = purchaseList[index];

              // final f = new DateFormat('dd-MM-yyyy');
              // final time = f.format(DateTime.parse(item.orderCode));
              
              return SingleChildScrollView(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MyOrderDetailsView(customerID: item,)));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      height: height / 5.5,
                      child: Material(
                        elevation: 14.0,
                        borderRadius: BorderRadius.circular(15),
                        shadowColor: Color(0x802196F3),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, top: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  RichText(
                                      text: TextSpan(children: <TextSpan>[
                                    TextSpan(
                                      text: 'Mã đơn: ',
                                      style: _theme.textTheme.display1,
                                    ),
                                    TextSpan(
                                      text: '#' + item.orderCode,
                                      style: _theme.textTheme.display1.copyWith(
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ])),
                                  Text(DateFormat('dd-MM-yyyy').format(item.orderDate),
                                      style: _theme.textTheme.display3
                                          .copyWith(color: AppColors.lightGray))
                                ],
                              ),
                              SizedBox(
                                height: AppSizes.sidePadding,
                              ),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    RichText(
                                        text: TextSpan(children: <TextSpan>[
                                      TextSpan(
                                        text: 'Số theo dõi: ',
                                        style: _theme.textTheme.display1
                                            .copyWith(
                                                color:
                                                    _theme.primaryColorLight),
                                      ),
                                      TextSpan(
                                        text: item.orderCode,
                                        style: _theme.textTheme.display1,
                                      ),
                                    ])),
                                    Text(
                                        item.orderStatus ??
                                            '', //orderStatus.toString().split('.')[1],
                                        style: _theme.textTheme.display1
                                            .copyWith(color: AppColors.green)),
                                  ]),
                              SizedBox(
                                height: AppSizes.sidePadding,
                              ),
                              buildSummaryLine(
                                  'Tổng tiền:',
                                  NumberFormat.currency(
                                          locale: AppSettings.locale)
                                      .format(item.totalMoney),
                                  //'\$' + state.orderData.totalPrice.toStringAsFixed(0),
                                  _theme,
                                  width),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return LoadingView();
        }
      },
    );
  }

  Widget buildOrderListTransported() {
    var _theme = Theme.of(context);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    DateTime now = new DateTime.now();
    return FutureBuilder(
      future: client.postPurchaseOrderData(1,DateFormat('yyyy-MM-dd').format(now).toString()),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          List<PurchaseOrderList> purchaseList = snapshot.data;
          return ListView.builder(
            primary: false,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: purchaseList.length,
            itemBuilder: (BuildContext context, int index) {
              final item = purchaseList[index];

              // final f = new DateFormat('dd-MM-yyyy');
              // final time = f.format(DateTime.parse(item.orderCode));
              
              return SingleChildScrollView(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MyOrderDetailsView(customerID: item,)));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      height: height / 5.5,
                      child: Material(
                        elevation: 14.0,
                        borderRadius: BorderRadius.circular(15),
                        shadowColor: Color(0x802196F3),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, top: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  RichText(
                                      text: TextSpan(children: <TextSpan>[
                                    TextSpan(
                                      text: 'Mã đơn: ',
                                      style: _theme.textTheme.display1,
                                    ),
                                    TextSpan(
                                      text: '#' + item.orderCode,
                                      style: _theme.textTheme.display1.copyWith(
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ])),
                                  Text(DateFormat('dd-MM-yyyy').format(item.orderDate),
                                      style: _theme.textTheme.display3
                                          .copyWith(color: AppColors.lightGray))
                                ],
                              ),
                              SizedBox(
                                height: AppSizes.sidePadding,
                              ),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    RichText(
                                        text: TextSpan(children: <TextSpan>[
                                      TextSpan(
                                        text: 'Số theo dõi: ',
                                        style: _theme.textTheme.display1
                                            .copyWith(
                                                color:
                                                    _theme.primaryColorLight),
                                      ),
                                      TextSpan(
                                        text: item.orderCode,
                                        style: _theme.textTheme.display1,
                                      ),
                                    ])),
                                    Text(
                                        item.orderStatus ??
                                            '', //orderStatus.toString().split('.')[1],
                                        style: _theme.textTheme.display1
                                            .copyWith(color: AppColors.green)),
                                  ]),
                              SizedBox(
                                height: AppSizes.sidePadding,
                              ),
                              buildSummaryLine(
                                  'Tổng tiền:',
                                  NumberFormat.currency(
                                          locale: AppSettings.locale)
                                      .format(item.totalMoney),
                                  //'\$' + state.orderData.totalPrice.toStringAsFixed(0),
                                  _theme,
                                  width),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return LoadingView();
        }
      },
    );
  }

  Widget buildOrderListComplete() {
    var _theme = Theme.of(context);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    DateTime now = new DateTime.now();
    return FutureBuilder(
      future: client.postPurchaseOrderData(2,DateFormat('yyyy-MM-dd').format(now).toString()),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          List<PurchaseOrderList> purchaseList = snapshot.data;
          return ListView.builder(
            primary: false,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: purchaseList.length,
            itemBuilder: (BuildContext context, int index) {
              final item = purchaseList[index];

              // final f = new DateFormat('dd-MM-yyyy');
              // final time = f.format(DateTime.parse(item.orderCode));
              
              return Padding(
                padding: const EdgeInsets.only(top: 15),
                child: SingleChildScrollView(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                    context, MaterialPageRoute(builder: (context) => MyOrderDetailsView(customerID: item,)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        height: height / 5.5,
                        child: Material(
                          elevation: 14.0,
                          borderRadius: BorderRadius.circular(15),
                          shadowColor: Color(0x802196F3),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, top: 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    RichText(
                                        text: TextSpan(children: <TextSpan>[
                                      TextSpan(
                                        text: 'Mã đơn: ',
                                        style: _theme.textTheme.display1,
                                      ),
                                      TextSpan(
                                        text: '#' + item.orderCode,
                                        style: _theme.textTheme.display1.copyWith(
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ])),
                                    Text(DateFormat('dd-MM-yyyy').format(item.orderDate),
                                        style: _theme.textTheme.display3
                                            .copyWith(color: AppColors.lightGray))
                                  ],
                                ),
                                SizedBox(
                                  height: AppSizes.sidePadding,
                                ),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      RichText(
                                          text: TextSpan(children: <TextSpan>[
                                        TextSpan(
                                          text: 'Số theo dõi: ',
                                          style: _theme.textTheme.display1
                                              .copyWith(
                                                  color:
                                                      _theme.primaryColorLight),
                                        ),
                                        TextSpan(
                                          text: item.orderCode,
                                          style: _theme.textTheme.display1,
                                        ),
                                      ])),
                                      Text(
                                          item.orderStatus ??
                                              '', //orderStatus.toString().split('.')[1],
                                          style: _theme.textTheme.display1
                                              .copyWith(color: AppColors.green)),
                                    ]),
                                SizedBox(
                                  height: AppSizes.sidePadding,
                                ),
                                buildSummaryLine(
                                    'Tổng tiền:',
                                    NumberFormat.currency(
                                            locale: AppSettings.locale)
                                        .format(item.totalMoney),
                                    //'\$' + state.orderData.totalPrice.toStringAsFixed(0),
                                    _theme,
                                    width),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return LoadingView();
        }
      },
    );
  }

  Widget buildOrderListCancelled() {
    return Container();
  }

  Row buildSummaryLine(
      String label, String text, ThemeData _theme, double width) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            label,
            style: _theme.textTheme.display1
                .copyWith(color: _theme.primaryColorLight),
          ),
          Container(
            child: Text(
              text,
              style: _theme.textTheme.display1,
            ),
          )
        ]);
  }
}
