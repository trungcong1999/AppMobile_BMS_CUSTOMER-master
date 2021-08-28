import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hosco/config/app_settings.dart';
import 'package:hosco/config/theme.dart';
import 'package:hosco/data/model/user_order.dart';

class OpenFlutterOrderTile extends StatelessWidget {
  final UserOrder order;
  final Function(String) onClick;

  const OpenFlutterOrderTile(
      {Key key, @required this.order, @required this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);
    return Container(
        padding: EdgeInsets.all(AppSizes.imageRadius),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: _theme.primaryColor.withOpacity(0.3),
                blurRadius: AppSizes.imageRadius,
              )
            ],
            borderRadius: BorderRadius.circular(AppSizes.imageRadius),
            color: AppColors.white,
          ),
          child: Padding(
            padding: EdgeInsets.all(AppSizes.sidePadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    RichText(
                        text: TextSpan(children: <TextSpan>[
                      TextSpan(
                        text: 'Mã đơn: ',
                        style: _theme.textTheme.display1.copyWith(
                            color: _theme.primaryColorLight,
                            fontWeight: FontWeight.normal),
                      ),
                      TextSpan(
                        text: '#' + order.orderNumber.toString(),
                        style: _theme.textTheme.display1
                            .copyWith(fontWeight: FontWeight.w700),
                      ),
                    ])),
                    Text(DateFormat('dd-MM-yyyy').format(order.orderDate),
                        style: _theme.textTheme.display3
                            .copyWith(color: AppColors.red))
                  ],
                ),
                SizedBox(
                  height: AppSizes.linePadding,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          'Số theo dõi: ',
                          style: _theme.textTheme.display1
                              .copyWith(color: _theme.primaryColorLight),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: AppSizes.sidePadding),
                          child: Text(
                            order.trackingNumber,
                            style: _theme.textTheme.display1,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: AppSizes.sidePadding,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        /*
                        Row(
                          children: <Widget>[
                            Text(
                              'Số lượng:',
                              style: _theme.textTheme.display1
                                  .copyWith(color: _theme.primaryColorLight),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: AppSizes.linePadding),
                              child: Text(
                                order.totalQuantity.toString(),
                                style: _theme.textTheme.display1,
                              ),
                            ),
                          ],
                        ),*/
                        Row(
                          children: <Widget>[
                            Text(
                              'Tổng tiền:',
                              style: _theme.textTheme.display1
                                  .copyWith(color: _theme.primaryColorLight),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: AppSizes.sidePadding),
                              child: Text(
                                  NumberFormat.currency(locale: AppSettings.locale).format(order.totalMoney), //TODO: order.totalPrice,
                                //total amount
                                style: _theme.textTheme.display1,
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: AppSizes.linePadding,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    RaisedButton(
                      padding: EdgeInsets.only(
                          left: 24, right: 24, top: 10, bottom: 10),
                      color: AppColors.white,
                      onPressed: () {
                        onClick(order.id);
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppSizes.imageRadius),
                          side: BorderSide(color: AppColors.black, width: 2)),
                      child: Text(
                        'Chi tiết',
                        style: _theme.textTheme.display1,
                      ),
                    ),
                    Text(order.statusText??'',//orderStatus.toString().split('.')[1],
                        style: _theme.textTheme.display1
                            .copyWith(color: AppColors.green)),
                  ],
                )
              ],
            ),
          ),
        ));
  }

  String getOrderStatusString() {
    var str = 'New';
    switch (order.orderStatus) {
      case UserOrderStatus.Paid:
        str = 'Paid';
        break;
      case UserOrderStatus.Sent:
        str = 'Sent';
        break;
      case UserOrderStatus.Delivered:
        str = 'Delivered';
        break;
      case UserOrderStatus.New:
      default:
        break;
    }
    return str;
  }
}
