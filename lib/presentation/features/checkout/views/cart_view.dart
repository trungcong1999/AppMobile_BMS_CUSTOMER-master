// Checkout Cart View Screen
// Author: openflutterproject@gmail.com
// Date: 2020-02-17

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:hosco/config/app_settings.dart';
import 'package:hosco/config/storage.dart';
import 'package:hosco/config/theme.dart';
import 'package:hosco/data/repositories/cart_repository_impl.dart';
import 'package:hosco/presentation/widgets/independent/action_card.dart';
import 'package:hosco/presentation/widgets/independent/delivery_method.dart';
import 'package:hosco/presentation/widgets/independent/payment_card.dart';
import 'package:hosco/presentation/widgets/independent/summary_line.dart';
import 'package:hosco/presentation/widgets/widgets.dart';

import '../../wrapper.dart';
import '../checkout.dart';

class CartView extends StatefulWidget {
  final Function changeView;

  const CartView({Key key, this.changeView}) : super(key: key);

  @override
  _CartViewState createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  @override
  void initState() {
    _fullNameController.text = Storage().account.name;
    _addressController.text = Storage().account.address;
    _mobileController.text = Storage().account.mobile;
    super.initState();
  }

  @override
  void dispose() {
    _fullNameController?.dispose();
    _addressController?.dispose();
    _mobileController?.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CheckoutBloc>(context);
    var _theme = Theme.of(context);
    var width = MediaQuery.of(context).size.width - AppSizes.sidePadding * 2;
    return BlocListener(
        cubit: bloc,
        listener: (context, state) {
          if (state is CheckoutErrorState) {
            return Container(
                padding: EdgeInsets.all(AppSizes.sidePadding),
                child: Text('Đã có lỗi xảy ra. Kiểm tra tín hiệu mạng...',
                    style: _theme.textTheme.display1
                        .copyWith(color: _theme.errorColor)));
          }
          return Container();
        },
        child: BlocBuilder(
            cubit: bloc,
            builder: (BuildContext context, CheckoutState state) {
              if(state is CheckoutProceededState) {
                if(state.isSentOrder) {
                  CartRepositoryImpl.cartProductDataStorage = CartProductDataStorage();
                  widget.changeView(
                      changeType: ViewChangeType.Exact, index: 5);
                } else {
                  showAlertDialog(context, state.isSentOrder, 'Thông báo', 'Hệ thống đang nâng cấp. Vui lòng thử lại sau...');
                }
              }

              if (state is CheckoutProceedState) {
                return SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: AppSizes.sidePadding),
                    ),
                    OpenFlutterSummaryLine(title: 'Thông tin khách hàng', summary: '',),
                    Padding(
                      padding: EdgeInsets.only(bottom: AppSizes.sidePadding),
                    ),
                    OpenFlutterInputField(
                      controller: _fullNameController,
                      hint: 'Họ tên',
                      onValueChanged: (value) => {},
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: AppSizes.sidePadding),
                    ),
                    OpenFlutterInputField(
                      controller: _addressController,
                      hint: 'Địa chỉ',
                      onValueChanged: (value) => {},
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: AppSizes.sidePadding),
                    ),
                    OpenFlutterInputField(
                      controller: _mobileController,
                      hint: 'Điện thoại',
                      onValueChanged: (value) => {},
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: AppSizes.sidePadding),
                    ),
                    OpenFlutterInputField(
                      controller: _descController,
                      hint: 'Ghi chú đặt hàng',
                      onValueChanged: (value) => {},
                    ),
                    /*
                    OpenFlutterBlockSubtitle(
                        title: 'Shipping Address', width: width),
                    OpenFlutterActionCard(
                        title: state.currentShippingAddress.fullName,
                        linkText: 'Change',
                        onLinkTap: (() => {
                            widget.changeView(
                              changeType: ViewChangeType.Exact, index: 2)
                          }),
                        child: RichText(
                          text: TextSpan(
                            text: state.currentShippingAddress.toString(),
                            style: _theme.textTheme.display3
                              .copyWith(color: _theme.primaryColor)),
                          maxLines: 2,
                        )),
                    OpenFlutterBlockSubtitle(
                      title: 'Payment',
                      width: width,
                      linkText: 'Change',
                      onLinkTap: (() => {
                        widget.changeView(changeType: ViewChangeType.Forward)
                      }),
                    ),
                    OpenFlutterPaymentCard(
                      cardNumber: state.currentPaymentMethod.toString(),
                    ),
                    OpenFlutterBlockSubtitle(
                      title: 'Delivery Method',
                      width: width,
                      /*linkText: 'Change',
                      onLinkTap: (() => {}),*/
                    ),
                    OpenFlutterDeliveryMethod(),
                     */
                    Padding(
                        padding: EdgeInsets.only(top: AppSizes.sidePadding * 3)),
                    OpenFlutterSummaryLine(title: 'Tổng tiền hàng', summary: NumberFormat.currency(locale: AppSettings.locale, symbol: 'đ').format(state.orderPrice)), //.toStringAsFixed(2)),
                    Padding(padding: EdgeInsets.only(top: AppSizes.sidePadding)),
                    OpenFlutterSummaryLine(title: 'Phí vận chuyển', summary: NumberFormat.currency(locale: AppSettings.locale, symbol: 'đ').format(state.deliveryPrice)), //.toStringAsFixed(2)),
                    Padding(padding: EdgeInsets.only(top: AppSizes.sidePadding)),
                    OpenFlutterSummaryLine(title: 'Thành tiền', summary: NumberFormat.currency(locale: AppSettings.locale, symbol: 'đ').format(state.summaryPrice)), //.toStringAsFixed(2)),
                    Padding(padding: EdgeInsets.only(top: AppSizes.sidePadding)),
                    OpenFlutterButton(
                      title: 'ĐẶT HÀNG',
                      onPressed: () async {
                        bloc.add(SendOrderCardEvent(state.deliveryPrice, _fullNameController.value.text,
                            _addressController.value.text, _mobileController.value.text,
                            _descController.value.text
                        ));
                        await Future.delayed(Duration.zero);
                      },
                      icon: Icons.send,
                    )
                  ],
                ));
              }
              return Container();
            }));
  }

  void showAlertDialog(BuildContext context, bool isSent, String title, String content) {
    var _theme = Theme.of(context);
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text('Đóng'),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text('Tiếp tục mua hàng'),
      onPressed:  () {

      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(content, style: _theme.textTheme.display3),
      actions: [
        cancelButton,
        isSent ? continueButton : Container(),
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
