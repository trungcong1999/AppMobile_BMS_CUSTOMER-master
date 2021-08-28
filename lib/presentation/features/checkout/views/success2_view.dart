// Checkout Success View Screen #2
// Author: openflutterproject@gmail.com
// Date: 2020-02-17

import 'package:flutter/material.dart';
import 'package:hosco/config/routes.dart';
import 'package:hosco/config/theme.dart';
import 'package:hosco/presentation/widgets/widgets.dart';

import '../../wrapper.dart';

class Success2View extends StatefulWidget {
  final Function changeView;

  const Success2View({Key key, this.changeView}) : super(key: key);

  @override
  _Success2ViewState createState() => _Success2ViewState();
}

class _Success2ViewState extends State<Success2View> {
  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);
    return Container(
        padding: EdgeInsets.symmetric(horizontal: AppSizes.sidePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(top: AppSizes.sidePadding * 5),
                child: Image.asset('assets/images/checkout/bags.png')),
            Padding(
              padding: EdgeInsets.only(
                top: AppSizes.sidePadding * 3,
                left: AppSizes.sidePadding * 2,
                right: AppSizes.sidePadding * 2,
              ),
              child: Text('Thành công!', style: _theme.textTheme.caption),
            ),
            Padding(
                padding: EdgeInsets.all(AppSizes.sidePadding * 2),
                child: Text(
                    'Đơn hàng của bạn sẽ được giao sớm. Cảm ơn bạn đã chọn ứng dụng của chúng tôi!',
                    style: _theme.textTheme.display1)),
            OpenFlutterButton(
              title: 'TIẾP TỤC MUA HÀNG',
              onPressed: (() {
                    Navigator.pushNamed(context, hoscoRoutes.home);
                    // widget.changeView(
                    //     changeType: ViewChangeType.Exact, index: 0);
                  }),
            ),
          ],
        ));
  }
}
