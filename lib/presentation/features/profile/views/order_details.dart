import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hosco/config/storage.dart';
import 'package:hosco/data/local/order/api_service_point.dart';
import 'package:hosco/data/model/orderDetail/detail.dart';
import 'package:hosco/data/model/orderDetail/purchaseorder_detail.dart';
import 'package:hosco/data/model/purchase_order.dart';
import 'package:hosco/presentation/widgets/independent/loading_view.dart';
import 'package:intl/intl.dart';
import 'package:hosco/config/app_settings.dart';
import 'package:hosco/config/theme.dart';
import 'package:hosco/data/model/cart_item.dart';
import 'package:hosco/presentation/widgets/data_driven/cart_tile.dart';
import 'package:hosco/presentation/widgets/widgets.dart';

import '../../wrapper.dart';
import '../profile.dart';
import '../profile_bloc.dart';
import '../profile_state.dart';
import 'package:http/http.dart' as http;

 
class MyOrderDetailsView extends StatelessWidget {
  final PurchaseOrderList customerID;
  const MyOrderDetailsView({Key key, this.customerID}) : super(key: key);

  final url =
      'http://api.phanmembanhang.com/api/PurchaseOrder/GetPurchaseOrderDetail/';
  Future<GetPurchaseOrderDetail> getDataDetail() async {
    var response = await http.get(
      url+customerID.id,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + Storage().token
      },
    );
    if (response.statusCode == 200) {
      var body = json.decode(response.body)['data'];
      print(body);
      return GetPurchaseOrderDetail.fromJson(body);
    } else {
      throw ("Can't get the Detail");
    }
  }



  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết đơn hàng',
            style: TextStyle(
              color: Colors.white,
            )),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Container(
        child: FutureBuilder<GetPurchaseOrderDetail>(
          future: getDataDetail(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final detail = snapshot.data;
              List<OrderDetail> detailpurchase = detail.orderDetail;

              return Padding(
                padding: EdgeInsets.all(AppSizes.sidePadding),
                child: SingleChildScrollView(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        RichText(
                            text: TextSpan(children: <TextSpan>[
                          TextSpan(
                            text: 'Mã đơn: ',
                            style: _theme.textTheme.display1,
                          ),
                          TextSpan(
                            text: '#' + detail.orderCode,
                            style: _theme.textTheme.display1
                                .copyWith(fontWeight: FontWeight.w700),
                          ),
                        ])),
                        Text(DateFormat('dd-MM-yyyy').format(detail.orderDate),
                            style: _theme.textTheme.display3
                                .copyWith(color: AppColors.lightGray))
                      ],
                    ),
                    SizedBox(
                      height: AppSizes.sidePadding,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          RichText(
                              text: TextSpan(children: <TextSpan>[
                            TextSpan(
                              text: 'Số theo dõi: ',
                              style: _theme.textTheme.display1,
                            ),
                            TextSpan(
                              text: '${detail.orderCode}',
                              style: _theme.textTheme.display1,
                            ),
                          ])),
                          Text(
                              detail.statusText ??
                                  '', //orderStatus.toString().split('.')[1],
                              style: _theme.textTheme.display1
                                  .copyWith(color: AppColors.green)),
                        ]),
                    SizedBox(
                      height: AppSizes.sidePadding,
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: <Widget>[
                    //     Row(
                    //       children: <Widget>[
                    //         Text(
                    //           state.orderData.totalQuantity.toString(),
                    //           style: _theme.textTheme.display1,
                    //         ),
                    //         Padding(
                    //           padding: const EdgeInsets.only(
                    //               left: AppSizes.linePadding),
                    //           child: Text(
                    //             'sản phẩm',
                    //             style: _theme.textTheme.display1,
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ],
                    // ),
                    SizedBox(
                      height: AppSizes.sidePadding,
                    ),
                    
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Chi tiết hóa đơn',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16),),
                        SizedBox(height: 8.0,),
                        Container(
                          height: 300,
                          child: ListView.builder(
                              primary: false,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: detailpurchase.length,
                              itemBuilder: (BuildContext context, int index) {
                                final item = detailpurchase[index];
                                return SizedBox(
                                  child: SingleChildScrollView(
                                    child: Padding(
                                      padding: EdgeInsets.only(bottom: 15.0),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: AppSizes.linePadding * 2),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                AppSizes.imageRadius),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: AppColors.lightGray
                                                      .withOpacity(0.3),
                                                  blurRadius: AppSizes.imageRadius,
                                                  offset: Offset(
                                                      0.0, AppSizes.imageRadius))
                                            ],
                                            color: AppColors.white),
                                        child: Stack(
                                          children: [
                                            Row(
                                              children: <Widget>[
                                                // Container(
                                                //     width: 100,
                                                //     child: widget.item.product.mainImage
                                                //             .isLocal
                                                //         ? Image.asset(widget.item
                                                //             .product.mainImage.address)
                                                //         : Image.network(
                                                //             widget.item.product
                                                //                 .mainImage.address,
                                                //             height: 100.0,
                                                //           )),
                                                Container(
                                                    padding: EdgeInsets.only(
                                                        left: AppSizes.sidePadding),
                                                    width: width - 50,
                                                    child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: <Widget>[
                                                                Container(
                                                                  width:
                                                                      width - 100,
                                                                  child: Text(
                                                                      item
                                                                          .productName,
                                                                      style: _theme
                                                                          .textTheme
                                                                          .display1
                                                                          .copyWith(
                                                                              fontSize:
                                                                                  18,
                                                                              fontWeight: FontWeight
                                                                                  .bold,
                                                                              color:
                                                                                  _theme.primaryColor)),
                                                                ),
                                                              ]),
                                                          Padding(
                                                            padding: EdgeInsets.only(
                                                                bottom: AppSizes
                                                                        .linePadding *
                                                                    2),
                                                          ),
                                                          Container(
                                                            width: width,
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                                NumberFormat.currency(
                                                                        locale: AppSettings
                                                                            .locale,
                                                                        symbol: 'đ')
                                                                    .format(
                                                                        item.price),
                                                                style: _theme
                                                                    .textTheme
                                                                    .headline6
                                                                    .copyWith(
                                                                        fontSize:
                                                                            16.0)),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.only(
                                                                bottom: AppSizes
                                                                        .linePadding *
                                                                    2),
                                                          ),
                                                          Row(children: <Widget>[
                                                            item.qty != null
                                                                ? Container(
                                                                    width: 120,
                                                                    child: Row(
                                                                      children: <
                                                                          Widget>[
                                                                        Container(
                                                                            alignment:
                                                                                Alignment
                                                                                    .center,
                                                                            width:
                                                                                36,
                                                                            height:
                                                                                36,
                                                                            decoration: BoxDecoration(
                                                                                color: AppColors
                                                                                    .white,
                                                                                borderRadius: BorderRadius.circular(
                                                                                    18),
                                                                                boxShadow: [
                                                                                  BoxShadow(color: AppColors.lightGray.withOpacity(0.3), blurRadius: AppSizes.imageRadius, offset: Offset(0.0, AppSizes.imageRadius))
                                                                                ]),
                                                                            child: Icon(
                                                                                Icons.remove)),
                                                                        Container(
                                                                          alignment:
                                                                              Alignment
                                                                                  .center,
                                                                          padding: EdgeInsets.all(
                                                                              AppSizes.linePadding *
                                                                                  2),
                                                                          child: Text(
                                                                              item.qty
                                                                                  .toString(),
                                                                              style: _theme
                                                                                  .textTheme
                                                                                  .display1),
                                                                        ),
                                                                        Container(
                                                                            alignment:
                                                                                Alignment
                                                                                    .center,
                                                                            width:
                                                                                36,
                                                                            height:
                                                                                36,
                                                                            decoration: BoxDecoration(
                                                                                color: AppColors
                                                                                    .white,
                                                                                borderRadius: BorderRadius.circular(
                                                                                    18),
                                                                                boxShadow: [
                                                                                  BoxShadow(color: AppColors.lightGray.withOpacity(0.3), blurRadius: AppSizes.imageRadius, offset: Offset(0.0, AppSizes.imageRadius))
                                                                                ]),
                                                                            child: Icon(
                                                                                Icons.add)),
                                                                      ],
                                                                    ),
                                                                  )
                                                                : Container(
                                                                    width: 110,
                                                                    child: Row(
                                                                        children: <
                                                                            Widget>[
                                                                          Text(
                                                                              'Units: ',
                                                                              style: _theme
                                                                                  .textTheme
                                                                                  .body1),
                                                                          Text(
                                                                              item.unit
                                                                                  .toString(),
                                                                              style: _theme
                                                                                  .textTheme
                                                                                  .body1
                                                                                  .copyWith(color: _theme.primaryColor)),
                                                                        ])),
                                                            // Container(
                                                            //   width: width - 280,
                                                            //   alignment:
                                                            //       Alignment.bottomRight,
                                                            //   child: Container(
                                                            //       alignment:
                                                            //           Alignment
                                                            //               .center,
                                                            //       width: 36,
                                                            //       height: 36,
                                                            //       decoration: BoxDecoration(
                                                            //           color:
                                                            //               AppColors
                                                            //                   .white,
                                                            //           borderRadius:
                                                            //               BorderRadius
                                                            //                   .circular(
                                                            //                       18),
                                                            //           boxShadow: [
                                                            //             BoxShadow(
                                                            //                 color: AppColors
                                                            //                     .lightGray
                                                            //                     .withOpacity(
                                                            //                         0.3),
                                                            //                 blurRadius:
                                                            //                     AppSizes
                                                            //                         .imageRadius,
                                                            //                 offset: Offset(
                                                            //                     0.0,
                                                            //                     AppSizes.imageRadius))
                                                            //           ]),
                                                            //       child: Icon(
                                                            //         Icons.delete,
                                                            //         color:
                                                            //             Colors.red,
                                                            //       )),
                                                            // ),
                                                          ])
                                                        ]))
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: AppSizes.sidePadding,
                    ),
                    Container(
                      child: Material(
                        elevation: 3.0,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        shadowColor: Color(0x802196F3),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Thông tin người nhận hàng',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(Icons.supervised_user_circle),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        detail.employeeName ?? '',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.phone),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(detail.customerPhone ?? '',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Text('Địa chỉ',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  Text(detail.customerAddress ?? '',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    Container(
                      child: Material(
                        elevation: 4.0,
                        borderRadius: BorderRadius.circular(15),
                        shadowColor: Color(0x802196F3),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Tạm tính:',
                                    style: _theme.textTheme.display1.copyWith(
                                        color: _theme.primaryColorLight,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Container(
                                    child: Text(
                                      NumberFormat.currency(
                                              locale: AppSettings.locale)
                                          .format(detail.orderTotal),
                                      style: _theme.textTheme.display1.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Ưu đãi:',
                                    style: _theme.textTheme.display1.copyWith(
                                        color: _theme.primaryColorLight,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Container(
                                    child: Text(
                                      NumberFormat.currency(
                                              locale: AppSettings.locale)
                                          .format(detail.fDiscount),
                                      style: _theme.textTheme.display1.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Tổng tiền phải trả:',
                                    style: _theme.textTheme.display1.copyWith(
                                        color: _theme.primaryColorLight,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Container(
                                    child: Text(
                                      NumberFormat.currency(
                                              locale: AppSettings.locale)
                                          .format(detail.orderTotalDiscount),
                                      style: _theme.textTheme.display1.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: AppSizes.sidePadding,
                    ),
                  ],
                )),
              );
            } else {
              return Center(
                child: LoadingView(),
              );
            }
          },
        ),
      ),
    );
  }
}
  

